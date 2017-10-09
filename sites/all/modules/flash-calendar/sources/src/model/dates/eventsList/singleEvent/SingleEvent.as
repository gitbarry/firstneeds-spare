package model.dates.eventsList.singleEvent {
import debug.Debug;

import model.Lang;
	import model.Settings;
	import model.SimpleDate;

	import flash.events.EventDispatcher;

	/**
	 * @author Robert Soghbatyan (robert.sogbatyan@gmail.com)
	 */
	public class SingleEvent extends EventDispatcher {
		////////////////////////////////////////////////////////////////////////////////////////
		// Events                                                                             //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private var _controller : Controller;
		private var _settings : Settings;
		private var _lang : Lang;

		private var _index : uint;

		private var _title : String;

		private var _startDate : SimpleDate;
		private var _endDate : SimpleDate;

		private var _descriptionText : String;
		private var _descriptionHtmlText : String;
		private var _descriptionCssText : String;
		private var _descriptionHtmlUrl : String;
		private var _descriptionCssUrl : String;

		private var _type : String;
		private var _priority : int;

		private var _mediaXmlList : XMLList;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		public function SingleEvent(index : uint, eventXml : XML) : void {
			_controller = Controller.getInstance();
			_settings = _controller.settings;
			_lang = _controller.lang;
			
			_index = index;
			
			_title = eventXml.title;
			_startDate = new SimpleDate();
			_startDate.init(eventXml.startDate);
			_endDate = new SimpleDate();
			_endDate.init(eventXml.endDate);
			_descriptionText = eventXml.description.text;
			_descriptionHtmlText = eventXml.description.html;
			_descriptionCssText = eventXml.description.css;
			_descriptionHtmlUrl = eventXml.description.htmlUrl;
			_descriptionCssUrl = eventXml.description.cssUrl;
			_type = eventXml.type;
			_priority = eventXml.priority;
			_mediaXmlList = eventXml.media.item;
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		public function get index() : uint {
			return _index;
		}

		public function get title() : String {
			return _title;
		}

		public function get startDate() : SimpleDate {
			return _startDate;
		}

		public function get endDate() : SimpleDate {
			return _endDate;
		}

		public function get descriptionText() : String {
			return _descriptionText;
		}
		
		public function get descriptionHtmlText() : String {
			return _descriptionHtmlText;
		}
		
		public function get descriptionCssText() : String {
			return _descriptionCssText;
		}
		
		public function get descriptionHtmlUrl() : String {
			return _descriptionHtmlUrl;
		}
		
		public function get descriptionCssUrl() : String {
			return _descriptionCssUrl;
		}

		public function get type() : String {
			return _type;
		}

		public function get priority() : int {
			return _priority;
		}

		public function get mediaXmlList() : XMLList {
			return _mediaXmlList;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
	}
}
