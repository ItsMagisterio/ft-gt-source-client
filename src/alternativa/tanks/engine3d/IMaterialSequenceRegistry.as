package alternativa.tanks.engine3d
{
    import flash.display.BitmapData;

    public interface IMaterialSequenceRegistry
    {

        function set timerInterval(_arg_1:int):void;
        function get useMipMapping():Boolean;
        function set useMipMapping(_arg_1:Boolean):void;
        function getSequence(_arg_1:MaterialType, _arg_2:BitmapData, _arg_3:int, _arg_4:Number, _arg_5:Boolean = false, _arg_6:Boolean = false):MaterialSequence;
        function getSquareSequence(_arg_1:MaterialType, _arg_2:BitmapData, _arg_3:Number, _arg_4:Boolean = false, _arg_5:Boolean = false):MaterialSequence;
        function clear():void;
        function getDump():String;
        function disposeSequence(_arg_1:MaterialSequence):void;

    }
}
