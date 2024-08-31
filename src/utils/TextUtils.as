// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// utils.TextUtils

package utils
{
    import flash.geom.Rectangle;
    import flash.text.TextFormat;
    import flash.display.BitmapData;
    import flash.display.Shape;
    import flash.geom.Matrix;
    import flash.display.BlendMode;
    import flash.text.TextField;

    public class TextUtils
    {

        public static function getTextInCells(tf:TextField, cellWidth:int, cellHeight:int, gridColor:uint = 0xCC00, gridAlpha:Number = 0.5, gridLinThickness:int = 1):BitmapData
        {
            var charRect:Rectangle;
            var shiftX:int;
            var shiftY:int;
            var format:TextFormat = tf.getTextFormat();
            var oldLetterSpacing:Object = format.letterSpacing;
            format.letterSpacing = 4;
            tf.setTextFormat(format);
            var length:int = tf.text.length;
            var bd:BitmapData = new BitmapData((cellWidth * length), cellHeight, true, 0xFFFFFF);
            var grid:Shape = new Shape();
            grid.graphics.lineStyle(gridLinThickness, gridColor, gridAlpha);
            grid.graphics.drawRect(0, 0, ((length * cellWidth) - gridLinThickness), (cellHeight - gridLinThickness));
            var i:int = 1;
            while (i < length)
            {
                grid.graphics.moveTo((i * cellWidth), 0);
                grid.graphics.lineTo((i * cellWidth), cellHeight);
                i++;
            }
            bd.draw(grid);
            var m:Matrix = new Matrix();
            i = 0;
            while (i < length)
            {
                charRect = tf.getCharBoundaries(i);
                charRect.width = (charRect.width - 4);
                shiftX = Math.round(((cellWidth - charRect.width) * 0.5));
                shiftY = Math.round(((cellHeight - charRect.height) * 0.5));
                m.tx = ((-(charRect.x) + (i * cellWidth)) + shiftX);
                m.ty = (-(charRect.y) + shiftY);
                bd.draw(tf, m, null, BlendMode.NORMAL, new Rectangle(((i * cellWidth) + shiftX), (charRect.y + shiftY), (charRect.width + 1), charRect.height), true);
                i++;
            }
            format.letterSpacing = oldLetterSpacing;
            tf.setTextFormat(format);
            return (bd);
        }

        public static function getIntByAlphabet(str:String):int
        {
            str = str.toUpperCase();

            if (str.length == 1)
            {
                var charCode:int = str.charCodeAt(0);
                if (charCode >= 65 && charCode <= 90)
                {
                    return charCode - 65;
                }
                else
                {
                    return 0;
                }
            }
            else
            {
                return 0;
            }
        }

        public static function getAlphabetByInt(value:int):String
        {
            if (value >= 0 && value <= 25)
            {
                return String.fromCharCode(value + 65);
            }
            else
            {
                return "A";
            }
        }

    }
} // package utils