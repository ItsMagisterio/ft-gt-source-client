package com.lorentz.SVG.utils
{
    public class SVGColorUtils
    {

        private static var colors:Object = {}

        {
            colors["aliceblue"] = 15792383;
            colors["antiquewhite"] = 16444375;
            colors["aqua"] = 0xFFFF;
            colors["aquamarine"] = 8388564;
            colors["azure"] = 15794175;
            colors["beige"] = 16119260;
            colors["bisque"] = 16770244;
            colors["black"] = 0;
            colors["blanchedalmond"] = 16772045;
            colors["blue"] = 0xFF;
            colors["blueviolet"] = 9055202;
            colors["brown"] = 10824234;
            colors["burlywood"] = 14596231;
            colors["cadetblue"] = 6266528;
            colors["chartreuse"] = 0x7FFF00;
            colors["chocolate"] = 13789470;
            colors["coral"] = 16744272;
            colors["cornflowerblue"] = 6591981;
            colors["cornsilk"] = 16775388;
            colors["crimson"] = 14423100;
            colors["cyan"] = 0xFFFF;
            colors["darkblue"] = 139;
            colors["darkcyan"] = 0x8B8B;
            colors["darkgoldenrod"] = 12092939;
            colors["darkgray"] = 0xA9A9A9;
            colors["darkgrey"] = 0xA9A9A9;
            colors["darkgreen"] = 0x6400;
            colors["darkkhaki"] = 12433259;
            colors["darkmagenta"] = 0x8B008B;
            colors["darkolivegreen"] = 5597999;
            colors["darkorange"] = 0xFF8C00;
            colors["darkorchid"] = 10040012;
            colors["darkred"] = 0x8B0000;
            colors["darksalmon"] = 15308410;
            colors["darkseagreen"] = 9419919;
            colors["darkslateblue"] = 4734347;
            colors["darkslategray"] = 3100495;
            colors["darkslategrey"] = 3100495;
            colors["darkturquoise"] = 52945;
            colors["darkviolet"] = 0x9400D3;
            colors["deeppink"] = 16716947;
            colors["deepskyblue"] = 49151;
            colors["dimgray"] = 0x696969;
            colors["dimgrey"] = 0x696969;
            colors["dodgerblue"] = 2003199;
            colors["firebrick"] = 11674146;
            colors["floralwhite"] = 16775920;
            colors["forestgreen"] = 2263842;
            colors["fuchsia"] = 0xFF00FF;
            colors["gainsboro"] = 0xDCDCDC;
            colors["ghostwhite"] = 16316671;
            colors["gold"] = 0xFFD700;
            colors["goldenrod"] = 14329120;
            colors["gray"] = 0x808080;
            colors["grey"] = 0x808080;
            colors["green"] = 0x8000;
            colors["greenyellow"] = 11403055;
            colors["honeydew"] = 15794160;
            colors["hotpink"] = 16738740;
            colors["indianred"] = 13458524;
            colors["indigo"] = 0x4B0082;
            colors["ivory"] = 16777200;
            colors["khaki"] = 15787660;
            colors["lavender"] = 15132410;
            colors["lavenderblush"] = 16773365;
            colors["lawngreen"] = 0x7CFC00;
            colors["lemonchiffon"] = 16775885;
            colors["lightblue"] = 11393254;
            colors["lightcoral"] = 15761536;
            colors["lightcyan"] = 14745599;
            colors["lightgoldenrodyellow"] = 16448210;
            colors["lightgray"] = 0xD3D3D3;
            colors["lightgrey"] = 0xD3D3D3;
            colors["lightgreen"] = 9498256;
            colors["lightpink"] = 16758465;
            colors["lightsalmon"] = 16752762;
            colors["lightseagreen"] = 2142890;
            colors["lightskyblue"] = 8900346;
            colors["lightslategray"] = 7833753;
            colors["lightslategrey"] = 7833753;
            colors["lightsteelblue"] = 11584734;
            colors["lightyellow"] = 16777184;
            colors["lime"] = 0xFF00;
            colors["limegreen"] = 3329330;
            colors["linen"] = 16445670;
            colors["magenta"] = 0xFF00FF;
            colors["maroon"] = 0x800000;
            colors["mediumaquamarine"] = 6737322;
            colors["mediumblue"] = 205;
            colors["mediumorchid"] = 12211667;
            colors["mediumpurple"] = 9662680;
            colors["mediumseagreen"] = 3978097;
            colors["mediumslateblue"] = 8087790;
            colors["mediumspringgreen"] = 64154;
            colors["mediumturquoise"] = 4772300;
            colors["mediumvioletred"] = 13047173;
            colors["midnightblue"] = 1644912;
            colors["mintcream"] = 16121850;
            colors["mistyrose"] = 16770273;
            colors["moccasin"] = 16770229;
            colors["navajowhite"] = 16768685;
            colors["navy"] = 128;
            colors["oldlace"] = 16643558;
            colors["olive"] = 0x808000;
            colors["olivedrab"] = 7048739;
            colors["orange"] = 0xFFA500;
            colors["orangered"] = 0xFF4500;
            colors["orchid"] = 14315734;
            colors["palegoldenrod"] = 15657130;
            colors["palegreen"] = 10025880;
            colors["paleturquoise"] = 11529966;
            colors["palevioletred"] = 14184595;
            colors["papayawhip"] = 16773077;
            colors["peachpuff"] = 16767673;
            colors["peru"] = 13468991;
            colors["pink"] = 16761035;
            colors["plum"] = 14524637;
            colors["powderblue"] = 11591910;
            colors["purple"] = 0x800080;
            colors["red"] = 0xFF0000;
            colors["rosybrown"] = 12357519;
            colors["royalblue"] = 4286945;
            colors["saddlebrown"] = 9127187;
            colors["salmon"] = 16416882;
            colors["sandybrown"] = 16032864;
            colors["seagreen"] = 3050327;
            colors["seashell"] = 16774638;
            colors["sienna"] = 10506797;
            colors["silver"] = 0xC0C0C0;
            colors["skyblue"] = 8900331;
            colors["slateblue"] = 6970061;
            colors["slategray"] = 7372944;
            colors["slategrey"] = 7372944;
            colors["snow"] = 16775930;
            colors["springgreen"] = 65407;
            colors["steelblue"] = 4620980;
            colors["tan"] = 13808780;
            colors["teal"] = 0x8080;
            colors["thistle"] = 14204888;
            colors["tomato"] = 16737095;
            colors["turquoise"] = 4251856;
            colors["violet"] = 15631086;
            colors["wheat"] = 16113331;
            colors["white"] = 0xFFFFFF;
            colors["whitesmoke"] = 0xF5F5F5;
            colors["yellow"] = 0xFFFF00;
            colors["yellowgreen"] = 10145074;
        }
        public static function getColorByName(name:String):uint
        {
            return (colors[name.toLowerCase()]);
        }
        public static function parseToUint(s:String):uint
        {
            var rgb:Array;
            var r:uint;
            var g:uint;
            var b:uint;
            if (s == null)
            {
                return (0);
            }
            s = StringUtil.trim(s);
            if (((s == "none") || (s == "")))
            {
                return (0);
            }
            if (s.charAt(0) == "#")
            {
                s = s.substring(1);
                if (s.length < 6)
                {
                    s = (((((s.charAt(0) + s.charAt(0)) + s.charAt(1)) + s.charAt(1)) + s.charAt(2)) + s.charAt(2));
                }
                return (new uint(("0x" + s)));
            }
            rgb = /\s*rgb\s*\(\s*(.*?)\s*,\s*(.*?)\s*,\s*(.*?)\s*\)/g.exec(s);
            if (rgb != null)
            {
                r = rgbColorPartToUint(rgb[1]);
                g = rgbColorPartToUint(rgb[2]);
                b = rgbColorPartToUint(rgb[3]);
                return (((r << 16) | (g << 8)) | b);
            }
            return (getColorByName(s));
        }
        private static function rgbColorPartToUint(s:String):uint
        {
            if (s.indexOf("%") != -1)
            {
                return ((Number(s.replace("%", "")) / 100) * 0xFF);
            }
            return (uint(s));
        }
        public static function uintToSVG(color:uint):String
        {
            var colorText:String = color.toString(16);
            while (colorText.length < 6)
            {
                colorText = ("0" + colorText);
            }
            return ("#" + colorText);
        }

    }
}
