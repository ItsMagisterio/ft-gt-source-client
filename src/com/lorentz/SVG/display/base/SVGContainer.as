package com.lorentz.SVG.display.base
{
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class SVGContainer extends SVGElement
    {

        private var _invalidElements:Boolean = false;
        private var _elements:Vector.<SVGElement> = new Vector.<SVGElement>();

        public function SVGContainer(tagName:String)
        {
            super(tagName);
        }
        protected function invalidateElements():void
        {
            if ((!(this._invalidElements)))
            {
                this._invalidElements = true;
                invalidateProperties();
            }
        }
        override protected function commitProperties():void
        {
            var element:SVGElement;
            super.commitProperties();
            if (this._invalidElements)
            {
                this._invalidElements = false;
                while (content.numChildren > 0)
                {
                    content.removeChildAt(0);
                }
                for each (element in this._elements)
                {
                    content.addChild(element);
                }
            }
        }
        public function addElement(element:SVGElement):void
        {
            this.addElementAt(element, this.numElements);
        }
        public function addElementAt(element:SVGElement, index:int):void
        {
            if (this._elements.indexOf(element) == -1)
            {
                this._elements.splice(index, 0, element);
                this.invalidateElements();
                attachElement(element);
            }
        }
        public function getElementAt(index:int):SVGElement
        {
            return (this._elements[index]);
        }
        public function get numElements():int
        {
            return (this._elements.length);
        }
        public function removeElement(element:SVGElement):void
        {
            this.removeElementAt(this._elements.indexOf(element));
        }
        public function removeElementAt(index:int):void
        {
            var element:SVGElement;
            if (((index >= 0) && (index < this.numElements)))
            {
                element = this._elements.splice(index, 1)[0];
                this.invalidateElements();
                detachElement(element);
            }
        }
        override public function clone():Object
        {
            var c:SVGContainer = (super.clone() as SVGContainer);
            var i:int;
            while (i < this.numElements)
            {
                c.addElement((this.getElementAt(i).clone() as SVGElement));
                i++;
            }
            return (c);
        }

    }
}
