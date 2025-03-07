﻿package alternativa.tanks.models.weapon.weakening
{
    import com.alternativaplatform.projects.tanks.client.warfare.models.tankparts.weapon.weakening.WeaponWeakeningModelBase;
    import com.alternativaplatform.projects.tanks.client.warfare.models.tankparts.weapon.weakening.IWeaponWeakeningModelBase;
    import alternativa.model.IModel;
    import alternativa.object.ClientObject;

    public class WeaponWeakeningModel extends WeaponWeakeningModelBase implements IWeaponWeakeningModelBase, IWeaponWeakeningModel
    {

        public function WeaponWeakeningModel()
        {
            _interfaces.push(IModel, IWeaponWeakeningModelBase, IWeaponWeakeningModel);
        }
        public function initObject(clientObject:ClientObject, maximumDamageRadius:Number, minimumDamagePercent:Number, minimumDamageRadius:Number):void
        {
            var data:WeaponWeakeningData = new WeaponWeakeningData();
            data.maximumDamageRadius = ((isNaN(maximumDamageRadius)) ? 0 : maximumDamageRadius);
            data.minimumDamageRadius = ((isNaN(minimumDamageRadius)) ? 1 : minimumDamageRadius);
            data.minimumDamagePercent = ((isNaN(minimumDamagePercent)) ? 0 : minimumDamagePercent);
            data.falloffInterval = (data.minimumDamageRadius - data.maximumDamageRadius);
            if (data.minimumDamagePercent > 100)
            {
                data.minimumDamagePercent = 100;
            }
            clientObject.putParams(WeaponWeakeningModel, data);
        }
        public function getImpactCoeff(clientObject:ClientObject, distance:Number):Number
        {
            var data:WeaponWeakeningData = (clientObject.getParams(WeaponWeakeningModel) as WeaponWeakeningData);
            if (data.falloffInterval <= 0)
            {
                return (1);
            }
            if (distance <= data.maximumDamageRadius)
            {
                return (1);
            }
            if (distance >= data.minimumDamageRadius)
            {
                return (0.01 * data.minimumDamagePercent);
            }
            return (0.01 * (data.minimumDamagePercent + (((data.minimumDamageRadius - distance) * (100 - data.minimumDamagePercent)) / data.falloffInterval)));
        }
        public function getFullDamageRadius(clientObject:ClientObject):Number
        {
            var weaponWeakeningData:WeaponWeakeningData = WeaponWeakeningData(clientObject.getParams(WeaponWeakeningModel));
            return weaponWeakeningData.maximumDamageRadius * 100;
        }

    }
}
