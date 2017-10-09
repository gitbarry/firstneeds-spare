package model.header {
	import model.App;
	import model.Calendar;
	import model.Container;
	import model.Lang;
	import model.Settings;

	import flash.events.Event;
	import flash.geom.Rectangle;

	/**
	 * @author Robert Soghbatyan (robert.sogbatyan@gmail.com)
	 */
	public class Header extends Container {
		////////////////////////////////////////////////////////////////////////////////////////
		// Events                                                                             //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private var _settings : Settings;		private var _calendar : Calendar;		private var _lang : Lang;

		private var _padding : Number;

		private var _bgRect : Rectangle;

		private var _yearChanger : DateChanger;
		private var _monthChanger : DateChanger;
		private var _dayChanger : DateChanger;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		public function Header() : void {
			super();
			
			_settings = _controller.settings;
			_calendar = _controller.calendar;
			_lang = _controller.lang;
			
			_padding = _settings.headerPadding;
			
			_bgRect = new Rectangle();
			
			_yearChanger = new DateChanger(DateChanger.TYPE_YEAR);
			_monthChanger = new DateChanger(DateChanger.TYPE_MONTH);
			_dayChanger = new DateChanger(DateChanger.TYPE_DAY);
			
			determineDateChangerMetrics();
			
			var viewSize : String = _controller.app.viewSize == Settings.VIEW_SIZE_MIN ? DateChanger.SIZE_MIN : DateChanger.SIZE_MAX;
			_yearChanger.size = viewSize;			_monthChanger.size = viewSize;			_dayChanger.size = viewSize;
			
			_controller.app.addEventListener(App.VIEW_STATE_CHANGED, viewStateChangedHandler);			_controller.app.addEventListener(App.VIEW_SIZE_CHANGED, viewSizeChangedHandler);
			
			updateRect();
			updateViewState();			updateViewSize();
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		public function get bgRect() : Rectangle {
			return _bgRect;
		}

		public function get yearChanger() : DateChanger {
			return _yearChanger;
		}

		public function get monthChanger() : DateChanger {
			return _monthChanger;
		}

		public function get dayChanger() : DateChanger {
			return _dayChanger;
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		override protected function updateRect() : void {
			_bgRect.x = 0;			_bgRect.y = _padding;
			_bgRect.width = _rect.width;
			_bgRect.height = _rect.height - 2 * _padding;
			
			_yearChanger.y = _rect.height / 2;
			_monthChanger.y = _rect.height / 2;
			_dayChanger.y = _rect.height / 2;
			
			super.updateRect();
		}

		private function determineDateChangerMetrics() : void {
			var maxWidth : Number = _settings.appMaxWidth;			var minWidth : Number = _settings.appMinWidth;
			
			var fits : Boolean;
			var scale : Number;
			
			var btnSize : Number = DateChanger.BTN_SIZE;
			
			var yearWidthMin : Number = _yearChanger.dateTextRectMin.width + 2 * btnSize;			var yearWidthMax : Number = _yearChanger.dateTextRectMax.width + 2 * btnSize;
			
			var monthWidthMin : Number = _monthChanger.dateTextRectMin.width + 2 * btnSize;
			var monthWidthMax : Number = _monthChanger.dateTextRectMax.width + 2 * btnSize;
			
			var dayWidthMin : Number = _dayChanger.dateTextRectMin.width + 2 * btnSize;
			var dayWidthMax : Number = _dayChanger.dateTextRectMax.width + 2 * btnSize;
			

			fits = yearWidthMin + monthWidthMin + dayWidthMin <= minWidth ? true : false;
			scale = fits == true ? 1 : minWidth / (yearWidthMin + monthWidthMin + dayWidthMin);
			
			_yearChanger.scaleMin = scale;
			_yearChanger.xMin = minWidth * (yearWidthMin / 2) / (yearWidthMin + monthWidthMin + dayWidthMin);
			_monthChanger.scaleMin = scale;
			_monthChanger.xMin = minWidth * (yearWidthMin + (monthWidthMin / 2)) / (yearWidthMin + monthWidthMin + dayWidthMin);
			_dayChanger.scaleMin = scale;
			_dayChanger.xMin = minWidth * (yearWidthMin + monthWidthMin + (dayWidthMin / 2)) / (yearWidthMin + monthWidthMin + dayWidthMin);
			
			fits = yearWidthMax + monthWidthMax + dayWidthMax <= maxWidth ? true : false;
			scale = fits == true ? 1 : maxWidth / (yearWidthMax + monthWidthMax + dayWidthMax);
			
			_yearChanger.scaleMax = scale;
			_yearChanger.xMax = maxWidth * (yearWidthMax / 2) / (yearWidthMax + monthWidthMax + dayWidthMax);
			_monthChanger.scaleMax = scale;
			_monthChanger.xMax = maxWidth * (yearWidthMax + (monthWidthMax / 2)) / (yearWidthMax + monthWidthMax + dayWidthMax);
			_dayChanger.scaleMax = scale;
			_dayChanger.xMax = maxWidth * (yearWidthMax + monthWidthMax + (dayWidthMax / 2)) / (yearWidthMax + monthWidthMax + dayWidthMax);
		}

		private function updateViewState() : void {
			var viewState : String = _controller.app.viewState;
			
			if (viewState == Settings.VIEW_STATE_YEARS) {
				_monthChanger.hide();
				_dayChanger.hide();
			} else if (viewState == Settings.VIEW_STATE_MONTHS) {
				_monthChanger.show();
				_dayChanger.hide();
			} else if (viewState == Settings.VIEW_STATE_DAYS) {
				_monthChanger.show();
				_dayChanger.show();
			}
		}
		
		private function updateViewSize() : void {
			var viewSize : String = _controller.app.viewSize;
			
			if (viewSize == Settings.VIEW_SIZE_MIN) {
				_yearChanger.size = DateChanger.SIZE_MIN;
				_monthChanger.size = DateChanger.SIZE_MIN;
				_dayChanger.size = DateChanger.SIZE_MIN;
			} else {
				_yearChanger.size = DateChanger.SIZE_MAX;
				_monthChanger.size = DateChanger.SIZE_MAX;
				_dayChanger.size = DateChanger.SIZE_MAX;
			}
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private function viewStateChangedHandler(event : Event) : void {
			updateViewState();
		}
		
		private function viewSizeChangedHandler(event : Event) : void {
			updateViewSize();
		}
	}
}
