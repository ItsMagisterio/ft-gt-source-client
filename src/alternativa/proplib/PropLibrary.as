﻿package alternativa.proplib
{
    import alternativa.proplib.types.PropGroup;
    import alternativa.utils.ByteArrayMap;
    import alternativa.proplib.utils.TextureByteDataMap;
    import flash.utils.ByteArray;
    import alternativa.proplib.types.PropData;
    import alternativa.proplib.objects.PropObject;
    import alternativa.engine3d.objects.Mesh;
    import alternativa.utils.XMLUtils;
    import alternativa.utils.textureutils.TextureByteData;
    import alternativa.proplib.types.PropState;
    import alternativa.proplib.objects.PropMesh;
    import alternativa.proplib.objects.PropSprite;

    public class PropLibrary
    {

        public static const LIB_FILE_NAME:String = "library.xml";
        public static const IMG_FILE_NAME:String = "images.xml";

        private var _rootGroup:PropGroup;
        private var files:ByteArrayMap;
        private var imageMap:TextureByteDataMap;

        public function PropLibrary(files:ByteArrayMap)
        {
            if (files == null)
            {
                throw (new ArgumentError("Parameter files is null"));
            }
            this.files = files;
            var imageMapData:ByteArray = files.getValue(IMG_FILE_NAME);
            if (imageMapData != null)
            {
                this.imageMap = this.parseImageMap(XML(imageMapData.toString()));
            }
            imageMapData = null;
            this._rootGroup = this.parseGroup(XML(files.getValue(LIB_FILE_NAME).toString()));
            prepareMeshes(this._rootGroup);
        }
        private static function prepareMeshes(param1:PropGroup):void
        {
            var _loc2_:PropGroup;
            var _loc3_:PropData;
            var _loc4_:PropObject;
            if (param1.groups != null)
            {
                for each (_loc2_ in param1.groups)
                {
                    prepareMeshes(_loc2_);
                }
            }
            if (param1.props != null)
            {
                for each (_loc3_ in param1.props)
                {
                    _loc4_ = _loc3_.getDefaultState().getDefaultObject();
                    if ((_loc4_.object is Mesh))
                    {
                        Mesh(_loc4_.object).calculateFacesNormals();
                        Mesh(_loc4_.object).calculateVerticesNormalsByAngle(((65 / 180) * Math.PI), 0.01);
                    }
                }
            }
        }

        public function get name():String
        {
            return ((this._rootGroup == null) ? null : this._rootGroup.name);
        }
        public function get rootGroup():PropGroup
        {
            return (this._rootGroup);
        }
        private function parseImageMap(imagesXml:XML):TextureByteDataMap
        {
            var image:* = null;
            var originalTextureFileName:String = null;
            var diffuseName:String = null;
            var opacityName:String = null;
            var imageFiles:TextureByteDataMap = new TextureByteDataMap();
            for each (image in imagesXml.image)
            {
                originalTextureFileName = image.@name;
                diffuseName = image.attribute("new-name").toString().toLowerCase();
                if ((opacityName = XMLUtils.getAttributeAsString(image, "alpha", null)) != null)
                {
                    opacityName = opacityName.toLowerCase();
                }
                imageFiles.putValue(originalTextureFileName, new TextureByteData(this.files.getValue(diffuseName), this.files.getValue(opacityName)));
            }
            return imageFiles;
        }
        private function parseGroup(groupXML:XML):PropGroup
        {
            var propElement:XML;
            var groupElement:XML;
            var group:PropGroup = new PropGroup(XMLUtils.copyXMLString(groupXML.@name));
            for each (propElement in groupXML.prop)
            {
                group.addProp(this.parseProp(propElement));
            }
            for each (groupElement in groupXML.elements("prop-group"))
            {
                group.addGroup(this.parseGroup(groupElement));
            }
            return (group);
        }
        private function parseProp(propXml:XML):PropData
        {
            var stateXml:XML;
            var prop:PropData = new PropData(XMLUtils.copyXMLString(propXml.@name));
            var states:XMLList = propXml.state;
            if (states.length() > 0)
            {
                for each (stateXml in states)
                {
                    prop.addState(XMLUtils.copyXMLString(stateXml.@name), this.parseState(stateXml));
                }
            }
            else
            {
                prop.addState(PropState.DEFAULT_NAME, this.parseState(propXml));
            }
            return (prop);
        }
        private function parseState(stateXml:XML):PropState
        {
            var lodXml:XML;
            var state:PropState = new PropState();
            var lods:XMLList = stateXml.lod;
            if (lods.length() > 0)
            {
                for each (lodXml in lods)
                {
                    state.addLOD(this.parsePropObject(lodXml), Number(lodXml.@distance));
                }
            }
            else
            {
                state.addLOD(this.parsePropObject(stateXml), 0);
            }
            return (state);
        }
        private function parsePropObject(parentXmlElement:XML):PropObject
        {
            if (parentXmlElement.mesh.length() > 0)
            {
                return (this.parsePropMesh(parentXmlElement.mesh[0]));
            }
            if (parentXmlElement.sprite.length() > 0)
            {
                return (this.parsePropSprite(parentXmlElement.sprite[0]));
            }
            throw (new Error("Unknown prop type"));
        }
        private function parsePropMesh(propXml:XML):PropMesh
        {
            var textureXml:XML;
            var modelData:ByteArray = this.files.getValue(propXml.@file.toString().toLowerCase());
            var textureFiles:Object;
            if (propXml.texture.length() > 0)
            {
                textureFiles = {}
                for each (textureXml in propXml.texture)
                {
                    textureFiles[XMLUtils.copyXMLString(textureXml.@name)] = textureXml.attribute("diffuse-map").toString().toLowerCase();
                }
            }
            var objectName:String = XMLUtils.getAttributeAsString(propXml, "file", null);
            return (new PropMesh(modelData, objectName, textureFiles, this.files, this.imageMap));
        }
        private function parsePropSprite(propXml:XML):PropSprite
        {
            var textureFile:String = propXml.@file.toString().toLowerCase();
            var textureData:TextureByteData = ((this.imageMap == null) ? new TextureByteData(this.files.getValue(textureFile)) : this.imageMap.getValue(textureFile));
            var originX:Number = XMLUtils.getAttributeAsNumber(propXml, "origin-x", 0.5);
            var originY:Number = XMLUtils.getAttributeAsNumber(propXml, "origin-y", 0.5);
            var scale:Number = XMLUtils.getAttributeAsNumber(propXml, "scale", 1);
            return (new PropSprite(textureData, originX, originY, scale));
        }
        public function freeMemory():*
        {
            this.files.destroy();
        }

    }
}
