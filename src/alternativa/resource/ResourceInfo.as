package alternativa.resource
{
    import alternativa.types.Long;

    public class ResourceInfo
    {

        public var id:Long;
        public var version:Long;
        public var type:int;
        public var isOptional:Boolean;

        public function ResourceInfo(id:Long, version:Long, _arg_3:int, isOptional:Boolean)
        {
            this.id = id;
            this.version = version;
            this.type = _arg_3;
            this.isOptional = isOptional;
        }
    }
}
