package controls
{
    import flash.display.Sprite;
    import logic.gui.combo.DPLBackground;
    import fl.controls.List;
    import fl.data.DataProvider;
    import flash.text.TextField;
    import flash.text.GridFitType;
    import flash.events.MouseEvent;
    import flash.text.TextFieldType;
    import fl.events.ListEvent;
    import flash.events.Event;
    import flash.text.TextFieldAutoSize;
    import flash.display.DisplayObject;
    import flash.events.KeyboardEvent;
    import alternativa.init.Main;

    public class TankCombo extends Sprite
    {

        private var button:ComboButton = new ComboButton();
        private var listBg:DPLBackground = new DPLBackground(100, 275);
        private var list:List = new List();
        private var dp:DataProvider = new DataProvider();
        private var state:Boolean = true;
        private var _label:Label;
        private var _selectedItem:Object;
        private var hiddenInput:TextField;
        private var _selectedIndex:int = 0;
        private var _width:int;
        public var _value:String;

        public function TankCombo()
        {
            this._label = new Label();
            this._label.x = -10;
            this._label.y = 7;
            this._label.gridFitType = GridFitType.SUBPIXEL;
            try
            {
                addChild(this.listBg);
                addChild(this.list);
                addChild(this.button);
                addChild(this._label);
            }
            catch (e:Error)
            {
            }
            this.listBg.y = 3;
            this.list.y = 33;
            this.list.x = 3;
            this.list.setSize(144, 115);
            this.list.rowHeight = 20;
            this.list.dataProvider = this.dp;
            this.list.setStyle("cellRenderer", ComboListRenderer);
            this.button.addEventListener(MouseEvent.CLICK, this.switchState);
            this.hiddenInput = new TextField();
            this.hiddenInput.visible = false;
            this.hiddenInput.type = TextFieldType.INPUT;
            this.switchState();
            this.list.addEventListener(ListEvent.ITEM_CLICK, this.onItemClick);
            addEventListener(Event.ADDED_TO_STAGE, this.Conf);
        }
        public function get selectedItem():Object
        {
            return (this._selectedItem);
        }
        public function set selectedItem(item:Object):void
        {
            if (item == null)
            {
                this._selectedItem = null;
                this.button.label = "";
            }
            else
            {
                this._selectedIndex = this.dp.getItemIndex(item);
                this._selectedItem = this.dp.getItemAt(this._selectedIndex);
                this.button.label = item.gameName;
            }
            dispatchEvent(new Event(Event.CHANGE));
        }
        public function get selectedIndex():int
        {
            return (this._selectedIndex);
        }
        public function set label(value:String):void
        {
            this._label.text = value;
            this._label.autoSize = TextFieldAutoSize.RIGHT;
        }
        private function Conf(e:Event):void
        {
        }
        private function onItemClick(e:ListEvent):void
        {
            var item:Object = e.item;
            this._selectedIndex = e.index;
            if (item.rang == 0)
            {
                this.button.label = item.gameName;
                this._selectedItem = item;
            }
            this.switchState();
            dispatchEvent(new Event(Event.CHANGE));
        }
        public function test():void
        {
        }
        private function switchStateClose(e:MouseEvent = null):void
        {
            if ((e.currentTarget as DisplayObject) != this.button)
            {
                this.state = false;
                this.listBg.visible = (this.list.visible = this.state);
            }
        }
        private function switchState(e:MouseEvent = null):void
        {
            this.state = (!(this.state));
            this.listBg.visible = (this.list.visible = this.state);
            if ((!(this.state)))
            {
                this.hiddenInput.removeEventListener(KeyboardEvent.KEY_UP, this.onKeyUpHiddenInput);
                if (Main.stage.focus == this.hiddenInput)
                {
                    Main.stage.focus = null;
                }
            }
            else
            {
                Main.stage.addChild(this.hiddenInput);
                Main.stage.focus = this.hiddenInput;
                this.hiddenInput.addEventListener(KeyboardEvent.KEY_UP, this.onKeyUpHiddenInput);
            }
        }
        private function onKeyUpHiddenInput(param1:KeyboardEvent):void
        {
            this.getItemByFirstChar(this.hiddenInput.text.substr(0, 1));
            this.hiddenInput.text = "";
        }
        public function getItemByFirstChar(param1:String):Object
        {
            var _loc4_:Object;
            var _loc2_:uint = this.dp.length;
            var _loc3_:int;
            while (_loc3_ < _loc2_)
            {
                _loc4_ = this.dp.getItemAt(_loc3_);
                if (_loc4_["gameName"].substr(0, 1).toLowerCase() == param1.toLowerCase())
                {
                    this._selectedItem = _loc4_;
                    this._value = this._selectedItem["gameName"];
                    this.button.label = this._value.toString();
                    this.list.selectedIndex = _loc3_;
                    this.list.verticalScrollPosition = (_loc3_ * 20);
                    dispatchEvent(new Event(Event.CHANGE));
                    return (_loc4_);
                }
                _loc3_++;
            }
            return (null);
        }
        public function addItem(obj:Object):void
        {
            var item:Object;
            this.dp.addItem(obj);
            item = this.dp.getItemAt(0);
            this._selectedItem = item;
            this.button.label = item.gameName;
        }
        public function sortOn(fieldName:Object, options:Object = null):void
        {
            var item:Object;
            this.dp.sortOn(fieldName, options);
            item = this.dp.getItemAt(0);
            this._selectedItem = item;
            this._value = this._selectedItem.gameName;
            this.button.label = item.gameName;
        }
        public function clear():void
        {
            this.dp = new DataProvider();
            this.list.dataProvider = this.dp;
            this.button.label = "";
        }
        override public function set width(w:Number):void
        {
            this._width = int(w);
            this.listBg.width = this._width;
            this.button.width = this._width;
            this.list.width = this._width;
            this.list.invalidate();
        }
        public function get listWidth():Number
        {
            return (this.list.width);
        }
        public function set listWidth(w:Number):void
        {
            this.list.width = w;
        }
        override public function set height(h:Number):void
        {
            this.listBg.height = h;
            this.list.height = (h - 35);
            this.list.invalidate();
        }
        public function set value(str:String):void
        {
            var item:Object;
            this._value = "";
            this.button.label = this._value;
            this._selectedItem = null;
            var i:int;
            while (i < this.dp.length)
            {
                item = this.dp.getItemAt(i);
                if (item.gameName == str)
                {
                    this._selectedItem = item;
                    this._value = this._selectedItem.gameName;
                    this.button.label = this._value;
                    this.list.selectedIndex = i;
                    this.list.scrollToSelected();
                }
                i++;
            }
            dispatchEvent(new Event(Event.CHANGE));
        }
        public function get value():String
        {
            return (this._value);
        }

    }
}
