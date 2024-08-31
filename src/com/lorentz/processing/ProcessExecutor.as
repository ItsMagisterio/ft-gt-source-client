package com.lorentz.processing
{
    import flash.display.Stage;
    import __AS3__.vec.Vector;
    import flash.events.Event;
    import flash.utils.getTimer;
    import __AS3__.vec.*;

    public class ProcessExecutor
    {

        private static var _allowInstantiation:Boolean = false;
        private static var _instance:ProcessExecutor;

        private var _stage:Stage;
        private var _processes:Vector.<IProcess>;
        private var _percentFrameProcessingTime:Number = 0.25;

        public function ProcessExecutor()
        {
            if ((!(_allowInstantiation)))
            {
                throw (new Error("The class 'ProcessExecutor' is singleton."));
            }
        }
        public static function get instance():ProcessExecutor
        {
            if (_instance == null)
            {
                _allowInstantiation = true;
                _instance = new (ProcessExecutor)();
                _allowInstantiation = false;
            }
            return (_instance);
        }

        public function initialize(stage:Stage):void
        {
            this._stage = stage;
            this._processes = new Vector.<IProcess>();
        }
        public function get percentFrameProcessingTime():Number
        {
            return (this._percentFrameProcessingTime);
        }
        public function set percentFrameProcessingTime(value:Number):void
        {
            this._percentFrameProcessingTime = value;
        }
        private function get internalFrameProcessingTime():Number
        {
            return ((1000 / this._stage.frameRate) * this._percentFrameProcessingTime);
        }
        private function ensureInitialized():void
        {
            if (this._stage == null)
            {
                throw (new Error("You must initialize the ProcessExecutor. Ex: ProcessExecutor.instance.initialize(stage)"));
            }
        }
        public function addProcess(process:IProcess):void
        {
            this.ensureInitialized();
            if (this._processes.length == 0)
            {
                this._stage.addEventListener(Event.ENTER_FRAME, this.enterFrameHandler, false, 0, false);
            }
            this._processes.push(process);
        }
        public function containsProcess(process:IProcess):Boolean
        {
            return (!(this._processes.indexOf(process) == -1));
        }
        public function removeProcess(process:IProcess):void
        {
            var index:int = this._processes.indexOf(process);
            if (index == -1)
            {
                return;
            }
            this._processes.splice(index, 1);
            if (this._processes.length == 0)
            {
                this._stage.removeEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
            }
        }
        private function enterFrameHandler(e:Event):void
        {
            var process:IProcess;
            var timePerProcess:int = int((this.internalFrameProcessingTime / this._processes.length));
            for each (process in this._processes)
            {
                this.executeProcess(process, timePerProcess);
            }
        }
        private function executeProcess(process:IProcess, duration:int):void
        {
            var endTime:int = (getTimer() + duration);
            var executeFunction:Function = process.executeLoop;
            do
            {
                if (executeFunction())
                {
                    break;
                }
            }
            while (getTimer() < endTime);
        }

    }
}
