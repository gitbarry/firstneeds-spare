package model.dates.eventsList.singleEvent {
	import model.Container;
	import model.Lang;
	import model.Settings;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;

	/**
	 * @author Robert Soghbatyan (robert.sogbatyan@gmail.com)
	 */
	public class SingleEventHeader extends Container {
		////////////////////////////////////////////////////////////////////////////////////////
		// Events                                                                             //
		////////////////////////////////////////////////////////////////////////////////////////
		public static const UPDATE_IS_OPENED : String = "updateIsOpened";

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private static const SPACE : Number = 10;
		
		private static const BTN_SIZE : Number = 30;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private var _settings : Settings;
		private var _lang : Lang;

		private var _index : uint;
		private var _isOpened : Boolean;
		
		private var _title : String;
		private var _type : String;
		private var _priority : int;

		private var _titleRect : Rectangle;
		private var _titleText : String;
		private var _btnCloseRect : Rectangle;

		private var _bgColor : int;

		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		public function SingleEventHeader(index : uint, title : String, type : String, priority : int) : void {
			super();

			_settings = _controller.settings;
			_lang = _controller.lang;
			
			_index = index;
			_isOpened = false;
			
			_title = title;
			_type = type;
			_priority = MathUtils.getInRange(priority, 0, 3);
			
			_titleRect = new Rectangle();
			var typeText : String = _type == "" ? "" : "    " + _lang.type + ": " + _type;
			var priorityText : String = _priority <= 0 ? "" : "    " + _lang.priority + ": " + _lang["priority" + _priority + "Text"];
			_titleText = _title + typeText + priorityText;
			
			_btnCloseRect = new Rectangle(0, 0, BTN_SIZE, BTN_SIZE);
			
			_bgColor = _settings["priority" + _priority + "Color"];
			
			updateRect();
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

		public function get isOpened() : Boolean {
			return _isOpened;
		}

		public function set isOpened(isOpened : Boolean) : void {
			_isOpened = isOpened;

            dispatchEvent(new Event(UPDATE_IS_OPENED));
            updateRect();
        }

		public function get titleRect() : Rectangle {
			return _titleRect;
		}

		public function get titleText() : String {
			return _titleText;
		}
		
		public function get btnCloseRect() : Rectangle {
			return _btnCloseRect;
		}

		public function get bgColor() : Number {
			return _bgColor;
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		override protected function updateRect() : void {
			var width : Number = _rect.width;
			var height : Number = _rect.height;
			
			_titleRect.x = SPACE;
			_titleRect.width = _isOpened == true ? width - height - 2 * SPACE : width - 2 * SPACE;
			_titleRect.height = height;
			
			_btnCloseRect.x = width - BTN_SIZE - SPACE;
			_btnCloseRect.y = (height - BTN_SIZE) / 2;
			
			super.updateRect();
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
	}
}
