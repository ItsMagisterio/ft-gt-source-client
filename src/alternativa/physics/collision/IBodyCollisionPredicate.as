package alternativa.physics.collision
{
    import alternativa.physics.Body;

    public interface IBodyCollisionPredicate
    {

        function considerBodies(_arg_1:Body, _arg_2:Body):Boolean;

    }
}
