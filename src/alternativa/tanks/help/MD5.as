﻿package alternativa.tanks.help
{
    public class MD5
    {

        public static const HEX_FORMAT_LOWERCASE:uint = 0;
        public static const HEX_FORMAT_UPPERCASE:uint = 1;
        public static const BASE64_PAD_CHARACTER_DEFAULT_COMPLIANCE:String = "";
        public static const BASE64_PAD_CHARACTER_RFC_COMPLIANCE:String = "=";
        public static var hexcase:uint = 0;
        public static var b64pad:String = "";

        public static function encrypt(string:String):String
        {
            return (hex_md5(string));
        }
        public static function hex_md5(string:String):String
        {
            return (rstr2hex(rstr_md5(str2rstr_utf8(string))));
        }
        public static function b64_md5(string:String):String
        {
            return (rstr2b64(rstr_md5(str2rstr_utf8(string))));
        }
        public static function any_md5(string:String, encoding:String):String
        {
            return (rstr2any(rstr_md5(str2rstr_utf8(string)), encoding));
        }
        public static function hex_hmac_md5(key:String, data:String):String
        {
            return (rstr2hex(rstr_hmac_md5(str2rstr_utf8(key), str2rstr_utf8(data))));
        }
        public static function b64_hmac_md5(key:String, data:String):String
        {
            return (rstr2b64(rstr_hmac_md5(str2rstr_utf8(key), str2rstr_utf8(data))));
        }
        public static function any_hmac_md5(key:String, data:String, encoding:String):String
        {
            return (rstr2any(rstr_hmac_md5(str2rstr_utf8(key), str2rstr_utf8(data)), encoding));
        }
        public static function md5_vm_test():Boolean
        {
            return (hex_md5("abc") == "900150983cd24fb0d6963f7d28e17f72");
        }
        public static function rstr_md5(string:String):String
        {
            return (binl2rstr(binl_md5(rstr2binl(string), (string.length * 8))));
        }
        public static function rstr_hmac_md5(key:String, data:String):String
        {
            var bkey:Array = rstr2binl(key);
            if (bkey.length > 16)
            {
                bkey = binl_md5(bkey, (key.length * 8));
            }
            var ipad:Array = new Array(16);
            var opad:Array = new Array(16);
            var i:Number = 0;
            while (i < 16)
            {
                ipad[i] = (bkey[i] ^ 0x36363636);
                opad[i] = (bkey[i] ^ 0x5C5C5C5C);
                i++;
            }
            var hash:Array = binl_md5(ipad.concat(rstr2binl(data)), (0x0200 + (data.length * 8)));
            return (binl2rstr(binl_md5(opad.concat(hash), (0x0200 + 128))));
        }
        public static function rstr2hex(input:String):String
        {
            var x:Number = NaN;
            var hex_tab:String = ((Boolean(hexcase)) ? "0123456789ABCDEF" : "0123456789abcdef");
            var output:String = "";
            var i:Number = 0;
            while (i < input.length)
            {
                x = input.charCodeAt(i);
                output = (output + (hex_tab.charAt(((x >>> 4) & 0x0F)) + hex_tab.charAt((x & 0x0F))));
                i++;
            }
            return (output);
        }
        public static function rstr2b64(input:String):String
        {
            var triplet:Number = NaN;
            var j:Number = NaN;
            var tab:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
            var output:String = "";
            var len:Number = input.length;
            var i:Number = 0;
            while (i < len)
            {
                triplet = (((input.charCodeAt(i) << 16) | (((i + 1) < len) ? (input.charCodeAt((i + 1)) << 8) : 0)) | (((i + 2) < len) ? input.charCodeAt((i + 2)) : 0));
                j = 0;
                while (j < 4)
                {
                    if (((i * 8) + (j * 6)) > (input.length * 8))
                    {
                        output = (output + b64pad);
                    }
                    else
                    {
                        output = (output + tab.charAt(((triplet >>> (6 * (3 - j))) & 0x3F)));
                    }
                    j++;
                }
                i = (i + 3);
            }
            return (output);
        }
        public static function rstr2any(input:String, encoding:String):String
        {
            var i:Number = NaN;
            var q:Number = NaN;
            var x:Number = NaN;
            var quotient:Array;
            var divisor:Number = encoding.length;
            var remainders:Array = [];
            var dividend:Array = new Array((input.length / 2));
            i = 0;
            while (i < dividend.length)
            {
                dividend[i] = ((input.charCodeAt((i * 2)) << 8) | input.charCodeAt(((i * 2) + 1)));
                i++;
            }
            while (dividend.length > 0)
            {
                quotient = [];
                x = 0;
                i = 0;
                while (i < dividend.length)
                {
                    x = ((x << 16) + dividend[i]);
                    q = Math.floor((x / divisor));
                    x = (x - (q * divisor));
                    if (((quotient.length > 0) || (q > 0)))
                    {
                        quotient[quotient.length] = q;
                    }
                    i++;
                }
                remainders[remainders.length] = x;
                dividend = quotient;
            }
            var output:String = "";
            i = (remainders.length - 1);
            while (i >= 0)
            {
                output = (output + encoding.charAt(remainders[i]));
                i--;
            }
            return (output);
        }
        public static function str2rstr_utf8(input:String):String
        {
            var x:Number = NaN;
            var y:Number = NaN;
            var output:String = "";
            var i:Number = -1;
            while (++i < input.length)
            {
                x = input.charCodeAt(i);
                y = (((i + 1) < input.length) ? Number(input.charCodeAt((i + 1))) : Number(0));
                if (((((0xD800 <= x) && (x <= 56319)) && (0xDC00 <= y)) && (y <= 57343)))
                {
                    x = ((0x10000 + ((x & 0x03FF) << 10)) + (y & 0x03FF));
                    i++;
                }
                if (x <= 127)
                {
                    output = (output + String.fromCharCode(x));
                }
                else
                {
                    if (x <= 2047)
                    {
                        output = (output + String.fromCharCode((0xC0 | ((x >>> 6) & 0x1F)), (0x80 | (x & 0x3F))));
                    }
                    else
                    {
                        if (x <= 0xFFFF)
                        {
                            output = (output + String.fromCharCode((0xE0 | ((x >>> 12) & 0x0F)), (0x80 | ((x >>> 6) & 0x3F)), (0x80 | (x & 0x3F))));
                        }
                        else
                        {
                            if (x <= 2097151)
                            {
                                output = (output + String.fromCharCode((0xF0 | ((x >>> 18) & 0x07)), (0x80 | ((x >>> 12) & 0x3F)), (0x80 | ((x >>> 6) & 0x3F)), (0x80 | (x & 0x3F))));
                            }
                        }
                    }
                }
            }
            return (output);
        }
        public static function str2rstr_utf16le(input:String):String
        {
            var output:String = "";
            var i:Number = 0;
            while (i < input.length)
            {
                output = (output + String.fromCharCode((input.charCodeAt(i) & 0xFF), ((input.charCodeAt(i) >>> 8) & 0xFF)));
                i++;
            }
            return (output);
        }
        public static function str2rstr_utf16be(input:String):String
        {
            var output:String = "";
            var i:Number = 0;
            while (i < input.length)
            {
                output = (output + String.fromCharCode(((input.charCodeAt(i) >>> 8) & 0xFF), (input.charCodeAt(i) & 0xFF)));
                i++;
            }
            return (output);
        }
        public static function rstr2binl(input:String):Array
        {
            var i:Number = 0;
            var output:Array = new Array((input.length >> 2));
            i = 0;
            while (i < output.length)
            {
                output[i] = 0;
                i++;
            }
            i = 0;
            while (i < (input.length * 8))
            {
                output[(i >> 5)] = (output[(i >> 5)] | ((input.charCodeAt((i / 8)) & 0xFF) << (i % 32)));
                i = (i + 8);
            }
            return (output);
        }
        public static function binl2rstr(input:Array):String
        {
            var output:String = "";
            var i:Number = 0;
            while (i < (input.length * 32))
            {
                output = (output + String.fromCharCode(((input[(i >> 5)] >>> (i % 32)) & 0xFF)));
                i = (i + 8);
            }
            return (output);
        }
        public static function binl_md5(x:Array, len:Number):Array
        {
            var olda:Number = NaN;
            var oldb:Number = NaN;
            var oldc:Number = NaN;
            var oldd:Number = NaN;
            x[(len >> 5)] = (x[(len >> 5)] | (128 << (len % 32)));
            x[((((len + 64) >>> 9) << 4) + 14)] = len;
            var a:Number = 1732584193;
            var b:Number = -271733879;
            var c:Number = -1732584194;
            var d:Number = 271733878;
            var i:Number = 0;
            while (i < x.length)
            {
                olda = a;
                oldb = b;
                oldc = c;
                oldd = d;
                a = md5_ff(a, b, c, d, x[(i + 0)], 7, -680876936);
                d = md5_ff(d, a, b, c, x[(i + 1)], 12, -389564586);
                c = md5_ff(c, d, a, b, x[(i + 2)], 17, 606105819);
                b = md5_ff(b, c, d, a, x[(i + 3)], 22, -1044525330);
                a = md5_ff(a, b, c, d, x[(i + 4)], 7, -176418897);
                d = md5_ff(d, a, b, c, x[(i + 5)], 12, 1200080426);
                c = md5_ff(c, d, a, b, x[(i + 6)], 17, -1473231341);
                b = md5_ff(b, c, d, a, x[(i + 7)], 22, -45705983);
                a = md5_ff(a, b, c, d, x[(i + 8)], 7, 1770035416);
                d = md5_ff(d, a, b, c, x[(i + 9)], 12, -1958414417);
                c = md5_ff(c, d, a, b, x[(i + 10)], 17, -42063);
                b = md5_ff(b, c, d, a, x[(i + 11)], 22, -1990404162);
                a = md5_ff(a, b, c, d, x[(i + 12)], 7, 1804603682);
                d = md5_ff(d, a, b, c, x[(i + 13)], 12, -40341101);
                c = md5_ff(c, d, a, b, x[(i + 14)], 17, -1502002290);
                b = md5_ff(b, c, d, a, x[(i + 15)], 22, 1236535329);
                a = md5_gg(a, b, c, d, x[(i + 1)], 5, -165796510);
                d = md5_gg(d, a, b, c, x[(i + 6)], 9, -1069501632);
                c = md5_gg(c, d, a, b, x[(i + 11)], 14, 643717713);
                b = md5_gg(b, c, d, a, x[(i + 0)], 20, -373897302);
                a = md5_gg(a, b, c, d, x[(i + 5)], 5, -701558691);
                d = md5_gg(d, a, b, c, x[(i + 10)], 9, 38016083);
                c = md5_gg(c, d, a, b, x[(i + 15)], 14, -660478335);
                b = md5_gg(b, c, d, a, x[(i + 4)], 20, -405537848);
                a = md5_gg(a, b, c, d, x[(i + 9)], 5, 568446438);
                d = md5_gg(d, a, b, c, x[(i + 14)], 9, -1019803690);
                c = md5_gg(c, d, a, b, x[(i + 3)], 14, -187363961);
                b = md5_gg(b, c, d, a, x[(i + 8)], 20, 1163531501);
                a = md5_gg(a, b, c, d, x[(i + 13)], 5, -1444681467);
                d = md5_gg(d, a, b, c, x[(i + 2)], 9, -51403784);
                c = md5_gg(c, d, a, b, x[(i + 7)], 14, 1735328473);
                b = md5_gg(b, c, d, a, x[(i + 12)], 20, -1926607734);
                a = md5_hh(a, b, c, d, x[(i + 5)], 4, -378558);
                d = md5_hh(d, a, b, c, x[(i + 8)], 11, -2022574463);
                c = md5_hh(c, d, a, b, x[(i + 11)], 16, 1839030562);
                b = md5_hh(b, c, d, a, x[(i + 14)], 23, -35309556);
                a = md5_hh(a, b, c, d, x[(i + 1)], 4, -1530992060);
                d = md5_hh(d, a, b, c, x[(i + 4)], 11, 1272893353);
                c = md5_hh(c, d, a, b, x[(i + 7)], 16, -155497632);
                b = md5_hh(b, c, d, a, x[(i + 10)], 23, -1094730640);
                a = md5_hh(a, b, c, d, x[(i + 13)], 4, 681279174);
                d = md5_hh(d, a, b, c, x[(i + 0)], 11, -358537222);
                c = md5_hh(c, d, a, b, x[(i + 3)], 16, -722521979);
                b = md5_hh(b, c, d, a, x[(i + 6)], 23, 76029189);
                a = md5_hh(a, b, c, d, x[(i + 9)], 4, -640364487);
                d = md5_hh(d, a, b, c, x[(i + 12)], 11, -421815835);
                c = md5_hh(c, d, a, b, x[(i + 15)], 16, 530742520);
                b = md5_hh(b, c, d, a, x[(i + 2)], 23, -995338651);
                a = md5_ii(a, b, c, d, x[(i + 0)], 6, -198630844);
                d = md5_ii(d, a, b, c, x[(i + 7)], 10, 1126891415);
                c = md5_ii(c, d, a, b, x[(i + 14)], 15, -1416354905);
                b = md5_ii(b, c, d, a, x[(i + 5)], 21, -57434055);
                a = md5_ii(a, b, c, d, x[(i + 12)], 6, 1700485571);
                d = md5_ii(d, a, b, c, x[(i + 3)], 10, -1894986606);
                c = md5_ii(c, d, a, b, x[(i + 10)], 15, -1051523);
                b = md5_ii(b, c, d, a, x[(i + 1)], 21, -2054922799);
                a = md5_ii(a, b, c, d, x[(i + 8)], 6, 1873313359);
                d = md5_ii(d, a, b, c, x[(i + 15)], 10, -30611744);
                c = md5_ii(c, d, a, b, x[(i + 6)], 15, -1560198380);
                b = md5_ii(b, c, d, a, x[(i + 13)], 21, 1309151649);
                a = md5_ii(a, b, c, d, x[(i + 4)], 6, -145523070);
                d = md5_ii(d, a, b, c, x[(i + 11)], 10, -1120210379);
                c = md5_ii(c, d, a, b, x[(i + 2)], 15, 718787259);
                b = md5_ii(b, c, d, a, x[(i + 9)], 21, -343485551);
                a = safe_add(a, olda);
                b = safe_add(b, oldb);
                c = safe_add(c, oldc);
                d = safe_add(d, oldd);
                i = (i + 16);
            }
            return ([a, b, c, d]);
        }
        public static function md5_cmn(q:Number, a:Number, b:Number, x:Number, s:Number, t:Number):Number
        {
            return (safe_add(bit_rol(safe_add(safe_add(a, q), safe_add(x, t)), s), b));
        }
        public static function md5_ff(a:Number, b:Number, c:Number, d:Number, x:Number, s:Number, t:Number):Number
        {
            return (md5_cmn(((b & c) | ((~(b)) & d)), a, b, x, s, t));
        }
        public static function md5_gg(a:Number, b:Number, c:Number, d:Number, x:Number, s:Number, t:Number):Number
        {
            return (md5_cmn(((b & d) | (c & (~(d)))), a, b, x, s, t));
        }
        public static function md5_hh(a:Number, b:Number, c:Number, d:Number, x:Number, s:Number, t:Number):Number
        {
            return (md5_cmn(((b ^ c) ^ d), a, b, x, s, t));
        }
        public static function md5_ii(a:Number, b:Number, c:Number, d:Number, x:Number, s:Number, t:Number):Number
        {
            return (md5_cmn((c ^ (b | (~(d)))), a, b, x, s, t));
        }
        public static function safe_add(x:Number, y:Number):Number
        {
            var lsw:Number = ((x & 0xFFFF) + (y & 0xFFFF));
            var msw:Number = (((x >> 16) + (y >> 16)) + (lsw >> 16));
            return ((msw << 16) | (lsw & 0xFFFF));
        }
        public static function bit_rol(num:Number, cnt:Number):Number
        {
            return ((num << cnt) | (num >>> (32 - cnt)));
        }

    }
}
