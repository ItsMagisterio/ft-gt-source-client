package alternativa.protocol.codec
{
    import alternativa.protocol.factory.ICodecFactory;
    import flash.utils.ByteArray;
    import alternativa.protocol.type.Byte;
    import alternativa.network.command.ControlCommand;
    import alternativa.resource.ResourceInfo;
    import alternativa.types.Long;
    import alternativa.register.ClassInfo;
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;

    public class ControlRootCodec extends AbstractCodec
    {

        private var codecFactory:ICodecFactory;

        public function ControlRootCodec(codecFactory:ICodecFactory)
        {
            this.codecFactory = codecFactory;
        }
        override protected function doDecode(reader:IDataInput, nullmap:NullMap, notnull:Boolean):Object
        {
            var hash:ByteArray;
            var arrayCodec:ICodec;
            var idArrayCodec:ICodec;
            var resourceArrayCodec:ICodec;
            var i:int;
            var commands:Array = new Array();
            var params:Array = new Array();
            var commandId:int = int(this.codecFactory.getCodec(Byte).decode(reader, nullmap, true));
            switch (commandId)
            {
                case ControlCommand.HASH_RESPONCE:
                    hash = new ByteArray();
                    i = 0;
                    while (i < 32)
                    {
                        hash.writeByte(int(this.codecFactory.getCodec(Byte).decode(reader, nullmap, true)));
                        i++;
                    }
                    hash.position = 0;
                    commands.push(hash);
                    break;
                case ControlCommand.OPEN_SPACE:
                    commands.push(new ControlCommand(ControlCommand.OPEN_SPACE, "openSpace", new Array()));
                    break;
                case ControlCommand.LOAD_RESOURCES:
                    params.push(int(this.codecFactory.getCodec(int).decode(reader, nullmap, true)));
                    arrayCodec = this.codecFactory.getArrayCodec(ResourceInfo, true, 2);
                    params.push((arrayCodec.decode(reader, nullmap, true) as Array));
                    commands.push(new ControlCommand(ControlCommand.LOAD_RESOURCES, "loadResources", params));
                    break;
                case ControlCommand.UNLOAD_CLASSES_AND_RESOURCES:
                    idArrayCodec = this.codecFactory.getArrayCodec(Long, true, 1);
                    resourceArrayCodec = this.codecFactory.getArrayCodec(ResourceInfo, true, 1);
                    params.push((idArrayCodec.decode(reader, nullmap, true) as Array));
                    params.push((resourceArrayCodec.decode(reader, nullmap, true) as Array));
                    commands.push(new ControlCommand(ControlCommand.UNLOAD_CLASSES_AND_RESOURCES, "unloadClassesAndResources", params));
                    break;
                case ControlCommand.COMMAND_REQUEST:
                    params.push(String(this.codecFactory.getCodec(String).decode(reader, nullmap, true)));
                    commands.push(new ControlCommand(ControlCommand.COMMAND_REQUEST, "commandRequest", params));
                    break;
                case ControlCommand.SERVER_MESSAGE:
                    params.push(int(this.codecFactory.getCodec(int).decode(reader, nullmap, true)));
                    params.push(String(this.codecFactory.getCodec(String).decode(reader, nullmap, true)));
                    commands.push(new ControlCommand(ControlCommand.SERVER_MESSAGE, "serverMessage", params));
                    break;
                case ControlCommand.LOAD_CLASSES:
                    params.push(int(this.codecFactory.getCodec(int).decode(reader, nullmap, true)));
                    arrayCodec = this.codecFactory.getArrayCodec(ClassInfo, false);
                    params.push(arrayCodec.decode(reader, nullmap, true));
                    params.push(reader);
                    params.push(nullmap);
                    commands.push(new ControlCommand(ControlCommand.LOAD_CLASSES, "loadClasses", params));
            }
            return (commands);
        }
        override protected function doEncode(dest:IDataOutput, object:Object, nullmap:NullMap, notnull:Boolean):void
        {
            var c:ControlCommand = ControlCommand(object);
            var byteCodec:ICodec = this.codecFactory.getCodec(Byte);
            byteCodec.encode(dest, c.id, nullmap, true);
            switch (c.id)
            {
                case ControlCommand.HASH_REQUEST:
                    break;
                case ControlCommand.HASH_ACCEPT:
                    break;
                case ControlCommand.RESOURCES_LOADED:
                    this.codecFactory.getCodec(int).encode(dest, int(c.params[0]), nullmap, true);
                    break;
                case ControlCommand.LOG:
                    this.codecFactory.getCodec(int).encode(dest, int(c.params[0]), nullmap, true);
                    this.codecFactory.getCodec(String).encode(dest, String(c.params[1]), nullmap, true);
                    break;
                case ControlCommand.COMMAND_RESPONCE:
                    this.codecFactory.getCodec(String).encode(dest, String(c.params[0]), nullmap, true);
                    break;
                case ControlCommand.CLASSES_LOADED:
                    this.codecFactory.getCodec(int).encode(dest, int(c.params[0]), nullmap, true);
            }
        }

    }
}
