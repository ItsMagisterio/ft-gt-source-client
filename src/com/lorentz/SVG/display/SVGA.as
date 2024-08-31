package com.lorentz.SVG.display
{
    import com.lorentz.SVG.display.base.SVGContainer;
    import flash.events.MouseEvent;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;

    public class SVGA extends SVGContainer
    {

        public var svgHref:String;

        public function SVGA()
        {
            super("a");
        }
        override protected function initialize():void
        {
            super.initialize();
            this.buttonMode = true;
            this.addEventListener(MouseEvent.CLICK, this.clickHandler, false, 0, true);
        }
        protected function clickHandler(e:MouseEvent):void
        {
            if (((!(this.svgHref == null)) && (!(this.svgHref == ""))))
            {
                navigateToURL(new URLRequest(this.svgHref));
            }
        }
        override public function clone():Object
        {
            var c:SVGA = (super.clone() as SVGA);
            c.svgHref = this.svgHref;
            return (c);
        }

    }
}
