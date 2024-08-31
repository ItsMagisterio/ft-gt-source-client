package alternativa.tanks.services.materialregistry.impl
{
    import alternativa.tanks.services.materialregistry.IMaterialRegistry;
    import alternativa.osgi.service.dump.dumper.IDumper;
    import alternativa.console.ConsoleVarInt;
    import alternativa.console.ConsoleVarFloat;
    import alternativa.tanks.engine3d.TextureMaterialRegistry;
    import alternativa.tanks.engine3d.MaterialSequenceRegistry;
    import alternativa.tanks.vehicles.tanks.SkinTextureRegistry;
    import alternativa.osgi.service.dump.IDumpService;
    import alternativa.init.OSGi;
    import alternativa.tanks.engine3d.ITextureMaterialRegistry;
    import alternativa.tanks.engine3d.IMaterialSequenceRegistry;
    import alternativa.tanks.vehicles.tanks.ISkinTextureRegistry;
    import __AS3__.vec.Vector;
    import alternativa.tanks.engine3d.IndexedTextureConstructor;

    public class MaterialRegistry implements IMaterialRegistry, IDumper
    {

        private static const TIMER_INTERVAL:int = 60;

        private var textureMaterialRegistryInterval:ConsoleVarInt = new ConsoleVarInt("tmr_timer_interval", TIMER_INTERVAL, 30, 1000, onTimerIntervalChange);
        private var mapMaterialRegistryInterval:ConsoleVarInt = new ConsoleVarInt("mmr_timer_interval", TIMER_INTERVAL, 30, 1000, onTimerIntervalChange);
        private var materialSequenceRegistryInterval:ConsoleVarInt = new ConsoleVarInt("msr_timer_interval", TIMER_INTERVAL, 30, 1000, onTimerIntervalChange);
        private var textureResolution:ConsoleVarFloat = new ConsoleVarFloat("tex_res", 5.8, 0, 100, onTextureResolutionChange);
        private var _textureMaterialRegistry:TextureMaterialRegistry = new TextureMaterialRegistry(TIMER_INTERVAL);
        private var _materialSequenceRegistry:MaterialSequenceRegistry = new MaterialSequenceRegistry(TIMER_INTERVAL);
        private var _mapMaterialRegistry:TextureMaterialRegistry = new TextureMaterialRegistry(TIMER_INTERVAL);
        private var _skinTextureRegistry:SkinTextureRegistry = new SkinTextureRegistry();

        public function MaterialRegistry(osgi:OSGi)
        {
            var dumpService:IDumpService = IDumpService(osgi.getService(IDumpService));
            if (dumpService != null)
            {
                dumpService.registerDumper(this);
            }
        }
        public function get useMipMapping():Boolean
        {
            return (this._textureMaterialRegistry.useMipMapping);
        }
        public function set useMipMapping(value:Boolean):void
        {
            this._textureMaterialRegistry.useMipMapping = value;
            this._materialSequenceRegistry.useMipMapping = value;
            this._mapMaterialRegistry.useMipMapping = value;
        }
        public function get textureMaterialRegistry():ITextureMaterialRegistry
        {
            return (this._textureMaterialRegistry);
        }
        public function get materialSequenceRegistry():IMaterialSequenceRegistry
        {
            return (this._materialSequenceRegistry);
        }
        public function get mapMaterialRegistry():ITextureMaterialRegistry
        {
            return (this._mapMaterialRegistry);
        }
        public function get skinTextureRegistry():ISkinTextureRegistry
        {
            return (this._skinTextureRegistry);
        }
        public function clear():void
        {
            this._textureMaterialRegistry.clear();
            this._materialSequenceRegistry.clear();
            this._mapMaterialRegistry.clear();
            this._skinTextureRegistry.clear();
        }
        public function dump(params:Vector.<String>):String
        {
            return ((this._textureMaterialRegistry.getDump() + this._materialSequenceRegistry.getDump()) + this._mapMaterialRegistry.getDump());
        }
        public function get dumperName():String
        {
            return ("materials");
        }
        public function createTextureConstructor():IndexedTextureConstructor
        {
            return (new IndexedTextureConstructor());
        }
        private function onTimerIntervalChange(variable:ConsoleVarInt):void
        {
            switch (variable)
            {
                case this.textureMaterialRegistryInterval:
                    this._textureMaterialRegistry.timerInterval = variable.value;
                    break;
                case this.mapMaterialRegistryInterval:
                    this._mapMaterialRegistry.timerInterval = variable.value;
                    break;
                case this.materialSequenceRegistryInterval:
                    this._materialSequenceRegistry.timerInterval = variable.value;
            }
        }
        private function onTextureResolutionChange(variable:ConsoleVarFloat):void
        {
            this._mapMaterialRegistry.resoluion = variable.value;
        }

    }
}
