package com.totaljerkface.game.menus
{
    import com.totaljerkface.game.Settings;
    import com.totaljerkface.game.editor.ui.*;
    import com.totaljerkface.game.events.*;
    import flash.display.*;
    import flash.events.*;

    [Embed(source="/_assets/assets.swf", symbol="symbol496")]
    public class ControlsMenu extends BasicMenu
    {
        public var customizeControlsButton:LibraryButton;

        public var message:Sprite;

        private var keys:Array = ["accelerate", "decelerate", "leanForward", "leanBack", "primaryAction", "secondaryAction1", "secondaryAction2", "eject", "switchCamera"];

        public function ControlsMenu()
        {
            super();
            addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            var _loc1_:Boolean = true;
            var _loc2_:Number = 0;
            while (_loc2_ < this.keys.length)
            {
                if (Settings[this.keys[_loc2_] + "DefaultCode"] != Settings[this.keys[_loc2_] + "Code"])
                {
                    trace(this.keys[_loc2_] + " is not the default");
                    _loc1_ = false;
                    break;
                }
                _loc2_++;
            }
            trace("hi");
            this.message.visible = _loc1_ ? false : true;
        }

        private function mouseUpHandler(param1:MouseEvent):void
        {
            switch (param1.target)
            {
                case this.customizeControlsButton:
                    dispatchEvent(new NavigationEvent(NavigationEvent.CUSTOMIZE_CONTROLS));
            }
        }

        override public function die():void
        {
            super.die();
            removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
        }
    }
}
