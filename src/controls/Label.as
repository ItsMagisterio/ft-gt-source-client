package controls
{
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.AntiAliasType;
    import flash.text.GridFitType;
    import flash.text.TextFieldAutoSize;
    import utils.FontParamsUtil;

    public class Label extends TextField
    {

        private var format:TextFormat;

        public function Label(param1:String = "MyriadPro")
        {
            this.format = new TextFormat(param1);
            this.format.color = 0xFFFFFF;
            this.selectable = false;
            this.embedFonts = true;
            this.antiAliasType = AntiAliasType.ADVANCED;
            this.gridFitType = GridFitType.SUBPIXEL;
            this.sharpness = FontParamsUtil.SHARPNESS_LABEL_BASE;
            this.thickness = FontParamsUtil.THICKNESS_LABEL_BASE;
            this.width = 10;
            this.height = 12;
            this.autoSize = TextFieldAutoSize.LEFT;
            this.defaultTextFormat = this.format;
            this.size = 12;
        }
        private function updateformat():void
        {
            this.defaultTextFormat = this.format;
            this.setTextFormat(this.format);
        }
        public function set size(_arg_1:Number):void
        {
            this.format.size = _arg_1;
            this.updateformat();
        }
        public function set bold(_arg_1:Boolean):void
        {
            this.format.bold = _arg_1;
            if (_arg_1)
            {
                this.thickness *= 2;
                this.sharpness = -50;
            }
            this.updateformat();
        }
        public function set color(_arg_1:uint):void
        {
            this.format.color = _arg_1;
            this.updateformat();
        }
        public function set align(_arg_1:String):void
        {
            this.format.align = _arg_1;
            this.updateformat();
        }

    }
}
