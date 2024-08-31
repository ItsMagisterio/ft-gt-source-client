package alternativa.tanks.gui.containers
{
    import flash.display.Sprite;
    import flash.display.BitmapData;

    public class Item extends Sprite
    {
        public var id:String;
        public var previewId:String;
        public var _name:String;
        public var count:int;
        public var rarity:String;
        public var color:int;

        public function Item(json:Object)
        {
            this.id = json.id;
            this.previewId = json.id + "_preview";
            this._name = json.name;
            this.count = json.count;
            this.rarity = json.rarity;
        }
    }
}