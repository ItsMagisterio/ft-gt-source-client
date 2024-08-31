package alternativa.physics
{
    import alternativa.math.Vector3;
    import alternativa.physics.collision.ICollisionDetector;
    import __AS3__.vec.Vector;
    import alternativa.physics.constraints.Constraint;
    import alternativa.physics.collision.KdTreeCollisionDetector;
    import alternativa.math.Matrix3;
    import __AS3__.vec.*;
    import alternativa.physics.altphysics;
    use namespace altphysics;

    public class PhysicsScene
    {

        private static var lastBodyId:int;

        public const MAX_CONTACTS:int = 1000;

        public var penResolutionSteps:int = 10;
        public var allowedPenetration:Number = 0.01;
        public var maxPenResolutionSpeed:Number = 0.5;
        public var collisionIterations:int = 4;
        public var contactIterations:int = 4;
        public var usePrediction:Boolean = false;
        public var freezeSteps:int = 10;
        public var linSpeedFreezeLimit:Number = 1;
        public var angSpeedFreezeLimit:Number = 0.01;
        public var staticSeparationIterations:int = 10;
        public var staticSeparationSteps:int = 10;
        public var maxAngleMove:Number = 10;
        public var useStaticSeparation:Boolean = false;
        public var _gravity:Vector3 = new Vector3(0, 0, -9.8);
        public var _gravityMagnitude:Number = 9.8;
        public var collisionDetector:ICollisionDetector;
        public var bodies:BodyList = new BodyList();
        altphysics var contacts:Contact;
        altphysics var constraints:Vector.<Constraint> = new Vector.<Constraint>();
        altphysics var constraintsNum:int;
        public var timeStamp:int;
        public var time:int;
        private var borderContact:Contact;
        private var _r:Vector3 = new Vector3();
        private var _t:Vector3 = new Vector3();
        private var _v:Vector3 = new Vector3();
        private var _v1:Vector3 = new Vector3();
        private var _v2:Vector3 = new Vector3();
        public var _staticCD:KdTreeCollisionDetector;

        public function PhysicsScene()
        {
            this.contacts = new Contact(0);
            var contact:Contact = this.contacts;
            var i:int = 1;
            while (i < this.MAX_CONTACTS)
            {
                contact.next = new Contact(i);
                contact = contact.next;
                i++;
            }
            this.collisionDetector = new KdTreeCollisionDetector();
            this._staticCD = (this.collisionDetector as KdTreeCollisionDetector);
        }
        public function get gravity():Vector3
        {
            return (this._gravity.vClone());
        }
        public function set gravity(value:Vector3):void
        {
            this._gravity.vCopy(value);
            this._gravityMagnitude = this._gravity.vLength();
        }
        public function addBody(body:Body):void
        {
            body.id = lastBodyId++;
            body.world = this;
            this.bodies.append(body);
        }
        public function removeBody(body:Body):void
        {
            if (this.bodies.remove(body))
            {
                body.world = null;
            }
        }
        public function addConstraint(c:Constraint):void
        {
            var _loc2_:* = this.constraintsNum++;
            this.constraints[_loc2_] = c;
            c.world = this;
        }
        public function removeConstraint(c:Constraint):Boolean
        {
            var idx:int = this.constraints.indexOf(c);
            if (idx < 0)
            {
                return (false);
            }
            this.constraints.splice(idx, 1);
            this.constraintsNum--;
            c.world = null;
            return (true);
        }
        private function applyForces(dt:Number):void
        {
            var body:Body;
            body = null;
            var item:BodyListItem = this.bodies.head;
            while (item != null)
            {
                body = item.body;
                body.beforePhysicsStep(dt);
                body.calcAccelerations();
                if (((body.movable) && (!(body.frozen))))
                {
                    body.accel.x = (body.accel.x + this._gravity.x);
                    body.accel.y = (body.accel.y + this._gravity.y);
                    body.accel.z = (body.accel.z + this._gravity.z);
                }
                item = item.next;
            }
        }
        private function detectCollisions(dt:Number):void
        {
            var b2:Body;
            var cp:ContactPoint;
            var bPos:Vector3;
            var body:Body;
            var b1:Body;
            b2 = null;
            var j:int;
            cp = null;
            bPos = null;
            var item:BodyListItem = this.bodies.head;
            while (item != null)
            {
                body = item.body;
                if ((!(body.frozen)))
                {
                    body.contactsNum = 0;
                    body.saveState();
                    if (this.usePrediction)
                    {
                        body.integrateVelocity(dt);
                        body.integratePosition(dt);
                    }
                    body.calcDerivedData();
                }
                item = item.next;
            }
            this.borderContact = this.collisionDetector.getAllContacts(this.contacts);
            var contact:Contact = this.contacts;
            while (contact != this.borderContact)
            {
                b1 = contact.body1;
                b2 = contact.body2;
                j = 0;
                while (j < contact.pcount)
                {
                    cp = contact.points[j];
                    bPos = b1.state.pos;
                    cp.r1.x = (cp.pos.x - bPos.x);
                    cp.r1.y = (cp.pos.y - bPos.y);
                    cp.r1.z = (cp.pos.z - bPos.z);
                    if (b2 != null)
                    {
                        bPos = b2.state.pos;
                        cp.r2.x = (cp.pos.x - bPos.x);
                        cp.r2.y = (cp.pos.y - bPos.y);
                        cp.r2.z = (cp.pos.z - bPos.z);
                    }
                    j++;
                }
                contact = contact.next;
            }
            if (this.usePrediction)
            {
                item = this.bodies.head;
                while (item != null)
                {
                    body = item.body;
                    if ((!(body.frozen)))
                    {
                        body.restoreState();
                        body.calcDerivedData();
                    }
                    item = item.next;
                }
            }
        }
        private function preProcessContacts(dt:Number):void
        {
            var b1:Body;
            var b2:Body;
            var j:int;
            var cp:ContactPoint;
            var constraint:Constraint;
            var contact:Contact = this.contacts;
            while (contact != this.borderContact)
            {
                b1 = contact.body1;
                b2 = contact.body2;
                if (b1.frozen)
                {
                    b1.frozen = false;
                    b1.freezeCounter = 0;
                }
                if (((!(b2 == null)) && (b2.frozen)))
                {
                    b2.frozen = false;
                    b2.freezeCounter = 0;
                }
                contact.restitution = b1.material.restitution;
                if (((!(b2 == null)) && (b2.material.restitution < contact.restitution)))
                {
                    contact.restitution = b2.material.restitution;
                }
                contact.friction = b1.material.friction;
                if (((!(b2 == null)) && (b2.material.friction < contact.friction)))
                {
                    contact.friction = b2.material.friction;
                }
                j = 0;
                while (j < contact.pcount)
                {
                    cp = contact.points[j];
                    cp.accumImpulseN = 0;
                    cp.velByUnitImpulseN = 0;
                    if (b1.movable)
                    {
                        cp.angularInertia1 = this._v.vCross2(cp.r1, contact.normal).vTransformBy3(b1.invInertiaWorld).vCross(cp.r1).vDot(contact.normal);
                        cp.velByUnitImpulseN = (cp.velByUnitImpulseN + (b1.invMass + cp.angularInertia1));
                    }
                    if (((!(b2 == null)) && (b2.movable)))
                    {
                        cp.angularInertia2 = this._v.vCross2(cp.r2, contact.normal).vTransformBy3(b2.invInertiaWorld).vCross(cp.r2).vDot(contact.normal);
                        cp.velByUnitImpulseN = (cp.velByUnitImpulseN + (b2.invMass + cp.angularInertia2));
                    }
                    this.calcSepVelocity(b1, b2, cp, this._v);
                    cp.normalVel = this._v.vDot(contact.normal);
                    if (cp.normalVel < 0)
                    {
                        cp.normalVel = (-(contact.restitution) * cp.normalVel);
                    }
                    cp.minSepVel = ((cp.penetration > this.allowedPenetration) ? Number(((cp.penetration - this.allowedPenetration) / (this.penResolutionSteps * dt))) : Number(0));
                    if (cp.minSepVel > this.maxPenResolutionSpeed)
                    {
                        cp.minSepVel = this.maxPenResolutionSpeed;
                    }
                    j++;
                }
                contact = contact.next;
            }
            var i:int;
            while (i < this.constraintsNum)
            {
                constraint = this.constraints[i];
                constraint.preProcess(dt);
                i++;
            }
        }
        private function processContacts(dt:Number, forceInelastic:Boolean):void
        {
            var i:int;
            var contact:Contact;
            var constraint:Constraint;
            var iterNum:int = ((!(!(forceInelastic))) ? int(this.contactIterations) : int(this.collisionIterations));
            var forwardLoop:Boolean;
            var iter:int;
            while (iter < iterNum)
            {
                forwardLoop = (!(forwardLoop));
                contact = this.contacts;
                while (contact != this.borderContact)
                {
                    this.resolveContact(contact, forceInelastic, forwardLoop);
                    contact = contact.next;
                }
                i = 0;
                while (i < this.constraintsNum)
                {
                    constraint = this.constraints[i];
                    constraint.apply(dt);
                    i++;
                }
                iter++;
            }
        }
        private function resolveContact(contactInfo:Contact, forceInelastic:Boolean, forwardLoop:Boolean):void
        {
            var i:int;
            var b1:Body = contactInfo.body1;
            var b2:Body = contactInfo.body2;
            var normal:Vector3 = contactInfo.normal;
            if (forwardLoop)
            {
                i = 0;
                while (i < contactInfo.pcount)
                {
                    this.resolveContactPoint(i, b1, b2, contactInfo, normal, forceInelastic);
                    i++;
                }
            }
            else
            {
                i = (contactInfo.pcount - 1);
                while (i >= 0)
                {
                    this.resolveContactPoint(i, b1, b2, contactInfo, normal, forceInelastic);
                    i--;
                }
            }
        }
        private function resolveContactPoint(idx:int, b1:Body, b2:Body, contact:Contact, normal:Vector3, forceInelastic:Boolean):void
        {
            var cnormal:Vector3;
            var r:Vector3;
            var m:Matrix3;
            var xx:Number = NaN;
            var yy:Number = NaN;
            var zz:Number = NaN;
            var minSpeVel:Number = NaN;
            var cp:ContactPoint = contact.points[idx];
            if ((!(forceInelastic)))
            {
                cp.satisfied = true;
            }
            var newVel:Number = 0;
            this.calcSepVelocity(b1, b2, cp, this._v);
            cnormal = contact.normal;
            var sepVel:Number = (((this._v.x * cnormal.x) + (this._v.y * cnormal.y)) + (this._v.z * cnormal.z));
            if (forceInelastic)
            {
                minSpeVel = ((!(!(this.useStaticSeparation))) ? Number(0) : Number(cp.minSepVel));
                if (sepVel < minSpeVel)
                {
                    cp.satisfied = false;
                }
                else
                {
                    if (cp.satisfied)
                    {
                        return;
                    }
                }
                newVel = minSpeVel;
            }
            else
            {
                newVel = cp.normalVel;
            }
            var deltaVel:Number = (newVel - sepVel);
            var impulse:Number = (deltaVel / cp.velByUnitImpulseN);
            var accumImpulse:Number = (cp.accumImpulseN + impulse);
            if (accumImpulse < 0)
            {
                accumImpulse = 0;
            }
            var deltaImpulse:Number = (accumImpulse - cp.accumImpulseN);
            cp.accumImpulseN = accumImpulse;
            if (b1.movable)
            {
                b1.applyRelPosWorldImpulse(cp.r1, normal, deltaImpulse);
            }
            if (((!(b2 == null)) && (b2.movable)))
            {
                b2.applyRelPosWorldImpulse(cp.r2, normal, -(deltaImpulse));
            }
            this.calcSepVelocity(b1, b2, cp, this._v);
            var tanSpeedByUnitImpulse:Number = 0;
            var dot:Number = (((this._v.x * cnormal.x) + (this._v.y * cnormal.y)) + (this._v.z * cnormal.z));
            this._v.x = (this._v.x - (dot * cnormal.x));
            this._v.y = (this._v.y - (dot * cnormal.y));
            this._v.z = (this._v.z - (dot * cnormal.z));
            var tanSpeed:Number = this._v.vLength();
            if (tanSpeed < 0.001)
            {
                return;
            }
            this._t.x = -(this._v.x);
            this._t.y = -(this._v.y);
            this._t.z = -(this._v.z);
            this._t.vNormalize();
            if (b1.movable)
            {
                r = cp.r1;
                m = b1.invInertiaWorld;
                this._v.x = ((r.y * this._t.z) - (r.z * this._t.y));
                this._v.y = ((r.z * this._t.x) - (r.x * this._t.z));
                this._v.z = ((r.x * this._t.y) - (r.y * this._t.x));
                xx = (((m.a * this._v.x) + (m.b * this._v.y)) + (m.c * this._v.z));
                yy = (((m.e * this._v.x) + (m.f * this._v.y)) + (m.g * this._v.z));
                zz = (((m.i * this._v.x) + (m.j * this._v.y)) + (m.k * this._v.z));
                this._v.x = ((yy * r.z) - (zz * r.y));
                this._v.y = ((zz * r.x) - (xx * r.z));
                this._v.z = ((xx * r.y) - (yy * r.x));
                tanSpeedByUnitImpulse = (tanSpeedByUnitImpulse + (((b1.invMass + (this._v.x * this._t.x)) + (this._v.y * this._t.y)) + (this._v.z * this._t.z)));
            }
            if (((!(b2 == null)) && (b2.movable)))
            {
                r = cp.r2;
                m = b2.invInertiaWorld;
                this._v.x = ((r.y * this._t.z) - (r.z * this._t.y));
                this._v.y = ((r.z * this._t.x) - (r.x * this._t.z));
                this._v.z = ((r.x * this._t.y) - (r.y * this._t.x));
                xx = (((m.a * this._v.x) + (m.b * this._v.y)) + (m.c * this._v.z));
                yy = (((m.e * this._v.x) + (m.f * this._v.y)) + (m.g * this._v.z));
                zz = (((m.i * this._v.x) + (m.j * this._v.y)) + (m.k * this._v.z));
                this._v.x = ((yy * r.z) - (zz * r.y));
                this._v.y = ((zz * r.x) - (xx * r.z));
                this._v.z = ((xx * r.y) - (yy * r.x));
                tanSpeedByUnitImpulse = (tanSpeedByUnitImpulse + (((b2.invMass + (this._v.x * this._t.x)) + (this._v.y * this._t.y)) + (this._v.z * this._t.z)));
            }
            var tanImpulse:Number = (tanSpeed / tanSpeedByUnitImpulse);
            var max:Number = (contact.friction * cp.accumImpulseN);
            if (max < 0)
            {
                if (tanImpulse < max)
                {
                    tanImpulse = max;
                }
            }
            else
            {
                if (tanImpulse > max)
                {
                    tanImpulse = max;
                }
            }
            if (b1.movable)
            {
                b1.applyRelPosWorldImpulse(cp.r1, this._t, tanImpulse);
            }
            if (((!(b2 == null)) && (b2.movable)))
            {
                b2.applyRelPosWorldImpulse(cp.r2, this._t, -(tanImpulse));
            }
        }
        private function calcSepVelocity(body1:Body, body2:Body, cp:ContactPoint, result:Vector3):void
        {
            var rot:Vector3 = body1.state.rotation;
            var v:Vector3 = cp.r1;
            var x:Number = ((rot.y * v.z) - (rot.z * v.y));
            var y:Number = ((rot.z * v.x) - (rot.x * v.z));
            var z:Number = ((rot.x * v.y) - (rot.y * v.x));
            v = body1.state.velocity;
            result.x = (v.x + x);
            result.y = (v.y + y);
            result.z = (v.z + z);
            if (body2 != null)
            {
                rot = body2.state.rotation;
                v = cp.r2;
                x = ((rot.y * v.z) - (rot.z * v.y));
                y = ((rot.z * v.x) - (rot.x * v.z));
                z = ((rot.x * v.y) - (rot.y * v.x));
                v = body2.state.velocity;
                result.x = (result.x - (v.x + x));
                result.y = (result.y - (v.y + y));
                result.z = (result.z - (v.z + z));
            }
        }
        private function intergateVelocities(dt:Number):void
        {
            var item:BodyListItem = this.bodies.head;
            while (item != null)
            {
                item.body.integrateVelocity(dt);
                item = item.next;
            }
        }
        private function integratePositions(dt:Number):void
        {
            var body:Body;
            var item:BodyListItem = this.bodies.head;
            while (item != null)
            {
                body = item.body;
                if (((body.movable) && (!(body.frozen))))
                {
                    body.integratePosition(dt);
                }
                item = item.next;
            }
        }
        private function performStaticSeparation():void
        {
            var iterNum:int = this.staticSeparationIterations;
        }
        private function resolveInterpenetration(contact:Contact):void
        {
            var worstCp:ContactPoint;
            var cp:ContactPoint;
            var i:int;
            var maxPen:Number = NaN;
            var j:int;
            contact.satisfied = true;
            var step:int;
            while (step < this.staticSeparationSteps)
            {
                worstCp = contact.points[0];
                i = 1;
                while (i < contact.pcount)
                {
                    cp = contact.points[i];
                    cp.satisfied = false;
                    if (cp.penetration > worstCp.penetration)
                    {
                        worstCp = cp;
                    }
                    i++;
                }
                if (worstCp.penetration <= this.allowedPenetration)
                {
                    break;
                }
                this.separateContactPoint(worstCp, contact);
                maxPen = 0;
                i = 1;
                while (i < contact.pcount)
                {
                    j = 0;
                    while (j < contact.pcount)
                    {
                        cp = contact.points[j];
                        if ((!(cp.satisfied)))
                        {
                            if (cp.penetration > maxPen)
                            {
                                maxPen = cp.penetration;
                                worstCp = cp;
                            }
                        }
                        j++;
                    }
                    if (maxPen <= this.allowedPenetration)
                    {
                        break;
                    }
                    this.separateContactPoint(worstCp, contact);
                    i++;
                }
                step++;
            }
        }
        private function separateContactPoint(cp:ContactPoint, contact:Contact):void
        {
        }
        private function postPhysics():void
        {
            var body:Body;
            var item:BodyListItem = this.bodies.head;
            while (item != null)
            {
                body = item.body;
                body.clearAccumulators();
                body.calcDerivedData();
                if (body.canFreeze)
                {
                    if (((body.state.velocity.vLength() < this.linSpeedFreezeLimit) && (body.state.rotation.vLength() < this.angSpeedFreezeLimit)))
                    {
                        if ((!(body.frozen)))
                        {
                            body.freezeCounter++;
                            if (body.freezeCounter >= this.freezeSteps)
                            {
                                body.frozen = true;
                            }
                        }
                    }
                    else
                    {
                        body.freezeCounter = 0;
                        body.frozen = false;
                    }
                }
                item = item.next;
            }
        }
        public function update(delta:int):void
        {
            this.timeStamp++;
            this.time = (this.time + delta);
            var dt:Number = (0.001 * delta);
            this.applyForces(dt);
            this.detectCollisions(dt);
            this.preProcessContacts(dt);
            this.processContacts(dt, false);
            this.intergateVelocities(dt);
            this.processContacts(dt, true);
            this.integratePositions(dt);
            this.postPhysics();
        }
        public function destroy():*
        {
            var buf:Contact;
            if (this.contacts != null)
            {
                while (this.contacts.next != null)
                {
                    buf = this.contacts;
                    this.contacts.destroy();
                    this.contacts = null;
                    this.contacts = buf.next;
                }
                this.contacts = null;
            }
        }

    }
}
