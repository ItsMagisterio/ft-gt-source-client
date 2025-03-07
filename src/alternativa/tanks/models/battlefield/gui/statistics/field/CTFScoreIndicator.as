﻿package alternativa.tanks.models.battlefield.gui.statistics.field
{
    import flash.display.Sprite;
    import controls.resultassets.WhiteFrame;
    import controls.Label;
    import flash.events.Event;
    import projects.tanks.client.battleservice.model.team.BattleTeamType;
    import flash.display.GradientType;
    import flash.geom.Matrix;
    import flash.display.SpreadMethod;
    import flash.display.Graphics;
    import flash.text.TextFieldAutoSize;
    import flash.utils.getTimer;
    import flash.display.Bitmap;
    import __AS3__.vec.*;

    public class CTFScoreIndicator extends Sprite
    {

        private static var flagBlueClass:Class = CTFScoreIndicator_flagBlueClass;
        private static var flagRedClass:Class = CTFScoreIndicator_flagRedClass;
        private static var flagBlueLostClass:Class = CTFScoreIndicator_flagBlueLostClass;
        private static var flagRedLostClass:Class = CTFScoreIndicator_flagRedLostClass;
        private static var flagFlashClass:Class = CTFScoreIndicator_flagFlashClass;
        private static const FONT_COLOR_RED:uint = 16742221;
        private static const FONT_COLOR_BLUE:uint = 4760319;
        private static const BG_COLOR_RED:uint = 0x8D2100;
        private static const BG_COLOR_BLUE:uint = 16256;
        private static const ICON_WIDTH:int = 30;
        private static const LABEL_Y:int = 6;

        private var border:WhiteFrame;
        private var blueIndicator:FlagIndicator;
        private var redIndicator:FlagIndicator;
        private var labelRed:Label;
        private var labelBlue:Label;
        private var time:int;
        private var redInterpolator:ColorInterpolator = new ColorInterpolator(FONT_COLOR_RED, 0xFFFFFF);
        private var blueInterpolator:ColorInterpolator = new ColorInterpolator(FONT_COLOR_BLUE, 0xFFFFFF);
        private var blinker:CTFScoreIndicatorBlinker = new CTFScoreIndicatorBlinker(0, 1, Vector.<int>([200, 600]), Vector.<Number>([10, 1.1]));

        public function CTFScoreIndicator()
        {
            this.border = new WhiteFrame();
            addChild(this.border);
            this.labelRed = this.createLabel(FONT_COLOR_RED);
            this.labelBlue = this.createLabel(FONT_COLOR_BLUE);
            this.blueIndicator = new FlagIndicator(new flagBlueClass(), new flagBlueLostClass(), new flagFlashClass(), this.blinker);
            this.blueIndicator.y = 5;
            addChild(this.blueIndicator);
            this.redIndicator = new FlagIndicator(new flagRedClass(), new flagRedLostClass(), new flagFlashClass(), this.blinker);
            this.redIndicator.y = 5;
            addChild(this.redIndicator);
            addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
        }
        public function initScore(redScore:int, blueScore:int):void
        {
            this.labelRed.text = redScore.toString();
            this.labelBlue.text = blueScore.toString();
            this.redIndicator.setState(FlagIndicator.STATE_AT_BASE);
            this.blueIndicator.setState(FlagIndicator.STATE_AT_BASE);
            this.update();
        }
        public function get redScore():int
        {
            return (int(this.labelRed.text));
        }
        public function set redScore(value:int):void
        {
            if (int(this.labelRed.text) == value)
            {
                return;
            }
            this.labelRed.text = value.toString();
            this.blueIndicator.setState(FlagIndicator.STATE_FLASHING);
            this.update();
        }
        public function get blueScore():int
        {
            return (int(this.labelBlue.text));
        }
        public function set blueScore(value:int):void
        {
            if (int(this.labelBlue.text) == value)
            {
                return;
            }
            this.labelBlue.text = value.toString();
            this.redIndicator.setState(FlagIndicator.STATE_FLASHING);
            this.update();
        }
        public function showFlagFlash(teamType:BattleTeamType):void
        {
            var flagInficator:FlagIndicator = this.getFlagInficator(teamType);
            flagInficator.setState(FlagIndicator.STATE_FLASHING);
        }
        public function showFlagAtBase(teamType:BattleTeamType):void
        {
            var flagInficator:FlagIndicator = this.getFlagInficator(teamType);
            flagInficator.setState(FlagIndicator.STATE_AT_BASE);
        }
        public function showFlagCarried(teamType:BattleTeamType):void
        {
            var flagInficator:FlagIndicator = this.getFlagInficator(teamType);
            flagInficator.setState(FlagIndicator.STATE_CARRIED);
        }
        public function showFlagDropped(teamType:BattleTeamType):void
        {
            var flagInficator:FlagIndicator = this.getFlagInficator(teamType);
            flagInficator.setState(FlagIndicator.STATE_DROPPED);
        }
        public function setTeamScore(teamType:BattleTeamType, score:int):void
        {
            switch (teamType)
            {
                case BattleTeamType.BLUE:
                    this.blueScore = score;
                    break;
                case BattleTeamType.RED:
                    this.redScore = score;
            }
        }
        private function update():void
        {
            var x:int;
            var spacing:int = 5;
            var maxLabelWidth:int = ((this.labelRed.width > this.labelBlue.width) ? int(this.labelRed.width) : int(this.labelBlue.width));
            this.redIndicator.x = (spacing + spacing);
            x = ((this.redIndicator.x + ICON_WIDTH) + spacing);
            this.labelRed.x = (x + ((maxLabelWidth - this.labelRed.width) >> 1));
            x = (x + ((maxLabelWidth + spacing) + spacing));
            this.labelBlue.x = (x + ((maxLabelWidth - this.labelBlue.width) >> 1));
            x = (x + (maxLabelWidth + spacing));
            this.blueIndicator.x = x;
            x = (x + ((ICON_WIDTH + spacing) + spacing));
            this.updateBgAndBorder(x);
        }
        private function updateBgAndBorder(width:int):void
        {
            this.border.width = width;
            var fillType:String = GradientType.LINEAR;
            var colors:Array = [BG_COLOR_RED, BG_COLOR_BLUE];
            var alphas:Array = [1, 1];
            var r:int = int(((8 / width) * 0xFF));
            var ratios:Array = [(127 - r), (127 + r)];
            var borderWidth:int = 2;
            var matrix:Matrix = new Matrix();
            matrix.createGradientBox((width - (2 * borderWidth)), (this.border.height - (2 * borderWidth)), 0, 0, 0);
            var spreadMethod:String = SpreadMethod.PAD;
            var g:Graphics = graphics;
            g.clear();
            g.beginGradientFill(fillType, colors, alphas, ratios, matrix, spreadMethod);
            g.drawRect(borderWidth, borderWidth, (width - (2 * borderWidth)), (this.border.height - (2 * borderWidth)));
            g.endFill();
        }
        private function createLabel(color:uint):Label
        {
            var label:Label = new Label();
            label.color = color;
            label.size = 18;
            label.bold = true;
            label.autoSize = TextFieldAutoSize.CENTER;
            label.y = LABEL_Y;
            label.text = "0";
            addChild(label);
            return (label);
        }
        private function onAddedToStage(event:Event):void
        {
            this.update();
            this.time = getTimer();
            stage.addEventListener(Event.ENTER_FRAME, this.onEnterFrame, false, 0, false);
        }
        private function onRemovedFromStage(event:Event):void
        {
            stage.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
        }
        private function onEnterFrame(event:Event):void
        {
            var now:int = getTimer();
            var delta:int = (now - this.time);
            this.time = now;
            this.blinker.update(now, delta);
            this.redIndicator.update(now, delta);
            this.blueIndicator.update(now, delta);
            this.updateScoreColor(this.labelRed, this.redInterpolator, this.blueIndicator.flashBitmap);
            this.updateScoreColor(this.labelBlue, this.blueInterpolator, this.redIndicator.flashBitmap);
        }
        private function updateScoreColor(scoreField:Label, interpolator:ColorInterpolator, flashBitmap:Bitmap):void
        {
            var newColor:uint;
            if (flashBitmap.visible)
            {
                newColor = interpolator.interpolate(flashBitmap.alpha);
            }
            else
            {
                newColor = interpolator.startColor;
            }
            if (newColor != scoreField.textColor)
            {
                scoreField.textColor = newColor;
            }
        }
        private function getFlagInficator(teamType:BattleTeamType):FlagIndicator
        {
            switch (teamType)
            {
                case BattleTeamType.BLUE:
                    return (this.blueIndicator);
                case BattleTeamType.RED:
                    return (this.redIndicator);
                default:
                    throw (new ArgumentError("Unsupported team type"));
            }
        }

    }
}

