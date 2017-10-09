package view.dates.eventsList {
	import model.Settings;
	import model.dates.eventsList.EventsList;

	import realTimeTweener.RealTimeTweener;

	import view.ContainerView;
	import view.dates.eventsList.singleEvent.SingleEventContentView;
	import view.dates.eventsList.singleEvent.SingleEventHeadersListView;

	import flash.events.Event;

	/**
	 * @author Robert Soghbatyan (robert.sogbatyan@gmail.com)
	 */
	public class EventsListView extends ContainerView {
		////////////////////////////////////////////////////////////////////////////////////////
		// Events                                                                             //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private var _eventsListHeaderView : EventsListHeaderView;
		private var _singleEventHeadersListView : SingleEventHeadersListView;
		private var _singleEventContentView : SingleEventContentView;

		private var _tweener : RealTimeTweener;
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		public function EventsListView(eventsList : EventsList) : void {
			super(eventsList);
			
			_eventsListHeaderView = new EventsListHeaderView(eventsList.eventsListHeader);
			_sprite.addChild(_eventsListHeaderView.sprite);
			
			_singleEventHeadersListView = new SingleEventHeadersListView(eventsList.singleEventHeadersList);
			_sprite.addChild(_singleEventHeadersListView.sprite);
			
			_singleEventContentView = new SingleEventContentView(eventsList.singleEventContent);
			_sprite.addChild(_singleEventContentView.sprite);

			_tweener = new RealTimeTweener(_sprite, _controller.stage);			_tweener.multiplier = Settings.REAL_TIME_TWEENER_MULTIPLIER;
			
			eventsList.addEventListener(EventsList.VISIBILITY_CHANGED, visibilityChangedHandler);
			
			updateRect();
			updateVisibility();
			_tweener.finishAll();		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		private function updateVisibility() : void {
			var eventsList : EventsList = _model as EventsList;
			var isVisible : Boolean = eventsList.isVisible;
			
			_sprite.mouseEnabled = isVisible;
			_sprite.mouseChildren = isVisible;
			
			var destAlpha : Number = isVisible == true ? 1 : 0;
			_tweener.tween("alpha", destAlpha);
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private function visibilityChangedHandler(event : Event) : void {
			updateVisibility();
		}
	}
}
