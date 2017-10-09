package view {
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author Robert Soghbatyan (robert.sogbatyan@gmail.com)
	 */
	public class View {
		////////////////////////////////////////////////////////////////////////////////////////
		// Events                                                                             //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private var _controller : Controller;
		
		private var _appView : AppView;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		public function View() : void {
			_controller = Controller.getInstance();
			_sprite = new Sprite();
			
			_appView = new AppView(_controller.app);
			_sprite.addChild(_appView.sprite);
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		//sprite
		public function get sprite() : Sprite {
			return _sprite;
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
	}
}