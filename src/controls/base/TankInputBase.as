package controls.base
{
    import controls.TankInput;
    import flash.events.MouseEvent;
    import flash.ui.Mouse;
    import flash.ui.MouseCursor;
    import flash.text.TextFieldType;
    import utils.FontParamsUtil;

    public class TankInputBase extends TankInput
    {

        public function TankInputBase()
        {
            _label.sharpness = FontParamsUtil.SHARPNESS_LABEL_BASE;
            _label.thickness = FontParamsUtil.THICKNESS_TANK_INPUT_BASE;
            textField.sharpness = -250;
            textField.thickness = -250;
            textField.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
            textField.addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
        }
        private function onMouseOver(param1:MouseEvent):void
        {
            Mouse.cursor = MouseCursor.IBEAM;
        }
        private function onMouseOut(param1:MouseEvent):void
        {
            Mouse.cursor = MouseCursor.AUTO;
        }
        public function set enable(param1:Boolean):void
        {
            textField.type = ((!(!(param1))) ? TextFieldType.INPUT : TextFieldType.DYNAMIC);
            textField.selectable = param1;
            textField.mouseEnabled = param1;
            textField.mouseWheelEnabled = param1;
            textField.tabEnabled = param1;
        }
        override public function set x(param1:Number):void
        {
            super.x = int(param1);
        }
        override public function set y(param1:Number):void
        {
            super.y = int(param1);
        }
        override public function set width(param1:Number):void
        {
            super.width = Math.ceil(param1);
        }
        override public function set height(param1:Number):void
        {
            super.height = Math.ceil(param1);
        }

    }
}
