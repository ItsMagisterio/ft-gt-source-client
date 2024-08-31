package alternativa.tanks.config.loaders
{
    import flash.events.EventDispatcher;
    import flash.geom.Matrix3D;
    import __AS3__.vec.Vector;
    import flash.geom.Vector3D;
    import alternativa.proplib.PropLibRegistry;
    import logic.resource.cache.CacheURLLoader;
    import alternativa.physics.collision.CollisionPrimitive;
    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.objects.Occluder;
    import alternativa.engine3d.core.Light3D;
    import flash.utils.Dictionary;
    import alternativa.tanks.models.battlefield.BattlefieldModel;
    import alternativa.init.Main;
    import alternativa.tanks.models.battlefield.IBattleField;
    import alternativa.math.Vector3;
    import flash.events.Event;
    import flash.net.URLRequest;
    import alternativa.engine3d.primitives.Plane;
    import alternativa.engine3d.primitives.Box;
    import alternativa.tanks.Triangle;
    import logic.networking.Network;
    import logic.networking.INetworker;
    import alternativa.tanks.help.MD5;
    import alternativa.proplib.objects.PropObject;
    import alternativa.proplib.objects.PropMesh;
    import alternativa.proplib.objects.PropSprite;
    import alternativa.proplib.PropLibrary;
    import alternativa.proplib.types.PropGroup;
    import alternativa.proplib.types.PropData;
    import alternativa.engine3d.lights.OmniLight;
    import alternativa.engine3d.objects.Mesh;
    import alternativa.engine3d.objects.BSP;
    import alternativa.tanks.models.battlefield.Object3DNames;
    import alternativa.utils.clearDictionary;
    import alternativa.engine3d.objects.Sprite3D;
    import alternativa.tanks.sfx.StaticObject3DPositionProvider;
    import alternativa.tanks.sfx.christmas.ChristmasTreeToyEffect;
    import alternativa.math.Matrix3;
    import alternativa.physics.collision.primitives.CollisionRect;
    import alternativa.physics.collision.primitives.CollisionBox;
    import alternativa.physics.collision.primitives.CollisionTriangle;
    import __AS3__.vec.*;
    import alternativa.engine3d.alternativa3d;
    import alternativa.utils.ByteArrayMap;
    import flash.net.URLLoaderDataFormat;
    import alternativa.utils.TARAParser;
    import flash.utils.ByteArray;
    import alternativa.startup.CacheURLPTLoader;
    use namespace alternativa3d;

    [Event(name="complete", type="flash.events.Event")]
    public class MapLoader extends EventDispatcher
    {

        public static const dummyTextureClass:Class = MapLoader_dummyTextureClass;
        private static const STATIC_COLLISION_GROUP:int = 0xFF;
        private static const MAX_BATCH_SIZE:int = 20;
        private static var objectMatrix:Matrix3D = new Matrix3D();
        private static var components:Vector.<Vector3D> = Vector.<Vector3D>([new Vector3D(), new Vector3D(), new Vector3D(1, 1, 1)]);

        public var mapXml:XML;
        public var propLibRegistry:PropLibRegistry;
        private var loader:CacheURLPTLoader;
        private var _collisionPrimitives:Vector.<CollisionPrimitive>;
        private var _visualCollisionObjects:Vector.<Object3D>;
        private var materialUsersRegistry:MaterialUsersRegistry;
        private var batchTextureBuilder:BatchTextureBuilder;
        private var mipMapResolution:Number = 5;

        private var normalsCalculator:NormalsCalculator = new NormalsCalculator();
        private var meshes:Vector.<Object3D> = new Vector.<Object3D>();
        private var toys:Array = new Array();
        private var _objects:Vector.<Object3D> = new Vector.<Object3D>();
        private var _sprites:Vector.<Object3D> = new Vector.<Object3D>();
        private var _occluders:Vector.<Occluder> = new Vector.<Occluder>();
        private var _lights:Vector.<Light3D> = new Vector.<Light3D>();
        private var textureNameByMesh:Dictionary = new Dictionary();
        private var propObjectByMesh:Dictionary = new Dictionary();
        private var spawnPoints:Object = {}
        private var battlefieldModel:BattlefieldModel = (Main.osgi.getService(IBattleField) as BattlefieldModel);
        private var resourceMap:ByteArrayMap;
        private var mapResourceId:String;

        private static function isNaNVector(v:Vector3):Boolean
        {
            return (((isNaN(v.x)) || (isNaN(v.y))) || (isNaN(v.z)));
        }
        private static function readVector3(xml:XMLList, result:Vector3):void
        {
            var element:XML;
            if (xml.length() > 0)
            {
                element = xml[0];
                result.x = Number(element.x);
                result.y = Number(element.y);
                result.z = Number(element.z);
            }
            else
            {
                result.x = (result.y = (result.z = 0));
            }
        }
        private static function readVector3D(xml:XMLList, result:Vector3D):void
        {
            var el:XML;
            el = null;
            if (xml.length() > 0)
            {
                el = xml[0];
                result.x = Number(el.x);
                result.y = Number(el.y);
                result.z = Number(el.z);
            }
            else
            {
                result.x = (result.y = (result.z = 0));
            }
        }
        private static function xmlToString(xml:XML, defaultValue:String):String
        {
            if (xml == null)
            {
                return (defaultValue);
            }
            return ((xml.toString()) || (defaultValue));
        }

        public function load(url:String, libRegistry:PropLibRegistry):void
        {
            if (url == null)
            {
                throw (new ArgumentError("Parameter url cannot be null"));
            }
            if (libRegistry == null)
            {
                throw (new ArgumentError("Parameter libRegistry cannot be null"));
            }
            this.propLibRegistry = libRegistry;
            this.loader = new CacheURLPTLoader();
            this.loader.addEventListener(this.parse);
            // TODO: load this from server
            this.mapResourceId = url;
            var path:String = "maps.tara";
            this.loader.load(path);
        }

        private function parse():void
        {
            this.resourceMap = TARAParser.parse(this.loader.data as ByteArray);
            this.mapXml = XML(this.resourceMap.getValue(this.mapResourceId).toString());
            this.onLoadingComplete();
        }

        public function get lights():Vector.<Light3D>
        {
            return (this._lights);
        }
        public function get objects():Vector.<Object3D>
        {
            return (this._objects);
        }
        public function get sprites():Vector.<Object3D>
        {
            return (this._sprites);
        }
        public function get occluders():Vector.<Occluder>
        {
            return (this._occluders);
        }
        public function get collisionPrimitives():Vector.<CollisionPrimitive>
        {
            return (this._collisionPrimitives);
        }
        public function getFlagPosition(_arg_1:String):Vector3D
        {
            var xmlList:XMLList = this.mapXml.elements("ctf-flags").elements(("flag-" + _arg_1));
            if (xmlList.length() == 0)
            {
                return (null);
            }
            var position:Vector3D = new Vector3D();
            readVector3D(xmlList, position);
            return (position);
        }
        public function get visualCollisionObjects():Vector.<Object3D>
        {
            var colXml:XML;
            var v0:Vector3D;
            var v1:Vector3D;
            var v2:Vector3D;
            var w:Number = NaN;
            var l:Number = NaN;
            var plane:Plane;
            var size:Vector3D;
            var box:Box;
            var tri:Triangle;
            if (this._visualCollisionObjects != null)
            {
                return (this._visualCollisionObjects);
            }
            this._visualCollisionObjects = new Vector.<Object3D>();
            var components:Vector.<Vector3D> = Vector.<Vector3D>([new Vector3D(), new Vector3D(), new Vector3D(1, 1, 1)]);
            var matrix:Matrix3D = new Matrix3D();
            for each (colXml in this.mapXml.elements("collision-geometry").elements("collision-plane"))
            {
                w = Number(colXml.width);
                l = Number(colXml.length);
                plane = new Plane(w, l);
                readVector3D(colXml.position, components[0]);
                readVector3D(colXml.rotation, components[1]);
                matrix.recompose(components);
                plane.matrix = matrix;
                this._visualCollisionObjects.push(plane);
            }
            for each (colXml in this.mapXml.elements("collision-geometry").elements("collision-box"))
            {
                size = components[0];
                readVector3D(colXml.size, size);
                box = new Box(size.x, size.y, size.z);
                readVector3D(colXml.position, components[0]);
                readVector3D(colXml.rotation, components[1]);
                matrix.recompose(components);
                box.matrix = matrix;
                this._visualCollisionObjects.push(box);
            }
            v0 = new Vector3D();
            v1 = new Vector3D();
            v2 = new Vector3D();
            for each (colXml in this.mapXml.elements("collision-geometry").elements("collision-triangle"))
            {
                readVector3D(colXml.v0, v0);
                readVector3D(colXml.v1, v1);
                readVector3D(colXml.v2, v2);
                tri = new Triangle(v0, v1, v2, false);
                readVector3D(colXml.position, components[0]);
                readVector3D(colXml.rotation, components[1]);
                matrix.recompose(components);
                tri.matrix = matrix;
                this._visualCollisionObjects.push(tri);
            }
            return (this._visualCollisionObjects);
        }
        private function onLoadingComplete():void
        {
            Network(Main.osgi.getService(INetworker)).send(((((("battle;" + "check_") + "m") + "d5") + "_map;") + MD5.hex_md5(this.mapXml.toString())));
            this.loader = null;
            this.parseProps();
            this.normalsCalculator.calculateNormals(this.meshes);
            this.makeBSPs();
            this.parseCollisionPrimitives();
            this.runTextureBuilder();
            this.setupChristmasTreeToys();
        }
        private function parseProps():void
        {
            var propXML:XML;
            this.materialUsersRegistry = new MaterialUsersRegistry();
            for each (propXML in this.mapXml.elements("static-geometry").prop)
            {
                this.parseProp(propXML);
            }
        }
        private function parseProp(propXml:XML):void
        {
            var propObject:PropObject = this.getPropObject(propXml);
            if ((propObject is PropMesh))
            {
                this.parsePropMesh(propXml, PropMesh(propObject));
            }
            else
            {
                if ((propObject is PropSprite))
                {
                    this.parsePropSprite(propXml, PropSprite(propObject));
                }
            }
        }
        private function getPropObject(propXml:XML):PropObject
        {
            var libName:String = propXml.attribute("library-name");
            var groupName:String = propXml.attribute("group-name");
            var propName:String = propXml.@name;
            var library:PropLibrary = this.propLibRegistry.getLibrary(libName);
            if (library == null)
            {
                return null;
                // throw (new Error(("Library not found " + libName)));
            }
            var group:PropGroup = library.rootGroup.getGroupByName(groupName);
            if (group == null)
            {
                return null;
                // throw (new Error(((("Group not found " + groupName) + " in library ") + libName)));
            }
            var propData:PropData = group.getPropByName(propName);
            if (propData == null)
            {
                return null;
                // throw (new Error(((((("Prop data not found " + propName) + " in group ") + groupName) + " in library ") + libName)));
            }
            return (propData.getDefaultState().getDefaultObject());
        }
        private function parsePropMesh(propXml:XML, propMesh:PropMesh):void
        {
            var omni:OmniLight;
            var occluder:Occluder;
            var matrix:Matrix3D;
            var mapOccluder:Occluder;
            var textureName:String = xmlToString(propXml.elements("texture-name")[0], PropMesh.DEFAULT_TEXTURE);
            if (textureName == "invisible")
            {
                return;
            }
            var position:Vector3D = components[0];
            var rotation:Vector3D = components[1];
            var mesh:Mesh = Mesh(propMesh.object.clone());
            readVector3D(propXml.position, position);
            mesh.x = position.x;
            mesh.y = position.y;
            mesh.z = position.z;
            readVector3D(propXml.rotation, rotation);
            mesh.rotationZ = rotation.z;
            if (propXml.elements("texture-name")[0] == "pumpkin")
            {
                omni = new OmniLight(0xFF8000, 500, 1000);
                omni.x = mesh.x;
                omni.y = mesh.y;
                omni.z = (mesh.z + 500);
                this._lights.push(omni);
            }
            this.textureNameByMesh[mesh] = textureName;
            this.propObjectByMesh[mesh] = propMesh;
            this.meshes.push(mesh);
            if (propMesh.occluders != null)
            {
                objectMatrix.recompose(components);
                for each (occluder in propMesh.occluders)
                {
                    matrix = occluder.matrix;
                    matrix.append(objectMatrix);
                    mapOccluder = Occluder(occluder.clone());
                    mapOccluder.matrix = matrix;
                    this._occluders.push(mapOccluder);
                }
            }
        }
        private function makeBSPs():void
        {
            var mesh:Mesh;
            var object:Object3D;
            var bsp:BSP;
            for each (object in this.meshes)
            {
                mesh = Mesh(object);
                bsp = new BSP();
                bsp.name = Object3DNames.STATIC;
                bsp.createTree(mesh, true);
                bsp.x = mesh.x;
                bsp.y = mesh.y;
                bsp.z = mesh.z;
                bsp.rotationZ = mesh.rotationZ;
                this.materialUsersRegistry.addBSP(this.propObjectByMesh[mesh], this.textureNameByMesh[mesh], new BSPWrapper(bsp));
                this._objects.push(bsp);
                mesh.shadowMapAlphaThreshold = 0.1;
                mesh.calculateVerticesNormalsBySmoothingGroups(0.01);
                if (mesh.name == "elka01")
                {
                    bsp.faces[0].material.alphaTestThreshold = 0.5;
                }
            }
            this.meshes.length = 0;
            clearDictionary(this.textureNameByMesh);
            clearDictionary(this.propObjectByMesh);
        }
        private function parsePropSprite(propXml:XML, propSprite:PropSprite):void
        {
            var toy:Vector3D;
            var sprite:Sprite3D = Sprite3D(propSprite.object.clone());
            if (propXml.@name.indexOf("Shar") != -1)
            {
                this.toys.push(sprite);
                toy = components[0];
                readVector3D(propXml.position, toy);
                sprite.x = toy.x;
                sprite.y = toy.y;
                sprite.z = toy.z;
                sprite.name = propXml.@name;
                return;
            }
            var position:Vector3D = components[0];
            readVector3D(propXml.position, position);
            sprite.x = position.x;
            sprite.y = position.y;
            sprite.z = position.z;
            sprite.width = propSprite.scale;
            sprite.softAttenuation = 80;
            this._sprites.push(sprite);
            this.materialUsersRegistry.addSprite3D(propSprite, new Sprite3DWrapper(sprite));
        }
        private function setupChristmasTreeToys():void
        {
            var _loc2_:Sprite3D;
            var _loc3_:StaticObject3DPositionProvider;
            var _loc4_:Vector3;
            var _loc5_:ChristmasTreeToyEffect;
            if (this.toys.length < 1)
            {
                return;
            }
            var _loc1_:Vector3 = new Vector3();
            for each (_loc2_ in this.toys)
            {
                _loc1_.x = (_loc1_.x + _loc2_.x);
                _loc1_.y = (_loc1_.y + _loc2_.y);
                _loc1_.z = (_loc1_.z + _loc2_.z);
            }
            _loc1_.x = (_loc1_.x / this.toys.length);
            _loc1_.y = (_loc1_.y / this.toys.length);
            _loc1_.z = (_loc1_.z / this.toys.length);
            for each (_loc2_ in this.toys)
            {
                _loc3_ = StaticObject3DPositionProvider(this.battlefieldModel.getObjectPool().getObject(StaticObject3DPositionProvider));
                _loc4_ = new Vector3(_loc2_.x, _loc2_.y, _loc2_.z);
                _loc3_.init(_loc4_, 150);
                _loc5_ = ChristmasTreeToyEffect(this.battlefieldModel.getObjectPool().getObject(ChristmasTreeToyEffect));
                _loc5_.init(_loc2_, _loc3_, _loc1_);
                this.battlefieldModel.addGraphicEffect(_loc5_);
            }
        }
        private function parseCollisionPrimitives():void
        {
            var rotation:Vector3;
            var primitive:CollisionPrimitive;
            var primitiveXml:XML;
            var v0:Vector3;
            var v1:Vector3;
            var v2:Vector3;
            this._collisionPrimitives = new Vector.<CollisionPrimitive>();
            var rotationMatrix:Matrix3 = new Matrix3();
            var halfSize:Vector3 = new Vector3();
            var position:Vector3 = new Vector3();
            rotation = new Vector3();
            var collisionXml:XMLList = this.mapXml.elements("collision-geometry")[0].elements("collision-plane");
            for each (primitiveXml in collisionXml)
            {
                halfSize.x = (0.5 * Number(primitiveXml.width));
                halfSize.y = (0.5 * Number(primitiveXml.length));
                halfSize.z = 0;
                readVector3(primitiveXml.position, position);
                readVector3(primitiveXml.rotation, rotation);
                rotationMatrix.setRotationMatrix(rotation.x, rotation.y, rotation.z);
                primitive = new CollisionRect(halfSize, STATIC_COLLISION_GROUP);
                primitive.transform.setFromMatrix3(rotationMatrix, position);
                this._collisionPrimitives.push(primitive);
            }
            collisionXml = this.mapXml.elements("collision-geometry")[0].elements("collision-box");
            for each (primitiveXml in collisionXml)
            {
                readVector3(primitiveXml.size, halfSize);
                halfSize.scale(0.5);
                readVector3(primitiveXml.position, position);
                readVector3(primitiveXml.rotation, rotation);
                rotationMatrix.setRotationMatrix(rotation.x, rotation.y, rotation.z);
                primitive = new CollisionBox(halfSize, STATIC_COLLISION_GROUP);
                primitive.transform.setFromMatrix3(rotationMatrix, position);
                this._collisionPrimitives.push(primitive);
            }
            v0 = new Vector3();
            v1 = new Vector3();
            v2 = new Vector3();
            collisionXml = this.mapXml.elements("collision-geometry")[0].elements("collision-triangle");
            for each (primitiveXml in collisionXml)
            {
                readVector3(primitiveXml.v0, v0);
                readVector3(primitiveXml.v1, v1);
                readVector3(primitiveXml.v2, v2);
                if ((!(((isNaNVector(v0)) || (isNaNVector(v1))) || (isNaNVector(v2)))))
                {
                    readVector3(primitiveXml.position, position);
                    readVector3(primitiveXml.rotation, rotation);
                    rotationMatrix.setRotationMatrix(rotation.x, rotation.y, rotation.z);
                    primitive = new CollisionTriangle(v0, v1, v2, STATIC_COLLISION_GROUP);
                    primitive.transform.setFromMatrix3(rotationMatrix, position);
                    this._collisionPrimitives.push(primitive);
                }
            }
        }
        private function runTextureBuilder():void
        {
            this.batchTextureBuilder = new BatchTextureBuilder();
            this.batchTextureBuilder.addEventListener(Event.COMPLETE, this.onTexturesComplete);
            this.batchTextureBuilder.run(this.mipMapResolution, MAX_BATCH_SIZE, this.materialUsersRegistry.bspEntries, this.materialUsersRegistry.spriteEntries);
        }
        private function onTexturesComplete(e:Event):void
        {
            this.batchTextureBuilder.removeEventListener(Event.COMPLETE, this.onTexturesComplete);
            this.batchTextureBuilder = null;
            this.complete();
        }
        private function complete():void
        {
            this.propLibRegistry.destroy();
            this.propLibRegistry = null;
            this.materialUsersRegistry = null;
            if (hasEventListener(Event.COMPLETE))
            {
                dispatchEvent(new Event(Event.COMPLETE));
            }
        }
        public function destroy():*
        {
            var cp:* = undefined;
            var m:Mesh;
            var s:Sprite3D;
            var o:Occluder;
            if (this._collisionPrimitives != null)
            {
                for each (cp in this._collisionPrimitives)
                {
                    if ((cp is CollisionTriangle))
                    {
                        (cp as CollisionTriangle).destroy();
                    }
                    else
                    {
                        if ((cp is CollisionRect))
                        {
                            (cp as CollisionRect).destroy();
                        }
                        else
                        {
                            (cp as CollisionPrimitive).destroy();
                        }
                    }
                }
                this._collisionPrimitives = null;
            }
            if (this.meshes != null)
            {
                for each (m in this.meshes)
                {
                    // m.destroy();
                    m = null;
                }
                this.meshes = null;
            }
            if (this._sprites != null)
            {
                for each (s in this._sprites)
                {
                    // s.destroy();
                    s = null;
                }
                this._sprites = null;
            }
            if (this._occluders != null)
            {
                for each (o in this._occluders)
                {
                    // o.destroy();
                    o = null;
                }
                this._occluders = null;
            }
        }

    }
}

