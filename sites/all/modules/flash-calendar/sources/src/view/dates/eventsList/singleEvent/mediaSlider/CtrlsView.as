package view.dates.eventsList.singleEvent.mediaSlider {
	import graphics.Rect;

	import model.Settings;
	import model.dates.eventsList.singleEvent.mediaSlider.Ctrls;
	import model.dates.eventsList.singleEvent.mediaSlider.MediaManager;

	import uiElements.Btn;
	import uiElements.mediaLoader.MediaLoader;

	import view.ContainerView;

	import flash.events.Event;
	import flash.geom.Rectangle;

	/**
	 * @author User
	 */
	public class CtrlsView extends ContainerView {
		////////////////////////////////////////////////////////////////////////////////////////
		// Events                                                                             //
		////////////////////////////////////////////////////////////////////////////////////////
		public static const START : String = "start";		public static const STOP : String = "stop";		public static const PREV : String = "prev";		public static const NEXT : String = "next";
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private static const BG_CORNER_RADIUS : Number = 5;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private var _settings : Settings;
		
		private var _mediaManager : MediaManager;		private var _mediaLoader : MediaLoader;

		private var _bg : Rect;

		private var _prevBtn : Btn;
		private var _startStopBtn : Btn;
		private var _nextBtn : Btn;
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////

		public function CtrlsView(ctrls : Ctrls, mediaManager : MediaManager, mediaLoader : MediaLoader) : void {
			super(ctrls);
			
			_settings = _controller.settings;
			
			_mediaManager = mediaManager;
			_mediaLoader = mediaLoader;
			
			var bgColor : int = _settings.mediaCtrlsBgColor;			var bgAlpha : Number = _settings.mediaCtrlsBgAlpha;
			_bg = new Rect();
			_bg.fillColor = bgColor;			_bg.fillAlpha = bgAlpha;			_bg.cornerRadius = BG_CORNER_RADIUS;
			_sprite.addChild(_bg);
			
			
			var btnColor : int = _settings.mediaCtrlsColor;
			var btnAlpha : Number = _settings.mediaCtrlsAlpha;
			
			var prevBtnRect : Rectangle = ctrls.prevBtnRect;
			_prevBtn = new Btn(prevBtnRect.width, prevBtnRect.height, "prevBtn", btnColor);
			_prevBtn.alpha = btnAlpha;
			_sprite.addChild(_prevBtn);
			
			var startStopBtnRect : Rectangle = ctrls.startStopBtnRect;
			_startStopBtn = new Btn(startStopBtnRect.width, startStopBtnRect.height, "startStopSlideShowBtn", btnColor);
			_startStopBtn.alpha = btnAlpha;
			_startStopBtn.curLabel = _mediaManager.autoplay == true ? STOP : START;
			_sprite.addChild(_startStopBtn);
			
			var nextBtnRect : Rectangle = ctrls.nextBtnRect;
			_nextBtn = new Btn(nextBtnRect.width, nextBtnRect.height, "nextBtn", btnColor);
			_nextBtn.alpha = btnAlpha;
			_sprite.addChild(_nextBtn);
			
			
			_prevBtn.addEventListener(PREV, btnsHandler);
			_startStopBtn.addEventListener(START, btnsHandler);
			_startStopBtn.addEventListener(STOP, btnsHandler);
			_nextBtn.addEventListener(NEXT, btnsHandler);
			
			updateRect();
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		override protected function updateRect() : void {
			super.updateRect();
			
			var ctrls : Ctrls = _model as Ctrls;
			var width : Number = ctrls.width;			var height : Number = ctrls.height;
			
			_bg.width = width;			_bg.height = height;			
			var prevBtnRect : Rectangle = ctrls.prevBtnRect;
			_prevBtn.x = prevBtnRect.x;
			_prevBtn.y = prevBtnRect.y;			_prevBtn.width = prevBtnRect.width;			_prevBtn.height = prevBtnRect.height;
			
			var playPauseBtnRect : Rectangle = ctrls.startStopBtnRect;
			_startStopBtn.x = playPauseBtnRect.x;
			_startStopBtn.y = playPauseBtnRect.y;
			_startStopBtn.width = playPauseBtnRect.width;
			_startStopBtn.height = playPauseBtnRect.height;
			
			var nextBtnRect : Rectangle = ctrls.nextBtnRect;
			_nextBtn.x = nextBtnRect.x;
			_nextBtn.y = nextBtnRect.y;
			_nextBtn.width = nextBtnRect.width;
			_nextBtn.height = nextBtnRect.height;
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private function btnsHandler(event : Event) : void {
			switch (event.type) {
				case START:
					_mediaManager.autoplay = true;
					var mediaType : String = _mediaLoader.type;
					var isVideo : Boolean = ((mediaType == MediaLoader.MEDIA_TYPE_VIDEO_HTTP) || (mediaType == MediaLoader.MEDIA_TYPE_VIDEO_YOUTUBE)) ? true : false;
					if (isVideo == false) {
						_mediaManager.startCountDown();
					}
					break;
				case STOP:
					_mediaManager.autoplay = false;
					break;
				case PREV:
					_mediaManager.index--;
					break;
				case NEXT:
					_mediaManager.index++;
					break;
			}
		}
	}
}
