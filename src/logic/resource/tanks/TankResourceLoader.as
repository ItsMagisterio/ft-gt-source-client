// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// scpacker.resource.tanks.TankResourceLoader

package logic.resource.tanks
{
	import __AS3__.vec.Vector;
	import flash.utils.Dictionary;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import alternativa.osgi.service.storage.IStorageService;
	import alternativa.init.Main;
	import logic.resource.cache.CacheURLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.geom.Vector3D;
	import alternativa.engine3d.core.Object3D;
	import flash.utils.ByteArray;
	import alternativa.engine3d.loaders.Parser3DS;
	import specter.utils.Logger;
	import alternativa.engine3d.objects.Mesh;
	import logic.resource.failed.FailedResource;
	import logic.resource.ResourceUtil;
	import flash.events.IOErrorEvent;
	import __AS3__.vec.*;
	import alternativa.utils.TARAParser;
	import alternativa.utils.ByteArrayMap;
	import alternativa.startup.CacheURLPTLoader;

	public class TankResourceLoader
	{

		private var path:String;
		public var list:TankResourceList;
		private var queue:Vector.<String>;
		private var length:int = 0;
		public var status:int = 0;
		private var lengthFailed:int = 0;
		private var failedResources:Dictionary = new Dictionary();
		private var loader:CacheURLPTLoader;
		private var resourceMap:ByteArrayMap;

		public function TankResourceLoader(path:String)
		{
			this.path = path;
			this.list = new TankResourceList();
			this.queue = new Vector.<String>();
			this.loader = new CacheURLPTLoader();
			this.loader.addEventListener(this.parse);
			this.loader.load(path);
		}
		private function parse():void
		{
			this.resourceMap = TARAParser.parse(this.loader.data as ByteArray);

			for (var key:String in resourceMap.data)
			{
				this.queue.push(key);
				this.length++;
			}
			this.loadQueue();
		}
		private function loadQueue():void
		{
			var resourceId:String;
			for each (resourceId in this.queue)
			{
				this.loadModel(resourceId);
			}
		}
		private function loadModel(resourceId:String):void
		{

			var flagMount:Vector3D;
			var turretMount:Vector3D;
			var obj:Object3D;
			var bytes:ByteArray = ByteArray(loader.data);
			var parser:Parser3DS = new Parser3DS();
			var muzzles:Vector.<Vector3D> = new Vector.<Vector3D>();
			parser.parse(resourceMap.getValue(resourceId));
			for each (obj in parser.objects)
			{
				if (obj.name.split("0")[0] == "muzzle")
				{
					muzzles.push(new Vector3D(obj.x, obj.y, obj.z));
				}
				if (obj.name.indexOf("fmnt") >= 0)
				{
					flagMount = new Vector3D(obj.x, obj.y, obj.z);
				}
				if (obj.name == "mount")
				{
					turretMount = new Vector3D(obj.x, obj.y, obj.z);
				}
			}
			if (parser.objects.length < 1)
			{
				Logger.log((("Invalid mesh width 0 objects: " + resourceId) as String));
				return;
			}
			var tnk:TankResource = new TankResource(Mesh(parser.objects[0]), resourceId.split(".")[0], null, muzzles, flagMount, turretMount);
			tnk.objects = parser.objects;
			list.add(tnk);
			this.length--;
			if (this.length == 0)
			{
				status = 1;
				ResourceUtil.onCompleteLoading();
			}
			muzzles = null;

		}

	}
} // package scpacker.resource.tanks