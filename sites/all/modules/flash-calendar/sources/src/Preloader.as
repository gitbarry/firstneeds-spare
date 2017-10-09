package {
	import fileLoader.File;
	import fileLoader.FileLoader;
	import fileLoader.FileLoaderEvent;
	import fileLoader.FileSwf;
	import fileLoader.FileTypes;
	import fileLoader.FileXml;

	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.text.TextField;

	/**
	 * @author Robert Soghbatyan (robert.sogbatyan@gmail.com)
	 */
	public class Preloader extends Sprite {
		////////////////////////////////////////////////////////////////////////////////////////
		// Events                                                                             //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private var _loadingClip : Sprite;
		private var _progress : TextField;
		
		private var _fileLoader : FileLoader;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		public function Preloader() : void {
			this.root.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.root.stage.align = StageAlign.TOP_LEFT;
			//addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			_loadingClip = Library.createSprite("loadingClip");
			_loadingClip.x = (this.stage.stageWidth - _loadingClip.width) / 2;			_loadingClip.y = (this.stage.stageHeight - _loadingClip.height) / 2;
			this.stage.addChild(_loadingClip);
			
			_progress = TextField(_loadingClip.getChildByName("progress"));
			_progress.text = "0%";
			
			
			var paramObj : Object = LoaderInfo(this.root.loaderInfo).parameters;
			var settingsUrl : String = paramObj["settingsUrl"] == undefined ? "" : String(paramObj["settingsUrl"]).split("@").join("&");
			var eventsListUrl : String = paramObj["eventsListUrl"] == undefined ? "" : String(paramObj["eventsListUrl"]).split("@").join("&");
			var langUrl : String = paramObj["langUrl"] == undefined ? "" : String(paramObj["langUrl"]).split("@").join("&");
			var appUrl : String = paramObj["swfUrl"] == undefined ? "calendar.swf" : String(paramObj["swfUrl"]).split("@").join("&");
			var settingsFile : File = File.createFile(FileTypes.XML, "settings", settingsUrl);			var eventsListFile : File = File.createFile(FileTypes.XML, "eventsList", eventsListUrl);			var langFile : File = File.createFile(FileTypes.XML, "lang", langUrl);
			var appFile : File = File.createFile(FileTypes.SWF, "app", appUrl);
			
			_fileLoader = new FileLoader();
			_fileLoader.addEventListener(FileLoaderEvent.PROGRESS, progressHandler);			_fileLoader.addEventListener(FileLoaderEvent.FILE_LOADING_FAILED, fileLoadingFailedHandler);			_fileLoader.addEventListener(FileLoaderEvent.ALL_FILES_LOADING_COMPLETED, loadingCompleteHandler);
			
			_fileLoader.add(settingsFile);			_fileLoader.add(eventsListFile);			_fileLoader.add(langFile);			_fileLoader.add(appFile);
			
			_fileLoader.load();
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
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private function addedToStageHandler(event : Event) : void {
			this.root.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.root.stage.align = StageAlign.TOP_LEFT;
		}
		
		private function progressHandler(event : FileLoaderEvent) : void {
			_progress.text = _fileLoader.percentLoaded + "%";
		}

		private function fileLoadingFailedHandler(event : FileLoaderEvent) : void {
		}

		private function loadingCompleteHandler(event : FileLoaderEvent) : void {
			this.stage.removeChild(_loadingClip);
			
			var settingsFile : FileXml = FileXml(_fileLoader.getFileById("settings"));
			var settingsXml : XML;
			if (settingsFile != null) {
				settingsXml = settingsFile.xml;
			} else {
				settingsXml = new XML();
			}
						var eventsListXml : XML = FileXml(_fileLoader.getFileById("eventsList")).xml;			var langXml : XML = FileXml(_fileLoader.getFileById("lang")).xml;
			
			var app : DisplayObject = FileSwf(_fileLoader.getFileById("app")).displayObject;
			this.stage.addChild(app);
			app["init"](settingsXml, eventsListXml, langXml);
		}
	}
}
