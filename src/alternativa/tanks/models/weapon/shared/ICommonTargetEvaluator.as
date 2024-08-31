package alternativa.tanks.models.weapon.shared
{
    import alternativa.physics.Body;

    public interface ICommonTargetEvaluator
    {

        function getTargetPriority(_arg_1:Body, _arg_2:Number, _arg_3:Number):Number;

    }
}
