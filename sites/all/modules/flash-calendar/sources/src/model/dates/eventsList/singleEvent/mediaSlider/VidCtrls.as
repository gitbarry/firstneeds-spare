package model.dates.eventsList.singleEvent.mediaSlider {
	import model.Container;
	import model.Settings;

	import flash.geom.Rectangle;

	/**
	 * @author Robert Soghbatyan (robert.sogbatyan@gmail.com)
	 */
	public class VidCtrls extends Container {
		////////////////////////////////////////////////////////////////////////////////////////
		// Events                                                                             //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private const SPACE : Number = 4;
		private const BTN_SIZE : Number = 16;
		private const VOL_SLIDE_WIDTH : Number = 30;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private var _settings : Settings;
		
		private var _playPauseBtnRect : Rectangle;		private var _vidSlideRect : Rectangle;		private var _volBtnRect : Rectangle;		private var _volSlideRect : Rectangle;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		public function VidCtrls() : void {
			super();
			
			_settings = _controller.settings;
			
			_rect.height = BTN_SIZE + 2 * SPACE;
			
			_playPauseBtnRect = new Rectangle();			_vidSlideRect = new Rectangle();			_volBtnRect = new Rectangle();			_volSlideRect = new Rectangle();

			updateRect();
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		override public function set height(height : Number) : void {
			return;
		}

		public function get playPauseBtnRect() : Rectangle {
			return _playPauseBtnRect;
		}

		public function get vidSlideRect() : Rectangle {
			return _vidSlideRect;
		}

		public function get volBtnRect() : Rectangle {
			return _volBtnRect;
		}

		public function get volSlideRect() : Rectangle {
			return _volSlideRect;
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		override protected function updateRect() : void {
			var width : Number = _rect.width;			var height : Number = _rect.height;
			
			if (width < BTN_SIZE + 2 * SPACE) {
				width = 0;
			}
			
			var vidSlideX : Number = BTN_SIZE + 2 * SPACE;
			var vidSlideWidth : Number = width - 2 * BTN_SIZE - VOL_SLIDE_WIDTH - 5 * SPACE;
			vidSlideWidth = vidSlideWidth < 0 ? 0 : vidSlideWidth;
			var volBtnX : Number = vidSlideWidth <= 0 ? vidSlideX : vidSlideX + vidSlideWidth + SPACE;
			var volBtnWidth : Number = (width >= 2 * BTN_SIZE + VOL_SLIDE_WIDTH + 4 * SPACE) ? BTN_SIZE : 0;
			var volSlideX : Number = volBtnWidth < 0 ? volBtnX : volBtnX + volBtnWidth + SPACE;
			var volSlideWidth : Number = width >= BTN_SIZE + VOL_SLIDE_WIDTH + 3 * SPACE ? VOL_SLIDE_WIDTH : 0;
			
			_playPauseBtnRect = new Rectangle(SPACE, SPACE, BTN_SIZE, BTN_SIZE);
			_vidSlideRect = new Rectangle(vidSlideX, SPACE, vidSlideWidth, BTN_SIZE);
			_volBtnRect = new Rectangle(volBtnX, SPACE, volBtnWidth, BTN_SIZE);
			_volSlideRect = new Rectangle(volSlideX, SPACE, volSlideWidth, BTN_SIZE);
			
			super.updateRect();
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
	}
}
