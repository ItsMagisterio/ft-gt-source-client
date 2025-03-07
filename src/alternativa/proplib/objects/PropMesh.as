﻿package alternativa.proplib.objects
{
    import alternativa.proplib.utils.TextureByteDataMap;
    import __AS3__.vec.Vector;
    import alternativa.engine3d.objects.Occluder;
    import flash.utils.ByteArray;
    import alternativa.utils.ByteArrayMap;
    import alternativa.utils.textureutils.TextureByteData;
    import alternativa.engine3d.objects.Mesh;
    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.loaders.Parser3DS;
    import alternativa.engine3d.materials.TextureMaterial;
    import alternativa.engine3d.alternativa3d;
    import alternativa.engine3d.core.Face;
    import __AS3__.vec.*;

    public class PropMesh extends PropObject
    {

        public static const DEFAULT_TEXTURE:String = "$$$_DEFAULT_TEXTURE_$$$";
        public static var threshold:Number = 0.01;
        public static var occluderDistanceThreshold:Number = 0.01;
        public static var occluderAngleThreshold:Number = 0.01;
        public static var occluderConvexThreshold:Number = 0.01;
        public static var occluderUvThreshold:int = 1;
        public static var meshDistanceThreshold:Number = 0.001;
        public static var meshUvThreshold:Number = 0.001;
        public static var meshAngleThreshold:Number = 0.001;
        public static var meshConvexThreshold:Number = 0.01;

        public var textures:TextureByteDataMap;
        public var occluders:Vector.<Occluder>;

        public function PropMesh(modelData:ByteArray, objectName:String, textureFiles:Object, files:ByteArrayMap, imageMap:TextureByteDataMap)
        {
            super(PropObjectType.MESH);
            this.parseModel(modelData, objectName, textureFiles, files, imageMap);
        }
        private function parseModel(modelData:ByteArray, objectName:String, textureFiles:Object, files:ByteArrayMap, imageMap:TextureByteDataMap):void
        {
            var textureName:String = null;
            var textureFileName:String = null;
            var textureByteData:TextureByteData = null;
            var mesh:Mesh = this.processObjects(modelData, objectName);
            this.initMesh(mesh);
            this.object = mesh;
            var defaultTextureFileName:String;
            if ((defaultTextureFileName = this.getTextureFileName(mesh)) == null && textureFiles == null)
            {
                throw new Error("PropMesh: no textures found");
            }
            if (textureFiles == null)
            {
                textureFiles = {}
            }
            if (defaultTextureFileName != null)
            {
                textureFiles["$$$_DEFAULT_TEXTURE_$$$"] = defaultTextureFileName;
            }
            this.textures = new TextureByteDataMap();
            for (textureName in textureFiles)
            {
                textureFileName = String(textureFiles[textureName]);
                if (imageMap == null)
                {
                    textureByteData = new TextureByteData(files.getValue(textureFileName), null);
                }
                else
                {
                    textureByteData = imageMap.getValue(textureFileName);
                }
                this.textures.putValue(textureName, textureByteData);
            }
        }
        private function processObjects(modelData:ByteArray, objectName:String):Mesh
        {
            var currObject:Object3D;
            var currObjectName:String;
            modelData.position = 0;
            var parser:Parser3DS = new Parser3DS();
            parser.parse(modelData);
            var objects:Vector.<Object3D> = parser.objects;
            var numObjects:int = objects.length;
            var mesh:Mesh;
            var i:int;
            while (i < numObjects)
            {
                currObject = objects[i];
                currObjectName = currObject.name.toLowerCase();
                if (currObjectName.indexOf("occl") == 0)
                {
                    this.addOccluder(Mesh(currObject));
                }
                else
                {
                    if (objectName == currObjectName)
                    {
                        mesh = Mesh(currObject);
                    }
                }
                i++;
            }
            return ((!(mesh == null)) ? mesh : Mesh(objects[0]));
        }
        private function getTextureFileName(mesh:Mesh):String
        {
            var material:TextureMaterial;
            var face:Face = mesh.alternativa3d::faceList;
            while (face != null)
            {
                material = (face.material as TextureMaterial);
                if (material != null)
                {
                    return (material.diffuseMapURL);
                }
                face = face.alternativa3d::next;
            }
            return (null);
        }
        private function addOccluder(mesh:Mesh):void
        {
            mesh.weldVertices(occluderDistanceThreshold, occluderUvThreshold);
            mesh.weldFaces(occluderAngleThreshold, occluderUvThreshold, occluderConvexThreshold);
            var occluder:Occluder = new Occluder();
            occluder.createForm(mesh);
            occluder.x = mesh.x;
            occluder.y = mesh.y;
            occluder.z = mesh.z;
            occluder.rotationX = mesh.rotationX;
            occluder.rotationY = mesh.rotationY;
            occluder.rotationZ = mesh.rotationZ;
            if (this.occluders == null)
            {
                this.occluders = new Vector.<Occluder>();
            }
            this.occluders.push(occluder);
        }
        private function initMesh(mesh:Mesh):void
        {
            mesh.weldVertices(meshDistanceThreshold, meshUvThreshold);
            mesh.weldFaces(meshAngleThreshold, meshUvThreshold, meshConvexThreshold);
            mesh.threshold = threshold;
        }
        override public function traceProp():void
        {
            var textureName:* = null;
            var textureData:TextureByteData;
            super.traceProp();
            for (textureName in this.textures)
            {
                textureData = this.textures[textureName];
            }
        }

    }
}
