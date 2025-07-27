package com.totaljerkface.game.editor.specials
{
    import com.totaljerkface.game.editor.RefSprite;

    [Embed(source="/_assets/assets.swf", symbol="symbol2851")]
    public class ArrowGunRef extends Special
    {
        protected var _rateOfFire:int = 5;

        protected var _dontShootPlayer:Boolean = false;

        protected var _immovable2:Boolean = true;

        public function ArrowGunRef()
        {
            super();
            name = "arrow gun";
            _shapesUsed = 23;
            _rotatable = true;
            _scalable = false;
            _joinable = true;
            _groupable = true;
            _joints = new Array();
        }

        override public function setAttributes():void
        {
            _type = "ArrowGunRef";
            _attributes = ["x", "y", "angle", "immovable2", "rateOfFire", "dontShootPlayer"];
        }

        override public function clone():RefSprite
        {
            var _loc1_:ArrowGunRef = new ArrowGunRef();
            _loc1_.x = x;
            _loc1_.y = y;
            _loc1_.angle = angle;
            _loc1_.rateOfFire = this.rateOfFire;
            _loc1_.immovable2 = this.immovable2;
            _loc1_.dontShootPlayer = this.dontShootPlayer;
            transferKeyedProperties(_loc1_);
            return _loc1_;
        }

        public function get immovable2():Boolean
        {
            return this._immovable2;
        }

        public function set immovable2(param1:Boolean):void
        {
            if (param1 && _inGroup)
            {
                return;
            }
            this._immovable2 = param1;
        }

        public function get rateOfFire():int
        {
            return this._rateOfFire;
        }

        public function set rateOfFire(param1:int):void
        {
            this._rateOfFire = param1;
        }

        public function get dontShootPlayer():Boolean
        {
            return this._dontShootPlayer;
        }

        public function set dontShootPlayer(param1:Boolean):void
        {
            this._dontShootPlayer = param1;
        }

        override public function get joinable():Boolean
        {
            if (this._immovable2)
            {
                return false;
            }
            return _joinable;
        }

        override public function get groupable():Boolean
        {
            if (this._immovable2 || _inGroup)
            {
                return false;
            }
            return _groupable;
        }
    }
}
