package alternativa.tanks.bg
{
    import flash.geom.Rectangle;

    public interface IBackgroundService
    {

        function showBg():void;
        function hideBg():void;
        function drawBg(_arg_1:Rectangle = null):void;

    }
}
