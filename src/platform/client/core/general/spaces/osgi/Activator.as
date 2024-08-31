package platform.client.core.general.spaces.osgi
{
   import _codec.platform.client.core.general.spaces.loading.dispatcher.types.CodecObjectsData;
   import _codec.platform.client.core.general.spaces.loading.dispatcher.types.CodecObjectsDependencies;
   import _codec.platform.client.core.general.spaces.loading.dispatcher.types.VectorCodecObjectsDataLevel1;
   import _codec.platform.client.core.general.spaces.loading.dispatcher.types.VectorCodecObjectsDependenciesLevel1;
   import _codec.platform.client.core.general.spaces.loading.modelconstructors.CodecModelData;
   import _codec.platform.client.core.general.spaces.loading.modelconstructors.VectorCodecModelDataLevel1;
   import alternativa.osgi.OSGi;
   import alternativa.osgi.bundle.IBundleActivator;
   import alternativa.protocol.ICodec;
   import alternativa.protocol.IProtocol;
   import alternativa.protocol.codec.OptionalCodecDecorator;
   import alternativa.protocol.info.CollectionCodecInfo;
   import alternativa.protocol.info.TypeCodecInfo;
   import alternativa.types.Long;
   import platform.client.core.general.spaces.loading.dispatcher.types.ObjectsData;
   import platform.client.core.general.spaces.loading.dispatcher.types.ObjectsDependencies;
   import platform.client.core.general.spaces.loading.modelconstructors.ModelData;
   import platform.client.fp10.core.registry.ModelRegistry;

   public class Activator implements IBundleActivator
   {

      public static var osgi:OSGi;

      public function Activator()
      {
         super();
      }

      public function start(param1:OSGi):void
      {
         var _loc4_:ICodec = null;
         osgi = param1;
         var _loc2_:ModelRegistry = ModelRegistry(OSGi.getInstance().getService(ModelRegistry));
         _loc2_.register(Long.getLong(191355032, 163351191), Long.getLong(748816660, 1488436371));
         _loc2_.register(Long.getLong(191355032, 163351191), Long.getLong(1779039460, 1862164506));
         _loc2_.register(Long.getLong(191355032, 163351191), Long.getLong(2104499555, 54326167));
         var _loc3_:IProtocol = IProtocol(osgi.getService(IProtocol));
         _loc4_ = new CodecObjectsData();
         _loc3_.registerCodec(new TypeCodecInfo(ObjectsData, false), _loc4_);
         _loc3_.registerCodec(new TypeCodecInfo(ObjectsData, true), new OptionalCodecDecorator(_loc4_));
         _loc4_ = new CodecObjectsDependencies();
         _loc3_.registerCodec(new TypeCodecInfo(ObjectsDependencies, false), _loc4_);
         _loc3_.registerCodec(new TypeCodecInfo(ObjectsDependencies, true), new OptionalCodecDecorator(_loc4_));
         _loc4_ = new CodecModelData();
         _loc3_.registerCodec(new TypeCodecInfo(ModelData, false), _loc4_);
         _loc3_.registerCodec(new TypeCodecInfo(ModelData, true), new OptionalCodecDecorator(_loc4_));
         _loc4_ = new VectorCodecObjectsDataLevel1(false);
         _loc3_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(ObjectsData, false), false, 1), _loc4_);
         _loc3_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(ObjectsData, false), true, 1), new OptionalCodecDecorator(_loc4_));
         _loc4_ = new VectorCodecObjectsDataLevel1(true);
         _loc3_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(ObjectsData, true), false, 1), _loc4_);
         _loc3_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(ObjectsData, true), true, 1), new OptionalCodecDecorator(_loc4_));
         _loc4_ = new VectorCodecObjectsDependenciesLevel1(false);
         _loc3_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(ObjectsDependencies, false), false, 1), _loc4_);
         _loc3_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(ObjectsDependencies, false), true, 1), new OptionalCodecDecorator(_loc4_));
         _loc4_ = new VectorCodecObjectsDependenciesLevel1(true);
         _loc3_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(ObjectsDependencies, true), false, 1), _loc4_);
         _loc3_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(ObjectsDependencies, true), true, 1), new OptionalCodecDecorator(_loc4_));
         _loc4_ = new VectorCodecModelDataLevel1(false);
         _loc3_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(ModelData, false), false, 1), _loc4_);
         _loc3_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(ModelData, false), true, 1), new OptionalCodecDecorator(_loc4_));
         _loc4_ = new VectorCodecModelDataLevel1(true);
         _loc3_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(ModelData, true), false, 1), _loc4_);
         _loc3_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(ModelData, true), true, 1), new OptionalCodecDecorator(_loc4_));
      }

      public function stop(param1:OSGi):void
      {
      }
   }
}
