package com.totaljerkface.game.editor
{
    import com.totaljerkface.game.editor.specials.Special;
    
    public class RefVehicle extends RefGroup
    {
        public static const NUM_ACTIONS:int = 3;
        
        public static const NUM_POSES:int = 3;
        
        protected var _spaceAction:int = 0;
        
        protected var _shiftAction:int = 0;
        
        protected var _ctrlAction:int = 0;
        
        protected var _acceleration:Number = 1;
        
        protected var _characterPose:int = 0;
        
        protected var _lockJoints:Boolean = false;
        
        protected var _leaningStrength:int = 0;
        
        public function RefVehicle()
        {
            super();
            name = "vehicle";
        }
        
        override public function setAttributes() : void
        {
            _attributes = ["x","y","angle","sleeping","foreground","acceleration","lockJoints","leaningStrength","spaceAction","shiftAction","ctrlAction","characterPose"];
            addTriggerProperties();
        }
        
        override public function get functions() : Array
        {
            return ["convertVehicleToGroup"];
        }
        
        override public function get vehiclePossible() : Boolean
        {
            return false;
        }
        
        public function get acceleration() : int
        {
            return this._acceleration;
        }
        
        public function set acceleration(param1:int) : void
        {
            if(param1 < 1)
            {
                param1 = 1;
            }
            if(param1 > 10)
            {
                param1 = 10;
            }
            this._acceleration = param1;
        }
        
        public function get lockJoints() : Boolean
        {
            return this._lockJoints;
        }
        
        public function set lockJoints(param1:Boolean) : void
        {
            this._lockJoints = param1;
        }
        
        public function get leaningStrength() : int
        {
            return this._leaningStrength;
        }
        
        public function set leaningStrength(param1:int) : void
        {
            if(param1 < 0)
            {
                param1 = 0;
            }
            if(param1 > 10)
            {
                param1 = 10;
            }
            this._leaningStrength = param1;
        }
        
        public function get spaceAction() : int
        {
            return this._spaceAction;
        }
        
        public function set spaceAction(param1:int) : void
        {
            if(param1 < 0)
            {
                param1 = 0;
            }
            if(param1 > NUM_ACTIONS)
            {
                param1 = NUM_ACTIONS;
            }
            this._spaceAction = param1;
        }
        
        public function get shiftAction() : int
        {
            return this._shiftAction;
        }
        
        public function set shiftAction(param1:int) : void
        {
            if(param1 < 0)
            {
                param1 = 0;
            }
            if(param1 > NUM_ACTIONS)
            {
                param1 = NUM_ACTIONS;
            }
            this._shiftAction = param1;
        }
        
        public function get ctrlAction() : int
        {
            return this._ctrlAction;
        }
        
        public function set ctrlAction(param1:int) : void
        {
            if(param1 < 0)
            {
                param1 = 0;
            }
            if(param1 > NUM_ACTIONS)
            {
                param1 = NUM_ACTIONS;
            }
            this._ctrlAction = param1;
        }
        
        public function get characterPose() : int
        {
            return this._characterPose;
        }
        
        public function set characterPose(param1:int) : void
        {
            if(param1 < 0)
            {
                param1 = 0;
            }
            if(param1 > NUM_POSES)
            {
                param1 = NUM_POSES;
            }
            this._characterPose = param1;
        }
        
        override public function checkVehicleAttached(param1:Array = null) : Boolean
        {
            return true;
        }
        
        override public function clone() : RefSprite
        {
            var _loc3_:RefShape = null;
            var _loc4_:RefShape = null;
            var _loc5_:RefSprite = null;
            var _loc6_:RefSprite = null;
            var _loc1_:RefVehicle = new RefVehicle();
            _loc1_.offset = offset;
            _loc1_.x = x;
            _loc1_.y = y;
            _loc1_.angle = angle;
            _loc1_.sleeping = sleeping;
            _loc1_.foreground = foreground;
            _loc1_.joinable = joinable;
            _loc1_.acceleration = this.acceleration;
            _loc1_.leaningStrength = this.leaningStrength;
            _loc1_.spaceAction = this.spaceAction;
            _loc1_.shiftAction = this.shiftAction;
            _loc1_.ctrlAction = this.ctrlAction;
            _loc1_.characterPose = this.characterPose;
            _loc1_.lockJoints = this.lockJoints;
            var _loc2_:int = 0;
            while(_loc2_ < _shapeContainer.numChildren)
            {
                _loc3_ = _shapeContainer.getChildAt(_loc2_) as RefShape;
                _loc4_ = _loc3_.clone() as RefShape;
                _loc1_.addShape(_loc4_);
                _loc4_.group = _loc1_;
                _loc4_.inGroup = true;
                _loc4_.setFilters();
                _loc2_++;
            }
            _loc2_ = 0;
            while(_loc2_ < _specialContainer.numChildren)
            {
                _loc5_ = _specialContainer.getChildAt(_loc2_) as RefSprite;
                _loc6_ = _loc5_.clone();
                _loc6_.group = _loc1_;
                _loc6_.inGroup = true;
                _loc1_.addSpecial(_loc6_ as Special);
                _loc2_++;
            }
            transferKeyedProperties(_loc1_);
            return _loc1_;
        }
        
        public function cloneAsGroup() : RefGroup
        {
            var _loc3_:RefSprite = null;
            var _loc4_:RefSprite = null;
            var _loc1_:RefGroup = new RefGroup();
            _loc1_.offset = offset;
            _loc1_.x = x;
            _loc1_.y = y;
            _loc1_.angle = angle;
            _loc1_.sleeping = sleeping;
            _loc1_.foreground = foreground;
            _loc1_.joinable = joinable;
            var _loc2_:int = 0;
            while(_loc2_ < _shapeContainer.numChildren)
            {
                _loc3_ = _shapeContainer.getChildAt(_loc2_) as RefSprite;
                _loc4_ = _loc3_.clone();
                _loc4_.group = _loc1_;
                _loc4_.inGroup = true;
                _loc1_.addShape(_loc4_ as RefShape);
                _loc2_++;
            }
            _loc2_ = 0;
            while(_loc2_ < _specialContainer.numChildren)
            {
                _loc3_ = _specialContainer.getChildAt(_loc2_) as RefSprite;
                _loc4_ = _loc3_.clone();
                _loc4_.group = _loc1_;
                _loc4_.inGroup = true;
                _loc1_.addSpecial(_loc4_ as Special);
                _loc2_++;
            }
            return _loc1_;
        }
    }
}

