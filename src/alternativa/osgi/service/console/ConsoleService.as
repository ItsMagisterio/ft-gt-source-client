package alternativa.osgi.service.console
{
    public class ConsoleService implements IConsoleService
    {

        private var _console:Object;

        public function ConsoleService(console:Object)
        {
            this._console = console;
        }
        public function writeToConsole(message:String, ...vars):void
        {
            var i:int;
            if (this.console != null)
            {
                i = 0;
                while (i < vars.length)
                {
                    message = message.replace(("%" + (i + 1)), vars[i]);
                    i++;
                }
                this._console.write(message, 0);
            }
        }
        public function writeToConsoleChannel(channel:String, message:String, ...vars):void
        {
            var i:int;
            if (this.console != null)
            {
                i = 0;
                while (i < vars.length)
                {
                    message = message.replace(("%" + (i + 1)), vars[i]);
                    i++;
                }
            }
        }
        public function hideConsole():void
        {
            if (this._console != null)
            {
                this._console.hide();
            }
        }
        public function showConsole():void
        {
            if (this._console != null)
            {
                this._console.show();
            }
        }
        public function clearConsole():void
        {
            if (this._console != null)
            {
                this._console.clear();
            }
        }
        public function get console():Object
        {
            return (this._console);
        }

    }
}
