package platform.client.fp10.core.logging.serverlog
{
   import alternativa.osgi.service.logging.LogLevel;
   import alternativa.osgi.service.logging.LogTarget;
   import platform.client.fp10.core.network.ICommandSender;
   import platform.client.fp10.core.network.command.control.client.LogCommand;
   import platform.client.fp10.core.service.serverlog.impl.ServerLogPanel;

   public class ServerLogTarget implements LogTarget
   {

      private static const logLevels:Object = {
            "t": LogLevel.TRACE,
            "d": LogLevel.DEBUG,
            "i": LogLevel.INFO,
            "w": LogLevel.WARNING,
            "e": LogLevel.ERROR
         }

      private var commandSender:ICommandSender;

      private var channelLevels:Object;

      private var serverLogPanel:ServerLogPanel;

      public function ServerLogTarget(param1:ICommandSender, param2:String)
      {
         this.channelLevels = {}
         super();
         this.commandSender = param1;
         this.setup(param2);
      }

      private static function createMessage(param1:String, param2:Array):String
      {
         var _loc3_:int = 0;
         if (Boolean(param2))
         {
            _loc3_ = 0;
            while (_loc3_ < param2.length)
            {
               param1 = param1.replace("%" + (_loc3_ + 1), param2[_loc3_]);
               _loc3_++;
            }
         }
         return param1;
      }

      private function setup(param1:String):void
      {
         var _loc3_:String = null;
         var _loc2_:Array = param1.split(",");
         for each (_loc3_ in _loc2_)
         {
            this.setupChannelLevels(_loc3_);
         }
      }

      private function setupChannelLevels(param1:String):void
      {
         var _loc7_:String = null;
         var _loc8_:LogLevel = null;
         if (!param1)
         {
            return;
         }
         var _loc2_:Array = param1.split(":");
         var _loc3_:String = String(_loc2_[0]);
         var _loc4_:String = String(_loc2_[1]);
         if (!_loc3_ || !_loc4_)
         {
            return;
         }
         var _loc5_:Object = {}
         var _loc6_:Array = _loc4_.split("");
         for each (_loc7_ in _loc6_)
         {
            _loc8_ = logLevels[_loc7_];
            if (Boolean(_loc8_))
            {
               _loc5_[_loc8_] = true;
            }
         }
         this.channelLevels[_loc3_] = _loc5_;
      }

      public function log(param1:Object, param2:LogLevel, param3:String, param4:Array = null):void
      {
         var _loc6_:String = null;
         var _loc5_:String = String(param1.toString());
         if (this.isLogEnabled(_loc5_, param2))
         {
            _loc6_ = createMessage(param3, param4);
            this.commandSender.sendCommand(new LogCommand(param2.getValue(), _loc5_, _loc6_));
            if (Boolean(this.serverLogPanel))
            {
               this.serverLogPanel.addLogMessage(param2.getName(), _loc5_ + " " + _loc6_);
            }
         }
      }

      private function isLogEnabled(param1:String, param2:LogLevel):Boolean
      {
         var _loc3_:Object = this.channelLevels[param1];
         return Boolean(_loc3_) && Boolean(_loc3_[param2]);
      }

      public function setLogPanel(param1:ServerLogPanel):void
      {
         this.serverLogPanel = param1;
      }
   }
}
