package alternativa.tanks.models.sfx.shoot.railgun
{
    import alternativa.object.ClientObject;
    import alternativa.math.Vector3;
    import alternativa.tanks.sfx.IGraphicEffect;
    import alternativa.engine3d.core.Object3D;
    import alternativa.tanks.sfx.ISound3DEffect;

    public interface IRailgunSFXModel
    {

        function getSFXData(_arg_1:ClientObject):RailgunShootSFXData;
        function createGraphicShotEffect(_arg_1:ClientObject, _arg_2:Vector3, _arg_3:Vector3):IGraphicEffect;
        function createChargeEffect(_arg_1:ClientObject, _arg_2:ClientObject, _arg_3:Vector3, _arg_4:Object3D, _arg_5:int):IGraphicEffect;
        function createSoundShotEffect(_arg_1:ClientObject, _arg_2:ClientObject, _arg_3:Vector3):ISound3DEffect;

    }
}
