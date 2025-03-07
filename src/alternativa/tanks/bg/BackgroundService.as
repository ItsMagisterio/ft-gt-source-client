﻿package alternativa.tanks.bg
{
    import flash.display.BitmapData;
    import alternativa.init.OSGi;
    import flash.display.Stage;
    import flash.display.DisplayObjectContainer;
    import flash.display.Shape;
    import flash.geom.Rectangle;
    import alternativa.init.TanksServicesActivator;
    import alternativa.osgi.service.mainContainer.IMainContainerService;
    import flash.events.Event;

    public class BackgroundService implements IBackgroundService
    {

        private static const bitmapBg:Class = BackgroundService_bitmapBg;
        private static const bgBitmap:BitmapData = new bitmapBg().bitmapData;

        private var osgi:OSGi;
        private var stage:Stage;
        private var bgLayer:DisplayObjectContainer;
        private var bg:Shape;
        private var bgCropRect:Rectangle;

        public function BackgroundService()
        {
            this.osgi = TanksServicesActivator.osgi;
            var mainContainerService:IMainContainerService = (this.osgi.getService(IMainContainerService) as IMainContainerService);
            this.stage = mainContainerService.stage;
            this.bgLayer = mainContainerService.backgroundLayer;
            this.bg = new Shape();
        }
        public function showBg():void
        {
            if ((!(this.bgLayer.contains(this.bg))))
            {
                this.redrawBg();
                this.bgLayer.addChild(this.bg);
                this.stage.addEventListener(Event.RESIZE, this.redrawBg);
            }
        }
        public function hideBg():void
        {
            if (this.bgLayer.contains(this.bg))
            {
                this.stage.removeEventListener(Event.RESIZE, this.redrawBg);
                this.bgLayer.removeChild(this.bg);
            }
        }
        public function drawBg(cropRect:Rectangle = null):void
        {
            this.bgCropRect = cropRect;
            this.redrawBg();
        }
        private function redrawBg(e:Event = null):void
        {
            this.bg.graphics.clear();
            this.bg.graphics.beginBitmapFill(bgBitmap);
            this.bg.graphics.drawRect(0, 0, this.stage.stageWidth, this.stage.stageHeight);
            if (this.bgCropRect != null)
            {
                this.bg.graphics.drawRect(this.bgCropRect.x, this.bgCropRect.y, this.bgCropRect.width, this.bgCropRect.height);
            }
        }

    }
}
