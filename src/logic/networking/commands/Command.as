// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// scpacker.networking.commands.Command

package logic.networking.commands
{
    public class Command
    {

        public var type:Type;
        public var args:Array;
        public var src:String;

        public function Command(_arg_1:Type, args:Array, src:String = null)
        {
            this.type = _arg_1;
            this.args = args;
            this.src = src;
        }
    }
} // package scpacker.networking.commands