package alternativa.osgi.service.focus
{
    import flash.display.Stage;
    import flash.events.FocusEvent;
    import flash.events.Event;
    import alternativa.init.OSGi;
    import alternativa.osgi.service.console.IConsoleService;
    import flash.display.DisplayObject;

    public class FocusService implements IFocusService
    {

        private var stage:Stage;
        private var mouseFocusChanged:Boolean = true;
        private var keyFocusChanged:Boolean = false;
        private var focusListeners:Array;
        private var _focused:Object;

        public function FocusService(_stage:Stage)
        {
            this.stage = _stage;
            if (_stage == null)
            {
                this.stage = Game.getInstance.stage;
            }
            this.focusListeners = new Array();
            this.stage.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, this.onMouseFocusChange);
            this.stage.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, this.onKeyFocusChange);
            this.stage.addEventListener(FocusEvent.FOCUS_IN, this.onFocusIn);
            this.stage.addEventListener(FocusEvent.FOCUS_OUT, this.onFocusOut);
            this.stage.addEventListener(Event.ACTIVATE, this.activate);
            this.stage.addEventListener(Event.DEACTIVATE, this.deactivate);
        }
        private function activate(e:Event):void
        {
            var listener:IFocusListener;
            var consoleService:IConsoleService = (OSGi.osgi.getService(IConsoleService) as IConsoleService);
            consoleService.writeToConsoleChannel("FOCUS", "activate");
            var i:int;
            while (i < this.focusListeners.length)
            {
                listener = IFocusListener(this.focusListeners[i]);
                listener.activate();
                i++;
            }
        }
        private function deactivate(e:Event):void
        {
            var listener:IFocusListener;
            var consoleService:IConsoleService = (OSGi.osgi.getService(IConsoleService) as IConsoleService);
            consoleService.writeToConsoleChannel("FOCUS", "deactivate");
            var i:int;
            while (i < this.focusListeners.length)
            {
                listener = IFocusListener(this.focusListeners[i]);
                listener.deactivate();
                i++;
            }
        }
        public function addFocusListener(listener:IFocusListener):void
        {
            this.focusListeners.push(listener);
        }
        public function removeFocusListener(listener:IFocusListener):void
        {
            this.focusListeners.splice(this.focusListeners.indexOf(listener), 1);
        }
        public function getFocus():Object
        {
            return (this._focused);
        }
        public function clearFocus(object:DisplayObject):void
        {
            if (this._focused == object)
            {
                this._focused = this.stage;
                this.stage.focus = this.stage;
            }
        }
        private function onFocusIn(e:FocusEvent):void
        {
            var listener:IFocusListener;
            this._focused = e.target;
            var i:int;
            while (i < this.focusListeners.length)
            {
                listener = IFocusListener(this.focusListeners[i]);
                listener.focusIn(this._focused);
                i++;
            }
        }
        private function onFocusOut(e:FocusEvent):void
        {
            var listener:IFocusListener;
            this._focused = null;
            var i:int;
            while (i < this.focusListeners.length)
            {
                listener = IFocusListener(this.focusListeners[i]);
                listener.focusOut(e.currentTarget);
                i++;
            }
        }
        private function onKeyFocusChange(e:FocusEvent):void
        {
            this.keyFocusChanged = true;
        }
        private function onMouseFocusChange(e:FocusEvent):void
        {
            this.mouseFocusChanged = true;
        }

    }
}
