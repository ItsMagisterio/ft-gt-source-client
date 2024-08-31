package alternativa.tanks.gui
{
    import forms.Alert;
    import controls.TankWindowHeader;
    import flash.events.Event;

    public class ExternalLinkAlert extends Alert
    {

        override protected function doLayout(e:Event):void
        {
            bgWindow.header = TankWindowHeader.ATTANTION;
            super.doLayout(e);
        }

    }
}
