﻿package com.alternativaplatform.projects.tanks.client.warfare.models.tankparts.weapon.healing
{
    public class IsisActionType
    {

        public static var HEAL:IsisActionType = new (IsisActionType)();
        public static var DAMAGE:IsisActionType = new (IsisActionType)();
        public static var IDLE:IsisActionType = new (IsisActionType)();

        public static function getType(str:String):IsisActionType
        {
            var obj:IsisActionType;
            switch (str)
            {
                case "idle":
                    obj = IDLE;
                    break;
                case "damage":
                    obj = DAMAGE;
                    break;
                case "heal":
                    obj = HEAL;
            }
            return (obj);
        }

    }
}