import flash.display.Shape;
import flash.geom.Matrix;
import flash.display.Graphics;
import flash.display.GradientType;

class ColorInterpolator
{

    public var startColor:uint;
    private var endColor:uint;
    private var deltaRed:Number;
    private var deltaGreen:Number;
    private var deltaBlue:Number;

    public function ColorInterpolator(startColor:uint, endColor:uint)
    {
        this.startColor = startColor;
        this.endColor = endColor;
        this.deltaRed = (((endColor >> 16) & 0xFF) - ((startColor >> 16) & 0xFF));
        this.deltaGreen = (((endColor >> 8) & 0xFF) - ((startColor >> 8) & 0xFF));
        this.deltaBlue = ((endColor & 0xFF) - (startColor & 0xFF));
    }
    public function interpolate(t:Number):uint
    {
        var r:int = (((this.startColor >> 16) & 0xFF) + (t * this.deltaRed));
        var g:int = (((this.startColor >> 8) & 0xFF) + (t * this.deltaGreen));
        var b:int = ((this.startColor & 0xFF) + (t * this.deltaBlue));
        return (((r << 16) | (g << 8)) | b);
    }

}

class FlashMask extends Shape
{

    private static const STATE_GROW:int = 1;
    private static const STATE_WAIT:int = 2;
    private static const STATE_FADE:int = 3;
    private static const GROW_SPEED:Number = (10 / 1000);
    private static const FADE_SPEED:Number = (1 / 1000);
    private static const MAX_WAIT_TIME:int = 200;

