package alternativa.tanks.display.usertitle.addition
{
    import flash.display.Sprite;
    import controls.TankWindow;

    public class DebugTitle extends Sprite
    {

        private var window:TankWindow = new TankWindow();

        public function DebugTitle()
        {
            this.window.width = 100;
            this.window.header = 70;
            addChild(this.window);
        }
    }
}
