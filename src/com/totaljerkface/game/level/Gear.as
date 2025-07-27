package com.totaljerkface.game.level
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.events.*;
    import flash.display.*;
    
    public class Gear extends LevelItem
    {
        private var id:String;
        
        internal var body:b2Body;
        
        internal var revJoint:b2RevoluteJoint;
        
        private var mc:MovieClip;
        
        private var motorSpeed:Number;
        
        public function Gear(param1:String, param2:Number = 0, param3:int = 5, param4:Number = 0.9, param5:Number = 0.12)
        {
            super();
            this.id = param1;
            this.motorSpeed = param2;
            this.createBodies(param3,param4,param5);
            this.createJoints();
            this.createMCs();
        }
        
        internal function createBodies(param1:int, param2:Number, param3:Number) : void
        {
            var _loc5_:b2PolygonDef = null;
            var _loc7_:Number = NaN;
            var _loc4_:b2BodyDef = new b2BodyDef();
            this.body = Settings.currentSession.m_world.CreateBody(_loc4_);
            _loc5_ = new b2PolygonDef();
            _loc5_.density = 1;
            _loc5_.friction = 1;
            _loc5_.restitution = 0.1;
            _loc5_.filter.categoryBits = 8;
            _loc5_.filter.groupIndex = -10;
            var _loc6_:b2CircleDef = new b2CircleDef();
            _loc6_.density = 1;
            _loc6_.friction = 1;
            _loc6_.restitution = 0.1;
            _loc6_.filter.categoryBits = 8;
            _loc6_.filter.groupIndex = -10;
            var _loc8_:b2Vec2 = new b2Vec2();
            var _loc9_:MovieClip = Settings.currentSession.level.shapeGuide[this.id];
            var _loc10_:Number = _loc9_.rotation * Math.PI / 180;
            _loc8_.Set(_loc9_.x / m_physScale,_loc9_.y / m_physScale);
            _loc6_.localPosition.Set(_loc8_.x,_loc8_.y);
            _loc6_.radius = _loc9_.scaleX * 5 * param2 / m_physScale;
            this.body.CreateShape(_loc6_);
            var _loc11_:Number = 180 / param1;
            var _loc12_:Number = _loc9_.scaleX * 5 / m_physScale;
            var _loc13_:Number = _loc9_.scaleX * 5 * param3 / m_physScale;
            var _loc14_:int = 0;
            while(_loc14_ < param1)
            {
                _loc7_ = _loc10_ + _loc14_ * _loc11_ * Math.PI / 180;
                _loc5_.SetAsOrientedBox(_loc12_,_loc13_,_loc8_,_loc7_);
                this.body.CreateShape(_loc5_);
                _loc14_++;
            }
            this.body.SetMassFromShapes();
        }
        
        internal function createJoints() : void
        {
            var _loc1_:b2RevoluteJointDef = new b2RevoluteJointDef();
            var _loc2_:b2Vec2 = new b2Vec2();
            var _loc3_:MovieClip = Settings.currentSession.level.shapeGuide[this.id];
            _loc2_.Set(_loc3_.x / m_physScale,_loc3_.y / m_physScale);
            _loc1_.Initialize(Settings.currentSession.level.levelBody,this.body,_loc2_);
            this.revJoint = Settings.currentSession.m_world.CreateJoint(_loc1_) as b2RevoluteJoint;
            if(this.motorSpeed != 0)
            {
                this.revJoint.EnableMotor(true);
                this.revJoint.m_maxMotorTorque = 10000000;
                this.revJoint.SetMotorSpeed(this.motorSpeed);
            }
        }
        
        internal function createMCs() : void
        {
            this.mc = Settings.currentSession.level.background[this.id + "mc"];
            var _loc1_:MovieClip = Settings.currentSession.level.shapeGuide[this.id];
            this.mc.inner.rotation = _loc1_.rotation;
        }
        
        override public function paint() : void
        {
            var _loc1_:b2Vec2 = null;
            if(this.body.IsSleeping())
            {
                return;
            }
            _loc1_ = this.body.GetWorldCenter();
            this.mc.x = _loc1_.x * m_physScale;
            this.mc.y = _loc1_.y * m_physScale;
            this.mc.rotation = this.body.GetAngle() * (180 / Math.PI);
        }
    }
}

