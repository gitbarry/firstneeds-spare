package model.dates {
	import model.App;
	import model.Container;
	import model.Lang;
	import model.Settings;

	import uiElements.text.TFUtils;

	import flash.events.Event;
	import flash.geom.Rectangle;

	/**
	 * @author Robert Soghbatyan (robert.sogbatyan@gmail.com)
	 */
	public class DaysNames extends Container {
		////////////////////////////////////////////////////////////////////////////////////////
		// Events                                                                             //
		////////////////////////////////////////////////////////////////////////////////////////
		public static const SHOW : String = "show";		public static const HIDE : String = "hide";

		public static const UPDATE_VISIBILITY : String = "updateVisibility";		public static const UPDATE_SIZE : String = "updateSize";

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		public static const PADDING : Number = 5;
		public static const SIZE_MIN : String = "sizeMin";
		public static const SIZE_MAX : String = "sizeMax";

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private var _settings : Settings;
		private var _lang : Lang;

		private var _size : String;

		private var _isVisible : Boolean;

		private var _heightMin : Number;		private var _heightMax : Number;

		private var _daysNamesMin : Array;		private var _daysNamesMax : Array;		private var _daysNames : Array;

		private var _scaleMin : Number;		private var _scaleMax : Number;		private var _scale : Number;

		private var _dayNameRectsMin : Array;		private var _dayNameRectsMax : Array;		private var _dayNameRects : Array;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		public function DaysNames() : void {
			super();
			
			_settings = _controller.settings;
			_lang = _controller.lang;
			
			_isVisible = _settings.startViewState == Settings.VIEW_STATE_DAYS ? true : false;
			
			_daysNamesMin = _lang.daysShort;			_daysNamesMax = _lang.days;
			
			_dayNameRectsMin = new Array();			_dayNameRectsMax = new Array();
			determineMetrics();
			
			_controller.app.addEventListener(App.VIEW_SIZE_CHANGED, viewSizeChangedHandler);			
			updateRect();
			updateSize();
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		override public function get height() : Number {
			return _size == SIZE_MIN ? _heightMin : _heightMax;
		}
		
		override public function set height(height : Number) : void {
			_rect.height = height;
			updateRect();
		}
		
		public function get isVisible() : Boolean {
			return _isVisible;
		}

		public function set isVisible(isVisible : Boolean) : void {
			if (_isVisible != isVisible) {
				_isVisible = isVisible;
				updateVisibility();
			}
		}

		public function get heightMin() : Number {
			return _heightMin;
		}

		public function get heightMax() : Number {
			return _heightMax;
		}

		public function get daysNames() : Array {
			return _daysNames;
		}

		public function get scale() : Number {
			return _scale;
		}

		public function get dayNameRects() : Array {
			return _dayNameRects;
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		private function determineMetrics() : void {
			var widthMin : Number = _settings.appMinWidth;			var widthMax : Number = _settings.appMaxWidth;
			
			var dayNameRectMin : Rectangle = new Rectangle();
			dayNameRectMin.width = widthMin / 7;			var dayNameRectMax : Rectangle = new Rectangle();
			dayNameRectMax.width = widthMax / 7;
			
			var font : String = Settings.FONT;
			var fontSize : uint = _settings.daysNamesFontSize;
			
			var dayName : String;
			var dayNameRect : Rectangle;
			
			
			for (var i : uint = 0;i < 7;i++) {
				dayName = _daysNamesMin[i];
				dayNameRect = TFUtils.getTFMetrics(dayName, font, fontSize);
				if (dayNameRectMin.width < dayNameRect.width + 2 * PADDING) {
					dayNameRectMin.width = dayNameRect.width + 2 * PADDING;
				}
						
				if (dayNameRectMin.height < dayNameRect.height) {
					dayNameRectMin.height = dayNameRect.height;
				}
				
				dayName = _daysNamesMax[i];
				dayNameRect = TFUtils.getTFMetrics(dayName, font, fontSize);
				if (dayNameRectMax.width < dayNameRect.width + 2 * PADDING) {
					dayNameRectMax.width = dayNameRect.width + 2 * PADDING;
				}
						
				if (dayNameRectMax.height < dayNameRect.height) {
					dayNameRectMax.height = dayNameRect.height;
				}
			}
			
			var dayNamesWidthMin : Number = 7 * dayNameRectMin.width;
			var dayNamesWidthMax : Number = 7 * dayNameRectMax.width;
			_scaleMin = dayNamesWidthMin < widthMin ? 1 : widthMin / dayNamesWidthMin;
			_scaleMax = dayNamesWidthMax < widthMax ? 1 : widthMax / dayNamesWidthMax;
			
			dayNameRectMin.width *= _scaleMin;			dayNameRectMin.height *= _scaleMin;
			
			dayNameRectMax.width *= _scaleMax;
			dayNameRectMax.height *= _scaleMax;
			
			_heightMin = dayNameRectMin.height + 2 * PADDING;
			_heightMax = dayNameRectMax.height + 2 * PADDING;			
			for (i = 0;i < 7;i++) {
				_dayNameRectsMin[i] = new Rectangle(i * dayNameRectMin.width, PADDING, dayNameRectMin.width, dayNameRectMin.height);				_dayNameRectsMax[i] = new Rectangle(i * dayNameRectMax.width, PADDING, dayNameRectMax.width, dayNameRectMax.height);
			}
		}

		private function updateVisibility() : void {
			if (_isVisible == true) {
				updateSize();
			}
			dispatchEvent(new Event(UPDATE_VISIBILITY));
		}

		private function updateSize() : void {
			_size = _controller.app.viewSize == Settings.VIEW_SIZE_MIN ? SIZE_MIN : SIZE_MAX;
			
			if (_size == SIZE_MIN) {
				_daysNames = _daysNamesMin;
				_scale = _scaleMin;
				_dayNameRects = _dayNameRectsMin;
			} else {
				_daysNames = _daysNamesMax;
				_scale = _scaleMax;
				_dayNameRects = _dayNameRectsMax;
			}
			
			dispatchEvent(new Event(UPDATE_SIZE));
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private function viewSizeChangedHandler(event : Event) : void {
			if (_isVisible == true) {
				updateSize();
			}
		}
	}
}
