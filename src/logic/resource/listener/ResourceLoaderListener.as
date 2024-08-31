// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// scpacker.resource.listener.ResourceLoaderListener

package logic.resource.listener
{
    import __AS3__.vec.Vector;
    import flash.utils.Dictionary;
    import __AS3__.vec.*;

    public class ResourceLoaderListener
    {

        public static var listeners:Vector.<Function> = new Vector.<Function>();
        private static var isCalled:Dictionary = new Dictionary();

        public static function addEventListener(fun:Function):void
        {
            listeners.push(fun);
        }
        public static function loadedComplete():void
        {
            var resource:Function;
            for each (resource in listeners)
            {
                resource.call();
                isCalled[resource] = true;
            }
        }
        public static function removeListener(f:Function):void
        {
            var l:Function;
            for each (l in listeners)
            {
                if (l == f)
                {
                    listeners.removeAt(listeners.indexOf(l));
                    l = null;
                }
            }
        }
        public static function clearListeners(safely:Boolean = true):void
        {
            var l:* = undefined;
            for each (l in listeners)
            {
                if (isCalled[l])
                {
                    isCalled[l] = null;
                }
                else
                {
                    if (safely)
                    {
                        l.call();
                    }
                }
                listeners.removeAt(listeners.indexOf(l));
                l = null;
            }
            isCalled = new Dictionary();
            listeners = new Vector.<Function>();
        }

    }
} // package scpacker.resource.listener