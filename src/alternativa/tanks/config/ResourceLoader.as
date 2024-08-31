package alternativa.tanks.config
{
    import alternativa.utils.Task;

    public class ResourceLoader extends Task
    {

        public var config:Config;
        public var name:String;

        public function ResourceLoader(name:String, config:Config)
        {
            this.config = config;
            this.name = name;
        }
    }
}
