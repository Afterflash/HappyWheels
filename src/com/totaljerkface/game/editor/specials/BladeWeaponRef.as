package com.totaljerkface.game.editor.specials
{
    import com.totaljerkface.game.editor.*;
    import com.totaljerkface.game.events.CanvasEvent;
    import flash.display.MovieClip;
    import flash.utils.Dictionary;

    [Embed(source="/_assets/assets.swf", symbol="symbol3081")]
    public class BladeWeaponRef extends Special
    {
        public static const MAX_WEAPONS:* = 12;

        public var mc:MovieClip;

        private var _bladeWeaponType:int = 1;

        private var _reverse:Boolean = false;

        private var _sleeping:Boolean = false;

        private var _interactive:Boolean = true;

        public function BladeWeaponRef()
        {
            _triggerable = true;
            _triggers = new Array();
            _triggerActions = new Dictionary();
            _triggerActionList = ["wake from sleep", "apply impulse"];
            _triggerActionListProperties = [null, ["impulseX", "impulseY", "spin"]];
            super();
            name = "blade weapon";
            _scalable = false;
            _joinable = true;
            _groupable = true;
            _shapesUsed = 2;
            _joints = new Array();
            _keyedPropertyObject[_triggerString] = _triggerActions;
            this.mc.gotoAndStop(this._bladeWeaponType);
        }

        override public function setAttributes():void
        {
            _type = "BladeWeaponRef";
            _attributes = ["x", "y", "angle", "reverse", "sleeping", "interactive", "bladeWeaponType"];
            addTriggerProperties();
        }

        public function get bladeWeaponType():int
        {
            return this._bladeWeaponType;
        }

        public function set bladeWeaponType(param1:int):void
        {
            if (param1 < 1)
            {
                param1 = 1;
            }
            if (param1 > MAX_WEAPONS)
            {
                param1 = MAX_WEAPONS;
            }
            this.mc.gotoAndStop(param1);
            if (_selected)
            {
                drawBoundingBox();
            }
            this._bladeWeaponType = param1;
        }

        public function get reverse():Boolean
        {
            return this._reverse;
        }

        public function set reverse(param1:Boolean):void
        {
            if (param1 == this._reverse)
            {
                return;
            }
            this.mc.scaleX = param1 ? -1 : 1;
            if (_selected)
            {
                drawBoundingBox();
            }
            this._reverse = param1;
        }

        public function get interactive():Boolean
        {
            return this._interactive;
        }

        public function set interactive(param1:Boolean):void
        {
            if (this._interactive == param1)
            {
                return;
            }
            if (param1 && _inGroup)
            {
                return;
            }
            this._interactive = param1;
            if (this._interactive)
            {
                _joinable = true;
                _shapesUsed = 2;
                _artUsed = 0;
                dispatchEvent(new CanvasEvent(CanvasEvent.ART, -1));
                dispatchEvent(new CanvasEvent(CanvasEvent.SHAPE, 2));
            }
            else
            {
                _joinable = false;
                _shapesUsed = 0;
                _artUsed = 1;
                dispatchEvent(new CanvasEvent(CanvasEvent.SHAPE, -2));
                dispatchEvent(new CanvasEvent(CanvasEvent.ART, 1));
            }
        }

        public function get sleeping():Boolean
        {
            return this._sleeping;
        }

        public function set sleeping(param1:Boolean):void
        {
            this._sleeping = param1;
        }

        override public function clone():RefSprite
        {
            var _loc1_:BladeWeaponRef = new BladeWeaponRef();
            _loc1_.x = x;
            _loc1_.y = y;
            _loc1_.interactive = this.interactive;
            _loc1_.angle = angle;
            _loc1_.reverse = this.reverse;
            _loc1_.sleeping = this.sleeping;
            _loc1_.bladeWeaponType = this.bladeWeaponType;
            transferKeyedProperties(_loc1_);
            return _loc1_;
        }

        override public function get groupable():Boolean
        {
            if (_inGroup)
            {
                return false;
            }
            return _groupable;
        }
    }
}
