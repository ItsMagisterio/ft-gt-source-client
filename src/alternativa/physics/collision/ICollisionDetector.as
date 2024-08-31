package alternativa.physics.collision
{
    import alternativa.physics.Contact;
    import alternativa.math.Vector3;
    import alternativa.physics.collision.types.RayIntersection;

    public interface ICollisionDetector
    {

        function getAllContacts(_arg_1:Contact):Contact;
        function intersectRay(_arg_1:Vector3, _arg_2:Vector3, _arg_3:int, _arg_4:Number, _arg_5:IRayCollisionPredicate, _arg_6:RayIntersection):Boolean;
        function intersectRayWithStatic(_arg_1:Vector3, _arg_2:Vector3, _arg_3:int, _arg_4:Number, _arg_5:IRayCollisionPredicate, _arg_6:RayIntersection):Boolean;
        function getContact(_arg_1:CollisionPrimitive, _arg_2:CollisionPrimitive, _arg_3:Contact):Boolean;
        function testCollision(_arg_1:CollisionPrimitive, _arg_2:CollisionPrimitive):Boolean;
        function destroy():void;

    }
}
