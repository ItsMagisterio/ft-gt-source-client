// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// scpacker.networking.Network

package logic.networking {
import com.hurlant.crypto.Crypto;
import com.hurlant.crypto.symmetric.AESKey;
import com.hurlant.crypto.symmetric.CBCMode;
import com.hurlant.crypto.symmetric.ICipher;
import com.hurlant.crypto.symmetric.IMode;
import com.hurlant.crypto.symmetric.IPad;
import com.hurlant.crypto.symmetric.IVMode;
import com.hurlant.crypto.symmetric.NullPad;
import com.hurlant.crypto.symmetric.PKCS5;
import com.hurlant.util.Base64;
import com.hurlant.util.Hex;

import flash.net.Socket;
import flash.events.ProgressEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;

import specter.utils.Logger;

import flash.utils.ByteArray;

import alternativa.init.Main;
import alternativa.osgi.service.alert.IAlertService;
import alternativa.tanks.bg.IBackgroundService;


public class Network extends NetworkService {

    private var socket:Socket;
    private var isReadingSize:Boolean = false;
    private var size:int = 0;
    public var connectionListener:Function;


    public function Network() {
        this.socket = new Socket();
    }

    public function connect(ip:String, port:int):void {
        this.socket.addEventListener(ProgressEvent.SOCKET_DATA, this.onDataSocket);
        this.socket.addEventListener(Event.CONNECT, this.onConnected);
        this.socket.addEventListener(Event.CLOSE, this.onCloseConnecting);
        this.socket.addEventListener(IOErrorEvent.IO_ERROR, this.ioError);
        this.socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityError);
        this.socket.connect(ip, port);
    }

    public function destroy():void {
        this.socket.removeEventListener(ProgressEvent.SOCKET_DATA, this.onDataSocket);
        this.socket.removeEventListener(Event.CONNECT, this.onConnected);
        this.socket.removeEventListener(Event.CLOSE, this.onCloseConnecting);
        this.socket.removeEventListener(IOErrorEvent.IO_ERROR, this.ioError);
        this.socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityError);
    }

    public function addEventListener(listener:INetworkListener):void {
        addListener(listener);
    }

    public function removeEventListener(listener:INetworkListener):void {
        removeListener(listener);
    }

    public function send(str:String):void {
        try {
            var initialKey:String = "084B255737229811CF454AF2AE99B20E";
            var initialIV:String = "D8BF3DF78364B5CC";
            var result:* = encrypt(str, initialKey, initialIV);
            this.socket.writeInt(result.length);
            this.socket.writeUTFBytes(result);
            this.socket.flush();
        } catch (e:Error) {
            Logger.warn(((("Error sending: " + e.message) + "\n") + e.getStackTrace()));
        }
    }


    public  function encrypt2(_InPlainData:String, _InPlainKey:String, _InPlainIV:String):Vector.<String> {
        var kdata:ByteArray = Hex.toArray(Hex.fromString(_InPlainKey));
        var data:ByteArray = Hex.toArray(Hex.fromString(_InPlainData));
        var pad:IPad = new PKCS5;
        // as3crypto determines the size based on the key. Look inside the Crypto class if you don't believe me.
        var mode:ICipher = Crypto.getCipher("aes-cbc", kdata, pad);

        var b64_IV:String = "";
        if (mode is IVMode) {
            var ivmode:IVMode = mode as IVMode;
            // Just remember this is just a cast. The IV is still being set on the mode variable.
            ivmode.IV = Hex.toArray(Hex.fromString(_InPlainIV));
            b64_IV = Base64.encode(_InPlainIV);
        }
        pad.setBlockSize(mode.getBlockSize());
        mode.encrypt(data);

        var returnIVandData:Vector.<String> = new Vector.<String>();
        returnIVandData.push(b64_IV);
        returnIVandData.push(Base64.encodeByteArray(data));
        return returnIVandData;
    }

    private function encrypt(input:String, initialKey:String, initialIV:String):String {
        var results:Vector.<String> = encrypt2(input, initialKey, initialIV);

        trace("Resulting B64 IV: " + results[0]);
        trace("Resulting B64 Data: " + results[1]);


        return results[1];
    }


    private function onConnected(e:Event):void {
        if (this.connectionListener != null) {
            this.connectionListener.call();
        }
        Logger.log("onConnected()");
    }

    private function onDataSocket(e:Event):void {
        trace("onDataSocket()")
        while (true) {
            if (!this.isReadingSize) {
                if (this.socket.bytesAvailable < 4) {
                    break;
                }
                this.size = this.socket.readInt();
                this.isReadingSize = true;
                var success:Boolean = parsePacket();
                if (success) {
                    this.isReadingSize = false;
                    this.size = 0;
                } else {
                    break;
                }
            } else {
                var success:Boolean = parsePacket();
                if (success) {
                    this.isReadingSize = false;
                    this.size = 0;
                } else {
                    break;
                }
            }
        }
    }

    private function parsePacket():Boolean {
        if (this.socket.bytesAvailable < this.size)
            return false;
        var bytes:ByteArray = new ByteArray();
        this.socket.readBytes(bytes, 0, this.size);
        var command:String = bytes.readUTFBytes(this.size);
        command = decrypt(command, "084B255737229811CF454AF2AE99B20E", Base64.encode("D8BF3DF78364B5CC"));
        protocolDecrypt(command)
        return true;
    }

    private function onCloseConnecting(e:Event):void {
        Logger.log("onCloseConnecting()");
        this.socket.close();
        var alertService:IAlertService = (Main.osgi.getService(IAlertService) as IAlertService);
        alertService.showAlert("Connection closed by server!");

        var i:int;
        while (i < Main.mainContainer.numChildren) {
            Main.mainContainer.removeChildAt(1);
            i++;
        }
        IBackgroundService(Main.osgi.getService(IBackgroundService)).drawBg();
        IBackgroundService(Main.osgi.getService(IBackgroundService)).showBg();
    }

    private function ioError(e:Event):void {
        Logger.warn("IO error!");
        this.socket.close();
        var alertService:IAlertService = (Main.osgi.getService(IAlertService) as IAlertService);
        alertService.showAlert(("Connection to server " + "failed"));
        var i:int;
        while (i < Main.mainContainer.numChildren) {
            Main.mainContainer.removeChildAt(1);
            i++;
        }
        IBackgroundService(Main.osgi.getService(IBackgroundService)).drawBg();
        IBackgroundService(Main.osgi.getService(IBackgroundService)).showBg();
    }

    private function securityError(e:Event):void {
        Logger.warn("Security error!");
        this.socket.close();
        var alertService:IAlertService = (Main.osgi.getService(IAlertService) as IAlertService);
        alertService.showAlert(("Connection to server " + "failed"));
        var i:int;
        while (i < Main.mainContainer.numChildren) {
            Main.mainContainer.removeChildAt(1);
            i++;
        }
        IBackgroundService(Main.osgi.getService(IBackgroundService)).drawBg();
        IBackgroundService(Main.osgi.getService(IBackgroundService)).showBg();
    }

    public function socketConnected():Boolean {
        return (this.socket.connected);
    }

}
} // package scpacker.networking