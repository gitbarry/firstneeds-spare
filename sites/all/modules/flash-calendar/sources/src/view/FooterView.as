package view {
	import graphics.Line;

	import model.App;
	import model.Footer;
	import model.Settings;

	import realTimeTweener.RealTimeTweener;

	import uiElements.Btn;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	/**
	 * @author Robert Soghbatyan (robert.sogbatyan@gmail.com)
	 */
	public class FooterView extends ContainerView {
		////////////////////////////////////////////////////////////////////////////////////////
		// Events                                                                             //
		////////////////////////////////////////////////////////////////////////////////////////
		public static const MINIMIZE : String = "minimize";
		public static const MAXIMIZE : String = "maximize";

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private const DIV_STROKE_WIDTH : Number = 2;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private var _settings : Settings;

		private var _watermark : Sprite;

		private var _div : Line;
		private var _btnScale : Btn;

		private var _divTweener : RealTimeTweener;
		private var _btnScaleTweener : RealTimeTweener;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////

		public function FooterView(footer : Footer) : void {
			super(footer);
			
			_settings = _controller.settings;
			
			var width : Number = footer.width;
			var height : Number = footer.height;
			
			var btnScaleColor : int = _settings.footerColor;
			_btnScale = new Btn(height, height, "btnScale", btnScaleColor);
			_btnScale.curLabel = _controller.app.viewSize == Settings.VIEW_SIZE_MIN ? MAXIMIZE : MINIMIZE;
			_btnScale.x = width - height;
			_sprite.addChild(_btnScale);
			
			var divColor : int = _settings.strokeColor;
			_div = new Line(0, 0, 0, height, DIV_STROKE_WIDTH, divColor, 1);
			_div.x = width - height;
			_sprite.addChild(_div);
			
			if ((Controller.FREE_VERSION == true) && (Controller.DRUPAL == false)) {
				_watermark = Library.createSprite("watermark");
				_watermark.buttonMode = true;
				_watermark.addEventListener(MouseEvent.CLICK, watermarkClickHandler);
				_sprite.addChild(_watermark);
			}
			
			_divTweener = new RealTimeTweener(_div, _controller.stage);
			_divTweener.multiplier = Settings.REAL_TIME_TWEENER_MULTIPLIER;
			_btnScaleTweener = new RealTimeTweener(_btnScale, _controller.stage);
			_btnScaleTweener.multiplier = Settings.REAL_TIME_TWEENER_MULTIPLIER;
			
			_btnScale.addEventListener(MINIMIZE, scaleBtnHandler);
			_btnScale.addEventListener(MAXIMIZE, scaleBtnHandler);
			
			_controller.app.addEventListener(App.VIEW_SIZE_CHANGED, viewSizeChangedHandler);
			_controller.app.addEventListener(App.VIEW_STATE_CHANGED, viewStateChangedHandler);
			
			updateRect();
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
			
			var width : Number = _model.width;
			var height : Number = _model.height;
			
			_btnScale.x = width - height;
			_div.x = width - height;
		}
		
		private function hideBtnScale() : void {
			_btnScale.disable();
			
			_divTweener.tween("alpha", 0);
			_btnScaleTweener.tween("alpha", 0);
		}

		private function showBtnScale() : void {
			_btnScale.enable();
			
			_divTweener.tween("alpha", 1);
			_btnScaleTweener.tween("alpha", 1);
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private function scaleBtnHandler(event : Event) : void {
			_controller.app.viewSize = event.type == MINIMIZE ? Settings.VIEW_SIZE_MIN : Settings.VIEW_SIZE_MAX;
		}

		private function viewSizeChangedHandler(event : Event) : void {
			_btnScale.curLabel = _controller.app.viewSize == Settings.VIEW_SIZE_MIN ? MAXIMIZE : MINIMIZE;
		}

		private function viewStateChangedHandler(event : Event) : void {
			_controller.app.viewState == Settings.VIEW_STATE_EVENT ? hideBtnScale() : showBtnScale();
		}

		private function watermarkClickHandler(event : MouseEvent) : void {
			navigateToURL(new URLRequest(Controller.WATERMARK_URL));
		}
	}
}
