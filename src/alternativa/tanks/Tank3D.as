package alternativa.tanks
{
    import alternativa.engine3d.containers.ConflictContainer;
    import alternativa.tanks.materials.PaintMaterial;
    import flash.display.BitmapData;
    import logic.resource.images.MultiframeResourceData;
    import alternativa.tanks.vehicles.tanks.TrackSkin;
    import alternativa.engine3d.core.Shadow;
    import logic.resource.images.ImageResource;
    import alternativa.engine3d.materials.Material;
    import flash.display.Shape;
    import flash.display.BlendMode;
    import alternativa.tanks.materials.AnimatedPaintMaterial;
    import alternativa.engine3d.materials.TextureMaterial;
    import alternativa.engine3d.core.MipMapping;
    import alternativa.engine3d.core.Face;
    import alternativa.engine3d.objects.Mesh;
    import alternativa.engine3d.core.Vertex;
    import alternativa.tanks.vehicles.tanks.TrackMeshSkin;
    import alternativa.tanks.vehicles.tanks.Wheel;
    import alternativa.engine3d.core.Object3DContainer;
    import alternativa.engine3d.core.Object3D;
    import logic.resource.ResourceUtil;
    import logic.resource.ResourceType;
    import alternativa.tanks.materials.TrackMaterial;
    import alternativa.init.Main;
    import alternativa.tanks.model.IGarage;
    import alternativa.tanks.model.GarageModel;

    public class Tank3D extends ConflictContainer
    {

        private static var defaultColormap:BitmapData;

        public static const EXCLUDED:RegExp = /(box.*|fmnt.*|muzzle.*|laser|rocket|mount|exh_.*|smk.*|smk_.*|fr.*|boundbox|shell|ult|spos_.*|snb.*)/i;

        public static const LEFT_WHEELS_REGEX:RegExp = /lwheel(\d+|_\d+|_b|_f)/i;

        public static const RIGHT_WHEELS_REGEX:RegExp = /rwheel(\d+|_\d+|_b|_f)/i;

        public static const LEFT_TRACK_REGEX:RegExp = /ltrack/i;

        public static const RIGHT_TRACK_REGEX:RegExp = /rtrack/i;

        private var leftPhysicalTrack:TrackMeshSkin;

        private var rightPhysicalTrack:TrackMeshSkin;

        private var rightWheels:Vector.<Wheel>;

        private var leftWheels:Vector.<Wheel>;

        private var hullObjects:Object3DContainer = new Object3DContainer();

        private var hull:Tank3DPart;
        private var turret:Tank3DPart;
        private var colormap:BitmapData;
        private var animatedColormap:Boolean;
        private var multiframeData:MultiframeResourceData;
        private var leftTrackSkin:TrackSkin;
        private var rightTrackSkin:TrackSkin;
        public var shadow:Shadow;

        public function Tank3D(hull:Tank3DPart, turret:Tank3DPart, colormap:ImageResource)
        {
            resolveByAABB = true;
            this.setHull(hull);
            this.setTurret(turret);
            this.setColorMap(colormap);
            this.shadow = new Shadow(128, 8, 100, 5000000, 10000000, 516, 0.95);
            this.shadow.offset = 100;
            this.shadow.backFadeRange = 100;
        }
        private function getDefaultColormap():BitmapData
        {
            if (defaultColormap == null)
            {
                defaultColormap = new BitmapData(1, 1, false, 0x666666);
            }
            return (defaultColormap);
        }
        public function setColorMap(colormap:ImageResource):void
        {
            this.colormap = ((!(colormap == null)) ? (colormap.bitmapData as BitmapData) : this.getDefaultColormap());
            if (this.hull != null)
            {
                this.hull.animatedPaint = ((!(colormap == null)) ? Boolean(colormap.animatedMaterial) : Boolean(false));
            }
            if (this.turret != null)
            {
                this.turret.animatedPaint = ((!(colormap == null)) ? Boolean(colormap.animatedMaterial) : Boolean(false));
            }
            this.animatedColormap = ((!(colormap == null)) ? Boolean(colormap.animatedMaterial) : Boolean(false));
            if (colormap != null)
            {
                if (colormap.multiframeData != null)
                {
                    this.multiframeData = new MultiframeResourceData();
                    this.multiframeData.fps = colormap.multiframeData.fps;
                    this.multiframeData.widthFrame = colormap.multiframeData.widthFrame;
                    this.multiframeData.heigthFrame = colormap.multiframeData.heigthFrame;
                    this.multiframeData.numFrames = colormap.multiframeData.numFrames;
                }
                else
                {
                    this.multiframeData = null;
                }
            }
            this.updatePartTexture(this.hull);
            this.updatePartTexture(this.turret);
        }
        public function setHull(value:Tank3DPart):void
        {
            if (this.hull != null)
            {
                removeChild(this.hull.mesh);
                var item:Wheel = null;
                for each (item in leftWheels)
                {
                    hullObjects.removeChild(item.mesh);
                }
                for each (item in rightWheels)
                {
                    hullObjects.removeChild(item.mesh);
                }
                if (this.leftPhysicalTrack != null && this.rightPhysicalTrack != null)
                {
                    hullObjects.removeChild(this.leftPhysicalTrack.mesh);
                    hullObjects.removeChild(this.rightPhysicalTrack.mesh);
                    this.leftPhysicalTrack = null;
                    this.rightPhysicalTrack = null;
                }
            }
            if (value == null)
            {
                return;
            }
            this.hull = value;
            addChild(this.hull.mesh);
            addChild(this.hullObjects);
            this.hull.mesh.x = 0;
            this.hull.mesh.y = 0;
            this.hull.mesh.z = 0;
            this.hullObjects.x = 0;
            this.hullObjects.y = 0;
            this.hullObjects.z = 0;
            this.hull.id = "hull";
            this.updatePartTexture(this.hull);
            this.updateMountPoint();
            this.shadow.addCaster(this.hull.mesh);
        }
        public function setTurret(value:Tank3DPart):void
        {
            if (this.turret != null)
            {
                removeChild(this.turret.mesh);
            }
            if (value == null)
            {
                return;
            }
            this.turret = value;
            addChild(this.turret.mesh);
            this.updatePartTexture(this.turret);
            this.updateMountPoint();
            this.shadow.addCaster(this.turret.mesh);
        }
        private function updatePartTexture(part:Tank3DPart):void
        {
            var material:Material;
            var tracksMaterial:Material;
            if (((part == null) || (this.colormap == null)))
            {
                return;
            }
            var shape:Shape = new Shape();
            shape.graphics.beginBitmapFill(this.colormap);
            shape.graphics.drawRect(0, 0, part.lightmap.width, part.lightmap.height);
            var texture:BitmapData = new BitmapData(part.lightmap.width, part.lightmap.height, false, 0);
            texture.draw(shape);
            texture.draw(part.lightmap, null, null, BlendMode.HARDLIGHT);
            texture.draw(part.details);
            if (multiframeData != null)
            {
                material = new AnimatedPaintMaterial(this.colormap, part.lightmap, part.details, (this.colormap.width / this.multiframeData.widthFrame), (this.colormap.height / this.multiframeData.heigthFrame), this.multiframeData.fps, this.multiframeData.numFrames, 1);
            }
            else
            {
                material = new PaintMaterial(this.colormap, part.lightmap, part.details);
            }
            tracksMaterial = new PaintMaterial(this.getDefaultColormap(), part.lightmap, part.details);
            part.mesh.setMaterialToAllFaces(material);
            if (part.id == "hull")
            {
                this.createWheels(hull, material);
            }
            this.createTrackSkins(part.mesh, tracksMaterial);
        }
        private function createWheels(hullDescriptor:Tank3DPart, material:Material):void
        {
            var _loc1_:Mesh = null;
            var _loc2_:Vector.<Mesh> = new Vector.<Mesh>;
            var index:int = 0;
            while (index < hullDescriptor.objects.length)
            {
                var object:Object3D = hullDescriptor.objects[index];

                if (object is Mesh && !EXCLUDED.test(object.name))
                {
                    _loc2_.push(Mesh(object));
                }

                index++;
            }
            this.leftWheels = new Vector.<Wheel>();
            this.rightWheels = new Vector.<Wheel>();

            var _loc1_:Mesh = null;
            for each (_loc1_ in _loc2_)
            {
                if (LEFT_WHEELS_REGEX.test(_loc1_.name))
                {
                    this.leftWheels.push(new Wheel(_loc1_));
                }
                else if (RIGHT_WHEELS_REGEX.test(_loc1_.name))
                {
                    this.rightWheels.push(new Wheel(_loc1_));
                }
            }
            var item:Wheel = null;
            for each (item in leftWheels)
            {
                item.mesh.setMaterialToAllFaces(material);
                hullObjects.addChild(item.mesh);
            }
            for each (item in rightWheels)
            {
                item.mesh.setMaterialToAllFaces(material);
                hullObjects.addChild(item.mesh);
            }
        }
        public function createTrackSkins(param1:Mesh, material:Material):void
        {
            var meshes:Vector.<Mesh> = new Vector.<Mesh>;
            var objIndex:int = 0;
            while (objIndex < hull.objects.length)
            {
                var object:Object3D = hull.objects[objIndex];

                if (object is Mesh && !EXCLUDED.test(object.name))
                {
                    meshes.push(Mesh(object));
                }

                objIndex++;
            }

            var tracksId:String = GarageModel(Main.osgi.getService(IGarage)).mountedArmorParams.equippedSkin + "_tracks";

            if (tracksId != null)
            {
                if (ResourceUtil.getResource(ResourceType.IMAGE, tracksId) != null)
                {
                    var _tracks:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE, tracksId).bitmapData.clone();

                    var mesh:Mesh = null;
                    for each (mesh in meshes)
                    {
                        if (LEFT_TRACK_REGEX.test(mesh.name))
                        {
                            this.leftPhysicalTrack = new TrackMeshSkin(mesh, false);
                            this.leftPhysicalTrack.setMaterial(new TrackMaterial(_tracks));
                            hullObjects.addChild(leftPhysicalTrack.mesh);
                        }
                        else if (RIGHT_TRACK_REGEX.test(mesh.name))
                        {
                            this.rightPhysicalTrack = new TrackMeshSkin(mesh, false);
                            this.rightPhysicalTrack.setMaterial(new TrackMaterial(_tracks));
                            hullObjects.addChild(rightPhysicalTrack.mesh);
                        }
                    }
                }
            }

            var _loc2_:Face;
            this.leftTrackSkin = new TrackSkin();
            this.rightTrackSkin = new TrackSkin();
            for each (_loc2_ in param1.faces)
            {
                if (_loc2_.id == "track")
                {
                    this.addFaceToTrackSkin(_loc2_);
                }
                if (_loc2_.material.name != null)
                {
                    if (_loc2_.material.name.toLowerCase().indexOf("track") != -1)
                    {
                        this.addFaceToTrackSkin(_loc2_);
                    }
                }
            }
            this.leftTrackSkin.init();
            this.rightTrackSkin.init();
            this.leftTrackSkin.setMaterial(material.clone());
            this.rightTrackSkin.setMaterial(material.clone());
        }
        private function addFaceToTrackSkin(param1:Face):void
        {
            var _loc2_:Vertex = param1.vertices[0];
            if (_loc2_.x < 0)
            {
                this.leftTrackSkin.addFace(param1);
            }
            else
            {
                this.rightTrackSkin.addFace(param1);
            }
        }
        private function updateMountPoint():void
        {
            if (((this.hull == null) || (this.turret == null)))
            {
                return;
            }
            this.turret.mesh.x = this.hull.turretMountPoint.x;
            this.turret.mesh.y = this.hull.turretMountPoint.y;
            this.turret.mesh.z = this.hull.turretMountPoint.z;
        }

    }
}
