package view.dates {
	import graphics.GraphicsUtils;
	import graphics.Rect;

	import model.Settings;
	import model.dates.Dates;

	import realTimeTweener.RealTimeTweener;
	import realTimeTweener.RealTimeTweenerEvent;

	import view.ContainerView;
	import view.dates.eventsList.EventsListView;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * @author Robert Soghbatyan (robert.sogbatyan@gmail.com)
	 */
	public class DatesView extends ContainerView {
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
		
		private var _bg : Rect;
		
		private var _daysNamesView : DaysNamesView;
		private var _datesListView : DatesListView;
		private var _eventsListView : EventsListView;
		
		private var _snapSprite : Sprite;
		
		private var _snapTweener : RealTimeTweener;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		public function DatesView(dates : Dates) : void {
			super(dates);
			
			_settings = _controller.settings;
			
			_bg = new Rect(dates.width, dates.height);
			_bg.strokeWidth = Settings.STROKE_WIDTH;
			_bg.strokeColor = _settings.strokeColor;
			_bg.fillType = Rect.FILL_TYPE_LINEAR;
			_bg.fillGradColors = _settings.datesBgColors;
			_bg.fillGradAlphas = [1, 1];			_bg.fillGradRatios = [0, 255];
			_bg.fillGradAngle = 90;
			_sprite.addChild(_bg);
			
			_daysNamesView = new DaysNamesView(dates.daysNames);
			_sprite.addChild(_daysNamesView.sprite);
			
			_datesListView = new DatesListView(dates.datesList);
			_sprite.addChild(_datesListView.sprite);
			
			_eventsListView = new EventsListView(dates.eventsList);
			_sprite.addChild(_eventsListView.sprite);
			
			_snapSprite = new Sprite();
			_snapSprite.mouseEnabled = false;			_snapSprite.mouseChildren = false;
			_sprite.addChild(_snapSprite);
			
			_snapTweener = new RealTimeTweener(null, _controller.stage);			_snapTweener.multiplier = Settings.REAL_TIME_TWEENER_MULTIPLIER;
			
			_snapTweener.addEventListener(RealTimeTweenerEvent.TWEEN_FINISHED, snapTweenFinishedHandler);
			
			dates.addEventListener(Dates.GET_SNAP, getSnapHandler);
			
			updateRect();		}

		
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
			
//			_snapTweener.finishAll();
//			clearSnapSprite();
			
			var dates : Dates = _model as Dates;
			
			_bg.width = dates.width;
			_bg.height = dates.height;		}
		
		private function getSnap() : void {
			clearSnapSprite();
			
			if (_sprite.parent == null) {
				return;
			}
			
			var snap : Bitmap = GraphicsUtils.getSnap(_sprite);
			
			var globCoords : Point = _sprite.parent.localToGlobal(new Point(snap.x, snap.y));
			var localCoords : Point = _snapSprite.globalToLocal(globCoords);
			snap.x = localCoords.x;
			snap.y = localCoords.y;
			
			_snapSprite.addChild(snap);
			
			_snapTweener.obj = snap;
			_snapTweener.tween("alpha", 0);
		}
		
		private function clearSnapSprite() : void {
			while (_snapSprite.numChildren > 0) {
				_snapSprite.removeChildAt(0);
			}
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private function getSnapHandler(event : Event) : void {
			getSnap();
		}
		
		private function snapTweenFinishedHandler(event : RealTimeTweenerEvent) : void {
			clearSnapSprite();
		}
	}
}
