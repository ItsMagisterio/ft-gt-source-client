package forms.itemscategory.shoteffects
{
    public class ShotEffectType
    {
        private var name:String;
        private var description:String;
        private var skinType:String;
        private var equiped:Boolean;
        private var price:int;
        private var bought:Boolean;

        public function ShotEffectType(name:String, description:String, skinType:String, equip:Boolean, price:int, bought:Boolean)
        {
            this.name = name;
            this.description = description;
            this.skinType = skinType;
            this.equiped = equip;
            this.price = price;
            this.bought = bought;
        }

        public function getName():String
        {
            return this.name;
        }
        public function getDescription():String
        {
            return this.description;
        }
        public function getSkinType():String
        {
            return this.skinType;
        }
        public function getEquipped():Boolean
        {
            return this.equiped;
        }
        public function getPrice():int
        {
            return this.price;
        }
        public function getPurchased():Boolean
        {
            return this.bought;
        }
    }
}