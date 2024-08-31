package alternativa.tanks.config
{
    import alternativa.proplib.PropLibRegistry;
    import alternativa.utils.TaskSequence;
    import flash.events.Event;
    import alternativa.utils.ByteArrayMap;
    import alternativa.utils.TARAParser;

    public class PropLibsLoader extends ResourceLoader
    {

        private var libRegistry:PropLibRegistry = new PropLibRegistry();
        private var sequence:TaskSequence;
        private var resourceMap:ByteArrayMap;
        private var taraPath:String;

        public function PropLibsLoader(taraPath:String, config:Config)
        {
            this.taraPath = taraPath;
            super("Props library loader", config);
        }
        override public function run():void
        {
            this.sequence = new TaskSequence();
            this.sequence.addTask(new PropLibLoadingTask(taraPath, this.libRegistry));
            this.sequence.addEventListener(Event.COMPLETE, this.onProplobsLoadingComplete);
            this.sequence.run();
        }
        private function onProplobsLoadingComplete(e:Event):void
        {
            this.sequence = null;
            config.propLibRegistry = this.libRegistry;
            completeTask();
        }

    }
}

import alternativa.utils.Task;
import alternativa.proplib.PropLibRegistry;
import logic.resource.cache.CacheURLLoader;
import flash.net.URLLoaderDataFormat;
import flash.events.Event;
import flash.net.URLRequest;
import alternativa.proplib.PropLibrary;
import alternativa.utils.TARAParser;
import specter.utils.Logger;
import flash.utils.ByteArray;
import alternativa.utils.ByteArrayMap;
import alternativa.startup.CacheURLPTLoader;

class PropLibLoadingTask extends Task
{

    private var taraPath:String;
    private var libRegistry:PropLibRegistry;
    private var loader:CacheURLPTLoader;

    public function PropLibLoadingTask(taraPath:String, libRegistry:PropLibRegistry)
    {
        this.taraPath = taraPath;
        this.libRegistry = libRegistry;
    }
    override public function run():void
    {
        this.loader = new CacheURLPTLoader();
        this.loader.addEventListener(this.parse);
        this.loader.load(this.taraPath);
    }
    private function parse():void
    {
        var resourceMap:ByteArrayMap = TARAParser.parse(this.loader.data as ByteArray); // da
        for (var key:String in resourceMap.data)
        {
            if (key.indexOf("resource") == -1 && key.indexOf("New folder") == -1 && key.indexOf("maps") == -1)
            {
                var propLibrary:PropLibrary = new PropLibrary(TARAParser.parse(resourceMap.getValue(key)));
                this.libRegistry.addLibrary(propLibrary);

            }
        }
        completeTask();
        // Logger.log(("Loaded prop: " + this.url));
    }

}
