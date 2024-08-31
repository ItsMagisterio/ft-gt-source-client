package alternativa.protocol.codec.primitive
{
    import alternativa.protocol.codec.AbstractCodec;
    import alternativa.types.LongFactory;
    import flash.utils.IDataInput;
    import alternativa.protocol.codec.NullMap;
    import alternativa.types.Long;
    import flash.utils.IDataOutput;

    public class LongCodec extends AbstractCodec
    {

        override protected function doDecode(reader:IDataInput, nullmap:NullMap, notnull:Boolean):Object
        {
            return (LongFactory.getLong(reader.readInt(), reader.readInt()));
        }
        override protected function doEncode(dest:IDataOutput, object:Object, nullmap:NullMap, notnull:Boolean):void
        {
            dest.writeInt(Long(object).high);
            dest.writeInt(Long(object).low);
        }

    }
}
