﻿package alternativa.tanks.help
{
    import alternativa.init.OSGi;
    import flash.net.SharedObject;
    import flash.display.Stage;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.utils.Dictionary;
    import alternativa.init.TanksServicesActivator;
    import alternativa.osgi.service.mainContainer.IMainContainerService;
    import alternativa.osgi.service.storage.IStorageService;
    import alternativa.osgi.service.console.IConsoleService;
    import flash.events.Event;
    import __AS3__.vec.Vector;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.text.TextFormat;
    import __AS3__.vec.*;

    public class HelpService implements IHelpService
    {

        private var osgi:OSGi;
        private var storage:SharedObject;
        private var stage:Stage;
        private var helpLayer:DisplayObjectContainer;
        private var helpContainer:Sprite;
        private var helpGroups:Dictionary;
        private var mainGroupObjects:Array;
        private var advancedUser:Boolean;
        private var hideTimers:Array;
        private var lock:Boolean;

        public function HelpService()
        {
            this.osgi = TanksServicesActivator.osgi;
            var mainContainerService:IMainContainerService = (this.osgi.getService(IMainContainerService) as IMainContainerService);
            this.stage = mainContainerService.stage;
            this.helpLayer = mainContainerService.noticesLayer;
            this.helpContainer = new Sprite();
            this.helpGroups = new Dictionary();
            this.mainGroupObjects = new Array();
            this.hideTimers = new Array();
            this.storage = IStorageService(this.osgi.getService(IStorageService)).getStorage();
            if (this.storage.data.helperShowNum == null)
            {
                this.storage.data.helperShowNum = new Dictionary();
            }
            this.advancedUser = ((!(this.storage.data.userRank == null)) && (this.storage.data.userRank >= 6));
            (this.osgi.getService(IConsoleService) as IConsoleService).writeToConsoleChannel("HELP", "advancedUser: %1", this.advancedUser);
            this.stage.addEventListener(Event.RESIZE, this.onStageResize);
        }
        public function registerHelper(groupKey:String, helperId:int, helper:Helper, showByHelpButtonClick:Boolean):void
        {
            var consoleSerivce:IConsoleService = IConsoleService(this.osgi.getService(IConsoleService));
            consoleSerivce.writeToConsoleChannel("HELP", "\nregisterHelper");
            consoleSerivce.writeToConsoleChannel("HELP", "   groupKey: %1", groupKey);
            consoleSerivce.writeToConsoleChannel("HELP", "   helperId: %1", helperId);
            consoleSerivce.writeToConsoleChannel("HELP", "   helper: %1", helper);
            var helpers:Dictionary = this.helpGroups[groupKey];
            if (helpers == null)
            {
                helpers = new Dictionary();
                this.helpGroups[groupKey] = helpers;
            }
            helpers[helperId] = helper;
            if (showByHelpButtonClick)
            {
                this.mainGroupObjects.push(helper);
            }
            var helperShowNum:Dictionary = (this.storage.data.helperShowNum as Dictionary);
            if (helperShowNum == null)
            {
                helperShowNum = new Dictionary();
            }
            if (helperShowNum[groupKey] == null)
            {
                helperShowNum[groupKey] = new Array();
            }
            if (helperShowNum[groupKey][helperId] == null)
            {
                helperShowNum[groupKey][helperId] = helper.showNum;
            }
            else
            {
                helper.showNum = helperShowNum[groupKey][helperId];
            }
            helper.id = helperId;
            helper.groupKey = groupKey;
        }
        public function unregisterHelper(groupKey:String, helperId:int):void
        {
            var consoleService:IConsoleService = IConsoleService(this.osgi.getService(IConsoleService));
            consoleService.writeToConsoleChannel("HELP", "\nunregisterHelper");
            consoleService.writeToConsoleChannel("HELP", "   groupKey: %1", groupKey);
            consoleService.writeToConsoleChannel("HELP", "   helperId: %1", helperId);
            var helpers:Dictionary = this.helpGroups[groupKey];
            if (helpers == null)
            {
                return;
            }
            var helper:Helper = helpers[helperId];
            if (helper == null)
            {
                return;
            }
            consoleService.writeToConsoleChannel("HELP", "   helper: %1", helper);
            this.doHideHelper(helper);
            delete helpers[helperId];
            var index:int = this.mainGroupObjects.indexOf(helper);
            if (index != -1)
            {
                this.mainGroupObjects.splice(index, 1);
            }
        }
        public function showHelper(groupKey:String, helperId:int, useTimer:Boolean = false):void
        {
            var helper:Helper;
            var helperShowNum:Vector.<Object>;
            var s:int;
            var i:int;
            var obj:Object;
            var timer:HelperTimer;
            (this.osgi.getService(IConsoleService) as IConsoleService).writeToConsoleChannel("HELP", "showHelper groupKey: %1, helperId: %2, advancedUser: %3", groupKey, helperId, this.advancedUser);
            if ((!(this.advancedUser)))
            {
                helper = this.getHelper(groupKey, helperId);
                if (helper == null)
                {
                    return;
                }
                if ((!(this.helpLayer.contains(this.helpContainer))))
                {
                    this.helpLayer.addChild(this.helpContainer);
                }
                if (((helper.showLimit == -1) || ((!(helper.showLimit == -1)) && (helper.showNum < helper.showLimit))))
                {
                    if ((!(this.helpContainer.contains(helper))))
                    {
                        helper.showNum = (helper.showNum + 1);
                        helperShowNum = (((!(this.storage.data.helperShowNum == null)) && (this.storage.data.helperShowNum is Vector.<Object>)) ? this.storage.data.helperShowNum : new Vector.<Object>());
                        s = -1;
                        i = 0;
                        while (i < helperShowNum.length)
                        {
                            if (((helperShowNum[i].hasOwnProperty("groupKey")) && (helperShowNum[i].groupKey == groupKey)))
                            {
                                s = i;
                            }
                            i++;
                        }
                        if (s == -1)
                        {
                            obj = new Object();
                            obj.groupKey = groupKey;
                            obj.helper = new Array();
                            obj.helper[helperId] = helper.showNum;
                            helperShowNum.push(obj);
                        }
                        else
                        {
                            helperShowNum[s].helper[helperId] = helper.showNum;
                        }
                        this.storage.data.helperShowNum = helperShowNum;
                        this.helpContainer.addChild(helper);
                        helper.draw(helper.size);
                        helper.align(this.stage.stageWidth, this.stage.stageHeight);
                        helper.addEventListener(MouseEvent.MOUSE_DOWN, this.onHelperClick);
                        if (useTimer)
                        {
                            timer = new HelperTimer(helper.showDuration, 1);
                            timer.helper = helper;
                            helper.timer = timer;
                            timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.onHelperTimer);
                            this.hideTimers.push(timer);
                            timer.reset();
                            timer.start();
                        }
                    }
                }
            }
        }
        public function hideHelper(groupKey:String, helperId:int):void
        {
            (this.osgi.getService(IConsoleService) as IConsoleService).writeToConsoleChannel("HELP", "hideHelper groupKey: %1, helperId: %2", groupKey, helperId);
            if ((!(this.advancedUser)))
            {
                this.doHideHelper(this.getHelper(groupKey, helperId));
            }
        }
        public function showHelp():void
        {
            var i:int;
            var helper:Helper;
            var index:int;
            if ((!(this.lock)))
            {
                (this.osgi.getService(IConsoleService) as IConsoleService).writeToConsoleChannel("HELP", "showHelp");
                if ((!(this.helpLayer.contains(this.helpContainer))))
                {
                    this.helpLayer.addChild(this.helpContainer);
                }
                i = 0;
                while (i < this.mainGroupObjects.length)
                {
                    helper = (this.mainGroupObjects[i] as Helper);
                    if ((!(this.helpContainer.contains(helper))))
                    {
                        this.helpContainer.addChild(helper);
                        helper.draw(helper.size);
                        helper.align(this.stage.stageWidth, this.stage.stageHeight);
                    }
                    else
                    {
                        index = this.hideTimers.indexOf(helper.timer);
                        if (index != -1)
                        {
                            (this.osgi.getService(IConsoleService) as IConsoleService).writeToConsoleChannel("HELP", "   helper %1 %2 timer stop", helper.groupKey, helper.id);
                            (this.hideTimers[index] as HelperTimer).stop();
                            this.hideTimers.splice(index, 1);
                        }
                    }
                    i++;
                }
                this.stage.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
            }
        }
        public function hideHelp():void
        {
            var helper:Helper;
            var index:int;
            (this.osgi.getService(IConsoleService) as IConsoleService).writeToConsoleChannel("HELP", "hideHelp");
            var i:int;
            while (i < this.mainGroupObjects.length)
            {
                helper = this.mainGroupObjects[i];
                index = this.hideTimers.indexOf(helper.timer);
                if (index != -1)
                {
                    (this.osgi.getService(IConsoleService) as IConsoleService).writeToConsoleChannel("HELP", "   helper %1 %2 timer stop", helper.groupKey, helper.id);
                    (this.hideTimers[index] as HelperTimer).stop();
                    this.hideTimers.splice(index, 1);
                }
                if (this.helpContainer.contains(helper))
                {
                    this.helpContainer.removeChild(helper);
                }
                i++;
            }
            if (this.helpContainer.numChildren == 0)
            {
                if (this.helpLayer.contains(this.helpContainer))
                {
                    this.helpLayer.removeChild(this.helpContainer);
                }
                this.helpContainer = new Sprite();
            }
            this.stage.removeEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
        }
        public function setHelperTextFormat(format:TextFormat):void
        {
            BubbleHelper.textFormat = format;
        }
        private function onMouseDown(e:MouseEvent):void
        {
            this.hideHelp();
            this.lock = true;
            this.stage.addEventListener(MouseEvent.MOUSE_DOWN, this.unlock);
        }
        private function unlock(e:MouseEvent):void
        {
            this.lock = false;
            this.stage.removeEventListener(MouseEvent.MOUSE_DOWN, this.unlock);
        }
        private function onHelperTimer(e:TimerEvent):void
        {
            (this.osgi.getService(IConsoleService) as IConsoleService).writeToConsoleChannel("HELP", "onHelperTimer");
            var timer:HelperTimer = (e.target as HelperTimer);
            var helper:Helper = timer.helper;
            (this.osgi.getService(IConsoleService) as IConsoleService).writeToConsoleChannel("HELP", "   helper.groupKey: %1", helper.groupKey);
            (this.osgi.getService(IConsoleService) as IConsoleService).writeToConsoleChannel("HELP", "   helper.id: %1", helper.id);
            this.hideHelper(helper.groupKey, helper.id);
        }
        private function onHelperClick(e:MouseEvent):void
        {
            var helper:Helper;
            (this.osgi.getService(IConsoleService) as IConsoleService).writeToConsoleChannel("HELP", "onHelperClick");
            if ((e.target is Helper))
            {
                helper = (e.target as Helper);
                (this.osgi.getService(IConsoleService) as IConsoleService).writeToConsoleChannel("HELP", "   helper.groupKey: %1", helper.groupKey);
                (this.osgi.getService(IConsoleService) as IConsoleService).writeToConsoleChannel("HELP", "   helper.id: %1", helper.id);
                this.hideHelper(helper.groupKey, helper.id);
            }
        }
        private function onStageResize(e:Event):void
        {
            var i:int;
            var helper:Helper;
            if (this.helpLayer.contains(this.helpContainer))
            {
                i = 0;
                while (i < this.helpContainer.numChildren)
                {
                    helper = (this.helpContainer.getChildAt(i) as Helper);
                    if (helper != null)
                    {
                        helper.align(this.stage.stageWidth, this.stage.stageHeight);
                    }
                    i++;
                }
            }
        }
        private function getHelper(groupKey:String, helperId:int):Helper
        {
            var helpers:Dictionary = this.helpGroups[groupKey];
            if (helpers == null)
            {
                return (null);
            }
            return (helpers[helperId]);
        }
        private function doHideHelper(helper:Helper):void
        {
            var index:int;
            if (helper == null)
            {
                return;
            }
            if (this.helpContainer.contains(helper))
            {
                this.helpContainer.removeChild(helper);
            }
            helper.removeEventListener(MouseEvent.MOUSE_DOWN, this.onHelperClick);
            var timer:HelperTimer = helper.timer;
            if (timer != null)
            {
                timer.stop();
                index = this.hideTimers.indexOf(timer);
                if (index != -1)
                {
                    this.hideTimers.splice(index, 1);
                }
            }
        }

    }
}
