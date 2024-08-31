package alternativa.resource
{
    import alternativa.types.LongFactory;
    import alternativa.types.Long;

    public class ResourceWrapper implements IResource
    {

        private var library:Object;

        public function ResourceWrapper(library:Object)
        {
            this.library = library;
        }
        public function load(url:String):void
        {
            this.library.load(url);
        }
        public function unload():void
        {
            this.library.unload();
        }
        public function get name():String
        {
            return (this.library.name);
        }
        public function get id():Long
        {
            return (LongFactory.getLong(0, this.library.id));
        }
        public function set id(value:Long):void
        {
            this.library.id = value.low;
        }
        public function set version(value:int):void
        {
            this.library.version = value;
        }
        public function get version():int
        {
            return (this.library.version);
        }
        public function close():void
        {
        }

    }
}