import alternativa.engine3d.materials.TextureMaterial;
import alternativa.engine3d.objects.Sprite3D;
import flash.display.BitmapData;
import alternativa.engine3d.objects.BSP;
import __AS3__.vec.Vector;
import alternativa.proplib.objects.PropMesh;
import alternativa.proplib.objects.PropSprite;
import alternativa.utils.textureutils.TextureByteData;
import flash.events.EventDispatcher;
import alternativa.utils.textureutils.ITextureConstructorListener;
import alternativa.init.Main;
import alternativa.tanks.model.panel.IBattleSettings;
import alternativa.engine3d.core.MipMapping;
import alternativa.utils.textureutils.TextureConstructor;
import flash.events.Event;
import __AS3__.vec.*;
import alternativa.tanks.config.loaders.MapLoader;

interface IMaterialUser
{

    function setMaterial(_arg_1:TextureMaterial):void;

}

class Sprite3DWrapper implements IMaterialUser
{

    private var sprite:Sprite3D;

    public function Sprite3DWrapper(sprite:Sprite3D)
    {
        this.sprite = sprite;
    }
    public function setMaterial(material:TextureMaterial):void
    {
        var texture:BitmapData = material.texture;
        this.sprite.material = material;
        var scale:Number = this.sprite.width;
        this.sprite.width = (scale * texture.width);
        this.sprite.height = (scale * texture.height);
        material.resolution = this.sprite.calculateResolution(texture.width, texture.height);
    }

}

