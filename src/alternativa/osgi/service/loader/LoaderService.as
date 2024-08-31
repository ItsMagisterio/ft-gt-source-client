package alternativa.osgi.service.loader
{
    public class LoaderService implements ILoaderService
    {

        private var _loadingProgress:LoadingProgress;

        public function LoaderService()
        {
            this._loadingProgress = new LoadingProgress();
        }
        public function get loadingProgress():LoadingProgress
        {
            return (this._loadingProgress);
        }

    }
}
