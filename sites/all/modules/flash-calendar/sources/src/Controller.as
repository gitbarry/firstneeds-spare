package {
	import model.App;
	import model.Calendar;
	import model.Lang;
	import model.Settings;

	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.EventDispatcher;

	/**
	 * @author Robert Soghbatyan (robert.sogbatyan@gmail.com)
	 */
	 
	/* Controller
	 * 
	 * func init - getting settings and events list xml urls, and initing settings. When settings are inited, initing
	 * events list. Once items list inited, initing view
	 */
	 
	public class Controller extends EventDispatcher {
		////////////////////////////////////////////////////////////////////////////////////////
		// Events                                                                             //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		public static const FREE_VERSION : Boolean = true;
		public static const DRUPAL : Boolean = true;
		public static const WATERMARK_URL : String = "http://webdorado.org/files/fromSpiderFC.php";
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private static var INSTANCE : Controller; //instance of controller
		
		private var _stage : Stage;
		
		private var _settings : Settings;
		private var _calendar : Calendar;
		private var _lang : Lang;
		
		private var _app : App;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		public function Controller() : void {
		}

		public static function getInstance() : Controller {
			if (INSTANCE == null) {
				INSTANCE = new Controller();
			}
			return INSTANCE;
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		public function init(stage : Stage, settingsXml : XML, eventsXml : XML, langXml : XML) : void {
			_stage = stage;
			_stage.scaleMode = StageScaleMode.NO_SCALE;
			_stage.align = StageAlign.TOP_LEFT;
			
			_settings = new Settings(settingsXml);
			_calendar = new Calendar(eventsXml);
			_lang = new Lang(langXml);
			
			_app = new App();
			_app.init();
		}



		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		//stage
		public function get stage() : Stage {
			return _stage;
		}
		
		//calendar
		public function get calendar() : Calendar {
			return _calendar;
		}
		
		//settings
		public function get settings() : Settings {
			return _settings;
		}
		
		//lang
		public function get lang() : Lang {
			return _lang;
		}
		
		public function get app() : App {
			return _app;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
	}
}
