package alternativa.tanks.gui.containers
{
    public class Rarity
    {
        public var color:uint;

        public function Rarity(color:uint)
        {
            this.color = color;
        }
        public static const COMMON:Rarity = new Rarity(0xe3e6e1);
        public static const RARE:Rarity = new Rarity(0x23a9fc);
        public static const EPIC:Rarity = new Rarity(0x722cdc);
        public static const LEGENDARY:Rarity = new Rarity(0xeded03);
        public static const EXOTIC:Rarity = new Rarity(0xed5227);
        public static const ULTIMATE:Rarity = new Rarity(0xde382e);

    }

}