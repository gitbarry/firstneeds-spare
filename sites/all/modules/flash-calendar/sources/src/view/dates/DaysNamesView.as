package view.dates {
	import model.Lang;
	import model.Settings;
	import model.dates.DaysNames;

	import realTimeTweener.RealTimeTweener;

	import uiElements.text.AdvancedTextField;

	import view.ContainerView;

	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;

	/**
	 * @author Robert Soghbatyan (robert.sogbatyan@gmail.com)
	 */
	public class DaysNamesView extends ContainerView {
		////////////////////////////////////////////////////////////////////////////////////////
		// Events                                                                             //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private var _settings : Settings;
		private var _lang : Lang;

		private var _nameTFs : Array;
		
		private var _nameTFTweeners : Array;


		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		public function DaysNamesView(daysNames : DaysNames) : void {
			super(daysNames);
			
			_settings = _controller.settings;
			_lang = _controller.lang;
			
			var daysNamesTexts : Array = daysNames.daysNames;
			var scale : Number = daysNames.scale;
			var dayNameRects : Array = daysNames.dayNameRects;
			var rect : Rectangle;
			
			var font : String = Settings.FONT;
			var fontSize : uint = _settings.daysNamesFontSize;
			var fontColor : int = _settings.daysNamesColor;
			
			_nameTFs = new Array();
			_nameTFTweeners = new Array();
			for (var i : int = 0;i < 7;i++) {
				var tf : AdvancedTextField = new AdvancedTextField(font, fontSize, fontColor);
				tf.autoSize = TextFieldAutoSize.CENTER;
				tf.text = daysNamesTexts[i];
				rect = dayNameRects[i] as Rectangle;
				tf.scaleX = scale;
				tf.scaleY = scale;
				tf.x = rect.x + (rect.width - tf.width) / 2;
				tf.y = rect.y + (rect.height - tf.height) / 2;
				_sprite.addChild(tf);
				_nameTFs[i] = tf;
				
				_nameTFTweeners[i] = new RealTimeTweener(tf, _controller.stage);				(_nameTFTweeners[i] as RealTimeTweener).multiplier = Settings.REAL_TIME_TWEENER_MULTIPLIER;
			}
			
			daysNames.addEventListener(DaysNames.UPDATE_SIZE, updateSizeHandler);			daysNames.addEventListener(DaysNames.UPDATE_VISIBILITY, updateVisibilityHandler);
			
			updateRect();
			updateSize();
			updateVisibility();
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
		}
		
		private function updateSize() : void {
			var daysNames : DaysNames = _model as DaysNames;
			
			var daysNamesTexts : Array = daysNames.daysNames;			var scale : Number = daysNames.scale;
			var dayNameRects : Array = daysNames.dayNameRects;
			var rect : Rectangle;
			
			var tf : AdvancedTextField;
			var tfTweener : RealTimeTweener;
			for (var i : uint = 0; i < _nameTFs.length; i++) {
				tf = _nameTFs[i];
				tf.text = daysNamesTexts[i];
				
				rect = dayNameRects[i] as Rectangle;
				
				tfTweener = _nameTFTweeners[i] as RealTimeTweener;
				tfTweener.tween("scaleX", scale);				tfTweener.tween("scaleY", scale);				tfTweener.tween("x", rect.x + (rect.width - tf.width) / 2);				tfTweener.tween("y", rect.y + (rect.height - tf.height) / 2);
			}
			
			if (daysNames.isVisible == false) {
				tfTweener.finishAll();
			}
		}
		
		private function updateVisibility() : void {
			var daysNames : DaysNames = _model as DaysNames;
			var isVisible : Boolean = daysNames.isVisible;
			
			_sprite.visible = isVisible;
			
			for each (var tfTweener : RealTimeTweener in _nameTFTweeners) {
				tfTweener.finishAll();
			}
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private function updateSizeHandler(event : Event) : void {
			updateSize();
		}

		private function updateVisibilityHandler(event : Event) : void {
			updateVisibility();
		}
	}
}
