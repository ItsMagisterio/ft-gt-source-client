package alternativa.osgi.service.focus
{
    import flash.display.DisplayObject;

    public interface IFocusService
    {

        function addFocusListener(_arg_1:IFocusListener):void;
        function removeFocusListener(_arg_1:IFocusListener):void;
        function getFocus():Object;
        function clearFocus(_arg_1:DisplayObject):void;

    }
}
