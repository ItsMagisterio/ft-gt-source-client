// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// scpacker.networking.commands.Type

package logic.networking.commands {
public class Type {

    public static var AUTH:Type = new (Type)();
    public static var REGISTRATON:Type = new (Type)();
    public static var CHAT:Type = new (Type)();
    public static var GARAGE:Type = new (Type)();
    public static var LOBBY:Type = new (Type)();
    public static var BATTLE:Type = new (Type)();
    public static var PING:Type = new (Type)();
    public static var LOBBY_CHAT:Type = new (Type)();
    public static var SYSTEM:Type = new (Type)();
    public static var UNKNOWN:Type = new (Type)();

    public static function valueOf(value:String):Type {
        switch (value) {
            case "auth":
                return AUTH;
            case "registration":
                return REGISTRATON;
            case "chat":
                return CHAT;
            case "garage":
                return GARAGE;
            case "lobby":
                return LOBBY;
            case "battle":
                return BATTLE;
            case "ping":
                return PING;
            case "lobby_chat":
                return LOBBY_CHAT;
            case "system":
                return SYSTEM;
            default:
                return UNKNOWN;

        }
    }
}
}
