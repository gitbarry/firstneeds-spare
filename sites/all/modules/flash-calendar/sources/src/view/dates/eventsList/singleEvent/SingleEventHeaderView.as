package view.dates.eventsList.singleEvent {
	import graphics.Rect;

	import model.Settings;
	import model.dates.eventsList.singleEvent.SingleEventHeader;

	import realTimeTweener.RealTimeTweener;

	import uiElements.Btn;
	import uiElements.text.StringScroller;

	import view.ContainerView;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * @author Robert Soghbatyan (robert.sogbatyan@gmail.com)
	 */
	public class SingleEventHeaderView extends ContainerView {
		////////////////////////////////////////////////////////////////////////////////////////
		// Events                                                                             //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private static const BG_FILL_ALPHA : Number = 0.75;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private var _settings : Settings;

		private var _bg : Rect;
        private var _openHitter : Rect;
        private var _title : StringScroller;
        private var _btnClose : Btn;

		private var _btnCloseTweener : RealTimeTweener;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		public function SingleEventHeaderView(singleEventHeader : SingleEventHeader) : void {
			super(singleEventHeader);
			
			_settings = _controller.settings;
			
			var width : Number = singleEventHeader.width;
			var height : Number = singleEventHeader.height;
			
			var color : int = _settings.eventHeaderColor;
			
			var bgStrokeWidth : Number = Settings.STROKE_WIDTH;
			var bgStrokeColor : int = _controller.settings.strokeColor;
			var fillColor : int = singleEventHeader.bgColor;
			var fillAlpha : Number = fillColor < 0 ? 0 : BG_FILL_ALPHA;
			_bg = new Rect(width, height);
			_bg.strokeWidth = bgStrokeWidth;
			_bg.strokeColor = bgStrokeColor;
			_bg.fillColor = fillColor;
			_bg.fillAlpha = fillAlpha;
			_sprite.addChild(_bg);
			
			var font : String = Settings.FONT;
			var fontSize : int = _settings.eventHeaderFontSize;

            _openHitter = new Rect(width, height);
            _openHitter.alpha = 0;
            _sprite.addChild(_openHitter);
			
			_title = new StringScroller();
			_title.font = font;
			_title.size = fontSize;
			_title.color = color;
			_title.align = StringScroller.ALIGN_LEFT;
			_title.text = singleEventHeader.titleText;
			_sprite.addChild(_title);
			
			var btnCloseRect : Rectangle = singleEventHeader.btnCloseRect;
			_btnClose = new Btn(btnCloseRect.width, btnCloseRect.height, "closeBtn", color);
			_sprite.addChild(_btnClose);
			
			_btnCloseTweener = new RealTimeTweener(_btnClose, _controller.stage);
			_btnCloseTweener.multiplier = Settings.REAL_TIME_TWEENER_MULTIPLIER;
			
			singleEventHeader.addEventListener(SingleEventHeader.UPDATE_IS_OPENED, updateIsOpenedHandler);
			
			updateRect();
			updateIsOpened();
			_btnCloseTweener.finishAll();
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
			
			var singleEventHeader : SingleEventHeader = _model as SingleEventHeader;
			var width : Number = singleEventHeader.width; 
			var height : Number = singleEventHeader.height;
			
			_bg.width = width;
			_bg.height = height;
			
			var titleRect : Rectangle = singleEventHeader.titleRect;
			_title.x = titleRect.x;
			_title.width = titleRect.width;
			_title.height = titleRect.height;
			
			_openHitter.width = width;
			_openHitter.height = height;
			
			var btnCloseRect : Rectangle = singleEventHeader.btnCloseRect;
			_btnClose.x = btnCloseRect.x;
			_btnClose.y = btnCloseRect.y;
		}

		private function updateIsOpened() : void {
			var singleEventHeader : SingleEventHeader = _model as SingleEventHeader;
			var isOpened : Boolean = singleEventHeader.isOpened;
			
			var btnCloseDestAlpha : Number;
			if (isOpened == true) {
				_openHitter.buttonMode = false;
                _openHitter.removeEventListener(MouseEvent.CLICK, spriteClickHandler);

                _title.buttonMode = false;
                _title.removeEventListener(MouseEvent.CLICK, spriteClickHandler);
				
				btnCloseDestAlpha = 1;
				_btnClose.mouseEnabled = true;
				_btnClose.mouseChildren = true;
				_btnClose.addEventListener(MouseEvent.CLICK, btnCloseClickHandler);
			} else {
				_openHitter.buttonMode = true;
				_openHitter.addEventListener(MouseEvent.CLICK, spriteClickHandler);

                _title.buttonMode = true;
                _title.addEventListener(MouseEvent.CLICK, spriteClickHandler);
				
				btnCloseDestAlpha = 0;
				_btnClose.mouseEnabled = false;
				_btnClose.mouseChildren = false;
				_btnClose.removeEventListener(MouseEvent.CLICK, btnCloseClickHandler);
			}
			
			_btnCloseTweener.tween("alpha", btnCloseDestAlpha);
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private function updateIsOpenedHandler(event : Event) : void {
			updateIsOpened();
		}

		private function spriteClickHandler(event : MouseEvent) : void {
			var singleEventHeader : SingleEventHeader = _model as SingleEventHeader;
			_controller.app.dates.eventsList.eventsListManager.isEventOpened = true;
			_controller.app.dates.eventsList.eventsListManager.openedEventIndex = singleEventHeader.index;
			_controller.app.viewState = Settings.VIEW_STATE_EVENT;
		}

		private function btnCloseClickHandler(event : MouseEvent) : void {
			_controller.app.viewState = Settings.VIEW_STATE_EVENTS;
		}
	}
}
