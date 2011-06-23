<?php
class Model_Image
{
	/**
	 * Идентификатор ресурса
	 * @var int
	 */
	private $_myimg;
	
	/**
	 * Тип (расширение)
	 * @var string
	 */
	private $_ext;
	
	/**
	 * Ширина фотографии
	 * @var int
	 */
	private $_width;
	
	/**
	 * Высота фотографии
	 * @var int
	 */
	private $_height;
	
	/**
	 * Массив опций для сохраняемых файлов
	 * @var array
	 */
	private $_config;
	
	/**
	 * Папка с фотографиями
	 * @var string
	 */
	private $_path;
	
	/**
	 * Конструктор
	 * @param string $path путь к папке
	 * @param array $config конфиг с настройками
	 * @return void
	 */
	function __construct($path = "public/catalog/", $config = false)
	{
		if ( ! file_exists( $this->getPath( $path ) ) ){
				throw new Model_Exception( 'Папки с фотографиями  не существует' );
		}
		/*
		 * Проверяем, пришел-ли нам config. Если нет, то будем создавать файлы везде, где они только смогут потребоваться.
		 * Подход деструктивный, но уж как-то так.
		 */
		if ( $config )
		{
			$this->_path = $this->getPath( $path ).'/';
			$this->_config = $config;
		} else /**/
		{
			$path = 'public/';
			$this->_path = $this->getPath( $path ).'/';
			$reg = Zend_Registry::getInstance();
			$this->_config = array(
				"catalog/big" => array( "size"=>$reg->get( 'catalog_big_size' ), "quality"=>100, "square" => $reg->get( 'square_big_active' ) ),
				"catalog/medium" => array( "size"=>$reg->get( 'catalog_medium_size' ), "quality"=>80, "square" => $reg->get( 'square_medium_active' )),
				"catalog/small" => array( "size"=>$reg->get( 'catalog_small_size' ), "quality"=>80, "square" => $reg->get( 'square_small_active' ) ),
				"catalog/kategory" => array( "size"=>$reg->get( 'catalog_kategory_size' ), "quality"=>80, "square" => $reg->get( 'square_kategory_active' )),
				"catalog/backend" => array( "size"=>75, "square"=>true ), // картинка для админки

				"shop/big" => array( "size"=>$reg->get( 'catalog_big_size' ), "quality"=>100, "square" => $reg->get( 'square_big_active' ) ),
				"shop/medium" => array( "size"=>$reg->get( 'catalog_medium_size' ), "quality"=>80, "square" => $reg->get( 'square_medium_active' )),
				"shop/small" => array( "size"=>$reg->get( 'catalog_small_size' ), "quality"=>80, "square" => $reg->get( 'square_small_active' ) ),
				"shop/kategory" => array( "size"=>$reg->get( 'catalog_kategory_size' ), "quality"=>80, "square" => $reg->get( 'square_kategory_active' )),
				"shop/backend" => array( "size"=>75, "square"=>true ), // картинка для админки

				"gallery/big" => array( "size"=>$reg->get( 'gallery_big_size' ), "quality"=>100, "square" => $reg->get( 'square_big_active' ) ),
				"gallery/medium" => array( "size"=>$reg->get( 'gallery_medium_size' ), "quality"=>80, "square" => $reg->get( 'square_medium_active' )),
				"gallery/small" => array( "size"=>$reg->get( 'gallery_small_size' ), "quality"=>80, "square" => $reg->get( 'square_small_active' ) ),
				"gallery/kategory" => array( "size"=>$reg->get( 'gallery_kategory_size' ), "quality"=>80, "square" => $reg->get( 'square_kategory_active' )),
				"gallery/backend" => array( "size"=>75, "square"=>true ), // картинка для админки
			);
		}
	}
	/**
	 * Резайзить фотографию под заданные размеры
	 * @param string $fileinputname имя файла в глобальном массиве $_FILES
	 * @return string
	 */
	public function LoadImages($fileinputname='photo')
	{
		$tmp = $_FILES[$fileinputname]['tmp_name'] ; // Проверяем, принят ли файл.
		if (@file_exists($tmp))
		{
			$info = @getimagesize($_FILES[$fileinputname]['tmp_name']); // Проверяем, является ли файл изображением.
			$this->_width = $info[0];
			$this->_height = $info[1];

			$p = array();

			if (preg_match('{image/(.*)}is', $info['mime'], $p))
			{	
				$this->_ext = $p[1];

				// Генерируем имя картинки
				$randarray = array('a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q');
				$ri = rand(1,16);
				$ri2 = rand(1,16);
				$namehead = time().$randarray[$ri].$randarray[$ri2];
				$name = $namehead.".".$this->_ext;

				// Папка для загрузки исходного изображения
				$upload_dir = rtrim($this->_path, "/");
				/*if (!file_exists($upload_dir)){
					mkdir($upload_dir, 0777);}*/
				//reset($this->config);
				//$moveitto = $this->path.key($this->config)."/".$name;
				$moveitto = $this->_path."/".$name;
				// Добавляем файл в каталог с фотографиями.
				if(move_uploaded_file($tmp, $moveitto))
				{
					switch($this->_ext)
					{
						case "jpeg":	$this->_myimg = imageCreateFromJpeg($moveitto);    break;
						case "gif" :	$this->_myimg = imageCreateFromGif($moveitto);     break;
						case "png" :	$this->_myimg = imageCreateFromPng($moveitto);     break;
					}
					unlink($moveitto);

					foreach($this->_config as $k=>$c)
					{
						$this->Output($k, $name);
					}

				//	if ($backendpic) $this->Output("backend", $name);

					return $name;
				}
				else
				{
					//echo "Ошибка загрузки файла!";
					return false;
				}
			}
			else
			{
				//echo "Попытка добавить файл недопустимого формата!";
				return false;
			}
		}

		return false;
	}
	
