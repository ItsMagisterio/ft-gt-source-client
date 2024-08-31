package forms.stat
{
    import flash.display.Sprite;
    import controls.statassets.ReferralStatHeader;
    import fl.controls.List;
    import fl.data.DataProvider;
    import flash.display.DisplayObject;
    import flash.utils.Timer;
    import flash.events.Event;
    import controls.statassets.StatLineBase;
    import flash.display.BitmapData;
    import controls.statassets.StatLineSelectedActive;
    import controls.statassets.StatLineNormalActive;
    import controls.statassets.StatLineSelected;
    import controls.statassets.StatLineNormal;
    import forms.events.StatListEvent;
    import alternativa.init.Main;
    import controls.statassets.ReferalStatLineBackgroundNormal;
    import flash.display.Bitmap;
    import controls.statassets.ReferalStatLineBackgroundSelected;
    import assets.scroller.color.ScrollTrackGreen;
    import assets.scroller.color.ScrollThumbSkinGreen;

    public class ReferralStatList extends Sprite
    {

        private var header:ReferralStatHeader = new ReferralStatHeader();
        protected var list:List = new List();
        protected var dp:DataProvider = new DataProvider();
        protected var currentSort:int = 1;
        protected var nr:DisplayObject;
        protected var sl:DisplayObject;
        protected var timer:Timer = null;
        protected var _width:int = 100;
        private var _height:int = 100;

        public function ReferralStatList()
        {
            addEventListener(Event.ADDED_TO_STAGE, this.ConfigUI);
        }
        public static function setBackground(_width:int, currentSort:int, _selected:Boolean):BitmapData
        {
            var cont:Sprite;
            var cell:StatLineBase;
            cont = new Sprite();
            var cells:Array = [0, (_width - 120), (_width - 1)];
            var i:int;
            var data:BitmapData = new BitmapData(_width, 20, true, 0);
            i = 0;
            while (i < 2)
            {
                if (currentSort == i)
                {
                    if (_selected)
                    {
                        cell = new StatLineSelectedActive();
                    }
                    else
                    {
                        cell = new StatLineNormalActive();
                    }
                }
                else
                {
                    if (_selected)
                    {
                        cell = new StatLineSelected();
                    }
                    else
                    {
                        cell = new StatLineNormal();
                    }
                }
                cell.width = ((cells[(i + 1)] - cells[i]) - 2);
                cell.height = 18;
                cell.x = cells[i];
                cont.addChild(cell);
                i++;
            }
            data.draw(cont);
            return (data);
        }

        protected function ConfigUI(e:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, this.ConfigUI);
            this.currentSort = 1;
            this.list.rowHeight = 20;
            this.list.setStyle("cellRenderer", ReferralStatListRenderer);
            this.list.dataProvider = this.dp;
            this.confSkin();
            addChild(this.header);
            addChild(this.list);
            this.list.y = 20;
            this.header.addEventListener(StatListEvent.UPDATE_SORT, this.changeSort);
        }
        override public function set height(value:Number):void
        {
            this._height = int(value);
            this.list.height = (this._height - 20);
        }
        public function clear():void
        {
            var item:Object = new Object();
            var i:int;
            while (i < this.dp.length)
            {
                item = this.dp.getItemAt(i);
                item.sort = this.currentSort;
                this.dp.replaceItemAt(item, i);
                i++;
            }
            this.sort();
        }
        public function addReferrals(referrals:Array):void
        {
            var item:Object;
            var i:Object;
            for each (i in referrals)
            {
                item = new Object();
                item.rank = i.rank;
                item.callsign = i.callsign;
                item.income = i.income;
                item.sort = this.currentSort;
                Main.writeVarsToConsoleChannel("REFERALS MODEL", "name = %1, income=%2", item.callsign, item.income);
                this.dp.addItem(item);
            }
            this.sort();
        }
        private function sort():void
        {
            if (this.currentSort == 0)
            {
                this.dp.sortOn("callsign");
            }
            else
            {
                this.dp.sortOn("income", (Array.NUMERIC | Array.DESCENDING));
            }
            this.dp.invalidate();
        }
        override public function set width(value:Number):void
        {
            this._width = int(value);
            var scrollOn:Boolean = (this.list.maxVerticalScrollPosition > 0);
            var _listWidth:int = ((!(!(scrollOn))) ? int((this._width + 6)) : int(this._width));
            this.list.width = _listWidth;
            this.header.width = ((!(!(scrollOn))) ? Number((_listWidth - 15)) : Number(_listWidth));
            ReferalStatLineBackgroundNormal.bg = new Bitmap(setBackground(((!(!(scrollOn))) ? int((_listWidth - 15)) : int(_listWidth)), this.currentSort, false));
            ReferalStatLineBackgroundSelected.bg = new Bitmap(setBackground(((!(!(scrollOn))) ? int((_listWidth - 15)) : int(_listWidth)), this.currentSort, true));
            this.dp.invalidate();
        }
        protected function changeSort(e:StatListEvent):void
        {
            this.currentSort = e.sortField;
            this.clear();
            this.width = this._width;
        }
        protected function confSkin():void
        {
            this.list.setStyle("downArrowUpSkin", ScrollArrowDownGreen);
            this.list.setStyle("downArrowDownSkin", ScrollArrowDownGreen);
            this.list.setStyle("downArrowOverSkin", ScrollArrowDownGreen);
            this.list.setStyle("downArrowDisabledSkin", ScrollArrowDownGreen);
            this.list.setStyle("upArrowUpSkin", ScrollArrowUpGreen);
            this.list.setStyle("upArrowDownSkin", ScrollArrowUpGreen);
            this.list.setStyle("upArrowOverSkin", ScrollArrowUpGreen);
            this.list.setStyle("upArrowDisabledSkin", ScrollArrowUpGreen);
            this.list.setStyle("trackUpSkin", ScrollTrackGreen);
            this.list.setStyle("trackDownSkin", ScrollTrackGreen);
            this.list.setStyle("trackOverSkin", ScrollTrackGreen);
            this.list.setStyle("trackDisabledSkin", ScrollTrackGreen);
            this.list.setStyle("thumbUpSkin", ScrollThumbSkinGreen);
            this.list.setStyle("thumbDownSkin", ScrollThumbSkinGreen);
            this.list.setStyle("thumbOverSkin", ScrollThumbSkinGreen);
            this.list.setStyle("thumbDisabledSkin", ScrollThumbSkinGreen);
        }

    }
}
