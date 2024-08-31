package alternativa.protocol.codec
{
    import alternativa.protocol.factory.ICodecFactory;
    import flash.utils.IDataInput;
    import flash.utils.ByteArray;
    import alternativa.network.command.SpaceCommand;
    import alternativa.protocol.type.Byte;
    import alternativa.types.Long;
    import flash.utils.IDataOutput;

    public class SpaceRootCodec extends AbstractCodec
    {

        private var codecFactory:ICodecFactory;

        public function SpaceRootCodec(codecFactory:ICodecFactory)
        {
            this.codecFactory = codecFactory;
        }
        override protected function doDecode(reader:IDataInput, nullmap:NullMap, notnull:Boolean):Object
        {
            return (new Array(reader, nullmap));
        }
        override protected function doEncode(dest:IDataOutput, object:Object, nullmap:NullMap, notnull:Boolean):void
        {
            var hash:ByteArray;
            var byteCodec:ICodec;
            var i:int;
            var c:SpaceCommand;
            var longCodec:ICodec;
            var data:ByteArray;
            if ((object is ByteArray))
            {
                hash = (object as ByteArray);
                byteCodec = this.codecFactory.getCodec(Byte);
                byteCodec.encode(dest, int(0), nullmap, true);
                hash.position = 0;
                i = 0;
                while (i < 32)
                {
                    byteCodec.encode(dest, hash.readByte(), nullmap, true);
                    i++;
                }
            }
            else
            {
                if ((object is SpaceCommand))
                {
                    c = SpaceCommand(object);
                    longCodec = this.codecFactory.getCodec(Long);
                    longCodec.encode(dest, c.objectId, nullmap, true);
                    longCodec.encode(dest, c.methodId, nullmap, true);
                    data = ByteArray(c.params);
                    dest.writeBytes(data, 0, data.bytesAvailable);
                    c.nullMap.reset();
                    i = 0;
                    while (i < c.nullMap.getSize())
                    {
                        nullmap.addBit(c.nullMap.getNextBit());
                        i++;
                    }
                }
                else
                {
                    dest.writeByte(int(object));
                }
            }
        }

    }
}
