﻿// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// scpacker.test.usertitles.DefaultUserTitlesRender

package logic.test.usertitles
{
    import alternativa.tanks.models.battlefield.IBattleField;
    import alternativa.tanks.models.tank.TankData;
    import alternativa.math.Vector3;
    import alternativa.physics.collision.types.RayIntersection;
    import alternativa.tanks.vehicles.tanks.Tank;
    import projects.tanks.client.battleservice.model.team.BattleTeamType;
    import alternativa.tanks.physics.TanksCollisionDetector;
    import __AS3__.vec.Vector;
    import alternativa.tanks.physics.CollisionGroup;
    import alternativa.tanks.display.usertitle.UserTitle;

    public class DefaultUserTitlesRender implements UserTitlesRender
    {

        private var titleShowDistance:Number = 7000;
        private var titleHideDistance:Number = 7050;
        private var battlefield:IBattleField;
        public var localUserData:TankData;
        private var point:Vector3 = new Vector3();
        private var rayOrigin:Vector3 = new Vector3();
        private var rayVector:Vector3 = new Vector3();
        private var rayIntersection:RayIntersection = new RayIntersection();

        public function updateTitle(tankData:TankData, cameraPos:Vector3):void
        {
            var pos:Vector3;
            var dx:Number = NaN;
            var dy:Number = NaN;
            var dz:Number = NaN;
            var distance:Number = NaN;
            var tank:Tank = tankData.tank;
            if (tankData.health <= 0)
            {
                tankData.tank.title.hide();
            }
            else
            {
                if (((!(tankData.local)) && (!(TankData.localTankData == null))))
                {
                    if ((!(this.isSameTeam(TankData.localTankData.teamType, tankData.teamType))))
                    {
                        pos = tank.state.pos;
                        dx = (pos.x - cameraPos.x);
                        dy = (pos.y - cameraPos.y);
                        dz = (pos.z - cameraPos.z);
                        distance = Math.sqrt((((dx * dx) + (dy * dy)) + (dz * dz)));
                        if (((distance >= this.titleHideDistance) || (this.isTankInvisible(tankData, cameraPos))))
                        {
                            tank.title.hide();
                        }
                        else
                        {
                            if (distance < this.titleShowDistance)
                            {
                                tank.title.show();
                            }
                        }
                    }
                    else
                    {
                        tank.title.show();
                    }
                }
            }
        }
        private function isSameTeam(teamType1:BattleTeamType, teamType2:BattleTeamType):Boolean
        {
            return ((!(teamType1 == BattleTeamType.NONE)) && (teamType1 == teamType2));
        }
        private function isTankInvisible(tankData:TankData, cameraPos:Vector3):Boolean
        {
            var collisionDetector:TanksCollisionDetector = this.battlefield.getBattlefieldData().collisionDetector;
            var points:Vector.<Vector3> = tankData.tank.visibilityPoints;
            var len:int = points.length;
            var i:int;
            while (i < len)
            {
                this.point.vCopy(points[i]);
                if (this.isTankPointVisible(this.point, tankData, cameraPos, collisionDetector))
                {
                    return (false);
                }
                i++;
            }
            return (true);
        }
        private function isTankPointVisible(point:Vector3, tankData:TankData, cameraPos:Vector3, collisionDetector:TanksCollisionDetector):Boolean
        {
            point.vTransformBy3(tankData.tank.baseMatrix);
            point.vAdd(tankData.tank.state.pos);
            this.rayOrigin.copyFrom(cameraPos);
            this.rayVector.vDiff(point, this.rayOrigin);
            return (!(collisionDetector.intersectRayWithStatic(this.rayOrigin, this.rayVector, CollisionGroup.STATIC, 1, null, this.rayIntersection)));
        }
        public function configurateTitle(tankData:TankData):void
        {
            if (((TankData.localTankData == null) || (TankData.localTankData.teamType == null)))
            {
                return;
            }
            var configFlags:int = (UserTitle.BIT_LABEL | UserTitle.BIT_EFFECTS);
            if (this.isSameTeam(tankData.teamType, TankData.localTankData.teamType))
            {
                configFlags = (configFlags | UserTitle.BIT_HEALTH);
            }
            var title:UserTitle = tankData.tank.title;
            title.setLabelText(tankData.userName);
            title.setRank(tankData.userRank);
            title.setTeamType(tankData.teamType);
            title.setHealth(tankData.health);
            title.setConfiguration(configFlags);
        }
        public function setBattlefield(model:IBattleField):void
        {
            this.battlefield = model;
        }
        public function setLocalData(model:TankData):void
        {
            this.localUserData = model;
        }
        public function render():void
        {
        }

    }
} // package scpacker.test.usertitles