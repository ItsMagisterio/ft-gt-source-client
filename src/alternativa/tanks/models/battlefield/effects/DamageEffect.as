package alternativa.tanks.models.battlefield.effects
{
    import alternativa.math.Vector3;
    import alternativa.physics.RayHit;
    import alternativa.tanks.models.battlefield.BattlefieldModel;
    import alternativa.init.Main;
    import alternativa.tanks.models.battlefield.IBattleField;
    import alternativa.engine3d.core.Object3D;
    import alternativa.tanks.vehicles.tanks.Tank;
    import controls.Label;
    import flash.filters.GlowFilter;
    import flash.display.BitmapData;
    import alternativa.engine3d.materials.TextureMaterial;
    import alternativa.engine3d.core.MipMapping;
    import flash.display.BlendMode;

    public class DamageEffect
    {

        private static const origin:Vector3 = new Vector3();
        private static const upDirection:Vector3 = new Vector3(0, 0, 1);
        private static const rayHit:RayHit = new RayHit();

        private var battlefield:BattlefieldModel;

        public function DamageEffect()
        {
            this.battlefield = (Main.osgi.getService(IBattleField) as BattlefieldModel);
        }
        public function createEffect(tank:Tank, damage:int, type:int):void
        {
            var tankObject:Object3D = tank.skin.turretMesh;
            var height:Number = 400;
            this.createLabel(tank.id, height, damage, tankObject, type);
        }
        private function createLabel(tankId:int, height:Number, damage:int, tank:Object3D, type:int):void
        {
            var damageLabel:Label;
            damageLabel = new Label();
            if (type == 1)
            {
                damageLabel.textColor = 0xFF0000;
            }
            else
            {
                damageLabel.textColor = 0xFFFFFF;
            }
            damageLabel.text = damage.toString();
            damageLabel.filters = [new GlowFilter(0, 0.8, 4, 4, 3)];
            damageLabel.size = 16;
            var damageBitmap:BitmapData = new BitmapData((damageLabel.textWidth + 10), (damageLabel.textHeight + 5), true, 0xFFFFFF);
            damageBitmap.draw(damageLabel);
            var damageTexture:TextureMaterial = new TextureMaterial(damageBitmap, false, true, MipMapping.PER_PIXEL, 1);
            var damageEffect:DamageUpEffect = DamageUpEffect(this.battlefield.getObjectPool().getObject(DamageUpEffect));
            damageEffect.init(500, damageBitmap.width, damageBitmap.height, 0, (height * 0.8), (height * 0.07), 0.75, 0, 0, 125, tank, damageTexture, BlendMode.NORMAL, type);
            this.battlefield.addGraphicEffect(damageEffect);
        }

    }
}
