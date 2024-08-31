package platform.client.fp10.core.model
{
   import platform.client.fp10.core.model.impl.Model;
   import platform.client.fp10.core.type.IGameObject;

   public class ObjectLoadListenerAdapt implements platform.client.fp10.core.model.ObjectLoadListener
   {

      private var object:IGameObject;

      private var impl:platform.client.fp10.core.model.ObjectLoadListener;

      public function ObjectLoadListenerAdapt(param1:IGameObject, param2:platform.client.fp10.core.model.ObjectLoadListener)
      {
         super();
         this.object = param1;
         this.impl = param2;
      }

      public function objectLoaded():void
      {
         try
         {
            Model.object = this.object;
            this.impl.objectLoaded();
         }
         finally
         {
            Model.popObject();
         }
      }
   }
}
