package alternativa.physics.collision
{
    import alternativa.physics.Contact;

    public interface ICollider
    {

        function getContact(_arg_1:CollisionPrimitive, _arg_2:CollisionPrimitive, _arg_3:Contact):Boolean;
        function haveCollision(_arg_1:CollisionPrimitive, _arg_2:CollisionPrimitive):Boolean;
        function destroy():void;

    }
}
