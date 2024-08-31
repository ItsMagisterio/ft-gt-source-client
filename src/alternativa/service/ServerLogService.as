package alternativa.service
{
    import alternativa.osgi.service.log.ILogService;
    import alternativa.network.CommandSocket;
    import flash.utils.Dictionary;
    import flash.display.Stage;
    import alternativa.network.ICommandSender;
    import alternativa.network.command.ControlCommand;
    import alternativa.osgi.service.log.LogLevel;

    public class ServerLogService implements ILogService
    {

        private var controlSocket:CommandSocket;
        private var errorLog:ErrorLog;
        private var localErrorLevels:Dictionary;

        public function ServerLogService(controlSocket:CommandSocket, stage:Stage, localErrorLevels:Array)
        {
            var i:int;
            super();
            this.controlSocket = controlSocket;
            this.errorLog = new ErrorLog(stage);
            if (localErrorLevels != null)
            {
                this.localErrorLevels = new Dictionary();
                for each (i in localErrorLevels)
                {
                    this.localErrorLevels[i] = true;
                }
            }
        }
        public function log(level:int, message:String, exception:String = null):void
        {
            ICommandSender(this.controlSocket).sendCommand(new ControlCommand(ControlCommand.LOG, "log", [level, message]));
            if (((this.localErrorLevels == null) || (!(this.localErrorLevels[level] == null))))
            {
                this.errorLog.addLogMessage(LogLevel.toString(level), message);
            }
        }

    }
}
