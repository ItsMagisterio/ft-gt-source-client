package alternativa.tanks.model.user
{

    public class UserData implements IUserData
    {

        private var id:Number;
        private var name:String;
        private var rank:int;
        private var email:String;
        private var isPremium:Boolean;
        private var _isMailConfirmed:Boolean;

        private var listeners:Vector.<IUserDataListener> = new Vector.<IUserDataListener>();

        public function UserData(id:Number, name:String, rank:int, email:String, isMailConfirmed:Boolean, isPremium:Boolean = false)
        {
            this.id = id;
            this.name = name;
            this.rank = rank;
            this.email = email;
            this.isPremium = isPremium;
            this._isMailConfirmed = isMailConfirmed;
        }

        public function get userId():Number
        {
            return this.id;
        }

        public function getuserId():Number
        {
            return this.id;
        }

        public function get userName():String
        {
            return this.name;
        }

        public function get userRank():Number
        {
            return this.rank;
        }

        public function get userEmail():String
        {
            return this.email;
        }

        public function get hasPremium():Boolean
        {
            return this.isPremium;
        }

        public function get isMailConfirmed():Boolean
        {
            return this._isMailConfirmed;
        }

        public function set isMailConfirmed(value:Boolean):void
        {
            this._isMailConfirmed = value;
        }
        public function set mail(value:String):void
        {
            this.email = value;
        }

        public function addListener(listener:IUserDataListener):void
        {
            this.listeners.push(listener);
        }

        public function removeListener(listener:IUserDataListener):void
        {
            var index:int = this.listeners.indexOf(listener);
            if (index != -1)
            {
                this.listeners.splice(index, 1);
            }
        }

        public function dispatchUserDataChanged():void
        {
            for each (var listener:IUserDataListener in this.listeners)
            {
                listener.userDataChanged(this);
            }
        }
    }
}
