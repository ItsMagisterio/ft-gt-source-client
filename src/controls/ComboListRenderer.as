package controls
{
    import fl.controls.listClasses.CellRenderer;
    import flash.text.TextFormat;
    import flash.display.DisplayObject;
    import flash.display.Bitmap;
    import assets.combo.ComboListOverState;
    import flash.display.BitmapData;

    import flash.display.Sprite;
    import flash.text.TextFieldAutoSize;
    import fl.controls.listClasses.ListData;
    import forms.ranks.SmallRankIcon;

    public class ComboListRenderer extends CellRenderer
    {

        private var format:TextFormat = new TextFormat("MyriadPro", 13);
        private var nicon:DisplayObject;
        private var normalStyle:Bitmap;
        private var overStyle:ComboListOverState = new ComboListOverState();

        override public function set data(_arg_1:Object):void
        {
            var _local_2:ButtonState;
            this.normalStyle = new Bitmap(new BitmapData(1, 1, true, 0));
            _data = _arg_1;
            setStyle("upSkin", this.normalStyle);
            setStyle("downSkin", this.overStyle);
            setStyle("overSkin", this.overStyle);
            setStyle("selectedUpSkin", this.normalStyle);
            setStyle("selectedOverSkin", this.overStyle);
            setStyle("selectedDownSkin", this.overStyle);
        }
        private function myIcon(_arg_1:Object):Sprite
        {
            var _local_3:Label;
            var _local_4:SmallRankIcon;
            var _local_2:Sprite = new Sprite();
            _local_3 = new Label();
            _local_3.autoSize = TextFieldAutoSize.NONE;
            _local_3.color = 0xFFFFFF;
            _local_3.alpha = ((_arg_1.rang > 0) ? 0.5 : 1);
            _local_3.text = _arg_1.gameName;
            _local_3.height = 20;
            _local_3.width = (_width - 20);
            _local_3.x = 12;
            _local_3.y = 0;
            if (_arg_1.rang > 0)
            {
                _local_4 = new SmallRankIcon(_arg_1.rang, _arg_1.isPremium);
                _local_4.x = -2;
                _local_4.y = 2;
                _local_2.addChild(_local_4);
            }
            _local_2.addChild(_local_3);
            return (_local_2);
        }
        override public function set listData(_arg_1:ListData):void
        {
            _listData = _arg_1;
            label = "";
            this.nicon = this.myIcon(_data);
            if (this.nicon != null)
            {
                setStyle("icon", this.nicon);
            }
        }
        override protected function drawIcon():void
        {
            var _local_1:DisplayObject = icon;
            var _local_2:String = ((enabled) ? mouseState : "disabled");
            if (selected)
            {
                _local_2 = (("selected" + _local_2.substr(0, 1).toUpperCase()) + _local_2.substr(1));
            }
            _local_2 = (_local_2 + "Icon");
            var _local_3:Object = getStyleValue(_local_2);
            if (_local_3 == null)
            {
                _local_3 = getStyleValue("icon");
            }
            if (_local_3 != null)
            {
                icon = getDisplayObjectInstance(_local_3);
            }
            if (icon != null)
            {
                addChildAt(icon, 1);
            }
            if ((((!(_local_1 == null)) && (!(_local_1 == icon))) && (_local_1.parent == this)))
            {
                removeChild(_local_1);
            }
        }

    }
}
