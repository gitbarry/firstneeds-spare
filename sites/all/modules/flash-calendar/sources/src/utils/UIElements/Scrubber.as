package utils.UIElements {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author Family
	 */
	public class Scrubber extends Sprite {
		////////////////////////////////////////////////////////////////////////////////////////
		// Events                                                                             //
		////////////////////////////////////////////////////////////////////////////////////////
		public static const LEVEL_CHANGED : String = "levelChanged"; //dispatched when pos changed		public static const DRAG_STARTED : String = "dragStarted"; //dispatched when starting to drag head		public static const DRAG_ENDED : String = "dragEnded"; //dispatched when head ended dragging


		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		protected var _width : Number; //slide width
		protected var _height : Number; //slide height

		protected var _skin : Sprite; //slide skin

		protected var _bg : Sprite; //slide bg
		protected var _bgColor : int; //color overlay for slide bg's child called "color"		protected var _bgHover : Sprite; //slide bg hover
		protected var _bgHoverColor : int; //color overlay for slide bg hovers's child called "color"
		protected var _bgAlpha : Number; //bg alpha

		protected var _slideLine : Sprite; //slide line
		protected var _slideLineColor : int; //slide line color
		
		protected var _head : Sprite; //slide head		protected var _headColor : int; //slide head color		protected var _headHover : Sprite; //slide head's hover
		protected var _headHoverColor : int; //color for slide's head hover child "color"		protected var _slideAlpha : Number; //slide and head Alpha
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		
		//initing skin, colors and alphas

		public function Scrubber(width : Number, height : Number, skin : String, bgColor : int, bgHoverColor : int, bgAlpha : Number,
							slideColor : int, slideHeadColor : int,	slideHeadHoverColor : int, slideAlpha : Number) : void {
			
			_width = width <= 1 ? 1 : width;
			_height = height <= 1 ? 1 : height;
				
			//colors and alphas	
			_bgColor = bgColor;			_bgHoverColor = bgHoverColor;
			_bgAlpha = bgAlpha;
			
			_slideLineColor = slideColor;
			_headColor = slideHeadColor;			_headHoverColor = slideHeadColor;//slideHeadHoverColor;
			_slideAlpha = slideAlpha;
			
			
			//skin
			_skin = Library.createSprite(skin);
			addChild(_skin);
			
			
			//bg and slide's width and height
			_bg = Sprite(_skin.getChildByName("bg"));
			if (_bg != null) {
				_bg.width = _width;
				_bg.height = _height;
				setColor(_bg, _bgColor);
				_bg.alpha = _bgAlpha;
			} else {
				_bg = new Sprite;
				_bg.graphics.beginFill(0xFFFFFF);
				_bg.graphics.drawRect(0, 0, _width, height);
				_bg.graphics.endFill();
				_bg.alpha = 0;
				addChild(_bg);
			}
			
			//bgHover
			_bgHover = _bg != null ? Sprite(_bg.getChildByName("hover")) : null;
			if (_bgHover != null) {
				setColor(_bgHover, _bgHoverColor);
				_bgHover.alpha = 0;
			}
			
			
			//slideActive
			_slideLine = Sprite(_skin.getChildByName("line"));
			if (_slideLine != null) {
				_slideLine.width = 0;
				_slideLine.height = _slideLine.height > height ? height : _slideLine.height;
				_slideLine.x = 0;
				_slideLine.y = height / 2 - _slideLine.height / 2;
				setColor(_slideLine, _slideLineColor);
				_slideLine.alpha = _slideAlpha;
			}
			
			
			//head
			_head = Sprite(_skin.getChildByName("head"));
			if (_head != null) {
				_head.x = 0;
				_head.y = height / 2 - _head.height / 2;
				setColor(_head, _headColor);
				_head.alpha = _slideAlpha;
			}
			
			
			//headHover
			_headHover = Sprite(_head.getChildByName("hover"));
			if (_headHover != null) {
				setColor(_headHover, _headHoverColor);
				_headHover.alpha = 0;
			}
			
			addEventListener(MouseEvent.ROLL_OVER, rollOverListener);
			addEventListener(MouseEvent.ROLL_OUT, rollOutListener);
			
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		public override function set width(width : Number) : void {
			var level : Number = this.level;
			
			_width = width <= 1 ? 1 : width;
			_bg.width = _width;
			
			this.setLevel(level);
		}
		
		//width and height
		public override function get width() : Number {
			return _width * this.scaleX;
		}

		public function get hght() : uint {
			return _height * this.scaleY;
		}

		
		//level
		public function get level() : Number {
			return (_head.x - _bg.x) / (_bg.width - _head.width);
		}

		public function set level(level : Number) : void {
			level *= _bg.width - _head.width;
			level += _head.width / 2;
			
			if (_slideLine != null) {
				_slideLine.width = level;
				_slideLine.x = _bg.x;
			}
			
			_head.x = _bg.x + level - _head.width / 2;
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Protected Methods                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////

		//setting Color to slide elements child named "color"
		protected function setColor(sprt : Sprite, color : int) : void {
			if (color == -1) {
				return;
			}
			
			var colorField : Sprite = Sprite(sprt.getChildByName("color"));
			ColorUtils.setColor(colorField, color);
		}

		//hoer on
		private function hoverOn() : void {
			if (_bgHover != null) {
				_bgHover.alpha = 1;
			} else if (_bg != null) {
				setColor(_bg, _bgHoverColor);
			}
			
			
			if (_headHover != null) {
				_headHover.alpha = 1;
			} else if (_head != null) {
				setColor(_head, _headHoverColor);
			}
		}

		//hover off
		private function hoverOff() : void {
			if (_bgHover != null) {
				_bgHover.alpha = 0;
			} else if (_bg != null) {
				setColor(_bg, _bgColor);
			}
			
			
			if (_headHover != null) {
				_headHover.alpha = 0;
			} else if (_head != null) {
				setColor(_head, _headColor);
			}
		}

		//refreshing colors
		protected function refresh() : void {
			if (this.hitTestPoint(this.root.stage.mouseX, this.root.stage.mouseY) == true) {
				hoverOn();
			} else {
				hoverOff();
			}
		}
		
		public function setLevel(level : Number) : void {
			level *= _bg.width - _head.width;
			level += _head.width / 2;
			
			if (_slideLine != null) {
				_slideLine.width = level;
				_slideLine.x = _bg.x;
			}
			
			_head.x = _bg.x + level - _head.width / 2;
			
			dispatchEvent(new Event(LEVEL_CHANGED, true));
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		
		//on roll over
		private function rollOverListener(e : MouseEvent) : void {
			hoverOn();
		}

		//on roll out
		private function rollOutListener(e : MouseEvent) : void {
			hoverOff();
		}

		//on mouse down
		private function mouseDownListener(e : MouseEvent) : void {
			removeEventListener(MouseEvent.ROLL_OUT, rollOutListener);
			
			dispatchEvent(new Event(DRAG_STARTED, true));
			
			mouseMoveListener();
			
			this.root.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveListener);
			this.root.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpListener);
		}

		//on mouse up
		private function mouseUpListener(e : MouseEvent) : void {
			dispatchEvent(new Event(DRAG_ENDED, true));
			
			this.root.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpListener);
			this.root.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveListener);
			
			addEventListener(MouseEvent.ROLL_OUT, rollOutListener);
			
			refresh();			
		}

		//on mouse move
		private function mouseMoveListener(e : MouseEvent = null) : void {
			var mx : Number = _bg.mouseX * _bg.scaleX;
			if (mx <= (_head.width / 2)) {
				mx = 0;
			} else if (mx > _bg.width - _head.width / 2) {
				mx = 1;
			} else {
				mx = (mx - _head.width / 2) / (_bg.width - _head.width);
			}
			
			setLevel(mx);
		}
	}
}
