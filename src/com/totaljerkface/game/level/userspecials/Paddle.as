package com.totaljerkface.game.level.userspecials
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.b2RevoluteJoint;
    import Box2D.Dynamics.Joints.b2RevoluteJointDef;
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.editor.specials.*;
    import com.totaljerkface.game.events.*;
    import com.totaljerkface.game.level.*;
    import com.totaljerkface.game.sound.SoundController;
    import flash.display.*;
    import flash.filters.BevelFilter;
    import flash.geom.ColorTransform;
    import flash.text.TextField;
    
    public class Paddle extends LevelItem
    {
        private static var idCounter:int = 0;
        
        private var id:String;
        
        private var timerText:TextField;
        
        private var body:b2Body;
        
        private var glow:Sprite;
        
        private var padShape:b2Shape;
        
        private var joint:b2RevoluteJoint;
        
        private var hit:Boolean;
        
        private var delayCounter:int = 0;
        
        private var delayTotal:int = 0;
        
        private var delayTimeString:String;
        
        private var paddle:MovieClip;
        
        private var startAng:Number;
        
        private var direction:int = 1;
        
        private var tarAng:Number = 90;
        
        private var tolerance:Number = 3;
        
        private const maxSpeed:int = 6;
        
        private const minSpeed:Number = 0.5;
        
        private var paddleSpeed:Number;
        
        private var blockerShape:b2Shape;
        
        public function Paddle(param1:Special)
        {
            var _loc2_:PaddleRef = null;
            var _loc4_:LevelB2D = null;
            super();
            _loc2_ = param1 as PaddleRef;
            this.tarAng = _loc2_.paddleAngle * Math.PI / 180;
            this.paddleSpeed = this.minSpeed + (this.maxSpeed - this.minSpeed) * _loc2_.paddleSpeed / 10;
            this.paddle = new PaddleMC();
            var _loc3_:MovieClip = new PaddleBaseMC();
            if(_loc2_.reverse)
            {
                this.direction = -1;
                this.tarAng *= this.direction;
                this.tolerance *= this.direction;
                this.paddle.nub.x *= -1;
                this.paddle.timer.x *= -1;
                this.paddle.arrow.x *= -1;
                _loc3_.nub.x *= -1;
            }
            this.createBody(new b2Vec2(_loc2_.x,_loc2_.y),_loc2_.rotation * Math.PI / 180);
            this.createJoint();
            _loc4_ = Settings.currentSession.level;
            var _loc5_:Sprite = _loc4_.background;
            _loc5_.addChild(_loc3_);
            _loc3_.x = _loc2_.x;
            _loc3_.y = _loc2_.y;
            _loc3_.rotation = _loc2_.rotation;
            this.timerText = this.paddle.timer.timerText;
            this.timerText.maxChars = 3;
            this.glow = this.paddle.arrow.glow;
            this.glow.visible = false;
            var _loc6_:Sprite = _loc4_.foreground;
            _loc6_.addChild(this.paddle);
            this.paddle.x = _loc2_.x;
            this.paddle.y = _loc2_.y;
            this.paddle.rotation = _loc2_.rotation;
            this.delayTotal = Math.round(_loc2_.springDelay * 30);
            this.delayCounter = this.delayTotal;
            var _loc7_:Number = this.delayCounter / 30;
            this.delayTimeString = _loc7_.toFixed(2);
            this.timerText.text = this.delayTimeString;
            _loc4_.paintItemVector.push(this);
            _loc4_.actionsVector.push(this);
            Settings.currentSession.contactListener.registerListener(ContactEvent.RESULT,this.padShape,this.checkContact);
            var _loc8_:BevelFilter = new BevelFilter(5,90,16777215,1,0,1,5,5,1,3,"inner");
            Settings.currentSession.particleController.createBMDArray("metalpieces",new MetalPiecesMC(),[_loc8_]);
        }
        
        internal function createBody(param1:b2Vec2, param2:Number) : void
        {
            var _loc3_:int = 15;
            var _loc4_:int = 30;
            var _loc5_:int = 332;
            var _loc6_:int = 40;
            var _loc7_:int = 350;
            this.startAng = param2;
            var _loc8_:b2BodyDef = new b2BodyDef();
            _loc8_.position.Set(param1.x / m_physScale,param1.y / m_physScale);
            _loc8_.angle = param2;
            this.body = Settings.currentSession.m_world.CreateBody(_loc8_);
            var _loc9_:b2PolygonDef = new b2PolygonDef();
            _loc9_.density = 200;
            _loc9_.friction = 0.5;
            _loc9_.restitution = 0.1;
            _loc9_.filter.categoryBits = 8;
            _loc9_.filter.groupIndex = _loc3_;
            _loc9_.SetAsOrientedBox(_loc5_ * 0.5 / m_physScale,_loc4_ * 0.5 / m_physScale,new b2Vec2(0,-(_loc6_ - _loc4_) / 2 / m_physScale),0);
            this.padShape = this.body.CreateShape(_loc9_);
            this.body.SetMassFromShapes();
            _loc9_.filter.groupIndex = 0;
            _loc9_.SetAsOrientedBox(_loc7_ * 0.5 / m_physScale,_loc6_ * 0.5 / m_physScale,this.body.GetWorldPoint(new b2Vec2(0,0)),param2);
            Settings.currentSession.level.levelBody.CreateShape(_loc9_);
            var _loc10_:Number = _loc6_ - _loc4_;
            _loc8_ = new b2BodyDef();
            _loc8_.position = this.body.GetWorldPoint(new b2Vec2(0,(_loc6_ / 2 - _loc10_ / 2) / m_physScale));
            _loc8_.angle = param2;
            _loc9_ = new b2PolygonDef();
            _loc9_.density = 0;
            _loc9_.friction = 0.5;
            _loc9_.restitution = 0.1;
            _loc9_.filter.categoryBits = 8;
            _loc9_.filter.groupIndex = _loc3_;
            _loc9_.SetAsBox(_loc7_ * 0.75 / 2 / m_physScale,_loc10_ / 2 / m_physScale);
            var _loc11_:b2Body = Settings.currentSession.m_world.CreateBody(_loc8_);
            this.blockerShape = _loc11_.CreateShape(_loc9_);
        }
        
        internal function createJoint() : void
        {
            var _loc1_:b2RevoluteJointDef = new b2RevoluteJointDef();
            var _loc2_:int = 30;
            var _loc3_:int = 332;
            var _loc4_:int = 40;
            var _loc5_:b2Vec2 = new b2Vec2(this.direction * (_loc3_ / 2 - _loc2_ / 2) / m_physScale,-(_loc4_ - _loc2_) / 2 / m_physScale);
            _loc1_.Initialize(Settings.currentSession.level.levelBody,this.body,this.body.GetWorldPoint(_loc5_));
            _loc1_.enableLimit = true;
            _loc1_.upperAngle = 0;
            _loc1_.lowerAngle = 0;
            _loc1_.enableMotor = false;
            _loc1_.maxMotorTorque = 1000000;
            this.joint = Settings.currentSession.m_world.CreateJoint(_loc1_) as b2RevoluteJoint;
        }
        
        override public function paint() : void
        {
            if(this.body.IsSleeping())
            {
                return;
            }
            var _loc1_:b2Vec2 = this.body.GetWorldCenter();
            this.paddle.x = _loc1_.x * m_physScale;
            this.paddle.y = _loc1_.y * m_physScale;
            this.paddle.rotation = this.body.GetAngle() * 180 / Math.PI;
        }
        
        private function checkRevJoint() : void
        {
            var _loc1_:* = undefined;
            var _loc2_:* = undefined;
            var _loc3_:Number = NaN;
            var _loc4_:Number = NaN;
            var _loc5_:Number = NaN;
            if(Boolean(this.joint) && !this.joint.broken)
            {
                _loc1_ = this.joint.GetAnchor1();
                _loc2_ = this.joint.GetAnchor2();
                _loc3_ = _loc2_.x - _loc1_.x;
                _loc4_ = _loc2_.y - _loc1_.y;
                _loc5_ = _loc3_ * _loc3_ + _loc4_ * _loc4_;
                if(_loc5_ > 0.43)
                {
                    this.breakJoint();
                }
            }
        }
        
        private function breakJoint() : void
        {
            Settings.currentSession.particleController.createSparkBurstPoint(this.joint.GetAnchor1(),new b2Vec2(1,1),50,80,100);
            Settings.currentSession.particleController.createBurst("metalpieces",10,50,this.body,25);
            Settings.currentSession.m_world.DestroyJoint(this.joint);
            this.joint.broken = true;
            this.paddle.arrow.glow.visible = true;
            Settings.currentSession.level.removeFromActionsVector(this);
            var _loc1_:ColorTransform = this.timerText.transform.colorTransform;
            _loc1_.color = 16711680;
            this.timerText.transform.colorTransform = _loc1_;
            this.timerText.alpha = 0.5;
            this.padShape.m_density = 10;
            this.body.SetMassFromShapes();
            this.paddle.arrow.glow.visible = false;
            SoundController.instance.playAreaSoundInstance("PaddleBreak",this.body);
        }
        
        override public function actions() : void
        {
            var _loc1_:Number = NaN;
            if(this.hit)
            {
                if(this.delayCounter == 0)
                {
                    this.glow.visible = true;
                    this.hit = false;
                    this.body.WakeUp();
                    this.body.SetBullet(true);
                    this.joint.SetMotorSpeed(this.direction * this.paddleSpeed);
                    if(this.direction == -1)
                    {
                        this.joint.SetLimits(-90 * Math.PI / 180,0);
                    }
                    else
                    {
                        this.joint.SetLimits(0,90 * Math.PI / 180);
                    }
                    this.joint.EnableMotor(true);
                    this.delayCounter = this.delayTotal;
                    this.timerText.text = "0.00";
                    SoundController.instance.playAreaSoundInstance("SpringBoxBounce",this.body);
                }
                else
                {
                    _loc1_ = this.delayCounter / 30;
                    this.timerText.text = _loc1_.toFixed(2);
                    --this.delayCounter;
                }
            }
            else if(this.joint.IsMotorEnabled())
            {
                this.checkRevJoint();
                if(this.joint.GetMotorSpeed() > 0 && this.direction == 1 || this.joint.GetMotorSpeed() < 0 && this.direction == -1)
                {
                    if(this.direction == 1)
                    {
                        if(this.joint.GetJointAngle() > this.tarAng)
                        {
                            this.joint.SetMotorSpeed(-2);
                        }
                    }
                    else if(this.joint.GetJointAngle() < this.tarAng)
                    {
                        this.joint.SetMotorSpeed(2);
                    }
                }
                else if(this.joint.GetMotorSpeed() < 0 && this.direction == 1 || this.joint.GetMotorSpeed() > 0 && this.direction == -1)
                {
                    if(this.joint.GetJointAngle() < 0 && this.direction == 1 || this.joint.GetJointAngle() > 0 && this.direction == -1)
                    {
                        this.joint.EnableMotor(false);
                        this.joint.SetLimits(0,0);
                        this.joint.SetMotorSpeed(0);
                        this.body.SetBullet(false);
                        Settings.currentSession.contactListener.registerListener(ContactEvent.RESULT,this.padShape,this.checkContact);
                        this.timerText.text = this.delayTimeString;
                        this.glow.visible = false;
                    }
                }
            }
        }
        
        protected function checkContact(param1:ContactEvent) : void
        {
            if(param1.otherShape == this.blockerShape)
            {
                return;
            }
            Settings.currentSession.contactListener.deleteListener(ContactEvent.RESULT,this.padShape);
            this.hit = true;
        }
    }
}

