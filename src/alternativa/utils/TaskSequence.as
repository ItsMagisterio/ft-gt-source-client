﻿package alternativa.utils
{
    import flash.events.EventDispatcher;
    import __AS3__.vec.Vector;
    import flash.events.Event;
    import __AS3__.vec.*;

    public class TaskSequence extends EventDispatcher
    {

        private var tasks:Vector.<Task>;
        private var currentTask:int;

        public function TaskSequence()
        {
            this.tasks = new Vector.<Task>();
        }
        public function addTask(task:Task):void
        {
            if (this.tasks.indexOf(task) < 0)
            {
                this.tasks.push(task);
                task.taskSequence = this;
            }
        }
        public function run():void
        {
            if (this.tasks.length > 0)
            {
                this.currentTask = 0;
                this.runCurrentTask();
            }
            else
            {
                dispatchEvent(new Event(Event.COMPLETE));
            }
        }
        private function runCurrentTask():void
        {
            this.tasks[this.currentTask].run();
        }
        public function taskComplete(task:Task):void
        {
            if (++this.currentTask < this.tasks.length)
            {
                this.runCurrentTask();
            }
            else
            {
                dispatchEvent(new Event(Event.COMPLETE));
            }
        }

    }
}
