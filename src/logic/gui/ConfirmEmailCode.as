﻿// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// scpacker.gui.ConfirmEmailCode

package logic.gui
{
    import flash.display.Sprite;
    import controls.TankWindow;
    import controls.Label;
    import controls.TankInput;
    import controls.DefaultButton;
    import flash.display.Bitmap;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.display.BitmapData;
    import flash.filters.BlurFilter;
    import flash.filters.BitmapFilterQuality;
    import flash.filters.BitmapFilter;

    public class ConfirmEmailCode extends Sprite
    {

        private var text:String;
        private var callback:Function;
        private var window:TankWindow = new TankWindow();
        private var textLabel:Label = new Label();
        private var codeInput:TankInput = new TankInput();
        private var confirmButton:DefaultButton = new DefaultButton();
        private var bg:Sprite = new Sprite();
        private var bmp:Bitmap = new Bitmap();

        public function ConfirmEmailCode(text:String, callback:Function)
        {
            this.text = text;
            this.callback = callback;
            addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        }
        private function draw():void
        {
            addChild(this.bg);
            this.drawBg();
            addChild(this.window);
            this.window.width = 400;
            this.window.height = 115;
            this.window.addChild(this.textLabel);
            this.textLabel.text = this.text;
            this.textLabel.x = 15;
            this.textLabel.y = 15;
            this.window.addChild(this.codeInput);
            this.codeInput.maxChars = 32;
            this.codeInput.x = 15;
            this.codeInput.y = 35;
            this.codeInput.width = (this.window.width - 30);
            this.window.addChild(this.confirmButton);
            this.confirmButton.label = "OK";
            this.confirmButton.x = ((this.window.width - this.confirmButton.width) - 15);
            this.confirmButton.y = (35 * 2);
            this.confirmButton.addEventListener(MouseEvent.CLICK, this.onClickButton);
        }
        private function onClickButton(event:Event):void
        {
            var code:String = this.codeInput.value;
            if ((((code == null) || (!(code.length == 32))) || (code.length > 32)))
            {
                this.codeInput.validValue = false;
                return;
            }
            this.codeInput.validValue = true;
            this.callback.call(null, code);
            this.confirmButton.removeEventListener(MouseEvent.CLICK, this.onClickButton);
            stage.removeEventListener(Event.RESIZE, this.resize);
            removeChildren(0, (numChildren - 1));
        }
        private function drawBg():void
        {
            var data:BitmapData;
            var filter:BitmapFilter = new BlurFilter(5, 5, BitmapFilterQuality.HIGH);
            var myFilters:Array = new Array();
            myFilters.push(filter);
            data = new BitmapData(stage.stageWidth, stage.stageHeight, true, 0);
            this.bmp.visible = false;
            data.draw(stage);
            this.bmp.visible = true;
            this.bmp.filters = myFilters;
            this.bmp.bitmapData = data;
            this.bg.addChild(this.bmp);
        }
        private function onAddedToStage(event:Event):void
        {
            this.draw();
            stage.addEventListener(Event.RESIZE, this.resize);
            this.resize(null);
            removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        }
        private function resize(event:Event):void
        {
            this.window.x = ((stage.stageWidth / 2) - (this.window.width / 2));
            this.window.y = ((stage.stageHeight / 2) - (this.window.height / 2));
            this.drawBg();
        }

    }
} // package scpacker.gui