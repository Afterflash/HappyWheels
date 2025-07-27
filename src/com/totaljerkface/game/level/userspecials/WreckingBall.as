package com.totaljerkface.game.level.userspecials
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Collision.b2ContactPoint;
    import Box2D.Common.Math.b2Math;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.editor.specials.*;
    import com.totaljerkface.game.events.*;
    import com.totaljerkface.game.level.*;
    import com.totaljerkface.game.sound.SoundController;
    import flash.display.*;
    
    public class WreckingBall extends LevelItem
    {
        private var mc:WreckingBallMC;
        
        private var ballMC:Sprite;
        
        private var ropeMC:Sprite;
        
        private var body:b2Body;
        
        private var ballShape:b2Shape;
        
        private var stemShape:b2Shape;
        
        private var joint:b2RevoluteJoint;
        
        private var speed:Number = 1.75;
        
        public function WreckingBall(param1:Special)
        {
            var _loc3_:LevelB2D = null;
            var _loc4_:Sprite = null;
            super();
            var _loc2_:WreckingBallRef = param1 as WreckingBallRef;
            this.createBody(new b2Vec2(_loc2_.x,_loc2_.y),_loc2_.ropeLength);
            this.createJoint(new b2Vec2(_loc2_.x,_loc2_.y));
            this.mc = new WreckingBallMC();
            _loc3_ = Settings.currentSession.level;
            _loc4_ = _loc3_.background;
            _loc4_.addChild(this.mc);
            this.mc.x = _loc2_.x;
            this.mc.y = _loc2_.y;
            this.mc.rope.base.y = _loc2_.ropeLength - 136.5;
            this.mc.rope.stem.height = _loc2_.ropeLength - 120;
            this.ropeMC = this.mc.rope;
            this.ballMC = this.mc.ball;
            _loc4_.addChild(this.ballMC);
            _loc3_.paintItemVector.push(this);
            _loc3_.actionsVector.push(this);
            this.speed = this.speed * 1000 / _loc2_.ropeLength;
        }
        
        internal function createBody(param1:b2Vec2, param2:int) : void
        {
            var _loc3_:b2BodyDef = new b2BodyDef();
            _loc3_.position.Set((param1.x + param2) / m_physScale,param1.y / m_physScale);
            _loc3_.angle = -90 * Math.PI / 180;
            this.body = Settings.currentSession.m_world.CreateBody(_loc3_);
            var _loc4_:b2PolygonDef = new b2PolygonDef();
            _loc4_.density = 500;
            _loc4_.friction = 0.1;
            _loc4_.restitution = 0.1;
            _loc4_.filter.categoryBits = 8;
            var _loc5_:b2CircleDef = new b2CircleDef();
            _loc5_.density = 500;
            _loc5_.friction = 0.1;
            _loc5_.restitution = 0.1;
            _loc5_.filter.categoryBits = 8;
            _loc4_.SetAsOrientedBox(18 / m_physScale,7.5 / m_physScale,new b2Vec2(0,-80 / m_physScale),0);
            this.stemShape = this.body.CreateShape(_loc4_);
            _loc5_.radius = 75 / m_physScale;
            this.ballShape = this.body.CreateShape(_loc5_);
            this.body.SetMassFromShapes();
            Settings.currentSession.contactListener.registerListener(ContactListener.ADD,this.ballShape,this.checkAdd);
            _loc4_.SetAsOrientedBox(18 / m_physScale,16 / m_physScale,new b2Vec2(param1.x / m_physScale,(param1.y - 16) / m_physScale),0);
            Settings.currentSession.level.levelBody.CreateShape(_loc4_);
        }
        
        internal function createJoint(param1:b2Vec2) : void
        {
            var _loc2_:b2RevoluteJointDef = new b2RevoluteJointDef();
            _loc2_.Initialize(Settings.currentSession.level.levelBody,this.body,new b2Vec2(param1.x / m_physScale,param1.y / m_physScale));
            _loc2_.enableLimit = true;
            _loc2_.upperAngle = Math.PI + 0.25 * Math.PI;
            _loc2_.lowerAngle = -0.25 * Math.PI;
            _loc2_.enableMotor = false;
            _loc2_.maxMotorTorque = 10000000;
            this.joint = Settings.currentSession.m_world.CreateJoint(_loc2_) as b2RevoluteJoint;
        }
        
        override public function paint() : void
        {
            var _loc1_:b2Vec2 = null;
            _loc1_ = this.body.GetWorldCenter();
            this.ballMC.x = _loc1_.x * m_physScale;
            this.ballMC.y = _loc1_.y * m_physScale;
            this.ballMC.rotation = this.body.GetAngle() * oneEightyOverPI;
            this.ropeMC.rotation = this.ballMC.rotation;
        }
        
        override public function actions() : void
        {
            if(this.joint.GetJointAngle() < 0.3)
            {
                if(this.joint.IsMotorEnabled())
                {
                    this.joint.EnableMotor(false);
                    if(this.speed < 0)
                    {
                        this.speed *= -1;
                    }
                    this.joint.SetMotorSpeed(this.speed);
                }
            }
            else if(this.joint.GetJointAngle() > 2.84)
            {
                if(this.joint.IsMotorEnabled())
                {
                    this.joint.EnableMotor(false);
                    if(this.speed > 0)
                    {
                        this.speed *= -1;
                    }
                    this.joint.SetMotorSpeed(this.speed);
                }
            }
            else if(!this.joint.IsMotorEnabled())
            {
                this.joint.EnableMotor(true);
                this.joint.SetMotorSpeed(this.speed);
                SoundController.instance.playAreaSoundInstance("BallSwing",this.body);
            }
        }
        
        private function checkAdd(param1:b2ContactPoint) : void
        {
            if(param1.shape2.m_isSensor)
            {
                return;
            }
            var _loc2_:Number = param1.shape2.m_body.m_mass;
            if(_loc2_ != 0 && _loc2_ < this.body.m_mass)
            {
                return;
            }
            var _loc3_:Number = b2Math.b2Dot(param1.velocity,param1.normal);
            _loc3_ = Math.abs(_loc3_);
            if(_loc3_ > 4)
            {
                SoundController.instance.playAreaSoundInstance("BallHit",this.body);
            }
        }
        
        override public function prepareForTrigger() : void
        {
            var _loc1_:Session = Settings.currentSession;
            var _loc2_:Vector.<LevelItem> = _loc1_.level.actionsVector;
            var _loc3_:int = int(_loc2_.indexOf(this));
            _loc2_.splice(_loc3_,1);
            this.joint.m_upperAngle = 0;
            this.joint.m_lowerAngle = 0;
            this.body.PutToSleep();
            this.ballShape.m_isSensor = true;
            this.stemShape.m_isSensor = true;
            Settings.currentSession.m_world.Refilter(this.ballShape);
            Settings.currentSession.m_world.Refilter(this.stemShape);
        }
        
        override public function triggerSingleActivation(param1:Trigger, param2:String, param3:Array) : void
        {
            if(_triggered)
            {
                return;
            }
            _triggered = true;
            this.body.WakeUp();
            this.joint.m_upperAngle = Math.PI + 0.25 * Math.PI;
            this.joint.m_lowerAngle = -0.25 * Math.PI;
            this.ballShape.m_isSensor = false;
            this.stemShape.m_isSensor = false;
            var _loc4_:Session = Settings.currentSession;
            _loc4_.m_world.Refilter(this.ballShape);
            _loc4_.m_world.Refilter(this.stemShape);
            _loc4_.level.actionsVector.push(this);
        }
    }
}

