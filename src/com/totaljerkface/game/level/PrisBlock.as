package com.totaljerkface.game.level
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.b2PrismaticJoint;
    import Box2D.Dynamics.Joints.b2PrismaticJointDef;
    import com.totaljerkface.game.*;
    import flash.display.*;
    
    public class PrisBlock extends LevelItem
    {
        private var mc:MovieClip;
        
        private var body:b2Body;
        
        private var id:String;
        
        private var counter:Number;
        
        private var speed:Number;
        
        private var waitTime:int;
        
        private var prisJoint:b2PrismaticJoint;
        
        private var distance:Number;
        
        private var raising:Boolean;
        
        private var waiting:Boolean;
        
        public function PrisBlock(param1:String, param2:Number = 3, param3:Number = 5, param4:int = 60, param5:int = 0)
        {
            var _loc6_:b2Vec2 = null;
            super();
            this.id = param1;
            this.speed = param2;
            this.distance = param3;
            this.waitTime = param4;
            this.createBody();
            this.createJoints();
            this.mc = Settings.currentSession.level.background[param1 + "mc"];
            _loc6_ = this.body.GetWorldCenter();
            this.mc.x = _loc6_.x * m_physScale;
            this.mc.y = _loc6_.y * m_physScale;
            this.mc.rotation = this.body.GetAngle() * (180 / Math.PI);
            this.counter = 0;
            this.raising = true;
            if(param5 > 0)
            {
                this.waiting = true;
                this.counter = param4 - param5;
            }
        }
        
        internal function createBody() : void
        {
            var _loc1_:b2BodyDef = new b2BodyDef();
            _loc1_.allowSleep = false;
            this.body = Settings.currentSession.m_world.CreateBody(_loc1_);
            var _loc2_:b2PolygonDef = new b2PolygonDef();
            _loc2_.density = 50;
            _loc2_.friction = 1;
            _loc2_.restitution = 0.1;
            _loc2_.filter.categoryBits = 8;
            _loc2_.filter.groupIndex = -10;
            var _loc3_:MovieClip = Settings.currentSession.level.shapeGuide[this.id];
            var _loc4_:Number = _loc3_.rotation * Math.PI / 180;
            var _loc5_:b2Vec2 = new b2Vec2();
            _loc5_.Set(_loc3_.x / m_physScale,_loc3_.y / m_physScale);
            _loc2_.SetAsOrientedBox(_loc3_.scaleX * 5 / m_physScale,_loc3_.scaleY * 5 / m_physScale,_loc5_,_loc4_);
            this.body.CreateShape(_loc2_);
            this.body.SetMassFromShapes();
        }
        
        internal function createJoints() : void
        {
            var _loc1_:b2PrismaticJointDef = new b2PrismaticJointDef();
            _loc1_.Initialize(Settings.currentSession.level.levelBody,this.body,this.body.GetWorldCenter(),new b2Vec2(0,1));
            _loc1_.lowerTranslation = -this.distance;
            _loc1_.upperTranslation = 0;
            _loc1_.enableLimit = true;
            _loc1_.maxMotorForce = 100000;
            this.prisJoint = Settings.currentSession.m_world.CreateJoint(_loc1_) as b2PrismaticJoint;
        }
        
        override public function paint() : void
        {
            var _loc1_:b2Vec2 = this.body.GetWorldCenter();
            this.mc.x = _loc1_.x * m_physScale;
            this.mc.y = _loc1_.y * m_physScale;
            this.mc.rotation = this.body.GetAngle() * (180 / Math.PI);
        }
        
        override public function actions() : void
        {
            var _loc1_:Number = this.prisJoint.GetJointTranslation();
            if(this.waiting)
            {
                if(this.counter != this.waitTime)
                {
                    this.counter += 1;
                    return;
                }
                this.prisJoint.EnableMotor(false);
                this.counter = 0;
                this.waiting = false;
            }
            if(this.raising)
            {
                if(_loc1_ < this.prisJoint.m_lowerTranslation)
                {
                    this.raising = false;
                    this.waiting = true;
                    this.prisJoint.SetMotorSpeed(0);
                    this.prisJoint.EnableMotor(true);
                }
                else
                {
                    this.body.SetLinearVelocity(new b2Vec2(0,-this.speed));
                }
            }
            else if(_loc1_ > this.prisJoint.m_upperTranslation)
            {
                this.raising = true;
                this.waiting = true;
                this.prisJoint.SetMotorSpeed(0);
                this.prisJoint.EnableMotor(true);
            }
            else
            {
                this.body.SetLinearVelocity(new b2Vec2(0,this.speed));
            }
        }
    }
}

