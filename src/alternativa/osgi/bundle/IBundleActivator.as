package alternativa.osgi.bundle
{
    import alternativa.init.OSGi;

    public interface IBundleActivator
    {

        function start(_arg_1:OSGi):void;
        function stop(_arg_1:OSGi):void;

    }
}
