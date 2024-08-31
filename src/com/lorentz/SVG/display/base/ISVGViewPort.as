package com.lorentz.SVG.display.base
{
    public interface ISVGViewPort extends ISVGPreserveAspectRatio
    {

        function get svgX():String;
        function set svgX(_arg_1:String):void;
        function get svgY():String;
        function set svgY(_arg_1:String):void;
        function get svgWidth():String;
        function set svgWidth(_arg_1:String):void;
        function get svgHeight():String;
        function set svgHeight(_arg_1:String):void;
        function get svgOverflow():String;
        function set svgOverflow(_arg_1:String):void;
        function get viewPortWidth():Number;
        function get viewPortHeight():Number;

    }
}
