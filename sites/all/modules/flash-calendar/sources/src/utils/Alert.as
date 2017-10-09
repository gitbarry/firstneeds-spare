package utils {
	import graphics.Rect;

	import uiElements.text.AdvancedTextField;

	import flash.display.Sprite;
	import flash.text.TextFieldAutoSize;

	/**
	 * @author Robert Soghbatyan (robert.sogbatyan@gmail.com)
	 */
	public class Alert extends Sprite {
		////////////////////////////////////////////////////////////////////////////////////////
		// Events                                                                             //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private static const PADDING : Number = 50;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private var _width : Number;		private var _height : Number;
		
		private var _bg : Rect;
		
		private var _msg : AdvancedTextField;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		public function Alert(font : String = "Verdana", fontSize : Object = 12, fontColor : int = 0xffffff, bgColor : int = 0x000000, bgAlpha : Number = 0.5, bgCornerRadius : Number = 0) : void {
			_width = 1;			_height = 1;
			
			_bg = new Rect(_width, _height);
			_bg.fillColor = bgColor;			_bg.fillAlpha = bgAlpha;			_bg.cornerRadius = bgCornerRadius;
			addChild(_bg);
			
			_msg = new AdvancedTextField(font, fontSize, fontColor);
			_msg.multiline = false;
			_msg.wordWrap = false;
			_msg.autoSize = TextFieldAutoSize.CENTER;
			addChild(_msg);
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		public override function set width(width : Number) : void {
			_width = width;
			update();
		}
		
		public override function set height(height : Number) : void {
			_height = height;
			update();
		}
		
		public function set msg(msg : String) : void {
			_msg.text = msg;
			update();
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		private function update() : void {
			_bg.width = _width;			_bg.height = _height;			
			_msg.width = _msg.textWidth < _width ? _msg.textWidth : _width ;
			_msg.x = _width / 2 - _msg.width / 2;
			_msg.y = _height / 2 - _msg.textHeight / 2;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
	}
}
