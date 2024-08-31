package alternativa.tanks.models.weapon.flamethrower
{
    import alternativa.tanks.models.weapon.shared.ITargetValidator;
    import alternativa.tanks.vehicles.tanks.Tank;
    import alternativa.physics.Body;

    public class FlamethrowerTargetValidator implements ITargetValidator
    {

        public function isValidTarget(targetBody:Body):Boolean
        {
            var tank:Tank = (targetBody as Tank);
            return ((!(tank == null)) && (tank.tankData.health > 0));
        }

    }
}
