package model.dates.eventsList.singleEvent.mediaSlider {
	import model.Container;
	import model.Settings;

	import flash.geom.Rectangle;

	/**
	 * @author Robert Soghbatyan (robert.sogbatyan@gmail.com)
	 */
	public class Ctrls extends Container {
		////////////////////////////////////////////////////////////////////////////////////////
		// Events                                                                             //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private static const SPACE : Number = 4;
		private static const BTN_SIZE : Number = 16;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private var _settings : Settings;
		
		private var _prevBtnRect : Rectangle;		private var _startStopBtnRect : Rectangle;		private var _nextBtnRect : Rectangle;
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		public function Ctrls() : void {
			super();
			
			_settings = _controller.settings;
			
			_rect.width = 3 * BTN_SIZE + 4 * SPACE;
			_rect.height = BTN_SIZE + 2 * SPACE;
			
			_prevBtnRect = new Rectangle(SPACE, SPACE, BTN_SIZE, BTN_SIZE);
			_startStopBtnRect = new Rectangle(2 * SPACE + BTN_SIZE, SPACE, BTN_SIZE, BTN_SIZE);
			_nextBtnRect = new Rectangle(3 * SPACE + 2 * BTN_SIZE, SPACE, BTN_SIZE, BTN_SIZE);
			
			updateRect();
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		override public function set width(width : Number) : void {
			return;
		}

		override public function set height(height : Number) : void {
			return;
		}
		
		public function get prevBtnRect() : Rectangle {
			return _prevBtnRect;
		}
		
		public function get startStopBtnRect() : Rectangle {
			return _startStopBtnRect;
		}
		
		public function get nextBtnRect() : Rectangle {
			return _nextBtnRect;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		override protected function updateRect() : void {
			_prevBtnRect.x = SPACE;			_prevBtnRect.y = SPACE;
			_prevBtnRect.width = BTN_SIZE;			_prevBtnRect.height = BTN_SIZE;
			
			_startStopBtnRect.x = 2 * SPACE + BTN_SIZE;
			_startStopBtnRect.y = SPACE;
			_startStopBtnRect.width = BTN_SIZE;
			_startStopBtnRect.height = BTN_SIZE;
			
			_nextBtnRect.x = 3 * SPACE + 2 * BTN_SIZE;
			_nextBtnRect.y = SPACE;
			_nextBtnRect.width = BTN_SIZE;
			_nextBtnRect.height = BTN_SIZE;
			
			super.updateRect();
		}
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
	}
}
