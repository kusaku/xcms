<?php
/**
 * 
 * Контроллер лент новостей
 * 
 * @category   Xcms
 * @package    News
 * @subpackage Controller
 * @version    $Id: CategoryController.php 254 2010-08-03 13:37:54Z igor $
 */

class News_CategoryController extends Xcms_Controller_Modulefront {
	private $allow_rss = true;

	/**
	 * Просмотр контента
	 * @return void
	 */
	public function viewAction() {
		$this->setDataFrom( $this->getRequest()->getParam('id') );
		$archive = $this->getRequest()->getParam( 'archive' );
		$rss = $this->getRequest()->getParam( 'rss' );
		$category_id = $this->view->element->id;
		$type = Model_Collection_ElementTypes::getInstance()->getModuleElementType('news', 'item');
		if ( isset($type) ) {
			$type_id = $type->id;
		} else {
			throw new Exception( 'Тип данных новости не существует' );
		}
		$category = Model_Collection_Elements::getInstance()->getElement( $category_id );
		$children = $category->getChildren( $type_id, 'publish_date_from DESC' );
		$items = array();
		$container = new Zend_Navigation();
		foreach ( $children as $k => $have ) {
			$element = Model_Collection_Elements::getInstance()
				->getElement ( $k );
			if( $archive == 'archive' ){
				if ( !$element->getValue('publish_arch') ) continue;
			}
			else{
				if ( $element->getValue('publish_arch') ) continue;
			}
			$publish_date = date_create( $element->getValue('publish_date_from') );
			$container->addPage( $element->getPage()
				->set('items', $element->getValues())
			);
		}
		$item_count = (int) Zend_Registry::getInstance()->get('news_items_count');
		if( $item_count <= 0 )
			$item_count = 10;
		$paginator = Zend_Paginator::factory( $container );
		$paginator->setItemCountPerPage($item_count);
		$paginator->setCurrentPageNumber( intval($this->getRequest()->getParam('page')) );
		$this->view->items = $paginator;
		if( $archive == 'archive' ){
			$archive_title = 'Архив Новостей';
			$this->setMeta( $archive_title );
			$this->view->element = (object) array(
				'title_text' => $archive_title,
				'id' => $category_id
			);
			$this->renderContent( 'archive.phtml' );
		}elseif ( ($rss == 'rss') and ($this->allow_rss) ) {
			/**
			 * Самым ужасным способом генерируем XML для RSS канала.
			 * Вынести всё это в шаблон не получилось, т.к. всё обёрнуто в основной шаблон (шапка, подвал).
			 *
			 * Мне стыдно, но как-то так. //Дима.
			 */
				header ("Content-Type:text/xml");
				print '<?xml version="1.0"?>'."\n";
				print '<rss version="2.0">'."\n";
				print '	<channel>'."\n";

				print '	<title>Новости '.$_SERVER['HTTP_HOST'].'</title>'."\n";
				print '	<link>http://'.$_SERVER['HTTP_HOST'].'</link>'."\n";
				print '	<description>Новостная лента с сайта '.$_SERVER['HTTP_HOST'].'.</description>'."\n";

				foreach ($this->view->items as $item){
				if ($item->items['publish_date_from'] > $lastUpdate)
						$lastUpdate = $item->items['publish_date_from'];
				}
				$lastUpdate = date_create($lastUpdate)->format('D, d M Y H:i:s O');
				print '	<lastBuildDate>'.$lastUpdate.'</lastBuildDate>'."\n";

				if (count($this->view->items)){
					foreach ($this->view->items as $item)
					{
						print '	<item>'."\n";
						print '		<title>'.$item->items['name'].'</title>'."\n";
						print '		<link>http://'.$_SERVER['HTTP_HOST'].'/'.$item->items['urlname'].'</link>'."\n";
						print '		<description>'.$item->items['news_preview'].'</description>'."\n";
						print '		<pubDate>'.$item->items['publish_date_from'].'</pubDate>'."\n";
						print '	</item>'."\n";
					}
				}
				print '	</channel>'."\n";
				print '</rss>'."\n";
				die();
			}
		else
			/**
			 * Рендерим основной шаблон для новостей.
			 */
			$this->renderContent( 'category.phtml' );
	}
}
