package alternativa.tanks.sound
{
    import __AS3__.vec.Vector;
    import flash.utils.Dictionary;
    import alternativa.math.Vector3;
    import flash.media.SoundTransform;
    import flash.media.SoundChannel;
    import flash.media.Sound;
    import alternativa.tanks.sfx.ISound3DEffect;
    import alternativa.tanks.camera.GameCamera;
    import alternativa.object.ClientObject;
    import flash.events.Event;
    import __AS3__.vec.*;

    public class SoundManager implements ISoundManager
    {

        private var maxDistanceSqr:Number;
        private var maxSounds:int = 10;
        private var maxSounds3D:int = 20;
        private var effects:Vector.<SoundEffectData> = new Vector.<SoundEffectData>();
        private var numEffects:int;
        private var sounds:Dictionary = new Dictionary();
        private var numSounds:int;
        private var _position:Vector3 = new Vector3();
        private var sortingStack:Vector.<int> = new Vector.<int>();

        public static function createSoundManager(testSound:Sound):ISoundManager
        {
            var channel:SoundChannel = testSound.play(0, 1, new SoundTransform(0));
            if (channel != null)
            {
                channel.stop();
                return (new (SoundManager)());
            }
            return (new DummySoundManager());
        }

        public function set maxDistance(value:Number):void
        {
            this.maxDistanceSqr = (value * value);
        }
        public function playSound(sound:Sound, startTime:int = 0, loops:int = 0, soundTransform:SoundTransform = null):SoundChannel
        {
            if (((this.numSounds == this.maxSounds) || (sound == null)))
            {
                return (null);
            }
            var channel:SoundChannel = sound.play(startTime, loops, soundTransform);
            if (channel == null)
            {
                return (null);
            }
            this.addSoundChannel(channel);
            return (channel);
        }
        public function stopSound(channel:SoundChannel):void
        {
            if (((channel == null) || (this.sounds[channel] == null)))
            {
                return;
            }
            this.removeSoundChannel(channel);
        }
        public function stopAllSounds():void
        {
            var channel:*;
            for (channel in this.sounds)
            {
                this.removeSoundChannel((channel as SoundChannel));
            }
        }
        public function addEffect(effect:ISound3DEffect):void
        {
            if (this.getEffectIndex(effect) > -1)
            {
                return;
            }
            effect.enabled = true;
            this.effects.push(SoundEffectData.create(0, effect));
            this.numEffects++;
        }
        public function removeEffect(effect:ISound3DEffect):void
        {
            var data:SoundEffectData;
            var i:int;
            while (i < this.numEffects)
            {
                data = this.effects[i];
                if (data.effect == effect)
                {
                    effect.destroy();
                    SoundEffectData.destroy(data);
                    this.effects.splice(i, 1);
                    this.numEffects--;
                    return;
                }
                i++;
            }
        }
        public function removeAllEffects():void
        {
            var data:SoundEffectData;
            while (this.effects.length > 0)
            {
                data = this.effects.pop();
                data.effect.destroy();
                SoundEffectData.destroy(data);
            }
            this.numEffects = 0;
        }
        public function updateSoundEffects(millis:int, camera:GameCamera):void
        {
            var data:SoundEffectData;
            var i:int;
            var numSounds:int;
            if (this.numEffects == 0)
            {
                return;
            }
            this.sortEffects(camera.pos);
            var num:int;
            i = 0;
            while (i < this.numEffects)
            {
                data = this.effects[i];
                numSounds = data.effect.numSounds;
                if (numSounds == 0)
                {
                    data.effect.destroy();
                    SoundEffectData.destroy(data);
                    this.effects.splice(i, 1);
                    this.numEffects--;
                    i--;
                }
                else
                {
                    if (((data.distanceSqr > this.maxDistanceSqr) || ((num + numSounds) > this.maxSounds3D)))
                    {
                        break;
                    }
                    data.effect.enabled = true;
                    data.effect.play(millis, camera);
                    num = (num + numSounds);
                }
                i++;
            }
            while (i < this.numEffects)
            {
                data = this.effects[i];
                data.effect.enabled = false;
                if (data.effect.numSounds == 0)
                {
                    data.effect.destroy();
                    SoundEffectData.destroy(data);
                    this.effects.splice(i, 1);
                    this.numEffects--;
                    i--;
                }
                i++;
            }
        }
        public function killEffectsByOwner(owner:ClientObject):void
        {
            var soundEffectData:SoundEffectData;
            var effect:ISound3DEffect;
            var i:int;
            while (i < this.numEffects)
            {
                soundEffectData = this.effects[i];
                effect = soundEffectData.effect;
                if (effect.owner == owner)
                {
                    effect.kill();
                }
                i++;
            }
        }
        private function addSoundChannel(channel:SoundChannel):void
        {
            channel.addEventListener(Event.SOUND_COMPLETE, this.onSoundComplete);
            this.sounds[channel] = true;
            this.numSounds++;
        }
        private function removeSoundChannel(channel:SoundChannel):void
        {
            channel.stop();
            channel.removeEventListener(Event.SOUND_COMPLETE, this.onSoundComplete);
            delete this.sounds[channel];
            this.numSounds--;
        }
        private function onSoundComplete(e:Event):void
        {
            this.stopSound((e.target as SoundChannel));
        }
        private function getEffectIndex(effect:ISound3DEffect):int
        {
            var i:int;
            while (i < this.numEffects)
            {
                if (SoundEffectData(this.effects[i]).effect == effect)
                {
                    return (i);
                }
                i++;
            }
            return (-1);
        }
        private function sortEffects(cameraPos:Vector3):void
        {
            var i:int;
            var j:int;
            var sortingStackIndex:int;
            var sortingMedian:Number;
            var data:SoundEffectData;
            var sortingLeft:SoundEffectData;
            var sortingRight:SoundEffectData;
            var dx:Number;
            var dy:Number;
            var dz:Number;
            var left:int;
            var right:int = (this.numEffects - 1);
            i = 0;
            while (i < this.numEffects)
            {
                data = this.effects[i];
                data.effect.readPosition(this._position);
                dx = (cameraPos.x - this._position.x);
                dy = (cameraPos.y - this._position.y);
                dz = (cameraPos.z - this._position.z);
                data.distanceSqr = (((dx * dx) + (dy * dy)) + (dz * dz));
                i++;
            }
            if (this.numEffects == 1)
            {
                return;
            }
            this.sortingStack[0] = left;
            this.sortingStack[1] = right;
            sortingStackIndex = 2;
            while (sortingStackIndex > 0)
            {
                j = (right = this.sortingStack[-- sortingStackIndex]);
                i = (left = this.sortingStack[-- sortingStackIndex]);
                sortingMedian = SoundEffectData(this.effects[((right + left) >> 1)]).distanceSqr;
                do
                {
                    while ((sortingLeft = this.effects[i]).distanceSqr < sortingMedian)
                    {
                        i++;
                    }
                    while ((sortingRight = this.effects[j]).distanceSqr > sortingMedian)
                    {
                        j--;
                    }
                    if (i <= j)
                    {
                        var _local_14:* = i++;
                        this.effects[_local_14] = sortingRight;
                        var _local_15:* = j--;
                        this.effects[_local_15] = sortingLeft;
                    }
                }
                while (i <= j);
                if (left < j)
                {
                    _local_14 = sortingStackIndex++;
                    this.sortingStack[_local_14] = left;
                    _local_15 = sortingStackIndex++;
                    this.sortingStack[_local_15] = j;
                }
                if (i < right)
                {
                    _local_14 = sortingStackIndex++;
                    this.sortingStack[_local_14] = i;
                    _local_15 = sortingStackIndex++;
                    this.sortingStack[_local_15] = right;
                }
            }
        }

    }
}

import __AS3__.vec.Vector;
import alternativa.tanks.sfx.ISound3DEffect;
import __AS3__.vec.*;

class SoundEffectData
{

    private static var pool:Vector.<SoundEffectData> = new Vector.<SoundEffectData>();
    private static var numObjects:int;

    public var distanceSqr:Number;
    public var effect:ISound3DEffect;

    public function SoundEffectData(distanceSqr:Number, effect:ISound3DEffect)
    {
        this.distanceSqr = distanceSqr;
        this.effect = effect;
    }
    public static function create(distanceSqr:Number, effect:ISound3DEffect):SoundEffectData
    {
        var data:SoundEffectData;
        if (numObjects > 0)
        {
            data = pool[-- numObjects];
            pool[numObjects] = null;
            data.distanceSqr = distanceSqr;
            data.effect = effect;
            return (data);
        }
        return (new SoundEffectData(distanceSqr, effect));
    }
    public static function destroy(data:SoundEffectData):void
    {
        data.effect = null;
        var _local_2:* = numObjects++;
        pool[_local_2] = data;
    }

}
