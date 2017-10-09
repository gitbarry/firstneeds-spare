package view.dates.eventsList.singleEvent.mediaSlider {
	import graphics.Rect;

	import model.Settings;
	import model.dates.eventsList.singleEvent.mediaSlider.MediaManager;
	import model.dates.eventsList.singleEvent.mediaSlider.MediaSlider;

	import realTimeTweener.RealTimeTweener;

	import uiElements.media.Video.VideoLoaderEvent;
	import uiElements.mediaLoader.MediaLoader;

	import utils.Alert;

	import view.ContainerView;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author Robert Soghbatyan (robert.sogbatyan@gmail.com)
	 */
	public class MediaSliderView extends ContainerView {
		////////////////////////////////////////////////////////////////////////////////////////
		// Events                                                                             //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		public static const TYPE_IMG : String = "img";
		public static const TYPE_VIDEO_HTTP : String = "vidHttp";
		public static const TYPE_VIDEO_YOUTUBE : String = "vidYoutube";
		
		private static const MEDIA_NOT_FOUND_MSG : String = "Media Not Found";

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private var _settings : Settings;

		private var _mediaManager : MediaManager;
		private var _mediaLoader : MediaLoader;
		
		private var _alert : Alert;

		private var _clipsSprite : Sprite;
		private var _loadingClip : MovieClip;
		private var _playClip : MovieClip;

		private var _ctrlsView : CtrlsView;
		private var _vidCtrlsView : VidCtrlsView;

		private var _spriteTweener : RealTimeTweener;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		public function MediaSliderView(mediaSlider : MediaSlider) : void {
			super(mediaSlider);
			
			_settings = _controller.settings;
			
			_mediaManager = mediaSlider.mediaManager;
			_mediaLoader = new MediaLoader();
			_mediaLoader.scaleType = _settings.mediaScaleType;
			_mediaLoader.videoLoader.autoplay = _settings.videoAutoplay;
			_mediaLoader.videoLoader.vol = _settings.videoDefaultVolume;
			_mediaLoader.videoLoader.posUpdateTime = 1000;
			var bg : Rect = _mediaLoader.bg;
			bg.fillColor = _settings.mediaBgColor;
			_sprite.addChild(_mediaLoader);
			
			_alert = new Alert(Settings.FONT);
			_alert.msg = MEDIA_NOT_FOUND_MSG;
			_alert.visible = false;
			_sprite.addChild(_alert);
			
			_clipsSprite = new Sprite();
			_sprite.addChild(_clipsSprite);
			_loadingClip = Library.createMC("loadingAnimClip");
			_playClip = Library.createMC("playClip");
			_playClip.buttonMode = true;
			
			_ctrlsView = new CtrlsView(mediaSlider.ctrls, _mediaManager, _mediaLoader);
			_sprite.addChild(_ctrlsView.sprite);
			
			_vidCtrlsView = new VidCtrlsView(mediaSlider.vidCtrls, _mediaLoader.videoLoader);
			_sprite.addChild(_vidCtrlsView.sprite);
			
			_spriteTweener = new RealTimeTweener(_sprite, _controller.stage);
			_spriteTweener.multiplier = Settings.REAL_TIME_TWEENER_MULTIPLIER;
			
			mediaSlider.addEventListener(MediaSlider.VISIBILITY_CHANGED, visibilityChangedHandler);
			
			_mediaManager.addEventListener(MediaManager.ITEM_CHANGED, itemChangedHandler);
			_mediaManager.addEventListener(MediaManager.CLEAR, mediaClearHandler);
			
			_mediaLoader.addEventListener(MediaLoader.STATE_CHANGED, mediaLoaderHandler);
			_mediaLoader.addEventListener(MediaLoader.LOADING_FAILED, mediaLoaderHandler);
			
			_mediaLoader.videoLoader.addEventListener(VideoLoaderEvent.VIDEO_PLAY, videoLoaderHandler);
			_mediaLoader.videoLoader.addEventListener(VideoLoaderEvent.VIDEO_SEEK, videoLoaderHandler);
			_mediaLoader.videoLoader.addEventListener(VideoLoaderEvent.VIDEO_BUFFER_EMPTY, videoLoaderHandler);
			_mediaLoader.videoLoader.addEventListener(VideoLoaderEvent.VIDEO_BUFFER_FULL, videoLoaderHandler);
			_mediaLoader.videoLoader.addEventListener(VideoLoaderEvent.VIDEO_END, videoLoaderHandler);
			
			_playClip.addEventListener(MouseEvent.CLICK, playClickHandler);
			
			updateRect();
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
			super.updateRect();
			
			var mediaSlider : MediaSlider = _model as MediaSlider;
			var width : Number = mediaSlider.width;
			var height : Number = mediaSlider.height;
			
			_mediaLoader.width = width;
			_mediaLoader.height = height;
			
			_alert.width = width;
			_alert.height = height;
			
			_clipsSprite.x = width / 2;
			_clipsSprite.y = height / 2;
		}

		private function updateVisibility() : void {
			var mediaSlider : MediaSlider = _model as MediaSlider;
			var isVisible : Boolean = mediaSlider.isVisible;

            if (isVisible == false) {
                hideClips();
            }
			
			_sprite.mouseEnabled = isVisible;
			_sprite.mouseChildren = isVisible;
			var destAlpha : Number = isVisible == true ? 1 : 0;
			
			_spriteTweener.tween("alpha", destAlpha);
		}

		private function updateMedia() : void {
			_alert.visible = false;
			
			var type : String = _mediaManager.curItemType;
			var url : String = _mediaManager.curItemUrl;
			
			switch (type) {
				case TYPE_IMG:
					type = MediaLoader.MEDIA_TYPE_IMAGE;
					break;
				case TYPE_VIDEO_HTTP:
					type = MediaLoader.MEDIA_TYPE_VIDEO_HTTP;
					break;
				case TYPE_VIDEO_YOUTUBE:
					type = MediaLoader.MEDIA_TYPE_VIDEO_YOUTUBE;
					break;
			}
			_mediaLoader.load(type, url);
		}

		private  function showLoadingClip() : void {
			_alert.visible = false;
			hideClips();
			_clipsSprite.addChild(_loadingClip);
		}

		private  function showPlayClip() : void {
			_alert.visible = false;
			hideClips();
			_clipsSprite.addChild(_playClip);
		}

		private function hideClips() : void {
			while (_clipsSprite.numChildren > 0) {
				_clipsSprite.removeChildAt(0);
			}
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private function visibilityChangedHandler(event : Event) : void {
			updateVisibility();
		}

		private function itemChangedHandler(event : Event) : void {
			updateMedia();
		}

		private function mediaClearHandler(event : Event) : void {
			_mediaLoader.clear();
		}

		private function mediaLoaderHandler(event : Event) : void {
			var mediaType : String = _mediaLoader.type;
			var isVideo : Boolean = (mediaType == MediaLoader.MEDIA_TYPE_VIDEO_HTTP) || (mediaType == MediaLoader.MEDIA_TYPE_VIDEO_YOUTUBE) ? true : false;
			
			if (event.type == MediaLoader.LOADING_FAILED) {
				//TODO
				hideClips();
				_alert.visible = true;
				_mediaManager.startCountDown();
				return;
			} else {
				_alert.visible = false;
			}
			
			var state : String = _mediaLoader.state;
			
			switch (state) {
				case MediaLoader.STATE_LOADING:
					showLoadingClip();
					break;
				case MediaLoader.STATE_LOADED:
					hideClips();
					if ((isVideo == true) && (_mediaLoader.videoLoader.autoplay == false)) {
						showPlayClip();
					}
					_mediaManager.startCountDown();
					break;
			}
		}

		private function videoLoaderHandler(event : VideoLoaderEvent) : void {
			switch (event.type) {
				case VideoLoaderEvent.VIDEO_PLAY:
					_alert.visible = false;
					hideClips();
					_mediaManager.stopCountDown();
					break;
				case VideoLoaderEvent.VIDEO_SEEK:
					_alert.visible = false;
					hideClips();
					_mediaManager.stopCountDown();
					break;
				case VideoLoaderEvent.VIDEO_BUFFER_EMPTY:
					_alert.visible = false;
					showLoadingClip();
					break;
				case VideoLoaderEvent.VIDEO_BUFFER_FULL:
					_alert.visible = false;
					if (_loadingClip.parent != null) {
						hideClips();
					}
					break;
				case VideoLoaderEvent.VIDEO_END:
					_alert.visible = false;
					_mediaLoader.videoLoader.stop();
                    hideClips();
					showPlayClip();
					_mediaManager.startCountDown();
					break;
			}
		}

		private function playClickHandler(event : MouseEvent) : void {
			_mediaLoader.videoLoader.play();
		}
	}
}
