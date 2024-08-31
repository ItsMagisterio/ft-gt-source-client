package platform.client.fp10.core.network.connection
{
   public class ConnectionStatus
   {

      public static const IDLE:platform.client.fp10.core.network.connection.ConnectionStatus = new platform.client.fp10.core.network.connection.ConnectionStatus("IDLE");

      public static const CONNECTING:platform.client.fp10.core.network.connection.ConnectionStatus = new platform.client.fp10.core.network.connection.ConnectionStatus("CONNECTING");

      public static const CONNECTED:platform.client.fp10.core.network.connection.ConnectionStatus = new platform.client.fp10.core.network.connection.ConnectionStatus("CONNECTED");

      public static const DISCONNECTED:platform.client.fp10.core.network.connection.ConnectionStatus = new platform.client.fp10.core.network.connection.ConnectionStatus("DISCONNECTED");

      private var _value:String;

      public function ConnectionStatus(param1:String)
      {
         super();
         this._value = param1;
      }

      public function toString():String
      {
         return this._value;
      }
   }
}
