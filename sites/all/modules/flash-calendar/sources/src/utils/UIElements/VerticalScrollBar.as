package utils.UIElements {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author Robert Soghbatyan (robert.sogbatyan@gmail.com)
	 */
	public class VerticalScrollBar extends Sprite {
		////////////////////////////////////////////////////////////////////////////////////////
		// Events                                                                             //
		////////////////////////////////////////////////////////////////////////////////////////
		public static const LEVEL_CHANGED : String = "levelChanged";

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private var _width : Number;		private var _height : Number;

		private var _bg : DisplayObject;
		private var _head : DisplayObject;

		private var _level : Number;

		private var _mouseOffsetY : Number;
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		public function VerticalScrollBar() : void {
			var skin : Sprite = Library.createSprite("verticalScrollBar");
			addChild(skin);
			_bg = skin.getChildByName("bg");
			_width = _bg.width;			_head = skin.getChildByName("head");
			_head.y = 0;
			
			_head.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			
			addEventListener(Event.ADDED, addedHandler);
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		public function enable() : void {
			this.visible = true;
		}

		public function disable() : void {
			this.visible = false;
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		public override function get width() : Number {
			return _width;
		}

		public override function get height() : Number {
			return _height;
		}

		public override function set height(height : Number) : void {
			_height = height;
			update();
		}

		public function get level() : Number {
			return _level;
		}

		public function set level(level : Number) : void {
			_level = level;
			updateHeadY();
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		private function update() : void {
			_bg.height = _height;
		}

		private function updateHeadY() : void {
			_head.y = (_height - _head.height) * _level;
		}

		private function updateLevel() : void {
			_level = _head.y / (_height - _head.height);
			dispatchEvent(new Event(LEVEL_CHANGED));
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private function addedHandler(event : Event) : void {
			if (this.parent != null) {
				this.parent.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
			}
		}

		private function mouseWheelHandler(event : MouseEvent) : void {
			if (this.visible == false) {
				return;
			}
			
			var y : Number = _head.y;
			y -= event.delta * _height / 100;
			
			if (y < 0) {
				y = 0;
			} else if (y > _height - _head.height) {
				y = _height - _head.height;
			}
			
			_head.y = y;
			updateLevel();
		}

		
		private function mouseDownHandler(event : MouseEvent) : void {
			_mouseOffsetY = this.mouseY - _head.y;
			_head.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);			_head.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}

		private function mouseUpHandler(event : MouseEvent) : void {
			_head.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			_head.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}

		private function mouseMoveHandler(event : MouseEvent) : void {
			var y : Number = this.mouseY - _mouseOffsetY;
			if (y < 0) {
				y = 0;
			} else if (y > _height - _head.height) {
				y = _height - _head.height;
			}
			
			_head.y = y;
			updateLevel();
		}
	}
}
