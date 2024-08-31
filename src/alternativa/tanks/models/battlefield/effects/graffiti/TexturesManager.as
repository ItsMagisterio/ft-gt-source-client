package alternativa.tanks.models.battlefield.effects.graffiti
{
    import flash.display.BitmapData;

    public class TexturesManager
    {

        private static const graffiti_default:Class = TexturesManager_graffiti_default;
        private static const graffiti_boo:Class = TexturesManager_graffiti_boo;
        private static const graffiti_fireball:Class = TexturesManager_graffiti_fireball;
        private static const graffiti_firegraff:Class = TexturesManager_graffiti_firegraff;
        private static const graffiti_fart:Class = TexturesManager_graffiti_fart;
        private static const graffiti_gg:Class = TexturesManager_graffiti_gg;
        private static const graffiti_glhf:Class = TexturesManager_graffiti_glhf;
        private static const graffiti_heart:Class = TexturesManager_graffiti_heart;
        private static const graffiti_music:Class = TexturesManager_graffiti_music;
        private static const graffiti_swag:Class = TexturesManager_graffiti_swag;
        private static const graffiti_subwaytank:Class = TexturesManager_graffiti_subwaytank;
        private static const graffiti_money:Class = TexturesManager_graffiti_money;

        public static function getBD(id:String):BitmapData
        {
            switch (id)
            {
                case "droppzone_gold":
                    return (new graffiti_boo().bitmapData);
                case "droppzone_crystal100":
                    return (new graffiti_boo().bitmapData);
                case "droppzone_damageup":
                    return (new graffiti_fireball().bitmapData);
                case "droppzone_nitro":
                    return (new graffiti_firegraff().bitmapData);
                case "droppzone_armorup":
                    return (new graffiti_fart().bitmapData);
                case "droppzone_medkit":
                    return (new graffiti_gg().bitmapData);
                case "droppzone_spin":
                    return (new graffiti_glhf().bitmapData);
                case "droppzone_ruby":
                    return (new graffiti_heart().bitmapData);
                case "graffiti_music":
                    return (new graffiti_music().bitmapData);
                case "graffiti_swag":
                    return (new graffiti_swag().bitmapData);
                case "graffiti_subwaytank":
                    return (new graffiti_subwaytank().bitmapData);
                case "graffiti_money":
                    return (new graffiti_money().bitmapData);
            }
            return null;
            // return (new graffiti_default().bitmapData);
        }

    }
}
