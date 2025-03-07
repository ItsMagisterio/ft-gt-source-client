﻿package alternativa.tanks.models.battlefield.logic
{
    import alternativa.tanks.vehicles.tanks.Tank;
    import alternativa.tanks.models.battlefield.BattlefieldModel;
    import alternativa.init.Main;
    import alternativa.tanks.models.battlefield.IBattleField;
    import alternativa.tanks.utils.MathUtils;

    public class BeforeKillTankTask implements LogicUnit
    {

        private var readyTime:int;
        private var tank:Tank;
        private var battle:BattlefieldModel;
        private var alreadyEffect:Boolean;

        public function BeforeKillTankTask(readyTime:int, tank:Tank)
        {
            this.readyTime = readyTime;
            this.tank = tank;
            this.battle = (Main.osgi.getService(IBattleField) as BattlefieldModel);
        }
        public function runLogic(param1:int, param2:int):void
        {
            if (((!(this.tank == null)) && (!(this.tank.skin == null))))
            {
                this.tank.skin.setAlpha(MathUtils.clamp(((this.readyTime - param1) / 500), 0, 1));
            }
            if (param1 > this.readyTime)
            {
                this.stop();
            }
        }
        private function stop():void
        {
            this.battle.logicUnits.removeLogicUnit(this);
        }

    }
}
