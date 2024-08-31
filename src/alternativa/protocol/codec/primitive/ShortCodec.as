package alternativa.protocol.codec.primitive
{
    import alternativa.protocol.codec.AbstractCodec;
    import flash.utils.IDataInput;
    import alternativa.protocol.codec.NullMap;
    import flash.utils.IDataOutput;

    public class ShortCodec extends AbstractCodec
    {

        public function ShortCodec()
        {
            nullValue = int.MIN_VALUE;
        }
        override protected function doDecode(reader:IDataInput, nullmap:NullMap, notnull:Boolean):Object
        {
            return (reader.readShort());
        }
        override protected function doEncode(dest:IDataOutput, object:Object, nullmap:NullMap, notnull:Boolean):void
        {
            dest.writeShort(int(object));
        }

    }
}
