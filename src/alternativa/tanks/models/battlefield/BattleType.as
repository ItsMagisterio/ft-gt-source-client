﻿package alternativa.tanks.models.battlefield
{
    public class BattleType
    {

        public static const DM:BattleType = new BattleType(0);
        public static const TDM:BattleType = new BattleType(1);
        public static const CTF:BattleType = new BattleType(2);
        public static const DOM:BattleType = new BattleType(3);

        private var _value:int;

        public function BattleType(value:int)
        {
            this._value = value;
        }
        public function get value():int
        {
            return (this._value);
        }

    }
}
