﻿package alternativa.protocol.codec.primitive
{
    import alternativa.protocol.codec.AbstractCodec;
    import flash.utils.IDataInput;
    import alternativa.protocol.codec.NullMap;
    import flash.utils.IDataOutput;

    public class IntegerCodec extends AbstractCodec
    {

        public function IntegerCodec()
        {
            nullValue = int.MIN_VALUE;
        }
        override protected function doDecode(reader:IDataInput, nullmap:NullMap, notnull:Boolean):Object
        {
            return (reader.readInt());
        }
        override protected function doEncode(dest:IDataOutput, object:Object, nullmap:NullMap, notnull:Boolean):void
        {
            dest.writeInt(int(object));
        }

    }
}
