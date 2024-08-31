// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// specter.utils.Logger

package specter.utils
{
    import alternativa.console.IConsole;
    import alternativa.init.Main;
    import alternativa.osgi.service.log.LogLevel;

    public class Logger
    {

        public static var debugging:Boolean;
        private static var Console:IConsole;

        public static function init():void
        {
            Console = (Main.osgi.getService(IConsole) as IConsole);
            debugging = false;
        }
        public static function debug(msg:String, stacktrace:Boolean = false):void
        {
            if ((!(debugging)))
            {
                return;
            }
            Console.addLine(("[DEBUG] " + msg));
            if ((!(stacktrace)))
            {
                return;
            }
            try
            {
                throw (new Error());
            }
            catch (e:Error)
            {
                Console.addLine(e.getStackTrace());
            }
        }
        public static function log(msg:String, stacktrace:Boolean = false):void
        {
            Console.addLine(("[LOG] " + msg));
            if ((!(stacktrace)))
            {
                return;
            }
            try
            {
                throw (new Error());
            }
            catch (e:Error)
            {
                Console.addLine(e.getStackTrace());
            }
        }
        public static function info(lvl:int, msg:String):void
        {
            Console.addLine(((("[" + LogLevel.toString(lvl)) + "] ") + msg));
        }
        public static function warn(msg:String, stacktrace:Boolean = false):void
        {
            Console.addLine(("[WARN] " + msg));
            if ((!(stacktrace)))
            {
                return;
            }
            try
            {
                throw (new Error());
            }
            catch (e:Error)
            {
                Console.addLine(e.getStackTrace());
            }
        }

    }
} // package specter.utils