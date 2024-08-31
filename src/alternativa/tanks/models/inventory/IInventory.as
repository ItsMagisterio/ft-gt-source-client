package alternativa.tanks.models.inventory
{
    public interface IInventory
    {

        function lockItem(_arg_1:int, _arg_2:int, _arg_3:Boolean):void;
        function lockItems(_arg_1:int, _arg_2:Boolean):void;

    }
}
