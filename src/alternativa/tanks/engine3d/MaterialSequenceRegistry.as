package alternativa.tanks.engine3d
{
    import flash.utils.Dictionary;
    import __AS3__.vec.Vector;
    import flash.utils.Timer;
    import flash.display.BitmapData;
    import alternativa.engine3d.alternativa3d;
    import flash.events.TimerEvent;
    import __AS3__.vec.*;

    public class MaterialSequenceRegistry implements IMaterialSequenceRegistry
    {

        private var _useMipMapping:Boolean;
        private var sequenceByImage:Dictionary = new Dictionary();
        private var scheduledSequences:Vector.<MaterialSequence> = new Vector.<MaterialSequence>();
        private var numScheduledSequences:int;
        private var timer:Timer;

        public function MaterialSequenceRegistry(timerInterval:int)
        {
            this.timer = new Timer(timerInterval);
        }
        public function set timerInterval(value:int):void
        {
            this.timer.delay = value;
        }
        public function get useMipMapping():Boolean
        {
            return (this._useMipMapping);
        }
        public function set useMipMapping(value:Boolean):void
        {
            this._useMipMapping = value;
        }
        public function getSequence(materialType:MaterialType, sourceImage:BitmapData, frameWidth:int, mipMapResolution:Number, disposeSourceImage:Boolean = false, createMirroredFrames:Boolean = false):MaterialSequence
        {
            var sequence:MaterialSequence = this.sequenceByImage[sourceImage];
            if (sequence == null)
            {
                sequence = new MaterialSequence(this, sourceImage, frameWidth, createMirroredFrames, disposeSourceImage, this._useMipMapping, mipMapResolution);
                this.sequenceByImage[sourceImage] = sequence;
                this.scheduleSequence(sequence);
            }
            sequence.referenceCount++;
            return (sequence);
        }
        public function getSquareSequence(materialType:MaterialType, sourceImage:BitmapData, mipMapResolution:Number, disposeSourceImage:Boolean = false, createMirroredFrames:Boolean = false):MaterialSequence
        {
            return (this.getSequence(materialType, sourceImage, sourceImage.height, mipMapResolution, disposeSourceImage, createMirroredFrames));
        }
        public function clear():void
        {
            var sequence:MaterialSequence;
            for each (sequence in this.sequenceByImage)
            {
                this.disposeSequence(sequence);
            }
        }
        public function getDump():String
        {
            var numSequences:int;
            var totalBitmapSize:int;
            var numMaps:int;
            var key:* = undefined;
            var numSequenceMaps:int;
            var sequence:MaterialSequence;
            var materialIndex:int;
            var material:TanksTextureMaterial;
            var mapIndex:int;
            var bmp:BitmapData;
            var w:int;
            var h:int;
            var s:String = "=== MaterialSequenceRegistry ===\n";
            for (key in this.sequenceByImage)
            {
                numSequences++;
                numSequenceMaps = 0;
                sequence = this.sequenceByImage[key];
                materialIndex = 0;
                while (materialIndex < sequence.materials.length)
                {
                    material = TanksTextureMaterial(sequence.materials[materialIndex]);
                    if (material.mipMapping)
                    {
                        mapIndex = 0;
                        /*while (mapIndex < material.) {
                            bmp = material.alternativa3d::mipMap[mapIndex];
                            totalBitmapSize = (totalBitmapSize + ((bmp.height * bmp.width) * 4));
                            mapIndex++;
                        }*/
                        // numSequenceMaps = (numSequenceMaps + material.alternativa3d::numMaps);
                    }
                    else
                    {
                        w = material.texture.width;
                        h = material.texture.height;
                        totalBitmapSize = (totalBitmapSize + ((w * h) * 4));
                    }
                    materialIndex++;
                }
                numMaps = (numMaps + numSequenceMaps);
                s = (s + (((("Sequence " + numSequences) + ": numMaps: ") + numSequenceMaps) + "\n"));
            }
            s = (s + (((((((("Total mipmaps: " + numMaps) + "\n") + "Total bitmap size: ") + totalBitmapSize) + "\n") + "Scheduled sequences: ") + this.numScheduledSequences) + "\n"));
            return (s);
        }
        public function disposeSequence(sequence:MaterialSequence):void
        {
            delete this.sequenceByImage[sequence.sourceImage];
            var index:int = this.scheduledSequences.indexOf(sequence);
            if (index > -1)
            {
                this.removeScheduledSequence(index);
            }
            sequence.dispose();
        }
        private function scheduleSequence(sequence:MaterialSequence):void
        {
            var _loc2_:* = this.numScheduledSequences++;
            this.scheduledSequences[_loc2_] = sequence;
            if (this.numScheduledSequences == 1)
            {
                this.timer.addEventListener(TimerEvent.TIMER, this.onTimer);
                this.timer.start();
            }
        }
        private function removeScheduledSequence(index:int):void
        {
            this.scheduledSequences[index] = this.scheduledSequences[-- this.numScheduledSequences];
            this.scheduledSequences[this.numScheduledSequences] = null;
            if (this.numScheduledSequences == 0)
            {
                this.timer.stop();
                this.timer.removeEventListener(TimerEvent.TIMER, this.onTimer);
            }
        }
        private function onTimer(e:TimerEvent):void
        {
            var sequence:MaterialSequence;
            var i:int;
            while (i < this.numScheduledSequences)
            {
                sequence = this.scheduledSequences[i];
                if (sequence.tick())
                {
                    this.removeScheduledSequence(i);
                    i--;
                }
                i++;
            }
        }

    }
}
