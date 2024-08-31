package platform.client.fp10.core.model
{
   import platform.client.fp10.core.model.impl.Model;
   import platform.client.fp10.core.type.IGameObject;

   public class ObjectUnloadListenerAdapt implements platform.client.fp10.core.model.ObjectUnloadListener
   {

      private var object:IGameObject;

      private var impl:platform.client.fp10.core.model.ObjectUnloadListener;

      public function ObjectUnloadListenerAdapt(param1:IGameObject, param2:platform.client.fp10.core.model.ObjectUnloadListener)
      {
         super();
         this.object = param1;
         this.impl = param2;
      }

      public function objectUnloaded():void
      {
         try
         {
            Model.object = this.object;
            this.impl.objectUnloaded();
         }
         finally
         {
            Model.popObject();
         }
      }
   }
}
