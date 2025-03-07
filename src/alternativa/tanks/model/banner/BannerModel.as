﻿package alternativa.tanks.model.banner
{
    import projects.tanks.client.banners.BannerModelBase;
    import projects.tanks.client.banners.IBannerModelBase;
    import flash.utils.Dictionary;
    import alternativa.model.IModel;
    import alternativa.init.Main;
    import alternativa.service.IResourceService;
    import alternativa.resource.ImageResource;
    import alternativa.object.ClientObject;
    import alternativa.types.Long;
    import flash.display.BitmapData;

    public class BannerModel extends BannerModelBase implements IBannerModelBase, IBanner
    {

        private var bd:Dictionary;
        private var url:Dictionary;

        public function BannerModel()
        {
            _interfaces.push(IModel, IBannerModelBase, IBanner);
            this.bd = new Dictionary();
            this.url = new Dictionary();
        }
        public function initObject(clientObject:ClientObject, resourceID:Long, url:String):void
        {
            Main.writeVarsToConsoleChannel("BannerModel", "initObject resourceID: %1, url: %2", resourceID, url);
            this.url[clientObject] = url;
            var resource:ImageResource = ((Main.osgi.getService(IResourceService) as IResourceService).getResource(resourceID) as ImageResource);
            this.bd[clientObject] = resource.data;
        }
        public function getBannerBd(bannerObject:ClientObject):BitmapData
        {
            return (this.bd[bannerObject]);
        }
        public function getBannerURL(bannerObject:ClientObject):String
        {
            return (this.url[bannerObject]);
        }
        public function click(bannerObject:ClientObject):void
        {
            Main.writeVarsToConsoleChannel("BannerModel", "click   bannerObjectId: %1", bannerObject.id);
        }

    }
}
