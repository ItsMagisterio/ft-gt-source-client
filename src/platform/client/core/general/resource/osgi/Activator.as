package platform.client.core.general.resource.osgi
{
   import _codec.platform.core.general.resource.types.image.CodecScaleEnum;
   import _codec.platform.core.general.resource.types.image.VectorCodecScaleEnumLevel1;
   import _codec.platform.core.general.resource.types.imageframe.CodecResourceImageFrameParams;
   import _codec.platform.core.general.resource.types.imageframe.VectorCodecResourceImageFrameParamsLevel1;
   import alternativa.osgi.OSGi;
   import alternativa.osgi.bundle.IBundleActivator;
   import alternativa.protocol.ICodec;
   import alternativa.protocol.IProtocol;
   import alternativa.protocol.codec.OptionalCodecDecorator;
   import alternativa.protocol.info.CollectionCodecInfo;
   import alternativa.protocol.info.EnumCodecInfo;
   import alternativa.protocol.info.TypeCodecInfo;
   import platform.core.general.resource.types.image.ScaleEnum;
   import platform.core.general.resource.types.imageframe.ResourceImageFrameParams;

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
         _loc3_ = new CodecScaleEnum();
         _loc2_.registerCodec(new EnumCodecInfo(ScaleEnum, false), _loc3_);
         _loc2_.registerCodec(new EnumCodecInfo(ScaleEnum, true), new OptionalCodecDecorator(_loc3_));
         _loc3_ = new CodecResourceImageFrameParams();
         _loc2_.registerCodec(new TypeCodecInfo(ResourceImageFrameParams, false), _loc3_);
         _loc2_.registerCodec(new TypeCodecInfo(ResourceImageFrameParams, true), new OptionalCodecDecorator(_loc3_));
         _loc3_ = new VectorCodecScaleEnumLevel1(false);
         _loc2_.registerCodec(new CollectionCodecInfo(new EnumCodecInfo(ScaleEnum, false), false, 1), _loc3_);
         _loc2_.registerCodec(new CollectionCodecInfo(new EnumCodecInfo(ScaleEnum, false), true, 1), new OptionalCodecDecorator(_loc3_));
         _loc3_ = new VectorCodecScaleEnumLevel1(true);
         _loc2_.registerCodec(new CollectionCodecInfo(new EnumCodecInfo(ScaleEnum, true), false, 1), _loc3_);
         _loc2_.registerCodec(new CollectionCodecInfo(new EnumCodecInfo(ScaleEnum, true), true, 1), new OptionalCodecDecorator(_loc3_));
         _loc3_ = new VectorCodecResourceImageFrameParamsLevel1(false);
         _loc2_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(ResourceImageFrameParams, false), false, 1), _loc3_);
         _loc2_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(ResourceImageFrameParams, false), true, 1), new OptionalCodecDecorator(_loc3_));
         _loc3_ = new VectorCodecResourceImageFrameParamsLevel1(true);
         _loc2_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(ResourceImageFrameParams, true), false, 1), _loc3_);
         _loc2_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(ResourceImageFrameParams, true), true, 1), new OptionalCodecDecorator(_loc3_));
      }

      public function stop(param1:OSGi):void
      {
      }
   }
}
