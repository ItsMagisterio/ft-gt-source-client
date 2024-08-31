package com.lorentz.SVG.data.text
{
    public class SVGTextToDraw
    {

        public var text:String;
        public var parentFontSize:Number;
        public var fontSize:Number;
        public var fontFamily:String;
        public var fontWeight:String;
        public var fontStyle:String;
        public var baselineShift:String;
        public var color:uint = 0;
        public var letterSpacing:Number = 0;
        public var useEmbeddedFonts:Boolean;

        public function clone():SVGTextToDraw
        {
            var copy:SVGTextToDraw = new SVGTextToDraw();
            copy.text = this.text;
            copy.parentFontSize = this.parentFontSize;
            copy.fontSize = this.fontSize;
            copy.fontFamily = this.fontFamily;
            copy.fontWeight = this.fontWeight;
            copy.fontStyle = this.fontStyle;
            copy.baselineShift = this.baselineShift;
            copy.color = this.color;
            copy.letterSpacing = this.letterSpacing;
            copy.useEmbeddedFonts = this.useEmbeddedFonts;
            return (copy);
        }

    }
}
