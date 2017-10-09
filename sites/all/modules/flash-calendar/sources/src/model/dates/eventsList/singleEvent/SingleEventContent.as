package model.dates.eventsList.singleEvent {
import fileLoader.File;
import fileLoader.FileCss;
import fileLoader.FileHtml;
import fileLoader.FileLoader;
import fileLoader.FileLoaderEvent;
import fileLoader.FileTypes;

import model.Calendar;
import model.Container;
import model.Lang;
import model.Settings;
import model.SimpleDate;
import model.dates.eventsList.EventsListManager;
import model.dates.eventsList.singleEvent.mediaSlider.MediaSlider;

import uiElements.text.TFUtils;

import flash.events.Event;
import flash.geom.Rectangle;

/**
 * @author Robert Soghbatyan (robert.sogbatyan@gmail.com)
 */
public class SingleEventContent extends Container {
    ////////////////////////////////////////////////////////////////////////////////////////
    // Events                                                                             //
    ////////////////////////////////////////////////////////////////////////////////////////
    public static const UPDATE_CONTENT:String = "updateContent";
    public static const GET_SNAP:String = "getSnap";

    public static const VISIBILITY_CHANGED:String = "visibilityChanged";


    ////////////////////////////////////////////////////////////////////////////////////////
    // Constants                                                                          //
    ////////////////////////////////////////////////////////////////////////////////////////
    private static const SPACE:Number = 10;


    ////////////////////////////////////////////////////////////////////////////////////////
    // Variables                                                                          //
    ////////////////////////////////////////////////////////////////////////////////////////
    private var _settings:Settings;
    private var _lang:Lang;
    private var _calendar:Calendar;

    private var _eventsListManager:EventsListManager;

    private var _isVisible:Boolean;

    private var _startDateRect:Rectangle;
    private var _startDate:SimpleDate;
    private var _startDateText:String;
    private var _endDateRect:Rectangle;
    private var _endDate:SimpleDate;
    private var _endDateText:String;
    private var _descriptionRect:Rectangle;
    private var _descriptionText:String;
    private var _descriptionHtmlText:String;
    private var _descriptionCssText:String;

    private var _mediaXmlList:XMLList;
    private var _mediaSlider:MediaSlider;

    private var _fileLoader:FileLoader;


    ////////////////////////////////////////////////////////////////////////////////////////
    // Constructor                                                                        //
    ////////////////////////////////////////////////////////////////////////////////////////
    public function SingleEventContent(eventsListManager:EventsListManager):void {
        super();

        _settings = _controller.settings;
        _lang = _controller.lang;
        _calendar = _controller.calendar;

        _eventsListManager = eventsListManager;

        _isVisible = false;

        _startDateRect = new Rectangle();
        _endDateRect = new Rectangle();
        determineDatesHeights();
        _descriptionRect = new Rectangle();

        _mediaSlider = new MediaSlider();
        _mediaSlider.isVisible = false;

        _fileLoader = new FileLoader();
        _fileLoader.addEventListener(FileLoaderEvent.ALL_FILES_LOADING_COMPLETED, filesLoadingCompleteHandler);

        _eventsListManager.addEventListener(EventsListManager.IS_EVENT_OPENED_CHANGED, isEventOpenedChanged);
        _eventsListManager.addEventListener(EventsListManager.OPENED_EVENT_INDEX_CHANGED, openedEventIndexChangedHandler);

        updateRect();
    }


    ////////////////////////////////////////////////////////////////////////////////////////
    // Public Methods                                                                     //
    ////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////
    // Getters & Setters                                                                  //
    ////////////////////////////////////////////////////////////////////////////////////////
    public function get isVisible():Boolean {
        return _isVisible;
    }

    public function get startDateRect():Rectangle {
        return _startDateRect;
    }

    public function get startDateText():String {
        return _startDateText;
    }

    public function get endDateRect():Rectangle {
        return _endDateRect;
    }

    public function get endDateText():String {
        return _endDateText;
    }

    public function get descriptionRect():Rectangle {
        return _descriptionRect;
    }

    public function get descriptionText():String {
        return _descriptionText;
    }

    public function get descriptionHtmlText():String {
        return _descriptionHtmlText;
    }

    public function get descriptionCssText():String {
        return _descriptionCssText;
    }

    public function get mediaSlider():MediaSlider {
        return _mediaSlider;
    }


    ////////////////////////////////////////////////////////////////////////////////////////
    // Private Methods                                                                    //
    ////////////////////////////////////////////////////////////////////////////////////////
    override protected function updateRect():void {
        if (_isVisible == false) {
            return;
        }

        var width:Number = _rect.width;
        var height:Number = _rect.height;

        var leftSideWidth:Number = _mediaSlider.isVisible == true ? width / 2 - 1.5 * SPACE : width - 2 * SPACE;

        _startDateRect.x = SPACE;
        _startDateRect.y = SPACE;
        _startDateRect.width = leftSideWidth;

        _endDateRect.x = SPACE;
        _endDateRect.y = _startDateRect.y + _startDateRect.height + SPACE;
        _endDateRect.width = leftSideWidth;

        _descriptionRect.x = SPACE;
        if (_endDateText == "") {
            if (_startDateText == "") {
                _descriptionRect.y = SPACE;
            } else {
                _descriptionRect.y = _startDateRect.y + _startDateRect.height + SPACE;
            }
        } else {
            _descriptionRect.y = _endDateRect.y + _endDateRect.height + SPACE;
        }
        _descriptionRect.width = leftSideWidth;
        _descriptionRect.height = height - SPACE - _descriptionRect.y;

        _mediaSlider.x = (width + SPACE) / 2;
        _mediaSlider.y = SPACE;
        _mediaSlider.width = width / 2 - 1.5 * SPACE;
        _mediaSlider.height = height - 2 * SPACE;

        super.updateRect();
    }

    private function determineDatesHeights():void {
        var font:String = Settings.FONT;
        var fontSize:int = _settings.eventContentDatesFontSize;

        var height:Number = TFUtils.getTFMetrics("00", font, fontSize).height;
        _startDateRect.height = height;
        _endDateRect.height = height;
    }

    private function updateVisibility():void {
        _isVisible = _eventsListManager.isEventOpened;

        if (_isVisible == false) {
            _mediaSlider.clear();
        }

        dispatchEvent(new Event(VISIBILITY_CHANGED));
    }

    private function parseEvent():void {
        if (_isVisible == false) {
            return;
        }

        _fileLoader.removeAll();

        var singleEvent:SingleEvent = _eventsListManager.singleEvents[_eventsListManager.openedEventIndex];

        _startDate = singleEvent.startDate;
        _endDate = singleEvent.endDate;

        _mediaXmlList = singleEvent.mediaXmlList;

        _descriptionText = singleEvent.descriptionText;
        _descriptionHtmlText = singleEvent.descriptionHtmlText;
        _descriptionCssText = singleEvent.descriptionCssText;

        var htmlUrl:String = singleEvent.descriptionHtmlUrl;
        var cssUrl:String = singleEvent.descriptionCssUrl;

        if ((_descriptionHtmlText == "") && (htmlUrl != "")) {
            var htmlFile:File = File.createFile(FileTypes.HTML, "html", htmlUrl);
            _fileLoader.add(htmlFile);
        }

        if ((_descriptionCssText == "") && (cssUrl != "")) {
            var cssFile:File = File.createFile(FileTypes.CSS, "css", cssUrl);
            _fileLoader.add(cssFile);
        }

        if ((htmlFile == null) && (cssFile == null)) {
            updateContent();
        } else {
            _fileLoader.load();
        }
    }

    private function updateContent():void {
        dispatchEvent(new Event(GET_SNAP));

        var startDateText:String;
        var endDateText:String;
        var dateFormat:String;

        var isPeriodDay:Boolean = _eventsListManager.period == EventsListManager.PERIOD_DAY ? true : false;
        if ((isPeriodDay == false) || (_endDate.isSameDay(_startDate) == false)) {
            dateFormat = _settings.dateFormat;
            startDateText = _lang.startDate + ":    " + _startDate.getDateStr(dateFormat);
            endDateText = _lang.endDate + ":    " + _endDate.getDateStr(dateFormat);
        } else {
            dateFormat = _settings.dateFormatShort;
            if (_startDate.hours < 0) {
                startDateText = "";
                endDateText = "";
            } else if ((_endDate.hours < 0) || (_endDate.isSameTime(_startDate))) {
                startDateText = _lang.time + ":    " + _startDate.getDateStr(dateFormat);
                endDateText = "";
            } else {
                startDateText = _lang.startDate + ":    " + _startDate.getDateStr(dateFormat);
                endDateText = _lang.endDate + ":    " + _endDate.getDateStr(dateFormat);
            }
        }

        _startDateText = startDateText;
        _endDateText = endDateText;

        _mediaSlider.updateMediaXmlList(_mediaXmlList);
        _mediaSlider.isVisible = ((_mediaXmlList == null) || (_mediaXmlList.length() == 0)) ? false : true;

        updateRect();

        dispatchEvent(new Event(UPDATE_CONTENT));
    }


    ////////////////////////////////////////////////////////////////////////////////////////
    // Listeners                                                                          //
    ////////////////////////////////////////////////////////////////////////////////////////
    private function isEventOpenedChanged(event:Event):void {
        updateVisibility();
    }

    private function openedEventIndexChangedHandler(event:Event):void {
        parseEvent();
    }

    private function filesLoadingCompleteHandler(event:FileLoaderEvent):void {
        var htmlFile:FileHtml = FileHtml(_fileLoader.getFileById("html"));
        var cssFile:FileCss = FileCss(_fileLoader.getFileById("css"));

        if (htmlFile != null) {
            _descriptionHtmlText = htmlFile.htmlText;
        }

        if (cssFile != null) {
            _descriptionCssText = cssFile.styleText;
        }

        updateContent();
    }
}
}
