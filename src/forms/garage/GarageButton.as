package forms.garage
{
    import alternativa.tanks.help.HelpService;
    import controls.BigButton;
    import alternativa.osgi.service.locale.ILocaleService;
    import alternativa.init.Main;
    import alternativa.tanks.locale.constants.TextConst;
    import flash.display.BitmapData;
    import controls.Label;
    import forms.ranks.SmallRankIcon;

    import flash.display.Sprite;
    import assets.Diamond;
    import flash.filters.DropShadowFilter;
    import flash.events.MouseEvent;

    public class GarageButton extends BigButton
    {

        private static const RANK_LABEL:String = (ILocaleService(Main.osgi.getService(ILocaleService)) as ILocaleService).getText(TextConst.GARAGE_BUY_BUTTON_RANK_LABEL);

        protected var bmp:BitmapData;

        private var kek:Boolean;

        public function setInfo(crystal:int = 0, rank:int = 0):void
        {

            var rangLabel:Label;
            var rangIcon:SmallRankIcon;
            var cont:Sprite = new Sprite();
            var c_price:Label = new Label();
            rangLabel = new Label();
            rangIcon = new SmallRankIcon();
            var diamond:Diamond = new Diamond();
            if (((crystal == 0) && (rank >= 0)))
            {
                this.kek = false;
                this.bmp = new BitmapData(40, 20, true, 0x80FF0000);
                this.icon = this.bmp;
            }
            else
            {
                this.kek = true;
                if (crystal < 0)
                {
                    c_price.color = 0xFF4E00;
                    c_price.sharpness = -100;
                    c_price.thickness = 100;
                }
                if (rank < 0)
                {
                    rangLabel.color = 0xFF4E00;
                    rangLabel.sharpness = -100;
                    rangLabel.thickness = 100;
                }
                else
                {
                    rank = 0;
                }
                rangLabel.filters = (c_price.filters = [new DropShadowFilter(1, 45, 0, 0.7, 1, 1, 1)]);
                crystal = ((crystal < 0) ? -(crystal) : crystal);
                rank = ((rank < 0) ? -(rank) : rank);
                if (crystal > 0)
                {
                    c_price.text = String(crystal);
                    c_price.x = 0;
                    c_price.y = 0;
                    cont.addChild(diamond);
                    cont.addChild(c_price);
                    diamond.x = (c_price.textWidth + 5);
                    diamond.y = 4;
                }
                if (rank > 0)
                {
                    rangIcon.setRank(rank);
                    cont.addChild(rangLabel);
                    rangLabel.y = 0;
                    rangLabel.x = (cont.width + 4);
                    rangLabel.text = RANK_LABEL;
                    rangIcon.y = (rangLabel.y + 3);
                    rangIcon.x = (cont.width - 1);
                    cont.addChild(rangIcon);
                }
                cont.x = (cont.x - (96 - cont.width));
                this.bmp = new BitmapData(cont.width, cont.height, true, 0);
                this.bmp.draw(cont);
                this.icon = this.bmp;
            }
        }
        override public function set width(w:Number):void
        {
            _width = int(w);
            stateDOWN.width = (stateOFF.width = (stateOVER.width = (stateUP.width = _width)));
            _info.width = (_label.width = (_width - 4));
            if (_icon.bitmapData != null)
            {
                _icon.x = ((_width - _icon.width) >> 1);
                _icon.y = 25;
            }
        }
        override public function set icon(icoBMP:BitmapData):void
        {
            if (icoBMP != null)
            {
                _icon.visible = true;
                _label.y = 8;
            }
            else
            {
                _label.width = (_width - 4);
                _icon.visible = false;
                _label.y = 15;
            }
            if (this.kek == false)
            {
                _label.width = (_width - 4);
                _icon.visible = false;
                _label.y = 15;
                _icon.bitmapData = null;
            }
            _icon.bitmapData = icoBMP;
            this.width = _width;
        }
        override protected function onMouseEvent(event:MouseEvent):void
        {
            if (_enable)
            {
                switch (event.type)
                {
                    case MouseEvent.MOUSE_OVER:
                        setState(2);
                        break;
                    case MouseEvent.MOUSE_OUT:
                        setState(1);
                        break;
                    case MouseEvent.MOUSE_DOWN:
                        setState(3);
                        break;
                    case MouseEvent.MOUSE_UP:
                        setState(1);
                        break;
                }
                if (_icon.bitmapData != null && this.kek)
                {
                    _icon.y = (25 + ((event.type == MouseEvent.MOUSE_DOWN) ? 1 : 0));
                    _label.y = (8 + ((event.type == MouseEvent.MOUSE_DOWN) ? 1 : 0));
                }
                else
                {
                    _label.y = (15 + ((event.type == MouseEvent.MOUSE_DOWN) ? 1 : 0));
                }
            }
        }

    }
}
