package alternativa.protocol
{
    import alternativa.protocol.factory.ICodecFactory;
    import alternativa.protocol.codec.ICodec;
    import alternativa.protocol.codec.NullMap;
    import flash.utils.ByteArray;
    import flash.utils.IDataOutput;
    import alternativa.osgi.service.console.IConsoleService;
    import alternativa.init.ProtocolActivator;
    import flash.utils.IDataInput;

    public class Protocol
    {

        private static const INPLACE_MASK_FLAG:int = 128;
        private static const MASK_LENGTH_2_BYTES_FLAG:int = 64;
        private static const INPLACE_MASK_1_BYTES:int = 32;
        private static const INPLACE_MASK_3_BYTES:int = 96;
        private static const INPLACE_MASK_2_BYTES:int = 64;
        private static const MASK_LENGTH_1_BYTE:int = 128;
        private static const MASK_LEGTH_3_BYTE:int = 0xC00000;

        private var codecFactory:ICodecFactory;
        private var rootTargetClass:Class;

        public function Protocol(codecFactory:ICodecFactory, rootTargetClass:Class)
        {
            this.codecFactory = codecFactory;
            this.rootTargetClass = rootTargetClass;
        }
        public function encode(dest:IDataOutput, object:Object):void
        {
            var codec:ICodec = this.codecFactory.getCodec(this.rootTargetClass);
            var nullMap:NullMap = new NullMap();
            var dataWriter:ByteArray = new ByteArray();
            codec.encode(IDataOutput(dataWriter), object, nullMap, true);
            var nullmapEncoded:ByteArray = this.encodeNullMap(nullMap);
            dataWriter.position = 0;
            nullmapEncoded.position = 0;
            dest.writeBytes(nullmapEncoded, 0, nullmapEncoded.length);
            dest.writeBytes(dataWriter, 0, dataWriter.length);
        }
        public function decode(reader:IDataInput):Object
        {
            var b:String;
            var codec:ICodec = this.codecFactory.getCodec(this.rootTargetClass);
            var nullMap:NullMap = this.decodeNullMap(reader);
            IConsoleService(ProtocolActivator.osgi.getService(IConsoleService)).writeToConsoleChannel("PROTOCOL", "Protocol decode nullMap:");
            var map:ByteArray = nullMap.getMap();
            map.position = 0;
            var mapString:String = "";
            while (map.bytesAvailable)
            {
                b = map.readUnsignedByte().toString(2);
                while (b.length < 8)
                {
                    b = (0 + b);
                }
                mapString = (mapString + (b + " "));
            }
            IConsoleService(ProtocolActivator.osgi.getService(IConsoleService)).writeToConsoleChannel("PROTOCOL", ("   " + mapString));
            IConsoleService(ProtocolActivator.osgi.getService(IConsoleService)).writeToConsoleChannel("PROTOCOL", " ");
            map.position = 0;
            nullMap.reset();
            return (codec.decode(reader, nullMap, true));
        }
        private function encodeNullMap(nullMap:NullMap):ByteArray
        {
            var sizeInBytes:int;
            var firstByte:int;
            var sizeEncoded:int;
            var secondByte:int;
            var thirdByte:int;
            var nullMapSize:int = nullMap.getSize();
            var map:ByteArray = nullMap.getMap();
            var res:ByteArray = new ByteArray();
            if (nullMapSize <= 5)
            {
                res.writeByte(int(((map[0] & 0xFF) >>> 3)));
                return (res);
            }
            if (nullMapSize <= 13)
            {
                res.writeByte(int((((map[0] & 0xFF) >>> 3) + INPLACE_MASK_1_BYTES)));
                res.writeByte((((map[1] & 0xFF) >>> 3) + (map[0] << 5)));
                return (res);
            }
            if (nullMapSize <= 21)
            {
                res.writeByte(int((((map[0] & 0xFF) >>> 3) + INPLACE_MASK_2_BYTES)));
                res.writeByte(int((((map[1] & 0xFF) >>> 3) + (map[0] << 5))));
                res.writeByte(int((((map[2] & 0xFF) >>> 3) + (map[1] << 5))));
                return (res);
            }
            if (nullMapSize <= 29)
            {
                res.writeByte(int((((map[0] & 0xFF) >>> 3) + INPLACE_MASK_3_BYTES)));
                res.writeByte(int((((map[1] & 0xFF) >>> 3) + (map[0] << 5))));
                res.writeByte(int((((map[2] & 0xFF) >>> 3) + (map[1] << 5))));
                res.writeByte(int((((map[3] & 0xFF) >>> 3) + (map[2] << 5))));
                return (res);
            }
            if (nullMapSize <= 504)
            {
                sizeInBytes = ((nullMapSize >>> 3) + (((nullMapSize & 0x07) == 0) ? 0 : 1));
                firstByte = int(((sizeInBytes & 0xFF) + MASK_LENGTH_1_BYTE));
                res.writeByte(firstByte);
                res.writeBytes(map, 0, sizeInBytes);
                return (res);
            }
            if (nullMapSize <= 0x2000000)
            {
                sizeInBytes = ((nullMapSize >>> 3) + (((nullMapSize & 0x07) == 0) ? 0 : 1));
                sizeEncoded = (sizeInBytes + MASK_LEGTH_3_BYTE);
                firstByte = int(((sizeEncoded & 0xFF0000) >>> 16));
                secondByte = int(((sizeEncoded & 0xFF00) >>> 8));
                thirdByte = int((sizeEncoded & 0xFF));
                res.writeByte(firstByte);
                res.writeByte(secondByte);
                res.writeByte(thirdByte);
                res.writeBytes(map, 0, sizeInBytes);
                return (res);
            }
            throw (new Error("NullMap overflow"));
        }
        private function decodeNullMap(reader:IDataInput):NullMap
        {
            var maskLength:int;
            var firstByteValue:int;
            var isLength22bit:Boolean;
            var sizeInBits:int;
            var secondByte:int;
            var thirdByte:int;
            var fourthByte:int;
            var mask:ByteArray = new ByteArray();
            var firstByte:int = reader.readByte();
            var isLongNullMap:Boolean = (!((firstByte & INPLACE_MASK_FLAG) == 0));
            if (isLongNullMap)
            {
                firstByteValue = (firstByte & 0x3F);
                isLength22bit = (!((firstByte & MASK_LENGTH_2_BYTES_FLAG) == 0));
                if (isLength22bit)
                {
                    secondByte = reader.readByte();
                    thirdByte = reader.readByte();
                    maskLength = (((firstByteValue << 16) + ((secondByte & 0xFF) << 8)) + (thirdByte & 0xFF));
                }
                else
                {
                    maskLength = firstByteValue;
                }
                reader.readBytes(mask, 0, maskLength);
                sizeInBits = (maskLength << 3);
                return (new NullMap(sizeInBits, mask));
            }
            firstByteValue = int((firstByte << 3));
            maskLength = int(((firstByte & 0x60) >> 5));
            switch (maskLength)
            {
                case 0:
                    mask.writeByte(firstByteValue);
                    return (new NullMap(5, mask));
                case 1:
                    secondByte = reader.readByte();
                    mask.writeByte(int((firstByteValue + ((secondByte & 0xFF) >>> 5))));
                    mask.writeByte(int((secondByte << 3)));
                    return (new NullMap(13, mask));
                case 2:
                    secondByte = reader.readByte();
                    thirdByte = reader.readByte();
                    mask.writeByte(int((firstByteValue + ((secondByte & 0xFF) >>> 5))));
                    mask.writeByte(int(((secondByte << 3) + ((thirdByte & 0xFF) >>> 5))));
                    mask.writeByte(int((thirdByte << 3)));
                    return (new NullMap(21, mask));
                case 3:
                    secondByte = reader.readByte();
                    thirdByte = reader.readByte();
                    fourthByte = reader.readByte();
                    mask.writeByte(int((firstByteValue + ((secondByte & 0xFF) >>> 5))));
                    mask.writeByte(int(((secondByte << 3) + ((thirdByte & 0xFF) >>> 5))));
                    mask.writeByte(int(((thirdByte << 3) + ((fourthByte & 0xFF) >>> 5))));
                    mask.writeByte(int((fourthByte << 3)));
                    return (new NullMap(29, mask));
                default:
                    return (null);
            }
        }

    }
}
