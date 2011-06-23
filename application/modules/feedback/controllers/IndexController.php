<?php
/**
 * 
 * Контроллер
 * 
 * @category   Xcms
 * @package    Feedback
 * @subpackage Controller
 * @version    $Id: IndexController.php 567 2010-11-15 10:02:15Z kifirch $
 */

class Feedback_IndexController extends Xcms_Controller_Modulefront {
	
	/**
	 * Просмотр
	 * @return void
	 */
	public function viewAction() {
			// Параметры полей предопределенных типов
			$fieldsTypes = array(
				"String" => array(
					"type" => "text",
					"validators" => array(),
					"filters" => array('StringTrim', 'StripTags'),
				),
				"Text" => array(
					"type" => "textarea",
					"validators" => array(),
					"filters" => array('StripTags')
				),
				"Email" => array(
					"type" => "text",
					"validators" => array('EmailAddress'),
					"filters" => array('StringTrim')
				)
			);
			
			// Получаем свойства формы
            $this->setDataFrom( $this->getRequest()->getParam('id') );
            $typeId = $this->view->element->feedback_fos_type;
            $needCaptcha = $this->view->element->feedback_fos_captcha;
            $fosmail = $this->view->element->feedback_fos_mails;
            $mco = Model_Collection_Objects::getInstance();
            // Устанавливаем тему сообщения
			$subject = 'Сообщение c сайта ' . $_SERVER['HTTP_HOST'];
            // Определяем, отправлять ли письмо на определенный ящик или предоставить выбор отдела пользователю
            $mailObj = $mco->getEntity( $fosmail[0] );
            $email = false;
            if($mailObj->title === "all")
            	$email = "all";
            else
            	$email = $mailObj->getValue("recip_mail");
            
            // Получаем набор полей формы
            $mcot = Model_Collection_ObjectTypes::getInstance();
            $groups = $mcot->getEntity( $typeId )->getFieldGroups();
            foreach($groups as $group) {
            	if(strstr($group->title, 'FieldGroup')) {
            		$fields = $group->getFields();
            		break;
            	}
            }
			
            // Создаем форму
			$form = new Feedback_Form_Send();
			$displayGroup = array();
			// Если пользователь выбирает отдел сам, добавляем в форму поле выбора отдела
			if($email === 'all') {
				$guideObj = $mco->getGuideObjects($mailObj->id_type);
				$mailArr = array("" => "Выберите отдел");
				if(count($guideObj)>1) {
					foreach($guideObj as $recipient) {
						if($recipient->title !== "all") {
							//$mailsArr[] = array($recipient->title => $recipient->getValue("recip_mail"));
							$mailArr = array_merge($mailArr, array($recipient->getValue("recip_mail") => $recipient->title));
						}
					}
					$recipSelect = $form->addElement('select', '_email', array('label'=>'Отдел', 'required' => true, 'multiOptions' => $mailArr));
					array_push($displayGroup, '_email');
				} else {
					throw Exception("Не указан список получателей");
				}
				
			}
			// Генерируем форму из набора полей
			foreach($fields as $field) {
            	$type = Model_Collection_FieldTypes::getInstance()->getEntity($field["id_type"]);
            	$decEls = split(",", $field["tip"]);
            	$decorator = array();
            	if(count($decEls)>0) {
            		if(!empty($decEls[0]))
            			$decorator["tag"] = trim($decEls[0]);
            		if(!empty($decEls[1]))
            			$decorator["class"] = trim($decEls[1]);
            	}
            	$form->addElement(
            		$fieldsTypes[$type["name"]]["type"], 
            		$field["name"], 
            		array(
            			'label' => htmlspecialchars_decode($field["title"]) . ':',
            			'required' => $field["is_required"],
            			'filters' => $fieldsTypes[$type["name"]]["filters"],
            			'validators' => $fieldsTypes[$type["name"]]["validators"],
            			'decorators' => array('ViewHelper', 'Errors', array('label', $decorator))
            		)
            	);
            	array_push($displayGroup, $field["name"]);
            }
            $form->addDisplayGroup($displayGroup, 'fb');
            
            if($needCaptcha)
            	$form->addCaptcha();
            $form->addSubmitButton();
            
			$request = $this->getRequest();
			if ( $request->isPost() ) {
				if ( $form->isValid( $request->getPost() ) ) {
					$data = array();
					$data = (object) $data;
					if($email === 'all') {
						$email = $form->getValue('_email');
					}
					$data->name = "System";
					$data->title = $subject;
					$data->message = "";
					foreach($fields as $field) {
						if($field->id_type == 13)
							$data->email = $form->getValue($field["name"]);
						$data->message .= $field["title"] . ": " . $form->getValue($field["name"]) . "<br/>";
					}
					$data->date = date("Y-m-d H:i");
					$headers =
						"Content-type: text/html; charset=utf-8\r\n"
						. "From: =?UTF-8?B?".base64_encode($data->email)."?= <{$data->email}>\r\n"
						. "Reply-To: =?UTF-8?B?".base64_encode($data->email)."?= <{$data->email}>";
					$msg = $this->partial('msg.phtml', $data);
					
					Main::logDebug($msg);
					if( @mail( $email, $subject, $msg, $headers ) ) {
						$this->view->sent = true;
					} else {
						$this->view->sent = false;
					}
				}
			}
			$this->view->form = $form;

            $this->renderContent();
	}
}