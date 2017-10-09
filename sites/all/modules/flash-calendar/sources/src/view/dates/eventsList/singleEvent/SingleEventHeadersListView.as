package view.dates.eventsList.singleEvent {
	import assets.CalendarVerticalSlideBar;

	import graphics.Rect;

	import model.Settings;
	import model.dates.eventsList.singleEvent.SingleEventHeader;
	import model.dates.eventsList.singleEvent.SingleEventHeadersList;

	import realTimeTweener.RealTimeTweener;

	import uiElements.slider.ContentSlider;
	import uiElements.slider.SlideBar;

	import view.ContainerView;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * @author Robert Soghbatyan (robert.sogbatyan@gmail.com)
	 */
	public class SingleEventHeadersListView extends ContainerView {
		////////////////////////////////////////////////////////////////////////////////////////
		// Events                                                                             //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private const SLIDE_BAR_WIDTH : Number = 4;
		private const SLIDE_BAR_PADDING : Number = 4;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private var _settings : Settings;

		private var _headersSlider : ContentSlider;
		private var _headersSprite : Sprite;
		private var _headersSpriteMask : Rect;
		private var _headersSpriteSlideBar : CalendarVerticalSlideBar;

		private var _singleEventHeaderViews : Array;

		private var _openedHeaderSprite : Sprite;
		private var _openedHeader : SingleEventHeaderView;

		private var _headersSliderTweener : RealTimeTweener;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		public function SingleEventHeadersListView(singleEventHeadersList : SingleEventHeadersList) : void {
			super(singleEventHeadersList);
			
			_settings = _controller.settings;
			
			var headersSliderSprite : Sprite = new Sprite();
			_sprite.addChild(headersSliderSprite);
			
			_headersSprite = new Sprite();
			_headersSprite.name = "content";
			headersSliderSprite.addChild(_headersSprite);
			
			_headersSpriteMask = new Rect();
			_headersSpriteMask.name = "contentMask";
			headersSliderSprite.addChild(_headersSpriteMask);
			_headersSprite.mask = _headersSpriteMask;
			
			var sliderHeadColor : int = _settings.eventsListHeaderColor;
			var sliderBgColor : int = _settings.eventsListHeaderbgColors[0];
			_headersSpriteSlideBar = new CalendarVerticalSlideBar(SLIDE_BAR_WIDTH, 0, sliderBgColor, sliderHeadColor, SLIDE_BAR_WIDTH, SLIDE_BAR_WIDTH);
			_headersSpriteSlideBar.mWheelObj = _sprite;
			_headersSpriteSlideBar.y = SLIDE_BAR_PADDING;
			headersSliderSprite.addChild(_headersSpriteSlideBar.sprite);
			
			_headersSlider = new ContentSlider(headersSliderSprite, _headersSpriteSlideBar);
			
			_singleEventHeaderViews = new Array();
			
			_openedHeaderSprite = new Sprite();
			_sprite.addChild(_openedHeaderSprite);
			
			_headersSliderTweener = new RealTimeTweener(headersSliderSprite, _controller.stage);
			_headersSliderTweener.multiplier = Settings.REAL_TIME_TWEENER_MULTIPLIER;
			
			singleEventHeadersList.addEventListener(SingleEventHeadersList.UPDATE_EVENTS, updateEventsHandler);
			singleEventHeadersList.addEventListener(SingleEventHeadersList.IS_EVENT_OPENED_CHANGED, isEventOpenedChangedHandler);
			singleEventHeadersList.addEventListener(SingleEventHeadersList.OPENED_EVENT_CHANGED, openedEventChangedHandler);
			
			updateRect();
			updateEvents();
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
			
			var singleEventHeadersList : SingleEventHeadersList = _model as SingleEventHeadersList;
			var width : Number = singleEventHeadersList.width;
			var height : Number = singleEventHeadersList.height;
			
			_headersSpriteMask.width = width;
			_headersSpriteMask.height = height;
			
			_headersSpriteSlideBar.height = height - 2 * SLIDE_BAR_PADDING;
			_headersSpriteSlideBar.x = width - SLIDE_BAR_WIDTH - SLIDE_BAR_PADDING;
			
			_headersSlider.updatePos();
		}

		private function updateEvents() : void {
			var singleEventHeadersList : SingleEventHeadersList = _model as SingleEventHeadersList;
			var singleEventHeaders : Array = singleEventHeadersList.singleEventHeaders;
			
			clearHeadersSprite();
			clearOpenedHeaderSprite();
			
			_singleEventHeaderViews = new Array();
			var singleEventHeader : SingleEventHeader;
			var singleEventHeaderView : SingleEventHeaderView;
			for (var i : uint = 0;i < singleEventHeaders.length;i++) {
				singleEventHeader = singleEventHeaders[i] as SingleEventHeader;
				singleEventHeaderView = new SingleEventHeaderView(singleEventHeader);
				_headersSprite.addChild(singleEventHeaderView.sprite);
				_singleEventHeaderViews[i] = singleEventHeaderView;
			}
			
			_headersSlider.resetPos();
			
			updateRect();
		}

		private function updateIsEventOpened() : void {
			var singleEventHeadersList : SingleEventHeadersList = _model as SingleEventHeadersList;
			var isEventOpened : Boolean = singleEventHeadersList.isEventOpened;
			
			if ((isEventOpened == false) && (_openedHeader != null)) {
				if (_openedHeader.sprite.parent != null) {
					_openedHeader.sprite.parent.removeChild(_openedHeader.sprite);
				}
				_headersSprite.addChild(_openedHeader.sprite);
				_openedHeader = null;
			}
			
			_headersSprite.mouseEnabled = !isEventOpened;
			_headersSprite.mouseChildren = !isEventOpened;
			
			var headersSliderDestAlpha : Number = isEventOpened == true ? 0 : 1;
			_headersSliderTweener.tween("alpha", headersSliderDestAlpha);
		}

		private function updateOpenedEvent() : void {
			if (_openedHeader != null) {
				if (_openedHeader.sprite.parent != null) {
					_openedHeader.sprite.parent.removeChild(_openedHeader.sprite);
				}
				_headersSprite.addChild(_openedHeader.sprite);
				_openedHeader = null;
			}
			
			var singleEventHeadersList : SingleEventHeadersList = _model as SingleEventHeadersList;
			var isEventOpened : Boolean = singleEventHeadersList.isEventOpened;
			if (isEventOpened == false) {
				return;
			}
			
			var openedEventIndex : int = singleEventHeadersList.openedEventIndex;
			
			_openedHeader = _singleEventHeaderViews[openedEventIndex];
			if (_openedHeader.sprite.parent != null) {
				_openedHeader.sprite.parent.removeChild(_openedHeader.sprite);
			}
			var globalPoint : Point = _openedHeader.sprite.localToGlobal(new Point());
			var localPoint : Point = _sprite.globalToLocal(globalPoint);
			_openedHeader.sprite.x = localPoint.x;
			_openedHeader.sprite.y = 0;
			_openedHeaderSprite.addChild(_openedHeader.sprite);
		}

		private function clearHeadersSprite() : void {
			while (_headersSprite.numChildren > 0) {
				_headersSprite.removeChildAt(0);
			}
			
			_headersSlider.resetPos();
		}

		private function clearOpenedHeaderSprite() : void {
			while (_openedHeaderSprite.numChildren > 0) {
				_openedHeaderSprite.removeChildAt(0);
			}
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private function updateEventsHandler(event : Event) : void {
			updateEvents();
		}

		private function isEventOpenedChangedHandler(event : Event) : void {
			updateIsEventOpened();
		}

		private function openedEventChangedHandler(event : Event) : void {
			updateOpenedEvent();
		}
	}
}
