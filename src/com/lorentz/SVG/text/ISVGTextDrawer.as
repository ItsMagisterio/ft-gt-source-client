package com.lorentz.SVG.text
{
    import com.lorentz.SVG.data.text.SVGTextToDraw;
    import com.lorentz.SVG.data.text.SVGDrawnText;

    public interface ISVGTextDrawer
    {

        function start():void;
        function drawText(_arg_1:SVGTextToDraw):SVGDrawnText;
        function end():void;

    }
}
