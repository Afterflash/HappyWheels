package com.totaljerkface.game.menus
{
    import com.totaljerkface.game.editor.ui.GenericButton;
    import com.totaljerkface.game.editor.ui.Window;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.text.TextField;

    [Embed(source="/_assets/assets.swf", symbol="symbol2996")]
    public class LoadLevelMenu extends Sprite
    {
        public static const REPLAY:String = "replay";

        public static const LEVEL:String = "level";

        public static const LOAD:String = "load";

        public static const CANCEL:String = "cancel";

        private static var index:int = 0;

        public var searchText:TextField;

        public var errorText:TextField;

        protected var _window:Window;

        protected var dropMenu:DropMenu;

        private var loadButton:GenericButton;

        private var cancelButton:GenericButton;

        public function LoadLevelMenu()
        {
            super();
            this.createWindow();
            this.dropMenu = new DropMenu("load:", ["level", "replay"], [LEVEL, REPLAY], index, 8947848);
            addChild(this.dropMenu);
            this.dropMenu.xLeft = 64;
            this.dropMenu.y = 35;
            this.loadButton = new GenericButton("load", 16613761, 70);
            addChild(this.loadButton);
            this.loadButton.x = 25;
            this.loadButton.y = 114;
            this.cancelButton = new GenericButton("cancel", 10066329, 70);
            addChild(this.cancelButton);
            this.cancelButton.x = 105;
            this.cancelButton.y = 114;
            addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            this.searchText.addEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler);
        }

        protected function createWindow():void
        {
            this._window = new Window(false, this, true);
        }

        public function get window():Window
        {
            return this._window;
        }

        public function get loadType():String
        {
            return this.dropMenu.value;
        }

        public function set loadID(param1:String):void
        {
            this.searchText.text = param1;
        }

        public function get loadID():String
        {
            return this.searchText.text;
        }

        private function keyDownHandler(param1:KeyboardEvent):void
        {
            this.errorText.text = "";
            if (param1.keyCode == 13)
            {
                this.ifValidLoad();
            }
        }

        private function ifValidLoad():void
        {
            this.errorText.text = "";
            var _loc1_:Boolean = true;
            var _loc2_:Array = this.searchText.text.split("=");
            if (_loc2_.length == 1)
            {
                if (isNaN(Number(this.searchText.text)))
                {
                    _loc1_ = false;
                }
                if (Number(this.searchText.text) < 1)
                {
                    _loc1_ = false;
                }
            }
            else if (this.searchText.text.indexOf("level_id") == -1 && this.searchText.text.indexOf("replay_id") == -1)
            {
                _loc1_ = false;
            }
            if (_loc1_)
            {
                dispatchEvent(new Event(LOAD));
            }
            else
            {
                this.errorText.text = "ID is invalid.";
            }
        }

        private function mouseUpHandler(param1:MouseEvent):void
        {
            switch (param1.target)
            {
                case this.loadButton:
                    this.ifValidLoad();
                    break;
                case this.cancelButton:
                    dispatchEvent(new Event(CANCEL));
            }
        }

        public function die():void
        {
            index = this.dropMenu.currentIndex;
            removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            this.searchText.removeEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler);
            this.dropMenu.die();
            this._window.closeWindow();
        }
    }
}
