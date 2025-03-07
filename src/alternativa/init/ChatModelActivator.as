﻿package alternativa.init
{
    import alternativa.osgi.bundle.IBundleActivator;
    import alternativa.tanks.model.ChatModel;
    import alternativa.service.IModelService;
    import alternativa.tanks.services.NewsService;
    import alternativa.tanks.services.NewsServiceImpl;
    import com.alternativaplatform.client.models.core.community.chat.IChatModelBase;

    public class ChatModelActivator implements IBundleActivator
    {

        public static var osgi:OSGi;

        public var chatModel:ChatModel;

        public function start(osgi:OSGi):void
        {
            ChatModelActivator.osgi = osgi;
            Main.writeToConsole("ChatModel init");
            var modelRegister:IModelService = (osgi.getService(IModelService) as IModelService);
            this.chatModel = new ChatModel();
            osgi.registerService(IChatModelBase, this.chatModel);
            osgi.registerService(NewsService, new NewsServiceImpl());
            modelRegister.add(this.chatModel);
        }
        public function stop(osgi:OSGi):void
        {
            var modelRegister:IModelService = (osgi.getService(IModelService) as IModelService);
            modelRegister.remove(this.chatModel.id);
            this.chatModel = null;
            ChatModelActivator.osgi = null;
        }

    }
}
