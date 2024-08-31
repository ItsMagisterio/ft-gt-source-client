// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// alternativa.tanks.models.battlefield.BattlefieldMessages

package alternativa.tanks.models.battlefield
{
    import flash.display.Sprite;
    import __AS3__.vec.Vector;
    import flash.filters.GlowFilter;
    import __AS3__.vec.*;

    public class BattlefieldMessages extends Sprite
    {

        private var maxMessages:int;
        private var fontSize:int;
        private var verticalInterval:int;
        private var numMessages:int;
        private var messages:Vector.<Message> = new Vector.<Message>();
        private var numPooledMessages:int;
        private var messagePool:Vector.<Message> = new Vector.<Message>();

        public function BattlefieldMessages(maxMessages:int, fontSize:int, verticalInterval:int)
        {
            this.maxMessages = maxMessages;
            this.fontSize = fontSize;
            this.verticalInterval = verticalInterval;
            filters = [new GlowFilter(0, 1, 6, 6)];
        }

        public function addMessage(color:uint, text:String):void
        {
            if (this.numMessages == this.maxMessages)
            {
                this.removeMessage(0);
            }
            var message:Message = (this.messages[this.numMessages] = this.createMessage());
            addChild(message.label);
            message.label.color = color;
            message.label.text = text;
            message.label.x = (-0.5 * message.label.width);
            message.label.y = (this.verticalInterval * this.numMessages);
            this.numMessages++;
        }

        public function update(deltaMsec:uint):void
        {
            var message:Message;
            var i:int;
            while (i < this.numMessages)
            {
                message = this.messages[i];
                if (message.isDead)
                {
                    this.removeMessage(i);
                    i--;
                }
                else
                {
                    message.update(deltaMsec);
                }
                i++;
            }
        }

        private function removeMessage(index:int):void
        {
            var message:Message = this.messages[index];
            this.destroyMessage(message);
            var i:int = (index + 1);
            while (i < this.numMessages)
            {
                message = (this.messages[int((i - 1))] = this.messages[i]);
                message.label.y = (message.label.y - this.verticalInterval);
                i++;
            }
            this.numMessages--;
        }

        private function destroyMessage(message:Message):void
        {
            removeChild(message.label);
            var _local_2:* = this.numPooledMessages++;
            this.messagePool[_local_2] = message;
        }

        private function createMessage():Message
        {
            var message:Message;
            if (this.numPooledMessages == 0)
            {
                message = new Message(this.fontSize);
            }
            else
            {
                message = this.messagePool[-- this.numPooledMessages];
                this.messagePool[this.numPooledMessages] = null;
            }
            message.init();
            return (message);
        }

    }
} // package alternativa.tanks.models.battlefield

import controls.Label;
import __AS3__.vec.Vector;
import __AS3__.vec.*;

class Message
{

    private static const FLASH_TIME:int = 100;
    private static const FADE_TIME:int = 300;
    private static const LIFE_TIME1:int = 2000;
    private static const LIFE_TIME2:int = 5000;
    private static const ALPHA:Number = 0.6;

    public var label:Label = new Label();
    public var isDead:Boolean;
    private var states:Vector.<IMessageState>;
    private var currentStateIndex:int;

    public function Message(fontSize:int)
    {
        this.states = Vector.<IMessageState>([new StateAlpha(this, FLASH_TIME, 0, 1), new StateNormal(this, LIFE_TIME1), new StateAlpha(this, FADE_TIME, 1, ALPHA), new StateNormal(this, LIFE_TIME2), new StateAlpha(this, FADE_TIME, ALPHA, 0)]);
        this.label.size = fontSize;
        this.label.bold = true;
    }

    public function init():void
    {
        this.isDead = false;
        this.currentStateIndex = 0;
        this.states[0].init();
    }

    public function update(timeDelta:int):void
    {
        if (this.isDead)
        {
            return;
        }
        var state:IMessageState = this.states[this.currentStateIndex];
        if ((!(state.update(timeDelta))))
        {
            if (++this.currentStateIndex == this.states.length)
            {
                this.isDead = true;
            }
            else
            {
                this.states[this.currentStateIndex].init();
            }
        }
    }

}

interface IMessageState
{

    function init():void;
    function update(_arg_1:int):Boolean;

}

class StateNormal implements IMessageState
{

    private var message:Message;
    private var lifeTime:int;
    private var timeLeft:int;

    public function StateNormal(message:Message, lifeTime:int)
    {
        this.message = message;
        this.lifeTime = lifeTime;
    }

    public function init():void
    {
        this.timeLeft = this.lifeTime;
    }

    public function update(timeDelta:int):Boolean
    {
        if (this.timeLeft <= 0)
        {
            return (false);
        }
        this.timeLeft = (this.timeLeft - timeDelta);
        return (true);
    }

}

class StateAlpha implements IMessageState
{

    private var message:Message;
    private var transitionTime:int;
    private var timeLeft:int;
    private var alpha1:Number;
    private var alpha2:Number;
    private var deltaAlpha:Number;

    public function StateAlpha(message:Message, transitionTime:int, alpha1:Number, alpha2:Number)
    {
        this.message = message;
        this.transitionTime = transitionTime;
        this.alpha1 = alpha1;
        this.alpha2 = alpha2;
        this.deltaAlpha = (alpha2 - alpha1);
    }

    public function init():void
    {
        this.message.label.alpha = this.alpha1;
        this.timeLeft = this.transitionTime;
    }

    public function update(timeDelta:int):Boolean
    {
        if (this.timeLeft <= 0)
        {
            return (false);
        }
        this.timeLeft = (this.timeLeft - timeDelta);
        if (this.timeLeft < 0)
        {
            this.timeLeft = 0;
        }
        this.message.label.alpha = (this.alpha2 - ((this.deltaAlpha * this.timeLeft) / this.transitionTime));
        return (true);
    }

}