class BSPWrapper implements IMaterialUser
{

    private var bsp:BSP;

    public function BSPWrapper(bsp:BSP)
    {
        this.bsp = bsp;
    }
    public function setMaterial(material:TextureMaterial):void
    {
        this.bsp.setMaterialToAllFaces(material);
    }

}

class MaterialUsersRegistry
{

    public var bspEntries:Vector.<BSPMaterialUserEntry> = new Vector.<BSPMaterialUserEntry>();
    public var spriteEntries:Vector.<Sprite3DMaterialUserEntry> = new Vector.<Sprite3DMaterialUserEntry>();

    public function addBSP(propMesh:PropMesh, textureName:String, materialUser:BSPWrapper):void
    {
        var entry:BSPMaterialUserEntry;
        var currentEntry:BSPMaterialUserEntry;
        for each (currentEntry in this.bspEntries)
        {
            if (((currentEntry.propMesh == propMesh) && (currentEntry.textureName == textureName)))
            {
                entry = currentEntry;
                break;
            }
        }
        if (entry == null)
        {
            entry = new BSPMaterialUserEntry(propMesh, textureName);
            this.bspEntries.push(entry);
        }
        entry.materialUsers.push(materialUser);
    }
    public function addSprite3D(propSprite:PropSprite, wrapper:Sprite3DWrapper):void
    {
        var entry:Sprite3DMaterialUserEntry;
        var currentEntry:Sprite3DMaterialUserEntry;
        for each (currentEntry in this.spriteEntries)
        {
            if (currentEntry.propSprite == propSprite)
            {
                entry = currentEntry;
                break;
            }
        }
        if (entry == null)
        {
            entry = new Sprite3DMaterialUserEntry(propSprite);
            this.spriteEntries.push(entry);
        }
        entry.materialUsers.push(wrapper);
    }

}

