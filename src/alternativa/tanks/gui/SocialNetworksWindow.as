﻿package alternativa.tanks.gui
{
    import flash.display.Sprite;
    import forms.TankWindowWithHeader;
    import controls.TankWindowInner;
    import controls.DefaultButton;
    import flash.display.Bitmap;
    import controls.Label;
    import alternativa.osgi.service.locale.ILocaleService;
    import alternativa.init.Main;
    import alternativa.tanks.locale.constants.TextConst;
    import flash.events.MouseEvent;
    import flash.net.URLLoader;
    import flash.events.Event;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;

    public class SocialNetworksWindow extends Sprite
    {

        private static const iconBitmap:Class = SocialNetworksWindow_iconBitmap;

        private var window:TankWindowWithHeader = TankWindowWithHeader.createWindow("SOCIAL NETWORKS");
        private var innerWindow:TankWindowInner = new TankWindowInner(0, 0, TankWindowInner.GREEN);
        public var closeBtn:DefaultButton = new DefaultButton();
        public var discordBtn:DefaultButton = new DefaultButton();
        public var vkBtn:DefaultButton = new DefaultButton();
        public var forumBtn:DefaultButton = new DefaultButton();
        private var bitmap:Bitmap = new Bitmap(new iconBitmap().bitmapData);
        private var discordUrl:String;
        private var vkUrl:String;
        private var forumUrl:String;
        private var descText:Label = new Label();
        public var windowWidth:*;
        public var windowHeight:*;

        public function SocialNetworksWindow()
        {
            this.window.width = 340;
            this.windowWidth = 340;
            this.window.height = 370;
            this.windowHeight = 370;
            addChild(this.window);
            this.innerWindow.width = (this.window.width - 30);
            this.innerWindow.height = (this.window.height - 65);
            this.innerWindow.x = 15;
            this.innerWindow.y = 15;
            addChild(this.innerWindow);
            this.closeBtn.x = ((this.window.width - this.closeBtn.width) - 15);
            this.closeBtn.y = ((this.window.height - this.closeBtn.height) - 15);
            this.closeBtn.label = ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.FREE_BONUSES_WINDOW_BUTTON_CLOSE_TEXT);
            addChild(this.closeBtn);
            this.parseLinks();
            this.initButtons();
            this.initText();
        }
        private function initButtons():void
        {
            this.discordBtn.x = (this.innerWindow.x + 5);
            this.discordBtn.y = (this.innerWindow.y + 5);
            this.discordBtn.label = "DISCORD";
            this.discordBtn.addEventListener(MouseEvent.CLICK, this.openUrl);
            addChild(this.discordBtn);
            this.vkBtn.x = ((this.discordBtn.x + this.discordBtn.width) + 5);
            this.vkBtn.y = (this.innerWindow.y + 5);
            this.vkBtn.label = "VK GROUP";
            this.vkBtn.addEventListener(MouseEvent.CLICK, this.openUrl);
            addChild(this.vkBtn);
            this.forumBtn.x = ((this.vkBtn.x + this.vkBtn.width) + 5);
            this.forumBtn.y = (this.innerWindow.y + 5);
            this.forumBtn.label = "FORUM";
            this.forumBtn.addEventListener(MouseEvent.CLICK, this.openUrl);
            addChild(this.forumBtn);
        }
        private function initText():void
        {
            this.descText.color = 5898034;
            this.descText.text = "Социальная сеть — онлайн-платформа, которая\nиспользуется для общения, знакомств,\nсоздания социальных отношений между танкистами,\nкоторые имеют схожие интересы, а также для\nразвлечения и работы";
            this.descText.x = 5;
            this.descText.y = (this.discordBtn.y + 20);
            this.innerWindow.addChild(this.descText);
            this.bitmap.x = ((this.innerWindow.width / 2) - (this.bitmap.width / 2));
            this.bitmap.y = ((this.descText.y + this.descText.height) + 10);
            this.innerWindow.addChild(this.bitmap);
        }
        private function parseLinks():void
        {
            var urlLoader:URLLoader;
            urlLoader = new URLLoader();
            urlLoader.addEventListener(Event.COMPLETE, function():void
                {
                    discordUrl = JSON.parse(urlLoader.data).discordUrl;
                    vkUrl = JSON.parse(urlLoader.data).vkUrl;
                    forumUrl = JSON.parse(urlLoader.data).forumUrl;
                });
            urlLoader.load(new URLRequest("socialNetworksUrl.json"));
        }
        private function openUrl(e:MouseEvent):void
        {
            var target:DefaultButton;
            if ((e.currentTarget as DefaultButton) != null)
            {
                target = (e.currentTarget as DefaultButton);
                switch (target.label)
                {
                    case "DISCORD":
                        navigateToURL(new URLRequest(this.discordUrl), "_self");
                        break;
                    case "VK GROUP":
                        navigateToURL(new URLRequest(this.vkUrl), "_self");
                        break;
                    case "FORUM":
                        navigateToURL(new URLRequest(this.forumUrl), "_self");
                        break;
                }
            }
        }

    }
}
