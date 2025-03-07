﻿// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// scpacker.server.models.bonus.ServerBonusModel

package logic.server.models.bonus
{
    import alternativa.tanks.model.bonus.BonusModel;
    import alternativa.service.IModelService;
    import alternativa.init.Main;
    import projects.tanks.client.panel.model.bonus.IBonusModelBase;
    import projects.tanks.client.panel.model.bonus.BonusItem;

    public class ServerBonusModel
    {

        private var model:BonusModel;
        private var modelsService:IModelService;

        public function ServerBonusModel()
        {
            this.modelsService = IModelService(Main.osgi.getService(IModelService));
            this.model = BonusModel(this.modelsService.getModelsByInterface(IBonusModelBase)[0]);
        }
        public function showBonuses(data:String):void
        {
            var item:Object;
            var bonusItem:BonusItem;
            var array:Array = new Array();
            var parser:Object = JSON.parse(data);
            var i:int;
            for each (item in parser.items)
            {
                bonusItem = new BonusItem(item.id);
                bonusItem.count = item.count;
                array[i] = bonusItem;
                i++;
            }
            this.model.showBonuses(null, array, "RU");
        }
        public function showCrystalls(count:int):void
        {
            this.model.showCrystals(null, count, null);
        }
        public function showDoubleCrystalls():void
        {
            this.model.showDoubleCrystalls(null, null);
        }
        public function showNoSupplies():void
        {
            this.model.showNoSupplies(null, null);
        }
        public function showNewbiesUpScore():void
        {
            this.model.showNubeUpScore();
        }
        public function showNewbiesNewRank():void
        {
            this.model.showNubeNewRank();
        }
        public function showRulesUpdate():void
        {
            this.model.showRulesUpdate();
        }

    }
} // package scpacker.server.models.bonus