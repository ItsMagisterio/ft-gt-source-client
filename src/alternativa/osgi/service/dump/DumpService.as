﻿package alternativa.osgi.service.dump
{
    import alternativa.init.OSGi;
    import flash.utils.Dictionary;
    import __AS3__.vec.Vector;
    import alternativa.osgi.service.dump.dumper.IDumper;
    import __AS3__.vec.*;

    public class DumpService implements IDumpService
    {

        private var osgi:OSGi;
        private var _dumpers:Dictionary;
        private var _dumpersList:Vector.<IDumper>;

        public function DumpService(osgi:OSGi)
        {
            this.osgi = osgi;
            this._dumpers = new Dictionary(false);
            this._dumpersList = new Vector.<IDumper>();
        }
        public function registerDumper(dumper:IDumper):void
        {
            if (this._dumpers[dumper.dumperName] == null)
            {
                this._dumpers[dumper.dumperName] = dumper;
                this._dumpersList.push(dumper);
            }
            else
            {
                trace((('Dumper "' + dumper.dumperName) + '" already registered!'));
            }
        }
        public function unregisterDumper(dumperName:String):void
        {
            this._dumpersList.splice(this._dumpersList.indexOf(this._dumpers[dumperName]), 1);
            delete this._dumpers[dumperName];
        }
        public function dump(params:Vector.<String>):String
        {
            var message:String;
            var dumper:IDumper;
            var index:int;
            var i:int;
            if (params.length > 0)
            {
                if (String(params[0]).match(/^\d+$/) != null)
                {
                    index = (int(params[0]) - 1);
                    if (this._dumpersList[index] != null)
                    {
                        dumper = IDumper(this._dumpersList[index]);
                        message = dumper.dump(params);
                    }
                    else
                    {
                        message = (("Dumper number " + (index + 1).toString()) + " not founded");
                    }
                }
                else
                {
                    if (this._dumpers[params[0]] != null)
                    {
                        dumper = IDumper(this._dumpers[params.shift()]);
                        message = dumper.dump(params);
                    }
                    else
                    {
                        message = (("Dumper with name '" + params[0]) + "' not founded");
                    }
                }
            }
            else
            {
                message = "\n";
                i = 0;
                while (i < this._dumpersList.length)
                {
                    message = (message + (((("   dumper " + (i + 1).toString()) + ": ") + IDumper(this._dumpersList[i]).dumperName) + "\n"));
                    i++;
                }
                message = (message + "\n");
            }
            return (message);
        }
        public function get dumpers():Dictionary
        {
            return (this._dumpers);
        }
        public function get dumpersList():Vector.<IDumper>
        {
            return (this._dumpersList);
        }

    }
}
