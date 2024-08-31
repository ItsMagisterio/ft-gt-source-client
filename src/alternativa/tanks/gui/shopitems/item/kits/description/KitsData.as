package alternativa.tanks.gui.shopitems.item.kits.description
{
    import __AS3__.vec.Vector;
    import projects.tanks.client.panel.model.shop.kitpackage.KitPackageItemInfo;

    public class KitsData
    {

        public var info:Vector.<KitPackageItemInfo>;
        public var discount:int;

        public function KitsData(kitInfo:Vector.<KitPackageItemInfo>, sale:int)
        {
            this.info = kitInfo;
            this.discount = sale;
        }
    }
}
