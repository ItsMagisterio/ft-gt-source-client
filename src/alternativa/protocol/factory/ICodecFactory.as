package alternativa.protocol.factory
{
    import alternativa.protocol.codec.ICodec;

    public interface ICodecFactory
    {

        function registerCodec(_arg_1:Class, _arg_2:ICodec):void;
        function unregisterCodec(_arg_1:Class):void;
        function getCodec(_arg_1:Class):ICodec;
        function getArrayCodec(_arg_1:Class, _arg_2:Boolean = true, _arg_3:int = 1):ICodec;

    }
}
