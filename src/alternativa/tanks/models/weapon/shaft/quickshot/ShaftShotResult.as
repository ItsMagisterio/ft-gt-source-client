// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// alternativa.tanks.models.weapon.shaft.quickshot.ShaftShotResult

package alternativa.tanks.models.weapon.shaft.quickshot
{
    import alternativa.math.Vector3;
    import alternativa.tanks.models.tank.TankData;

    public class ShaftShotResult
    {

        public var targets:Array = [];
        public var hitPoints:Array = [];
        public var dir:Vector3 = new Vector3();

        public function toJSON():String
        {
            var obj:Object = new Object();
            obj.targets = this.targets;
            obj.hitPoints = this.hitPoints;
            obj.dir = this.dir;
            return (JSON.stringify(obj, function(key:*, v:*):*
                    {
                        var vector:*;
                        var tank:*;
                        if ((v is Vector3))
                        {
                            vector = (v as Vector3);
                            return ( {
                                        "x": vector.x,
                                        "y": vector.y,
                                        "z": vector.z
                                    });
                        }
                        if ((v is TankData))
                        {
                            tank = (v as TankData);
                            return ( {"target_id": tank.userName});
                        }
                        return (v);
                    }));
        }

    }
} // package alternativa.tanks.models.weapon.shaft.quickshot