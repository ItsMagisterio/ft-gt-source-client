package com.alternativaplatform.projects.tanks.client.warfare.models.common.longterm
{
    import alternativa.object.ClientObject;
    import alternativa.types.Long;

    public interface ILongTermBonusModelBase
    {

        function effectStart(_arg_1:ClientObject, _arg_2:Long, _arg_3:int):void;
        function effectStop(_arg_1:ClientObject, _arg_2:Long):void;

    }
}
