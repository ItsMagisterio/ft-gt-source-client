package com.lorentz.SVG.utils
{
    import com.lorentz.SVG.data.style.StyleDeclaration;
    import flash.geom.Matrix;

    public class SVGUtil
    {

        private static var _specialXMLEntities:Object = {
                "quot": '"',
                "amp": "&",
                "apos": "'",
                "lt": "<",
                "gt": ">",
                "nbsp": " "
            }
        protected static const presentationStyles:Array = ["display", "visibility", "opacity", "fill", "fill-opacity", "fill-rule", "stroke", "stroke-opacity", "stroke-width", "stroke-linecap", "stroke-linejoin", "stroke-dasharray", "stroke-dashoffset", "stroke-dashalign", "font-size", "font-family", "font-weight", "text-anchor", "letter-spacing", "dominant-baseline", "direction", "filter", "marker", "marker-start", "marker-mid", "marker-end"];
        public static const WIDTH:String = "width";
        public static const HEIGHT:String = "height";
        public static const WIDTH_HEIGHT:String = "width_height";
        public static const FONT_SIZE:String = "font_size";

        public static function processXMLEntities(xmlString:String):String
        {
            var entity:Array;
            var entityDeclaration:String;
            var entityName:String;
            var entityValue:String;
            while (true)
            {
                entity = /<!ENTITY\s+(\w*)\s+"((?:.|\s)*?)"\s*>/.exec(xmlString);
                if (entity == null)
                {
                    break;
                }
                entityDeclaration = entity[0];
                entityName = entity[1];
                entityValue = entity[2];
                xmlString = xmlString.replace(entityDeclaration, "");
                xmlString = xmlString.replace(new RegExp((("&" + entityName) + ";"), "g"), entityValue);
            }
            return (xmlString);
        }
        public static function processSpecialXMLEntities(s:String):String
        {
            var entityName:String;
            for (entityName in _specialXMLEntities)
            {
                s = s.replace(new RegExp((("\\&" + entityName) + ";"), "g"), _specialXMLEntities[entityName]);
            }
            return (s);
        }
        public static function replaceCharacterReferences(s:String):String
        {
            var hexaUnicode:String;
            var decimalUnicode:String;
            var hexaValue:String;
            var decimalValue:String;
            for each (hexaUnicode in s.match(/&#x[A-Fa-f0-9]+;/g))
            {
                hexaValue = /&#x([A-Fa-f0-9]+);/.exec(hexaUnicode)[1];
                s = s.replace(new RegExp((("\\&#x" + hexaValue) + ";"), "g"), String.fromCharCode(int(("0x" + hexaValue))));
            }
            for each (decimalUnicode in s.match(/&#[0-9]+;/g))
            {
                decimalValue = /&#([0-9]+);/.exec(decimalUnicode)[1];
                s = s.replace(new RegExp((("\\&#" + decimalValue) + ";"), "g"), String.fromCharCode(int(decimalValue)));
            }
            return (s);
        }
        public static function prepareXMLText(s:String):String
        {
            s = processSpecialXMLEntities(s);
            s = s.replace(/(?:[ ]+(\n|\r)+[ ]*)|(?:[ ]*(\n|\r)+[ ]+)/g, " ");
            s = s.replace(/\n|\r|\t/g, "");
            return (s);
        }
        public static function presentationStyleToStyleDeclaration(elt:XML, styleDeclaration:StyleDeclaration = null):StyleDeclaration
        {
            var styleName:String;
            if (styleDeclaration == null)
            {
                styleDeclaration = new StyleDeclaration();
            }
            for each (styleName in presentationStyles)
            {
                if ((("@" + styleName) in elt))
                {
                    styleDeclaration.setProperty(styleName, elt[("@" + styleName)]);
                }
            }
            return (styleDeclaration);
        }
        public static function flashRadialGradientMatrix(cx:Number, cy:Number, r:Number, fx:Number, fy:Number):Matrix
        {
            var d:Number = (r * 2);
            var mat:Matrix = new Matrix();
            mat.createGradientBox(d, d, 0, 0, 0);
            var a:Number = Math.atan2((fy - cy), (fx - cx));
            mat.translate(-(cx), -(cy));
            mat.rotate(-(a));
            mat.translate(cx, cy);
            mat.translate((cx - r), (cy - r));
            return (mat);
        }
        public static function flashLinearGradientMatrix(x1:Number, y1:Number, x2:Number, y2:Number):Matrix
        {
            var w:Number = (x2 - x1);
            var h:Number = (y2 - y1);
            var a:Number = Math.atan2(h, w);
            var vl:Number = Math.sqrt((Math.pow(w, 2) + Math.pow(h, 2)));
            var matr:Matrix = new Matrix();
            matr.createGradientBox(1, 1, 0, 0, 0);
            matr.rotate(a);
            matr.scale(vl, vl);
            matr.translate(x1, y1);
            return (matr);
        }
        public static function extractUrlId(url:String):String
        {
            var matches:Array = /url\s*\(#(.*?)\)/.exec(url);
            if (matches == null)
            {
                return (null);
            }
            return (matches[1]);
        }
        public static function getFontSize(s:String, currentFontSize:Number, viewPortWidth:Number, viewPortHeight:Number):Number
        {
            switch (s)
            {
                case "xx-small":
                    s = "6.94pt";
                    break;
                case "x-small":
                    s = "8.33pt";
                    break;
                case "small":
                    s = "10pt";
                    break;
                case "medium":
                    s = "12pt";
                    break;
                case "large":
                    s = "14.4pt";
                    break;
                case "x-large":
                    s = "17.28pt";
                    break;
                case "xx-large":
                    s = "20.736pt";
                    break;
            }
            return (getUserUnit(s, currentFontSize, viewPortWidth, viewPortHeight, FONT_SIZE));
        }
        public static function getUserUnit(s:String, referenceFontSize:Number, referenceWidth:Number, referenceHeight:Number, referenceMode:String):Number
        {
            var value:Number;
            if (s.indexOf("pt") != -1)
            {
                value = Number(StringUtil.remove(s, "pt"));
                return (value * 1.25);
            }
            if (s.indexOf("pc") != -1)
            {
                value = Number(StringUtil.remove(s, "pc"));
                return (value * 15);
            }
            if (s.indexOf("mm") != -1)
            {
                value = Number(StringUtil.remove(s, "mm"));
                return (value * 3.543307);
            }
            if (s.indexOf("cm") != -1)
            {
                value = Number(StringUtil.remove(s, "cm"));
                return (value * 35.43307);
            }
            if (s.indexOf("in") != -1)
            {
                value = Number(StringUtil.remove(s, "in"));
                return (value * 90);
            }
            if (s.indexOf("px") != -1)
            {
                value = Number(StringUtil.remove(s, "px"));
                return (value);
            }
            if (s.indexOf("em") != -1)
            {
                value = Number(StringUtil.remove(s, "em"));
                return (value * referenceFontSize);
            }
            if (s.indexOf("%") != -1)
            {
                value = Number(StringUtil.remove(s, "%"));
                switch (referenceMode)
                {
                    case WIDTH:
                        return ((value / 100) * referenceWidth);
                    case HEIGHT:
                        return ((value / 100) * referenceHeight);
                    case FONT_SIZE:
                        return ((value / 100) * referenceFontSize);
                    default:
                        return (((value / 100) * Math.sqrt((Math.pow(referenceWidth, 2) + Math.pow(referenceHeight, 2)))) / Math.sqrt(2));
                }
            }
            return (Number(s));
        }

    }
}
