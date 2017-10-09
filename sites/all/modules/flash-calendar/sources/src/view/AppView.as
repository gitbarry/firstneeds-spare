package view {
	import graphics.Rect;

	import model.App;
	import model.Settings;

	import view.dates.DatesView;
	import view.header.HeaderView;

	import flash.display.Sprite;
	import flash.geom.Rectangle;

	/**
	 * @author Robert Soghbatyan (robert.sogbatyan@gmail.com)
	 */
	public class AppView extends ContainerView {
		////////////////////////////////////////////////////////////////////////////////////////
		// Events                                                                             //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private const BG_STROKE_WIDTH : Number = 2;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private var _settings : Settings;

		private var _bg : Rect;

		private var _contentSprite : Sprite;
		private var _contentSpriteMask : Rect;

		private var _headerView : HeaderView;
		private var _datesView : DatesView;
		private var _footerView : FooterView;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		public function AppView(app : App) : void {
			super(app);
			
			_settings = _controller.settings;
			
			_bg = new Rect();
			_bg.strokeWidth = BG_STROKE_WIDTH;
			_bg.strokeColor = _settings.strokeColor;
			_bg.strokeAlpha = 1;
			_bg.fillType = Rect.FILL_TYPE_LINEAR;
			_bg.fillGradColors = _settings.bgColors;			_bg.fillGradAlphas = [1, 1];			_bg.fillGradRatios = [0, 255];
			_bg.fillGradAngle = 90;
			_bg.cornerRadius = _settings.bgCornerRadius;
			_sprite.addChild(_bg);
			
			_contentSprite = new Sprite();
			_sprite.addChild(_contentSprite);
			_contentSpriteMask = new Rect();
			_contentSpriteMask.strokeWidth = BG_STROKE_WIDTH;
			_contentSpriteMask.strokeAlign = Rect.STROKE_ALIGN_IN;
			_contentSpriteMask.cornerRadius = _settings.bgCornerRadius;
			_sprite.addChild(_contentSpriteMask);
			_contentSprite.mask = _contentSpriteMask;
			
			_headerView = new HeaderView(app.header);
			_contentSprite.addChild(_headerView.sprite);
			
			_datesView = new DatesView(app.dates);
			_contentSprite.addChild(_datesView.sprite);
			
			_footerView = new FooterView(app.footer);
			_contentSprite.addChild(_footerView.sprite);
			
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
			var app : App = _model as App;
			var bgRect : Rectangle = app.bgRect;
			
			_bg.x = bgRect.x;
			_bg.y = bgRect.y;
			_bg.width = bgRect.width;
			_bg.height = bgRect.height;
			
			_contentSpriteMask.x = bgRect.x;			_contentSpriteMask.y = bgRect.y;			_contentSpriteMask.width = bgRect.width;			_contentSpriteMask.height = bgRect.height;
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
	}
}
