﻿package alternativa.tanks.models.battlefield.gui.statistics.fps
{

	import alternativa.init.Main;
	import alternativa.tanks.model.PingService;
	import controls.Label;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import logic.networking.INetworker;
	import logic.networking.Network;

	public class FPSText extends Sprite
	{

		private static const MAX_FPS:int = 1000;

		private static const MIN_PING:int = 0;

		private static const MAX_PING:int = 999;

		private static const DELTA_LINE:int = 19;

		private static const OFFSET_X:int = 50 + 8;

		private static const OFFSET_Y:int = 74 + DELTA_LINE;

		private static const VALUE_OFFSET_X:int = 40 + 8;

		private static const NUM_FRAMES:int = 10;

		private static const glowFilter:GlowFilter = new GlowFilter(0, 0.8, 4, 4, 3);

		private var fpsLabel:Label;

		private var fpsValue:Label;

		private var pingLabel:Label;

		private var pingValue:Label;

		private var counter:int;

		private var time:int;

		private var inited:Boolean = false;

		private var timer:Timer;

		public function FPSText()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
		}

		private function init():void
		{
			if (!this.inited)
			{
				this.fpsLabel = new Label();
				this.fpsLabel.autoSize = TextFieldAutoSize.LEFT;
				this.fpsLabel.color = 16777215;
				this.fpsLabel.text = "FPS: ";
				this.fpsLabel.selectable = false;
				addChild(this.fpsLabel);
				this.fpsValue = new Label();
				this.fpsValue.autoSize = TextFieldAutoSize.LEFT;
				this.fpsValue.color = int("0x00FF00");
				this.fpsValue.text = MAX_FPS.toString();
				this.fpsValue.selectable = false;
				addChild(this.fpsValue);
				this.pingLabel = new Label();
				this.pingLabel.autoSize = TextFieldAutoSize.LEFT;
				this.pingLabel.color = 16777215;
				this.pingLabel.text = "PING: ";
				this.pingLabel.selectable = false;
				this.pingLabel.x = -7;
				this.pingLabel.y = DELTA_LINE;
				addChild(this.pingLabel);
				this.pingValue = new Label();
				this.pingValue.autoSize = TextFieldAutoSize.LEFT;
				this.pingValue.color = int("0x00FF00");
				this.pingValue.text = MIN_PING.toString();
				this.pingValue.selectable = false;
				this.pingValue.y = DELTA_LINE;
				addChild(this.pingValue);
				filters = [glowFilter];
				this.inited = true;
				this.timer = new Timer(1000);
				this.timer.addEventListener(TimerEvent.TIMER, this.sendRequest);
				this.timer.start();

			}
		}

		private function sendRequest(e:TimerEvent):void
		{
			Network(Main.osgi.getService(INetworker)).send("battle;ping");
			PingService.setReqTime();
		}

		private function onAddedToStage(param1:Event):void
		{
			this.init();
			this.onResize();
			this.counter = 0;
			this.time = getTimer();
			stage.addEventListener(Event.ENTER_FRAME, this.onEnterFrame, false, 0, false);
			stage.addEventListener(Event.RESIZE, this.onResize);
			removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
		}

		private function onRemovedFromStage(param1:Event):void
		{
			stage.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
			stage.removeEventListener(Event.RESIZE, this.onResize);
			removeEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
			addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
		}

		private function onEnterFrame(param1:Event):void
		{
			var _loc2_:int = 0;
			var _loc3_:Number = NaN;
			var _loc4_:Number = NaN;
			if (++this.counter >= NUM_FRAMES)
			{
				_loc2_ = getTimer();
				_loc3_ = 1000 * this.counter / (_loc2_ - this.time);
				if (_loc3_ > MAX_FPS)
				{
					_loc3_ = MAX_FPS;
				}
				this.fpsValue.text = Math.round(_loc3_).toString();
				this.fpsValue.x = VALUE_OFFSET_X - this.fpsValue.width;
				if (_loc3_ > 30)
				{
					if (_loc3_ < 60)
					{
						this.fpsValue.color = this.interpolateColor(int("0xFFFF00"), int("0x00FF00"), (_loc3_ - 30) / (60 - 30));
					}
					else
					{
						this.fpsValue.color = int("0x00FF00");
					}
				}
				else if (_loc3_ > 15)
				{
					this.fpsValue.color = this.interpolateColor(int("0XF03416"), int("0XFFFF00"), (_loc3_ - 15) / (30 - 15));
				}
				else
				{
					this.fpsValue.color = int("0XF03416");
				}
				this.time = _loc2_;
				this.counter = 0;
				_loc4_ = PingService.getPing();
				if (_loc4_ > MAX_PING)
				{
					_loc4_ = MAX_PING;
				}
				this.pingValue.text = Math.round(_loc4_).toString();
				this.pingValue.x = VALUE_OFFSET_X - this.pingValue.width;
				if (_loc4_ < 200)
				{
					if (_loc4_ > 100)
					{
						this.pingValue.color = this.interpolateColor(int("0x00FF00"), int("0xFFFF00"), (_loc4_ - 100) / (200 - 100));
					}
					else
					{
						this.pingValue.color = int("0x00FF00");
					}
				}
				else if (_loc4_ < 500)
				{
					this.pingValue.color = this.interpolateColor(int("0xFFFF00"), int("0XF03416"), (_loc4_ - 200) / (500 - 200));
				}
				else
				{
					this.pingValue.color = int("0XF03416");
				}
			}
		}

		private function interpolateColor(param1:int, param2:int, param3:Number):int
		{
			var _loc4_:int = param1 >> 16 & 255;
			var _loc5_:int = param1 >> 8 & 255;
			var _loc6_:int = param1 & 255;
			var _loc7_:int = param2 >> 16 & 255;
			var _loc8_:int = param2 >> 8 & 255;
			var _loc9_:int = param2 & 255;
			if (param3 > 1)
			{
				param3 = 1;
			}
			return _loc4_ + (_loc7_ - _loc4_) * param3 << 16 | _loc5_ + (_loc8_ - _loc5_) * param3 << 8 | int(_loc6_ + (_loc9_ - _loc6_) * param3);
		}

		private function onResize(param1:Event = null):void
		{
			x = stage.stageWidth - OFFSET_X;
			y = stage.stageHeight - OFFSET_Y;
			this.fpsValue.x = VALUE_OFFSET_X - this.fpsValue.width;
			this.pingValue.x = VALUE_OFFSET_X - this.pingValue.width;
		}
	}
}
