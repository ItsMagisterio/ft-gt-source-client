// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// scpacker.test.usertitles.UserTitlesRender

package logic.test.usertitles
{
    import alternativa.tanks.models.battlefield.IBattleField;
    import alternativa.tanks.models.tank.TankData;
    import alternativa.math.Vector3;

    public interface UserTitlesRender
    {

        function render():void;
        function setBattlefield(_arg_1:IBattleField):void;
        function setLocalData(_arg_1:TankData):void;
        function updateTitle(_arg_1:TankData, _arg_2:Vector3):void;
        function configurateTitle(_arg_1:TankData):void;

    }
} // package scpacker.test.usertitles