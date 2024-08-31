package forms.garage
{
import com.alternativaplatform.projects.tanks.client.commons.models.itemtype.ItemTypeEnum;

import flash.display.Sprite;
    import alternativa.model.IResourceLoadListener;
    import flash.display.BitmapData;
    import fl.controls.TileList;
    import fl.data.DataProvider;
    import alternativa.tanks.model.GarageModel;
    import fl.events.ListEvent;
    import fl.controls.ScrollBarDirection;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import logic.resource.images.ImageResource;
    import alternativa.init.Main;
    import alternativa.tanks.model.IGarage;
    import alternativa.console.IConsole;
    import alternativa.types.Long;
    import flash.geom.Rectangle;
    import flash.utils.getTimer;
    import flash.display.DisplayObject;
    import forms.events.PartsListEvent;
    import flash.display.Bitmap;
    import assets.icons.GarageItemBackground;
    import controls.Label;
    import controls.rangicons.RangIconNormal;
    import assets.Diamond;
    import assets.icons.IconGarageMod;
    import controls.InventoryIcon;
    import assets.icons.InputCheckIcon;
    import forms.RegisterForm;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormatAlign;
    import assets.scroller.color.ScrollTrackGreen;
    import assets.scroller.color.ScrollThumbSkinGreen;
    import flash.system.Capabilities;

    public class PartsList extends Sprite implements IResourceLoadListener
    {
        private static const MIN_POSIBLE_SPEED:Number = 20;
        private static const MAX_DELTA_FOR_SELECT:Number = 7;
        private static const ADDITIONAL_SCROLL_AREA_HEIGHT:Number = 3;
        private static var _discountImage:Class = PartsList__discountImage;
        private static var discountBitmap:BitmapData = new _discountImage().bitmapData;

        private var list:TileList;
        private var dp:DataProvider;
        private var typeSort:Array = [1, 2, 3, 4, 0];
        private var _selectedItemID:Object = null;
        private var previousPositionX:Number;
        private var currrentPositionX:Number;
        private var sumDragWay:Number;
        private var lastItemIndex:int;
        private var previousTime:int;
        private var currentTime:int;
        private var scrollSpeed:Number = 0;
        private var _width:int;
        private var _height:int;
        private var model:GarageModel;

        public function PartsList()
        {
            this.dp = new DataProvider();
            this.list = new TileList();
            this.list.dataProvider = this.dp;
            this.list.addEventListener(ListEvent.ITEM_CLICK, this.selectItem);
            this.list.addEventListener(ListEvent.ITEM_DOUBLE_CLICK, this.selectItem);
            this.list.rowCount = 1;
            this.list.rowHeight = 130;
            this.list.columnWidth = 203;
            this.list.setStyle("cellRenderer", PartsListRenderer);
            this.list.direction = ScrollBarDirection.HORIZONTAL;
            this.list.focusEnabled = false;
            this.list.horizontalScrollBar.focusEnabled = false;
            addChild(this.list);
            addEventListener(MouseEvent.MOUSE_WHEEL, this.scrollList);
            this.confScroll();
            addEventListener(Event.ADDED_TO_STAGE, this.addListeners);
            addEventListener(Event.REMOVED_FROM_STAGE, this.killLists);
        }
        public function resourceLoaded(resource:Object):void
        {
            var i:int;
            var item:Object;
            try
            {
                i = 0;
                while (i < this.dp.length)
                {
                    item = this.dp.getItemAt(i);
                    if (resource.id.split("_preview")[0] == item.dat.id)
                    {
                        this.update(item.dat.id, "preview", (resource as ImageResource));
                        break;
                    }
                    i = (i + 1);
                }
                this.model = GarageModel(Main.osgi.getService(IGarage));
            }
            catch (e:Error)
            {
                (Main.osgi.getService(IConsole) as IConsole).addLine(e.getStackTrace());
            }
        }
        public function resourceUnloaded(resourceId:Long):void
        {
        }
        private function onMouseDown1(param1:MouseEvent):void
        {
            this.scrollSpeed = 0;
            var _loc2_:Rectangle = this.list.horizontalScrollBar.getBounds(stage);
            _loc2_.top = (_loc2_.top - ADDITIONAL_SCROLL_AREA_HEIGHT);
            if ((!(_loc2_.contains(param1.stageX, param1.stageY))))
            {
                this.sumDragWay = 0;
                this.previousPositionX = (this.currrentPositionX = param1.stageX);
                this.currentTime = (this.previousTime = getTimer());
                this.lastItemIndex = this.list.selectedIndex;
                stage.addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp1);
                stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove1);
            }
        }
        private function onMouseMove1(param1:MouseEvent):void
        {
            this.previousPositionX = this.currrentPositionX;
            this.currrentPositionX = param1.stageX;
            this.previousTime = this.currentTime;
            this.currentTime = getTimer();
            var _loc2_:Number = (this.currrentPositionX - this.previousPositionX);
            this.sumDragWay = (this.sumDragWay + Math.abs(_loc2_));
            if (this.sumDragWay > MAX_DELTA_FOR_SELECT)
            {
                this.list.horizontalScrollPosition = (this.list.horizontalScrollPosition - _loc2_);
            }
        }
        private function onMouseUp1(param1:MouseEvent):void
        {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove1);
            stage.removeEventListener(MouseEvent.MOUSE_UP, this.onMouseUp1);
            var _loc2_:Number = ((getTimer() - this.previousTime) / 1000);
            if (_loc2_ == 0)
            {
                _loc2_ = 0.1;
            }
            var _loc3_:Number = (param1.stageX - this.previousPositionX);
            this.scrollSpeed = (_loc3_ / _loc2_);
            this.previousTime = this.currentTime;
            this.currentTime = getTimer();
            addEventListener(Event.ENTER_FRAME, this.onEnterFrame1, false, 0, false);
        }
        private function onEnterFrame1(param1:Event):void
        {
            this.previousTime = this.currentTime;
            this.currentTime = getTimer();
            var _loc2_:Number = ((this.currentTime - this.previousTime) / 1000);
            this.list.horizontalScrollPosition = (this.list.horizontalScrollPosition - (this.scrollSpeed * _loc2_));
            var _loc3_:Number = this.list.horizontalScrollPosition;
            var _loc4_:Number = this.list.maxHorizontalScrollPosition;
            if ((((Math.abs(this.scrollSpeed) > MIN_POSIBLE_SPEED) && (0 < _loc3_)) && (_loc3_ < _loc4_)))
            {
                this.scrollSpeed = (this.scrollSpeed * Math.exp((-1.5 * _loc2_)));
            }
            else
            {
                this.scrollSpeed = 0;
                removeEventListener(Event.ENTER_FRAME, this.onEnterFrame1);
            }
        }
        public function get selectedItemID():Object
        {
            return (this._selectedItemID);
        }
        override public function set width(value:Number):void
        {
            this._width = int(value);
            this.list.width = this._width;
        }
        override public function get width():Number
        {
            return (this._width);
        }
        override public function set height(value:Number):void
        {
            this._height = int(value);
            this.list.height = this._height;
        }
        override public function get height():Number
        {
            return (this._height);
        }
        private function addListeners(param1:Event):void
        {
            addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown1);
        }
        private function killLists(e:Event):void
        {
            removeEventListener(Event.ENTER_FRAME, this.onEnterFrame1);
            this.list.removeEventListener(ListEvent.ITEM_CLICK, this.selectItem);
            removeEventListener(MouseEvent.MOUSE_WHEEL, this.scrollList);
            removeEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown1);
            stage.removeEventListener(MouseEvent.MOUSE_UP, this.onMouseUp1);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove1);
        }
        public function addItem(id:Object, name:String, itemType:ItemTypeEnum, sort:int, crystalPrice:int, discount:int, rang:int, installed:Boolean, garageElement:Boolean, count:int, preview:ImageResource, sto:Boolean, modification:int = 0):void
        {
            var iNormal:DisplayObject;
            var iSelected:DisplayObject;
            var data:Object = {}
            var access:Boolean = ((rang < 1) && (!(garageElement)));
            data.id = id;
            data.name = name;
            data.type = itemType;
            data.typeSort = this.typeSort[itemType];
            data.mod = modification;
            data.crystalPrice = crystalPrice;
            data.discount = discount;
            data.rang = ((garageElement) ? -1 : rang);
            data.installed = installed;
            data.garageElement = garageElement;
            data.count = count;
            data.preview = preview;
            data.sort = sort;
            data.sto = sto;
            iNormal = this.myIcon(data, false, sto);
            iSelected = this.myIcon(data, true, sto);
            this.dp.addItem( {
                        "iconNormal": iNormal,
                        "iconSelected": iSelected,
                        "dat": data,
                        "accessable": access,
                        "rang": data.rang,
                        "type": itemType,
                        "sto": sto,
                        "typesort": data.typeSort,
                        "sort": sort
                    });
            this.dp.sortOn(["sto", "accessable", "rang", "typesort", "sort"], [Array.DESCENDING, Array.DESCENDING, Array.NUMERIC, Array.NUMERIC, Array.NUMERIC]);
        }
        public function update(id:Object, param:String, value:* = null):void
        {
            var iNormal:DisplayObject;
            var iSelected:DisplayObject;
            var index:int = this.indexById(id);
            if (index == -1)
            {
                return;
            }
            var obj:Object = this.dp.getItemAt(index);
            var data:Object = obj.dat;
            data[param] = value;
            iNormal = this.myIcon(data, false, data.sto);
            iSelected = this.myIcon(data, true, data.sto);
            obj.dat = data;
            obj.iconNormal = iNormal;
            obj.iconSelected = iSelected;
            this.dp.replaceItemAt(obj, index);
            this.dp.sortOn(["sto", "accessable", "rang", "typesort", "sort"], [Array.DESCENDING, Array.DESCENDING, Array.NUMERIC, Array.NUMERIC, Array.NUMERIC]);
            this.dp.invalidateItemAt(index);
        }
        public function lock(id:Object):void
        {
            this.update(id, "accessable", true);
        }
        public function unlock(id:Object):void
        {
            this.update(id, "accessable", false);
        }
        public function mount(id:Object):void
        {
            this.update(id, "installed", true);
        }
        public function unmount(id:Object):void
        {
            this.update(id, "installed", false);
        }
        public function updateCondition(id:Object, value:int):void
        {
            this.update(id, "condition", value);
        }
        public function updateCount(id:Object, value:int):void
        {
            this.update(id, "count", value);
        }
        public function updateModification(id:Object, value:int):void
        {
            this.update(id, "mod", value);
        }
        public function deleteaItem():void
        {
            this.dp = new DataProvider();
        }
        public function deleteItem(id:Object):void
        {
            var index:int = this.indexById(id);
            if (index < 0)
            {
                return;
            }
            var obj:Object = this.dp.getItemAt(index);
            if (this.list.selectedIndex == index)
            {
                this._selectedItemID = null;
                this.list.selectedItem = null;
            }
            this.dp.removeItem(obj);
        }
        public function select(id:Object):void
        {
            var index:int = this.indexById(id);
            this.list.selectedIndex = index;
            this._selectedItemID = id;
            dispatchEvent(new PartsListEvent(PartsListEvent.SELECT_PARTS_LIST_ITEM));
        }
        public function selectByIndex(index:uint):void
        {
            var obj:Object = (this.dp.getItemAt(index) as Object).dat;
            this.list.selectedIndex = index;
            this._selectedItemID = obj.id;
            dispatchEvent(new PartsListEvent(PartsListEvent.SELECT_PARTS_LIST_ITEM));
        }
        public function scrollTo(id:Object):void
        {
            var index:int = this.indexById(id);
            this.list.scrollToIndex(index);
        }
        public function unselect():void
        {
            this._selectedItemID = null;
            this.list.selectedItem = null;
        }
        private function myIcon(data:Object, select:Boolean, h:Boolean):DisplayObject
        {
            var prv:Bitmap;
            var bmp:BitmapData;
            var bg:GarageItemBackground;
            var itemName:String;
            var discountLabel:Bitmap;
            var label:Label;
            prv = null;
            var rangIcon:RangIconNormal;
            var icon:Sprite = new Sprite();
            var cont:Sprite = new Sprite();
            var name:Label = new Label();
            var c_price:Label = new Label();
            var count:Label = new Label();
            var diamond:Diamond = new Diamond();
            var iconMod:IconGarageMod = new IconGarageMod(data.mod);
            var iconInventory:InventoryIcon = new InventoryIcon(data.sort, true);
            var iconCheck:InputCheckIcon = new InputCheckIcon();
            var imageResource:ImageResource = data.preview;
            if (imageResource == null)
            {
                cont.addChild(iconCheck);
                iconCheck.x = ((200 - iconCheck.width) >> 1);
                iconCheck.y = ((130 - iconCheck.height) >> 1);
                iconCheck.gotoAndStop(RegisterForm.CALLSIGN_STATE_INVALID);
            }
            else
            {
                if (imageResource.loaded())
                {
                    prv = new Bitmap((imageResource.bitmapData as BitmapData));
                    prv.x = 19;
                    prv.y = 18;
                    cont.addChild(prv);
                }
                else
                {
                    if (((!(imageResource == null)) && (!(imageResource.loaded()))))
                    {
                        cont.addChild(iconCheck);
                        iconCheck.x = ((200 - iconCheck.width) >> 1);
                        iconCheck.y = ((130 - iconCheck.height) >> 1);
                        iconCheck.gotoAndStop(RegisterForm.CALLSIGN_STATE_PROGRESS);
                        imageResource.completeLoadListener = this;
                        imageResource.load();
                    }
                }
            }
            if ((((data.rang > 0) && (!(data.garageElement))) || (data.accessable)))
            {
                rangIcon = new RangIconNormal(data.rang);
                itemName = "OFF";
                data.installed = false;
                rangIcon.x = 135;
                rangIcon.y = 60;
                cont.addChild(rangIcon);
                count.color = (c_price.color = (name.color = 0xC0C0C0));
                bg = new GarageItemBackground(((select) ? 2 : 0));
            }
            else
            {
                if (data.garageElement)
                {
                    count.color = (c_price.color = (name.color = 11194766));
                    bg = new GarageItemBackground(((data.installed) ? ((select) ? 6 : 5) : ((select) ? 10 : 9)));
                }
                else
                {
                    count.color = (c_price.color = (name.color = 5898034));
                    bg = new GarageItemBackground(((select) ? 8 : 7));
                }
                switch (data.type)
                {
                    case ItemTypeEnum.WEAPON:
                        if (data.garageElement)
                        {
                            cont.addChild(iconMod);
                            iconMod.x = 159;
                            iconMod.y = 7;
                        }
                        itemName = "GUN";
                        break;
                    case ItemTypeEnum.ARMOR:
                        if (data.garageElement)
                        {
                            cont.addChild(iconMod);
                            iconMod.x = 159;
                            iconMod.y = 7;
                        }
                        itemName = "SHIELD";
                        break;
                    case ItemTypeEnum.COLOR:
                        itemName = "COLOR";
                        break;
                    case ItemTypeEnum.RESISTANCE:
                        itemName = "RESISTANCE";
                        break;
                    default :
                        itemName = "ENGINE";
                        data.installed = false;
                        cont.addChild(count);
                        count.x = 90;
                        count.y = 100;
                        iconInventory.x = 6;
                        iconInventory.y = 84;
                        count.autoSize = TextFieldAutoSize.NONE;
                        count.size = 16;
                        count.align = TextFormatAlign.RIGHT;
                        count.width = 100;
                        count.height = 25;
                        count.text = ((data.count == 0) ? " " : ("×" + String(data.count)));
                        break;
                }
            }
            name.text = data.name;
            if (!data.garageElement || data.type == ItemTypeEnum.INVENTORY)
            {
                if (data.crystalPrice > 0)
                {
                    c_price.text = String(data.crystalPrice);
                    c_price.x = (181 - c_price.textWidth);
                    c_price.y = 2;
                    cont.addChild(diamond);
                    cont.addChild(c_price);
                    diamond.x = 186;
                    diamond.y = 6;
                }
            }
            name.y = 2;
            name.x = 3;
            cont.addChildAt(bg, 0);
            cont.addChild(name);
            var needShowSales:Boolean;
            if (data.garageElement)
            {
                if (data.maxModification > 1 && !(data.mod == 3))
                {
                    needShowSales = true;
                }
            }
            else
            {
                needShowSales = true;
            }
            if (((data.discount > 0) && (needShowSales)))
            {
                discountLabel = new Bitmap(discountBitmap);
                discountLabel.x = 0;
                discountLabel.y = (bg.height - discountLabel.height);
                cont.addChild(discountLabel);
                label = new Label();
                label.color = 0xFFFFFF;
                label.align = TextFormatAlign.LEFT;
                label.text = (("-" + data.discount) + "%");
                label.height = 35;
                label.width = 100;
                label.thickness = 0;
                label.autoSize = TextFieldAutoSize.NONE;
                label.size = 16;
                label.x = 10;
                label.y = 90;
                label.rotation = 45;
                cont.addChild(label);
            }
            bmp = new BitmapData(cont.width, cont.height, true, 0);
            bmp.draw(cont);
            icon.addChildAt(new Bitmap(bmp), 0);
            return (icon);
        }
        private function confScroll():void
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
        private function indexById(id:Object):int
        {
            var obj:Object;
            var i:int;
            while (i < this.dp.length)
            {
                obj = this.dp.getItemAt(i);
                if (obj.dat.id == id)
                {
                    return (i);
                }
                i++;
            }
            return (-1);
        }
        private function selectItem(e:ListEvent):void
        {
            var obj:Object;
            obj = e.item;
            this._selectedItemID = obj.dat.id;
            this.list.selectedItem = obj;
            this.list.scrollToSelected();
            dispatchEvent(new PartsListEvent(PartsListEvent.SELECT_PARTS_LIST_ITEM));
        }
        private function scrollList(e:MouseEvent):void
        {
            this.list.horizontalScrollPosition = (this.list.horizontalScrollPosition - (e.delta * ((Boolean((!(Capabilities.os.search("Linux") == -1)))) ? 50 : 10)));
        }

    }
}
