﻿package controls
{
    import flash.display.Sprite;
    import flash.display.Shape;
    import flash.text.TextFormat;
    import flash.text.AntiAliasType;
    import flash.text.GridFitType;
    import flash.text.TextFieldType;
    import flash.text.TextFieldAutoSize;
    import flash.display.Graphics;
    import flash.geom.Matrix;
    import flash.display.GradientType;

    public class TextArea extends Sprite
    {

        private var _width:int;
        private var _height:int;

        private var shadow:Shape = new Shape();
        private var bg:TankWindowInner = new TankWindowInner(0);
        private const format:TextFormat = new TextFormat("MyriadPro", 12, 0xFFFFFF);
        public var tf:TextFieldUtf8 = new TextFieldUtf8();

        public function TextArea()
        {
            addChild(this.shadow);
            this.shadow.x = (this.shadow.y = 1);
            addChild(this.bg);
            addChild(this.tf);
            this.tf.defaultTextFormat = this.format;
            this.tf.antiAliasType = AntiAliasType.ADVANCED;
            this.tf.gridFitType = GridFitType.PIXEL;
            this.tf.embedFonts = true;
            this.tf.sharpness = -150;
            this.tf.thickness = -150;
            this.tf.x = (this.tf.y = 5);
            this.tf.multiline = true;
            this.tf.wordWrap = true;
            this.tf.type = TextFieldType.INPUT;
            this.tf.selectable = true;
            this.tf.autoSize = TextFieldAutoSize.NONE;
        }
        override public function set width(value:Number):void
        {
            this._width = int(value);
            this.bg.width = this._width;
            this.tf.width = (this._width - 10);
            this.draw();
        }
        override public function get width():Number
        {
            return (this._width);
        }
        override public function set height(value:Number):void
        {
            this._height = int(value);
            this.bg.height = this._height;
            this.tf.height = (this._height - 10);
            this.draw();
        }
        override public function get height():Number
        {
            return (this._height);
        }
        public function get text():String
        {
            return (this.tf.text);
        }
        public function set text(value:String):void
        {
            this.tf.text = value;
        }
        private function draw():void
        {
            var g:Graphics = this.shadow.graphics;
            var matrix:Matrix = new Matrix();
            matrix.createGradientBox((this._width - 2), (this._height - 2), (Math.PI * 0.5));
            g.clear();
            g.beginGradientFill(GradientType.LINEAR, [0, 0], [0.8, 0], [0, 0xFF], matrix);
            g.drawRect(0, 0, (this._width - 2), (this._height - 2));
            g.endFill();
        }
        public function set maxChars(value:int):void
        {
            this.tf.maxChars = value;
        }

    }
}
