package alternativa.tanks.services.materialregistry
{
    import alternativa.tanks.engine3d.ITextureMaterialRegistry;
    import alternativa.tanks.engine3d.IMaterialSequenceRegistry;
    import alternativa.tanks.vehicles.tanks.ISkinTextureRegistry;
    import alternativa.tanks.engine3d.IndexedTextureConstructor;

    public interface IMaterialRegistry
    {

        function get useMipMapping():Boolean;
        function set useMipMapping(_arg_1:Boolean):void;
        function get textureMaterialRegistry():ITextureMaterialRegistry;
        function get materialSequenceRegistry():IMaterialSequenceRegistry;
        function get skinTextureRegistry():ISkinTextureRegistry;
        function get mapMaterialRegistry():ITextureMaterialRegistry;
        function clear():void;
        function createTextureConstructor():IndexedTextureConstructor;

    }
}
