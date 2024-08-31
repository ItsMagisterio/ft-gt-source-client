package com.lorentz.SVG.utils
{
    public class StringUtil
    {

        public static function trim(input:String, _arg_2:String = " "):String
        {
            return (StringUtil.ltrim(StringUtil.rtrim(input, _arg_2), _arg_2));
        }
        public static function ltrim(input:String, _arg_2:String = " "):String
        {
            var size:Number = input.length;
            var i:Number = 0;
            while (i < size)
            {
                if (input.charAt(i) != _arg_2)
                {
                    return (input.substring(i));
                }
                i++;
            }
            return ("");
        }
        public static function rtrim(input:String, _arg_2:String = " "):String
        {
            var size:Number = input.length;
            var i:Number = size;
            while (i > 0)
            {
                if (input.charAt((i - 1)) != _arg_2)
                {
                    return (input.substring(0, i));
                }
                i--;
            }
            return ("");
        }
        public static function remove(input:String, remove:String):String
        {
            return (StringUtil.replace(input, remove, ""));
        }
        public static function replace(input:String, replace:String, replaceWith:String):String
        {
            var j:Number;
            var sb:String = new String();
            var found:Boolean;
            var sLen:Number = input.length;
            var rLen:Number = replace.length;
            var i:Number = 0;
            for (; i < sLen; i++)
            {
                if (input.charAt(i) == replace.charAt(0))
                {
                    found = true;
                    j = 0;
                    while (j < rLen)
                    {
                        if ((!(input.charAt((i + j)) == replace.charAt(j))))
                        {
                            found = false;
                            break;
                        }
                        j++;
                    }
                    if (found)
                    {
                        sb = (sb + replaceWith);
                        i = (i + (rLen - 1));
                        continue;
                    }
                }
                sb = (sb + input.charAt(i));
            }
            return (sb);
        }
        public static function shrinkSequencesOf(s:String, ch:String):String
        {
            var len:int = s.length;
            var idx:int;
            var idx2:int;
            var rs:String = "";
            while ((idx2 = (s.indexOf(ch, idx) + 1)) != 0)
            {
                rs = (rs + s.substring(idx, idx2));
                idx = idx2;
                while (((s.charAt(idx) == ch) && (idx < len)))
                {
                    idx++;
                }
            }
            return (rs + s.substring(idx, len));
        }

    }
}
