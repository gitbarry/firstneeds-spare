package model {

	/**
	 * @author Robert Soghbatyan (robert.sogbatyan@gmail.com)
	 */
	public class Lang {
		////////////////////////////////////////////////////////////////////////////////////////
		// Events                                                                             //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private var _langXml : XML;
		
		private var _months : Array;		private var _monthsShort : Array;
		
		private var _days : Array;
		private var _daysShort : Array;
				private var _event : String;		private var _events : String;
		
		private var _priority : String;
		private var _priority0Text : String;		private var _priority1Text : String;		private var _priority2Text : String;		private var _priority3Text : String;
		
		private var _time : String;		private var _startDate : String;		private var _endDate : String;
				private var _eventsListHeaderTitleText : String;
		
		private var _type : String;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		public function Lang(langXml : XML) : void {
			_langXml = langXml;
			
			_months = TextUtils.removeSpaces(String(_langXml.months)).split(",");			_monthsShort = TextUtils.removeSpaces(String(_langXml.monthsShort)).split(",");
			
			_days = TextUtils.removeSpaces(String(_langXml.days)).split(",");
			_daysShort = TextUtils.removeSpaces(String(_langXml.daysShort)).split(",");
			
			_event = String(_langXml.event);			_events = String(_langXml.events);
						_priority = String(_langXml.priority);			_priority0Text = String(_langXml.priority0Text);			_priority1Text = String(_langXml.priority1Text);			_priority2Text = String(_langXml.priority2Text);			_priority3Text = String(_langXml.priority3Text);
			
			_time = String(_langXml.time);			_startDate = String(_langXml.startDate);			_endDate = String(_langXml.endDate);
			
			_eventsListHeaderTitleText = String(_langXml.eventsListHeaderTitleText);
			
			_type = String(_langXml.type);
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		public function get langXml() : XML {
			return _langXml;
		}
		
		public function get months() : Array {
			return _months;
		}
		
		public function get monthsShort() : Array {
			return _monthsShort;
		}
		
		public function get days() : Array {
			return _days;
		}
		
		public function get daysShort() : Array {
			return _daysShort;
		}
		
		public function get event() : String {
			return _event;
		}
		
		public function get events() : String {
			return _events;
		}
		
		public function get priority() : String {
			return _priority;
		}
		
		public function get priority0Text() : String {
			return _priority0Text;
		}
		
		public function get priority1Text() : String {
			return _priority1Text;
		}
		
		public function get priority2Text() : String {
			return _priority2Text;
		}
		
		public function get priority3Text() : String {
			return _priority3Text;
		}
		
		public function get time() : String {
			return _time;
		}
		
		public function get startDate() : String {
			return _startDate;
		}
		
		public function get endDate() : String {
			return _endDate;
		}
		
		public function get eventsListHeaderTitleText() : String {
			return _eventsListHeaderTitleText;
		}
		
		public function get type() : String {
			return _type;
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
	}
}

