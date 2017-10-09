package view.dates.eventsList.singleEvent {
import graphics.GraphicsUtils;
import graphics.Rect;

import model.Settings;
import model.dates.eventsList.singleEvent.SingleEventContent;

import realTimeTweener.RealTimeTweener;
import realTimeTweener.RealTimeTweenerEvent;

import uiElements.text.StringScroller;

import utils.SimpleTextArea;

import view.ContainerView;
import view.dates.eventsList.singleEvent.mediaSlider.MediaSliderView;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
 * @author Robert Soghbatyan (robert.sogbatyan@gmail.com)
 */
public class SingleEventContentView extends ContainerView {
    ////////////////////////////////////////////////////////////////////////////////////////
    // Events                                                                             //
    ////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////
    // Constants                                                                          //
    ////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////
    // Variables                                                                          //
    ////////////////////////////////////////////////////////////////////////////////////////
    private var _settings:Settings;

    private var _bg:Rect;

    private var _startDate:StringScroller;
    private var _endDate:StringScroller;

    private var _description:SimpleTextArea;

    private var _mediaSliderView:MediaSliderView;

    private var _snap:Bitmap;
    private var _snapSprite:Sprite;
    private var _snapMask:Rect;

    private var _spriteTweener:RealTimeTweener;

    private var _snapTweener:RealTimeTweener;


    ////////////////////////////////////////////////////////////////////////////////////////
    // Constructor                                                                        //
    ////////////////////////////////////////////////////////////////////////////////////////
    public function SingleEventContentView(singleEventContent:SingleEventContent):void {
        super(singleEventContent);

        _settings = _controller.settings;

        _bg = new Rect();
        _bg.strokeWidth = Settings.STROKE_WIDTH;
        _bg.strokeColor = _settings.strokeColor;
        _bg.strokeAlpha = 0;
        _bg.fillType = Rect.FILL_TYPE_LINEAR;
        _bg.fillGradColors = _settings.eventContentBgColors;
        _bg.fillGradAlphas = [1, 1];
        _bg.fillGradRatios = [0, 255];
        _bg.fillGradAngle = 90;
        _sprite.addChild(_bg);


        var font:String = Settings.FONT;
        var datesFontSize:int = _settings.eventContentDatesFontSize;
        var datesColor:int = _settings.eventContentDatesColor;

        _startDate = new StringScroller();
        _startDate.font = font;
        _startDate.size = datesFontSize;
        _startDate.color = datesColor;
        _startDate.align = StringScroller.ALIGN_LEFT;
        _startDate.autoHeight = true;
        _sprite.addChild(_startDate);

        _endDate = new StringScroller();
        _endDate.font = font;
        _endDate.size = datesFontSize;
        _endDate.color = datesColor;
        _endDate.align = StringScroller.ALIGN_LEFT;
        _endDate.autoHeight = true;
        _sprite.addChild(_endDate);

        _description = new SimpleTextArea();
        _description.font = font;
        _description.fontSize = _settings.eventContentDescriptionFontSize;
        _description.fontColor = _settings.eventContentDescriptionColor;
        _sprite.addChild(_description.sprite);

        _mediaSliderView = new MediaSliderView(singleEventContent.mediaSlider);
        _sprite.addChild(_mediaSliderView.sprite);

        _snapSprite = new Sprite();
        _sprite.addChild(_snapSprite);
        _snapMask = new Rect();
        _sprite.addChild(_snapMask);
        _snapSprite.mask = _snapMask;

        _spriteTweener = new RealTimeTweener(_sprite, _controller.stage);
        _spriteTweener.multiplier = Settings.REAL_TIME_TWEENER_MULTIPLIER;
        _snapTweener = new RealTimeTweener(null, _controller.stage);
        _snapTweener.multiplier = Settings.REAL_TIME_TWEENER_MULTIPLIER;

        singleEventContent.addEventListener(SingleEventContent.UPDATE_CONTENT, updateContentHandler);
        singleEventContent.addEventListener(SingleEventContent.GET_SNAP, getSnapHandler);
        singleEventContent.addEventListener(SingleEventContent.VISIBILITY_CHANGED, visibilityChangedHandler);

        _snapTweener.addEventListener(RealTimeTweenerEvent.TWEEN_FINISHED, snapsTweensFinishedHandler);

        updateRect();
        updateContent();
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
    override protected function updateRect():void {
        super.updateRect();

        var singleEventContent:SingleEventContent = _model as SingleEventContent;
        var width:Number = singleEventContent.width;
        var height:Number = singleEventContent.height;

        _snapTweener.finishAll();

        var strokeWidth:Number = Settings.STROKE_WIDTH;
        _bg.width = width;
        _bg.height = height;

        _snapMask.width = width - strokeWidth;
        _snapMask.height = height - strokeWidth;
        _snapMask.x = strokeWidth / 2;
        _snapMask.y = strokeWidth / 2;

        var startDateRect:Rectangle = singleEventContent.startDateRect;
        _startDate.x = startDateRect.x;
        _startDate.y = startDateRect.y;
        _startDate.width = startDateRect.width;

        var endDateRect:Rectangle = singleEventContent.endDateRect;
        _endDate.x = endDateRect.x;
        _endDate.y = endDateRect.y;
        _endDate.width = endDateRect.width;

        var descriptionRect:Rectangle = singleEventContent.descriptionRect;
        _description.x = descriptionRect.x;
        _description.y = descriptionRect.y;
        _description.width = descriptionRect.width;
        _description.height = descriptionRect.height;
    }

    private function updateVisibility():void {
        var singleEventContent:SingleEventContent = _model as SingleEventContent;
        var isVisible:Boolean = singleEventContent.isVisible;

        if (isVisible == false) {
            _snap = null;
        }

        _sprite.mouseEnabled = isVisible;
        _sprite.mouseChildren = isVisible;

        var destAlpha:Number = isVisible == true ? 1 : 0;

        _spriteTweener.tween("alpha", destAlpha);
    }

    private function updateContent():void {
        var singleEventContent:SingleEventContent = _model as SingleEventContent;
        if (singleEventContent.isVisible == false) {
            return;
        }

        _snapTweener.finishAll();
        clearSnapSprite();

        _startDate.text = singleEventContent.startDateText;
        _endDate.text = singleEventContent.endDateText;

        var text:String = singleEventContent.descriptionText;
        var htmlText:String = singleEventContent.descriptionHtmlText;
        var cssText:String = singleEventContent.descriptionCssText;
        _description.init(text, htmlText, cssText);

        if (_snap != null) {
            _snapSprite.addChild(_snap);
            _snapTweener.obj = _snap;
            _snapTweener.tween("x", _snap.x - singleEventContent.width);
        }
    }

    private function getSnap():void {
        clearSnapSprite();
        if (_sprite.parent == null) {
            return;
        }

        if (_snap == null) {
            _snap = new Bitmap();
            _snapSprite.addChild(_snap);
            return;
        }

        _snap = GraphicsUtils.getSnap(_sprite);
        var globCoords:Point = _sprite.parent.localToGlobal(new Point(_snap.x, _snap.y));
        var localCoords:Point = _snapSprite.globalToLocal(globCoords);
        _snap.x = localCoords.x;
        _snap.y = localCoords.y;
        _snapSprite.addChild(_snap);
    }

    private function clearSnapSprite():void {
        while (_snapSprite.numChildren > 0) {
            _snapSprite.removeChildAt(0);
        }
    }


    ////////////////////////////////////////////////////////////////////////////////////////
    // Listeners                                                                          //
    ////////////////////////////////////////////////////////////////////////////////////////
    private function updateContentHandler(event:Event):void {
        updateContent();
    }

    private function getSnapHandler(event:Event):void {
        getSnap();
    }

    private function visibilityChangedHandler(event:Event):void {
        updateVisibility();
    }

    private function snapsTweensFinishedHandler(event:Event):void {
        clearSnapSprite();
    }
}
}
