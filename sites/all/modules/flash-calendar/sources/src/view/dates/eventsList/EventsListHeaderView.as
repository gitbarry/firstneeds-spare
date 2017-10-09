package view.dates.eventsList {
	import graphics.Rect;

	import model.Settings;
	import model.dates.eventsList.EventsListHeader;
	import model.dates.eventsList.EventsListManager;

	import realTimeTweener.RealTimeTweener;

	import uiElements.Btn;
	import uiElements.text.AdvancedTextField;
	import uiElements.text.StringScroller;

	import view.ContainerView;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * @author Robert Soghbatyan (robert.sogbatyan@gmail.com)
	 */
	public class EventsListHeaderView extends ContainerView {
		////////////////////////////////////////////////////////////////////////////////////////
		// Events                                                                             //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private var _settings : Settings;

		private var _bg : Rect;

		private var _title : StringScroller;
		private var _ctrlsSprite : Sprite;
		private var _btnPrev : Btn;
		private var _openedEventIndex : AdvancedTextField;
		private var _btnNext : Btn;

		private var _btnClose : Btn;

		private var _ctrlsTweener : RealTimeTweener;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		public function EventsListHeaderView(eventsListHeader : EventsListHeader) : void {
			super(eventsListHeader);
			
			_settings = _controller.settings;			
			var width : Number = eventsListHeader.width;			var height : Number = eventsListHeader.height;
			
			var font : String = Settings.FONT;
			var fontSize : int = _settings.eventsListHeaderFontSize;
			var color : int = _settings.eventsListHeaderColor;
			
			var bgStrokeWidth : Number = Settings.STROKE_WIDTH;			var bgStrokeColor : int = _settings.strokeColor;			var bgColors : Array = _settings.eventsListHeaderbgColors;
			_bg = new Rect(width, height);
			_bg.strokeWidth = bgStrokeWidth;			_bg.strokeColor = bgStrokeColor;
			_bg.fillType = Rect.FILL_TYPE_LINEAR;			_bg.fillGradColors = bgColors;			_bg.fillGradAlphas = [1, 1];			_bg.fillGradRatios = [0, 255];
			_bg.fillGradAngle = 90;
			_sprite.addChild(_bg);
			
			_title = new StringScroller();
			_title.font = font;			_title.size = fontSize;			_title.color = color;
			_title.align = StringScroller.ALIGN_LEFT;
			_sprite.addChild(_title);
			
			_ctrlsSprite = new Sprite();
			//_ctrlsSprite.alpha = 0;
			_sprite.addChild(_ctrlsSprite);
			
			var btnPrevRect : Rectangle = eventsListHeader.ctrlsBtnPrevRect;
			_btnPrev = new Btn(btnPrevRect.width, btnPrevRect.height, "prevBtn", color);
			_btnPrev.x = btnPrevRect.x;
			_btnPrev.y = btnPrevRect.y;
			_ctrlsSprite.addChild(_btnPrev);
			
			_openedEventIndex = new AdvancedTextField(font, fontSize, color);
			_ctrlsSprite.addChild(_openedEventIndex);
			
			var btnNextRect : Rectangle = eventsListHeader.ctrlsBtnNextRect;
			_btnNext = new Btn(btnNextRect.width, btnNextRect.height, "nextBtn", color);
			_btnNext.x = btnNextRect.x;
			_btnNext.y = btnNextRect.y;
			_ctrlsSprite.addChild(_btnNext);
			
			var btnCloseRect : Rectangle = eventsListHeader.btnCloseRect;
			_btnClose = new Btn(btnCloseRect.width, btnCloseRect.height, "closeBtn", color);
			_sprite.addChild(_btnClose);
			
			_ctrlsTweener = new RealTimeTweener(_ctrlsSprite, _controller.stage);			_ctrlsTweener.multiplier = Settings.REAL_TIME_TWEENER_MULTIPLIER;
			
			_btnPrev.addEventListener(MouseEvent.CLICK, clickHandler);			_btnNext.addEventListener(MouseEvent.CLICK, clickHandler);			_btnClose.addEventListener(MouseEvent.CLICK, clickHandler);
			
			eventsListHeader.addEventListener(EventsListHeader.UPDATE_TITLE_TEXT, updateTitleTextHandler);			eventsListHeader.addEventListener(EventsListHeader.UPDATE_CTRLS_VISIBILITY, updateCtrlsVisibilityHandler);			eventsListHeader.addEventListener(EventsListHeader.UPDATE_OPENED_EVENT_INDEX, updateOpenedEventIndexTextHandler);			
			updateRect();
			updateTitleText();
			updateOpenedEventIndexText();
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
			var eventsListHeader : EventsListHeader = _model as EventsListHeader;
			
			var width : Number = eventsListHeader.width;
			var height : Number = eventsListHeader.height;
			
			_bg.width = width;			_bg.height = height;			
			var titleRect : Rectangle = eventsListHeader.titleRect;
			_title.width = titleRect.width;			_title.height = titleRect.height;
			_title.x = titleRect.x;			_title.y = titleRect.y;
			
			var ctrlsRect : Rectangle = eventsListHeader.ctrlsRect;
			_ctrlsSprite.x = ctrlsRect.x;
			_ctrlsSprite.y = ctrlsRect.y;
			
			var openedEventIndexRect : Rectangle = eventsListHeader.ctrlsOpenedEventIndexRect;
			_openedEventIndex.x = openedEventIndexRect.x + (openedEventIndexRect.width - _openedEventIndex.width) / 2;			_openedEventIndex.y = openedEventIndexRect.y + (openedEventIndexRect.height - _openedEventIndex.height) / 2;
			
			var btnCloseRect : Rectangle = eventsListHeader.btnCloseRect;
			_btnClose.x = btnCloseRect.x;
			_btnClose.y = btnCloseRect.y;		}
		
		private function updateTitleText() : void {
			var eventsListHeader : EventsListHeader = _model as EventsListHeader;
			var titleText : String = eventsListHeader.titleText;
			_title.text = titleText;
		}
		
		private function updateCtrlsVisibility() : void {
			var eventsListHeader : EventsListHeader = _model as EventsListHeader;
			var isCtrlsVisible : Boolean = eventsListHeader.isCtrlsVisible;
			var destAlpha : Number = isCtrlsVisible == true ? 1 : 0;
			_ctrlsTweener.tween("alpha", destAlpha);
		}
		
		private function updateOpenedEventIndexText() : void {
			var eventsListHeader : EventsListHeader = _model as EventsListHeader;
			var openedEventIndexText : String = eventsListHeader.openedEventIndexText;
			var openedEventIndexRect : Rectangle = eventsListHeader.ctrlsOpenedEventIndexRect;
			_openedEventIndex.text = openedEventIndexText;
			_openedEventIndex.x = openedEventIndexRect.x + (openedEventIndexRect.width - _openedEventIndex.width) / 2;
			_openedEventIndex.y = openedEventIndexRect.y + (openedEventIndexRect.height - _openedEventIndex.height) / 2;
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private function updateTitleTextHandler(event : Event) : void {
			updateTitleText();
		}
		
		private function updateCtrlsVisibilityHandler(event : Event) : void {
			updateCtrlsVisibility();
		}

		private function updateOpenedEventIndexTextHandler(event : Event) : void {
			updateOpenedEventIndexText();
		}

		private function clickHandler(event : MouseEvent) : void {
			var eventsListHeader : EventsListHeader = _model as EventsListHeader;			var eventsListManager : EventsListManager = eventsListHeader.eventsListManager;
			switch (event.currentTarget) {
				case _btnPrev:
					eventsListManager.openedEventIndex--;
					break;
				case _btnNext:
					eventsListManager.openedEventIndex++;
					break;
				case _btnClose:
					_controller.app.dates.hideEventsList();
					break;
			}
		}
	}
}
