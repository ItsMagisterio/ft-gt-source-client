package alternativa.protocol.factory
{
    import flash.utils.Dictionary;
    import alternativa.protocol.codec.primitive.IntegerCodec;
    import alternativa.protocol.type.Short;
    import alternativa.protocol.codec.primitive.ShortCodec;
    import alternativa.protocol.type.Byte;
    import alternativa.protocol.codec.primitive.ByteCodec;
    import alternativa.protocol.codec.primitive.DoubleCodec;
    import alternativa.protocol.type.Float;
    import alternativa.protocol.codec.primitive.FloatCodec;
    import alternativa.protocol.codec.primitive.BooleanCodec;
    import alternativa.types.Long;
    import alternativa.protocol.codec.primitive.LongCodec;
    import alternativa.protocol.codec.complex.StringCodec;
    import alternativa.protocol.codec.ICodec;
    import alternativa.protocol.codec.complex.ArrayCodec;

    public class CodecFactory implements ICodecFactory
    {

        private var codecs:Dictionary;
        private var notnullArrayCodecs:Dictionary;
        private var nullArrayCodecs:Dictionary;

        public function CodecFactory()
        {
            this.codecs = new Dictionary();
            this.notnullArrayCodecs = new Dictionary();
            this.nullArrayCodecs = new Dictionary();
            this.registerCodec(int, new IntegerCodec());
            this.registerCodec(Short, new ShortCodec());
            this.registerCodec(Byte, new ByteCodec());
            this.registerCodec(Number, new DoubleCodec());
            this.registerCodec(Float, new FloatCodec());
            this.registerCodec(Boolean, new BooleanCodec());
            this.registerCodec(Long, new LongCodec());
            this.registerCodec(String, new StringCodec());
        }
        public function registerCodec(targetClass:Class, codec:ICodec):void
        {
            this.codecs[targetClass] = codec;
        }
        public function unregisterCodec(targetClass:Class):void
        {
            this.codecs[targetClass] = null;
        }
        public function getCodec(targetClass:Class):ICodec
        {
            return (this.codecs[targetClass]);
        }
        public function getArrayCodec(targetClass:Class, elementnotnull:Boolean = true, depth:int = 1):ICodec
        {
            var codec:ArrayCodec;
            var dict:Dictionary;
            if (elementnotnull)
            {
                dict = this.notnullArrayCodecs;
            }
            else
            {
                dict = this.nullArrayCodecs;
            }
            if (dict[targetClass] == null)
            {
                dict[targetClass] = new Dictionary(false);
            }
            if (dict[targetClass][depth] == null)
            {
                codec = new ArrayCodec(targetClass, this.getCodec(targetClass), elementnotnull, depth);
                dict[targetClass][depth] = codec;
            }
            else
            {
                codec = dict[targetClass][depth];
            }
            return (codec);
        }

    }
}