class MaterialUserEntry
{

    public var materialUsers:Vector.<IMaterialUser> = new Vector.<IMaterialUser>();

    public function getTextureData():TextureByteData
    {
        throw (new Error("Not implemented"));
    }

}

class BSPMaterialUserEntry extends MaterialUserEntry
{

    public var propMesh:PropMesh;
    public var textureName:String;

    public function BSPMaterialUserEntry(propMesh:PropMesh, textureName:String)
    {
        this.propMesh = propMesh;
        this.textureName = textureName;
    }
    override public function getTextureData():TextureByteData
    {
        var ro:TextureByteData = this.propMesh.textures.getValue(this.textureName);
        return (ro);
    }

}

class Sprite3DMaterialUserEntry extends MaterialUserEntry
{

    public var propSprite:PropSprite;

    public function Sprite3DMaterialUserEntry(propSprite:PropSprite)
    {
        this.propSprite = propSprite;
    }
    override public function getTextureData():TextureByteData
    {
        return (this.propSprite.textureData);
    }

}

class BatchTextureBuilder extends EventDispatcher implements ITextureConstructorListener
{

    private var mipMapResolution:Number;
    private var maxBatchSize:int;
    private var batchSize:int;
    private var firstBatchIndex:int;
    private var batchCouner:int;
    private var totalCounter:int;
    private var entries:Vector.<MaterialUserEntry>;
    private var constructors:Vector.<IndexedTextureConstructor>;
    private var useMipMap:Boolean;

