package com.alternativaplatform.projects.tanks.client.commons.types
{
    public class DeathReason
    {

        public static var SUICIDE:DeathReason = new (DeathReason)();
        public static var KILLED_IN_BATTLE:DeathReason = new (DeathReason)();
        public static var MINE:DeathReason = new (DeathReason)();

        public static function getReason(str:String):DeathReason
        {
            if (str == "suicide")
            {
                return (SUICIDE);
            }
            if (str == "mine")
            {
                return (MINE);
            }
            return (KILLED_IN_BATTLE);
        }

    }
}
