package alternativa.tanks.models.battlefield.gui
{
    import projects.tanks.client.battleservice.model.team.BattleTeamType;
    import alternativa.tanks.models.dom.hud.panel.KeyPointsHUDPanel;

    public interface IBattlefieldGUI
    {

        function logUserAction(_arg_1:String, _arg_2:String, _arg_3:String = null):void;
        function logAction(_arg_1:String, _arg_2:String = null):void;
        function ctfShowFlagAtBase(_arg_1:BattleTeamType):void;
        function ctfShowFlagCarried(_arg_1:BattleTeamType):void;
        function ctfShowFlagDropped(_arg_1:BattleTeamType):void;
        function updateHealthIndicator(_arg_1:Number):void;
        function updateWeaponIndicator(_arg_1:Number):void;
        function showPauseIndicator(_arg_1:Boolean):void;
        function setPauseTimeout(_arg_1:int):void;
        function updatePointsHUD():void;
        function createPointsHUD(_arg_1:KeyPointsHUDPanel):void;

    }
}
