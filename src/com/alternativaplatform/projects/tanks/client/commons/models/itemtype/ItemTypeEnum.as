﻿package com.alternativaplatform.projects.tanks.client.commons.models.itemtype
{
    public class ItemTypeEnum
    {

        public static var WEAPON:ItemTypeEnum = new ItemTypeEnum(1 );
        public static var ARMOR:ItemTypeEnum = new ItemTypeEnum(2 );
        public static var COLOR:ItemTypeEnum = new ItemTypeEnum(3 );
        public static var RESISTANCE:ItemTypeEnum = new ItemTypeEnum(4);
        public static var INVENTORY:ItemTypeEnum = new ItemTypeEnum(5);
        public static var KIT:ItemTypeEnum = new ItemTypeEnum(6);
        public static var SPECIAL:ItemTypeEnum = new ItemTypeEnum(7);

        public var value:int;

        public function ItemTypeEnum(value:int)
        {
            this.value = value;
        }
    }
}
