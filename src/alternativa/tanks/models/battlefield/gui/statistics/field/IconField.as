﻿package alternativa.tanks.models.battlefield.gui.statistics.field
{
    import flash.display.Sprite;
    import assets.icons.BattleInfoIcons;
    import controls.Label;
    import flash.display.Bitmap;

    public class IconField extends Sprite
    {

        private static const dom:Class = IconField_dom;

        protected var icon:BattleInfoIcons;
        protected var iconType:int;
        protected var label:Label;
        private var addicitonIcon:Bitmap;

        public function IconField(iconType:int = -1)
        {
            this.iconType = iconType;
            this.init();
        }
        protected function init():void
        {
            if (this.iconType == 10)
            {
                this.addicitonIcon = new Bitmap(new dom().bitmapData);
                addChild(this.addicitonIcon);
                this.addicitonIcon.x = 0;
                this.addicitonIcon.y = 2;
            }
            else
            {
                if (this.iconType > -1)
                {
                    this.icon = new BattleInfoIcons();
                    this.icon.type = this.iconType;
                    addChild(this.icon);
                    this.icon.x = 0;
                    this.icon.y = 0;
                }
            }
            this.label = new Label();
            this.label.color = 0xFFFFFF;
            if (this.icon)
            {
                this.label.x = (this.icon.width + 3);
            }
            if (this.addicitonIcon)
            {
                this.label.x = (this.addicitonIcon.width + 3);
            }
            addChild(this.label);
        }
        public function set text(value:String):void
        {
            this.label.htmlText = value;
        }
        public function set size(value:Number):void
        {
            this.label.size = value;
        }

    }
}
