package controls
{
    import flash.text.TextField;
    import flash.system.Capabilities;
    import flash.events.TextEvent;
    import flash.events.KeyboardEvent;
    import flash.events.Event;

    public class TextFieldUtf8 extends TextField
    {

        private static const NOTHING:int = -1;
        private static const INVALID:int = -2;

        private var character:int = 0;
        private var bits_left:int = 0;
        private var utf32_char:int = -1;

        public function TextFieldUtf8()
        {
            if (((Boolean((!(Capabilities.os.search("Linux") == -1)))) && (!(Capabilities.playerType == "StandAlone"))))
            {
                addEventListener(TextEvent.TEXT_INPUT, this.textInputHandler, false, 1);
                addEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler, false, 1);
            }
        }
        private function utf8Decode(_arg_1:int):int
        {
            if (this.bits_left == 0)
            {
                if ((_arg_1 & 0x80) == 0)
                {
                    return (_arg_1 & 0x7F);
                }
                if ((_arg_1 & 0xE0) == 192)
                {
                    this.character = ((_arg_1 & 0x1F) << 6);
                    this.bits_left = 6;
                }
                else
                {
                    if ((_arg_1 & 0xF0) == 224)
                    {
                        this.character = ((_arg_1 & 0x0F) << 12);
                        this.bits_left = 12;
                    }
                    else
                    {
                        if ((_arg_1 & 0xF8) == 240)
                        {
                            this.character = ((_arg_1 & 0x07) << 18);
                            this.bits_left = 18;
                        }
                        else
                        {
                            if ((_arg_1 & 0xFC) == 248)
                            {
                                this.character = ((_arg_1 & 0x03) << 24);
                                this.bits_left = 24;
                            }
                            else
                            {
                                if ((_arg_1 & 0xFE) == 252)
                                {
                                    this.character = ((_arg_1 & 0x01) << 30);
                                    this.bits_left = 30;
                                }
                                else
                                {
                                    return (INVALID);
                                }
                            }
                        }
                    }
                }
                return (NOTHING);
            }
            if ((_arg_1 & 0xC0) != 128)
            {
                return (INVALID);
            }
            this.bits_left = (this.bits_left - 6);
            this.character = (this.character | ((_arg_1 & 0x3F) << this.bits_left));
            if (this.bits_left == 0)
            {
                return (this.character);
            }
            if (this.bits_left > 30)
            {
                this.bits_left = 0;
                return (INVALID);
            }
            return (NOTHING);
        }
        private function keyDownHandler(_arg_1:KeyboardEvent):void
        {
            this.utf32_char = this.utf8Decode(_arg_1.charCode);
        }
        private function textInputHandler(_arg_1:TextEvent):void
        {
            var _local_2:String;
            var _local_3:String;
            var _local_4:int;
            if (((this.utf32_char == 10) && (!(this.multiline))))
            {
                _arg_1.preventDefault();
                _arg_1.stopImmediatePropagation();
                return;
            }
            if (_arg_1.text.length == 1)
            {
                if (((!(this.utf32_char == NOTHING)) && (!(this.utf32_char == INVALID))))
                {
                    if (this.selectionBeginIndex == this.selectionEndIndex)
                    {
                        _local_2 = this.text.substr(0, this.caretIndex);
                        _local_3 = this.text.substr(this.caretIndex);
                        _local_4 = (this.caretIndex + 1);
                    }
                    else
                    {
                        _local_2 = this.text.substr(0, this.selectionBeginIndex);
                        _local_3 = this.text.substr(this.selectionEndIndex);
                        _local_4 = (this.selectionBeginIndex + 1);
                    }
                    _arg_1.text = (this.text = ((_local_2 + String.fromCharCode(this.utf32_char)) + _local_3));
                    this.setSelection(_local_4, _local_4);
                    this.dispatchEvent(new Event(Event.CHANGE));
                }
                else
                {
                    _arg_1.stopImmediatePropagation();
                }
                _arg_1.preventDefault();
            }
        }

    }
}