	/**
	 * Фотография после ресайза
	 * @param array $conf массив настроек для ресайза фотографии( размер, имя папки для сохранения )
	 * @param string $filename имя сохраняемого файла
	 * @return string
	 */
	private function Output($conf, $filename)
	{	
		if (isset($this->_myimg) and isset($this->_config[$conf]["size"]))
			$imsize = $this->_config[$conf]["size"];
		else
			return false;
		if (isset($this->_config[$conf]["square"]))
			$square = $this->_config[$conf]["square"];
		else
			$square = false;

		if (isset($this->_config[$conf]["quality"]))
			$quality = $this->_config[$conf]["quality"];

		// ресайз
		if ($square)
			$resized = $this->resizeSquared($imsize);
		else
			$resized = $this->resizeLim($imsize);

		$result = false;
		if ($resized)
		{
			// папки для загрузки изображений
			if (!file_exists($this->_path.$conf)) {
				if(!mkdir($this->_path.$conf, 0644))
					throw new Model_Exception( 'Создать директорию '.$this->_path.$conf.' не удалось' );
			}
			// сохраняемый файл
			$file = $this->_path.$conf."/".$filename;

			switch($this->_ext)
			{
				case "jpeg":
					if (isset($quality))
						$result = imageJpeg($resized, $file, $quality);
					else
						$result = imageJpeg($resized, $file);
					break;
				case "gif":
					$result = imageGif($resized, $file);
					break;
				case "png":
					$result = imagePng($resized, $file);
					break;
			}
		}
		return $result;
	}
	
	/**
	 * Изменяет размер изображения чтобы оно вписывалось в квадрат со стороной $a
	 * @param int $a размер стороны квадрата
	 * @return string
	 */
	
	private function resizeLim($a)
	{
		$image = $this->_myimg;

		$prop = $this->_width/$this->_height;

		if ($prop>1) // если горизонтальная картинка ..
		{			// максимальное измерение получается $this->_width

			if($this->_width<=$a) { return $image; } // если картинка меньше чем нужно - возвращаем как есть

			$newwidth = $a; // ширина очевидно равна стороне квадрата

			// теперь подсчитаем, чему должна быть равна высота
			// она должна быть меньше ширины в $prop раз

			$newheight = $newwidth/$prop;
		}

		if ($prop<1) // если вертикальная картинка ..
		{			// максимальное измерение получается $this->width

			if($this->_height<=$a) { return $image; } // если высота картинки меньше чем нужно - возвращаем как есть, что делать =)

			$newheight = $a; // высота равна стороне квадрата

			// теперь подсчитаем, чему должна быть равна ширина
			// она должна быть меньше ширины в $prop раз

			$newwidth = $newheight*$prop;
		}

		if ($prop==1) // если квадратная картинка ..
		{
			if($this->_height<=$a) { return $image; } // если высота картинки меньше чем нужно - возвращаем как есть

			$newheight = $a;
			$newwidth = $a;
		}

		$resized = imageCreateTrueColor($newwidth,$newheight);

		if ($resized and
			imageCopyResampled($resized,$image,0,0,0,0,$newwidth,$newheight,$this->_width,$this->_height))
			return $resized;
		else
			return false;

	}
	
	/**
	 * Вырезает из фотографии максимальный квадрат со стороной $a
	 * @param int $a размер стороны квадрата
	 * @return string
	 */
	private function resizeSquared($a)
	{
		$image = $this->_myimg;

		$prop = $this->_width/$this->_height;
		if ($prop>1)  // горизонтальная
		{
			$xstart=(abs($this->_width-$this->_height))/2;
			$ystart=0;
		}
		if ($prop<1)  // вертикальная
		{
			$ystart=(abs($this->_width-$this->_height))/2;
			$xstart=0;
		}
		if ($prop==1) // квадрат
		{
			$xstart=0;
			$ystart=0;
		}

		$resized = imageCreateTrueColor($a,$a);

		if ($resized and
			imageCopyResampled($resized,$image,0,0,$xstart,$ystart,$a,$a,$this->_width-$xstart*2,$this->_height-$ystart*2))
			return $resized;
		else
			return false;
	}
	
	/**
	 * Путь к папке с фотографиями
	 * @param string $path путь к папке
	 * @return string
	 */
	public function getPath( $path ){
		return 
			realpath( APPLICATION_PATH . '/../' .$path );
	}
}
