package alternativa.resource.factory
{
    import alternativa.resource.SoundResource;
    import alternativa.resource.Resource;

    public class SoundResourceFactory implements IResourceFactory
    {

        public function createResource(resourceType:int):Resource
        {
            return (new SoundResource());
        }

    }
}
