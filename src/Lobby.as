package
{
	import alternativa.tanks.services.NewsService;
	import alternativa.tanks.services.NewsServiceImpl;

	import projects.tanks.client.chat.models.news.showing.NewsItemData;

	import logic.networking.INetworkListener;

	import alternativa.init.ChatModelActivator;
	import alternativa.init.BattleSelectModelActivator;
	import alternativa.init.GarageModelActivator;

	import logic.networking.Network;
	import logic.server.models.bonus.ServerBonusModel;

	import alternativa.service.IModelService;
	import alternativa.tanks.model.ItemEffectModel;
	import alternativa.init.Main;
	import alternativa.tanks.model.IItemEffect;
	import alternativa.model.IModel;
	import alternativa.tanks.model.challenge.ChallengeModel;
	import alternativa.tanks.model.challenge.server.ChallengeServerData;
	import alternativa.tanks.model.challenge.ChallengePrizeInfo;

	import forms.Alert;

	import flash.net.SharedObject;

	import projects.tanks.client.battleselect.types.UserInfoClient;

	import alternativa.tanks.model.achievement.AchievementModel;
	import alternativa.tanks.model.news.NewsModel;

	import __AS3__.vec.Vector;

	import alternativa.tanks.model.news.NewsItemServer;
	import alternativa.tanks.model.challenge.server.UserProgressServerData;
	import alternativa.tanks.model.achievement.Achievement;
	import alternativa.tanks.model.gift.server.GiftServerModel;
	import alternativa.tanks.model.ItemParams;

	import com.alternativaplatform.projects.tanks.client.garage.garage.ItemInfo;

	import alternativa.osgi.service.storage.IStorageService;

	import projects.tanks.client.battlefield.gui.models.chat.IChatModelBase;

	import alternativa.tanks.model.user.IUserData;
	import alternativa.tanks.model.user.UserData;

	import logic.networking.commands.Type;

	import alternativa.tanks.model.panel.PanelModel;
	import alternativa.tanks.model.panel.IPanel;

	import flash.net.navigateToURL;
	import flash.net.URLRequest;

	import alternativa.tanks.model.challenge.IChallenge;

	import forms.AlertAnswer;

	import alternativa.tanks.model.Friend;

	import projects.tanks.client.battleservice.model.team.BattleTeamType;

	import alternativa.tanks.model.achievement.IAchievementModel;

	import logic.networking.INetworker;

	import alternativa.tanks.model.profile.server.UserGiftServerItem;
	import alternativa.tanks.model.news.INewsModel;
	import alternativa.tanks.model.gift.server.IGiftServerModel;
	import alternativa.tanks.model.gift.server.GiftServerItem;
	import alternativa.tanks.model.GarageModel;

	import com.alternativaplatform.projects.tanks.client.commons.models.itemtype.ItemTypeEnum;

	import logic.resource.ResourceUtil;
	import logic.resource.ResourceType;
	import logic.networking.commands.Command;

	import com.alternativaplatform.client.models.core.community.chat.types.UserChat;
	import com.alternativaplatform.client.models.core.community.chat.types.ChatMessage;

	import projects.tanks.client.battleservice.model.BattleType;
	import projects.tanks.client.battleselect.types.BattleClient;

	import com.alternativaplatform.projects.tanks.client.garage.item.ModificationInfo;
	import com.alternativaplatform.projects.tanks.client.garage.item.ItemPropertyValue;

	import alternativa.osgi.service.locale.ILocaleService;

	import projects.tanks.client.panel.model.shop.kitpackage.KitPackageItemInfo;

	import alternativa.tanks.gui.shopitems.item.kits.description.KitsInfoData;
	import alternativa.types.Long;
	import alternativa.tanks.model.IGarage;

	import projects.tanks.client.battleselect.types.MapClient;
	import projects.tanks.client.battleselect.IBattleSelectModelBase;

	import com.alternativaplatform.projects.tanks.client.commons.types.ItemProperty;

	import __AS3__.vec.*;

	import alternativa.tanks.gui.ItemInfoPanel;

	import flash.utils.setTimeout;
	import flash.events.TransformGestureEvent;

	import forms.zad.Challenge;
	import forms.itemscategory.skin.SkinType;

	import projects.tanks.client.panel.model.quest.QuestTypeEnum;

	import alternativa.tanks.model.challenge.QuestTabButton;

	import controls.buttons.CategoryButtonSkin;

	import alternativa.tanks.model.BattleSelectModel;

	import forms.itemscategory.shoteffects.ShotEffectType;
	import flash.events.EventDispatcher;
	import forms.events.ContainerWindowEvent;
	import forms.notification.Notification;
	import forms.notification.PremiumNotification;

	public class Lobby extends EventDispatcher implements INetworkListener
	{

		public static var firstInit:Boolean = true;

		private const greenColor:uint = 8454016;
		private const yellowColor:uint = 0xE9FF00;

		public var chat:ChatModelActivator;
		public var battleSelect:BattleSelectModelActivator;
		public var garage:GarageModelActivator;
		private var networker:Network;
		private var chatInited:Boolean = false;
		private var bonusModel:ServerBonusModel = new ServerBonusModel();
		private var modelRegister:IModelService;
		private var itemEffectModel:ItemEffectModel;
		private var listInited:Boolean = false;

		public function Lobby()
		{
			this.chat = new ChatModelActivator();
			this.battleSelect = new BattleSelectModelActivator();
			this.garage = new GarageModelActivator();
			this.garage.start(Main.osgi);
			this.modelRegister = (Main.osgi.getService(IModelService) as IModelService);
			this.itemEffectModel = (((this.modelRegister.getModelsByInterface(IItemEffect) as Vector.<IModel>)[0] as IItemEffect) as ItemEffectModel);
		}

		public function onData(data:Command):void
		{
			var parser:Object;
			var questsModel:ChallengeModel;
			var quest:ChallengeServerData;
			var prizes:Array;
			var p:String;
			var idOldItem:String;
			var special:Object;
			var special2:Object;
			var special3:Object;
			var specQuest:ChallengeServerData;
			var specQuest2:ChallengeServerData;
			var specQuest3:ChallengeServerData;
			var specialPrizes:Array;
			var specialPrizes2:Array;
			var specialPrizes3:Array;
			var _prize:Object;
			var prize:ChallengePrizeInfo;
			var alert:Alert;
			var parserGifts:Object;
			var itemsGift:Array;
			var parserInfo:Object;
			var storage:SharedObject;
			parser = null;
			var info:UserInfoClient;
			var achievementModel:AchievementModel;
			var temp:BattleController;
			var effect:* = undefined;
			var id:String;
			var time:Number = NaN;
			var newsModel:NewsModel;
			var news:Vector.<NewsItemServer>;
			var news_item:* = undefined;
			questsModel = null;
			var progress:UserProgressServerData;
			var quests:Array;
			var q:Object;
			quest = null;
			prizes = null;
			p = null;
			var achievements:Vector.<Achievement>;
			var achievementId:Object;
			var achievement:Achievement;
			var giftsModel:GiftServerModel;
			var items:Array;
			var _item:* = undefined;
			var j:Array;
			var oldItem:ItemParams;
			idOldItem = null;
			var item:ItemParams;
			var item_info:ItemInfo;
			var parser1:Object;
			var mynews:Vector.<NewsItemData>;
			switch (data.type)
			{
				case Type.LOBBY_CHAT:
					if (data.args[0] == "system")
					{
						if ((!(this.chatInited)))
						{
							this.chatInited = true;
						}
						;
						this.chat.chatModel.chatPanel.addMessage("", 0, 0, data.args[1], 0, 0, "", true, ((data.args[2] == "yellow") ? this.yellowColor : this.greenColor));
					}
					else if (data.args[0] == "init_chat")
					{
						storage = IStorageService(Main.osgi.getService(IStorageService)).getStorage();
						if (storage.data.showNewRules)
						{
							return;
						}
						;
						this.bonusModel.showRulesUpdate();
						storage.data.showNewRules = true;
					}
					else if (data.args[0] == "clear_all")
					{
						if ((!(this.chatInited)))
						{
							this.chatInited = true;
						}
						this.chat.chatModel.cleanUsersMessages(null, "");
					}
					else if (data.args[0] == "init_messages")
					{
						Main.osgi.registerService(IChatModelBase, this.chat.chatModel);
						Main.osgi.registerService(NewsService, new NewsServiceImpl());
						this.chat.chatModel.initObject(Game.getInstance.classObject, ["cybertankz.com"], (Main.osgi.getService(IUserData) as UserData).userName);

						parser = JSON.parse(data.args[2]);
						newsModel = (Main.osgi.getService(INewsModel) as NewsModel);
						mynews = new Vector.<NewsItemData>;
						for each (news_item in parser)
						{
							mynews.push(new NewsItemData(news_item.date, news_item.text, 0, String(news_item.header), int(news_item.id), String(news_item.image)));
						}
						this.chat.chatModel.objectLoaded(Game.getInstance.classObject);
						this.chat.chatModel.initNews(mynews);
						this.parseChatMessages(data.args[1]);

						// Main.osgi.registerService(NewsService, new NewsServiceImpl());
						// parser = JSON.parse(data.args[2]);
						// newsModel = (Main.osgi.getService(INewsModel) as NewsModel);
						// mynews = new Vector.<NewsItemData>
						// for each (news_item in parser)
						// {
						// mynews.push(new NewsItemData(news_item.date, news_item.text, 0, String(news_item.header), int(news_item.id), String(news_item.image)));
						// }
						// mynews = new Vector.<NewsItemData>
						// Main.osgi.registerService(IChatModelBase,this.chat.chatModel);
						// this.chat.chatModel.initObject(Game.getInstance.classObject,["vk.com/response_null"],(Main.osgi.getService(IUserData) as UserData).name);
						// this.chat.chatModel.objectLoaded(Game.getInstance.classObject);
						// this.chat.chatModel.initNews(mynews);
						// this.parseChatMessages(data.args[1]);

					}
					else if (data.args[0] == "clean_by")
					{
						this.chat.chatModel.cleanUsersMessages(null, data.args[1]);
					}
					else if (data.args[0] == "clean_by_text")
					{
						this.chat.chatModel.cleanMessages(data.args[1]);
					}
					else
					{
						if ((!(this.chatInited)))
						{
							this.chatInited = true;
						}
						this.parseAndAddMessageToChat(data.args[0]);
					}
					break;
				case Type.LOBBY:
					if (data.args[0] == "container_window")
					{
						dispatchEvent(new ContainerWindowEvent(ContainerWindowEvent.ON_OPEN_CONTAINER_WINDOW_DATA, data.args[1]));
					}
					if (data.args[0] == "container_opened")
					{
						dispatchEvent(new ContainerWindowEvent(ContainerWindowEvent.ON_OPEN_CONTAINER_DATA, data.args[1]));
					}
					if (data.args[0] == "wrong_email_unbinded_code")
					{
						alert = new Alert();
						alert.showAlert("Invalid code", [AlertAnswer.OK]);
						Main.cursorLayer.addChild(alert);
						var userData:UserData = Main.osgi.getService(IUserData) as UserData;
						userData.dispatchUserDataChanged();
					}
					else if (data.args[0] == "email_unbinded")
					{
						var userData:UserData = Main.osgi.getService(IUserData) as UserData;
						userData.isMailConfirmed = false;
						userData.mail = null;
						userData.dispatchUserDataChanged();
					}
					else if (data.args[0] == "mail_changed")
					{
						var userData:UserData = Main.osgi.getService(IUserData) as UserData;
						userData.isMailConfirmed = false;
						userData.mail = data.args[1];
						userData.dispatchUserDataChanged();
					}
					else if (data.args[0] == "wrong_email_confirmation_code")
					{
						var alert:Alert = new Alert();
						alert.showAlert("Invalid code", [AlertAnswer.OK]);
						Main.cursorLayer.addChild(alert);
						var userData1:UserData = Main.osgi.getService(IUserData) as UserData;
						userData1.isMailConfirmed = false;
						userData1.dispatchUserDataChanged();
					}
					else if (data.args[0] == "error_enter_equipment")
					{
						var alert:Alert = new Alert();
						alert.showAlert("Your equipment does not match the battle requirements", [AlertAnswer.OK]);
						Main.cursorLayer.addChild(alert);
					}
					else if (data.args[0] == "email_confirmed")
					{
						var alert:Alert = new Alert();
						Main.cursorLayer.addChild(alert);
						alert.showAlert("Email confirmed", [AlertAnswer.OK]);
						var userData1:UserData = Main.osgi.getService(IUserData) as UserData;
						userData1.isMailConfirmed = true;
						userData1.dispatchUserDataChanged();
					}
					else if (data.args[0] == "password_changed")
					{
						var panelModel:PanelModel = Main.osgi.getService(IPanel) as PanelModel;
						panelModel.passwordChanged();
					}
					else if (data.args[0] == "wrong_old_password")
					{
						var panelModel:PanelModel = Main.osgi.getService(IPanel) as PanelModel;
						panelModel.wrongOldPassword();
					}
					else if (data.args[0] == "init_panel")
					{
						this.parseAndInitPanelInfo(data.args[1]);
					}
					else if (data.args[0] == "stars_count")
					{
						PanelModel(Main.osgi.getService(IPanel)).mainPanel.buttonBar.starCountBut.starsCount = data.args[1];
					}
					else if (data.args[0] == "add_crystall")
					{
						PanelModel(Main.osgi.getService(IPanel)).updateCrystal(null, int(data.args[1]));
					}
					else if (data.args[0] == "add_score")
					{
						PanelModel(Main.osgi.getService(IPanel)).updateScore(null, int(data.args[1]));
					}
					else if (data.args[0] == "update_rang_progress")
					{
						PanelModel(Main.osgi.getService(IPanel)).updateRankProgress(null, int(data.args[1]));
					}
					else if (data.args[0] == "update_rang")
					{
						PanelModel(Main.osgi.getService(IPanel)).updateRang(null, int(data.args[1]), int(data.args[2]), PanelModel(Main.osgi.getService(IPanel)).havePremium);
					}
					else if (data.args[0] == "enable_premium")
					{
						var panelModel:PanelModel = PanelModel(Main.osgi.getService(IPanel));
						panelModel.havePremium = true;
						panelModel.updateRang(null, panelModel.mainPanel.rang, panelModel.nextScore, panelModel.havePremium);
					}
					else if (data.args[0] == "disable_premium")
					{
						var panelModel:PanelModel = PanelModel(Main.osgi.getService(IPanel));
						panelModel.havePremium = false;
						panelModel.updateRang(null, panelModel.mainPanel.rang, panelModel.nextScore, panelModel.havePremium);
						var not:PremiumNotification = null;
						not = new PremiumNotification(Main.stage);
						not.add = "Your premium has expired";
					}
					else if (data.args[0] == "init_battle_select")
					{
						this.parseAndInitBattlesList(data.args[1]);
					}
					else if (data.args[0] == "create_battle")
					{
						this.parseBattle(data.args[1]);
					}
					else if (data.args[0] == "start_battle")
					{
						this.battleSelect.battleSelectModel.startLoadBattle();
					}
					else if (data.args[0] == "check_battle_name")
					{
						this.battleSelect.battleSelectModel.setFilteredBattleName(null, data.args[1]);
					}
					else if (data.args[0] == "show_battle_info")
					{
						this.parseBattleInfo(data.args[1]);
					}
					else if (data.args[0] == "navigate_url")
					{
						navigateToURL(new URLRequest(data.args[1]), "_self");
						PanelModel(Main.osgi.getService(IPanel)).unlock();
					}
					else if (data.args[0] == "show_discount_window")
					{
						PanelModel(Main.osgi.getService(IPanel)).openDiscountWindow(data.args[1], data.args[2], data.args[3]);
					}
					else if (data.args[0] == "show_quests")
					{
						parser = JSON.parse(data.args[1]);
						questsModel = (Main.osgi.getService(IChallenge) as ChallengeModel);
						quest = new ChallengeServerData();
						quest.changeCost = parser.changeCost;
						if (parser.quest1.progress != null)
						{
							special = parser.quest1;
							specQuest = new ChallengeServerData();
							specQuest.description = special.description;
							specQuest.id = special.id;
							specQuest.target_progress = special.target_progress;
							specQuest.progress = special.progress;
							specialPrizes = new Array();
							for each (p in special.prizes)
							{
								specialPrizes.push(p);
							}
							specQuest.prizes = specialPrizes;
							quest.quest1 = specQuest;
						}
						if (parser.quest2.progress != null)
						{
							special2 = parser.quest2;
							specQuest2 = new ChallengeServerData();
							specQuest2.description = special2.description;
							specQuest2.id = special2.id;

							specQuest2.target_progress = special2.target_progress;
							specQuest2.progress = special2.progress;
							specialPrizes2 = new Array();
							for each (p in special2.prizes)
							{
								specialPrizes2.push(p);
							}
							specQuest2.prizes = specialPrizes2;
							quest.quest2 = specQuest2;
						}
						if (parser.quest3.progress != null)
						{
							special3 = parser.quest3;
							specQuest3 = new ChallengeServerData();
							specQuest3.description = special3.description;
							specQuest3.id = special3.id;

							specQuest3.target_progress = special3.target_progress;
							specQuest3.progress = special3.progress;
							specialPrizes3 = new Array();
							for each (p in special3.prizes)
							{
								specialPrizes3.push(p);
							}
							specQuest3.prizes = specialPrizes3;
							quest.quest3 = specQuest3;
						}
						questsModel.show(quest);
						PanelModel(Main.osgi.getService(IPanel)).unlock();
					}
					else if (data.args[0] == "show_new_quests")
					{
						parser = JSON.parse(data.args[1]);
						questsModel = (Main.osgi.getService(IChallenge) as ChallengeModel);
						quest = new ChallengeServerData();

						quest.changeCost = parser.changeCost;
						if (parser.quest1.progress != null)
						{
							special = parser.quest1;
							specQuest = new ChallengeServerData();
							specQuest.description = special.description;
							specQuest.id = special.id;
							specQuest.target_progress = special.target_progress;
							specQuest.progress = special.progress;
							specialPrizes = new Array();
							for each (p in special.prizes)
							{
								specialPrizes.push(p);
							}
							;
							specQuest.prizes = specialPrizes;
							quest.quest1 = specQuest;
						}
						;
						if (parser.quest2.progress != null)
						{
							special2 = parser.quest2;
							specQuest2 = new ChallengeServerData();
							specQuest2.description = special2.description;

							specQuest2.id = special2.id;
							specQuest2.target_progress = special2.target_progress;
							specQuest2.progress = special2.progress;
							specialPrizes2 = new Array();
							for each (p in special2.prizes)
							{
								specialPrizes2.push(p);
							}
							;
							specQuest2.prizes = specialPrizes2;
							quest.quest2 = specQuest2;
						}
						;
						if (parser.quest3.progress != null)
						{
							special3 = parser.quest3;
							specQuest3 = new ChallengeServerData();
							specQuest3.description = special3.description;
							specQuest3.id = special3.id;

							specQuest3.target_progress = special3.target_progress;
							specQuest3.progress = special3.progress;
							specialPrizes3 = new Array();
							for each (p in special3.prizes)
							{
								specialPrizes3.push(p);
							}
							specQuest3.prizes = specialPrizes3;
							quest.quest3 = specQuest3;
						}
						questsModel.updateQuest(quest);
					}
					else if (data.args[0] == "show_quests_bonus")
					{
						parser = JSON.parse(data.args[1]);
						prizes = new Array();
						for each (_prize in parser.prizes)
						{
							prize = new ChallengePrizeInfo();
							prize.count = _prize.count;
							prize.nameId = _prize.nameId;
							prizes.push(prize);
						}
						PanelModel(Main.osgi.getService(IPanel)).openChallegneCongratsWindow(prizes);
					}
					else if (data.args[0] == "init_challenges_panel")
					{
						this.parseBattlePass(data.args[1]);
					}
					else if (data.args[0] == "show_alert_info")
					{
						alert = new Alert();
						alert.showAlert(data.args[1], [AlertAnswer.OK]);
						Main.contentUILayer.addChild(alert);
						PanelModel(Main.osgi.getService(IPanel)).unlock();
					}
					else if (data.args[0] == "init_friends_list")
					{
						Friend.friends = data.args[1];
						PanelModel(Main.osgi.getService(IPanel)).openFriends();
					}
					else if (data.args[0] == "update_friends_list")
					{
						Friend.friends = data.args[1];
						PanelModel(Main.osgi.getService(IPanel)).updateFriendsList();
					}
					else if (data.args[0] == "show_friends_warning")
					{
						PanelModel(Main.osgi.getService(IPanel)).mainPanel.buttonBar.icon.visible = true;
						PanelModel(Main.osgi.getService(IPanel)).friendsCachedId = data.args[1];
					}
					else if (data.args[0] == "update_count_users_in_dm_battle")
					{
						this.battleSelect.battleSelectModel.updateUsersCountForDM(null, data.args[1], data.args[2]);
					}
					else if (data.args[0] == "update_count_users_in_team_battle")
					{
						parser = JSON.parse(data.args[1]);
						this.battleSelect.battleSelectModel.updateUsersCountForTeam(null, parser.battleId, parser.redPeople, parser.bluePeople);
					}
					else if (data.args[0] == "remove_battle")
					{
						this.battleSelect.battleSelectModel.removeBattle(null, data.args[1]);
					}
					else if (data.args[0] == "add_player_to_battle")
					{
						parser = JSON.parse(data.args[1]);
						if (parser.battleId != this.battleSelect.battleSelectModel.selectedBattleId)
						{
							return;
						}
						;
						info = new UserInfoClient();
						info.id = parser.id;
						info.kills = parser.kills;
						info.name = parser.name;
						info.rank = parser.rank;
						info.type = BattleTeamType.getType(parser.type);
						info.isBot = parser.isBot;
						this.battleSelect.battleSelectModel.currentBattleAddUser(null, info);
					}
					else if (data.args[0] == "remove_player_from_battle")
					{
						parser = JSON.parse(data.args[1]);
						if (parser.battleId != this.battleSelect.battleSelectModel.selectedBattleId)
						{
							return;
						}
						this.battleSelect.battleSelectModel.currentBattleRemoveUser(null, parser.id);
					}
					else if (data.args[0] == "server_message")
					{
						Main.debug.showServerMessageWindow(data.args[1]);
					}
					else if (data.args[0] == "show_bonuses")
					{
						this.bonusModel.showBonuses(data.args[1]);
					}
					else if (data.args[0] == "show_no_supplies")
					{
						this.bonusModel.showNoSupplies();
					}
					else if (data.args[0] == "show_double_crystalls")
					{
						this.bonusModel.showDoubleCrystalls();
					}
					else if (data.args[0] == "show_crystalls")
					{
						this.bonusModel.showCrystalls(int(data.args[1]));
					}
					else if (data.args[0] == "show_nube_up_score")
					{
						this.bonusModel.showNewbiesUpScore();
					}
					else if (data.args[0] == "show_nube_new_rank")
					{
						achievementModel = (Main.osgi.getService(IAchievementModel) as AchievementModel);
						achievementModel.showNewRankCongratulationsWindow();
					}
					else if (data.args[0] == "init_battlecontroller")
					{
						PanelModel(Main.osgi.getService(IPanel)).startBattle(null);
						if (BattleController(Main.osgi.getService(IBattleController)) == null)
						{
							temp = new BattleController();
							Main.osgi.registerService(IBattleController, temp);
						}
						if (Main.activatedBattleListener == false)
						{
							Main.activatedBattleListener = true;
							Network(Main.osgi.getService(INetworker)).addEventListener((Main.osgi.getService(IBattleController) as BattleController));
						}
					}
					else if (data.args[0] == "server_halt")
					{
						PanelModel(Main.osgi.getService(IPanel)).serverHalt(null, 50, 0, 0, null);
					}
					else if (data.args[0] == "show_profile")
					{
						parser = JSON.parse(data.args[1]);
						PanelModel(Main.osgi.getService(IPanel)).openProfile(null, parser.emailNotice, parser.isComfirmEmail, false, "", "");
					}
					else if (data.args[0] == "open_profile")
					{
						parserGifts = JSON.parse(data.args[1]).incoming;
						itemsGift = new Array();
						for each (_item in parserGifts)
						{
							itemsGift.push(new UserGiftServerItem(_item.userid, _item.giftid, _item.image, _item.name, _item.status, _item.message, _item.date));
						}
						;
						parserInfo = JSON.parse(data.args[2]);
						PanelModel(Main.osgi.getService(IPanel)).showGiftWindow(itemsGift, parserInfo);
					}
					else if (data.args[0] == "open_shop")
					{
						PanelModel(Main.osgi.getService(IPanel)).onShopWindow(JSON.parse(data.args[1]));
					}
					else if (data.args[0] == "open_url")
					{
						navigateToURL(new URLRequest(data.args[1]), "_self");
					}
					else if (data.args[0] == "donate_successfully")
					{
						PanelModel(Main.osgi.getService(IPanel)).showPurchaseWindow(data.args[1], data.args[2], data.args[3]);
					}
					else if (data.args[0] == "quest_new")
					{
						PanelModel(Main.osgi.getService(IPanel)).showIconQuest(true);
					}
					else if (data.args[0] == "effect_stopped")
					{
						this.itemEffectModel.effectStopped(data.args[1]);
					}
					else if (data.args[0] == "init_effect_model")
					{
						parser = JSON.parse(data.args[1]);
						for each (effect in parser.effects)
						{
							id = effect.id;
							time = effect.time;
							this.itemEffectModel.setRemaining(id, time);
						}
					}
					else if (data.args[0] == "set_reamining_time")
					{
						this.itemEffectModel.setRemaining(data.args[1], data.args[2]);
					}
					else if (data.args[0] == "show_news")
					{
						parser = JSON.parse(data.args[1]);
						newsModel = (Main.osgi.getService(INewsModel) as NewsModel);
						news = new Vector.<NewsItemServer>();
						for each (news_item in parser)
						{
							news.push(new NewsItemServer(news_item.date, news_item.text, news_item.icon_id));
						}
						;
						newsModel.showNews(news);
					}
					else if (data.args[0] == "show_achievements")
					{
						achievementModel = (Main.osgi.getService(IAchievementModel) as AchievementModel);
						parser = JSON.parse(data.args[1]);
						achievements = new Vector.<Achievement>();
						for each (achievementId in parser.ids)
						{
							achievements.push(Achievement.getById((achievementId as int)));
						}
						;
						achievementModel.objectLoaded(achievements);
					}
					else if (data.args[0] == "complete_achievement")
					{
						achievementModel = (Main.osgi.getService(IAchievementModel) as AchievementModel);
						achievement = Achievement.getById(parseInt(data.args[1]));
						achievementModel.completeAchievement(achievement);
					}
					else if (data.args[0] == "update_rating_data")
					{
						PanelModel(Main.osgi.getService(IPanel)).updateRating(null, parseInt(data.args[1]));
						PanelModel(Main.osgi.getService(IPanel)).updatePlace(null, parseInt(data.args[2]));
					}
					else if (data.args[0] == "show_gifts_window")
					{
						parser = JSON.parse(data.args[1]);
						giftsModel = (Main.osgi.getService(IGiftServerModel) as GiftServerModel);
						items = new Array();
						for each (_item in parser)
						{
							items.push(new GiftServerItem(_item.item_id, _item.rarity, _item.count));
						}
						giftsModel.openGiftWindow(items, parseInt(data.args[2]));
					}
					else if (data.args[0] == "item_rolled")
					{
						giftsModel = (Main.osgi.getService(IGiftServerModel) as GiftServerModel);
						giftsModel.doRoll(data.args[1], (JSON.parse(data.args[2]) as Array), data.args[3], data.args[4], parseInt(data.args[5]));
					}
					else if (data.args[0] == "items_rolled")
					{
						giftsModel = (Main.osgi.getService(IGiftServerModel) as GiftServerModel);
						j = (JSON.parse(data.args[1]) as Array);
						giftsModel.doRolls(j);
					}
					break;
				case Type.GARAGE:
					if (data.args[0] == "init_containers")
					{
						parseContainers(data.args[1]);
					}
					else if (data.args[0] == "init_skins_for_item")
					{
						parseSkin(data.args[1]);
					}
					else if (data.args[0] == "update_upgrade_info")
					{
						ItemInfoPanel.instance.doUpgrade(int(data.args[1]), int(data.args[2]));
					}
					else if (data.args[0] == "update_skins_for_item")
					{
						updateSkinWindow(data.args[1]);
					}
					else if (data.args[0] == "init_shot_effects_for_item")
					{
						parseShotEffects(data.args[1]);
					}
					else if (data.args[0] == "update_shot_effects_for_item")
					{
						updateShotEffectsWindow(data.args[1]);
					}
					else if (data.args[0] == "init_garage_items")
					{
						this.parseGarageItems(data.args[1], data.src);
					}
					else if (data.args[0] == "reload")
					{
						PanelModel(Main.osgi.getService(IPanel)).reloadGarage();
					}
					else if (data.args[0] == "init_market")
					{
						this.parseMarket(data.args[1]);
					}
					else if (data.args[0] == "mount_skin")
					{
						oldItem = GarageModel.getItemParamsWithoutModification(data.args[1]);
						var skinData:String;
						if (data.args[2] != "")
						{
							oldItem = GarageModel.getItemParamsWithoutModification(data.args[1]);
							skinData = data.args[2];
						}
						else
						{
							skinData = null;
						}
						if (oldItem.itemType == ItemTypeEnum.ARMOR)
						{
							idOldItem = this.garage.garageModel.mountedArmorId;
						}
						else if (oldItem.itemType == ItemTypeEnum.WEAPON)
						{
							idOldItem = this.garage.garageModel.mountedWeaponId;
						}
						if (ResourceUtil.getResource(ResourceType.IMAGE, "garage_box_img") == null)
						{
							ResourceUtil.addEventListener(function():void
								{
									garage.garageModel.mountItem(null, idOldItem, idOldItem, skinData);
								});
						}
						else
						{
							this.garage.garageModel.mountItem(null, idOldItem, idOldItem, skinData);
						}
					}
					else if (data.args[0] == "mount_item")
					{
						oldItem = GarageModel.getItemParams(data.args[1]);
						var skinData:String;
						if (data.args[1] != data.args[2])
						{
							oldItem = GarageModel.getItemParams(data.args[1]);
							skinData = data.args[2];
						}
						else
						{
							skinData = null;
						}
						if(oldItem.itemType == ItemTypeEnum.ARMOR)
						{
							idOldItem = this.garage.garageModel.mountedArmorId;
						}
						else if(oldItem.itemType == ItemTypeEnum.WEAPON)
						{
							idOldItem = this.garage.garageModel.mountedWeaponId;
						}
						else if(oldItem.itemType == ItemTypeEnum.COLOR)
						{
							idOldItem = this.garage.garageModel.mountedColormapId;
						}
						else if(oldItem.itemType == ItemTypeEnum.RESISTANCE)
						{
							idOldItem = this.garage.garageModel.mountedResistanceId;
						}
						if (ResourceUtil.getResource(ResourceType.IMAGE, "garage_box_img") == null)
						{
							ResourceUtil.addEventListener(function():void
								{
									garage.garageModel.mountItem(null, idOldItem, data.args[1], skinData);
								});
						}
						else
						{
							this.garage.garageModel.mountItem(null, idOldItem, data.args[1], skinData);
						}
					}
					else if (data.args[0] == "update_item")
					{
						GarageModel.replaceItemInfo(data.args[1], data.args[2]);
						GarageModel.replaceItemParams(data.args[1], data.args[2]);
						this.garage.garageModel.upgradeItem(null, data.args[1], GarageModel.getItemInfo(data.args[2]));
					}
					else if (data.args[0] == "init_mounted_item")
					{
						item = GarageModel.getItemParams(data.args[1]);
						this.garage.garageModel.mountItem(null, null, data.args[1], data.args[2]);
					}
					else if (data.args[0] == "buy_item")
					{
						item_info = new ItemInfo();
						parser1 = JSON.parse(data.args[2]);
						item_info.count = parser1.count;
						item_info.itemId = data.args[1];
						item_info.addable = parser1.addable;
						item_info.multicounted = parser1.multicounted;
						this.garage.garageModel.buyItem(null, item_info);
						var item:ItemParams = GarageModel.itemsParams[item_info.itemId];
						if(item != null){
							if (item.itemType == ItemTypeEnum.INVENTORY)
							{
								var index = 0;
								for each (var itemInfoSelect:ItemInfo in this.garage.garageModel.garageWindow.myInventory)
								{
									if (itemInfoSelect.itemId == item_info.itemId)
									{
										this.garage.garageModel.garageWindow.myInventory[index] = item_info;
										break;
									}
									index++;
								}
							}
							this.garage.garageModel.garageWindow.updateItemInfo(item_info.itemId, item_info, item);
						}
					}
					else if (data.args[0] == "remove_item_from_market")
					{
						this.garage.garageModel.removeItemFromStore(data.args[1]);
					}
			}
		}

		private function parseContainers(json:String):void
		{
			var parser:Object = JSON.parse(json);
			trace(json)
			for each (var container:Object in parser.list)
			{
				var infoItem:ItemInfo = new ItemInfo();
				infoItem.itemId = container.id;
				var item = new ItemParams((container.id), container.desc, true, 1, [], ItemTypeEnum.SPECIAL, 0, container.title, 0, null, 0, container.id, 0, 0, null, false, null, false, null, 0, 0, false, "");
				infoItem = new ItemInfo();
				infoItem.addable = false;
				infoItem.count = container.count;
				infoItem.itemId = item.baseItemId;
				if(this.garage.garageModel.garageWindow == null){
					return;
				}
				if (this.garage.garageModel.garageWindow.mySpecialItems.length == 0)
				{
					this.garage.garageModel.initItem(item.baseItemId, item);
					this.garage.garageModel.garageWindow.mySpecialItems.push(infoItem);
				}
				else
				{
					this.garage.garageModel.buyItem(null, infoItem);
					if (item.itemType == ItemTypeEnum.SPECIAL)
					{
						var index = 0;
						for each (var itemInfoSelect:ItemInfo in this.garage.garageModel.garageWindow.mySpecialItems)
						{
							if (itemInfoSelect.itemId == infoItem.itemId)
							{
								this.garage.garageModel.garageWindow.mySpecialItems[index] = infoItem;
								break;
							}
							index++;
						}
					}
					this.garage.garageModel.garageWindow.updateItemInfo(infoItem.itemId, infoItem, item);
				}
				// this.garage.garageModel.initDepot(null, this.garage.garageModel.garageWindow.mySpecialItems);
			}
		}

		private function parseChatMessages(json:String):void
		{
			var obj:Object;
			var user:UserChat;
			var msg:ChatMessage;
			var parser:Object = JSON.parse(json);
			var msgs:Array = new Array();
			var userTo:UserChat;
			for each (obj in parser.messages)
			{
				user = new UserChat();
				user.rankIndex = obj.rang;
				user.chatPermissions = obj.chatPermissions;
				user.uid = obj.name;
				user.isPremium = obj.isPremium;
				if (obj.addressed)
				{
					userTo = new UserChat();
					userTo.uid = obj.nameTo;
					userTo.chatPermissions = obj.chatPermissionsTo;
					userTo.rankIndex = obj.rangTo;
					userTo.isPremium = obj.isPremiumTo;
				}
				msg = new ChatMessage();
				msg.sourceUser = user;
				msg.system = obj.system;
				msg.targetUser = userTo;
				msg.text = obj.message;
				msg.sysCollor = ((Boolean(obj.yellow)) ? uint(this.yellowColor) : uint(this.greenColor));
				msgs.push(msg);
				userTo = null;
			}
			this.chat.chatModel.showMessages(null, msgs);
		}

		private function parseBattleInfo(json:String):void
		{
			var user_obj:Object;
			var usr:UserInfoClient;
			var obj:Object = JSON.parse(json);
			if (obj.null_battle)
			{
				return;
			}
			var users:Array = new Array();
			for each (user_obj in obj.users_in_battle)
			{
				usr = new UserInfoClient();
				usr.id = String(user_obj.nickname);
				usr.kills = int(user_obj.kills);
				usr.name = String(user_obj.nickname);
				usr.rank = int(user_obj.rank);
				usr.type = BattleTeamType.getType(user_obj.team_type);
				usr.isBot = user_obj.isBot;
				users.push(usr);
			}
			this.battleSelect.battleSelectModel.showBattleInfo(null, obj.name, obj.maxPeople, BattleType.getType(obj.type), obj.battleId, obj.previewId, obj.minRank, obj.maxRank, obj.timeLimit, obj.timeCurrent, obj.killsLimit, obj.scoreRed, obj.scoreBlue, obj.autobalance, obj.frielndyFie, users, obj.paidBattle, obj.withoutBonuses, obj.userAlreadyPaid, obj.fullCash, ((!(obj.clanName == null)) ? obj.clanName : ""), obj.spectator);
			this.battleSelect.battleSelectModel.selectedBattleId = obj.battleId;
		}

		public function parseSkin(json:String):void
		{
			var parser:Object = JSON.parse(json);
			var hasEquippedSkin:Boolean = false;
			var equippedSkinId:String = "default";
			for each (var skin:Object in parser)
			{
				if (skin.equipped)
				{
					hasEquippedSkin = true;
					equippedSkinId = skin.skin;
				}
				if ((skin.skin as String).split("_")[1].toLowerCase() != "xt")
				{
					// TODO: Do not rely on xt skin existance
					ItemInfoPanel.skinButton.skinWindow.parseSkin(new SkinType(skin.title, skin.desc, skin.skin, skin.equipped, skin.price, skin.bought));
				}
			}
			ItemInfoPanel.skinButton.skinWindow.init(parser[0].title, parser[0].desc, parser[0].skin);

			ItemInfoPanel.skinButton.skinWindow.configXT(parser[0].price, parser[0].equipped, parser[0].bought);
			ItemInfoPanel.skinButton.skinWindow.configDefault(!hasEquippedSkin);

			ItemInfoPanel.skinButton.skinWindow.show();
			ItemInfoPanel.skinButton.skinWindow.destroySkins();
			ItemInfoPanel.skinButton.skinWindow.reconfigureSkins();
		}

		public function updateSkinWindow(json:String):void
		{
			ItemInfoPanel.skinButton.skinWindow.destroySkins();
			ItemInfoPanel.skinButton.skinWindow.hide();
			ItemInfoPanel.skinButton.removeAll();
			ItemInfoPanel.skinButton.sd(null, true);

			var parser:Object = JSON.parse(json);
			var equippedIndex:int = 0;
			var equippedSkinId:String = "default";
			for each (var skin:Object in parser)
			{
				if (skin.equipped)
				{
					equippedIndex = -1;
					equippedSkinId = skin.skin;
				}
				if ((skin.skin as String).split("_")[1].toLowerCase() != "xt")
				{
					ItemInfoPanel.skinButton.skinWindow.parseSkin(new SkinType(skin.title, skin.desc, skin.skin, skin.equipped, skin.price, skin.bought));
				}
			}
			ItemInfoPanel.skinButton.skinWindow.init(parser[0].title, parser[0].desc, parser[0].skin);
			ItemInfoPanel.skinButton.id = ItemInfoPanel.instance.selectedItemParams.baseItemId;

			ItemInfoPanel.skinButton.skinWindow.configXT(parser[0].price, parser[0].equipped, parser[0].bought);
			ItemInfoPanel.skinButton.skinWindow.configDefault(equippedIndex == -1 ? false : true);

			ItemInfoPanel.skinButton.skinWindow.show();
			ItemInfoPanel.skinButton.skinWindow.destroySkins();
			ItemInfoPanel.skinButton.skinWindow.reconfigureSkins();

			var itemParams:ItemParams = ItemParams(GarageModel.itemsParams[ItemInfoPanel.instance.selectedItemParams.baseItemId]);
			ItemParams(GarageModel.itemsParams[ItemInfoPanel.instance.selectedItemParams.baseItemId]).equippedSkin = equippedSkinId;
			ItemInfoPanel.instance.updateSkinButton(itemParams);
		}

		public function parseShotEffects(json:String):void
		{
			var parser:Object = JSON.parse(json);
			var hasEquippedSkin:Boolean = false;
			var equippedSkinId:String = "default";
			for each (var skin:Object in parser)
			{
				if (skin.equipped)
				{
					hasEquippedSkin = true;
					equippedSkinId = skin.shotEffect;
				}
				ItemInfoPanel.shotEffectsButton.skinWindow.parseSkin(new ShotEffectType(skin.title, skin.desc, skin.shotEffect, skin.equipped, skin.price, skin.bought));
			}
			ItemInfoPanel.shotEffectsButton.skinWindow.init(ItemInfoPanel.instance.selectedItemParams.baseItemId);

			ItemInfoPanel.shotEffectsButton.skinWindow.configDefault(!hasEquippedSkin);

			ItemInfoPanel.shotEffectsButton.skinWindow.show();
			ItemInfoPanel.shotEffectsButton.skinWindow.destroySkins();
			ItemInfoPanel.shotEffectsButton.skinWindow.reconfigureSkins();
		}

		public function updateShotEffectsWindow(json:String):void
		{
			ItemInfoPanel.shotEffectsButton.skinWindow.destroySkins();
			ItemInfoPanel.shotEffectsButton.skinWindow.hide();
			ItemInfoPanel.shotEffectsButton.removeAll();
			ItemInfoPanel.shotEffectsButton.sd(null, true);

			var parser:Object = JSON.parse(json);
			var equippedIndex:int = 0;
			var equippedSkinId:String = "default";
			for each (var skin:Object in parser)
			{
				if (skin.equipped)
				{
					equippedIndex = -1;
					equippedSkinId = skin.shotEffect;
				}
				ItemInfoPanel.shotEffectsButton.skinWindow.parseSkin(new ShotEffectType(skin.title, skin.desc, skin.shotEffect, skin.equipped, skin.price, skin.bought));
			}
			ItemInfoPanel.shotEffectsButton.skinWindow.init(ItemInfoPanel.instance.selectedItemParams.baseItemId);
			ItemInfoPanel.shotEffectsButton.id = ItemInfoPanel.instance.selectedItemParams.baseItemId;

			ItemInfoPanel.shotEffectsButton.skinWindow.configDefault(equippedIndex == -1 ? false : true);

			ItemInfoPanel.shotEffectsButton.skinWindow.show();
			ItemInfoPanel.shotEffectsButton.skinWindow.destroySkins();
			ItemInfoPanel.shotEffectsButton.skinWindow.reconfigureSkins();

			var itemParams:ItemParams = ItemParams(GarageModel.itemsParams[ItemInfoPanel.instance.selectedItemParams.baseItemId]);
			ItemParams(GarageModel.itemsParams[ItemInfoPanel.instance.selectedItemParams.baseItemId]).equippedShotEffect = equippedSkinId;
			ItemInfoPanel.instance.updateShotEffectsButton(itemParams);
		}

		public function parseBattlePass(json:String):void
		{
			var parser:Object = JSON.parse(json);
			var currStars:int = parser.stars;
			var battlePassActive:Boolean = parser.isBattlePassActive == "true";
			var leftTime:int = parser.leftMinutes;
			var tiers:Array = parser.tiers;
			var lastTierStars:int = 0;
			var currentTierSelect:int = 1;
			var questsModel:ChallengeModel = (Main.osgi.getService(IChallenge) as ChallengeModel);
			for each (var tier:Object in tiers)
			{
				var tierStarsCount:int = tier.stars;
				if (currStars >= tierStarsCount)
				{
					currentTierSelect++;
					nextTier = tierStarsCount;
					questsModel.window.challengeInfo.list.part = currentTierSelect;
					lastTierStars = tierStarsCount;
				}
				else
				{
					nextTier = tierStarsCount;
					questsModel.window.challengeInfo.list.part = currentTierSelect;
					lastTierStars = tierStarsCount;
				}
			}
			var currentTier:int = 1;
			var currentTierStars:int = 0;
			var nextTier:int = 0;
			var elementTier:int = 0;
			for each (var tier:Object in tiers)
			{
				questsModel.window.challengeInfo.list.prem = battlePassActive;
				var tierStars:int = tier.stars;
				if (currStars >= tierStars)
				{
					currentTier++;
					currentTierStars = tierStars;
				}
				else
				{
					if (nextTier == 0)
					{
						nextTier = tierStars;
					}
				}
				elementTier++;
				var baseItem:Object = tier.base;
				var battlePassItem:Object = tier.battlePass;
				var baseItemId:String = baseItem.itemId;
				var baseItemName:String = baseItem.itemName;
				var baseItemCount:int = int(baseItem.count);
				var battlePassItemId:String = battlePassItem.itemId;
				var battlePassItemName:String = battlePassItem.itemName;
				var battlePassItemCount:int = int(battlePassItem.count);
				questsModel.window.challengeInfo.list.addItem(null, baseItemName, 0, elementTier, baseItemCount, baseItemId, null, battlePassItemName, 0, elementTier, battlePassItemCount, battlePassItemId);
			}
			questsModel.window.challengeInfo.inf(currStars, nextTier, currentTier, currentTierStars, lastTierStars);
			questsModel.window.challengeInfo.chas(leftTime * 60, leftTime * 60);

			// (questsModel.window.navigateTabPanel.questCategoryToButton[QuestTypeEnum.CHALLENGE] as QuestTabButton).enabled = true; //ENABLE DAILY
			// (questsModel.window.navigateTabPanel.questCategoryToButton[QuestTypeEnum.CHALLENGE] as QuestTabButton).setSkin(CategoryButtonSkin.createActiveButtonSkin());

			// questsModel.window.selectTab(QuestTypeEnum.CHALLENGE);
			// questsModel.window.navigateTabPanel.selectTabButton(QuestTypeEnum.CHALLENGE);
			//(questsModel.window.navigateTabPanel.questCategoryToButton[QuestTypeEnum.DAILY] as QuestTabButton).enabled = false;
		}

		private function parseBattle(json:String):void
		{
			var parser:Object = JSON.parse(json);
			var battle:BattleClient = new BattleClient();
			battle.battleId = parser.battleId;
			battle.mapId = parser.mapId;
			battle.name = parser.name;
			battle.team = parser.team;
			battle.countRedPeople = parser.redPeople;
			battle.countBluePeople = parser.bluePeople;
			battle.countPeople = parser.countPeople;
			battle.maxPeople = parser.maxPeople;
			battle.minRank = parser.minRank;
			battle.maxRank = parser.maxRank;
			battle.paid = parser.isPaid;
			this.battleSelect.battleSelectModel.addBattle(null, battle);
		}

		private function initMarket(json:String):void
		{
			if (BattleSelectModel(Main.osgi.getService(IBattleSelectModelBase)) != null)
			{
				BattleSelectModel(Main.osgi.getService(IBattleSelectModelBase)).objectUnloaded(null);
			}
			var obj:Object;
			var modifications:Array;
			var obj2:Object;
			var id:int;
			var item:ItemParams;
			var infoItem:ItemInfo;
			var props:Array;
			var prop:Object;
			var info:ModificationInfo;
			var pid:String;
			var p:ItemPropertyValue;
			var parser:Object = JSON.parse(json);
			var items:Array = new Array();
			for each (obj in parser.items)
			{
				modifications = new Array();
				for each (obj2 in obj.modification)
				{
					props = new Array();
					for each (prop in obj2.properts)
					{
						p = new ItemPropertyValue();
						p.property = this.getItemProperty(prop.property);
						p.value = prop.value;
						props.push(p);
					}
					info = new ModificationInfo();
					info.crystalPrice = obj2.price;
					info.rankId = obj2.rank;
					info.previewId = obj2.previewId;
					pid = obj2.previewId;
					info.itemProperties = props;
					modifications.push(info);
				}
				if (obj.json_kit_info != null)
				{
					this.parseKitInfo(((obj.id + "_m") + obj.modificationID), JSON.parse(obj.json_kit_info), obj.discount);
				}
				id = obj.modificationID;
				item = new ItemParams(((obj.id + "_m") + id), obj.description, obj.isInventory, obj.index, props, this.getTypeItem(obj.type), obj.modificationID, obj.name, obj.next_price, null, obj.next_rank, modifications[id].previewId, obj.price, obj.rank, modifications, true, obj.skins, obj.has_skins, obj.equippedSkin, obj.microUpgradePrice, obj.microUpgrades, obj.has_shot_effects, obj.equippedShotEffect);
				infoItem = new ItemInfo();
				infoItem.count = obj.count;
				infoItem.itemId = item.baseItemId;
				infoItem.discount = obj.discount;
				infoItem.multicounted = obj.multicounted;
				this.garage.garageModel.initItem(item.baseItemId, item);
				if (this.garage.garageModel.garageWindow == null)
				{
					this.garage.garageModel.objectLoaded(null);
				}
				if (this.getTypeItem(obj.type) == ItemTypeEnum.WEAPON)
				{
					this.garage.garageModel.garageWindow.storeTurrets.push(infoItem);
				}
				else if (this.getTypeItem(obj.type) == ItemTypeEnum.ARMOR)
				{
					this.garage.garageModel.garageWindow.storeHulls.push(infoItem);
				}
				else if (this.getTypeItem(obj.type) == ItemTypeEnum.COLOR)
				{
					this.garage.garageModel.garageWindow.storeColormaps.push(infoItem);
				}
				else if (((this.getTypeItem(obj.type) == ItemTypeEnum.INVENTORY)))
				{
					this.garage.garageModel.garageWindow.storeInventory.push(infoItem);
				}
				else if (this.getTypeItem(obj.type) == ItemTypeEnum.KIT)
				{
					this.garage.garageModel.garageWindow.storeKits.push(infoItem);
				}
				else if (this.getTypeItem(obj.type) == ItemTypeEnum.SPECIAL)
				{
					this.garage.garageModel.garageWindow.storeSpecial.push(infoItem);
				}
				else if (this.getTypeItem(obj.type) == ItemTypeEnum.RESISTANCE)
				{
					this.garage.garageModel.garageWindow.storeResistance.push(infoItem);
				}

			}
			this.garage.garageModel.initMarket(null, this.garage.garageModel.garageWindow.storeTurrets);
			this.garage.garageModel.initMarket(null, this.garage.garageModel.garageWindow.storeHulls);
			this.garage.garageModel.initMarket(null, this.garage.garageModel.garageWindow.storeColormaps);
			this.garage.garageModel.initMarket(null, this.garage.garageModel.garageWindow.storeResistance);
			this.garage.garageModel.initMarket(null, this.garage.garageModel.garageWindow.storeInventory);
			this.garage.garageModel.initMarket(null, this.garage.garageModel.garageWindow.storeKits);
			this.garage.garageModel.initMarket(null, this.garage.garageModel.garageWindow.storeSpecial);
			this.garage.garageModel.objectLoaded(null);

		}

		private function parseKitInfo(key:String, kitInfos:Object, discount:int):void
		{
			var infoObj:Object;
			var kitPackage:Vector.<KitPackageItemInfo> = new Vector.<KitPackageItemInfo>();
			for each (infoObj in kitInfos)
			{
				kitPackage.push(new KitPackageItemInfo(1, infoObj.price, infoObj.name));
			}
			KitsInfoData.setData(key, kitPackage, discount);
		}

		private function parseMarket(json:String):void
		{
			if ((((!(ResourceUtil.resourceLoaded)) || (ResourceUtil.getResource(ResourceType.IMAGE, "garage_box_img", true) == null)) || (ResourceUtil.getResource(ResourceType.IMAGE, "zeus_m0_preview", true) == null)))
			{
				ResourceUtil.addEventListener(function():void
					{
						parseMarket(json);
					});
			}
			else
			{
				this.initMarket(json);
			}
		}

		public function parseGarageItems(json:String, src:String = null):void
		{
			if ((((!(ResourceUtil.resourceLoaded)) || (ResourceUtil.getResource(ResourceType.IMAGE, "garage_box_img", true) == null)) || (ResourceUtil.getResource(ResourceType.IMAGE, "zeus_m0_preview", true) == null)))
			{
				ResourceUtil.addEventListener(function():void
					{
						parseGarageItems(json, src);
					});
			}
			else
			{
				this.initGarageItems(json, src);
			}
		}

		private function initGarageItems(json:String, src:String = null):void
		{
			var parser:Object;
			var items:Array;
			var obj:Object;
			var modifications:Array;
			var obj2:Object;
			var id:int;
			var item:ItemParams;
			var infoItem:ItemInfo;
			var props:Array;
			var prop:Object;
			var info:ModificationInfo;
			var pid:String;
			var p:ItemPropertyValue;
			this.garage.garageModel.initObject(Game.getInstance.classObject, "english", 1000000, new Long(100, 100), this.networker);
			try
			{
				parser = JSON.parse(json);
				items = new Array();
				for each (obj in parser.items)
				{
					modifications = new Array();
					for each (obj2 in obj.modification)
					{
						props = new Array();
						for each (prop in obj2.properts)
						{
							p = new ItemPropertyValue();
							p.property = this.getItemProperty(prop.property);
							p.value = prop.value;
							props.push(p);
						}
						info = new ModificationInfo();
						info.crystalPrice = obj2.price;
						info.rankId = obj2.rank;
						info.previewId = obj2.previewId;
						pid = obj2.previewId;
						info.itemProperties = props;
						modifications.push(info);
					}
					id = obj.modificationID;
					item = new ItemParams(((obj.id + "_m") + id), obj.description, obj.isInventory, obj.index, props, this.getTypeItem(obj.type), obj.modificationID, obj.name, obj.next_price, null, obj.next_rank, modifications[id].previewId, obj.price, obj.rank, modifications, false, obj.skins, obj.has_skins, obj.equippedSkin, obj.microUpgradePrice, obj.microUpgrades, obj.has_shot_effects, obj.equippedShotEffect);
					infoItem = new ItemInfo();
					if (this.getTypeItem(obj.type) != ItemTypeEnum.ARMOR)
					{
						if (this.getTypeItem(obj.type) != ItemTypeEnum.WEAPON)
						{
							if (this.getTypeItem(obj.type) == ItemTypeEnum.COLOR)
							{
							}
						}
					}
					infoItem.count = obj.count;
					infoItem.itemId = item.baseItemId;
					infoItem.discount = obj.discount;
					infoItem.multicounted = obj.multicounted;
					this.garage.garageModel.initItem(item.baseItemId, item);
					if (this.getTypeItem(obj.type) == ItemTypeEnum.WEAPON)
					{
						this.garage.garageModel.garageWindow.myTurrets.push(infoItem);
					}
					else if (this.getTypeItem(obj.type) == ItemTypeEnum.ARMOR)
					{
						this.garage.garageModel.garageWindow.myHulls.push(infoItem);
					}
					else if (this.getTypeItem(obj.type) == ItemTypeEnum.COLOR)
					{
						this.garage.garageModel.garageWindow.myColormaps.push(infoItem);
					}
					else if (this.getTypeItem(obj.type) == ItemTypeEnum.INVENTORY)
					{
						this.garage.garageModel.garageWindow.myInventory.push(infoItem);
					}
					else if (this.getTypeItem(obj.type) == ItemTypeEnum.RESISTANCE)
					{
						this.garage.garageModel.garageWindow.myResistance.push(infoItem);
					}
				}
				this.garage.garageModel.initDepot(null, this.garage.garageModel.garageWindow.myHulls);
				this.garage.garageModel.initDepot(null, this.garage.garageModel.garageWindow.myColormaps);
				this.garage.garageModel.initDepot(null, this.garage.garageModel.garageWindow.myResistance);
				this.garage.garageModel.initDepot(null, this.garage.garageModel.garageWindow.myInventory);
				this.garage.garageModel.initDepot(null, this.garage.garageModel.garageWindow.myTurrets);
				Network(Main.osgi.getService(INetworker)).send("garage;get_garage_data");
				Network(Main.osgi.getService(INetworker)).send("garage;get_containers");
				PanelModel(Main.osgi.getService(IPanel)).addListener(this.garage.garageModel);
				Main.osgi.registerService(IGarage, this.garage.garageModel);
				PanelModel(Main.osgi.getService(IPanel)).isGarageSelect = true;
				// garage.garageModel.objectLoaded(Game.getInstance.classObject);
			}
			catch (e:Error)
			{
				throw (new Error(("Watafak " + e.getStackTrace())));
			}
		}

		public function parseAndInitBattlesList(json:String):void
		{
			if (BattleSelectModel(Main.osgi.getService(IBattleSelectModelBase)) != null)
			{
				BattleSelectModel(Main.osgi.getService(IBattleSelectModelBase)).objectUnloaded(null);
			}
			var obj1:Object;
			var btl:Object;
			var map:MapClient;
			var battle:BattleClient;
			Main.osgi.registerService(IBattleSelectModelBase, this.battleSelect.battleSelectModel);
			var maps:Array = new Array();
			var battles:Array = new Array();
			var js:Object = JSON.parse(json);
			for each (obj1 in js.items)
			{
				map = new MapClient();
				map.ctf = obj1.ctf;
				map.gameName = obj1.gameName;
				map.id = obj1.id;
				map.maxPeople = obj1.maxPeople;
				map.maxRank = obj1.maxRank;
				map.minRank = obj1.minRank;
				map.name = obj1.name;
				map.previewId = (obj1.id + "_preview");
				map.tdm = obj1.tdm;
				map.dom = obj1.dom;
				map.hr = obj1.hr;
				map.themeName = obj1.themeName;
				maps.push(map);
			}
			for each (btl in js.battles)
			{
				battle = new BattleClient();
				battle.battleId = btl.battleId;
				battle.mapId = btl.mapId;
				battle.name = btl.name;
				battle.type = btl.type;
				battle.team = btl.team;
				battle.countRedPeople = btl.redPeople;
				battle.countBluePeople = btl.bluePeople;
				battle.countPeople = btl.countPeople;
				battle.maxPeople = btl.maxPeople;
				battle.minRank = btl.minRank;
				battle.maxRank = btl.maxRank;
				battle.paid = btl.isPaid;
				battles.push(battle);
			}
			this.battleSelect.battleSelectModel.initObject(null, 10, js.haveSubscribe, maps);
			this.battleSelect.battleSelectModel.initBattleList(null, battles, js.recommendedBattle, false);
			if ((!(this.listInited)))
			{
				this.listInited = true;
			}
		}

		public function parseAndAddMessageToChat(json:String):void
		{
			var parser:Object = JSON.parse(json);
			var username:String = parser.name;
			var rang:int = parser.rang;
			var chatPermissions:int = parser.chatPermissions;
			var text:String = parser.message;
			var rangTo:int = parser.rangTo;
			var chatPermissionsTo:int = parser.chatPermissionsTo;
			var newVar:* = (parser.nameTo == "NULL") ? "" : parser.nameTo;
			var system:Boolean = parser.system;
			this.chat.chatModel.chatPanel.addMessage(username,rang,
					chatPermissions, text, rangTo, chatPermissionsTo, newVar, system, 8454016, parser.isPremium, parser.isPremiumTo);
		}

		public function parseAndInitPanelInfo(json:String):void
		{
			var obj:Object = JSON.parse(json);
			this.initPanel(obj.crystall, obj.email, obj.tester,
					obj.userId, obj.name, obj.next_score,
					obj.place, obj.rang, obj.rating, obj.score,
					obj.isPremium, obj.isEmailConfirmed, obj.friendsCachedId);
		}

		private function initPanel(crystall:int, email:String,
				tester:Boolean, userId:Number,
				nickname:String, nextScore:int,
				place:int, rang:int,
				rating:int, score:int,
				premiumAccount:Boolean,
				isMailConfirmed:Boolean,
				friendsCachedId:String):void
		{
			var modelPanel:PanelModel = PanelModel(Main.osgi.getService(IPanel));
			modelPanel.initObject(Game.getInstance.classObject, crystall, email, tester, nickname, nextScore, place, rang, rating, score, premiumAccount);
			modelPanel.lock();
			modelPanel.friendsCachedId = friendsCachedId;
			var storage:SharedObject = SharedObject.getLocal("FriendsModel");
			if (storage.data["friendsCachedId"] != friendsCachedId && friendsCachedId != null && friendsCachedId != "" && friendsCachedId != "[]")
			{
				modelPanel.mainPanel.buttonBar.icon.visible = true;
			}
			var user1:UserData = new UserData(userId, nickname, rang, email, isMailConfirmed, premiumAccount);
			Main.osgi.registerService(IUserData, user1);
			this.init();
		}

		public function beforeAuth():void
		{
			this.networker = (Main.osgi.getService(INetworker) as Network);
			this.networker.addEventListener(this);
		}

		private function init():void
		{
			this.chat.start(Game.getInstance.osgi);
			this.battleSelect.start(Game.getInstance.osgi);
		}

		public function getItemProperty(src:String):ItemProperty
		{
			switch (src)
			{
				case "damage":
					return (ItemProperty.DAMAGE);
				case "damage_per_second":
					return (ItemProperty.DAMAGE_PER_SECOND);
				case "critical_chance":
					return (ItemProperty.CRITICAL_CHANCE);
				case "heating_time":
					return (ItemProperty.HEATING_TIME);
				case "aiming_error":
					return (ItemProperty.AIMING_ERROR);
				case "cone_angle":
					return (ItemProperty.CONE_ANGLE);
				case "shot_area":
					return (ItemProperty.SHOT_AREA);
				case "shot_frequency":
					return (ItemProperty.SHOT_FREQUENCY);
				case "shot_range":
					return (ItemProperty.SHOT_RANGE);
				case "turn_speed":
					return (ItemProperty.TURN_SPEED);
				case "mech_resistance":
					return (ItemProperty.MECH_RESISTANCE);
				case "plasma_resistance":
					return (ItemProperty.PLASMA_RESISTANCE);
				case "rail_resistance":
					return (ItemProperty.RAIL_RESISTANCE);
				case "terminator_resistance":
					return (ItemProperty.TERMINATOR_RESISTANCE);
				case "mine_resistance":
					return (ItemProperty.MINE_RESISTANCE);
				case "vampire_resistance":
					return (ItemProperty.VAMPIRE_RESISTANCE);
				case "armor":
					return (ItemProperty.ARMOR);
				case "turret_turn_speed":
					return (ItemProperty.TURRET_TURN_SPEED);
				case "fire_resistance":
					return (ItemProperty.FIRE_RESISTANCE);
				case "thunder_resistance":
					return (ItemProperty.THUNDER_RESISTANCE);
				case "freeze_resistance":
					return (ItemProperty.FREEZE_RESISTANCE);
				case "ricochet_resistance":
					return (ItemProperty.RICOCHET_RESISTANCE);
				case "healing_radius":
					return (ItemProperty.HEALING_RADUIS);
				case "heal_rate":
					return (ItemProperty.HEAL_RATE);
				case "vampire_rate":
					return (ItemProperty.VAMPIRE_RATE);
				case "speed":
					return (ItemProperty.SPEED);
				case "shaft_damage":
					return (ItemProperty.SHAFT_DAMAGE);
				case "shaft_shot_frequency":
					return (ItemProperty.SHAFT_FIRE_RATE);
				case "shaft_resistance":
					return (ItemProperty.SHAFT_RESISTANCE);
				default:
					return (null);
			}
		}

		public function getTypeItem(sct:int):ItemTypeEnum
		{
			switch (sct)
			{
				case 2:
					return (ItemTypeEnum.ARMOR);
				case 1:
					return (ItemTypeEnum.WEAPON);
				case 3:
					return (ItemTypeEnum.COLOR);
				case 4:
					return (ItemTypeEnum.INVENTORY);
				case 5:
					return (ItemTypeEnum.SPECIAL);
				case 6:
					return (ItemTypeEnum.KIT);
				case 7:
					return (ItemTypeEnum.RESISTANCE);
				default:
					return (null);
			}
		}

	}
}
