// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// forms.ranks.RankIcon

package forms.ranks
{
    import base.DiscreteSprite;
    // import projects.tanks.clients.fp10.libraries.tanksservices.service.rank.RankService;
    import flash.display.Bitmap;
    import projects.tanks.clients.fp10.libraries.tanksservices.utils.removeDisplayObject;
    import flash.errors.IllegalOperationError;

    public class RankIcon extends DiscreteSprite
    {

        // [Inject]
        // public static var rankService:RankService;

        private var hasPremium:Boolean = false;
        private var rankIcon:Bitmap;

        public function setRank(_arg_1:int):void
        {
            if (this.hasPremium)
            {
                this.setPremium(_arg_1);
            }
            else
            {
                this.setDefaultAccount(_arg_1);
            }
        }

        public function setPremium(_arg_1:int):void
        {
            this.hasPremium = true;
            this.setBitmap(this.createPremiumRankBitmap(_arg_1));
        }

        public function setDefaultAccount(_arg_1:int):void
        {
            this.hasPremium = false;
            this.setBitmap(this.createDefaultRankBitmap(_arg_1));
        }

        private function setBitmap(_arg_1:Bitmap):void
        {
            removeDisplayObject(this.rankIcon);
            addChild((this.rankIcon = _arg_1));
        }

        public function init(_arg_1:Boolean, _arg_2:int):void
        {
            if (_arg_1)
            {
                this.setPremium(_arg_2);
            }
            else
            {
                this.setDefaultAccount(_arg_2);
            }
        }

        protected function createDefaultRankBitmap(_arg_1:int):Bitmap
        {
            throw (new IllegalOperationError());
        }

        protected function createPremiumRankBitmap(_arg_1:int):Bitmap
        {
            throw (new IllegalOperationError());
        }

    }
} // package forms.ranks