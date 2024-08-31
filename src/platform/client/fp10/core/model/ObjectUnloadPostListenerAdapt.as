package platform.client.fp10.core.model
{
   import platform.client.fp10.core.model.impl.Model;
   import platform.client.fp10.core.type.IGameObject;

   public class ObjectUnloadPostListenerAdapt implements platform.client.fp10.core.model.ObjectUnloadPostListener
   {

      private var object:IGameObject;

      private var impl:platform.client.fp10.core.model.ObjectUnloadPostListener;

      public function ObjectUnloadPostListenerAdapt(param1:IGameObject, param2:platform.client.fp10.core.model.ObjectUnloadPostListener)
      {
         super();
         this.object = param1;
         this.impl = param2;
      }

      public function objectUnloadedPost():void
      {
         try
         {
            Model.object = this.object;
            this.impl.objectUnloadedPost();
         }
         finally
         {
            Model.popObject();
         }
      }
   }
}