    public function run(mipMapResolution:Number, maxBatchSize:int, bspEntries:Vector.<BSPMaterialUserEntry>, spriteEntries:Vector.<Sprite3DMaterialUserEntry>):void
    {
        var bspEntry:* = null;
        var spriteEntry:* = null;
        var i:int = 0;
        this.mipMapResolution = mipMapResolution;
        this.maxBatchSize = maxBatchSize;
        this.constructors = new Vector.<IndexedTextureConstructor>(maxBatchSize);
        while (i < maxBatchSize)
        {
            this.constructors[i] = new IndexedTextureConstructor();
            i++;
        }
        this.entries = new Vector.<MaterialUserEntry>();
        for each (bspEntry in bspEntries)
        {
            this.entries.push(bspEntry);
        }
        for each (spriteEntry in spriteEntries)
        {
            this.entries.push(spriteEntry);
        }
        this.totalCounter = 0;
        this.firstBatchIndex = 0;
        this.createBatch();
    }
    public function onTextureReady(constructor:TextureConstructor):void
    {
        var materialUser:* = null;
        var textureConstructor:IndexedTextureConstructor = IndexedTextureConstructor(constructor);
        var textureMaterial:TextureMaterial = new TextureMaterial(textureConstructor.texture, false, true, 2, this.mipMapResolution);
        for each (materialUser in this.entries[textureConstructor.index].materialUsers)
        {
            materialUser.setMaterial(textureMaterial);
        }
        this.totalCounter++;
        this.batchCouner++;
        if (this.totalCounter == this.entries.length)
        {
            this.complete();
        }
        else if (this.batchCouner == this.batchSize)
        {
            this.createBatch();
        }
    }
    private function createBatch():void
    {
        var textureConstructor:IndexedTextureConstructor = null;
        var textureData:TextureByteData = null;
        var i:int = 0;
        this.batchCouner = 0;
        var nextIndex:int = this.firstBatchIndex + this.maxBatchSize;
        if (nextIndex > this.entries.length)
        {
            nextIndex = int(this.entries.length);
        }
        this.batchSize = nextIndex - this.firstBatchIndex;
        while (i < this.batchSize)
        {
            textureConstructor = this.constructors[i];
            textureConstructor.index = this.firstBatchIndex + i;
            textureData = this.entries[textureConstructor.index].getTextureData();
            if (textureData == null)
            {
                textureData = new TextureByteData();
            }
            if (textureData.diffuseData == null)
            {
                textureData.diffuseData = new MapLoader.dummyTextureClass();
            }
            textureConstructor.createTexture(textureData, this);
            i++;
        }
        this.firstBatchIndex = nextIndex;
    }
    private function complete():void
    {
        this.constructors = null;
        this.entries = null;
        dispatchEvent(new Event(Event.COMPLETE));
    }

}

class IndexedTextureConstructor extends TextureConstructor
{

    public var index:int;

}
