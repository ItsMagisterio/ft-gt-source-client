package alternativa.tanks.models.sfx.colortransform
{
    import com.alternativaplatform.projects.tanks.client.warfare.models.colortransform.ColorTransformModelBase;
    import com.alternativaplatform.projects.tanks.client.warfare.models.colortransform.IColorTransformModelBase;
    import alternativa.model.IModel;
    import __AS3__.vec.Vector;
    import alternativa.object.ClientObject;
    import __AS3__.vec.*;

    public class ColorTransformModel extends ColorTransformModelBase implements IColorTransformModelBase, IColorTransformModel
    {

        public function ColorTransformModel()
        {
            _interfaces.push(IModel, IColorTransformModel);
        }
        public function initObject(clientObject:ClientObject, colorTransforms:Array):void
        {
            var numEntries:uint = colorTransforms.length;
            var entries:Vector.<ColorTransformEntry> = new Vector.<ColorTransformEntry>(numEntries);
            var i:int;
            while (i < numEntries)
            {
                entries[i] = new ColorTransformEntry(colorTransforms[i]);
                i++;
            }
            clientObject.putParams(ColorTransformModel, entries);
        }
        public function getModelData(clientObject:ClientObject):Vector.<ColorTransformEntry>
        {
            return (Vector.<ColorTransformEntry>(clientObject.getParams(ColorTransformModel)));
        }

    }
}
