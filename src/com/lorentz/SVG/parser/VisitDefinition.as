package com.lorentz.SVG.parser
{
    public class VisitDefinition
    {

        public var node:XML;
        public var onComplete:Function;

        public function VisitDefinition(node:XML, onComplete:Function = null)
        {
            this.node = node;
            this.onComplete = onComplete;
        }
    }
}
