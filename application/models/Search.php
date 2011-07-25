<?
class Model_Search {
	
	protected static $_instance = NULL;
	protected $index = NULL;
	
	// Конфиг индексатора
	// TODO починить стемминг
	protected $config = array(
		"caseSensitive" => false, // Включить регистро-независимый анализатор
		"stemming" => false, // Использовать русский стеммер для разбора лексем
		"mergeFactor" => 5, // Установить MergeFactor
		"joinStrings" => true, // Склеивать все текстовые поля элемента
		"charset" => 'utf-8', // Кодировка индекса
	);
		
	protected function __construct() {
		try {
			$this->index = Zend_Search_Lucene::open(APPLICATION_PATH.'/../data/search');
		} catch(Exception $e) {
			$this->index = Zend_Search_Lucene::create(APPLICATION_PATH.'/../data/search');
		}
		$this->applyConfig();
		Zend_Search_Lucene::setDefaultSearchField(NULL);
	}
	
	/**
	 * Переконфигурировать индексатор
	 */
	protected function applyConfig() {
		$this->setAnalizer($this->config["caseSensitive"], $this->config["stemming"]);
		$this->setMergeFactor($this->config["mergeFactor"]);
		Zend_Search_Lucene_Search_QueryParser::setDefaultEncoding($this->config["charset"]);
	}
	
	/**
	 * Установить анализатор по умолчанию
	 * @param bool $caseSensitive Использовать регистро-зависимый анализатор
	 * @param bool $stemming Использовать русский стеммер
	 */
	protected function setAnalizer($caseSensitive, $stemming) {
		if($caseSensitive)
			$analyzer = new Zend_Search_Lucene_Analysis_Analyzer_Common_Utf8Num();
		else
			$analyzer = new Zend_Search_Lucene_Analysis_Analyzer_Common_Utf8Num_CaseInsensitive();
			
		if($stemming)
			$analyzer->addFilter(new Model_RussianStemmer());
			
		Zend_Search_Lucene_Analysis_Analyzer::setDefault($analyzer);
	}
	
	/**
	 * Установить MergeFactor
	 * @param int $mf
	 */
	protected function setMergeFactor($mf) {
		$this->index->setMergeFactor($mf);
	}

	
	///////////////////////////////////////////
	// PUBLIC METHODS
	///////////////////////////////////////////
	
	public static function getInstance() {
		if(self::$_instance == NULL)
			self::$_instance = new self;
		return self::$_instance;
	}
	
	/**
	 * Получить значение конфига
	 * @param mix $key
	 */
	public function __get($key) {
		if(isset($this->config[$key]))
			return $this->config[$key];
		return NULL;
	}
	
	/**
	 * Установить значение конфига и переконфигурировать индексатор
	 * @param mix $key
	 * @param mix $value
	 */
	public function __set($key, $value) {
		if(isset($this->config[$key])) {
			$this->config[$key] = $value;
			$this->applyConfig();
		}
	}
	
	/**
	 * Найти в индексе документ с заданным id
	 * @param int $id
	 */
	public function getDocById($id) {
		$term = new Zend_Search_Lucene_Index_Term($id, 'element_id');
		$docIds  = $this->index->termDocs($term);
		if(count($docIds) > 0)
			return $docIds;
		return false;
	}
	
	/**
	 * Проиндексировать элемент
	 * @param $element
	 */
	public function index($element) {
		// При наличии данного элемента в индексе удаляем его
		if(count($this->getDocById($element->id)) > 0)
			$this->delete($element);
		
		$doc = new Zend_Search_Lucene_Document();
		$stringBuffer = '';
		$otype = $element->getObject()->getType()->__toString();
		$fields = $element->getValues(true);
		
		foreach($fields as $name => $value) {
			if(is_array($value)) continue;
			if(is_string($value)) {
				if($this->joinStrings && $name != 'urlname' && $name != 'name')
					$stringBuffer .= $value . " ";
				else
					$doc->addField(Zend_Search_Lucene_Field::text($name, $value, 'utf-8'));
			} else {
				$doc->addField(Zend_Search_Lucene_Field::Keyword($name, $value, 'utf-8'));
			}
		}
		if($stringBuffer !== '')
			$doc->addField(Zend_Search_Lucene_Field::UnStored('contents', $stringBuffer, 'utf-8'));
		$doc->addField(Zend_Search_Lucene_Field::Keyword('element_id', $element->id, 'utf-8'));
		$doc->addField(Zend_Search_Lucene_Field::Keyword('element_type', $otype, 'utf-8'));
		
		$this->index->addDocument($doc);
		$this->index->commit();
		//$this->optimize();
	}
	
	/**
	 * Удалить элемент из индекса
	 * @param $element
	 */
	public function delete($element) {
		if($docs = $this->getDocById($element->id)) {
			foreach($docs as $doc)
				$this->index->delete($doc);
		}
	}
	
	/**
	 * Проиндексировать массив элементов
	 * @param $elements
	 */
	public function massIndex($elements) {
		foreach($elements as $element) {
			$this->index($element);
		}
	}
	
	/**
	 * Удалить поисковый индекс
	 */
	public function deleteIndex() {
		$dh = opendir(APPLICATION_PATH.'/../data/search');
		while (($file = readdir($dh)) !== false) {
			if($file != '.' && $file != '..')
				unlink(APPLICATION_PATH.'/../data/search/'.$file);
		}
		$this->index = Zend_Search_Lucene::create(APPLICATION_PATH.'/../data/search');
	}
	
	/**
	 * Оптимизировать поисковый индекс
	 */
	public function optimize() {
		$this->index->optimize();
	}
	
	/**
	 * Получить размер индекса
	 */
	public function getSize($deleted = false) {
		if($deleted)
			return $this->index->count();
		return $this->index->numDocs();
	}
	
	/**
	 * Сгенерировать объект запроса
	 * @param string $queryString
	 */
	public function buildQuery($queryString) {
		$queryString = strToLower($queryString);
		$words = explode(" ", $queryString);
		if(count($words)>1) {
			$queries = array();
			foreach($words as $word) {
				$queries[]= $word."~";
			}
			$querystr = join(" or ", $queries);
			$userQuery = Zend_Search_Lucene_Search_QueryParser::parse($querystr);
		} else {
			$userQuery = Zend_Search_Lucene_Search_QueryParser::parse($queryString);
		}
		
		$extraTerm  = new Zend_Search_Lucene_Index_Term('0', 'is_deleted');
		$extraQuery = new Zend_Search_Lucene_Search_Query_Term($extraTerm);
		
		$query = new Zend_Search_Lucene_Search_Query_Boolean();
		$query->addSubquery($userQuery, true);
		$query->addSubquery($extraQuery, true);
		
		return $userQuery;
	}
	
	/**
	 * Выполнить поиск в индексе
	 * @param string $queryString
	 */
	public function find($queryString) {
		$query = $this->buildQuery($queryString);
		return $this->index->find($query, 'element_type', SORT_STRING, SORT_DESC);
	}

}