package alternativa.osgi.service.storage
{
    import flash.net.SharedObject;

    public class StorageService implements IStorageService
    {

        private var storage:SharedObject;

        public function StorageService(sharedObject:SharedObject)
        {
            this.storage = sharedObject;
        }
        public function getStorage():SharedObject
        {
            return (this.storage);
        }

    }
}
