﻿package controls
{
    public class Money
    {

        public static const ROUBLE_SIGN:String = " ¤";

        public static function roubleToString(value:Number):String
        {
            var subs:Array = new Array();
            var str:String = String(value);
            var len:int = int((str.length - (int((str.length / 3)) * 3)));
            var pos:int;
            if (len > 0)
            {
                str = (((len == 1) ? "  " : " ") + str);
            }
            pos = 0;
            while (pos < str.length)
            {
                subs.push(str.substr(pos, 3));
                pos = (pos + 3);
            }
            str = subs.join(" ");
            if (len > 0)
            {
                str = str.substr((3 - len));
            }
            return (str + ROUBLE_SIGN);
        }
        public static function numToString(value:Number, fl:Boolean = true):String
        {
            var subs:Array = new Array();
            var str:String = ((fl) ? String(int(value)) : String(Math.round(value)));
            var len:int = int((str.length - (int((str.length / 3)) * 3)));
            var pos:int;
            if (len > 0)
            {
                str = (((len == 1) ? "  " : " ") + str);
            }
            pos = 0;
            while (pos < str.length)
            {
                subs.push(str.substr(pos, 3));
                pos = (pos + 3);
            }
            str = subs.join(" ");
            if (len > 0)
            {
                str = str.substr((3 - len));
            }
            return (str + ((fl) ? value.toFixed(10).substr(-11, 3) : ""));
        }

    }
}
