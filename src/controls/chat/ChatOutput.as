package controls.chat
{
    import fl.containers.ScrollPane;
    import flash.display.Sprite;
    import fl.controls.ScrollPolicy;
    import forms.events.LoginFormEvent;
    import flash.events.Event;

    public class ChatOutput extends ScrollPane
    {

        private const numMessages:int = 80;

        private var _cont:Sprite = new Sprite();
        private var __width:Number;
        public var firstFill:Boolean = true;
        public var deltaWidth:int = 9;
        public var selfName:String;
        private var oldLine:ChatOutputLine;

        public function ChatOutput()
        {
            this.source = this._cont;
            this.horizontalScrollPolicy = ScrollPolicy.OFF;
            this.focusEnabled = false;
            addEventListener(LoginFormEvent.SHOW_RULES, this.showRules);
        }
        private function showRules(e:Event):void
        {
        }
        public function addLine(rang:int, chatPermissions:int, name:String, text:String, rangTo:int = 0, chatPermissionsTo:int = 0, nameTo:String = "", system:Boolean = false, html:Boolean = false, _systemColor:uint = 8454016, premium:Boolean = false, premiumTo:Boolean = false):void
        {
            var line:ChatOutputLine;
            var maxScroll:Boolean = (((this.verticalScrollPosition + 5) > this.maxVerticalScrollPosition) || (this.firstFill));
            if (this._cont.numChildren > this.numMessages)
            {
                this.shiftMessages();
                this.oldLine = null;
                line = new ChatOutputLine(this.__width, rang, chatPermissions, name, text, rangTo, chatPermissionsTo, nameTo, system, html, _systemColor, premium, premiumTo);
            }
            else
            {
                line = new ChatOutputLine(this.__width, rang, chatPermissions, name, text, rangTo, chatPermissionsTo, nameTo, system, html, _systemColor, premium, premiumTo);
            }
            var curY:int = int((this._cont.height + 0.5));
            line.self = (line._userNameTo == this.selfName);
            line.y = curY;
            this._cont.addChild(line);
            this.update();
            if (maxScroll)
            {
                this.verticalScrollPosition = this.maxVerticalScrollPosition;
            }
        }
        public function scrollDown():void
        {
            this.verticalScrollPosition = this.maxVerticalScrollPosition;
        }
        public function selectUser(name:String):void
        {
            var element:ChatOutputLine;
            var i:int;
            while (i < this._cont.numChildren)
            {
                element = (this._cont.getChildAt(i) as ChatOutputLine);
                element.light = ((element.username == name) && (!(name == "")));
                element.self = ((element._userNameTo == this.selfName) && (!(name == "")));
                i++;
            }
        }
        private function shiftMessages():void
        {
            this.oldLine = (this._cont.getChildAt(0) as ChatOutputLine);
            var shift:Number = (this.oldLine.height + this.oldLine.y);
            this._cont.removeChild(this.oldLine);
            var i:int;
            while (i < this._cont.numChildren)
            {
                this._cont.getChildAt(i).y = (this._cont.getChildAt(i).y - shift);
                i++;
            }
        }
        override public function setSize(width:Number, height:Number):void
        {
            super.setSize(width, height);
            this.__width = (width - this.deltaWidth);
            this.resizeLines();
        }
        private function resizeLines():void
        {
            var element:ChatOutputLine;
            var i:int;
            var cash:Array = new Array();
            var curY:int;
            var nofirstTime:Boolean = (this._cont.numChildren > 0);
            while (this._cont.numChildren > 0)
            {
                element = (this._cont.getChildAt(i) as ChatOutputLine);
                element.width = this.__width;
                cash.push(element);
                this._cont.removeChildAt(0);
            }
            i = 0;
            while (i < cash.length)
            {
                element = cash[i];
                curY = int((this._cont.height + 0.5));
                element.y = curY;
                this._cont.addChild(element);
                i++;
            }
            if (nofirstTime)
            {
                this.update();
            }
        }
        public function cleanOutUsersMessages(uid:String):void
        {
            var line:ChatOutputLine;
            var linesToDelete:Array = new Array();
            var i:int;
            while (i < this._cont.numChildren)
            {
                line = (this._cont.getChildAt(i) as ChatOutputLine);
                if (((line._userName == uid) || (uid == "")))
                {
                    linesToDelete.push(line);
                }
                i++;
            }
            i = 0;
            while (i < linesToDelete.length)
            {
                this._cont.removeChild(linesToDelete[i]);
                i++;
            }
            this.resizeLines();
            this.update();
        }
        public function cleanOutMessages(msg:String):void
        {
            var line:ChatOutputLine;
            var linesToDelete:Array = new Array();
            var i:int;
            while (i < this._cont.numChildren)
            {
                line = (this._cont.getChildAt(i) as ChatOutputLine);
                if (line.output.text == msg)
                {
                    linesToDelete.push(line);
                }
                i++;
            }
            i = 0;
            while (i < linesToDelete.length)
            {
                this._cont.removeChild(linesToDelete[i]);
                i++;
            }
            this.resizeLines();
            this.update();
        }

    }
}
