// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// alternativa.tanks.models.weapon.shaft.SetControllerForTemporaryItems

package alternativa.tanks.models.weapon.shaft
{
    import __AS3__.vec.Vector;
    import flash.utils.Dictionary;
    import __AS3__.vec.*;

    public class SetControllerForTemporaryItems
    {

        private var temporaryItems:Vector.<Object> = new Vector.<Object>();
        private var sourceSet:Dictionary;

        public function SetControllerForTemporaryItems(param1:Dictionary)
        {
            this.sourceSet = param1;
        }

        public function addTemporaryItem(param1:Object):void
        {
            this.sourceSet[param1] = true;
            this.temporaryItems.push(param1);
        }

        public function deleteAllTemporaryItems():void
        {
            var _loc1_:int;
            while (_loc1_ < this.temporaryItems.length)
            {
                delete this.sourceSet[this.temporaryItems[_loc1_]];
                _loc1_++;
            }
            this.temporaryItems.length = 0;
        }

    }
} // package alternativa.tanks.models.weapon.shaft