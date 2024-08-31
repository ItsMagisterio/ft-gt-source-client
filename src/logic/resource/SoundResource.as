// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// scpacker.resource.SoundResource

package logic.resource
{
    import flash.media.Sound;

    public class SoundResource
    {

        public var sound:Sound;
        public var nameID:String;

        public function SoundResource(sound:Sound, id:String)
        {
            this.nameID = id;
            this.sound = sound;
        }
    }
} // package scpacker.resource