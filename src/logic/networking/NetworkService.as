// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// scpacker.networking.NetworkService

package logic.networking
{
    import __AS3__.vec.Vector;

import com.hurlant.crypto.Crypto;

import com.hurlant.crypto.symmetric.ICipher;

import com.hurlant.crypto.symmetric.IPad;
import com.hurlant.crypto.symmetric.IVMode;
import com.hurlant.crypto.symmetric.PKCS5;

import com.hurlant.util.Base64;

import com.hurlant.util.Hex;

import flash.utils.ByteArray;

import logic.networking.commands.Type;
    import logic.networking.commands.Command;
    import __AS3__.vec.*;

    public class NetworkService
    {

        private static var listeners:Vector.<INetworkListener>;
        public static const DELIM_ARGUMENTS_SYMBOL:String = ";";


        public function NetworkService()
        {
            listeners = new Vector.<INetworkListener>();
        }
        public static function decrypt(_InB64Data:String, _InPlainKey:String, _InB64IV:String):String {
            var kdata:ByteArray = Hex.toArray(Hex.fromString(_InPlainKey));
            var data:ByteArray = Base64.decodeToByteArray(_InB64Data);
            var pad:IPad = new PKCS5;
            var mode:com.hurlant.crypto.symmetric.ICipher;
            mode = Crypto.getCipher("aes-cbc", kdata, pad);
            if (mode is IVMode) {
                var ivmode:IVMode = mode as IVMode;
                // Just remember this is just a cast. The IV is still being set on the mode variable.
                ivmode.IV = Base64.decodeToByteArray( _InB64IV );
            }
            pad.setBlockSize(mode.getBlockSize());
            mode.decrypt(data);

            return Hex.toString(Hex.fromArray(data));
        }

        public function protocolDecrypt(command:String):void
        {
                var args:Array = command.split(DELIM_ARGUMENTS_SYMBOL);
                var commandType:Type = Type.valueOf(args[0]);
                if (commandType == Type.UNKNOWN)
                {
                    throw new Error("Что то пошло не так  " + command);
                }
               //remove first element
                args.shift();
                var tempCommand:Command = new Command(commandType, args, command);
                this.sendRequestToAllListeners(tempCommand);
        }

        public function sendRequestToAllListeners(command:Command):void
        {
            var listener:INetworkListener;
            for each (listener in listeners)
            {
                listener.onData(command);
            }
        }
        public function addListener(listener:INetworkListener):void
        {
            listeners.push(listener);
        }
        public function removeListener(listener:INetworkListener):void
        {
            var list:INetworkListener;
            var index:int;
            for each (list in listeners)
            {
                if (list == listener)
                {
                    break;
                }
                index++;
            }
            listeners.removeAt(index);
        }
        private function getArray(...args):Array
        {
            var array:Array = new Array(args);
            return (array);
        }

    }
}