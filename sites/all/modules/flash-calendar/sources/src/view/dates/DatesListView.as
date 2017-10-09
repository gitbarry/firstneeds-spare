package view.dates {
	import model.Settings;
	import model.dates.DatesList;
	import model.dates.SingleDate;

	import realTimeTweener.RealTimeTweener;

	import uiElements.Btn;

	import view.ContainerView;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author Robert Soghbatyan (robert.sogbatyan@gmail.com)
	 */
	public class DatesListView extends ContainerView {
		////////////////////////////////////////////////////////////////////////////////////////
		// Events                                                                             //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		public static const BTN_WIDTH : Number = 20;
		public static const BTN_HEIGHT : Number = 50;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private var _datesSprite : Sprite;

		private var _grid : Grid;

		private var _btnPrev : Btn;
		private var _btnNext : Btn;

		private var _spriteTweener : RealTimeTweener;
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		public function DatesListView(datesList : DatesList) : void {
			super(datesList);
			
			_datesSprite = new Sprite();
			_sprite.addChild(_datesSprite);
			
			_grid = new Grid();
			_sprite.addChild(_grid);
			
			var btnColor : int = _controller.settings.strokeColor;
			_btnPrev = new Btn(BTN_WIDTH, BTN_HEIGHT, "prevYearsBtn", btnColor);
			
			_spriteTweener = new RealTimeTweener(_sprite, _controller.stage);
			
			datesList.addEventListener(DatesList.VISIBILITY_CHANGED, updateVisibilityHandler);
			datesList.addEventListener(DatesList.UPDATE_STATE, updateStateHandler);
			
			_btnPrev.addEventListener(MouseEvent.CLICK, clickHandler);
			
			updateRect();
			updateDates();
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
			
			var datesList : DatesList = _model as DatesList;
			
			var width : Number = datesList.width;
			
			_grid.width = width;
			
			if (datesList.state == DatesList.STATE_YEARS) {
				_btnPrev.x = 0;
				_btnPrev.y = (height - BTN_HEIGHT) / 2;
			
				_btnNext.x = width - BTN_WIDTH;
				_btnNext.y = (height - BTN_HEIGHT) / 2;
			}
		}

		private function updateVisibility() : void {
			var datesList : DatesList = _model as DatesList;
			var isVisible : Boolean = datesList.isVisible;
			_sprite.mouseEnabled = isVisible;
			var destAlpha : Number = isVisible == true ? 1 : 0;
			_spriteTweener.tween("alpha", destAlpha);
		}
		
		private function updateState() : void {
			var datesList : DatesList = _model as DatesList;
			if (datesList.state == DatesList.STATE_YEARS) {
				_sprite.addChild(_btnPrev);
			} else {
				if (_btnPrev.parent != null) {
					_btnPrev.parent.removeChild(_btnPrev);
				}
				if (_btnNext.parent != null) {
					_btnNext.parent.removeChild(_btnNext);
				}
			}
		}

		private function updateDates() : void {
			var datesList : DatesList = _model as DatesList;
			
			updateGrid();
			
			clearDatesSprite();
			
			var dates : Array = datesList.dates;
			var cols : uint = datesList.cols;
			var i : uint;
			var row : Array;
			var singleDate : SingleDate;
			
			_dateViews = new Array();
			for (i = 0;i < rows;i++) {
				row = new Array();
				for (j = 0;j < cols;j++) {
					singleDate = dates[i][j] as SingleDate;
					singleDateView = new SingleDateView(singleDate);
					_datesSprite.addChild(singleDateView.sprite);
					row[j] = singleDateView;
				}
				_dateViews[i] = row;
			}
		}

		private function updateGrid() : void {
			var datesList : DatesList = _model as DatesList;
			
			var cols : uint = datesList.cols;
			
			_grid.cols = cols;
		}

		private function clearDatesSprite() : void {
			while (_datesSprite.numChildren > 0) {
				_datesSprite.removeChildAt(0);
			}
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private function updateVisibilityHandler(event : Event) : void {
			updateVisibility();
		}
		
		private function updateStateHandler(event : Event) : void {
			updateState();
		}

		private function updateDatesHandler(event : Event) : void {
			updateDates();
		}
		
		private function clickHandler(event : MouseEvent) : void {
			switch (event.currentTarget) {
				case _btnPrev:
					_controller.calendar.curYear -= 12;
					break;
				case _btnNext:
					_controller.calendar.curYear += 12;
					break;
			}
		}
	}
}