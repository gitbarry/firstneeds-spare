package view.dates.eventsList.singleEvent.mediaSlider {
	import uiElements.media.Video.VideoLoaderEvent;

	import graphics.Rect;

	import model.Settings;
	import model.dates.eventsList.singleEvent.mediaSlider.VidCtrls;

	import realTimeTweener.RealTimeTweener;

	import uiElements.Btn;
	import uiElements.media.StreamEvent;
	import uiElements.media.Video.VideoLoader;

	import utils.UIElements.Scrubber;

	import view.ContainerView;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

	/**
	 * @author User
	 */
	public class VidCtrlsView extends ContainerView {
		////////////////////////////////////////////////////////////////////////////////////////
		// Events                                                                             //
		////////////////////////////////////////////////////////////////////////////////////////
		public static const PLAY : String = "play";
		public static const PAUSE : String = "pause";

		public static const VOL_ON : String = "volOn";
		public static const VOL_OFF : String = "volOff";
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private static const BG_CORNER_RADIUS : Number = 5;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private var _settings : Settings;

		private var _videoLoader : VideoLoader;

		private var _isOpened : Boolean;

		private var _vidCtrlsSprite : Sprite;
		private var _vidCtrlsSpriteMask : Rect;

		private var _bg : Rect;

		private var _playPauseBtn : Btn;		private var _vidSlide : Scrubber;		private var _volBtn : Btn;		private var _volSlide : Scrubber;

		private var _vidCtrlsSpriteTweener : RealTimeTweener;

		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////

		public function VidCtrlsView(vidCtrls : VidCtrls, videoLoader : VideoLoader) : void {
			super(vidCtrls);
			
			_settings = _controller.settings;
			
			_videoLoader = videoLoader;
			
			_vidCtrlsSprite = new Sprite;
			_sprite.addChild(_vidCtrlsSprite);
			
			_vidCtrlsSpriteMask = new Rect();			_vidCtrlsSpriteMask.cornerRadius = BG_CORNER_RADIUS;
			_sprite.addChild(_vidCtrlsSpriteMask);
			_vidCtrlsSprite.mask = _vidCtrlsSpriteMask;
			
			var bgColor : int = _settings.mediaCtrlsBgColor;
			var bgAlpha : Number = _settings.mediaCtrlsBgAlpha;
			_bg = new Rect();
			_bg.fillColor = bgColor;			_bg.fillAlpha = bgAlpha;			_bg.cornerRadius = BG_CORNER_RADIUS;
			_vidCtrlsSprite.addChild(_bg);
			
			var btnColor : int = _settings.mediaCtrlsColor;			var btnHoverColor : int = ColorUtils.lighten(btnColor, 0.2);
			var btnAlpha : Number = _settings.mediaCtrlsAlpha;
			
			var playPauseBtnRect : Rectangle = vidCtrls.playPauseBtnRect;
			_playPauseBtn = new Btn(playPauseBtnRect.width, playPauseBtnRect.height, "playPauseBtn", btnColor);
			_playPauseBtn.alpha = btnAlpha;
			_playPauseBtn.curLabel = _videoLoader.isPlaying == true ? PAUSE : PLAY;
			_vidCtrlsSprite.addChild(_playPauseBtn);
			
			var vidSlideRect : Rectangle = vidCtrls.vidSlideRect;
			_vidSlide = new Scrubber(vidSlideRect.width, vidSlideRect.height, "slide", -1, -1, 0, btnColor, btnColor, btnHoverColor, btnAlpha);
			_vidCtrlsSprite.addChild(_vidSlide);
			
			var volBtnRect : Rectangle = vidCtrls.volBtnRect;
			_volBtn = new Btn(volBtnRect.width, volBtnRect.height, "volBtn", btnColor);
			_volBtn.alpha = btnAlpha;
			_volBtn.curLabel = _videoLoader.vol == 0 ? VOL_ON : VOL_OFF;
			_vidCtrlsSprite.addChild(_volBtn);
			
			var volSlideRect : Rectangle = vidCtrls.volSlideRect;
			_volSlide = new Scrubber(volSlideRect.width, volSlideRect.height, "slide", -1, -1, 0, btnColor, btnColor, btnHoverColor, btnAlpha);
			_volSlide.level = _videoLoader.vol;
			_vidCtrlsSprite.addChild(_volSlide);
			
			_vidCtrlsSprite.x = -vidCtrls.width - 5;
			_sprite.mouseEnabled = false;			_sprite.mouseChildren = false;
			
			_vidCtrlsSpriteTweener = new RealTimeTweener(_vidCtrlsSprite, _controller.stage);			_vidCtrlsSpriteTweener.multiplier = Settings.REAL_TIME_TWEENER_MULTIPLIER;
			
			_playPauseBtn.addEventListener(PLAY, btnsHandler);			_playPauseBtn.addEventListener(PAUSE, btnsHandler);
			_vidSlide.addEventListener(Scrubber.DRAG_STARTED, vidSlideHandler);			_vidSlide.addEventListener(Scrubber.DRAG_ENDED, vidSlideHandler);			_volBtn.addEventListener(VOL_ON, btnsHandler);
			_volBtn.addEventListener(VOL_OFF, btnsHandler);			_volSlide.addEventListener(Scrubber.LEVEL_CHANGED, volSlideHandler);
			
			_videoLoader.addEventListener(VideoLoaderEvent.VIDEO_START, videoLoaderHandler);			_videoLoader.addEventListener(VideoLoaderEvent.VIDEO_CLEAR, videoLoaderHandler);			_videoLoader.addEventListener(VideoLoaderEvent.VIDEO_PLAY, videoLoaderHandler);			_videoLoader.addEventListener(VideoLoaderEvent.VIDEO_PLAY, videoLoaderHandler);			_videoLoader.addEventListener(VideoLoaderEvent.VIDEO_PAUSE, videoLoaderHandler);			_videoLoader.addEventListener(VideoLoaderEvent.VIDEO_STOP, videoLoaderHandler);			_videoLoader.addEventListener(VideoLoaderEvent.VIDEO_SEEK, videoLoaderHandler);			_videoLoader.addEventListener(VideoLoaderEvent.VIDEO_VOL, videoLoaderHandler);
			
			updateRect();
			updateIsOpened();
			_vidCtrlsSpriteTweener.finishAll();
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
			
			var vidCtrls : VidCtrls = _model as VidCtrls;
			var width : Number = vidCtrls.width;			var height : Number = vidCtrls.height;
			
			_vidCtrlsSpriteMask.width = width;			_vidCtrlsSpriteMask.height = height;			
			_bg.width = width;			_bg.height = height;			
			var playPauseBtnRect : Rectangle = vidCtrls.playPauseBtnRect;
			if (playPauseBtnRect.width == 0) {
				if (_playPauseBtn.parent != null) {
					_playPauseBtn.parent.removeChild(_playPauseBtn);
				}
			} else {
				_vidCtrlsSprite.addChild(_playPauseBtn);
				_playPauseBtn.width = playPauseBtnRect.width;				_playPauseBtn.height = playPauseBtnRect.height;
				_playPauseBtn.x = playPauseBtnRect.x;
				_playPauseBtn.y = playPauseBtnRect.y;
			}
			
			var vidSlideRect : Rectangle = vidCtrls.vidSlideRect;
			if (vidSlideRect.width == 0) {
				if (_vidSlide.parent != null) {
					_vidSlide.parent.removeChild(_vidSlide);
				}
			} else {
				_vidCtrlsSprite.addChild(_vidSlide);
				_vidSlide.width = vidSlideRect.width;
				_vidSlide.height = vidSlideRect.height;
				_vidSlide.x = vidSlideRect.x;
				_vidSlide.y = vidSlideRect.y;
			}
			
			var volBtnRect : Rectangle = vidCtrls.volBtnRect;
			if (volBtnRect.width == 0) {
				if (_volBtn.parent != null) {
					_volBtn.parent.removeChild(_volBtn);
				}
			} else {
				_vidCtrlsSprite.addChild(_volBtn);
				_volBtn.width = volBtnRect.width;
				_volBtn.height = volBtnRect.height;
				_volBtn.x = volBtnRect.x;
				_volBtn.y = volBtnRect.y;
			}
			
			var volSlideRect : Rectangle = vidCtrls.volSlideRect;
			if (volSlideRect.width == 0) {
				if (_volSlide.parent != null) {
					_volSlide.parent.removeChild(_volSlide);
				}
			} else {
				_vidCtrlsSprite.addChild(_volSlide);
				_volSlide.width = volSlideRect.width;
				_volSlide.height = volSlideRect.height;
				_volSlide.x = volSlideRect.x;
				_volSlide.y = volSlideRect.y;
			}
			
			updateIsOpened();
			_vidCtrlsSpriteTweener.finishAll();
		}

		private function updateIsOpened() : void {
			var vidCtrls : VidCtrls = _model as VidCtrls;
			
			_sprite.mouseEnabled = _isOpened;
			_sprite.mouseChildren = _isOpened;
			
			_vidCtrlsSpriteTweener.removeAll();
			var destX : Number = _isOpened == true ? 0 : -vidCtrls.width - 5;
			_vidCtrlsSpriteTweener.tween("x", destX);
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private function btnsHandler(event : Event) : void {
			switch (event.type) {
				case PLAY:
					_videoLoader.play();
					break;
				case PAUSE:
					_videoLoader.pause();
					break;
				case VOL_ON:
					_videoLoader.unMute();
					break;
				case VOL_OFF:
					_videoLoader.mute();
					break;
			}
		}

		private function vidSlideHandler(event : Event) : void {
			switch (event.type) {
				case Scrubber.DRAG_STARTED:
					_videoLoader.removeEventListener(VideoLoaderEvent.VIDEO_PAUSE, videoLoaderHandler);
					_videoLoader.removeEventListener(VideoLoaderEvent.VIDEO_SEEK, videoLoaderHandler);
					_videoLoader.pause();
					_vidSlide.addEventListener(Scrubber.LEVEL_CHANGED, vidSlideHandler);
					break;
				case Scrubber.DRAG_ENDED:
					_vidSlide.removeEventListener(Scrubber.LEVEL_CHANGED, vidSlideHandler);
					_videoLoader.addEventListener(VideoLoaderEvent.VIDEO_PAUSE, videoLoaderHandler);
					_videoLoader.addEventListener(VideoLoaderEvent.VIDEO_SEEK, videoLoaderHandler);
					if (_playPauseBtn.curLabel == PAUSE) {
						_videoLoader.play();
					}
					break;
				case Scrubber.LEVEL_CHANGED:
					if (_vidSlide.level < 1) {
						_videoLoader.seekToPos(_vidSlide.level);
					}
					break;
			}
		}

		private function volSlideHandler(event : Event) : void {
			_videoLoader.vol = _volSlide.level;
		}

		private function videoLoaderHandler(event : Event) : void {
			switch (event.type) {
				case VideoLoaderEvent.VIDEO_START:
					_isOpened = true;
					updateIsOpened();
					break;
				case VideoLoaderEvent.VIDEO_CLEAR:
					_isOpened = false;
					_vidSlide.level = 0;
					updateIsOpened();
					break;
				case VideoLoaderEvent.VIDEO_PLAY:
					_playPauseBtn.curLabel = PAUSE;
					break;
				case VideoLoaderEvent.VIDEO_PAUSE:
					_playPauseBtn.curLabel = PLAY;
					break;
				case VideoLoaderEvent.VIDEO_STOP:
					_playPauseBtn.curLabel = PLAY;
					_vidSlide.level = 0;
					break;
				case VideoLoaderEvent.VIDEO_SEEK:
					_vidSlide.level = _videoLoader.pos;
					break;
				case VideoLoaderEvent.VIDEO_VOL:
					_volSlide.level = _videoLoader.vol;
					_volBtn.curLabel = _videoLoader.vol == 0 ? VOL_ON : VOL_OFF;
					break;
			}
		}
	}
}
