package alternativa.protocol
{
    import flash.utils.ByteArray;
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;
    import alternativa.osgi.service.console.IConsoleService;
    import alternativa.init.ProtocolActivator;

    public class Packet
    {

        private static const ZIP_PACKET_SIZE_DELIMITER:int = 2000;
        private static const MAXIMUM_DATA_LENGTH:int = 2147483647;
        private static const LONG_SIZE_DELIMITER:int = 0x4000;
        private static const ZIPPED_FLAG:int = int(64);
        private static const LENGTH_FLAG:int = int(128);

        private function wrap(src:IDataInput, dst:IDataOutput, zipped:Boolean):void
        {
            var sizeToWrite:int;
            var hiByte:int;
            var loByte:int;
            var toWrap:ByteArray = new ByteArray();
            while (src.bytesAvailable)
            {
                toWrap.writeByte(src.readByte());
            }
            toWrap.position = 0;
            var longSize:Boolean = this.isLongSize(toWrap);
            if (((!(zipped)) && (longSize)))
            {
                zipped = true;
            }
            if (zipped)
            {
                toWrap.compress();
            }
            var length:int = toWrap.length;
            if (length > MAXIMUM_DATA_LENGTH)
            {
                throw (new Error((("Packet size too big(" + length) + ")")));
            }
            if (longSize)
            {
                sizeToWrite = (length + (LENGTH_FLAG << 24));
                dst.writeInt(sizeToWrite);
            }
            else
            {
                hiByte = int((((length & 0xFF00) >> 8) + ((!(!(zipped))) ? ZIPPED_FLAG : 0)));
                loByte = int((length & 0xFF));
                dst.writeByte(hiByte);
                dst.writeByte(loByte);
            }
            dst.writeBytes(toWrap, 0, length);
        }
        public function wrapPacket(src:IDataInput, dst:IDataOutput):void
        {
            this.wrap(src, dst, this.determineZipped(src));
        }
        public function wrapZippedPacket(src:IDataInput, dst:IDataOutput):void
        {
            this.wrap(src, dst, true);
        }
        public function wrapUnzippedPacket(src:IDataInput, dst:IDataOutput):void
        {
            this.wrap(src, dst, false);
        }
        public function unwrapPacket(src:IDataInput, dst:IDataOutput):Boolean
        {
            var flagByte:int;
            var longSize:Boolean;
            var isZipped:Boolean;
            var packetSize:int;
            var readPacket:Boolean;
            var hiByte:int;
            var middleByte:int;
            var loByte:int;
            var loByte2:int;
            var toUnwrap:ByteArray;
            var i:int;
            var console:IConsoleService;
            var s:String;
            var b:String;
            var result:Boolean;
            if (src.bytesAvailable >= 2)
            {
                flagByte = src.readByte();
                longSize = (!((flagByte & LENGTH_FLAG) == 0));
                readPacket = true;
                if (src.bytesAvailable >= 1)
                {
                    if (longSize)
                    {
                        if (src.bytesAvailable >= 3)
                        {
                            isZipped = true;
                            hiByte = ((flagByte ^ LENGTH_FLAG) << 24);
                            middleByte = ((src.readByte() & 0xFF) << 16);
                            loByte = ((src.readByte() & 0xFF) << 8);
                            loByte2 = (src.readByte() & 0xFF);
                            packetSize = (((hiByte + middleByte) + loByte) + loByte2);
                        }
                        else
                        {
                            readPacket = false;
                        }
                    }
                    else
                    {
                        isZipped = (!((flagByte & ZIPPED_FLAG) == 0));
                        hiByte = ((flagByte & 0x3F) << 8);
                        loByte = (src.readByte() & 0xFF);
                        packetSize = (hiByte + loByte);
                    }
                    if (src.bytesAvailable < packetSize)
                    {
                        readPacket = false;
                    }
                    if (readPacket)
                    {
                        toUnwrap = new ByteArray();
                        i = 0;
                        while (i < packetSize)
                        {
                            toUnwrap.writeByte(src.readByte());
                            i++;
                        }
                        if (isZipped)
                        {
                            toUnwrap.uncompress();
                        }
                        console = (ProtocolActivator.osgi.getService(IConsoleService) as IConsoleService);
                        s = "Unwraped data: ";
                        toUnwrap.position = 0;
                        while (toUnwrap.bytesAvailable)
                        {
                            b = (toUnwrap.readUnsignedByte().toString(16).toUpperCase() + " ");
                            if (b.length < 3)
                            {
                                b = ("0" + b);
                            }
                            s = (s + b);
                        }
                        console.writeToConsoleChannel("PROTOCOL", s);
                        toUnwrap.position = 0;
                        dst.writeBytes(toUnwrap, 0, toUnwrap.length);
                        result = true;
                    }
                }
            }
            return (result);
        }
        private function isLongSize(reader:IDataInput):Boolean
        {
            return ((reader.bytesAvailable >= LONG_SIZE_DELIMITER) || (reader.bytesAvailable == -1));
        }
        private function determineZipped(reader:IDataInput):Boolean
        {
            return ((reader.bytesAvailable == -1) || (reader.bytesAvailable > ZIP_PACKET_SIZE_DELIMITER));
        }

    }
}
