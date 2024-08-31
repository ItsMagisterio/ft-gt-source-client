package com.lorentz.SVG.display
{
    import com.lorentz.SVG.display.base.SVGContainer;
    import flash.net.URLLoader;
    import com.lorentz.SVG.parser.AsyncSVGParser;
    import com.lorentz.SVG.text.ISVGTextDrawer;
    import com.lorentz.SVG.text.FTESVGTextDrawer;
    import flash.net.URLRequest;
    import flash.net.URLLoaderDataFormat;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import com.lorentz.SVG.utils.SVGUtil;
    import com.lorentz.SVG.events.SVGEvent;
    import __AS3__.vec.Vector;
    import com.lorentz.SVG.data.style.StyleDeclaration;
    import com.lorentz.SVG.utils.ICloneable;
    import com.lorentz.SVG.display.base.SVGElement;
    import com.lorentz.SVG.utils.StringUtil;
    import flash.geom.Rectangle;
    import __AS3__.vec.*;

    [Event(name="invalidate", type="com.lorentz.SVG.events.SVGEvent")]
    [Event(name="syncValidated", type="com.lorentz.SVG.events.SVGEvent")]
    [Event(name="asyncValidated", type="com.lorentz.SVG.events.SVGEvent")]
    [Event(name="validated", type="com.lorentz.SVG.events.SVGEvent")]
    [Event(name="rendered", type="com.lorentz.SVG.events.SVGEvent")]
    [Event(name="parseStart", type="com.lorentz.SVG.events.SVGEvent")]
    [Event(name="parseComplete", type="com.lorentz.SVG.events.SVGEvent")]
    [Event(name="elementAdded", type="com.lorentz.SVG.events.SVGEvent")]
    [Event(name="elementRemoved", type="com.lorentz.SVG.events.SVGEvent")]
    public class SVGDocument extends SVGContainer
    {

        private var _urlLoader:URLLoader;
        private var _parser:AsyncSVGParser;
        private var _parsing:Boolean = false;
        private var _definitions:Object = {}
        private var _stylesDeclarations:Object = {}
        private var _firstValidationAfterParse:Boolean = false;
        private var _defaultBaseUrl:String;
        private var _availableWidth:Number = 500;
        private var _availableHeight:Number = 500;
        public var baseURL:String;
        public var validateWhileParsing:Boolean = true;
        public var validateAfterParse:Boolean = true;
        public var forceSynchronousParse:Boolean = false;
        public var defaultFontName:String = "Verdana";
        public var useEmbeddedFonts:Boolean = true;
        public var textDrawingInterceptor:Function;
        public var textDrawer:ISVGTextDrawer = new FTESVGTextDrawer();
        public var autoAlign:Boolean = false;
        private var _validationQueued:Boolean;

        public function SVGDocument()
        {
            super("document");
        }
        public static function isHttpURL(url:String):Boolean
        {
            return ((!(url == null)) && ((url.indexOf("http://") == 0) || (url.indexOf("https://") == 0)));
        }

        public function get defaultBaseUrl():String
        {
            return (this._defaultBaseUrl);
        }
        public function load(urlOrUrlRequest:Object):void
        {
            var urlRequest:URLRequest;
            if (this._urlLoader != null)
            {
                try
                {
                    this._urlLoader.close();
                }
                catch (e:Error)
                {
                }
                this._urlLoader = null;
            }
            if ((urlOrUrlRequest is URLRequest))
            {
                urlRequest = (urlOrUrlRequest as URLRequest);
            }
            else
            {
                if ((urlOrUrlRequest is String))
                {
                    urlRequest = new URLRequest(String(urlOrUrlRequest));
                }
                else
                {
                    throw (new Error("Invalid param 'urlOrUrlRequest'."));
                }
            }
            this._defaultBaseUrl = urlRequest.url.match(/^([^?]*\/)/g)[0];
            this._urlLoader = new URLLoader();
            this._urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
            this._urlLoader.addEventListener(Event.COMPLETE, this.urlLoader_completeHandler, false, 0, true);
            this._urlLoader.addEventListener(IOErrorEvent.IO_ERROR, this.urlLoader_ioErrorHandler, false, 0, true);
            this._urlLoader.load(urlRequest);
        }
        private function urlLoader_completeHandler(e:Event):void
        {
            if (e.currentTarget != this._urlLoader)
            {
                return;
            }
            var svgString:String = String(this._urlLoader.data);
            this.parseInternal(svgString);
            this._urlLoader = null;
        }
        private function urlLoader_ioErrorHandler(e:IOErrorEvent):void
        {
            if (e.currentTarget != this._urlLoader)
            {
                return;
            }
            trace(e.text);
            this._urlLoader = null;
        }
        public function parse(xmlOrXmlString:Object):void
        {
            this._defaultBaseUrl = null;
            this.parseInternal(xmlOrXmlString);
        }
        private function parseInternal(xmlOrXmlString:Object):void
        {
            var xml:XML;
            var xmlString:String;
            var oldXMLIgnoreWhitespace:Boolean;
            if ((xmlOrXmlString is String))
            {
                xmlString = SVGUtil.processXMLEntities(String(xmlOrXmlString));
                oldXMLIgnoreWhitespace = XML.ignoreWhitespace;
                XML.ignoreWhitespace = false;
                xml = new XML(xmlString);
                XML.ignoreWhitespace = oldXMLIgnoreWhitespace;
            }
            else
            {
                if ((xmlOrXmlString is XML))
                {
                    xml = (xmlOrXmlString as XML);
                }
                else
                {
                    throw (new Error("Invalid param 'xmlOrXmlString'."));
                }
            }
            this.parseXML(xml);
        }
        private function parseXML(svg:XML):void
        {
            this.clear();
            if (this._parsing)
            {
                this._parser.cancel();
            }
            this._parsing = true;
            if (hasEventListener(SVGEvent.PARSE_START))
            {
                dispatchEvent(new SVGEvent(SVGEvent.PARSE_START));
            }
            this._parser = new AsyncSVGParser(this, svg);
            this._parser.addEventListener(Event.COMPLETE, this.parser_completeHandler);
            this._parser.parse(this.forceSynchronousParse);
        }
        protected function parser_completeHandler(e:Event):void
        {
            this._parsing = false;
            this._parser = null;
            if (hasEventListener(SVGEvent.PARSE_COMPLETE))
            {
                dispatchEvent(new SVGEvent(SVGEvent.PARSE_COMPLETE));
            }
            this._firstValidationAfterParse = true;
            if (this.validateAfterParse)
            {
                this.validate();
            }
        }
        override protected function onValidated():void
        {
            super.onValidated();
            if (this._firstValidationAfterParse)
            {
                this._firstValidationAfterParse = false;
                if (hasEventListener(SVGEvent.RENDERED))
                {
                    dispatchEvent(new SVGEvent(SVGEvent.RENDERED));
                }
            }
        }
        public function clear():void
        {
            var id:String;
            id = null;
            svgClass = null;
            svgClipPath = null;
            svgMask = null;
            svgTransform = null;
            this._stylesDeclarations = {}
            style.clear();
            for (id in this._definitions)
            {
                this.removeDefinition(id);
            }
            while (numElements > 0)
            {
                removeElementAt(0);
            }
            while (content.numChildren > 0)
            {
                content.removeChildAt(0);
            }
            content.scaleX = 1;
            content.scaleY = 1;
        }
        public function listStyleDeclarations():Vector.<String>
        {
            var id:String;
            var selectorsList:Vector.<String> = new Vector.<String>();
            for (id in this._stylesDeclarations)
            {
                selectorsList.push(id);
            }
            return (selectorsList);
        }
        public function addStyleDeclaration(selector:String, styleDeclaration:StyleDeclaration):void
        {
            this._stylesDeclarations[selector] = styleDeclaration;
        }
        public function getStyleDeclaration(selector:String):StyleDeclaration
        {
            return (this._stylesDeclarations[selector]);
        }
        public function removeStyleDeclaration(selector:String):StyleDeclaration
        {
            var value:StyleDeclaration = this._stylesDeclarations[selector];
            delete this._stylesDeclarations[selector];
            return (value);
        }
        public function listDefinitions():Vector.<String>
        {
            var id:String;
            var definitionsList:Vector.<String> = new Vector.<String>();
            for (id in this._definitions)
            {
                definitionsList.push(id);
            }
            return (definitionsList);
        }
        public function addDefinition(id:String, object:Object):void
        {
            if ((!(this._definitions[id])))
            {
                this._definitions[id] = object;
            }
        }
        public function hasDefinition(id:String):Boolean
        {
            return (!(this._definitions[id] == null));
        }
        public function getDefinition(id:String):Object
        {
            return (this._definitions[id]);
        }
        public function getDefinitionClone(id:String):Object
        {
            var object:Object = this._definitions[id];
            if ((object is ICloneable))
            {
                return ((object as ICloneable).clone());
            }
            return (object);
        }
        public function removeDefinition(id:String):void
        {
            if (this._definitions[id])
            {
                this._definitions[id] = null;
            }
        }
        public function onElementAdded(element:SVGElement):void
        {
            if (hasEventListener(SVGEvent.ELEMENT_ADDED))
            {
                dispatchEvent(new SVGEvent(SVGEvent.ELEMENT_ADDED, element));
            }
        }
        public function onElementRemoved(element:SVGElement):void
        {
            if (hasEventListener(SVGEvent.ELEMENT_REMOVED))
            {
                dispatchEvent(new SVGEvent(SVGEvent.ELEMENT_REMOVED, element));
            }
        }
        public function resolveURL(url:String):String
        {
            var slashPos:Number;
            var baseUrlFinal:String = ((this.baseURL) || (this.defaultBaseUrl));
            if ((((!(url == null)) && (!(isHttpURL(url)))) && (baseUrlFinal)))
            {
                if (url.indexOf("./") == 0)
                {
                    url = url.substring(2);
                }
                if (isHttpURL(baseUrlFinal))
                {
                    if (url.charAt(0) == "/")
                    {
                        slashPos = baseUrlFinal.indexOf("/", 8);
                        if (slashPos == -1)
                        {
                            slashPos = baseUrlFinal.length;
                        }
                    }
                    else
                    {
                        slashPos = (baseUrlFinal.lastIndexOf("/") + 1);
                        if (slashPos <= 8)
                        {
                            baseUrlFinal = (baseUrlFinal + "/");
                            slashPos = baseUrlFinal.length;
                        }
                    }
                    if (slashPos > 0)
                    {
                        url = (baseUrlFinal.substring(0, slashPos) + url);
                    }
                }
                else
                {
                    url = ((StringUtil.rtrim(baseUrlFinal, "/") + "/") + url);
                }
            }
            return (url);
        }
        override public function validate():void
        {
            super.validate();
            if (this.numInvalidElements > 0)
            {
                this.queueValidation();
            }
        }
        override protected function get numInvalidElements():int
        {
            return (super.numInvalidElements);
        }
        override protected function set numInvalidElements(value:int):void
        {
            if (((super.numInvalidElements == 0) && (value > 0)))
            {
                this.queueValidation();
            }
            super.numInvalidElements = value;
        }
        protected function queueValidation():void
        {
            if ((!(this._validationQueued)))
            {
                this._validationQueued = false;
                if (stage != null)
                {
                    stage.addEventListener(Event.ENTER_FRAME, this.validateCaller, false, 0, false);
                    stage.addEventListener(Event.RENDER, this.validateCaller, false, 0, true);
                    stage.invalidate();
                }
                else
                {
                    addEventListener(Event.ADDED_TO_STAGE, this.validateCaller, false, 0, true);
                }
            }
        }
        protected function validateCaller(e:Event):void
        {
            this._validationQueued = false;
            if (((this._parsing) && (!(this.validateWhileParsing))))
            {
                this.queueValidation();
                return;
            }
            if (e.type == Event.ADDED_TO_STAGE)
            {
                removeEventListener(Event.ADDED_TO_STAGE, this.validateCaller);
            }
            else
            {
                e.target.removeEventListener(Event.ENTER_FRAME, this.validateCaller, false);
                e.target.removeEventListener(Event.RENDER, this.validateCaller, false);
                if (stage == null)
                {
                    addEventListener(Event.ADDED_TO_STAGE, this.validateCaller, false, 0, true);
                    return;
                }
            }
            this.validate();
        }
        override protected function onPartialyValidated():void
        {
            var bounds:Rectangle;
            super.onPartialyValidated();
            if (this.autoAlign)
            {
                bounds = content.getBounds(content);
                content.x = -(bounds.left);
                content.y = -(bounds.top);
            }
            else
            {
                content.x = 0;
                content.y = 0;
            }
        }
        public function get availableWidth():Number
        {
            return (this._availableWidth);
        }
        public function set availableWidth(value:Number):void
        {
            this._availableWidth = value;
        }
        public function get availableHeight():Number
        {
            return (this._availableHeight);
        }
        public function set availableHeight(value:Number):void
        {
            this._availableHeight = value;
        }
        override public function clone():Object
        {
            var id:String;
            var selector:String;
            var object:Object;
            var style:StyleDeclaration;
            var c:SVGDocument = (super.clone() as SVGDocument);
            c.availableWidth = this.availableWidth;
            c.availableHeight = this.availableHeight;
            c._defaultBaseUrl = this._defaultBaseUrl;
            c.baseURL = this.baseURL;
            c.validateWhileParsing = this.validateWhileParsing;
            c.validateAfterParse = this.validateAfterParse;
            c.defaultFontName = this.defaultFontName;
            c.useEmbeddedFonts = this.useEmbeddedFonts;
            c.textDrawingInterceptor = this.textDrawingInterceptor;
            c.textDrawer = this.textDrawer;
            for each (id in this.listDefinitions())
            {
                object = this.getDefinition(id);
                if ((object is ICloneable))
                {
                    c.addDefinition(id, (object as ICloneable).clone());
                }
            }
            for each (selector in this.listStyleDeclarations())
            {
                style = this.getStyleDeclaration(selector);
                c.addStyleDeclaration(selector, (style.clone() as StyleDeclaration));
            }
            return (c);
        }

    }
} // package com.lorentz.SVG.display