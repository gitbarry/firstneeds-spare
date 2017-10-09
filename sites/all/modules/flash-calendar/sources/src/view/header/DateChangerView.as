package view.header {
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;

	import graphics.Rect;

	import model.Calendar;
	import model.Settings;
	import model.header.DateChanger;

	import realTimeTweener.RealTimeTweener;

	import uiElements.Btn;
	import uiElements.text.AdvancedTextField;

	import view.ContainerView;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;

	/**
	 * @author Robert Soghbatyan (robert.sogbatyan@gmail.com)
	 */
	public class DateChangerView extends ContainerView {
		////////////////////////////////////////////////////////////////////////////////////////
		// Events                                                                             //
		////////////////////////////////////////////////////////////////////////////////////////
		private const PREV : String = "prev";		private const NEXT : String = "next";

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private static const OVER_COLOR_SHIFT : Number = 0.4;
		private static const DOWN_COLOR_SHIFT : Number = 0.2;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private var _settings : Settings;		private var _calendar : Calendar;

		private var _contentColor : int;

		private var _btnPrev : Btn;
		private var _dateTF : AdvancedTextField;
		private var _dateTFHitter : Rect;
		private var _btnNext : Btn;

		private var _spriteTweener : RealTimeTweener;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		public function DateChangerView(dateChanger : DateChanger) : void {
			super(dateChanger);
			
			_settings = _controller.settings;
			_calendar = _controller.calendar;
			
			_sprite.x = dateChanger.x;			_sprite.y = dateChanger.y;			_sprite.scaleX = dateChanger.scale;			_sprite.scaleY = dateChanger.scale;
			
			var contentStrokeColor : int = _settings.headerContentStrokeColor;
			if (contentStrokeColor >= 0) {
				var strokeOuter : GlowFilter = new GlowFilter(contentStrokeColor, 0.9, 1.4, 1.4, 15, BitmapFilterQuality.HIGH);
				_sprite.filters = new Array(strokeOuter);
			} 
			
			_contentColor = _settings.headerContentColor;
			
			var btnPrevRect : Rectangle = dateChanger.btnPrevRect;
			_btnPrev = new Btn(btnPrevRect.width, btnPrevRect.height, "dateChangerBtnPrev", _contentColor);
			_btnPrev.x = btnPrevRect.x;
			_btnPrev.y = btnPrevRect.y;
			_sprite.addChild(_btnPrev);
			
			var font : String = Settings.FONT;
			var fontSize : int = _settings.headerFontSize;
			var dateTextRect : Rectangle = dateChanger.dateTextRect;
			_dateTF = new AdvancedTextField(font, fontSize, _contentColor);
			_dateTF.autoSize = TextFieldAutoSize.CENTER;
			_dateTF.x = dateTextRect.x;
			_dateTF.y = dateTextRect.y;
			_dateTF.width = dateTextRect.width;
			_dateTF.height = dateTextRect.height;
			_sprite.addChild(_dateTF);
			
			_dateTFHitter = new Rect();
			_dateTFHitter.x = dateTextRect.x;
			_dateTFHitter.y = dateTextRect.y;
			_dateTFHitter.width = dateTextRect.width;
			_dateTFHitter.height = dateTextRect.height;
			_dateTFHitter.buttonMode = true;
			_dateTFHitter.alpha = 0;
			_sprite.addChild(_dateTFHitter);
			
			var btnNextRect : Rectangle = dateChanger.btnNextRect;
			_btnNext = new Btn(btnNextRect.width, btnNextRect.height, "dateChangerBtnNext", _contentColor);
			_btnNext.x = btnNextRect.x;
			_btnNext.y = btnNextRect.y;
			_sprite.addChild(_btnNext);
			
			_spriteTweener = new RealTimeTweener(_sprite, _controller.stage);			_spriteTweener.multiplier = Settings.REAL_TIME_TWEENER_MULTIPLIER;
			
			
			_btnPrev.addEventListener(PREV, btnPrevClickHandler);			_btnNext.addEventListener(NEXT, btnNextClickHandler);
			
			_dateTFHitter.addEventListener(MouseEvent.ROLL_OVER, dateTFHitterHandler);			_dateTFHitter.addEventListener(MouseEvent.ROLL_OUT, dateTFHitterHandler);			_dateTFHitter.addEventListener(MouseEvent.MOUSE_DOWN, dateTFHitterHandler);			_dateTFHitter.addEventListener(MouseEvent.MOUSE_UP, dateTFHitterHandler);			_dateTFHitter.addEventListener(MouseEvent.CLICK, dateTFHitterHandler);
			
			dateChanger.addEventListener(DateChanger.UPDATE_SIZE, updateSizeHandler);
			dateChanger.addEventListener(DateChanger.VISIBILITY_CHANGED, visibilityChangedHandler);			dateChanger.addEventListener(DateChanger.UPDATE_DATE_TEXT, updateDateTextHandler);			
			updateRect();
			updateSize();
			updateDateText();
			updateVisibility();
			_spriteTweener.finishAll();
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
			var dateChanger : DateChanger = _model as DateChanger;
			
			var btnPrevRect : Rectangle = dateChanger.btnPrevRect;
			_btnPrev.x = btnPrevRect.x;			_btnPrev.y = btnPrevRect.y;
			
			var dateTextRect : Rectangle = dateChanger.dateTextRect;
			_dateTF.x = dateTextRect.x;
			_dateTF.y = dateTextRect.y;
			_dateTF.width = dateTextRect.width;
			_dateTF.height = dateTextRect.height;
			
			_dateTFHitter.x = dateTextRect.x;
			_dateTFHitter.y = dateTextRect.y;
			_dateTFHitter.width = dateTextRect.width;
			_dateTFHitter.height = dateTextRect.height;
			
			var btnNextRect : Rectangle = dateChanger.btnNextRect;
			_btnNext.x = btnNextRect.x;
			_btnNext.y = btnNextRect.y;
			
			_spriteTweener.tween("x", dateChanger.x);			_spriteTweener.tween("y", dateChanger.y);			_spriteTweener.tween("scaleX", dateChanger.scale);			_spriteTweener.tween("scaleY", dateChanger.scale);		}

		private function updateSize() : void {
			updateRect();
		}

		private function updateVisibility() : void {
			var dateChanger : DateChanger = _model as DateChanger;
			var isVisible : Boolean = dateChanger.isVisible;
			
			_sprite.mouseEnabled = isVisible;			_sprite.mouseChildren = isVisible;
			_spriteTweener.tween("alpha", isVisible == true ? 1 : 0);
		}

		private function updateDateText() : void {
			var dateChanger : DateChanger = _model as DateChanger;
			_dateTF.text = dateChanger.dateText;
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private function btnPrevClickHandler(event : Event) : void {
			var dateChanger : DateChanger = DateChanger(_model);
			switch (dateChanger.type) {
				case DateChanger.TYPE_YEAR:
					_calendar.curYear--;
					break;
				case DateChanger.TYPE_MONTH:
					_calendar.curMonth--;
					break;
				case DateChanger.TYPE_DAY:
					_calendar.curDate--;
					break;
			}
		}

		private function btnNextClickHandler(event : Event) : void {
			var dateChanger : DateChanger = DateChanger(_model);
			switch (dateChanger.type) {
				case DateChanger.TYPE_YEAR:
					_calendar.curYear++;
					break;
				case DateChanger.TYPE_MONTH:
					_calendar.curMonth++;
					break;
				case DateChanger.TYPE_DAY:
					_calendar.curDate++;
					break;
			}
		}

		private function dateTFHitterHandler(event : MouseEvent) : void {
			switch (event.type) {
				case MouseEvent.ROLL_OVER:
					_dateTF.color = ColorUtils.lighten(_contentColor, OVER_COLOR_SHIFT * 2);
					break;
				case MouseEvent.ROLL_OUT:
					_dateTF.color = _contentColor;
					break;
				case MouseEvent.MOUSE_DOWN:
					_dateTF.color = ColorUtils.darken(_contentColor, DOWN_COLOR_SHIFT);
					break;
				case MouseEvent.MOUSE_UP:
					_dateTF.color = _contentColor;
					break;
				case MouseEvent.CLICK:
					var dateChanger : DateChanger = DateChanger(_model);
					switch (dateChanger.type) {
						case DateChanger.TYPE_YEAR:
							_controller.app.viewState = Settings.VIEW_STATE_YEARS;
							break;
						case DateChanger.TYPE_MONTH:
							_controller.app.viewState = Settings.VIEW_STATE_MONTHS;
							break;
						case DateChanger.TYPE_DAY:
							_controller.app.viewState = Settings.VIEW_STATE_DAYS;
							break;
					}
					break;
			}
		}

		private function updateSizeHandler(event : Event) : void {
			updateSize();
		}

		private function visibilityChangedHandler(event : Event) : void {
			updateVisibility();
		}

		private function updateDateTextHandler(event : Event) : void {
			updateDateText();
		}
	}
}
