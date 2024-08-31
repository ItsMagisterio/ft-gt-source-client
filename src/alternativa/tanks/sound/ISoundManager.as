package alternativa.tanks.sound
{
    import flash.media.Sound;
    import flash.media.SoundTransform;
    import flash.media.SoundChannel;
    import alternativa.tanks.sfx.ISound3DEffect;
    import alternativa.tanks.camera.GameCamera;
    import alternativa.object.ClientObject;

    public interface ISoundManager
    {

        function playSound(_arg_1:Sound, _arg_2:int = 0, _arg_3:int = 0, _arg_4:SoundTransform = null):SoundChannel;
        function stopSound(_arg_1:SoundChannel):void;
        function stopAllSounds():void;
        function addEffect(_arg_1:ISound3DEffect):void;
        function removeEffect(_arg_1:ISound3DEffect):void;
        function removeAllEffects():void;
        function updateSoundEffects(_arg_1:int, _arg_2:GameCamera):void;
        function killEffectsByOwner(_arg_1:ClientObject):void;
        function set maxDistance(_arg_1:Number):void;

    }
}
