package alternativa.protocol.codec
{
    import alternativa.protocol.factory.ICodecFactory;
    import alternativa.types.Long;
    import alternativa.protocol.type.Short;
    import alternativa.resource.ResourceInfo;
    import flash.utils.IDataInput;

    public class ResourceCodec extends AbstractCodec
    {

        private var codecFactory:ICodecFactory;

        public function ResourceCodec(codecFactory:ICodecFactory)
        {
            this.codecFactory = codecFactory;
        }
        override protected function doDecode(reader:IDataInput, nullmap:NullMap, notnull:Boolean):Object
        {
            var id:Long = Long(this.codecFactory.getCodec(Long).decode(reader, nullmap, true));
            var version:Long = Long(this.codecFactory.getCodec(Long).decode(reader, nullmap, true));
            var _local_6:int = int(this.codecFactory.getCodec(Short).decode(reader, nullmap, true));
            var isOptional:Boolean = Boolean(this.codecFactory.getCodec(Boolean).decode(reader, nullmap, true));
            return (new ResourceInfo(id, version, _local_6, isOptional));
        }

    }
}
