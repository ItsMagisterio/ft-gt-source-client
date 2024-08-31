// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// scpacker.gui.AlertBugWindow

package logic.gui
{
    import flash.display.Sprite;
    import controls.TankWindow;
    import controls.TankWindowInner;
    import controls.DefaultButton;
    import fl.controls.UIScrollBar;
    import controls.Label;
    import flash.text.TextFieldAutoSize;
    import assets.scroller.color.ScrollTrackBlue;
    import assets.scroller.color.ScrollThumbSkinBlue;
    import flash.filters.GlowFilter;
    import flash.events.MouseEvent;
    import alternativa.init.Main;
    import flash.events.Event;

    public class AlertBugWindow extends Sprite
    {

        private var window:TankWindow = new TankWindow();
        private var windowInner:TankWindowInner = new TankWindowInner(-1, -1, TankWindowInner.RED);
        private var btnOk:DefaultButton = new DefaultButton();
        private var scrollBar:UIScrollBar = new UIScrollBar();
        private var errorText:Label = new Label();

        public function AlertBugWindow()
        {
            addChild(this.window);
            this.window.addChild(this.windowInner);
            this.window.addChild(this.btnOk);
            this.window.addChild(this.errorText);
            this.window.addChild(this.scrollBar);
            this.window.width = 450;
            this.window.height = 250;
            this.windowInner.width = 430;
            this.windowInner.height = 200;
            this.windowInner.x = 10;
            this.windowInner.y = 10;
            this.btnOk.x = ((this.window.width / 2) - (this.btnOk.width / 2));
            this.btnOk.y = (this.windowInner.height + 12);
            this.errorText.x = 20;
            this.errorText.y = 15;
            this.errorText.wordWrap = true;
            this.errorText.autoSize = TextFieldAutoSize.NONE;
            this.errorText.selectable = true;
            this.errorText.width = 410;
            this.errorText.height = 190;
            this.scrollBar.setSize((this.errorText.width + 5), (this.errorText.y + 5));
            this.btnOk.label = "OK";
            this.errorText.multiline = true;
            this.scrollBar.scrollTarget = this.errorText;
            this.scrollBar.move((this.errorText.x + this.errorText.width), this.errorText.y);
            this.scrollBar.setSize(this.scrollBar.width, this.errorText.height);
            this.scrollBar.setStyle("downArrowUpSkin", ScrollArrowDownBlue);
            this.scrollBar.setStyle("downArrowDownSkin", ScrollArrowDownBlue);
            this.scrollBar.setStyle("downArrowOverSkin", ScrollArrowDownBlue);
            this.scrollBar.setStyle("downArrowDisabledSkin", ScrollArrowDownBlue);
            this.scrollBar.setStyle("upArrowUpSkin", ScrollArrowUpBlue);
            this.scrollBar.setStyle("upArrowDownSkin", ScrollArrowUpBlue);
            this.scrollBar.setStyle("upArrowOverSkin", ScrollArrowUpBlue);
            this.scrollBar.setStyle("upArrowDisabledSkin", ScrollArrowUpBlue);
            this.scrollBar.setStyle("trackUpSkin", new ScrollTrackBlue());
            this.scrollBar.setStyle("trackDownSkin", ScrollTrackBlue);
            this.scrollBar.setStyle("trackOverSkin", ScrollTrackBlue);
            this.scrollBar.setStyle("trackDisabledSkin", ScrollTrackBlue);
            this.scrollBar.setStyle("thumbUpSkin", ScrollThumbSkinBlue);
            this.scrollBar.setStyle("thumbDownSkin", ScrollThumbSkinBlue);
            this.scrollBar.setStyle("thumbOverSkin", ScrollThumbSkinBlue);
            this.scrollBar.setStyle("thumbDisabledSkin", ScrollThumbSkinBlue);
            this.errorText.filters = [new GlowFilter(0)];
            this.errorText.textColor = 0xFFFFFF;
            this.btnOk.addEventListener(MouseEvent.CLICK, this.remove);
            Main.stage.addEventListener(Event.RESIZE, this.resize);
            this.resize(null);
        }
        private function resize(e:Event):void
        {
            this.window.x = ((Main.stage.width / 2) - (this.window.width / 2));
            this.window.y = ((Main.stage.height / 2) - (this.window.height / 2));
        }
        private function remove(e:MouseEvent):void
        {
            parent.removeChild(this);
        }
        public function set text(_text:String):void
        {
            this.errorText.text = _text;
            this.scrollBar.update();
            this.scrollBar.setSize(this.scrollBar.width, this.errorText.height);
        }

    }
} // package scpacker.gui