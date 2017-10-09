package view.dates {
	import graphics.Line;

	import flash.display.Sprite;

	/**
	 * @author Robert Soghbatyan (robert.sogbatyan@gmail.com)
	 */
	public class Grid extends Sprite {
		////////////////////////////////////////////////////////////////////////////////////////
		// Events                                                                             //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		public static const STROKE_WIDTH :Number = 1;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private var _controller : Controller;
				private var _strokeColor : int;

		private var _width : Number;
		private var _height : Number;

		private var _cols : uint;		private var _rows : uint;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		public function Grid() : void {
			_controller = Controller.getInstance();
			
			_strokeColor = _controller.settings.strokeColor;
			
			_width = 0;
			_height = 0;
			
			_cols = 1;
			_rows = 1;
			
			update();
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		override public function get width() : Number {
			return _width;
		}

		override public function set width(width : Number) : void {
			if (_width != width) {
				_width = width;
				update();
			}
		}

		override public function get height() : Number {
			return _height;
		}

		override public function set height(height : Number) : void {
			if (_height != height) {
				_height = height;
				update();
			}
		}

		public function get cols() : uint {
			return _cols;
		}

		public function set cols(cols : uint) : void {
			if (_cols != cols) {
				_cols = cols;
				update();
			}
		}

		public function get rows() : uint {
			return _rows;
		}

		public function set rows(rows : uint) : void {
			if (_rows != rows) {
				_rows = rows;
				update();
			}		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		private function update() : void {
			clearSprite();
			
			var i : uint;
			var x : Number;
			var y : Number;
			var line : Line;
			
			for (i = 0; i < cols; i++) {
				x = i * (width / cols);
				line = new Line(x, 0, x, height, STROKE_WIDTH, _strokeColor);
				this.addChild(line);
			}
			
			for (i = 0; i < rows; i++) {
				y = i * (height / rows);
				line = new Line(0, y, width, y, STROKE_WIDTH, _strokeColor);
				this.addChild(line);
			}
		}

		private function clearSprite() : void {
			while (this.numChildren > 0) {
				this.removeChildAt(0);
			}
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
	}
}