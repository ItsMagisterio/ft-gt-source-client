package controls.statassets
{
    import flash.display.Sprite;
    import alternativa.osgi.service.locale.ILocaleService;
    import alternativa.init.Main;
    import alternativa.tanks.locale.constants.TextConst;
    import flash.events.MouseEvent;
    import forms.events.StatListEvent;

    public class ReferralStatHeader extends Sprite
    {

        protected var tabs:Array = new Array();
        protected var headers:Array;
        protected var _currentSort:int = 1;
        protected var _oldSort:int = 1;
        protected var _width:int = 800;

        public function ReferralStatHeader()
        {
            var cell:StatHeaderButton;
            super();
            var localeService:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
            this.headers = [localeService.getText(TextConst.REFERAL_STATISTICS_HEADER_CALLSIGN), localeService.getText(TextConst.REFERAL_STATISTICS_HEADER_INCOME)];
            var i:int;
            while (i < 2)
            {
                cell = new StatHeaderButton((i == 1));
                cell.label = this.headers[i];
                cell.height = 18;
                cell.numSort = i;
                addChild(cell);
                cell.addEventListener(MouseEvent.CLICK, this.changeSort);
                i++;
            }
            this.draw();
        }
        protected function draw():void
        {
            var cell:StatHeaderButton;
            var infoX:int = int((this._width - 345));
            this.tabs = [0, (this._width - 120), (this._width - 1)];
            var i:int;
            while (i < 2)
            {
                cell = (getChildAt(i) as StatHeaderButton);
                cell.width = ((this.tabs[(i + 1)] - this.tabs[i]) - 2);
                cell.x = this.tabs[i];
                cell.selected = (i == this._currentSort);
                i++;
            }
        }
        protected function changeSort(e:MouseEvent):void
        {
            var trgt:StatHeaderButton = (e.currentTarget as StatHeaderButton);
            this._currentSort = trgt.numSort;
            if (this._currentSort != this._oldSort)
            {
                this.draw();
                dispatchEvent(new StatListEvent(StatListEvent.UPDATE_SORT, 0, 0, this._currentSort));
                this._oldSort = this._currentSort;
            }
        }
        override public function set width(w:Number):void
        {
            this._width = Math.floor(w);
            this.draw();
        }

    }
}
