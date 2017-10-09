package {
	import flash.events.Event;
	import view.View;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	/**
	 * @author Robert Soghbatyan (robert.sogbatyan@gmail.com)
	 */
	 
	/* Calendar (Document class)
	 * constructor - getting settings and items list xml urls. creating view and initing controller
	 */
	public class Organizer extends Sprite {
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private var _controller : Controller; //instance of controller
		private var _view : View;		


		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		public function Organizer() : void {
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}

		public function init(settingsXml : XML, eventsListXml : XML, langXml : XML) : void {
			_controller = Controller.getInstance();
			_controller.init(this.root.stage, settingsXml, eventsListXml, langXml);
			
			_view = new View();
			this.root.stage.addChild(_view.sprite);
		}

		private function addedToStageHandler(event : Event) : void {
			this.root.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.root.stage.align = StageAlign.TOP_LEFT;
		}
	}
}