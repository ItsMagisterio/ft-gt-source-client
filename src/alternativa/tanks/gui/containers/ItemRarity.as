package alternativa.tanks.gui.containers
{
    public class ItemRarity
    {

        public function getRarity(rar:String):Rarity
        {

            if (rar == "common")
            {
                return Rarity.COMMON;
            }
            if (rar == "rare")
            {
                return Rarity.RARE;
            }
            if (rar == "epic")
            {
                return Rarity.EPIC;
            }
            if (rar == "legendary")
            {
                return Rarity.LEGENDARY;
            }
            if (rar == "exotic")
            {
                return Rarity.EXOTIC;
            }
            if (rar == "ultimate")
            {
                return Rarity.ULTIMATE;
            }
            return null;
        }

    }
}