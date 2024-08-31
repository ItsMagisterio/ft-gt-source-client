// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// scpacker.server.models.inventory.ServerInventoryModel

package logic.server.models.inventory
{
	import alternativa.tanks.model.panel.IPanel;
	import alternativa.tanks.model.panel.PanelModel;
	import alternativa.tanks.models.battlefield.inventory.InventoryModel;
	import alternativa.tanks.models.battlefield.inventory.InventoryItemModel;
	import alternativa.tanks.models.effectsvisualization.EffectsVisualizationModel;
	import alternativa.service.IModelService;
	import flash.utils.Dictionary;
	import alternativa.init.Main;
	import alternativa.tanks.models.inventory.IInventory;
	import alternativa.tanks.models.battlefield.inventory.IInventoryItemModel;
	import alternativa.tanks.models.effectsvisualization.IEffectsVisualizationModel;
	import alternativa.object.ClientObject;

	public class ServerInventoryModel
	{

		public var inventoryModel:InventoryModel;
		private var inventoryItemModel:InventoryItemModel;
		private var effectModel:EffectsVisualizationModel;
		private var modelsService:IModelService;
		private var _objects:Dictionary;

		public function init():void
		{
			this.modelsService = IModelService(Main.osgi.getService(IModelService));
			this.inventoryModel = InventoryModel(this.modelsService.getModelsByInterface(IInventory)[0]);
			this.inventoryItemModel = InventoryItemModel(this.modelsService.getModelsByInterface(IInventoryItemModel)[0]);
			this.effectModel = EffectsVisualizationModel(this.modelsService.getModelsByInterface(IEffectsVisualizationModel)[0]);
			this._objects = new Dictionary();
		}

		public function initInventory(items:Array):void
		{
			var data:ServerInventoryData;
			var clientObject:ClientObject;
			var gold:Boolean;
			var cch:int = 0;
			this.inventoryModel.objectLoaded(null);
			for each (data in items)
			{
				clientObject = this.getClientObject(data.id);
				if (data.slotId == 6 && data.count == 0)
				{
					gold = true;
				}
				this.inventoryItemModel.initObject(clientObject, null, data.count, data.itemEffectTime, data.slotId, data.itemRestSec);
				this._objects[data.id] = clientObject;
			}
			if (!gold)
			{
				// this.inventoryModel.setVisible(5, true, true);
			}

		}

		public function updateInventory(items:Array):void
		{
			var data:ServerInventoryData;
			if (((this.inventoryModel == null) || (this.inventoryItemModel == null)))
			{
				return;
			}
			;
			for each (data in items)
			{
				this.inventoryItemModel.updateItemCount(this._objects[data.id], data.count);
			}

		}

		public function activateItem(id:String):void
		{
			this.inventoryItemModel.activated(this._objects[id]);

			switch (id)
			{
				case "health":
					this.inventoryModel.activateCooldown(0, 30000);
					this.inventoryModel.activateDependedCooldown(4, 15000);
					this.inventoryModel.activateDependedCooldown(1, 15000);
					this.inventoryModel.activateDependedCooldown(2, 15000);

					break;
				case "armor":
					this.inventoryModel.activateCooldown(1, 15000);
					this.inventoryModel.activateDependedCooldown(2, 30000);
					this.inventoryModel.activateDependedCooldown(3, 15000);
					break;
				case "double_damage":
					this.inventoryModel.activateCooldown(2, 15000);
					this.inventoryModel.activateDependedCooldown(1, 30000);
					this.inventoryModel.activateDependedCooldown(3, 15000);

					break;
				case "n2o":
					this.inventoryModel.activateCooldown(3, 15000);
					this.inventoryModel.activateDependedCooldown(1, 15000);
					this.inventoryModel.activateDependedCooldown(2, 15000);
					break;
				case "mine":
					this.inventoryModel.activateCooldown(4, 30000);
					this.inventoryModel.activateDependedCooldown(1, 15000);
					this.inventoryModel.activateDependedCooldown(2, 15000);
					this.inventoryModel.activateDependedCooldown(0, 15000);
				case "gold":
					this.inventoryModel.activateCooldown(5, 1000);
					break;
			}

		}

		public function enableEffects(clientObject:ClientObject, effects:Array):void
		{
			this.effectModel.initObject(clientObject, effects);

		}

		public function enableEffect(clientObject:ClientObject, itemIndex:int, duration:int):void
		{
			this.effectModel.effectActivated(clientObject, clientObject.id, itemIndex, duration);
			if (clientObject.id == (Main.osgi.getService(IPanel) as PanelModel).userName)
			{
				var time:int = duration;
				if (itemIndex == 1 || itemIndex == 5)
				{
					time = 2000;
				}

				this.inventoryModel.changeEffectTime(itemIndex - 1, time, true, false);
			}

		}

		public function disnableEffect(clientObject:ClientObject, itemIndex:int):void
		{
			this.effectModel.effectStopped(clientObject, clientObject.id, itemIndex);
		}

		public function localTankKilled():void
		{
			if (this.inventoryModel == null)
			{
				return;
			}
			this.inventoryModel.killCurrentUser(null);
		}

		private function getClientObject(id:String):ClientObject
		{
			return (new ClientObject(id, null, id, null));
		}

	}
} // package scpacker.server.models.inventory