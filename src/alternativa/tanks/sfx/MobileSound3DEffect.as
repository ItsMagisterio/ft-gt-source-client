﻿package alternativa.tanks.sfx
{
    import alternativa.tanks.utils.objectpool.PooledObject;
    import alternativa.math.Vector3;
    import alternativa.object.ClientObject;
    import alternativa.engine3d.core.Object3D;
    import flash.media.SoundChannel;
    import alternativa.tanks.utils.objectpool.ObjectPool;
    import flash.events.Event;
    import alternativa.tanks.camera.GameCamera;

    public class MobileSound3DEffect extends PooledObject implements ISound3DEffect
    {

        private static var soundPosition:Vector3 = new Vector3();

        private var _owner:ClientObject;
        private var sound:Sound3D;
        private var playbackDelay:int;
        private var loops:int;
        private var object:Object3D;
        private var channel:SoundChannel;
        private var _enabled:Boolean;
        private var playing:Boolean;
        private var terminated:Boolean;
        private var time:int;
        private var actualVolume:Number;
        private var volumeFadeSpeed:Number;

        public function MobileSound3DEffect(objectPool:ObjectPool)
        {
            super(objectPool);
        }
        public function init(owner:ClientObject, sound:Sound3D, object:Object3D, playbackDelay:int, loops:int):void
        {
            this._owner = owner;
            this.sound = sound;
            this.object = object;
            this.playbackDelay = playbackDelay;
            this.loops = loops;
            this.terminated = false;
            this.playing = false;
            this._enabled = false;
            this.time = 0;
            this.actualVolume = sound.volume;
            this.volumeFadeSpeed = 0;
        }
        public function get owner():ClientObject
        {
            return (this._owner);
        }
        public function play(millis:int, camera:GameCamera):Boolean
        {
            if ((!(this.playing)))
            {
                if (this.time < this.playbackDelay)
                {
                    this.time = (this.time + millis);
                    return ((this._enabled) && (!(this.terminated)));
                }
                this.playing = true;
                this.channel = this.sound.play(0, this.loops);
                if (this.channel != null)
                {
                    this.channel.addEventListener(Event.SOUND_COMPLETE, this.onSoundComplete);
                }
                else
                {
                    this._enabled = false;
                    return (false);
                }
            }
            soundPosition.x = this.object.x;
            soundPosition.y = this.object.y;
            soundPosition.z = this.object.z;
            if (this.volumeFadeSpeed > 0)
            {
                this.actualVolume = (this.actualVolume - (this.volumeFadeSpeed * millis));
                if (this.actualVolume <= 0)
                {
                    this.volumeFadeSpeed = 0;
                    this.actualVolume = 0;
                }
                this.sound.volume = this.actualVolume;
            }
            this.sound.checkVolume(camera.pos, soundPosition, camera.xAxis);
            return ((this._enabled) && (!(this.terminated)));
        }
        public function destroy():void
        {
            Sound3D.destroy(this.sound);
            if (this.channel != null)
            {
                this.onSoundComplete(null);
            }
            this._owner = null;
            this.object = null;
            this.sound = null;
            storeInPool();
        }
        public function kill():void
        {
            this.terminated = true;
        }
        public function set enabled(value:Boolean):void
        {
            if (this._enabled == value)
            {
                return;
            }
            if ((!(this._enabled = value)))
            {
                this.onSoundComplete(null);
            }
        }
        public function readPosition(result:Vector3):void
        {
            result.x = this.object.x;
            result.y = this.object.y;
            result.z = this.object.z;
        }
        public function get numSounds():int
        {
            return (((this._enabled) && (!(this.terminated))) ? int(1) : int(0));
        }
        public function fade(time:int):void
        {
            this.volumeFadeSpeed = (this.actualVolume / time);
        }
        override protected function getClass():Class
        {
            return (MobileSound3DEffect);
        }
        private function onSoundComplete(e:Event):void
        {
            if (this.channel != null)
            {
                this.channel.removeEventListener(Event.SOUND_COMPLETE, this.onSoundComplete);
                this.channel = null;
            }
            this._enabled = false;
        }

    }
}
