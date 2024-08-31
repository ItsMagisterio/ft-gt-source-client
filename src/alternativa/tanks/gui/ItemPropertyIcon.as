package alternativa.tanks.gui
{
    import flash.display.Sprite;
    import flash.display.Bitmap;
    import controls.Label;
    import flash.text.TextFormatAlign;
    import flash.display.BitmapData;
    import com.alternativaplatform.projects.tanks.client.commons.models.itemtype.ItemTypeEnum;

    public class ItemPropertyIcon extends Sprite
    {

        private const space:int = 2;

        public var bmp:Bitmap;
        private var label:Label;
        private var _module:String;
        private var _text:String;

        public function ItemPropertyIcon(icon:BitmapData, module:String, res:Boolean = false)
        {
            this._module = module;
            this.bmp = new Bitmap(icon);
            addChild(this.bmp);
            this.label = new Label();
            this.label.size = 12;
            addChild(this.label);
            this.label.text = this._module;
            this.label.color = 0xFFFFFF;
            this.label.align = TextFormatAlign.CENTER;
            this.label.sharpness = -100;
            this.label.thickness = 100;
            this.label.alpha = res ? 1 : 0;
            this.posLabel();
            this.label.y = (this.bmp.height + this.space);
            if(res){
                this.label.y -= 5;
            }
        }
        public function set labelText(text:String):void
        {
            if (((!(text == null)) && (!(text == "null"))))
            {
                this._text = text;
            }
            else
            {
                this._text = "—";
            }
            this.label.text = ((this._module + "\n") + this._text);
            if(this._text.indexOf("1200") != -1){
                this.label.alpha = 1;
                this.label.text = this._text;
            }
            this.posLabel();
        }
        private function posLabel():void
        {
            if (this.bmp.width > this.label.textWidth)
            {
                this.label.x = (Math.round(((this.bmp.width - this.label.textWidth) * 0.5)) - 3);
            }
            else
            {
                if (this.label.textWidth > this.bmp.width)
                {
                    this.label.x = (-(Math.round(((this.label.textWidth - this.bmp.width) * 0.5))) - 3);
                }
                else
                {
                    this.label.x = -3;
                }
            }
        }

        public function posUpgradeLabel(type:ItemTypeEnum, index:int):void
        {
            if (type == ItemTypeEnum.WEAPON)
            {
                switch (this._module)
                {
                    case "hp/sec":
                        this.label.text = "Damage";
                        if (index == 1)
                        {
                            this.label.text = "Healing";
                        }
                        break;
                    case "grad/sec":
                        this.label.text = "Rotation speed";
                        break;
                    case "m":
                        this.label.text = "Range";
                        break;
                    case "grad":
                        this.label.text = "Spreading angle";
                        break;
                    case "shot/min":
                        this.label.text = "Reloading time";
                        break;
                    case "hp":
                        this.label.text = "Damage";
                        break;
                    case "grad":
                        this.label.text = "Spreading angle";
                        break;
                }
            }
            else if (type == ItemTypeEnum.ARMOR)
            {
                switch (this._module)
                {
                    case "hp":
                        this.label.text = "Protection";
                        break;
                    case "m/sec":
                        this.label.text = "Maximum speed";
                        break;
                    case "grad/sec":
                        this.label.text = "Turning speed";
                        break;
                }
            }

            this.label.text += ":";
            this.label.color = 0xffffff;
            this.label.size = 11;
            this.label.align = TextFormatAlign.CENTER;
            this.label.sharpness = -100;
            this.label.thickness = 100;
            this.label.x = bmp.x + bmp.width + 12;
            this.label.y = bmp.y + bmp.height / 4 - 2;
        }

        public function get labelCoord():int
        {
            return (this.label.x);
        }

        public function get labelText():String
        {
            return (this.label.text);
        }

        public function clone():ItemPropertyIcon
        {
            var icon:ItemPropertyIcon = new ItemPropertyIcon(this.bmp.bitmapData, this._module);
            icon.label.alpha = 1;
            return icon;
        }

    }
}
