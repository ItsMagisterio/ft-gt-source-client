package alternativa.debug.dump
{
    import alternativa.osgi.service.dump.dumper.IDumper;
    import alternativa.service.IResourceService;
    import alternativa.types.Long;
    import alternativa.resource.ResourceStatus;
    import __AS3__.vec.Vector;
    import alternativa.resource.IResource;
    import alternativa.init.Main;
    import alternativa.resource.ImageResource;

    public class ResourceDumper implements IDumper
    {

        public function dump(params:Vector.<String>):String
        {
            var resourceRegister:IResourceService;
            var p:String;
            var batchLoadingHistory:Array;
            var i:int;
            var batchId:int;
            var resourcesList:Array;
            var j:int;
            var resourceId:Long;
            var resourceStatus:ResourceStatus;
            var s:String;
            var resources:Vector.<IResource>;
            var result:String = "\n";
            resourceRegister = (Main.osgi.getService(IResourceService) as IResourceService);
            if (params.length > 0)
            {
                p = params[0];
                switch (p)
                {
                    case "status":
                        batchLoadingHistory = resourceRegister.batchLoadingHistory;
                        i = 0;
                        while (i < batchLoadingHistory.length)
                        {
                            batchId = (batchLoadingHistory[i] as int);
                            result = (result + (("\n\n      BatchID: " + batchId) + "\n"));
                            resourcesList = resourceRegister.resourceLoadingHistory[batchId];
                            j = 0;
                            while (j < resourcesList.length)
                            {
                                resourceId = resourcesList[j];
                                resourceStatus = (resourceRegister.resourceStatus[batchId][resourceId] as ResourceStatus);
                                s = ((((("\nid: " + resourceId) + "  ") + resourceStatus.typeName) + " ") + resourceStatus.name);
                                s = (s + (" status: " + resourceStatus.status));
                                result = (result + s);
                                j++;
                            }
                            i++;
                        }
                        break;
                    case "images":
                        return (this.getImageResourcesDump());
                }
            }
            else
            {
                resources = resourceRegister.resourcesList;
                i = 0;
                while (i < resources.length)
                {
                    result = (result + (((("   resource id: " + IResource(resources[i]).id) + "  ") + IResource(resources[i]).name) + "\n"));
                    i++;
                }
                result = (result + "\n");
            }
            return (result);
        }
        private function getImageResourcesDump():String
        {
            var s:String;
            var count:int;
            var totalSize:int;
            var resource:ImageResource;
            var size:int;
            var resourceRegister:IResourceService = IResourceService(Main.osgi.getService(IResourceService));
            var resources:Vector.<IResource> = resourceRegister.resourcesList;
            var i:int;
            while (i < resources.length)
            {
                resource = (resources[i] as ImageResource);
                if (((!(resource == null)) && (!(resource.data == null))))
                {
                    count++;
                    size = ((resource.data.width * resource.data.height) * 4);
                    s = (s + (((("Image " + count) + ": size = ") + size) + "\n"));
                    totalSize = (totalSize + size);
                }
                i++;
            }
            s = (s + (("Total size: " + totalSize) + "\n"));
            return (s);
        }
        public function get dumperName():String
        {
            return ("resource");
        }

    }
}
