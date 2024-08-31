package alternativa.protocol.codec.complex
{
    import alternativa.protocol.codec.AbstractCodec;
    import alternativa.protocol.codec.ICodec;
    import flash.utils.IDataOutput;
    import alternativa.protocol.codec.NullMap;
    import flash.utils.IDataInput;

    public class ArrayCodec extends AbstractCodec
    {

        private var targetClass:Class;
        private var elementCodec:ICodec;
        private var elementnotnull:Boolean;
        private var depth:int;

        public function ArrayCodec(targetClass:Class, elementCodec:ICodec, elementnotnull:Boolean, depth:int = 1)
        {
            this.targetClass = targetClass;
            this.elementCodec = elementCodec;
            this.elementnotnull = elementnotnull;
            this.depth = depth;
        }
        override public function encode(dest:IDataOutput, object:Object, nullmap:NullMap, notnull:Boolean):void
        {
            if ((!(notnull)))
            {
                nullmap.addBit((object == nullValue));
            }
            if (object != nullValue)
            {
                this.encodeArray(dest, (object as Array), nullmap, 1);
            }
            else
            {
                if (notnull)
                {
                    throw (new Error("Object is null, but notnull expected."));
                }
            }
        }
        override public function decode(reader:IDataInput, nullmap:NullMap, notnull:Boolean):Object
        {
            return (((!(notnull)) && (nullmap.getNextBit())) ? nullValue : this.decodeArray(reader, nullmap, 1));
        }
        private function decodeArray(reader:IDataInput, nullmap:NullMap, currentDepth:int):Array
        {
            var i:int;
            var length:int = LengthCodec.decodeLength(reader);
            var result:Array = new Array();
            if (currentDepth == this.depth)
            {
                i = 0;
                while (i < length)
                {
                    result[i] = this.elementCodec.decode(reader, nullmap, this.elementnotnull);
                    i++;
                }
            }
            else
            {
                currentDepth++;
                i = 0;
                while (i < length)
                {
                    result[i] = this.decodeArray(reader, nullmap, currentDepth);
                    i++;
                }
            }
            return (result);
        }
        private function encodeArray(dest:IDataOutput, object:Array, nullmap:NullMap, currentDepth:int):void
        {
            var element:Object;
            var array:Array;
            LengthCodec.encodeLength(dest, object.length);
            if (currentDepth == this.depth)
            {
                for each (element in object)
                {
                    this.elementCodec.encode(dest, element, nullmap, this.elementnotnull);
                }
            }
            else
            {
                currentDepth++;
                for each (array in object)
                {
                    this.encodeArray(dest, array, nullmap, currentDepth);
                }
            }
        }

    }
}
