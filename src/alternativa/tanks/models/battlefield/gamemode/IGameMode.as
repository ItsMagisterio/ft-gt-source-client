package alternativa.tanks.models.battlefield.gamemode
{
    import alternativa.tanks.models.battlefield.BattleView3D;
    import alternativa.tanks.model.panel.IBattleSettings;
    import flash.display.BitmapData;

    public interface IGameMode
    {

        function applyChanges(_arg_1:BattleView3D):void;
        function applyChangesBeforeSettings(_arg_1:IBattleSettings):void;
        function applyColorchangesToSkybox(_arg_1:BitmapData):BitmapData;

    }
}
