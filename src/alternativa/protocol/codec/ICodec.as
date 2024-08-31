package alternativa.protocol.codec
{
    import flash.utils.IDataOutput;
    import flash.utils.IDataInput;

    public interface ICodec
    {

        function encode(_arg_1:IDataOutput, _arg_2:Object, _arg_3:NullMap, _arg_4:Boolean):void;
        function decode(_arg_1:IDataInput, _arg_2:NullMap, _arg_3:Boolean):Object;

    }
}
