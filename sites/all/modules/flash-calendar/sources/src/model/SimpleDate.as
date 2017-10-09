package model {
import debug.Debug;

/**
	 * @author Robert Soghbatyan (robert.sogbatyan@gmail.com)
	 */
	public class SimpleDate {
		////////////////////////////////////////////////////////////////////////////////////////
		// Events                                                                             //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private var _controller : Controller;
		private var _lang : Lang;

		private var _year : int;
		private var _month : int;
		private var _day : int;
		private var _weeksDay : int;
		private var _hours : int;
		private var _minutes : int;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		public function SimpleDate(year : int = -1, month : int = -1, day : int = -1, hours : int = -1, minutes : int = -1) : void {
			_controller = Controller.getInstance();
			_lang = _controller.lang;
			
			_year = year;
			_month = month;
			_day = day;
			_hours = hours;
			_minutes = minutes;
			
			update();
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		public function init(str : String) : void {
			clear();
			
			var dateString : String = String(str.split(" ")[0]);
			var timeString : String = String(str.split(" ")[1]);
			
			var dateArray : Array = dateString.split("-");
			var timeArray : Array = timeString.split(":");
			
			if ((dateArray[2] == "undefined") || (dateArray[2] == undefined) || (dateArray[2] == "")) {
				return;
			} else {
				year = int(dateArray[2]);
			}
				
			if ((dateArray[1] == "undefined") || (dateArray[1] == undefined) || (dateArray[1] == "")) {
				return;
			} else {
				month = int(dateArray[1]) - 1;
			}
				
			if ((dateArray[0] == "undefined") || (dateArray[0] == undefined) || (dateArray[0] == "")) {
				return;
			} else {
				day = dateArray[0];
			}

			if ((timeArray[0] == "undefined") || (timeArray[0] == undefined) || (timeArray[0] == "")) {
                Debug.trace("BBBB" + timeArray[0]);
                return;
			} else {
				hours = timeArray[0];
			}
			
			if ((timeArray[1] == "undefined") || (timeArray[1] == undefined) || (timeArray[1] == "")) {
				return;
			} else {
				minutes = timeArray[1];
			}
		}

		public function setCurDate() : void {
			var date : Date = new Date;
			_year = date.fullYear;
			_month = date.month;
			_day = date.date;
			_hours = date.hours;
			_minutes = date.minutes;
			
			update();
		}

		public function isSameDay(simpleDate : SimpleDate) : Boolean {
			var result : Boolean = false;
			if ((_year == simpleDate.year) && (_month == simpleDate.month) && (_day == simpleDate.day)) {
				result = true;
			}
			
			return result;
		}

		public function isSameTime(simpleDate : SimpleDate) : Boolean {
			var result : Boolean = false;
			if ((_hours == simpleDate.hours) && (_minutes == simpleDate.minutes)) {
				result = true;
			}
			
			return result;
		}

		public function getDateStr(dateFormat : String) : String {
			var timeStr : String;
			if ((_hours < 0) || (_minutes < 0)) {
				timeStr = "";
			} else {
				var minutesStr : String = _minutes < 10 ? "0" + String(_minutes) : String(_minutes);
				if (_controller.settings.time12Hours == true) {
					timeStr = Math.floor(_hours / 12) == 0 ? String(_hours % 12) + ":" + minutesStr + "AM" : String(_hours % 12) + ":" + minutesStr + "PM";
				} else {
					var hoursStr : String = _hours < 10 ? "0" + String(_hours) : String(_hours);
					timeStr = hoursStr + ":" + minutesStr;
				}
			}
			
			dateFormat = dateFormat.split("%y").join(String(_year));
			dateFormat = dateFormat.split("%m").join(_lang.months[_month]);
			dateFormat = dateFormat.split("%d").join(String(_day));
			dateFormat = dateFormat.split("%t").join(timeStr);
			
			/*var dateStr : String = "-";
			if (_year == -1) {
			return dateStr;
			} else {
			dateStr = String(_year);
			}
			
			if (_month == -1) {
			return dateStr;
			} else {
			dateStr += ", " + _lang.months[_month];
			}
			
			if (_day == -1) {
			return dateStr;
			} else {
			dateStr += ", " + String(_day);
			}
			
			if (_hours == -1) {
			return dateStr;
			} else {
			dateStr += _hours < 10 ? "    0" + String(_hours) : "    " + String(_hours);
			}
			
			if (_minutes == -1) {
			dateStr += ":" + "0";
			} else {
			dateStr += _minutes < 10 ? ":0" + String(_minutes) : ":" + String(_minutes);
			}*/

			return dateFormat;
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		public function get year() : int {
			return _year;
		}

		public function set year(year : int) : void {
			if (year < 0) {
				_year = -1;
			} else {
				_year = year;
			}
			update();
		}

		public function get month() : int {
			return _month;
		}

		public function set month(month : int) : void {
			if (month < 0) {
				_month = -1;
			} else if (month > 11) {
				_month = 11;
			} else {
				_month = month;
			}
			update();
		}

		public function get day() : int {
			return _day;
		}

		public function set day(day : int) : void {
			if (day < 1) {
				_day = -1;
			} else if (day > 31) {
				_day = 31;
			} else {
				_day = day;
			}
			update();
		}

		public function get weeksDay() : int {
			return _weeksDay;
		}

		public function get hours() : int {
			return _hours;
		}

		public function set hours(hours : int) : void {
			if (hours < 0) {
				_hours = -1;
			} else if (hours > 23) {
				_hours = 23;
			} else {
				_hours = hours;
			}
			update();
		}

		public function get minutes() : int {
			return _minutes;
		}

		public function set minutes(minutes : int) : void {
			if (minutes < 0) {
				_minutes = -1;
			} else if (minutes > 59) {
				_minutes = 59;
			} else {
				_minutes = minutes;
			}
			update();
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		private function update() : void {
			if ((_day == -1) || (_month == -1) || (_year == -1)) {
				_weeksDay = -1;
			} else {
				var date : Date = new Date(_year, _month, _day);
				_weeksDay = date.day;
			}
		}

		private function clear() : void {
			_year = -1;
			_month = -1;
			_day = -1;
			_weeksDay = -1;
			_hours = -1;
			_minutes = -1;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
	}
}
