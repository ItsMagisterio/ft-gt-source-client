package alternativa.tanks.model.referals
{
    import projects.tanks.client.panel.model.referals.ReferalsModelBase;
    import projects.tanks.client.panel.model.referals.IReferalsModelBase;
    import alternativa.model.IObjectLoadListener;
    import alternativa.object.ClientObject;
    import alternativa.service.IModelService;
    import alternativa.model.IModel;
    import alternativa.init.Main;
    import alternativa.tanks.model.panel.IPanel;
    import projects.tanks.client.panel.model.referals.RefererIncomeData;
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class ReferalsModel extends ReferalsModelBase implements IReferalsModelBase, IObjectLoadListener, IReferals
    {

        private var clientObject:ClientObject;
        private var referals:Array;
        private var modelRegister:IModelService;

        public function ReferalsModel()
        {
            _interfaces.push(IModel);
            _interfaces.push(IReferalsModelBase);
            _interfaces.push(IObjectLoadListener);
            _interfaces.push(IReferals);
            this.modelRegister = (Main.osgi.getService(IModelService) as IModelService);
        }
        public function initObject(object:ClientObject, magicString:String):void
        {
            this.clientObject = object;
            Main.writeVarsToConsoleChannel("REFERALS MODEL", "initObject   magicString: %1", magicString);
        }
        public function objectLoaded(object:ClientObject):void
        {
            Main.writeVarsToConsoleChannel("REFERALS MODEL", "objectLoaded");
            this.clientObject = object;
            Main.writeVarsToConsoleChannel("REFERALS MODEL", "   clientObject: %1", this.clientObject);
        }
        public function objectUnloaded(object:ClientObject):void
        {
            Main.writeVarsToConsoleChannel("REFERALS MODEL", "objectUnloaded");
            this.clientObject = null;
        }
        public function inviteSentSuccessfuly(clientObject:ClientObject, sentSuccessfuly:Boolean, errorMessage:String):void
        {
            var panelModel:IPanel = ((this.modelRegister.getModelsByInterface(IPanel) as Vector.<IModel>)[0] as IPanel);
            panelModel.setInviteSendResult(sentSuccessfuly, errorMessage);
        }
        public function setRefererIncomeData(clientObject:ClientObject, data:Array):void
        {
            var incomeData:RefererIncomeData;
            var listeners:Vector.<IModel>;
            var i:int;
            this.referals = data;
            for each (incomeData in data)
            {
                Main.writeVarsToConsoleChannel("REFERALS MODEL", ((((("rank: " + incomeData.rank) + " callsign: ") + incomeData.callsign) + " income: ") + incomeData.income));
            }
            listeners = (this.modelRegister.getModelsByInterface(IReferalsListener) as Vector.<IModel>);
            if (listeners != null)
            {
                i = 0;
                while (i < listeners.length)
                {
                    (listeners[i] as IReferalsListener).updateReferalsData(data);
                    i++;
                }
            }
        }
        public function getReferalsData():void
        {
            Main.writeVarsToConsoleChannel("REFERALS MODEL", "getReferalsData   clientObject: %1", this.clientObject);
        }

    }
}
