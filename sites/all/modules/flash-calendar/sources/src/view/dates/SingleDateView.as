package view.dates {
	import graphics.Rect;

	import model.Calendar;
	import model.Settings;
	import model.dates.SingleDate;

	import uiElements.text.AdvancedTextField;

	import view.ContainerView;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * @author Robert Soghbatyan (robert.sogbatyan@gmail.com)
	 */
	public class SingleDateView extends ContainerView {
		////////////////////////////////////////////////////////////////////////////////////////
		// Events                                                                             //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		public static const BG_FILL_ALPHA : Number = 0.75;

		public static const BG_STROKE_WIDTH_SELECTED : Number = 2;		public static const BG_STROKE_WIDTH_OVER : Number = 1;		public static const BG_STROKE_WIDTH_OUT : Number = 0;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private var _settings : Settings;		private var _calendar : Calendar;

		private var _bg : Rect;

		private var _date : AdvancedTextField;
		private var _dateHitter : Rect;
		private var _eventsCount : AdvancedTextField;
		private var _eventsCountHitter : Rect;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		public function SingleDateView(singleDate : SingleDate) : void {
			super(singleDate);
			
			_settings = _controller.settings;
			_calendar = _controller.calendar;
			
			if (singleDate.isActive == false) {
				_sprite.alpha = 0.5;			
			}
			
			_bg = new Rect();
			_bg.strokeAlign = Rect.STROKE_ALIGN_IN;
			_bg.strokeWidth = singleDate.isSelected == false ? BG_STROKE_WIDTH_OUT : BG_STROKE_WIDTH_SELECTED;			_bg.strokeColor = _settings.dateStrokeColor;
			_bg.fillColor = singleDate.bgColor;
			_sprite.addChild(_bg);
			
			var font : String = Settings.FONT;
			
			var dateFontSize : int = _settings.dateFontSize;
			var dateFontColor : int = _settings.dateColor;
			var dateText : String = singleDate.dateText;
			_date = new AdvancedTextField(font, dateFontSize, dateFontColor);
			_date.text = dateText;
			_sprite.addChild(_date);
			
			var showEventsCount : Boolean = _settings.showDateEventsCount;	
			var eventsCountFontSize : int = _settings.dateEventsCountFontSize;			var eventsCountFontColor : int = _settings.dateEventsCountColor;
			var eventsCountText : String = singleDate.eventsCountText;
			_eventsCount = new AdvancedTextField(font, eventsCountFontSize, eventsCountFontColor);
			_eventsCount.text = eventsCountText;
			if (showEventsCount == true) {
				_sprite.addChild(_eventsCount);
			}
			
			_dateHitter = new Rect();
			_dateHitter.alpha = 0;
			_sprite.addChild(_dateHitter);
			
			var canSwitchToEvents : Boolean = singleDate.canSwitchToEvents;
			if (canSwitchToEvents == true) {
				_eventsCountHitter = new Rect();
				_eventsCountHitter.buttonMode = true;
				_eventsCountHitter.alpha = 0;
				if (showEventsCount == true) {
					_sprite.addChild(_eventsCountHitter);
				}
			}

			_controller.stage.addEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler, false, 0, true);
			_controller.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 0, true);
			
			_dateHitter.addEventListener(MouseEvent.CLICK, hitterClickHandler);
			if (_eventsCountHitter != null) {
				_eventsCountHitter.addEventListener(MouseEvent.CLICK, hitterClickHandler);
			}
			
			singleDate.addEventListener(SingleDate.UPDATE_DATE_TEXT, updateDateTextHandler);			singleDate.addEventListener(SingleDate.UPDATE_SELECTED, updateSelectedHandler);
						updateRect();
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		override protected function updateRect() : void {
			super.updateRect();
			
			var singleDate : SingleDate = _model as SingleDate;
			var width : Number = singleDate.width; 
			var height : Number = singleDate.height;
			
			_bg.width = width;
			_bg.height = height;
			
			var dateScale : Number = singleDate.dateScale;
			_date.scaleX = _date.scaleY = dateScale;
			var dateRect : Rectangle = singleDate.dateRect;
			_date.x = dateRect.x + (dateRect.width - _date.width) / 2;			_date.y = dateRect.y + (dateRect.height - _date.height) / 2;
			
			_dateHitter.width = width;			_dateHitter.height = height;
			
			var eventsCountScale : Number = singleDate.eventsCountScale;
			_eventsCount.scaleX = _eventsCount.scaleY = eventsCountScale;
			var eventsCountRect : Rectangle = singleDate.eventsCountRect;
			_eventsCount.x = eventsCountRect.x + (eventsCountRect.width - _eventsCount.width) / 2;
			_eventsCount.y = eventsCountRect.y + (eventsCountRect.height - _eventsCount.height) / 2;
			
			if (_eventsCountHitter != null) {
				_eventsCountHitter.width = width;
				_eventsCountHitter.height = (1 - SingleDate.DATE_PERCENT) * height;
				_eventsCountHitter.y = SingleDate.DATE_PERCENT * height;
			}
			
//			var scale : Number;
//			var scaleX : Number;//			var scaleY : Number;
//			//id
//			var idRect : Rectangle = _singleDate.idRect;
//			_id.scaleX = _id.scaleY = _singleDate.idScale;
//			_id.x = idRect.x + (idRect.width - _id.width) / 2;//			_id.y = idRect.y + (idRect.height - _id.height) / 2;
//			
//			//eventsCount
//			var eventsCountRect : Rectangle = _singleDate.eventsCountRect;
//			_eventsCount.scaleX = _eventsCount.scaleY = _singleDate.eventsCountScale;
//			_eventsCount.x = eventsCountRect.x + (eventsCountRect.width - _eventsCount.width) / 2;
//			_eventsCount.y = eventsCountRect.y + (eventsCountRect.height - _eventsCount.height) / 2;
//			if ((eventsCountRect.width == 0) || (eventsCountRect.height == 0)) {
//				if (_eventsCount.parent != null) {
//					_eventsCount.parent.removeChild(_eventsCount);
//				}
//				if (_eventsCountHitRect.parent != null) {
//					_eventsCountHitRect.parent.removeChild(_eventsCountHitRect);
//				}
//			} else if (_singleDate.showEventsCount == true) {
//				_sprite.addChild(_eventsCount);//				_sprite.addChild(_eventsCountHitRect);
//			}
//			_eventsCountHitRect.width = eventsCountRect.width;//			_eventsCountHitRect.height = eventsCountRect.height;//			_eventsCountHitRect.x = eventsCountRect.x;//			_eventsCountHitRect.y = eventsCountRect.y;		}

		private function updateDateText() : void {
			var singleDate : SingleDate = _model as SingleDate;
			var dateText : String = singleDate.dateText;
			_date.text = dateText;
		}

		private function updateSelected() : void {
			var singleDate : SingleDate = _model as SingleDate;
			var isSelected : Boolean = singleDate.isSelected;
			if (isSelected == true) {
				_bg.strokeWidth = BG_STROKE_WIDTH_SELECTED;
			} else {
				_bg.strokeWidth = BG_STROKE_WIDTH_OUT;
			}
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private function mouseMoveHandler(event : MouseEvent) : void {
			var singleDate : SingleDate = _model as SingleDate;
			if (singleDate.isSelected == true) {
				_bg.strokeWidth = BG_STROKE_WIDTH_SELECTED;
			} else if (Utils.isMouseOn(_bg)) {
				_bg.strokeWidth = BG_STROKE_WIDTH_OVER;
			} else {
				_bg.strokeWidth = BG_STROKE_WIDTH_OUT;
			}
		}

		private function mouseLeaveHandler(event : Event) : void {
			var singleDate : SingleDate = _model as SingleDate;
			if (singleDate.isSelected == true) {
				_bg.strokeWidth = BG_STROKE_WIDTH_SELECTED;
			} else {
				_bg.strokeWidth = BG_STROKE_WIDTH_OUT;
			}
		}

		private function hitterClickHandler(event : MouseEvent) : void {
			var isTargetEvents : Boolean = event.target == _eventsCountHitter ? true : false;
			var viewState : String = "";
			
			var singleDate : SingleDate = _model as SingleDate;
			var type : String = singleDate.type;
			var date : Date = singleDate.date;
			
			var switchToEvents : Boolean;
			if ((isTargetEvents == true) || ((type == SingleDate.TYPE_DATE) && (singleDate.canSwitchToEvents == true))) {
				switchToEvents = true; 
			} else {
				switchToEvents = false;
			}
			
			switch (type) {
				case SingleDate.TYPE_YEAR:
					_calendar.curYear = date.fullYear;
					viewState = Settings.VIEW_STATE_MONTHS;
					break;
				case SingleDate.TYPE_MONTH:
					_calendar.curMonth = date.month;
					viewState = Settings.VIEW_STATE_DAYS;
					break;
				case SingleDate.TYPE_DATE:
					if (_calendar.curYear != date.fullYear) {
						_calendar.curYear = date.fullYear;
					}
					if (_calendar.curMonth != date.month) {
						_calendar.curMonth = date.month;
					}
					_calendar.curDate = date.date;
					break;
			}
			
			if (switchToEvents == true) {
				_controller.app.viewState = Settings.VIEW_STATE_EVENTS;
			} else if (viewState != "") {
				_controller.app.viewState = viewState;
			}
		}

		private function updateDateTextHandler(event : Event) : void {
			updateDateText();
		}

		private function updateSelectedHandler(event : Event) : void {
			updateSelected();
		}
	}
}
