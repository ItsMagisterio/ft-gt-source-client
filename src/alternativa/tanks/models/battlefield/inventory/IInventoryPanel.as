package alternativa.tanks.models.battlefield.inventory
{
    public interface IInventoryPanel
    {

        function assignItemToSlot(_arg_1:InventoryItem, _arg_2:int):void;
        function itemActivated(_arg_1:InventoryItem):void;

    }
}
