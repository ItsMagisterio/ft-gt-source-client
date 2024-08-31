package alternativa.tanks.model.payment
{
    import projects.tanks.client.panel.model.payment.PaymentModelBase;
    import projects.tanks.client.panel.model.payment.IPaymentModelBase;
    import alternativa.model.IObjectLoadListener;
    import alternativa.object.ClientObject;
    import alternativa.model.IModel;
    import alternativa.init.Main;
    import alternativa.service.IModelService;
    import __AS3__.vec.Vector;
    import alternativa.osgi.service.storage.IStorageService;
    import flash.net.SharedObject;

    public class PaymentModel extends PaymentModelBase implements IPaymentModelBase, IObjectLoadListener, IPayment
    {

        private var clientObject:ClientObject;
        private var _accountId:String;
        private var _projectId:int;
        private var _formId:String;
        private var _currentLocaleCurrency:String;

        public function PaymentModel()
        {
            _interfaces.push(IModel);
            _interfaces.push(IPayment);
            _interfaces.push(IPaymentModelBase);
            _interfaces.push(IObjectLoadListener);
        }
        public function objectLoaded(object:ClientObject):void
        {
            this.clientObject = object;
        }
        public function objectUnloaded(object:ClientObject):void
        {
            this.clientObject = null;
        }
        public function setInitData(clientObject:ClientObject, counries:Array, rates:Array, accountId:String, projectId:int, formId:String, currentLocaleCurrency:String):void
        {
            var i:int;
            this._accountId = accountId;
            this._projectId = projectId;
            this._formId = formId;
            this._currentLocaleCurrency = currentLocaleCurrency;
            var modelRegister:IModelService = (Main.osgi.getService(IModelService) as IModelService);
            var listeners:Vector.<IModel> = modelRegister.getModelsByInterface(IPaymentListener);
            if (listeners != null)
            {
                i = 0;
                while (i < listeners.length)
                {
                    (listeners[i] as IPaymentListener).setInitData(counries, rates, accountId, projectId, formId);
                    i++;
                }
            }
        }
        public function setOperators(clientObject:ClientObject, countryId:String, operators:Array):void
        {
            var i:int;
            var modelRegister:IModelService = (Main.osgi.getService(IModelService) as IModelService);
            var listeners:Vector.<IModel> = modelRegister.getModelsByInterface(IPaymentListener);
            if (listeners != null)
            {
                i = 0;
                while (i < listeners.length)
                {
                    (listeners[i] as IPaymentListener).setOperators(countryId, operators);
                    i++;
                }
            }
        }
        public function setNumbers(clientObject:ClientObject, operatorId:int, smsNumbers:Array):void
        {
            var i:int;
            var modelRegister:IModelService = (Main.osgi.getService(IModelService) as IModelService);
            var listeners:Vector.<IModel> = modelRegister.getModelsByInterface(IPaymentListener);
            if (listeners != null)
            {
                i = 0;
                while (i < listeners.length)
                {
                    (listeners[i] as IPaymentListener).setNumbers(operatorId, smsNumbers);
                    i++;
                }
            }
        }
        public function getData():void
        {
        }
        public function getOperatorsList(countryId:String):void
        {
        }
        public function getNumbersList(operatorId:int):void
        {
            var storage:SharedObject = IStorageService(Main.osgi.getService(IStorageService)).getStorage();
            storage.data.userOperator = operatorId;
        }
        public function get currentLocaleCurrency():String
        {
            return (this._currentLocaleCurrency);
        }
        public function get accountId():String
        {
            return (this._accountId);
        }
        public function get projectId():int
        {
            return (this._projectId);
        }
        public function get formId():String
        {
            return (this._formId);
        }

    }
}
