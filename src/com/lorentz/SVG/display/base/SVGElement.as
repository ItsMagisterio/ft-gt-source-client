package com.lorentz.SVG.display.base
{
    import flash.display.Sprite;
    import com.lorentz.SVG.utils.ICloneable;
    import flash.filters.ColorMatrixFilter;
    import flash.display.DisplayObject;
    import com.lorentz.SVG.data.style.StyleDeclaration;
    import com.lorentz.SVG.display.SVGDocument;
    import __AS3__.vec.Vector;
    import com.lorentz.SVG.events.StyleDeclarationEvent;
    import com.lorentz.SVG.display.SVGClipPath;
    import com.lorentz.SVG.events.SVGEvent;
    import com.lorentz.SVG.display.SVGPattern;
    import flash.geom.Matrix;
    import com.lorentz.SVG.utils.MathUtils;
    import com.lorentz.SVG.parser.SVGParserCommon;
    import com.lorentz.SVG.utils.SVGUtil;
    import com.lorentz.SVG.data.filters.SVGFilterCollection;
    import flash.display.Bitmap;
    import flash.geom.Rectangle;
    import flash.display.BitmapData;
    import flash.display.BlendMode;
    import com.lorentz.SVG.utils.SVGViewPortUtils;
    import __AS3__.vec.*;

    [Event(name="invalidate", type="com.lorentz.SVG.events.SVGEvent")]
    [Event(name="syncValidated", type="com.lorentz.SVG.events.SVGEvent")]
    [Event(name="asyncValidated", type="com.lorentz.SVG.events.SVGEvent")]
    [Event(name="validated", type="com.lorentz.SVG.events.SVGEvent")]
    public class SVGElement extends Sprite implements ICloneable
    {

        private static const _maskRgbToLuminanceFilter:ColorMatrixFilter = new ColorMatrixFilter([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.2125, 0.7154, 0.0721, 0, 0]);

        protected var content:Sprite;
        private var _mask:DisplayObject;
        private var _currentFontSize:Number = NaN;
        private var _type:String;
        private var _id:String;
        private var _svgClipPathChanged:Boolean = false;
        private var _svgMaskChanged:Boolean = false;
        private var _svgFilterChanged:Boolean = false;
        private var _style:StyleDeclaration;
        private var _finalStyle:StyleDeclaration;
        private var _parentElement:SVGElement;
        private var _viewPortElement:ISVGViewPort;
        private var _document:SVGDocument;
        private var _numInvalidElements:int = 0;
        private var _numRunningAsyncValidations:int = 0;
        private var _runningAsyncValidations:Object = {}
        private var _invalidFlag:Boolean = false;
        private var _invalidStyleFlag:Boolean = false;
        private var _invalidPropertiesFlag:Boolean = false;
        private var _invalidTransformFlag:Boolean = false;
        private var _displayChanged:Boolean = false;
        private var _opacityChanged:Boolean = false;
        private var _attributes:Object = {}
        private var _elementsAttached:Vector.<SVGElement> = new Vector.<SVGElement>();
        private var _viewPortWidth:Number;
        private var _viewPortHeight:Number;
        public var metadata:XML;

        public function SVGElement(tagName:String)
        {
            this._type = tagName;
            this.initialize();
        }
        protected function initialize():void
        {
            this._style = new StyleDeclaration();
            this._style.addEventListener(StyleDeclarationEvent.PROPERTY_CHANGE, this.style_propertyChangeHandler, false, 0, true);
            this._finalStyle = new StyleDeclaration();
            this._finalStyle.addEventListener(StyleDeclarationEvent.PROPERTY_CHANGE, this.finalStyle_propertyChangeHandler, false, 0, true);
            this.content = new Sprite();
            addChild(this.content);
        }
        public function get type():String
        {
            return (this._type);
        }
        public function get id():String
        {
            return (this._id);
        }
        public function set id(value:String):void
        {
            this._id = value;
        }
        public function get svgClass():String
        {
            return (this.getAttribute("class") as String);
        }
        public function set svgClass(value:String):void
        {
            this.setAttribute("class", value);
        }
        public function get svgClipPath():String
        {
            return (this.getAttribute("clip-path") as String);
        }
        public function set svgClipPath(value:String):void
        {
            this.setAttribute("clip-path", value);
        }
        public function get svgMask():String
        {
            return (this.getAttribute("mask") as String);
        }
        public function set svgMask(value:String):void
        {
            this.setAttribute("mask", value);
        }
        public function get svgTransform():String
        {
            return (this.getAttribute("transform") as String);
        }
        public function set svgTransform(value:String):void
        {
            this.setAttribute("transform", value);
        }
        public function getAttribute(name:String):Object
        {
            return (this._attributes[name]);
        }
        public function setAttribute(name:String, value:Object):void
        {
            var oldValue:Object;
            if (this._attributes[name] != value)
            {
                oldValue = this._attributes[name];
                this._attributes[name] = value;
                this.onAttributeChanged(name, oldValue, value);
            }
        }
        public function removeAttribute(name:String):void
        {
            delete this._attributes[name];
        }
        public function hasAttribute(name:String):Boolean
        {
            return (name in this._attributes);
        }
        protected function onAttributeChanged(attributeName:String, oldValue:Object, newValue:Object):void
        {
            switch (attributeName)
            {
                case "class":
                    this.invalidateStyle(true);
                    break;
                case "clip-path":
                    this._svgClipPathChanged = true;
                    this.invalidateProperties();
                    break;
                case "mask":
                    this._svgMaskChanged = true;
                    this.invalidateProperties();
                    break;
                case "transform":
                    this._invalidTransformFlag = true;
                    this.invalidateProperties();
                    break;
            }
        }
        protected function attachElement(element:SVGElement):void
        {
            if (this._elementsAttached.indexOf(element) == -1)
            {
                this._elementsAttached.push(element);
                element.setParentElement(this);
            }
        }
        protected function detachElement(element:SVGElement):void
        {
            var index:int = this._elementsAttached.indexOf(element);
            if (index != -1)
            {
                this._elementsAttached.splice(index, 1);
                element.setParentElement(null);
            }
        }
        public function get style():StyleDeclaration
        {
            return (this._style);
        }
        public function get finalStyle():StyleDeclaration
        {
            return (this._finalStyle);
        }
        public function isInClipPath():Boolean
        {
            if ((this is SVGClipPath))
            {
                return (true);
            }
            if (this.parentElement == null)
            {
                return (false);
            }
            return (this.parentElement.isInClipPath());
        }
        public function get parentElement():SVGElement
        {
            return (this._parentElement);
        }
        protected function setParentElement(value:SVGElement):void
        {
            if (this._parentElement != value)
            {
                if (this._parentElement != null)
                {
                    this._parentElement.numInvalidElements = (this._parentElement.numInvalidElements - this._numInvalidElements);
                    this._parentElement.numRunningAsyncValidations = (this._parentElement.numRunningAsyncValidations - this._numRunningAsyncValidations);
                }
                this._parentElement = value;
                if (this._parentElement != null)
                {
                    this._parentElement.numInvalidElements = (this._parentElement.numInvalidElements + this._numInvalidElements);
                    this._parentElement.numRunningAsyncValidations = (this._parentElement.numRunningAsyncValidations + this._numRunningAsyncValidations);
                }
                this.setSVGDocument(((!(this._parentElement == null)) ? this._parentElement.document : null));
                this.setViewPortElement(((!(this._parentElement == null)) ? this._parentElement.viewPortElement : null));
                this.invalidateStyle();
            }
        }
        private function setSVGDocument(value:SVGDocument):void
        {
            var element:SVGElement;
            if (this._document != value)
            {
                if (this._document)
                {
                    this._document.onElementRemoved(this);
                }
                this._document = value;
                if (this._document)
                {
                    this._document.onElementAdded(this);
                }
                this.invalidateStyle(true);
                for each (element in this._elementsAttached)
                {
                    element.setSVGDocument(value);
                }
            }
        }
        private function setViewPortElement(value:ISVGViewPort):void
        {
            var element:SVGElement;
            if (this._viewPortElement != value)
            {
                this._viewPortElement = value;
                for each (element in this._elementsAttached)
                {
                    element.setViewPortElement(value);
                }
            }
        }
        public function get document():SVGDocument
        {
            return ((this is SVGDocument) ? (this as SVGDocument) : this._document);
        }
        public function get viewPortElement():ISVGViewPort
        {
            return ((this is ISVGViewPort) ? (this as ISVGViewPort) : this._viewPortElement);
        }
        public function get validationInProgress():Boolean
        {
            return ((!(this.numInvalidElements == 0)) || (!(this.numRunningAsyncValidations == 0)));
        }
        protected function get numInvalidElements():int
        {
            return (this._numInvalidElements);
        }
        protected function set numInvalidElements(value:int):void
        {
            var d:int = (value - this._numInvalidElements);
            this._numInvalidElements = value;
            if (this._parentElement != null)
            {
                this._parentElement.numInvalidElements = (this._parentElement.numInvalidElements + d);
            }
            if (((this._numInvalidElements == 0) && (!(d == 0))))
            {
                if (hasEventListener(SVGEvent.SYNC_VALIDATED))
                {
                    dispatchEvent(new SVGEvent(SVGEvent.SYNC_VALIDATED));
                }
                this.onPartialyValidated();
            }
        }
        protected function get numRunningAsyncValidations():int
        {
            return (this._numRunningAsyncValidations);
        }
        protected function set numRunningAsyncValidations(value:int):void
        {
            var d:int = (value - this._numRunningAsyncValidations);
            this._numRunningAsyncValidations = value;
            if (((this._numRunningAsyncValidations == 0) && (!(d == 0))))
            {
                if (hasEventListener(SVGEvent.ASYNC_VALIDATED))
                {
                    dispatchEvent(new SVGEvent(SVGEvent.ASYNC_VALIDATED));
                }
                this.onPartialyValidated();
            }
            if (this._parentElement != null)
            {
                this._parentElement.numRunningAsyncValidations = (this._parentElement.numRunningAsyncValidations + d);
            }
        }
        protected function onPartialyValidated():void
        {
            if (((this is ISVGViewPort) && (this.document)))
            {
                this.adjustContentToViewPort();
            }
            if ((!(this.validationInProgress)))
            {
                if (hasEventListener(SVGEvent.VALIDATED))
                {
                    dispatchEvent(new SVGEvent(SVGEvent.VALIDATED));
                }
                this.onValidated();
            }
        }
        protected function onValidated():void
        {
        }
        protected function invalidate():void
        {
            if ((!(this._invalidFlag)))
            {
                this._invalidFlag = true;
                this.numInvalidElements = (this.numInvalidElements + 1);
                if (hasEventListener(SVGEvent.INVALIDATE))
                {
                    dispatchEvent(new SVGEvent(SVGEvent.INVALIDATE));
                }
            }
        }
        public function invalidateStyle(recursive:Boolean = true):void
        {
            var element:SVGElement;
            if ((!(this._invalidStyleFlag)))
            {
                this._invalidStyleFlag = true;
                this.invalidate();
            }
            if (recursive)
            {
                for each (element in this._elementsAttached)
                {
                    element.invalidateStyle(recursive);
                }
            }
        }
        public function invalidateProperties():void
        {
            if ((!(this._invalidPropertiesFlag)))
            {
                this._invalidPropertiesFlag = true;
                this.invalidate();
            }
        }
        public function validate():void
        {
            var element:SVGElement;
            if (this._invalidStyleFlag)
            {
                this.updateStyles();
            }
            this.updateCurrentFontSize();
            if (this._invalidPropertiesFlag)
            {
                this.commitProperties();
            }
            if (this._invalidFlag)
            {
                this._invalidFlag = false;
                this.numInvalidElements = (this.numInvalidElements - 1);
            }
            if (this.numInvalidElements > 0)
            {
                for each (element in this._elementsAttached)
                {
                    element.validate();
                }
            }
        }
        public function beginASyncValidation(validationId:String):void
        {
            if (this._runningAsyncValidations[validationId] == null)
            {
                this._runningAsyncValidations[validationId] = true;
                this.numRunningAsyncValidations++;
            }
        }
        public function endASyncValidation(validationId:String):void
        {
            if (this._runningAsyncValidations[validationId] != null)
            {
                this.numRunningAsyncValidations--;
                delete this._runningAsyncValidations[validationId];
            }
        }
        protected function getElementToInheritStyles():SVGElement
        {
            if ((this is SVGPattern))
            {
                return (null);
            }
            return (this.parentElement);
        }
        protected function updateStyles():void
        {
            var className:String;
            var classStyle:StyleDeclaration;
            this._invalidStyleFlag = false;
            var newFinalStyle:StyleDeclaration = new StyleDeclaration();
            var inheritFrom:SVGElement = this.getElementToInheritStyles();
            if (inheritFrom)
            {
                inheritFrom.finalStyle.copyStyles(newFinalStyle, true);
            }
            var typeStyle:StyleDeclaration = this.document.getStyleDeclaration(this._type);
            if (typeStyle)
            {
                typeStyle.copyStyles(newFinalStyle);
            }
            if (this.svgClass)
            {
                for each (className in this.svgClass.split(" "))
                {
                    classStyle = this.document.getStyleDeclaration(("." + className));
                    if (classStyle)
                    {
                        classStyle.copyStyles(newFinalStyle);
                    }
                }
            }
            this._style.copyStyles(newFinalStyle);
            newFinalStyle.cloneOn(this._finalStyle);
        }
        private function style_propertyChangeHandler(e:StyleDeclarationEvent):void
        {
            this.invalidateStyle();
        }
        private function finalStyle_propertyChangeHandler(e:StyleDeclarationEvent):void
        {
            this.onStyleChanged(e.propertyName, e.oldValue, e.newValue);
        }
        protected function onStyleChanged(styleName:String, oldValue:String, newValue:String):void
        {
            switch (styleName)
            {
                case "display":
                    this._displayChanged = true;
                    this.invalidateProperties();
                    break;
                case "opacity":
                    this._opacityChanged = true;
                    this.invalidateProperties();
                    break;
                case "filter":
                    this._svgFilterChanged = true;
                    this.invalidateProperties();
                    break;
                case "clip-path":
                    this._svgClipPathChanged = true;
                    this.invalidateProperties();
                    break;
            }
        }
        protected function get shouldApplySvgTransform():Boolean
        {
            return (true);
        }
        private function computeTransformMatrix():Matrix
        {
            var svgTransformMat:Matrix;
            var mat:Matrix;
            if (transform.matrix)
            {
                mat = transform.matrix;
                mat.identity();
            }
            else
            {
                mat = new Matrix();
            }
            mat.scale(scaleX, scaleY);
            mat.rotate(MathUtils.radiusToDegress(rotation));
            mat.translate(x, y);
            if (((this.shouldApplySvgTransform) && (!(this.svgTransform == null))))
            {
                svgTransformMat = SVGParserCommon.parseTransformation(this.svgTransform);
                if (svgTransformMat)
                {
                    mat.concat(svgTransformMat);
                }
            }
            return (mat);
        }
        public function get currentFontSize():Number
        {
            return (this._currentFontSize);
        }
        protected function updateCurrentFontSize():void
        {
            this._currentFontSize = Number.NaN;
            if (this.parentElement)
            {
                this._currentFontSize = this.parentElement.currentFontSize;
            }
            var fontSize:String = this.finalStyle.getPropertyValue("font-size");
            if (fontSize)
            {
                this._currentFontSize = SVGUtil.getFontSize(fontSize, this._currentFontSize, this.viewPortWidth, this.viewPortHeight);
            }
            if (isNaN(this._currentFontSize))
            {
                this._currentFontSize = SVGUtil.getFontSize("medium", this.currentFontSize, this.viewPortWidth, this.viewPortHeight);
            }
        }
        protected function commitProperties():void
        {
            var mask:SVGElement;
            var clip:SVGElement;
            var validateN:int;
            var onClipOrMaskValidated:Function;
            var clipPathValue:String;
            var maskId:String;
            var clipPathId:String;
            var filters:Array;
            var filterLink:String;
            var filterId:String;
            var filterCollection:SVGFilterCollection;
            this._invalidPropertiesFlag = false;
            if (this._invalidTransformFlag)
            {
                this._invalidTransformFlag = false;
                transform.matrix = this.computeTransformMatrix();
            }
            if (((this._svgClipPathChanged) || (this._svgMaskChanged)))
            {
                this._svgClipPathChanged = false;
                this._svgMaskChanged = false;
                if (this._mask != null)
                {
                    this.content.mask = null;
                    this.content.cacheAsBitmap = false;
                    removeChild(this._mask);
                    if ((this._mask is SVGElement))
                    {
                        this.detachElement((this._mask as SVGElement));
                    }
                    else
                    {
                        if ((this._mask is Bitmap))
                        {
                            (this._mask as Bitmap).bitmapData.dispose();
                            (this._mask as Bitmap).bitmapData = null;
                        }
                    }
                    this._mask = null;
                }
                mask = null;
                clip = null;
                validateN = 0;
                onClipOrMaskValidated = function(e:SVGEvent):void
                {
                    var maskRc:Rectangle;
                    var matrix:Matrix;
                    var bmd:BitmapData;
                    e.target.removeEventListener(SVGEvent.VALIDATED, onClipOrMaskValidated);
                    validateN--;
                    if (validateN == 0)
                    {
                        if (mask)
                        {
                            if (clip)
                            {
                                mask.mask = clip;
                                clip.cacheAsBitmap = false;
                            }
                            maskRc = mask.getBounds(mask);
                            if (((maskRc.width > 0) && (maskRc.height > 0)))
                            {
                                matrix = new Matrix();
                                matrix.translate(-(maskRc.left), -(maskRc.top));
                                bmd = new BitmapData(maskRc.width, maskRc.height, true, 0);
                                bmd.draw(mask, matrix, null, null, null, true);
                                mask.filters = [_maskRgbToLuminanceFilter];
                                bmd.draw(mask, matrix, null, BlendMode.ALPHA, null, true);
                                _mask = new Bitmap(bmd);
                                _mask.x = maskRc.left;
                                _mask.y = maskRc.top;
                                addChild(_mask);
                                _mask.cacheAsBitmap = true;
                                content.cacheAsBitmap = true;
                                content.mask = _mask;
                            }
                            detachElement(mask);
                            if (clip)
                            {
                                detachElement(clip);
                                mask.mask = null;
                            }
                        }
                        else
                        {
                            if (clip)
                            {
                                _mask = clip;
                                _mask.cacheAsBitmap = false;
                                content.cacheAsBitmap = false;
                                addChild(_mask);
                                content.mask = _mask;
                            }
                        }
                    }
                }
                if ((((!(this.svgMask == null)) && (!(this.svgMask == ""))) && (!(this.svgMask == "none"))))
                {
                    maskId = SVGUtil.extractUrlId(this.svgMask);
                    mask = (this.document.getDefinitionClone(maskId) as SVGElement);
                    if (mask != null)
                    {
                        this.attachElement(mask);
                        mask.addEventListener(SVGEvent.VALIDATED, onClipOrMaskValidated);
                        validateN = (validateN + 1);
                    }
                }
                clipPathValue = ((this.finalStyle.getPropertyValue("clip-path")) || (this.svgClipPath));
                if ((((!(clipPathValue == null)) && (!(clipPathValue == ""))) && (!(clipPathValue == "none"))))
                {
                    clipPathId = SVGUtil.extractUrlId(clipPathValue);
                    clip = (this.document.getDefinitionClone(clipPathId) as SVGElement);
                    if (clip != null)
                    {
                        this.attachElement(clip);
                        clip.addEventListener(SVGEvent.VALIDATED, onClipOrMaskValidated);
                        validateN = (validateN + 1);
                    }
                }
            }
            if (this._displayChanged)
            {
                this._displayChanged = false;
                visible = ((!(this.finalStyle.getPropertyValue("display") == "none")) && (!(this.finalStyle.getPropertyValue("visibility") == "hidden")));
            }
            if (this._opacityChanged)
            {
                this._opacityChanged = false;
                this.content.alpha = Number(((this.finalStyle.getPropertyValue("opacity")) || (1)));
                if (((!(this.content.alpha == 1)) && (this is SVGContainer)))
                {
                    this.content.blendMode = BlendMode.LAYER;
                }
                else
                {
                    this.content.blendMode = BlendMode.NORMAL;
                }
            }
            if (this._svgFilterChanged)
            {
                this._svgFilterChanged = false;
                filters = [];
                filterLink = this.finalStyle.getPropertyValue("filter");
                if (filterLink)
                {
                    filterId = SVGUtil.extractUrlId(filterLink);
                    filterCollection = (this.document.getDefinition(filterId) as SVGFilterCollection);
                    if (filterCollection)
                    {
                        filters = filterCollection.getFlashFilters();
                    }
                }
                this.filters = filters;
            }
            if ((this is ISVGViewPort))
            {
                this.updateViewPortSize();
            }
        }
        protected function getViewPortUserUnit(s:String, reference:String):Number
        {
            var viewPortWidth:Number = 0;
            var viewPortHeight:Number = 0;
            if (this.parentElement == this.document)
            {
                viewPortWidth = this.document.availableWidth;
                viewPortHeight = this.document.availableHeight;
            }
            else
            {
                if (this.viewPortElement != null)
                {
                    viewPortWidth = this.viewPortElement.viewPortWidth;
                    viewPortHeight = this.viewPortElement.viewPortHeight;
                }
            }
            return (SVGUtil.getUserUnit(s, this._currentFontSize, viewPortWidth, viewPortHeight, reference));
        }
        public function clone():Object
        {
            var thisViewPort:ISVGViewPort;
            var cViewPort:ISVGViewPort;
            var clazz:Class = (Object(this).constructor as Class);
            var copy:SVGElement = new (clazz)();
            copy.svgClass = this.svgClass;
            copy.svgClipPath = this.svgClipPath;
            copy.svgMask = this.svgMask;
            this._style.cloneOn(copy.style);
            copy.id = (('????  Clone of "' + this.id) + '"');
            copy.svgTransform = this.svgTransform;
            if ((this is ISVGViewBox))
            {
                (copy as ISVGViewBox).svgViewBox = (this as ISVGViewBox).svgViewBox;
            }
            if ((this is ISVGPreserveAspectRatio))
            {
                (copy as ISVGPreserveAspectRatio).svgPreserveAspectRatio = (this as ISVGPreserveAspectRatio).svgPreserveAspectRatio;
            }
            if ((this is ISVGViewPort))
            {
                thisViewPort = (this as ISVGViewPort);
                cViewPort = (copy as ISVGViewPort);
                cViewPort.svgX = thisViewPort.svgX;
                cViewPort.svgY = thisViewPort.svgY;
                cViewPort.svgWidth = thisViewPort.svgWidth;
                cViewPort.svgHeight = thisViewPort.svgHeight;
                cViewPort.svgOverflow = thisViewPort.svgOverflow;
            }
            return (copy);
        }
        public function get viewPortWidth():Number
        {
            return (this._viewPortWidth);
        }
        public function get viewPortHeight():Number
        {
            return (this._viewPortHeight);
        }
        protected function updateViewPortSize():void
        {
            var viewPort:ISVGViewPort = (this as ISVGViewPort);
            if (viewPort == null)
            {
                throw (new Error((("Element '" + this.type) + "' isn't a viewPort.")));
            }
            if (((this is ISVGViewBox) && (!((this as ISVGViewBox).svgViewBox == null))))
            {
                this._viewPortWidth = (this as ISVGViewBox).svgViewBox.width;
                this._viewPortHeight = (this as ISVGViewBox).svgViewBox.height;
            }
            else
            {
                if (viewPort.svgWidth)
                {
                    this._viewPortWidth = this.getViewPortUserUnit(viewPort.svgWidth, SVGUtil.WIDTH);
                }
                if (viewPort.svgHeight)
                {
                    this._viewPortHeight = this.getViewPortUserUnit(viewPort.svgHeight, SVGUtil.HEIGHT);
                }
            }
        }
        protected function adjustContentToViewPort():void
        {
            var preserveAspectRatio:Object;
            var viewPortContentMetrics:Object;
            var viewPort:ISVGViewPort = (this as ISVGViewPort);
            if (viewPort == null)
            {
                throw (new Error((("Element '" + this.type) + "' isn't a viewPort.")));
            }
            scrollRect = null;
            this.content.scaleX = 1;
            this.content.scaleY = 1;
            this.content.x = 0;
            this.content.y = 0;
            var viewBoxRect:Rectangle = this.getViewBoxRect();
            var viewPortRect:Rectangle = this.getViewPortRect();
            var svgPreserveAspectRatio:String = this.getPreserveAspectRatio();
            if (((!(viewBoxRect == null)) && (!(viewPortRect == null))))
            {
                if (svgPreserveAspectRatio != "none")
                {
                    preserveAspectRatio = SVGParserCommon.parsePreserveAspectRatio(((svgPreserveAspectRatio) || ("")));
                    viewPortContentMetrics = SVGViewPortUtils.getContentMetrics(viewPortRect, viewBoxRect, preserveAspectRatio.align, preserveAspectRatio.meetOrSlice);
                    if (preserveAspectRatio.meetOrSlice == "slice")
                    {
                        this.scrollRect = viewPortRect;
                    }
                    this.content.x = viewPortContentMetrics.contentX;
                    this.content.y = viewPortContentMetrics.contentY;
                    this.content.scaleX = viewPortContentMetrics.contentScaleX;
                    this.content.scaleY = viewPortContentMetrics.contentScaleY;
                }
                else
                {
                    this.content.x = viewPortRect.x;
                    this.content.y = viewPortRect.y;
                    this.content.scaleX = (viewPortRect.width / this.content.width);
                    this.content.scaleY = (viewPortRect.height / this.content.height);
                }
            }
        }
        private function getViewBoxRect():Rectangle
        {
            if ((this is ISVGViewBox))
            {
                return ((this as ISVGViewBox).svgViewBox);
            }
            return (this.getContentBox());
        }
        protected function getContentBox():Rectangle
        {
            return (null);
        }
        private function getViewPortRect():Rectangle
        {
            var x:Number;
            var y:Number;
            var w:Number;
            var h:Number;
            var viewPort:ISVGViewPort = (this as ISVGViewPort);
            if ((((!(viewPort == null)) && (!(viewPort.svgWidth == null))) && (!(viewPort.svgHeight == null))))
            {
                x = ((viewPort.svgX) ? this.getViewPortUserUnit(viewPort.svgX, SVGUtil.WIDTH) : 0);
                y = ((viewPort.svgY) ? this.getViewPortUserUnit(viewPort.svgY, SVGUtil.HEIGHT) : 0);
                w = this.getViewPortUserUnit(viewPort.svgWidth, SVGUtil.WIDTH);
                h = this.getViewPortUserUnit(viewPort.svgHeight, SVGUtil.HEIGHT);
                return (new Rectangle(x, y, w, h));
            }
            return (null);
        }
        private function getPreserveAspectRatio():String
        {
            var viewPort:ISVGViewPort = (this as ISVGViewPort);
            if (viewPort != null)
            {
                return (viewPort.svgPreserveAspectRatio);
            }
            return (null);
        }

    }
}
