package com.lorentz.SVG.utils
{
    import flash.events.EventDispatcher;
    import flash.utils.ByteArray;
    import com.lorentz.processing.Process;
    import flash.events.Event;

    public class Base64AsyncDecoder extends EventDispatcher
    {

        public static const COMPLETE:String = "complete";
        public static const ERROR:String = "fail";
        private static const ESCAPE_CHAR_CODE:Number = 61;
        private static const inverse:Array = [64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 62, 64, 64, 64, 63, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 64, 64, 64, 64, 64, 64, 64, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 64, 64, 64, 64, 64, 64, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64];

        public var bytes:ByteArray;
        public var errorMessage:String;
        private var encoded:String;
        private var index:uint = 0;
        private var count:int = 0;
        private var filled:int = 0;
        private var work:Array = [0, 0, 0, 0];

        public function Base64AsyncDecoder(encoded:String)
        {
            this.encoded = encoded;
        }
        public function decode():void
        {
            new Process(this.startFunction, this.loopFunction, this.completeFunction).start();
        }
        private function startFunction():void
        {
            this.bytes = new ByteArray();
            this.count = 0;
            this.filled = 0;
            this.index = 0;
            this.errorMessage = null;
        }
        private function loopFunction():int
        {
            var c:Number;
            var z:int;
            for (; z < 100; z++)
            {
                if (this.index == this.encoded.length)
                {
                    return (Process.COMPLETE);
                }
                c = this.encoded.charCodeAt(this.index++ );
                if (c == ESCAPE_CHAR_CODE)
                {
                    var _local_3:* = this.count++;
                    this.work[_local_3] = -1;
                }
                else
                {
                    if (inverse[c] != 64)
                    {
                        _local_3 = this.count++;
                        this.work[_local_3] = inverse[c];
                    }
                    else
                    {
                        continue;
                    }
                }
                if (this.count == 4)
                {
                    this.count = 0;
                    this.bytes.writeByte(((this.work[0] << 2) | ((this.work[1] & 0xFF) >> 4)));
                    this.filled++;
                    if (this.work[2] == -1)
                    {
                        return (Process.COMPLETE);
                    }
                    this.bytes.writeByte(((this.work[1] << 4) | ((this.work[2] & 0xFF) >> 2)));
                    this.filled++;
                    if (this.work[3] == -1)
                    {
                        return (Process.COMPLETE);
                    }
                    this.bytes.writeByte(((this.work[2] << 6) | this.work[3]));
                    this.filled++;
                }
            }
            return (Process.CONTINUE);
        }
        private function completeFunction():void
        {
            if (this.count > 0)
            {
                this.errorMessage = (("A partial block (" + this.count) + " of 4 bytes) was dropped. Decoded data is probably truncated!");
                dispatchEvent(new Event(ERROR));
            }
            else
            {
                dispatchEvent(new Event(COMPLETE));
            }
        }

    }
}
