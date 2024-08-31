package alternativa.utils
{
    import flash.display.Sprite;
    import flash.utils.Dictionary;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;

    public class DebugPanel extends Sprite
    {

        private var values:Dictionary;
        private var count:int;

        public function DebugPanel()
        {
            this.values = new Dictionary();
            mouseEnabled = false;
            tabEnabled = false;
            mouseChildren = false;
            tabChildren = false;
        }
        public function printValue(valueName:String, ...args):void
        {
            var textField:TextField = this.values[valueName];
            if (textField == null)
            {
                textField = this.createTextField();
                this.values[valueName] = textField;
            }
            textField.text = ((valueName + ": ") + args.join(" "));
        }
        public function printText(text:String):void
        {
            this.createTextField().text = text;
        }
        private function createTextField():TextField
        {
            var textField:TextField;
            textField = new TextField();
            textField.autoSize = TextFieldAutoSize.LEFT;
            addChild(textField);
            textField.defaultTextFormat = new TextFormat("Tahoma", 11, 0xFFFFFF);
            textField.y = (this.count * 20);
            this.count++;
            return (textField);
        }

    }
}
