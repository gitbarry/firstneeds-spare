package model.header {
	import model.App;
	import model.Calendar;
	import model.Container;
	import model.Lang;
	import model.Settings;

	import uiElements.text.TFUtils;

	import flash.events.Event;
	import flash.geom.Rectangle;

	/**
	 * @author Robert Soghbatyan (robert.sogbatyan@gmail.com)
	 */
	public class DateChanger extends Container {
		////////////////////////////////////////////////////////////////////////////////////////
		// Events                                                                             //
		////////////////////////////////////////////////////////////////////////////////////////
		public static const UPDATE_SIZE : String = "updateSize";
		public static const VISIBILITY_CHANGED : String = "visibilityChanged";

		public static const UPDATE_DATE_TEXT : String = "updateDateText";
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		public static const BTN_SIZE : Number = 40;

		public static const TYPE_YEAR : String = "typeYear";		public static const TYPE_MONTH : String = "typeMonth";		public static const TYPE_DAY : String = "typeDay";

		public static const SIZE_MIN : String = "sizeMin";		public static const SIZE_MAX : String = "sizeMax";

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private var _settings : Settings;
		private var _calendar : Calendar;		private var _lang : Lang;

		private var _type : String;
		private var _size : String;
		private var _isVisible : Boolean;
		
		private var _xMin : Number;
		private var _xMax : Number;

		private var _scale : Number;
		private var _scaleMin : Number;
		private var _scaleMax : Number;

		private var _btnPrevRect : Rectangle;

		private var _dateTextRectMin : Rectangle;
		private var _dateTextRectMax : Rectangle;
		private var _dateTextRect : Rectangle;

		private var _btnNextRect : Rectangle;

		private var _dateText : String;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		public function DateChanger(type : String) : void {
			super();
			
			_settings = _controller.settings;
			_calendar = _controller.calendar;
			_lang = _controller.lang;
			
			_type = type;
			_size = SIZE_MIN;
			_isVisible = true;
			
			_scaleMin = 1;			_scaleMax = 1;			
			_btnPrevRect = new Rectangle(0, -BTN_SIZE / 2, BTN_SIZE, BTN_SIZE);
			
			_dateTextRectMin = new Rectangle();			_dateTextRectMax = new Rectangle();			determineMetrics();
			_dateTextRect = _controller.app.viewSize == Settings.VIEW_SIZE_MIN ? _dateTextRectMin : _dateTextRectMax;			
			_btnNextRect = new Rectangle(0, -BTN_SIZE / 2, BTN_SIZE, BTN_SIZE);
			
			_dateText = "";			
			_calendar.addEventListener(Calendar.DATE_CHANGED, dateChangedHandler);
			
			updateRect();
			updateDateText();
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		public function show() : void {
			updateDateText();
			_isVisible = true;
			dispatchEvent(new Event(VISIBILITY_CHANGED));
		}

		public function hide() : void {
			_isVisible = false;
			dispatchEvent(new Event(VISIBILITY_CHANGED));
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		public function get type() : String {
			return _type;
		}

		public function get size() : String {
			return _size;
		}

		public function set size(size : String) : void {
			_size = size;
			updateSize();
		}

		public function get isVisible() : Boolean {
			return _isVisible;
		}
		
		public function get xMin() : Number {
			return _xMin;
		}

		public function set xMin(xMin : Number) : void {
			_xMin = xMin;
		}
		
		public function get xMax() : Number {
			return _xMax;
		}

		public function set xMax(xMax : Number) : void {
			_xMax = xMax;
		}
		
		public function get scale() : Number {
			return _scale;
		}

		public function get scaleMin() : Number {
			return _scaleMin;
		}

		public function set scaleMin(scaleMin : Number) : void {
			_scaleMin = scaleMin;
		}

		public function get scaleMax() : Number {
			return _scaleMax;
		}

		public function set scaleMax(scaleMax : Number) : void {
			_scaleMax = scaleMax;
		}

		public function get btnPrevRect() : Rectangle {
			return _btnPrevRect;
		}

		public function get dateTextRectMin() : Rectangle {
			return _dateTextRectMin;
		}

		public function get dateTextRectMax() : Rectangle {
			return _dateTextRectMax;
		}

		public function get dateTextRect() : Rectangle {
			return _dateTextRect;
		}

		public function get btnNextRect() : Rectangle {
			return _btnNextRect;
		}

		public function get dateText() : String {
			return _dateText;
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		private function determineMetrics() : void {
			var font : String = Settings.FONT;
			var fontSize : int = _settings.headerFontSize;
			
			switch (_type) {
				case TYPE_YEAR:				case TYPE_DAY:
					_dateTextRectMin = TFUtils.getTFMetrics("8888", font, fontSize);
					_dateTextRectMin.x = -_dateTextRectMin.width / 2;					_dateTextRectMin.y = -_dateTextRectMin.height / 2;
					_dateTextRectMax = _dateTextRectMin;
					break;
				case TYPE_MONTH:
					_dateTextRectMin = new Rectangle();					_dateTextRectMax = new Rectangle();
					
					var monthNamesShort : Array = _lang.monthsShort;
					var monthNames : Array = _lang.months;					var curMonthRect : Rectangle;
					
					for (var i : uint = 0;i < 12;i++) {
						curMonthRect = TFUtils.getTFMetrics(monthNamesShort[i], font, fontSize);
						if (_dateTextRectMin.width < curMonthRect.width) {
							_dateTextRectMin.width = curMonthRect.width;
						}
						
						if (_dateTextRectMin.height < curMonthRect.height) {
							_dateTextRectMin.height = curMonthRect.height;
						}
						
						curMonthRect = TFUtils.getTFMetrics(monthNames[i], font, fontSize);
						if (_dateTextRectMax.width < curMonthRect.width) {
							_dateTextRectMax.width = curMonthRect.width;
						}
						
						if (_dateTextRectMax.height < curMonthRect.height) {
							_dateTextRectMax.height = curMonthRect.height;
						}
					}
					
					_dateTextRectMin.x = -_dateTextRectMin.width / 2;
					_dateTextRectMin.y = -_dateTextRectMin.height / 2;
					
					_dateTextRectMax.x = -_dateTextRectMax.width / 2;
					_dateTextRectMax.y = -_dateTextRectMax.height / 2;
					break;
			}
		}

		private function updateSize() : void {
			_scale = _size == SIZE_MIN ? _scaleMin : _scaleMax;
			this.x = _size == SIZE_MIN ? _xMin : _xMax;
			
			_dateTextRect = _size == SIZE_MIN ? _dateTextRectMin : _dateTextRectMax;
			
			_btnPrevRect.x = _dateTextRect.x - BTN_SIZE;			_btnNextRect.x = _dateTextRect.x + _dateTextRect.width;
			
			dispatchEvent(new Event(UPDATE_SIZE));
			
			if (_type == TYPE_MONTH) {
				updateDateText();
			}
		}

		private function updateDateText() : void {
			var dateText : String;
			
			switch (_type) {
				case TYPE_YEAR:
					var year : String = String(_calendar.curYear);
					dateText = TextUtils.fillZeros(year, 4);
					break;
				case TYPE_MONTH:
					var monthIndex : uint = _calendar.curMonth;
					var monthsArray : Array = _controller.app.viewSize == Settings.VIEW_SIZE_MIN ? _lang.monthsShort : _lang.months;
					dateText = monthsArray[monthIndex];
					break;
				case TYPE_DAY:
					var day : String = String(_calendar.curDate);
					dateText = TextUtils.fillZeros(day, 2);
					break;
			}
			
			if (_dateText != dateText) {
				_dateText = dateText;
				dispatchEvent(new Event(UPDATE_DATE_TEXT));
			}
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private function dateChangedHandler(event : Event) : void {
			if (_isVisible == true) {
				updateDateText();
			}
		}
	}
}
