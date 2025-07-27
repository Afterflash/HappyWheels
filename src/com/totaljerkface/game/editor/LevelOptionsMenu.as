package com.totaljerkface.game.editor
{
    import com.totaljerkface.game.editor.ui.LevelOptionsColorInput;
    import com.totaljerkface.game.editor.ui.ValueEvent;
    import com.totaljerkface.game.editor.ui.Window;
    import com.totaljerkface.game.menus.DropMenu;
    import flash.display.Sprite;
    import flash.events.Event;

    [Embed(source="/_assets/assets.swf", symbol="symbol787")]
    public class LevelOptionsMenu extends Sprite
    {
        private static var windowX:Number = 30;

        private static var windowY:Number = 250;

        private var backdropDrop:DropMenu;

        private var backgroundColorInput:LevelOptionsColorInput;

        private var _window:Window;

        public function LevelOptionsMenu()
        {
            super();
            this.init();
        }

        public function init():void
        {
            var _loc1_:Array = ["blank", "green hills", "city"];
            var _loc2_:Array = [0, 1, 2];
            this.backdropDrop = new DropMenu("level backdrop:", _loc1_, _loc2_, Canvas.backDropIndex, 16777215);
            addChild(this.backdropDrop);
            this.backdropDrop.xLeft = 20;
            this.backdropDrop.y = 15;
            this.backdropDrop.addEventListener(DropMenu.ITEM_SELECTED, this.bdSelected);
            this.backgroundColorInput = new LevelOptionsColorInput("background color", "backgroundColor", true, true);
            addChildAt(this.backgroundColorInput, getChildIndex(this.backdropDrop));
            this.backgroundColorInput.x = 20;
            this.backgroundColorInput.y = this.backdropDrop.y + this.backdropDrop.height + 3;
            this.backgroundColorInput.setValue(Canvas.backgroundColor);
            this.backgroundColorInput.addEventListener(ValueEvent.VALUE_CHANGE, this.handleColorSelected);
            this.buildWindow();
            this._window.resize();
        }

        private function handleColorSelected(param1:Event):void
        {
            if (Canvas.backgroundColor == this.backgroundColorInput.color)
            {
                return;
            }
            if (this.backgroundColorInput.color == -1 || this.backgroundColorInput.color == 16777215)
            {
                Canvas.backgroundColor = this.backgroundColorInput.color = 16777215;
            }
            else
            {
                this.backdropDrop.currentIndex = Canvas.backDropIndex = 0;
                Canvas.backgroundColor = this.backgroundColorInput.color;
            }
        }

        private function bdSelected(param1:Event):void
        {
            this.backgroundColorInput.color = Canvas.backgroundColor = 16777215;
            Canvas.backDropIndex = this.backdropDrop.currentIndex;
        }

        private function buildWindow():void
        {
            this._window = new Window(true, this, true);
            this._window.x = windowX;
            this._window.y = windowY;
            this._window.addEventListener(Window.WINDOW_CLOSED, this.windowClosed);
        }

        public function get window():Window
        {
            return this._window;
        }

        private function windowClosed(param1:Event):void
        {
            dispatchEvent(param1.clone());
        }

        public function die():void
        {
            this._window.removeEventListener(Window.WINDOW_CLOSED, this.windowClosed);
            this._window.closeWindow();
            this.backdropDrop.removeEventListener(DropMenu.ITEM_SELECTED, this.bdSelected);
            this.backdropDrop.die();
            this.backgroundColorInput.removeEventListener(ValueEvent.VALUE_CHANGE, this.handleColorSelected);
            this.backgroundColorInput.die();
        }
    }
}
