package alternativa.model
{
    import alternativa.object.ClientObject;
    import alternativa.protocol.factory.ICodecFactory;
    import flash.utils.IDataInput;
    import alternativa.protocol.codec.NullMap;
    import __AS3__.vec.Vector;

    public interface IModel
    {

        function _initObject(_arg_1:ClientObject, _arg_2:Object):void;
        function invoke(_arg_1:ClientObject, _arg_2:String, _arg_3:ICodecFactory, _arg_4:IDataInput, _arg_5:NullMap):void;
        function get id():String;
        function get interfaces():Vector.<Class>;

    }
}
