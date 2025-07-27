package com.totaljerkface.game.level
{
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.b2RevoluteJoint;
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.editor.RefSprite;
    import flash.display.*;
    import flash.events.*;
    
    public class TargetActionRevJoint extends LevelItem
    {
        protected var _refSprite:RefSprite;
        
        protected var _joint:b2RevoluteJoint;
        
        protected var _action:String;
        
        protected var _properties:Array;
        
        protected var _instant:Boolean;
        
        protected var counter:int = 0;
        
        public function TargetActionRevJoint(param1:RefSprite, param2:b2RevoluteJoint, param3:String, param4:Array)
        {
            super();
            this._refSprite = param1;
            this._joint = param2;
            this._action = param3;
            this._instant = param3 == "change motor speed" ? false : true;
            this._properties = param4;
        }
        
        override public function singleAction() : void
        {
            var _loc1_:Number = NaN;
            var _loc2_:Number = NaN;
            var _loc3_:b2World = null;
            switch(this._action)
            {
                case "disable limits":
                    if(this._joint)
                    {
                        if(this._joint.m_body1.IsSleeping())
                        {
                            this._joint.m_body1.WakeUp();
                        }
                        if(this._joint.m_body2.IsSleeping())
                        {
                            this._joint.m_body2.WakeUp();
                        }
                        this._joint.EnableLimit(false);
                    }
                    break;
                case "change limits":
                    if(this._joint)
                    {
                        if(this._joint.m_body1.IsSleeping())
                        {
                            this._joint.m_body1.WakeUp();
                        }
                        if(this._joint.m_body2.IsSleeping())
                        {
                            this._joint.m_body2.WakeUp();
                        }
                        _loc1_ = this._properties[0] * Math.PI / 180;
                        _loc2_ = this._properties[1] * Math.PI / 180;
                        this._joint.SetLimits(_loc2_,_loc1_);
                        if(Settings.currentSession.levelVersion > 1.84)
                        {
                            this._joint.EnableLimit(true);
                        }
                    }
                    break;
                case "disable motor":
                    if(this._joint)
                    {
                        this._joint.EnableMotor(false);
                        if(this._joint.m_body1.IsSleeping())
                        {
                            this._joint.m_body1.WakeUp();
                        }
                        if(this._joint.m_body2.IsSleeping())
                        {
                            this._joint.m_body2.WakeUp();
                        }
                    }
                    break;
                case "delete self":
                    if(this._joint)
                    {
                        _loc3_ = Settings.currentSession.m_world;
                        _loc3_.DestroyJoint(this._joint);
                        this._joint = null;
                    }
            }
        }
        
        override public function actions() : void
        {
            var _loc1_:Number = NaN;
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            var _loc4_:Number = NaN;
            switch(this._action)
            {
                case "change motor speed":
                    if(this._joint)
                    {
                        if(this._joint.m_body1.IsSleeping())
                        {
                            this._joint.m_body1.WakeUp();
                        }
                        if(this._joint.m_body2.IsSleeping())
                        {
                            this._joint.m_body2.WakeUp();
                        }
                        if(!this._joint.IsMotorEnabled())
                        {
                            this._joint.EnableMotor(true);
                        }
                        _loc1_ = Number(this._properties[0]);
                        _loc2_ = Number(this._properties[1]);
                        _loc2_ = Math.round(_loc2_ * 30);
                        if(this.counter == _loc2_)
                        {
                            if(Settings.currentSession.levelVersion > 1.8)
                            {
                                this.counter = 0;
                            }
                            this._joint.SetMotorSpeed(_loc1_);
                            Settings.currentSession.level.removeFromActionsVector(this);
                            return;
                        }
                        _loc3_ = this._joint.GetMotorSpeed();
                        _loc4_ = _loc1_ - _loc3_;
                        this._joint.SetMotorSpeed(_loc3_ + _loc4_ / (_loc2_ - this.counter));
                    }
            }
            this.counter += 1;
        }
        
        public function get joint() : b2RevoluteJoint
        {
            return this._joint;
        }
        
        public function set joint(param1:b2RevoluteJoint) : void
        {
            this._joint = param1;
        }
        
        public function get instant() : Boolean
        {
            return this._instant;
        }
    }
}

