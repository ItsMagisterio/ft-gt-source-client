package platform.client.fp10.core.osgi
{
   import alternativa.osgi.service.logging.LogLevel;
   import alternativa.osgi.service.logging.LogTarget;

   internal class TraceLogger implements LogTarget
   {

      public function TraceLogger()
      {
         super();
      }

      public function log(param1:Object, param2:LogLevel, param3:String, param4:Array = null):void
      {
      }
   }
}
