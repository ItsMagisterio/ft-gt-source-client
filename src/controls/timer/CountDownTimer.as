package controls.timer
{
    // import platform.client.fp10.core.type.AutoClosable;
    import __AS3__.vec.Vector;
    import flash.utils.clearInterval;
    import flash.utils.getTimer;
    import flash.utils.setInterval;
    import __AS3__.vec.*;

    public class CountDownTimer
    {

        [Inject]
        private static var allTimers:Vector.<CountDownTimer> = new Vector.<CountDownTimer>();
        private static var intervalId:int;
        private static var EMPTY_VECTOR:Vector.<Object> = new Vector.<Object>(0, true);

        private var endTime:Number;
        private var remainingTimeInSeconds:int;
        private var allListeners:Object = {}

        public static function resetAllTimers():void
        {
            if (allTimers.length != 0)
            {
                clearInterval(intervalId);
                allTimers.length = 0;
            }
        }
        private static function onAllTimersTick():void
        {
            var _local_3:CountDownTimer;
            var _local_1:int = getTimer();
            var _local_2:int = (allTimers.length - 1);
            while (_local_2 >= 0)
            {
                _local_3 = allTimers[_local_2];
                _local_3.onTick(_local_1);
                _local_2--;
            }
        }

        public function addListener(_arg_1:Class, _arg_2:Object):void
        {
            var _local_3:Vector.<Object> = this.allListeners[_arg_1];
            if (_local_3 == null)
            {
                this.allListeners[_arg_1] = (_local_3 = new Vector.<Object>());
            }
            _local_3.push(_arg_2);
        }
        public function removeListener(_arg_1:Class, _arg_2:Object):void
        {
            var _local_3:Vector.<Object> = this.allListeners[_arg_1];
            if (_local_3 != null)
            {
                _local_3.splice(_local_3.indexOf(_arg_2), 1);
            }
        }
        public function start(_arg_1:Number):void
        {
            this.endTime = _arg_1;
            this.addTimer();
            this.remainingTimeInSeconds = Math.ceil(((_arg_1 - getTimer()) / 1000));
        }
        public function destroy():void
        {
            this.removeTimer();
            this.allListeners = {}
        }
        public function stop():void
        {
            this._stop(true);
        }
        private function _stop(_arg_1:Boolean):void
        {
            var _local_2:CountDownTimerOnCompleteBefore;
            var _local_3:CountDownTimerOnCompleteAfter;
            this.removeTimer();
            this.remainingTimeInSeconds = 0;
            for each (_local_2 in this.getListeners(CountDownTimerOnCompleteBefore).concat())
            {
                _local_2.onCompleteBefore(this, _arg_1);
            }
            for each (_local_3 in this.getListeners(CountDownTimerOnCompleteAfter).concat())
            {
                _local_3.onCompleteAfter(this, _arg_1);
            }
            this.allListeners = {}
        }
        public function getRemainingSeconds():int
        {
            return (this.remainingTimeInSeconds);
        }
        public function getEndTime():uint
        {
            return (this.endTime);
        }
        private function onTick(_arg_1:int):void
        {
            var _local_2:CountDownTimerOnTick;
            this.remainingTimeInSeconds = Math.ceil(((this.endTime - _arg_1) / 1000));
            if (this.remainingTimeInSeconds <= 0)
            {
                this._stop(false);
            }
            else
            {
                for each (_local_2 in this.getListeners(CountDownTimerOnTick))
                {
                    _local_2.onTick(this);
                }
            }
        }
        private function getListeners(_arg_1:Class):Vector.<Object>
        {
            var _local_2:Vector.<Object> = this.allListeners[_arg_1];
            if (_local_2 != null)
            {
                return (_local_2);
            }
            return (EMPTY_VECTOR);
        }
        private function addTimer():void
        {
            if (allTimers.length == 0)
            {
                intervalId = setInterval(onAllTimersTick, 1000);
            }
            allTimers.push(this);
        }
        private function removeTimer():void
        {
            var _local_1:Number = allTimers.indexOf(this);
            if (_local_1 == -1)
            {
                return;
            }
            allTimers.splice(_local_1, 1);
            if (allTimers.length == 0)
            {
                clearInterval(intervalId);
            }
        }
        public function close():void
        {
            this.destroy();
        }

    }
} // package controls.timer