package alternativa.tanks.models.battlefield.gui.chat.cmdhandlers
{
    import alternativa.tanks.models.battlefield.gui.chat.BattleChatOutput;
    import forms.LobbyChat;
    import alternativa.osgi.service.locale.ILocaleService;
    import alternativa.init.Main;
    import alternativa.tanks.locale.constants.TextConst;

    public class UnblockCommandHandler implements IChatCommandHandler
    {

        private var output:BattleChatOutput;

        public function UnblockCommandHandler(output:BattleChatOutput)
        {
            this.output = output;
        }
        public function handleCommand(args:Array):Boolean
        {
            if (args.length == 0)
            {
                return (false);
            }
            var userName:String = args[0];
            LobbyChat.unblockUser(userName);
            var localeService:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
            this.output.addSystemMessage(localeService.getText(TextConst.CHAT_PANEL_COMMAND_UNBLOCK, userName));
            return (true);
        }

    }
}
