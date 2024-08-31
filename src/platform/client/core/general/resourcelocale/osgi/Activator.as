package platform.client.core.general.resourcelocale.osgi
{
   import _codec.platform.client.core.general.resourcelocale.format.CodecImagePair;
   import _codec.platform.client.core.general.resourcelocale.format.CodecLocalizedFileFormat;
   import _codec.platform.client.core.general.resourcelocale.format.CodecStringPair;
   import _codec.platform.client.core.general.resourcelocale.format.VectorCodecImagePairLevel1;
   import _codec.platform.client.core.general.resourcelocale.format.VectorCodecLocalizedFileFormatLevel1;
   import _codec.platform.client.core.general.resourcelocale.format.VectorCodecStringPairLevel1;
   import alternativa.osgi.OSGi;
   import alternativa.osgi.bundle.IBundleActivator;
   import alternativa.protocol.ICodec;
   import alternativa.protocol.IProtocol;
   import alternativa.protocol.codec.OptionalCodecDecorator;
   import alternativa.protocol.info.CollectionCodecInfo;
   import alternativa.protocol.info.TypeCodecInfo;
   import platform.client.core.general.resourcelocale.format.ImagePair;
   import platform.client.core.general.resourcelocale.format.LocalizedFileFormat;
   import platform.client.core.general.resourcelocale.format.StringPair;

   public class Activator implements IBundleActivator
   {

      public static var osgi:OSGi;

      public function Activator()
      {
         super();
      }

      public function start(param1:OSGi):void
      {
         var _loc3_:ICodec = null;
         osgi = param1;
         var _loc2_:IProtocol = IProtocol(osgi.getService(IProtocol));
         _loc3_ = new CodecImagePair();
         _loc2_.registerCodec(new TypeCodecInfo(ImagePair, false), _loc3_);
         _loc2_.registerCodec(new TypeCodecInfo(ImagePair, true), new OptionalCodecDecorator(_loc3_));
         _loc3_ = new CodecLocalizedFileFormat();
         _loc2_.registerCodec(new TypeCodecInfo(LocalizedFileFormat, false), _loc3_);
         _loc2_.registerCodec(new TypeCodecInfo(LocalizedFileFormat, true), new OptionalCodecDecorator(_loc3_));
         _loc3_ = new CodecStringPair();
         _loc2_.registerCodec(new TypeCodecInfo(StringPair, false), _loc3_);
         _loc2_.registerCodec(new TypeCodecInfo(StringPair, true), new OptionalCodecDecorator(_loc3_));
         _loc3_ = new VectorCodecImagePairLevel1(false);
         _loc2_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(ImagePair, false), false, 1), _loc3_);
         _loc2_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(ImagePair, false), true, 1), new OptionalCodecDecorator(_loc3_));
         _loc3_ = new VectorCodecImagePairLevel1(true);
         _loc2_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(ImagePair, true), false, 1), _loc3_);
         _loc2_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(ImagePair, true), true, 1), new OptionalCodecDecorator(_loc3_));
         _loc3_ = new VectorCodecLocalizedFileFormatLevel1(false);
         _loc2_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(LocalizedFileFormat, false), false, 1), _loc3_);
         _loc2_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(LocalizedFileFormat, false), true, 1), new OptionalCodecDecorator(_loc3_));
         _loc3_ = new VectorCodecLocalizedFileFormatLevel1(true);
         _loc2_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(LocalizedFileFormat, true), false, 1), _loc3_);
         _loc2_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(LocalizedFileFormat, true), true, 1), new OptionalCodecDecorator(_loc3_));
         _loc3_ = new VectorCodecStringPairLevel1(false);
         _loc2_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(StringPair, false), false, 1), _loc3_);
         _loc2_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(StringPair, false), true, 1), new OptionalCodecDecorator(_loc3_));
         _loc3_ = new VectorCodecStringPairLevel1(true);
         _loc2_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(StringPair, true), false, 1), _loc3_);
         _loc2_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(StringPair, true), true, 1), new OptionalCodecDecorator(_loc3_));
      }

      public function stop(param1:OSGi):void
      {
      }
   }
}
