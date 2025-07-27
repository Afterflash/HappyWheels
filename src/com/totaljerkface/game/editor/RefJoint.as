package com.totaljerkface.game.editor
{
    import com.totaljerkface.game.editor.actions.Action;
    import com.totaljerkface.game.editor.actions.ActionDelete;
    import com.totaljerkface.game.editor.actions.ActionProperty;
    import com.totaljerkface.game.editor.trigger.RefTrigger;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    import flash.geom.Point;
    
    public class RefJoint extends RefSprite
    {
        protected var _body1:RefSprite;
        
        protected var _body2:RefSprite;
        
        protected var _vehicleAttached:Boolean;
        
        protected var _vehicleControlled:Boolean = true;
        
        protected var _collideSelf:Boolean;
        
        public function RefJoint()
        {
            super();
            rotatable = false;
            scalable = false;
        }
        
        public function identifyBodies() : void
        {
            var _loc5_:Boolean = false;
            var _loc6_:Boolean = false;
            var _loc8_:DisplayObject = null;
            var _loc9_:RefSprite = null;
            trace("identify");
            var _loc1_:Canvas = parent.parent as Canvas;
            var _loc2_:DisplayObjectContainer = _loc1_.parent;
            var _loc3_:Point = _loc2_.localToGlobal(new Point(x,y));
            var _loc4_:Array = _loc2_.getObjectsUnderPoint(_loc3_);
            trace("objects under joint" + _loc4_.length);
            _loc4_.reverse();
            var _loc7_:int = 0;
            while(_loc7_ < _loc4_.length)
            {
                _loc8_ = _loc4_[_loc7_];
                if(!(_loc8_ == _loc1_ || _loc8_ == _loc2_))
                {
                    while(_loc8_.parent.parent != _loc1_)
                    {
                        _loc8_ = _loc8_.parent;
                    }
                    if(_loc8_ is RefSprite)
                    {
                        _loc9_ = _loc8_ as RefSprite;
                        if(_loc9_.joinable)
                        {
                            if(!_loc5_)
                            {
                                this._body1 = _loc9_;
                                _loc5_ = true;
                                this._body1.addEventListener(RefSprite.COORDINATE_CHANGE,this.bodyMoved,false,0,true);
                                _loc9_.addJoint(this);
                            }
                            else if(_loc9_ != this._body1)
                            {
                                this._body2 = _loc9_;
                                _loc6_ = true;
                                this._body2.addEventListener(RefSprite.COORDINATE_CHANGE,this.bodyMoved,false,0,true);
                                _loc9_.addJoint(this);
                                break;
                            }
                        }
                    }
                }
                _loc7_++;
            }
            if(!_loc5_)
            {
                this.deleteSelf(_loc1_);
                return;
            }
            if(!_loc6_)
            {
                this._body2 = null;
            }
            this._vehicleAttached = this._body1 is RefVehicle || this._body2 is RefVehicle ? true : false;
            setAttributes();
            this.drawArms();
        }
        
        public function drawArms() : void
        {
            graphics.clear();
            graphics.lineStyle(0,16737792);
            if(this._body1)
            {
                graphics.moveTo(0,0);
                graphics.lineTo(this.body1.x - x,this.body1.y - y);
            }
            if(this.body2)
            {
                graphics.moveTo(0,0);
                graphics.lineTo(this.body2.x - x,this.body2.y - y);
            }
            if(selected)
            {
                drawBoundingBox();
            }
        }
        
        protected function bodyMoved(param1:Event) : void
        {
            this.drawArms();
        }
        
        private function bodyDeleted(param1:Event) : void
        {
            trace("body deleted");
            if(param1.target == this.body1)
            {
                this._body1.removeEventListener(RefSprite.COORDINATE_CHANGE,this.bodyMoved);
                this._body1 = null;
                if(!this.body2)
                {
                    this.deleteSelf(parent.parent as Canvas);
                    return;
                }
                this._body1 = this._body2;
                this._body2 = null;
            }
            if(param1.target == this.body2)
            {
                this._body2.removeEventListener(RefSprite.COORDINATE_CHANGE,this.bodyMoved);
                this._body2 = null;
            }
            this.drawArms();
        }
        
        override public function deleteSelf(param1:Canvas) : Action
        {
            var _loc3_:Action = null;
            var _loc4_:Action = null;
            var _loc5_:* = 0;
            var _loc6_:RefTrigger = null;
            var _loc2_:Point = new Point(x,y);
            if(this._body1)
            {
                _loc3_ = new ActionProperty(this,"body1",this._body1,null,_loc2_,_loc2_);
                _loc4_ = _loc3_;
                this._body1.removeEventListener(RefSprite.COORDINATE_CHANGE,this.bodyMoved);
                this._body1.removeJoint(this);
                this._body1 = null;
            }
            if(this._body2)
            {
                _loc3_ = new ActionProperty(this,"body2",this._body2,null,_loc2_,_loc2_);
                if(_loc4_)
                {
                    _loc4_.nextAction = _loc3_;
                }
                _loc4_ = _loc3_;
                this._body2.removeEventListener(RefSprite.COORDINATE_CHANGE,this.bodyMoved);
                this._body2.removeJoint(this);
                this._body2 = null;
            }
            if(_triggers)
            {
                _loc5_ = 0;
                while(_loc5_ < _triggers.length)
                {
                    _loc6_ = _triggers[_loc5_];
                    _loc3_ = _loc6_.removeTarget(this);
                    if(_loc4_)
                    {
                        _loc4_.nextAction = _loc3_.firstAction;
                    }
                    _loc4_ = _loc3_;
                    removeTrigger(_loc6_);
                    _loc5_ = --_loc5_ + 1;
                }
            }
            if(parent)
            {
                _loc3_ = new ActionDelete(this,param1,parent.getChildIndex(this));
                if(_loc4_)
                {
                    _loc4_.nextAction = _loc3_;
                }
                param1.removeRefSprite(this);
                return _loc3_;
            }
            return null;
        }
        
        public function removeBody(param1:RefSprite) : Action
        {
            var _loc3_:Action = null;
            var _loc4_:Action = null;
            trace("REMOVE BODY " + param1);
            var _loc2_:Point = new Point(x,y);
            if(param1 == this._body1)
            {
                trace("body 1 " + param1);
                _loc3_ = new ActionProperty(this,"body1",this._body1,null,_loc2_,_loc2_);
                this._body1 = null;
            }
            else
            {
                if(param1 != this._body2)
                {
                    throw new Error("body not contained in this joint");
                }
                trace("body 2 " + param1);
                _loc3_ = new ActionProperty(this,"body2",this._body2,null,_loc2_,_loc2_);
                this._body2 = null;
            }
            if(this._body1 == null && this._body2 == null)
            {
                trace("BOTH NULL");
                _loc4_ = _loc3_;
                _loc3_ = this.deleteSelf(parent.parent as Canvas);
                _loc4_.nextAction = _loc3_;
            }
            else
            {
                this.drawArms();
            }
            this._vehicleAttached = this._body1 is RefVehicle || this._body2 is RefVehicle ? true : false;
            setAttributes();
            return _loc3_;
        }
        
        public function get body1() : RefSprite
        {
            return this._body1;
        }
        
        public function set body1(param1:RefSprite) : void
        {
            if(this._body1)
            {
                this._body1.removeEventListener(RefSprite.COORDINATE_CHANGE,this.bodyMoved);
                this._body1.removeJoint(this);
            }
            if(param1 == null)
            {
                this._body1 = null;
                return;
            }
            this._body1 = param1;
            this._vehicleAttached = this._body1 is RefVehicle || this._body2 is RefVehicle ? true : false;
            setAttributes();
            if(stage == null)
            {
                return;
            }
            param1.addEventListener(RefSprite.COORDINATE_CHANGE,this.bodyMoved,false,0,true);
            param1.addJoint(this);
        }
        
        public function get body2() : RefSprite
        {
            return this._body2;
        }
        
        public function set body2(param1:RefSprite) : void
        {
            if(this._body2)
            {
                this._body2.removeEventListener(RefSprite.COORDINATE_CHANGE,this.bodyMoved);
                this._body2.removeJoint(this);
            }
            if(param1 == null)
            {
                this._body2 = null;
                return;
            }
            this._body2 = param1;
            this._vehicleAttached = this._body1 is RefVehicle || this._body2 is RefVehicle ? true : false;
            setAttributes();
            if(stage == null)
            {
                return;
            }
            param1.addEventListener(RefSprite.COORDINATE_CHANGE,this.bodyMoved,false,0,true);
            param1.addJoint(this);
        }
        
        override public function set x(param1:Number) : void
        {
            super.x = param1;
            this.drawArms();
        }
        
        override public function set y(param1:Number) : void
        {
            super.y = param1;
            this.drawArms();
        }
        
        public function get collideSelf() : Boolean
        {
            return this._collideSelf;
        }
        
        public function set collideSelf(param1:Boolean) : void
        {
            this._collideSelf = param1;
        }
        
        public function get vehicleAttached() : Boolean
        {
            return this._vehicleAttached;
        }
        
        public function get vehicleControlled() : Boolean
        {
            return this._vehicleControlled;
        }
        
        public function set vehicleControlled(param1:Boolean) : void
        {
            this._vehicleControlled = param1;
        }
    }
}

