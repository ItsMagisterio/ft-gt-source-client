package com.lorentz.SVG.display
{
    import com.lorentz.SVG.display.base.SVGShape;
    import com.lorentz.SVG.drawing.SVGPathRenderer;
    import __AS3__.vec.Vector;
    import com.lorentz.SVG.data.path.SVGPathCommand;
    import com.lorentz.SVG.parser.SVGParserCommon;
    import com.lorentz.SVG.drawing.IDrawer;
    import __AS3__.vec.*;

    public class SVGPath extends SVGShape
    {

        private var _invalidPathFlag:Boolean = false;
        private var _pathRenderer:SVGPathRenderer;
        private var _path:Vector.<SVGPathCommand>;

        public function SVGPath()
        {
            super("path");
        }
        public function get svgPath():String
        {
            return (getAttribute("path") as String);
        }
        public function set svgPath(value:String):void
        {
            setAttribute("path", value);
        }
        public function get path():Vector.<SVGPathCommand>
        {
            return (this._path);
        }
        public function set path(value:Vector.<SVGPathCommand>):void
        {
            this._path = value;
            this._pathRenderer = null;
            invalidateRender();
        }
        override protected function onAttributeChanged(attributeName:String, oldValue:Object, newValue:Object):void
        {
            super.onAttributeChanged(attributeName, oldValue, newValue);
            switch (attributeName)
            {
                case "path":
                    this._invalidPathFlag = true;
                    invalidateProperties();
            }
        }
        override protected function commitProperties():void
        {
            super.commitProperties();
            if (this._invalidPathFlag)
            {
                this._invalidPathFlag = false;
                this.path = SVGParserCommon.parsePathData(this.svgPath);
            }
        }
        override protected function beforeDraw():void
        {
            super.beforeDraw();
            this._pathRenderer = new SVGPathRenderer(this.path);
        }
        override protected function drawToDrawer(drawer:IDrawer):void
        {
            this._pathRenderer.render(drawer);
        }
        override public function clone():Object
        {
            var command:SVGPathCommand;
            var c:SVGPath = (super.clone() as SVGPath);
            var pathCopy:Vector.<SVGPathCommand> = new Vector.<SVGPathCommand>();
            for each (command in this.path)
            {
                pathCopy.push(command.clone());
            }
            c.path = pathCopy;
            return (c);
        }

    }
}
