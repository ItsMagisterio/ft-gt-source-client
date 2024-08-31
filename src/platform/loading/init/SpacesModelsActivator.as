package platform.loading.init
{
   import alternativa.osgi.OSGi;
   import alternativa.osgi.bundle.IBundleActivator;
   import alternativa.protocol.IProtocol;
   import platform.client.core.general.spaces.loading.dispatcher.types.ObjectsData;
   import platform.client.core.general.spaces.loading.dispatcher.types.ObjectsDependencies;
   import platform.client.core.general.spaces.loading.modelconstructors.ModelData;
   import platform.loading.codecs.ModelDataCodec;
   import platform.loading.codecs.ObjectsDataCodec;
   import platform.loading.codecs.ObjectsDependenciesCodec;

   public class SpacesModelsActivator implements IBundleActivator
   {

      public function SpacesModelsActivator()
      {
         super();
      }

      public function start(param1:OSGi):void
      {
         var _loc2_:IProtocol = IProtocol(param1.getService(IProtocol));
         _loc2_.registerCodecForType(ModelData, new ModelDataCodec());
         _loc2_.registerCodecForType(ObjectsData, new ObjectsDataCodec());
         _loc2_.registerCodecForType(ObjectsDependencies, new ObjectsDependenciesCodec());
      }

      public function stop(param1:OSGi):void
      {
      }
   }
}
