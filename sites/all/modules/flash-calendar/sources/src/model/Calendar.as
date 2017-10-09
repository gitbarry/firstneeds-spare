package model {
import flash.events.Event;
import flash.events.EventDispatcher;

/**
 * @author Family
 */
public class Calendar extends EventDispatcher {
    ////////////////////////////////////////////////////////////////////////////////////////
    // Events                                                                             //
    ////////////////////////////////////////////////////////////////////////////////////////
    public static const DATE_CHANGED : String = "dateChanged";


    ////////////////////////////////////////////////////////////////////////////////////////
    // Consts                                                                             //
    ////////////////////////////////////////////////////////////////////////////////////////
    private var EVENTS_COUNT_FREE : uint = 3;


    ////////////////////////////////////////////////////////////////////////////////////////
    // Variables                                                                          //
    ////////////////////////////////////////////////////////////////////////////////////////
    private var _controller : Controller; //controller instance

    private var _eventsList : XMLList; //events list

    private var _curDate : Date; //current date


    ////////////////////////////////////////////////////////////////////////////////////////
    // Constructor                                                                        //
    ////////////////////////////////////////////////////////////////////////////////////////

    public function Calendar(eventsXml : XML) : void {
        _controller = Controller.getInstance();

        if ((eventsXml.@defaultDate != undefined) && (eventsXml.@defaultDate != "")) {
            _curDate = getDateFromStr(String(eventsXml.@defaultDate));
        } else {
            _curDate = new Date();
        }

        if (Controller.FREE_VERSION == true) {
            if (Controller.DRUPAL == true) {
                var eventsList : XMLList = eventsXml.eventFree;
                _eventsList = new XMLList();
                for (var i : uint = 0; i < Math.min(EVENTS_COUNT_FREE, eventsList.length()); i++) {
                    _eventsList += eventsList[i];
                }
            } else {
                _eventsList = eventsXml.eventFree;
            }
        } else {
            _eventsList = eventsXml.event;
        }

    }


    ////////////////////////////////////////////////////////////////////////////////////////
    // Public Methods                                                                     //
    ////////////////////////////////////////////////////////////////////////////////////////
    public function getEvents(start : Date, finish : Date) : XMLList {
        var eventsList : XMLList = _eventsList.(isDateInRange(getDateFromStr(startDate), getDateFromStr(endDate), start, finish) == true);
        return eventsList;
    }


    ////////////////////////////////////////////////////////////////////////////////////////
    // Getters & Setters                                                                  //
    ////////////////////////////////////////////////////////////////////////////////////////
    public function get curYear() : int {
        return _curDate.fullYear;
    }

    public function set curYear(year : int) : void {
        var maxDays : int = getDaysInMonth(year, curMonth);
        if (curDate > maxDays) {
            curDate = maxDays;
        }

        _curDate.fullYear = year;
        dispatchEvent(new Event(DATE_CHANGED));
    }

    public function get curMonth() : int {
        return _curDate.month;
    }

    public function set curMonth(month : int) : void {
        var maxDays : int = getDaysInMonth(curYear, month);
        if (curDate > maxDays) {
            curDate = maxDays;
        }

        _curDate.month = month;
        dispatchEvent(new Event(DATE_CHANGED));
    }

    public function get curDate() : int {
        return _curDate.date;
    }

    public function set curDate(date : int) : void {
        _curDate.date = date;
        dispatchEvent(new Event(DATE_CHANGED));
    }


    public function get year() : int {
        return _curDate.fullYear;
    }

    public function get monthName() : String {
        var monthNames : Array = _controller.lang.months;
        return monthNames[_curDate.month];
    }

    public function get monthShortName() : String {
        var monthShortNames : Array = _controller.lang.monthsShort;
        return monthShortNames[_curDate.month];
    }


    ////////////////////////////////////////////////////////////////////////////////////////
    // Private Methods                                                                    //
    ////////////////////////////////////////////////////////////////////////////////////////
    private function getDaysInMonth(year : int, month : int) : int {
        var days : int;

        if (month == 1) {
            days = year % 4 == 0 ? 29 : 28;
        } else if ((month <= 0) || (month == 2) || (month == 5) || (month == 6) || (month == 7) || (month == 9) || (month >= 11)) {
            days = 31;
        } else {
            days = 30;
        }

        return days;
    }

    private function getDateFromStr(str : String) : Date {
        var dateString : String = String(str.split(" ")[0]);
        var timeString : String = String(str.split(" ")[1]);

        var dateArray : Array = dateString.split("-");
        var day : int = int(dateArray[0]);
        day = ((day >= 1) && (day <= 31)) ? day : 0;
        var month : int = int(dateArray[1]) - 1;
        month = ((month >= 0) && (month <= 11)) ? month : 0;
        var year : int = int(dateArray[2]);

        var timeArray : Array = timeString.split(":");
        var hours : int = timeArray[0];
        hours = ((hours >= 0) && (hours <= 23)) ? hours : 0;
        var minutes : int = timeArray[1];
        minutes = ((minutes >= 0) && (minutes <= 59)) ? minutes : 0;

        var date : Date = new Date();
        date.fullYear = year;
        date.month = month;
        date.date = day;
        date.hours = hours;
        date.minutes = minutes;

        return date;
    }

    private function isDateInRange(eventsStartDate : Date, eventsEndDate : Date, startDate : Date, endDate : Date) : Boolean {
        var result : Boolean;

        var eventsStartDateTime : Number = eventsStartDate.getTime();
        var eventsEndDateTime : Number = eventsEndDate.getTime();
        var startDateTime : Number = startDate.getTime();
        var endDateTime : Number = endDate.getTime();

        if ((eventsEndDateTime < startDateTime) || (eventsStartDateTime > endDateTime)) {
            result = false;
        } else {
            result = true;
        }

        return result;
    }


    ////////////////////////////////////////////////////////////////////////////////////////
    // Listeners                                                                          //
    ////////////////////////////////////////////////////////////////////////////////////////
}
}
