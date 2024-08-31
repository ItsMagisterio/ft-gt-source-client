package platform.client.fp10.core.resource
{
   import flash.events.Event;
   import flash.net.URLRequest;

   public class SafeURLLoader
   {

      private var opened:Boolean;

      private var closed:Boolean;

      public function SafeURLLoader()
      {
         super();
         // addEventListener(Event.OPEN,this.onOpen,false,int.MAX_VALUE);
      }

      public function load(param1:URLRequest):void
      {

      }

      public function close():void
      {
         if (this.opened)
         {
            this.opened = false;
            super.close();
         }
         else
         {
            this.closed = true;
         }
      }

      private function onOpen(param1:Event):void
      {
         this.opened = true;
         if (this.closed)
         {
            this.close();
         }
      }
   }
}
