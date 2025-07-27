package com.totaljerkface.game.editor.specials
{
    import com.totaljerkface.game.Settings;
    import com.totaljerkface.game.editor.*;
    import flash.display.*;

    [Embed(source="/_assets/assets.swf", symbol="symbol991")]
    public class StartPlaceHolder extends RefSprite
    {
        public var mc:MovieClip;

        private var minIndex:int = 1;

        private var maxIndex:int = Settings.totalCharacters;

        private var _characterIndex:int = 1;

        private var _forceChar:Boolean;

        private var _hideVehicle:Boolean = false;

        public function StartPlaceHolder()
        {
            super();
            this.maxIndex = Settings.totalCharacters;
            name = "main character";
            deletable = false;
            cloneable = false;
            rotatable = false;
            scalable = false;
            this.mc.gotoAndStop(1);
        }

        override public function setAttributes():void
        {
            _attributes = ["x", "y", "characterIndex", "forceChar", "hideVehicle"];
        }

        public function get characterIndex():int
        {
            return this._characterIndex;
        }

        public function set characterIndex(param1:int):void
        {
            if (param1 < this.minIndex)
            {
                param1 = this.minIndex;
            }
            if (param1 > this.maxIndex)
            {
                param1 = this.maxIndex;
            }
            trace("character index value: " + param1);
            this._characterIndex = param1;
            this.mc.gotoAndStop(param1);
            var _loc2_:Sprite = this.mc.vehicle;
            this.mc.vehicle.visible = this._hideVehicle ? false : true;
            if (_selected)
            {
                drawBoundingBox();
            }
            x = x;
            y = y;
        }

        public function get hideVehicle():Boolean
        {
            return this._hideVehicle;
        }

        public function set hideVehicle(param1:Boolean):void
        {
            this._hideVehicle = param1;
            this.mc.vehicle.visible = this._hideVehicle ? false : true;
            if (_selected)
            {
                drawBoundingBox();
            }
        }

        public function get forceChar():Boolean
        {
            return this._forceChar;
        }

        public function set forceChar(param1:Boolean):void
        {
            this._forceChar = param1;
        }
    }
}
