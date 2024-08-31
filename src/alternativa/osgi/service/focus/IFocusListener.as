package alternativa.osgi.service.focus
{
    public interface IFocusListener
    {

        function focusIn(_arg_1:Object):void;
        function focusOut(_arg_1:Object):void;
        function activate():void;
        function deactivate():void;

    }
}
