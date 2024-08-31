package com.lorentz.processing
{
    public class Process implements IProcess
    {

        public static const CONTINUE:int = 0;
        public static const SKIP_FRAME:int = 1;
        public static const COMPLETE:int = 2;

        private var _loopFunction:Function;
        private var _completeFunction:Function;
        private var _startFunction:Function;
        internal var _isComplete:Boolean = false;
        internal var _isRunning:Boolean = false;

        public function Process(startFunction:Function, loopFunction:Function, completeFunction:Function = null)
        {
            this._startFunction = startFunction;
            this._loopFunction = loopFunction;
            this._completeFunction = completeFunction;
        }
        public function get loopFunction():Function
        {
            return (this._loopFunction);
        }
        public function get completeFunction():Function
        {
            return (this._completeFunction);
        }
        public function get startFunction():Function
        {
            return (this._startFunction);
        }
        public function get isComplete():Boolean
        {
            return (this._isComplete);
        }
        public function get isRunning():Boolean
        {
            return (this._isRunning);
        }
        public function start():void
        {
            if (this._isRunning)
            {
                throw (new Error("This process is already running."));
            }
            if (this._isComplete)
            {
                throw (new Error("This process is complete."));
            }
            this._isRunning = true;
            if (this.startFunction != null)
            {
                this.startFunction();
            }
            ProcessExecutor.instance.addProcess(this);
        }
        public function execute():void
        {
            if (this.startFunction != null)
            {
                this.startFunction();
            }
            do
            {
            }
            while (this.loopFunction() != COMPLETE);
            this.complete();
        }
        public function stop():void
        {
            this._isRunning = false;
            ProcessExecutor.instance.removeProcess(this);
        }
        public function complete():void
        {
            this._isRunning = false;
            this._isComplete = true;
            if (this.completeFunction != null)
            {
                this.completeFunction();
            }
            ProcessExecutor.instance.removeProcess(this);
        }
        public function reset():void
        {
            if (this._isRunning)
            {
                this.stop();
            }
            this._isComplete = false;
        }
        public function executeLoop():Boolean
        {
            var r:* = this.loopFunction();
            if (r == COMPLETE)
            {
                this.complete();
            }
            return (r);
        }

    }
}
