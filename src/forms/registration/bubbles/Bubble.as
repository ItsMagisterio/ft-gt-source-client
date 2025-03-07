package forms.registration.bubbles
{
   import alternativa.tanks.help.HelperAlign;
   import alternativa.tanks.help.HelperArrowDirection;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.display.StageQuality;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.text.AntiAliasType;
   import flash.text.GridFitType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;

   public class Bubble extends Sprite
   {

      public static const r:int = 16;

      private static const lineThickness:int = 1;

      private static const lineColor:uint = 16777215;

      private static const fillColor:uint = 0;

      private static const lineAlpha:Number = 1;

      private static const fillAlpha:Number = 0.85;

      private static const arrowShift:int = r * 1.5;

      private static const arrowWidth:int = r * 1.5;

      private static var defaultTextFormat:TextFormat = new TextFormat("Tahoma", 10, 16777215, true);

      private static var embededFont:Boolean = false;

      private var back:Shape;

      private var outline:Shape;

      private var _arrowLehgth:int = 48.0;

      private var _arrowAlign:int;

      private var arrowP1:Point;

      private var arrowP2:Point;

      private var arrowTarget:Point;

      private var outlineArrowP1:Point;

      private var outlineArrowP2:Point;

      private var outlineArrowTarget:Point;

      private var arrowDirection:Boolean;

      private var descriptionLabel:TextField;

      private var margin:int = 12;

      private var bmp:Bitmap;

      private var backContainer:Sprite;

      private var _size:Point;

      public var relativePosition:Point;

      public function Bubble(relativePosition:Point)
      {
         this.arrowP1 = new Point();
         this.arrowP2 = new Point();
         this.arrowTarget = new Point();
         this.outlineArrowP1 = new Point();
         this.outlineArrowP2 = new Point();
         this.outlineArrowTarget = new Point();
         this._size = new Point();
         super();
         this.relativePosition = relativePosition;
         this.bmp = new Bitmap();
         addChild(this.bmp);
         this.backContainer = new Sprite();
         this.backContainer.mouseEnabled = false;
         this.backContainer.mouseChildren = false;
         this.backContainer.tabEnabled = false;
         this.backContainer.tabChildren = false;
         this.outline = new Shape();
         this.backContainer.addChild(this.outline);
         this.back = new Shape();
         this.backContainer.addChild(this.back);
         this.arrowAlign = HelperAlign.MIDDLE_RIGHT;
         this.descriptionLabel = new TextField();
         this.descriptionLabel.defaultTextFormat = defaultTextFormat;
         this.descriptionLabel.embedFonts = embededFont;
         this.descriptionLabel.antiAliasType = AntiAliasType.ADVANCED;
         this.descriptionLabel.gridFitType = GridFitType.SUBPIXEL;
         this.descriptionLabel.autoSize = TextFieldAutoSize.LEFT;
         this.descriptionLabel.sharpness = -150;
         this.descriptionLabel.thickness = -150;
         this.descriptionLabel.wordWrap = false;
         this.descriptionLabel.multiline = true;
         this.descriptionLabel.selectable = false;
         addChild(this.descriptionLabel);
         this.descriptionLabel.x = this.margin - 3;
         this.descriptionLabel.y = this.margin - 4;
         this.descriptionLabel.mouseEnabled = false;
         this.descriptionLabel.tabEnabled = false;
         addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
      }

      private function onAddedToStage(e:Event):void
      {
         removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
         this.draw();
         addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
         addEventListener(MouseEvent.CLICK, this.onMouseClick);
         stage.addEventListener(Event.RESIZE, this.onResize);
         this.onResize();
      }

      private function onMouseClick(e:MouseEvent):void
      {
         parent.removeChild(this);
      }

      private function onRemovedFromStage(e:Event):void
      {
         removeEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
         stage.removeEventListener(Event.RESIZE, this.onResize);
         stage.removeEventListener(MouseEvent.CLICK, this.onMouseClick);
      }

      private function onResize(e:Event = null):void
      {
         this.doAlign();
      }

      public function hide():void
      {
         if (parent)
         {
            parent.removeChild(this);
         }
      }

      protected function draw():void
      {
         this.outline.graphics.clear();
         this.outline.graphics.beginFill(lineColor, lineAlpha);
         this.outline.graphics.drawRoundRect(-lineThickness, -lineThickness, this._size.x + lineThickness * 2, this._size.y + lineThickness * 2, r + 2, r + 2);
         this.outline.graphics.drawRoundRect(0, 0, this._size.x, this._size.y, r, r);
         this.back.graphics.clear();
         this.back.graphics.beginFill(fillColor, fillAlpha);
         this.back.graphics.drawRoundRect(0, 0, this._size.x, this._size.y, r, r);
         var tga:Number = this._arrowLehgth / arrowWidth;
         if (this._arrowAlign & HelperAlign.TOP_MASK)
         {
            this.arrowP1.y = 0;
            this.arrowP2.y = 0;
            this.arrowTarget.y = -this._arrowLehgth;
            this.outlineArrowP1.y = 0;
            this.outlineArrowP2.y = 0;
            this.outlineArrowTarget.y = -tga * (arrowWidth + lineThickness * 2);
         }
         else if (this._arrowAlign & HelperAlign.MIDDLE_MASK)
         {
            this.arrowP1.y = this._size.y - arrowWidth >> 1;
            this.arrowP2.y = this.arrowP1.y + arrowWidth;
            this.arrowTarget.y = this.arrowP1.y;
            this.outlineArrowP1.y = this.arrowP1.y - lineThickness;
            this.outlineArrowP2.y = this.arrowP1.y + arrowWidth + lineThickness;
            this.outlineArrowTarget.y = this.outlineArrowP1.y;
         }
         else
         {
            this.arrowP1.y = this._size.y;
            this.arrowP2.y = this._size.y;
            this.arrowTarget.y = this._size.y + this._arrowLehgth;
            this.outlineArrowP1.y = this._size.y;
            this.outlineArrowP2.y = this._size.y;
            this.outlineArrowTarget.y = this._size.y + tga * (arrowWidth + lineThickness * 2);
         }
         if (this._arrowAlign & HelperAlign.LEFT_MASK)
         {
            if (this.arrowDirection == HelperArrowDirection.VERTICAL)
            {
               this.arrowTarget.x = arrowShift;
               this.arrowP1.x = arrowShift;
               this.arrowP2.x = arrowShift + arrowWidth;
               this.outlineArrowTarget.x = arrowShift - lineThickness;
               this.outlineArrowP1.x = arrowShift - lineThickness;
               this.outlineArrowP2.x = arrowShift + arrowWidth + lineThickness;
            }
            else
            {
               this.arrowTarget.x = -this._arrowLehgth;
               this.arrowP1.x = 0;
               this.arrowP2.x = 0;
               this.outlineArrowTarget.x = -tga * (arrowWidth + lineThickness * 2);
               this.outlineArrowP1.x = 0;
               this.outlineArrowP2.x = 0;
            }
            if (this._arrowAlign & HelperAlign.TOP_MASK)
            {
               this.outline.graphics.drawRect(this.arrowP1.x, this.arrowP1.y - lineThickness, this.arrowP2.x - this.arrowP1.x, lineThickness);
            }
            else if (this._arrowAlign & HelperAlign.MIDDLE_MASK)
            {
               this.outline.graphics.drawRect(this.arrowP1.x - lineThickness, this.arrowP1.y, lineThickness, this.arrowP2.y - this.arrowP1.y);
            }
            else
            {
               this.outline.graphics.drawRect(this.arrowP1.x, this.arrowP1.y, this.arrowP2.x - this.arrowP1.x, lineThickness);
            }
         }
         else if (this._arrowAlign & HelperAlign.CENTER_MASK)
         {
            this.arrowTarget.x = this._size.x - arrowWidth >> 1;
            this.arrowP1.x = this.arrowTarget.x;
            this.arrowP2.x = this.arrowTarget.x + arrowWidth;
            this.outlineArrowTarget.x = this.arrowTarget.x - lineThickness;
            this.outlineArrowP1.x = this.outlineArrowTarget.x;
            this.outlineArrowP2.x = this.arrowP2.x + lineThickness;
            if (this._arrowAlign & HelperAlign.TOP_MASK)
            {
               this.outline.graphics.drawRect(this.arrowP1.x, this.arrowP1.y - lineThickness, this.arrowP2.x - this.arrowP1.x, lineThickness);
            }
            else
            {
               this.outline.graphics.drawRect(this.arrowP1.x, this.arrowP1.y, this.arrowP2.x - this.arrowP1.x, lineThickness);
            }
         }
         else
         {
            if (this.arrowDirection == HelperArrowDirection.VERTICAL)
            {
               this.arrowTarget.x = this._size.x - arrowShift;
               this.arrowP1.x = this.arrowTarget.x;
               this.arrowP2.x = this.arrowP1.x - arrowWidth;
               this.outlineArrowTarget.x = this.arrowTarget.x + lineThickness;
               this.outlineArrowP1.x = this.outlineArrowTarget.x;
               this.outlineArrowP2.x = this.arrowTarget.x - arrowWidth - lineThickness;
            }
            else
            {
               this.arrowTarget.x = this._size.x + this._arrowLehgth;
               this.arrowP1.x = this._size.x;
               this.arrowP2.x = this._size.x;
               this.outlineArrowTarget.x = this._size.x + tga * (arrowWidth + lineThickness * 2);
               this.outlineArrowP1.x = this._size.x;
               this.outlineArrowP2.x = this._size.x;
            }
            if (this._arrowAlign & HelperAlign.TOP_MASK)
            {
               this.outline.graphics.drawRect(this.arrowP1.x, this.arrowP1.y - lineThickness, this.arrowP2.x - this.arrowP1.x, lineThickness);
            }
            else if (this._arrowAlign & HelperAlign.MIDDLE_MASK)
            {
               this.outline.graphics.drawRect(this.arrowP1.x, this.arrowP1.y, lineThickness, this.arrowP2.y - this.arrowP1.y);
            }
            else
            {
               this.outline.graphics.drawRect(this.arrowP1.x, this.arrowP1.y, this.arrowP2.x - this.arrowP1.x, lineThickness);
            }
         }
         this.back.graphics.moveTo(this.arrowTarget.x, this.arrowTarget.y);
         this.back.graphics.lineTo(this.arrowP1.x, this.arrowP1.y);
         this.back.graphics.lineTo(this.arrowP2.x, this.arrowP2.y);
         this.back.graphics.lineTo(this.arrowTarget.x, this.arrowTarget.y);
         this.outline.graphics.beginFill(lineColor, lineAlpha);
         this.outline.graphics.moveTo(this.outlineArrowTarget.x, this.outlineArrowTarget.y);
         this.outline.graphics.lineTo(this.outlineArrowP1.x, this.outlineArrowP1.y);
         this.outline.graphics.lineTo(this.outlineArrowP2.x, this.outlineArrowP2.y);
         this.outline.graphics.lineTo(this.outlineArrowTarget.x, this.outlineArrowTarget.y);
         this.outline.graphics.moveTo(this.arrowTarget.x, this.arrowTarget.y);
         this.outline.graphics.lineTo(this.arrowP1.x, this.arrowP1.y);
         this.outline.graphics.lineTo(this.arrowP2.x, this.arrowP2.y);
         this.outline.graphics.lineTo(this.arrowTarget.x, this.arrowTarget.y);
         var stageQuality:String = stage.quality;
         stage.quality = StageQuality.HIGH;
         var matrix:Matrix = new Matrix();
         if (this.outlineArrowTarget.x < 0)
         {
            matrix.tx = -Math.round(this.outlineArrowTarget.x);
            this.bmp.x = Math.round(this.outlineArrowTarget.x);
         }
         else
         {
            matrix.tx = lineThickness;
            this.bmp.x = -lineThickness;
         }
         if (this.outlineArrowTarget.y < 0)
         {
            matrix.ty = -Math.round(this.outlineArrowTarget.y);
            this.bmp.y = Math.round(this.outlineArrowTarget.y);
         }
         else
         {
            matrix.ty = lineThickness;
            this.bmp.y = -lineThickness;
         }
         this.bmp.bitmapData = new BitmapData(Math.round(this.outline.width), Math.round(this.outline.height), true, 0);
         this.bmp.bitmapData.draw(this.backContainer, matrix, new ColorTransform(), BlendMode.NORMAL, null, true);
         stage.quality = stageQuality;
         this.descriptionLabel.width = this._size.x - this.margin * 2;
      }

      protected function doAlign():void
      {
         x = Math.round(this.relativePosition.x - this.outlineArrowTarget.x);
         y = Math.round(this.relativePosition.y - this.outlineArrowTarget.y);
      }

      public function get arrowLehgth():int
      {
         return this._arrowLehgth;
      }

      public function set arrowLehgth(value:int):void
      {
         this._arrowLehgth = value;
      }

      public function get arrowAlign():int
      {
         return this._arrowAlign;
      }

      public function set arrowAlign(value:int):void
      {
         this._arrowAlign = value == HelperAlign.MIDDLE_CENTER ? int(HelperAlign.BOTTOM_LEFT) : int(value);
         if (this._arrowAlign & HelperAlign.TOP_MASK || this._arrowAlign & HelperAlign.BOTTOM_MASK)
         {
            this.arrowDirection = HelperArrowDirection.VERTICAL;
         }
         else
         {
            this.arrowDirection = HelperArrowDirection.HORIZONTAL;
         }
      }

      public function set text(value:String):void
      {
         this.descriptionLabel.htmlText = value;
         this._size.x = Math.round(this.descriptionLabel.textWidth + this.margin * 2);
         this._size.y = Math.round(this.descriptionLabel.textHeight + this.margin * 2) - 3;
      }
   }
}
