package alternativa.osgi.service.loader
{
    import __AS3__.vec.Vector;
    import flash.utils.Dictionary;
    import alternativa.init.OSGi;
    import alternativa.osgi.service.console.IConsoleService;
    import __AS3__.vec.*;

    public class LoadingProgress
    {

        private var listeners:Vector.<ILoadingProgressListener>;
        private var progressData:Dictionary;

        public function LoadingProgress()
        {
            this.listeners = new Vector.<ILoadingProgressListener>();
            this.progressData = new Dictionary();
        }
        public function addEventListener(listener:ILoadingProgressListener):void
        {
            this.listeners.push(listener);
        }
        public function removeEventListener(listener:ILoadingProgressListener):void
        {
            this.listeners.splice(this.listeners.indexOf(listener), 1);
        }
        public function startProgress(processId:Object):void
        {
            var i:int;
            while (i < this.listeners.length)
            {
                ILoadingProgressListener(this.listeners[i]).processStarted(processId);
                i++;
            }
        }
        public function stopProgress(processId:Object):void
        {
            var i:int;
            while (i < this.listeners.length)
            {
                ILoadingProgressListener(this.listeners[i]).processStoped(processId);
                i++;
            }
        }
        public function setStatus(processId:Object, value:String):void
        {
            (OSGi.osgi.getService(IConsoleService) as IConsoleService).writeToConsoleChannel("LOADING PROGRESS", "setStatus: %1 (processId: %2)", value, processId);
            if (this.progressData[processId] == null)
            {
                this.progressData[processId] = new LoadingProgressData(value, 0);
            }
            else
            {
                LoadingProgressData(this.progressData[processId]).status = value;
            }
            var i:int;
            while (i < this.listeners.length)
            {
                ILoadingProgressListener(this.listeners[i]).changeStatus(processId, value);
                i++;
            }
        }
        public function setProgress(processId:Object, value:Number):void
        {
            (OSGi.osgi.getService(IConsoleService) as IConsoleService).writeToConsoleChannel("LOADING PROGRESS", "setProgress: %1 (processId: %2)", value, processId);
            if (value < 0)
            {
                value = 0;
            }
            if (value > 1)
            {
                value = 1;
            }
            if (this.progressData[processId] == null)
            {
                if (value != 1)
                {
                    this.progressData[processId] = new LoadingProgressData("", value);
                }
            }
            else
            {
                if (value != 1)
                {
                    LoadingProgressData(this.progressData[processId]).progress = value;
                }
                else
                {
                    this.progressData[processId] = null;
                }
            }
            var i:int;
            while (i < this.listeners.length)
            {
                ILoadingProgressListener(this.listeners[i]).changeProgress(processId, value);
                i++;
            }
        }
        public function getStatus(processId:Object):String
        {
            var status:String = ((!(this.progressData[processId] == null)) ? LoadingProgressData(this.progressData[processId]).status : "");
            return (status);
        }
        public function getProgress(processId:Object):Number
        {
            var progress:Number = ((!(this.progressData[processId] == null)) ? Number(LoadingProgressData(this.progressData[processId]).progress) : Number(0));
            return (progress);
        }

    }
}
