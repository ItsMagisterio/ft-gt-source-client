package alternativa.service
{
    import alternativa.model.IModel;
    import alternativa.object.ClientObject;
    import flash.utils.IDataInput;
    import alternativa.protocol.codec.NullMap;
    import __AS3__.vec.Vector;

    public interface IModelService
    {

        function register(_arg_1:String, _arg_2:String):void;
        function add(_arg_1:IModel):void;
        function remove(_arg_1:String):void;
        function registerModelsParamsStruct(_arg_1:String, _arg_2:Class):void;
        function getModelsParamsStruct(_arg_1:String):Class;
        function invoke(_arg_1:ClientObject, _arg_2:String, _arg_3:IDataInput, _arg_4:NullMap):void;
        function getModel(_arg_1:String):IModel;
        function getModelsByInterface(_arg_1:Class):Vector.<IModel>;
        function getModelForObject(_arg_1:ClientObject, _arg_2:Class):IModel;
        function getModelsForObject(_arg_1:ClientObject, _arg_2:Class):Vector.<IModel>;
        function getInterfacesForModel(_arg_1:String):Vector.<Class>;
        function get modelsList():Vector.<IModel>;

    }
}
