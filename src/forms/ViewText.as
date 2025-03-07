﻿package forms
{
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import fl.controls.UIScrollBar;
    import controls.DefaultButton;
    import flash.events.Event;
    import alternativa.osgi.service.locale.ILocaleService;
    import alternativa.init.Main;
    import controls.TankWindow;
    import flash.text.AntiAliasType;
    import alternativa.tanks.locale.constants.TextConst;
    import flash.events.MouseEvent;

    public class ViewText extends Sprite
    {

        private var output:TextField = new TextField();
        private var format:TextFormat = new TextFormat("MyriadPro", 13);
        private var scrollBar:UIScrollBar = new UIScrollBar();
        public var closeButton:DefaultButton = new DefaultButton();

        public function ViewText()
        {
            addEventListener(Event.ADDED_TO_STAGE, this.doLayout);
        }
        private function doLayout(e:Event):void
        {
            var localeService:ILocaleService;
            localeService = (Main.osgi.getService(ILocaleService) as ILocaleService);
            var bg:TankWindow = new TankWindow(400, 500);
            bg.x = -200;
            addChild(bg);
            removeEventListener(Event.ADDED_TO_STAGE, this.doLayout);
            this.format.color = 0xFFFFFF;
            addChild(this.output);
            this.output.background = false;
            this.output.multiline = true;
            this.output.wordWrap = true;
            this.output.x = -165;
            this.output.y = 35;
            this.output.width = 315;
            this.output.height = 375;
            this.output.embedFonts = true;
            this.output.antiAliasType = AntiAliasType.ADVANCED;
            this.output.sharpness = -200;
            this.output.defaultTextFormat = this.format;
            addChild(this.scrollBar);
            this.scrollBar.move((this.output.x + this.output.width), this.output.y);
            this.scrollBar.setSize(this.scrollBar.width, this.output.height);
            this.scrollBar.scrollTarget = this.output;
            addChild(this.closeButton);
            this.closeButton.x = -52;
            this.closeButton.y = 435;
            this.closeButton.label = localeService.getText(TextConst.ALERT_ANSWER_OK);
            this.closeButton.addEventListener(MouseEvent.CLICK, this.hide);
            stage.addEventListener(Event.RESIZE, this.onResize);
            this.onResize(null);
        }
        private function onResize(e:Event):void
        {
            this.x = int((stage.stageWidth / 2));
            this.y = int(((stage.stageHeight / 2) - (this.height / 2)));
        }
        private function hide(e:MouseEvent):void
        {
            this.closeButton.removeEventListener(MouseEvent.CLICK, this.hide);
            stage.removeEventListener(Event.RESIZE, this.onResize);
            this.visible = false;
            parent.removeChild(this);
        }
        public function set text(itext:String):void
        {
            this.output.text = itext;
            this.scrollBar.update();
            if (this.scrollBar.maxScrollPosition == 0)
            {
                this.scrollBar.visible = false;
            }
        }

    }
}
