package platform.client.fp10.core.model
{
   import platform.client.fp10.core.model.impl.Model;
   import platform.client.fp10.core.type.IGameObject;

   public class ObjectLoadListenerEvents implements ObjectLoadListener
   {

      private var object:IGameObject;

      private var impl:Vector.<Object>;

      public function ObjectLoadListenerEvents(param1:IGameObject, param2:Vector.<Object>)
      {
         super();
         this.object = param1;
         this.impl = param2;
      }

      public function objectLoaded():void
      {
         var i:int = 0;
         var m:ObjectLoadListener = null;
         try
         {
            Model.object = this.object;
            i = 0;
            while (i < this.impl.length)
            {
               m = ObjectLoadListener(this.impl[i]);
               m.objectLoaded();
               i++;
            }
         }
         finally
         {
            Model.popObject();
         }
      }
   }
}
