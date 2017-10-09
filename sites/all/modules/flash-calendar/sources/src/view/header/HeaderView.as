package view.header {
	import graphics.Rect;

	import model.App;
	import model.Settings;
	import model.header.Header;

	import view.ContainerView;

	import flash.events.Event;
	import flash.geom.Rectangle;

	/**
	 * @author Robert Soghbatyan (robert.sogbatyan@gmail.com)
	 */
	public class HeaderView extends ContainerView {
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

		private var _yearChanger : DateChangerView;
		private var _monthChanger : DateChangerView;		private var _dayChanger : DateChangerView;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		public function HeaderView(header : Header) : void {
			super(header);
			
			_settings = _controller.settings;
			
			_bg = new Rect();
			_bg.strokeWidth = BG_STROKE_WIDTH;
			_bg.strokeColor = _settings.headerBgStrokeColor;
			_bg.fillType = Rect.FILL_TYPE_LINEAR;
			_bg.fillGradColors = _settings.headerBgColors;
			_bg.fillGradAlphas = [1, 1];
			_bg.fillGradRatios = [0, 255];
			_bg.fillGradAngle = 90;
			_sprite.addChild(_bg);
			
			_yearChanger = new DateChangerView(header.yearChanger);
			_sprite.addChild(_yearChanger.sprite);
						_monthChanger = new DateChangerView(header.monthChanger);
			_sprite.addChild(_monthChanger.sprite);
						_dayChanger = new DateChangerView(header.dayChanger);
			_sprite.addChild(_dayChanger.sprite);
			
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
			
			var header : Header = Header(_model);
			var bgRect : Rectangle = header.bgRect;
			
			_bg.x = bgRect.x;			_bg.y = bgRect.y;
			_bg.width = bgRect.width;			_bg.height = bgRect.height;		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
	}
}
