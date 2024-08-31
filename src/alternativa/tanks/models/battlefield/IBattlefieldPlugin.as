package alternativa.tanks.models.battlefield
{
    import alternativa.object.ClientObject;

    public interface IBattlefieldPlugin
    {

        function get battlefieldPluginName():String;
        function startBattle():void;
        function restartBattle():void;
        function finishBattle():void;
        function tick(_arg_1:int, _arg_2:int, _arg_3:Number, _arg_4:Number):void;
        function addUser(_arg_1:ClientObject):void;
        function removeUser(_arg_1:ClientObject):void;
        function addUserToField(_arg_1:ClientObject):void;
        function removeUserFromField(_arg_1:ClientObject):void;

    }
}
