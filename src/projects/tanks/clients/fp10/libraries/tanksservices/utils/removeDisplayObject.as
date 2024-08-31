// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// projects.tanks.clients.fp10.libraries.tanksservices.utils.removeDisplayObject

package projects.tanks.clients.fp10.libraries.tanksservices.utils
{
    import flash.display.DisplayObject;

    public function removeDisplayObject(_arg_1:DisplayObject):void
    {
        if (((!(_arg_1 == null)) && (!(_arg_1.parent == null))))
        {
            _arg_1.parent.removeChild(_arg_1);
        }
    }
} // package projects.tanks.clients.fp10.libraries.tanksservices.utils