    private var m:Matrix = new Matrix();
    private var state:int;
    private var waitTime:int;

    public function FlashMask()
    {
        blendMode = "add";
        visible = false;
    }
    public function init(x:int, y:int, w:int, h:int, color:uint):void
    {
        this.x = x;
        this.y = y;
        this.m.createGradientBox(w, h);
        var g:Graphics = graphics;
        g.clear();
        g.beginGradientFill(GradientType.RADIAL, [color, 0], [1, 1], [127, 0xFF], this.m);
        g.drawRect(0, 0, w, h);
        g.endFill();
        visible = true;
        alpha = 0;
        this.state = STATE_GROW;
    }
    public function update(delta:int):Boolean
    {
        switch (this.state)
        {
            case STATE_GROW:
                alpha = (alpha + (GROW_SPEED * delta));
                if (alpha >= 1)
                {
                    alpha = 1;
                    this.state = STATE_WAIT;
                    this.waitTime = MAX_WAIT_TIME;
                }
                break;
            case STATE_WAIT:
                this.waitTime = (this.waitTime - delta);
                if (this.waitTime <= 0)
                {
                    this.state = STATE_FADE;
                }
                break;
            case STATE_FADE:
                alpha = (alpha - (FADE_SPEED * delta));
                if (alpha <= 0)
                {
                    visible = false;
                    return (false);
                }
                break;
        }
        return (true);
    }

}
