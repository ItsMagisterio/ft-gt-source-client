package alternativa.utils
{
    import flash.utils.ByteArray;
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class TARAParser
    {

        public static function parse(data:ByteArray):ByteArrayMap
        {
            var i:int;
            var fileData:ByteArray;
            var fileInfo:FileInfo;
            var numFiles:int = data.readInt();
            var files:Vector.<FileInfo> = new Vector.<FileInfo>(numFiles, true);
            i = 0;
            while (i < numFiles)
            {
                files[i] = new FileInfo(data.readUTF(), data.readInt());
                i++;
            }
            var table:ByteArrayMap = new ByteArrayMap();
            i = 0;
            while (i < numFiles)
            {
                fileData = new ByteArray();
                fileInfo = files[i];
                data.readBytes(fileData, 0, fileInfo.size);
                table.putValue(fileInfo.name, fileData);
                i++;
            }
            fileData = null;
            fileInfo = null;
            files = null;
            return (table);
        }

    }
}

class FileInfo
{

    public var name:String;
    public var size:int;

    public function FileInfo(name:String, size:int)
    {
        this.name = name;
        this.size = size;
    }
}
