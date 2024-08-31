package alternativa.tanks.model.gift
{
    import flash.display.Sprite;
    import alternativa.model.IResourceLoadListener;
    import flash.display.BitmapData;
    import fl.controls.TileList;
    import fl.data.DataProvider;
    import fl.controls.ScrollBarDirection;
    import fl.controls.ScrollPolicy;
    import assets.scroller.color.ScrollTrackGreen;
    import assets.scroller.color.ScrollThumbSkinGreen;
    import alternativa.tanks.model.gift.server.GiftServerItem;
    import flash.display.DisplayObject;
    import flash.utils.Dictionary;
    import logic.resource.ResourceUtil;
    import logic.resource.ResourceType;
    import logic.resource.images.ImageResource;
    import alternativa.types.Long;
    import flash.display.Bitmap;
    import assets.icons.InputCheckIcon;
    import forms.RegisterForm;
    import controls.Label;

    public class GiftRollerList extends Sprite implements IResourceLoadListener
    {

        private static const _bg:Class = GiftRollerList__bg;
        private static const itemBG:BitmapData = new _bg().bitmapData;

        public var list:TileList;
        private var dataProvider:DataProvider;
        private var _width:int;
        private var _height:int;

        public function GiftRollerList()
        {
            this.dataProvider = new DataProvider();
            this.list = new TileList();
        }
        private function configurateList():void
        {
            this.dataProvider = new DataProvider();
            this.list = new TileList();
            this.list.dataProvider = this.dataProvider;
            this.list.rowCount = 1;
            this.list.rowHeight = 117;
            this.list.columnWidth = 190;
            this.list.setStyle("cellRenderer", GiftRollerRenderer);
            this.list.direction = ScrollBarDirection.HORIZONTAL;
            this.list.focusEnabled = false;
            this.list.horizontalScrollBar.focusEnabled = false;
            this.list.scrollPolicy = ScrollPolicy.OFF;
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
            this.list.width = this._width;
            this.list.height = this._height;
            this.list.buttonMode = false;
            this.list.useHandCursor = false;
        }
        public function initData(items:Array):void
        {
            var i:GiftServerItem;
            var i_:int;
            var a:int;
            var itemsByRare:Array;
            var random:int;
            var item:GiftServerItem;
            var data:Object;
            var icon:DisplayObject;
            if (contains(this.list))
            {
                removeChild(this.list);
            }
            this.configurateList();
            var rare2items:Dictionary = new Dictionary();
            for each (i in items)
            {
                itemsByRare = rare2items[i.rare];
                if (itemsByRare == null)
                {
                    itemsByRare = new Array();
                    rare2items[i.rare] = itemsByRare;
                }
                itemsByRare.push(i);
            }
            i_ = 0;
            a = 0;
            while (a < (GiftView.WINNER_ITEM_ID + 10))
            {
                random = (Math.random() * 100);
                if (random < 50)
                {
                    item = rare2items[0][int((Math.random() * rare2items[0].length))];
                }
                else
                {
                    if (random < 70)
                    {
                        item = rare2items[1][int((Math.random() * rare2items[1].length))];
                    }
                    else
                    {
                        if (random < 85)
                        {
                            item = rare2items[2][int((Math.random() * rare2items[2].length))];
                        }
                        else
                        {
                            if (random < 90)
                            {
                                item = rare2items[3][int((Math.random() * rare2items[3].length))];
                            }
                            else
                            {
                                item = rare2items[4][int((Math.random() * rare2items[4].length))];
                            }
                        }
                    }
                }
                data = {}
                data.id = item.id;
                data.index = i_;
                data.preview = ResourceUtil.getResource(ResourceType.IMAGE, (item.id + "_m0_preview"));
                icon = this.myIcon(data, false);
                this.dataProvider.addItem( {
                            "iconNormal": icon,
                            "iconSelected": icon,
                            "dat": data,
                            "accessable": false,
                            "rang": 0,
                            "type": 1,
                            "typesort": 0,
                            "sort": 1
                        });
                i_++;
                a++;
            }
            addChild(this.list);
        }
        public function resourceLoaded(resource:Object):void
        {
            var item:Object;
            var i:int;
            while (i < this.dataProvider.length)
            {
                item = this.dataProvider.getItemAt(i);
                if (resource.id.split("_m0_preview")[0] == item.dat.id)
                {
                    this.update(item.dat.index, "preview", (resource as ImageResource));
                }
                i++;
            }
        }
        public function resourceUnloaded(resource:Long):void
        {
        }
        private function indexById(id:Object, searchInSilent:Boolean = false):int
        {
            var obj:Object;
            var i:int;
            while (i < this.dataProvider.length)
            {
                obj = this.dataProvider.getItemAt(i);
                if (obj.dat.id == id)
                {
                    return (i);
                }
                i++;
            }
            return (-1);
        }
        public function update(index:int, param:String, value:* = null):void
        {
            var iNormal:DisplayObject;
            var iSelected:DisplayObject;
            var obj:Object = this.dataProvider.getItemAt(index);
            var data:Object = obj.dat;
            data[param] = value;
            iNormal = this.myIcon(data, false);
            iSelected = this.myIcon(data, true);
            obj.dat = data;
            obj.iconNormal = iNormal;
            obj.iconSelected = iSelected;
            this.dataProvider.replaceItemAt(obj, index);
            this.dataProvider.invalidateItemAt(index);
        }
        private function myIcon(data:Object, select:Boolean):DisplayObject
        {
            var bmp:BitmapData;
            var bg:Bitmap;
            var prv:Bitmap;
            var icon:Sprite = new Sprite();
            var cont:Sprite = new Sprite();
            bg = new Bitmap(itemBG);
            bg.width = (this.list.columnWidth - 5);
            bg.height = this.list.rowHeight;
            cont.addChildAt(bg, 0);
            var iconCheck:InputCheckIcon = new InputCheckIcon();
            var imageResource:ImageResource = data.preview;
            if (imageResource == null)
            {
                cont.addChild(iconCheck);
                iconCheck.x = ((130 - iconCheck.width) >> 1);
                iconCheck.y = ((93 - iconCheck.height) >> 1);
                iconCheck.gotoAndStop(RegisterForm.CALLSIGN_STATE_INVALID);
            }
            else
            {
                if (imageResource.loaded())
                {
                    prv = new Bitmap((imageResource.bitmapData as BitmapData));
                    prv.width = (prv.width * 0.9);
                    prv.height = (prv.height * 0.9);
                    prv.x = 20;
                    prv.y = 14;
                    cont.addChild(prv);
                }
                else
                {
                    if (((!(imageResource == null)) && (!(imageResource.loaded()))))
                    {
                        cont.addChild(iconCheck);
                        iconCheck.x = ((134 - iconCheck.width) >> 1);
                        iconCheck.y = ((97 - iconCheck.height) >> 1);
                        iconCheck.gotoAndStop(RegisterForm.CALLSIGN_STATE_PROGRESS);
                        imageResource.completeLoadListener = this;
                        imageResource.load();
                    }
                }
            }
            var id:Label = new Label();
            id.text = data.id;
            id.x = 5;
            id.y = 5;
            bmp = new BitmapData(cont.width, cont.height, true, 0);
            bmp.draw(cont);
            icon.addChildAt(new Bitmap(bmp), 0);
            return (icon);
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

    }
}
