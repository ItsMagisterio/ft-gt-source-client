// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// alternativa.tanks.models.weapon.shaft.Aim

package alternativa.tanks.models.weapon.shaft
{
    import alternativa.tanks.vehicles.tanks.Tank;
    import alternativa.math.Vector3;

    public class Aim
    {

        public var target:Tank;
        public var targetHitPoint:Vector3;

        public function Aim(b:Tank, v:Vector3)
        {
            this.target = b;
            this.targetHitPoint = v;
        }

    }
} // package alternativa.tanks.models.weapon.shaft