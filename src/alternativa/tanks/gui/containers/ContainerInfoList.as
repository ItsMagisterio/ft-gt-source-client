package alternativa.tanks.gui.containers
{

    import flash.display.Sprite;
    import fl.containers.ScrollPane;
    import assets.scroller.color.ScrollTrackGreen;
    import assets.scroller.color.ScrollThumbSkinGreen;
    import fl.controls.ScrollPolicy;
    import flash.events.MouseEvent;
    import flash.ui.Mouse;
    import flash.system.Capabilities;
    import fl.controls.TileList;
    import fl.controls.ScrollBarDirection;
    import alternativa.tanks.model.gift.GiftRollerRenderer;
    import fl.data.DataProvider;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import alternativa.resource.ImageResource;
    import flash.display.Bitmap;
    import controls.Label;
    import flash.filters.GlowFilter;
    import alternativa.tanks.model.gift.icons.ItemGiftBackgrounds;
    import assets.icons.InputCheckIcon;
    import forms.RegisterForm;
    import flash.net.URLRequest;
    import flash.net.URLLoader;
    import flash.events.Event;
    import logic.networking.INetworker;
    import alternativa.init.Main;
    import logic.networking.Network;
    import forms.events.ContainerWindowEvent;
    public class ContainerInfoList extends Sprite
    {
        public var scrollPane:ScrollPane;
        private var scrollContainer:Sprite;
        private var mainContainer:Sprite;
        private var itemList:ItemList;
        private var jsonString:String;
        private var isDragging:Boolean = false;
        private var lastMouseX:Number;
        public function ContainerInfoList(containerId:String, w:Number, h:Number)
        {
            this.scrollPane = new ScrollPane();
            this.itemList = new ItemList();
            this.confScroll();
            this.scrollPane.horizontalScrollPolicy = ScrollPolicy.AUTO;
            this.scrollPane.verticalScrollPolicy = ScrollPolicy.OFF;
            this.scrollPane.focusEnabled = false;
            this.scrollPane.setSize(w, h);
            this.scrollContainer = new Sprite();
            this.mainContainer = new Sprite();

            this.scrollContainer.addChild(this.mainContainer);
            this.scrollPane.source = this.scrollContainer;
            addChild(this.scrollPane);
            this.scrollPane.update();
            this.scrollPane.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
            this.scrollPane.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            this.scrollPane.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            this.scrollPane.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            var lobby:Lobby = Main.osgi.getService(ILobby) as Lobby;
            lobby.addEventListener(ContainerWindowEvent.ON_OPEN_CONTAINER_WINDOW_DATA, this.onContainerWindowOpenData);
            Network(Main.osgi.getService(INetworker)).send("garage;open_container_window;" + containerId);
        }
        private function onContainerWindowOpenData(event:ContainerWindowEvent):void
        {
            var lobby:Lobby = Main.osgi.getService(ILobby) as Lobby;
            lobby.removeEventListener(ContainerWindowEvent.ON_OPEN_CONTAINER_WINDOW_DATA, this.onContainerWindowOpenData);
            var jsonData:Array = JSON.parse(event.data) as Array;
            this.itemList.generateItemList(this.mainContainer, jsonData, this.scrollPane);
        }

        private function onMouseDown(e:MouseEvent):void
        {
            this.isDragging = true;
            this.lastMouseX = e.stageX;
        }

        private function onMouseMove(e:MouseEvent):void
        {
            if (this.isDragging)
            {
                var deltaX:Number = e.stageX - this.lastMouseX;
                this.scrollPane.horizontalScrollPosition -= deltaX;
                this.lastMouseX = e.stageX;
            }
        }

        private function onMouseUp(e:MouseEvent):void
        {
            this.isDragging = false;
        }

        private function onMouseWheel(e:MouseEvent):void
        {
            this.scrollPane.horizontalScrollPosition -= e.delta * 3;
        }

        private function confScroll():void
        {
            this.scrollPane.setStyle("downArrowUpSkin", ScrollArrowDownGreen);
            this.scrollPane.setStyle("downArrowDownSkin", ScrollArrowDownGreen);
            this.scrollPane.setStyle("downArrowOverSkin", ScrollArrowDownGreen);
            this.scrollPane.setStyle("downArrowDisabledSkin", ScrollArrowDownGreen);
            this.scrollPane.setStyle("upArrowUpSkin", ScrollArrowUpGreen);
            this.scrollPane.setStyle("upArrowDownSkin", ScrollArrowUpGreen);
            this.scrollPane.setStyle("upArrowOverSkin", ScrollArrowUpGreen);
            this.scrollPane.setStyle("upArrowDisabledSkin", ScrollArrowUpGreen);
            this.scrollPane.setStyle("trackUpSkin", ScrollTrackGreen);
            this.scrollPane.setStyle("trackDownSkin", ScrollTrackGreen);
            this.scrollPane.setStyle("trackOverSkin", ScrollTrackGreen);
            this.scrollPane.setStyle("trackDisabledSkin", ScrollTrackGreen);
            this.scrollPane.setStyle("thumbUpSkin", ScrollThumbSkinGreen);
            this.scrollPane.setStyle("thumbDownSkin", ScrollThumbSkinGreen);
            this.scrollPane.setStyle("thumbOverSkin", ScrollThumbSkinGreen);
            this.scrollPane.setStyle("thumbDisabledSkin", ScrollThumbSkinGreen);
        }

    }
}
