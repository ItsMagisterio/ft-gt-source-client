package forms.battlelist
{
    import flash.display.Sprite;
    import controls.TankWindow;
    import controls.TankWindowInner;
    import flash.text.TextFormat;
    import fl.controls.List;
    import fl.data.DataProvider;
    import flash.utils.Timer;
    import controls.DefaultButton;
    import flash.events.Event;
    import alternativa.init.Main;
    import alternativa.osgi.service.locale.ILocaleService;
    import alternativa.tanks.locale.constants.TextConst;
    import controls.TankWindowHeader;
    import fl.events.ListEvent;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import fl.controls.ScrollBar;
    import assets.scroller.color.ScrollTrackGreen;
    import assets.scroller.color.ScrollThumbSkinGreen;
    import forms.TankWindowWithHeader;
    import forms.events.BattleListEvent;
    import flash.ui.Keyboard;
    import flash.display.Bitmap;
    import controls.Label;
    import assets.cellrenderer.battlelist.Abris;
    import flash.display.Shape;
    import assets.cellrenderer.battlelist.PaydIcon;
    import flash.display.BitmapData;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormatAlign;
    import flash.events.TimerEvent;

    public class ViewBattleList extends Sprite
    {

        private static const dm:Class = ViewBattleList_dm;
        private static const tdm:Class = ViewBattleList_tdm;
        private static const ctf:Class = ViewBattleList_ctf;
        private static const cp:Class = ViewBattleList_cp;

        private var mainBackground:TankWindowWithHeader = new TankWindowWithHeader("CURRENT BATTLES");
        private var inner:TankWindowInner = new TankWindowInner(100, 100, TankWindowInner.GREEN);
        private var format:TextFormat = new TextFormat("MyriadPro", 13);
        private var battleList:List = new List();
        private var dp:DataProvider = new DataProvider();
        private var filterDP:DataProvider = new DataProvider();
        private var _selectedBattleID:Object;
        private var delayTimer:Timer;
        private var iconWidth:int = 100;
        private var onStage:Boolean = false;
        private var dmButton:DefaultButton = new DefaultButton();
        private var tdmButton:DefaultButton = new DefaultButton();
        private var ctfButton:DefaultButton = new DefaultButton();
        private var domButton:DefaultButton = new DefaultButton();
        private var dmBitmap:Sprite = new Sprite();
        private var tdmBitmap:Sprite = new Sprite();
        private var ctfBitmap:Sprite = new Sprite();
        private var domBitmap:Sprite = new Sprite();
        public var createButton:DefaultButton = new DefaultButton();
        private var oldIconWidth:int = 0;

        public function ViewBattleList()
        {
            addEventListener(Event.ADDED_TO_STAGE, this.ConfigUI);
            addEventListener(Event.ADDED_TO_STAGE, this.addResizeListener);
            addEventListener(Event.REMOVED_FROM_STAGE, this.removeResizeListener);
        }
        public function get selectedBattleID():Object
        {
            return (this._selectedBattleID);
        }
        private function addResizeListener(e:Event):void
        {
            stage.addEventListener(Event.RESIZE, this.onResize);
            this.onStage = true;
            this.onResize(null);
        }
        private function removeResizeListener(e:Event):void
        {
            stage.removeEventListener(Event.RESIZE, this.onResize);
            this.onStage = false;
        }
        private function ConfigUI(e:Event):void
        {
            var localeService:ILocaleService = (Main.osgi.getService(ILocaleService) as ILocaleService);
            removeEventListener(Event.ADDED_TO_STAGE, this.ConfigUI);
            addChild(this.mainBackground);
            addChild(this.inner);
            this.inner.showBlink = true;
            this.battleList.rowHeight = 20;
            this.battleList.setStyle("cellRenderer", BattleListRenderer);
            this.battleList.dataProvider = this.dp;
            this.battleList.addEventListener(ListEvent.ITEM_CLICK, this.selectItem);
            this.battleList.addEventListener(KeyboardEvent.KEY_UP, this.selectCurrentItem);
            this.battleList.focusEnabled = true;
            this.confScroll();
            addChild(this.battleList);
            this.battleList.move(15, 15);
            addChild(this.createButton);
            this.createButton.addEventListener(MouseEvent.CLICK, this.createGame);
            this.createButton.label = localeService.getText(TextConst.BATTLELIST_PANEL_BUTTON_CREATE);
            /*   this.dmBitmap.addChild(new dm());
            this.tdmBitmap.addChild(new tdm());
            this.ctfBitmap.addChild(new ctf());
            this.domBitmap.addChild(new cp());
            addChild(this.dmButton);
            this.dmButton.width = this.dmButton.height;
            addChild(this.dmBitmap);
            this.dmBitmap.addEventListener(MouseEvent.CLICK, this.filterBattle);
            addChild(this.tdmButton);
            this.tdmButton.width = this.tdmButton.height;
            addChild(this.tdmBitmap);
            this.tdmBitmap.addEventListener(MouseEvent.CLICK, this.filterBattle);
            addChild(this.ctfButton);
            this.ctfButton.width = this.ctfButton.height;
            addChild(this.ctfBitmap);
            this.ctfBitmap.addEventListener(MouseEvent.CLICK, this.filterBattle);
            addChild(this.domButton);
            this.domButton.width = this.domButton.height;
            addChild(this.domBitmap);
            this.domBitmap.addEventListener(MouseEvent.CLICK, this.filterBattle); */
            this.inner.x = (this.inner.y = 11);
        }
        private function filterBattle(e:MouseEvent = null):void
        {
            var target:Sprite;
            var i:int;
            if ((e.currentTarget as Sprite) != null)
            {
                this.battleList.selectedItem = null;
                target = (e.currentTarget as Sprite);
                if (target == this.dmBitmap)
                {
                    this.dmButton.enable = (!(this.dmButton.enable));
                }
                else
                {
                    if (target == this.tdmBitmap)
                    {
                        this.tdmButton.enable = (!(this.tdmButton.enable));
                    }
                    else
                    {
                        if (target == this.ctfBitmap)
                        {
                            this.ctfButton.enable = (!(this.ctfButton.enable));
                        }
                        else
                        {
                            if (target == this.domBitmap)
                            {
                                this.domButton.enable = (!(this.domButton.enable));
                            }
                        }
                    }
                }
                this.filterDP.removeAll();
                i = 0;
                while (i < this.dp.length)
                {
                    if (((!(this.dmButton.enable)) && (this.dp.getItemAt(i).dat.type == "DM")))
                    {
                        this.filterDP.addItem(this.dp.getItemAt(i));
                    }
                    if (((!(this.tdmButton.enable)) && (this.dp.getItemAt(i).dat.type == "TDM")))
                    {
                        this.filterDP.addItem(this.dp.getItemAt(i));
                    }
                    if (((!(this.ctfButton.enable)) && (this.dp.getItemAt(i).dat.type == "CTF")))
                    {
                        this.filterDP.addItem(this.dp.getItemAt(i));
                    }
                    if (((!(this.domButton.enable)) && (this.dp.getItemAt(i).dat.type == "DOM")))
                    {
                        this.filterDP.addItem(this.dp.getItemAt(i));
                    }
                    i++;
                }
                this.filterDP.sortOn(["accessible", "id"], [Array.DESCENDING, Array.DESCENDING]);
                if (((this.filterDP.length > 0) && ((((this.dmButton.enable) || (this.tdmButton.enable)) || (this.ctfButton.enable)) || (this.domButton.enable))))
                {
                    this.battleList.dataProvider = this.filterDP;
                }
                else
                {
                    this.battleList.dataProvider = this.dp;
                }
            }
        }
        private function confScroll():void
        {
            var bar:ScrollBar = this.battleList.verticalScrollBar;
            this.battleList.setStyle("downArrowUpSkin", ScrollArrowDownGreen);
            this.battleList.setStyle("downArrowDownSkin", ScrollArrowDownGreen);
            this.battleList.setStyle("downArrowOverSkin", ScrollArrowDownGreen);
            this.battleList.setStyle("downArrowDisabledSkin", ScrollArrowDownGreen);
            this.battleList.setStyle("upArrowUpSkin", ScrollArrowUpGreen);
            this.battleList.setStyle("upArrowDownSkin", ScrollArrowUpGreen);
            this.battleList.setStyle("upArrowOverSkin", ScrollArrowUpGreen);
            this.battleList.setStyle("upArrowDisabledSkin", ScrollArrowUpGreen);
            this.battleList.setStyle("trackUpSkin", ScrollTrackGreen);
            this.battleList.setStyle("trackDownSkin", ScrollTrackGreen);
            this.battleList.setStyle("trackOverSkin", ScrollTrackGreen);
            this.battleList.setStyle("trackDisabledSkin", ScrollTrackGreen);
            this.battleList.setStyle("thumbUpSkin", ScrollThumbSkinGreen);
            this.battleList.setStyle("thumbDownSkin", ScrollThumbSkinGreen);
            this.battleList.setStyle("thumbOverSkin", ScrollThumbSkinGreen);
            this.battleList.setStyle("thumbDisabledSkin", ScrollThumbSkinGreen);
        }
        private function createGame(e:MouseEvent):void
        {
            this.battleList.selectedItem = null;
            dispatchEvent(new BattleListEvent(BattleListEvent.CREATE_GAME));
        }
        private function selectItem(e:ListEvent):void
        {
            this._selectedBattleID = e.item.id;
            dispatchEvent(new BattleListEvent(BattleListEvent.SELECT_BATTLE));
        }
        private function selectCurrentItem(e:KeyboardEvent):void
        {
            if (((!(this.battleList.selectedItem)) || ((!(e.keyCode == Keyboard.UP)) && (!(e.keyCode == Keyboard.DOWN)))))
            {
                return;
            }
            this._selectedBattleID = this.battleList.selectedItem.id;
            dispatchEvent(new BattleListEvent(BattleListEvent.SELECT_BATTLE));
        }
        private function getItem(id:Object, name:String, deathMatch:Boolean = true, reds:int = 0, blues:int = 0, all:int = 0, map:String = "", totalfull:Boolean = false, redful:Boolean = false, bluefull:Boolean = false, accessible:Boolean = true, closed:Boolean = false):Object
        {
            var data:Object = new Object();
            var item:Object = new Object();
            data.gamename = name;
            data.id = id;
            data.dmatch = deathMatch;
            data.reds = reds;
            data.blues = blues;
            data.all = all;
            data.nmap = map;
            data.allfull = totalfull;
            data.redfull = redful;
            data.bluefull = bluefull;
            data.accessible = accessible;
            data.closed = closed;
            item.id = id;
            item.accessible = accessible;
            item.iconNormal = this.myIcon(false, data);
            item.iconSelected = this.myIcon(true, data);
            item.dat = data;
            return (item);
        }
        public function addItem(id:Object, name:String, deathMatch:Boolean = true, reds:int = 0, blues:int = 0, all:int = 0, map:String = "", totalfull:Boolean = false, redful:Boolean = false, bluefull:Boolean = false, accessible:Boolean = true, closed:Boolean = false, _arg_13:String = ""):void
        {
            var data:Object = new Object();
            var item:Object = new Object();
            var index:int = this.indexById(id);
            data.gamename = name;
            data.id = id;
            data.type = _arg_13;
            data.dmatch = deathMatch;
            data.reds = reds;
            data.blues = blues;
            data.all = all;
            data.nmap = map;
            data.allfull = totalfull;
            data.redfull = redful;
            data.bluefull = bluefull;
            data.accessible = accessible;
            data.closed = closed;
            item.id = id;
            item.accessible = accessible;
            item.iconNormal = this.myIcon(false, data);
            item.iconSelected = this.myIcon(true, data);
            item.dat = data;
            if (index < 0)
            {
                this.dp.addItem(item);
                this.dp.sortOn(["accessible", "id"], [Array.DESCENDING, Array.DESCENDING]);
            }
            if (this.onStage)
            {
                this.onResize();
            }
        }
        public function setBattleAccessibility(id:Object, accessible:Boolean):void
        {
            var d:Object;
            var newItem:Object;
            var i:Object = new Object();
            var index:int = this.indexById(id);
            if (index >= 0)
            {
                i = this.dp.getItemAt(index);
                d = i.dat;
                newItem = this.getItem(i.id, d.gamename, d.dmatch, d.reds, d.blues, d.all, d.nmap, d.allfull, d.redfull, d.bluefull, accessible, d.closed);
                this.dp.replaceItemAt(newItem, index);
                this.dp.invalidateItemAt(index);
            }
        }
        public function updatePlayersTotal(id:Object, num:int, full:Boolean):void
        {
            var d:Object;
            var newItem:Object;
            var i:Object = new Object();
            var index:int = this.indexById(id);
            if (index >= 0)
            {
                i = this.dp.getItemAt(index);
                d = i.dat;
                newItem = this.getItem(i.id, d.gamename, d.dmatch, d.reds, d.blues, num, d.nmap, full, d.redfull, d.bluefull, d.accessible, d.closed);
                this.dp.replaceItemAt(newItem, index);
                this.dp.invalidateItemAt(index);
            }
        }
        public function updatePlayersRed(id:Object, num:int, full:Boolean):void
        {
            var d:Object;
            var newItem:Object;
            var i:Object = new Object();
            var index:int = this.indexById(id);
            if (index >= 0)
            {
                i = this.dp.getItemAt(index);
                d = i.dat;
                newItem = this.getItem(i.id, d.gamename, d.dmatch, num, d.blues, d.all, d.nmap, d.allfull, full, d.bluefull, d.accessible, d.closed);
                this.dp.replaceItemAt(newItem, index);
                this.dp.invalidateItemAt(index);
            }
        }
        public function updatePlayersBlue(id:Object, num:int, full:Boolean):void
        {
            var d:Object;
            var newItem:Object;
            var i:Object = new Object();
            var index:int = this.indexById(id);
            if (index >= 0)
            {
                i = this.dp.getItemAt(index);
                d = i.dat;
                newItem = this.getItem(i.id, d.gamename, d.dmatch, d.reds, num, d.all, d.nmap, d.allfull, d.redfull, full, d.accessible, d.closed);
                this.dp.replaceItemAt(newItem, index);
                this.dp.invalidateItemAt(index);
            }
        }
        public function select(id:Object):void
        {
            var index:int = this.indexById(id);
            if (index > -1)
            {
                this.battleList.selectedIndex = index;
                this.battleList.scrollToSelected();
                this._selectedBattleID = id;
            }
        }
        public function removeItem(id:Object):void
        {
            var index:int = this.indexById(id);
            if (index >= 0)
            {
                this.dp.removeItemAt(index);
            }
        }
        private function indexById(id:Object):int
        {
            var obj:Object;
            var i:int;
            while (i < this.dp.length)
            {
                obj = this.dp.getItemAt(i);
                if (obj.id == id)
                {
                    return (i);
                }
                i++;
            }
            return (-1);
        }
        private function myIcon(select:Boolean, data:Object):Sprite
        {
            var icon:Bitmap;
            var tf:Label;
            var abris:Abris;
            var cont:Sprite = new Sprite();
            var shape:Shape = new Shape();
            var access:Boolean = data.accessible;
            var closed_icon:PaydIcon = new PaydIcon();
            var _width:int = this.iconWidth;
            var bmp:BitmapData = new BitmapData(_width, 20, true, 0);
            var abrisX:int = int((_width * 0.55));
            if (data.closed)
            {
                closed_icon.y = 3;
                closed_icon.x = -2;
                cont.addChild(closed_icon);
                closed_icon.gotoAndStop(((select) ? ((access) ? 2 : 4) : ((access) ? 1 : 3)));
            }
            tf = new Label();
            tf.size = 12;
            tf.color = ((select) ? ((access) ? TankWindowInner.GREEN : 0x585858) : ((access) ? 5898034 : 0xB1B1B1));
            tf.text = data.gamename;
            tf.autoSize = TextFieldAutoSize.NONE;
            tf.width = (abrisX - 6);
            tf.height = 18;
            tf.x = 8;
            tf.y = -1;
            cont.addChild(tf);
            tf = new Label();
            tf.size = 12;
            tf.color = ((select) ? ((access) ? TankWindowInner.GREEN : 0x585858) : ((access) ? 5898034 : 0xB1B1B1));
            tf.autoSize = TextFieldAutoSize.RIGHT;
            tf.align = TextFormatAlign.RIGHT;
            tf.text = String(data.nmap);
            tf.x = ((_width - tf.textWidth) + 2);
            tf.y = -1;
            cont.addChild(tf);
            if (data.dmatch)
            {
                abris = new Abris();
                abris.gotoAndStop(((!(data.allfull)) ? 2 : 1));
                abris.x = abrisX;
                abris.y = 1;
                cont.addChild(abris);
                tf = new Label();
                tf.autoSize = TextFieldAutoSize.NONE;
                tf.size = 12;
                tf.color = ((!(data.allfull)) ? 0xFFFFFF : 0x868686);
                tf.align = TextFormatAlign.CENTER;
                tf.text = String(data.all);
                tf.x = (abrisX - 0.5);
                tf.y = -1;
                tf.width = 52;
                cont.addChild(tf);
            }
            else
            {
                abris = new Abris();
                abris.gotoAndStop(((!(data.redfull)) ? 5 : 3));
                abris.x = abrisX;
                abris.y = 1;
                cont.addChild(abris);
                abris = new Abris();
                abris.gotoAndStop(((!(data.bluefull)) ? 6 : 4));
                abris.x = (abrisX + 27);
                abris.y = 1;
                cont.addChild(abris);
                tf = new Label();
                tf.autoSize = TextFieldAutoSize.NONE;
                tf.size = 12;
                tf.align = TextFormatAlign.CENTER;
                tf.color = ((!(data.redfull)) ? 0xFFFFFF : 0x868686);
                tf.text = String(data.reds);
                tf.x = (abrisX - 0.5);
                tf.y = -1;
                tf.width = 27;
                cont.addChild(tf);
                tf = new Label();
                tf.autoSize = TextFieldAutoSize.NONE;
                tf.align = TextFormatAlign.CENTER;
                tf.color = ((!(data.bluefull)) ? 0xFFFFFF : 0x868686);
                tf.text = String(data.blues);
                tf.x = (abrisX + 26.5);
                tf.y = -1;
                tf.width = 25;
                cont.addChild(tf);
            }
            bmp.draw(cont, null, null, null, null, true);
            icon = new Bitmap(bmp);
            return (cont);
        }
        private function resizeAll(___width:int):void
        {
            // FIXME: throws an error when entering battle weird, might be debugger problem or compiler problem
            try
            {
                if (this.battleList.maxVerticalScrollPosition != null)
                {
                    var i:Object;
                    var d:Object;
                    this.iconWidth = (___width - ((this.battleList.maxVerticalScrollPosition > 0) ? 32 : 20));
                    if (this.iconWidth == this.oldIconWidth)
                    {
                        return;
                    }
                    this.oldIconWidth = this.iconWidth;
                    var j:int;
                    while (j < this.dp.length)
                    {
                        i = this.dp.getItemAt(j);
                        d = i.dat;
                        i.iconNormal = this.myIcon(false, d);
                        i.iconSelected = this.myIcon(true, d);
                        this.dp.replaceItemAt(i, j);
                        this.dp.invalidateItemAt(j);
                        j++;
                    }
                }
            }
            catch (e:Error)
            {

            }
        }
        private function onResize(e:Event = null):void
        {
            var listWidth:int;
            var minWidth:int = int(Math.max(1000, stage.stageWidth));
            var index:int = this.battleList.selectedIndex;
            if (this.delayTimer == null)
            {
                this.delayTimer = new Timer(400, 1);
                this.delayTimer.addEventListener(TimerEvent.TIMER, this.resizeList);
            }
            this.mainBackground.width = (minWidth / 3);
            this.mainBackground.height = Math.max((stage.stageHeight - 60), 530);
            this.x = this.mainBackground.width;
            this.y = 60;
            this.inner.width = (this.mainBackground.width - 22);
            this.inner.height = (this.mainBackground.height - 58);
            this.createButton.x = ((this.mainBackground.width - this.createButton.width) - 11);
            this.createButton.y = (this.mainBackground.height - 42);
            this.dmButton.x = int(this.inner.x);
            this.dmButton.y = (this.mainBackground.height - 42);
            this.tdmButton.x = int((this.dmButton.x + (11 / 2)) + this.dmButton.width);
            this.tdmButton.y = (this.mainBackground.height - 42);
            this.ctfButton.x = int((this.tdmButton.x + (11 / 2)) + this.tdmButton.width);
            this.ctfButton.y = (this.mainBackground.height - 42);
            this.domButton.x = int((this.ctfButton.x + (11 / 2)) + this.ctfButton.width);
            this.domButton.y = (this.mainBackground.height - 42);
            this.dmBitmap.x = int(this.dmButton.x + ((this.dmButton.width - this.dmBitmap.width) / 2));
            this.dmBitmap.y = (this.dmButton.y + ((this.dmButton.height - this.dmBitmap.height) / 2));
            this.tdmBitmap.x = int(this.tdmButton.x + ((this.tdmButton.width - this.tdmBitmap.width) / 2));
            this.tdmBitmap.y = (this.tdmButton.y + ((this.tdmButton.height - this.tdmBitmap.height) / 2));
            this.ctfBitmap.x = int(this.ctfButton.x + ((this.ctfButton.width - this.ctfBitmap.width) / 2));
            this.ctfBitmap.y = (this.ctfButton.y + ((this.ctfButton.height - this.ctfBitmap.height) / 2));
            this.domBitmap.x = int(this.domButton.x + ((this.domButton.width - this.domBitmap.width) / 2));
            this.domBitmap.y = (this.domButton.y + ((this.domButton.height - this.domBitmap.height) / 2));
            this.createButton.x = ((this.mainBackground.width - this.createButton.width) - 11);
            this.createButton.y = (this.mainBackground.height - 42);
            listWidth = (this.inner.width - ((this.battleList.maxVerticalScrollPosition > 0) ? 0 : 4));
            this.battleList.setSize(listWidth, (this.inner.height - 8));
            this.resizeAll(listWidth);
            this.delayTimer.stop();
            this.delayTimer.start();
        }
        private function resizeList(e:TimerEvent):void
        {
            var index:int = this.battleList.selectedIndex;
            var listWidth:int = (this.inner.width - ((this.battleList.maxVerticalScrollPosition > 0) ? 0 : 4));
            this.battleList.setSize(listWidth, (this.inner.height - 8));
            this.resizeAll(listWidth);
            this.battleList.selectedIndex = index;
            this.battleList.scrollToSelected();
            this.delayTimer.removeEventListener(TimerEvent.TIMER, this.resizeList);
            this.delayTimer = null;
        }
        public function destroy():*
        {
            this.mainBackground = null;
        }

    }
}
