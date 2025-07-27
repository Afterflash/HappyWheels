package com.totaljerkface.game.level.userspecials
{
    import Box2D.Collision.Shapes.b2CircleDef;
    import Box2D.Collision.Shapes.b2PolygonDef;
    import Box2D.Collision.Shapes.b2Shape;
    import Box2D.Collision.b2ContactPoint;
    import Box2D.Common.Math.b2Mat22;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.Joints.b2RevoluteJoint;
    import Box2D.Dynamics.Joints.b2RevoluteJointDef;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2World;
    import com.totaljerkface.game.ContactListener;
    import com.totaljerkface.game.Settings;
    import com.totaljerkface.game.editor.specials.CannonRef;
    import com.totaljerkface.game.editor.specials.Special;
    import com.totaljerkface.game.level.LevelB2D;
    import com.totaljerkface.game.level.LevelItem;
    import com.totaljerkface.game.sound.SoundController;
    import flash.display.*;
    import flash.geom.Point;
    import flash.utils.Dictionary;
    
    public class Cannon extends LevelItem
    {
        public static const WAITING:String = "waiting";
        
        public static const LOADING:String = "loading";
        
        public static const AIMING:String = "aiming";
        
        public static const RETURNING:String = "returning";
        
        public static const FIRING:String = "firing";
        
        private var state:String;
        
        private var _muzzleBody:b2Body;
        
        private var _baseBody:b2Body;
        
        private var _sensor:b2Shape;
        
        private var _muzzleMC:MovieClip;
        
        private var _baseMC:MovieClip;
        
        private var _muzzleJoint:b2RevoluteJoint;
        
        private var _bodiesInCannonDict:Dictionary = new Dictionary(true);
        
        private var _frameCounter:int = 0;
        
        private var _loadingFrameCount:int;
        
        private var _firingFrameCount:int = 5;
        
        private var _startAngle:Number;
        
        private var _firingAngle:Number;
        
        private var _power:Number;
        
        private var _maxTorque:int = 10000;
        
        private var PIOverOneEighty:Number = 0.017453292519943295;
        
        private var _muzzleMovementSpeed:Number = 0.6;
        
        private var _showStar:Boolean = true;
        
        public function Cannon(param1:Special, param2:b2Body = null, param3:Point = null)
        {
            super();
            var _loc4_:CannonRef = param1 as CannonRef;
            this._showStar = _loc4_.cannonType == 1;
            this.createBodies(_loc4_);
            this.createJoints(_loc4_);
            this.state = WAITING;
            this._bodiesInCannonDict = new Dictionary(true);
            this._power = 1.5 + _loc4_.cannonPower / 10 * 4;
            this._loadingFrameCount = _loc4_.cannonDelay * 30;
            this._startAngle = _loc4_.startRotation * this.PIOverOneEighty;
            this._firingAngle = _loc4_.firingRotation * this.PIOverOneEighty;
        }
        
        private function createBodies(param1:CannonRef) : void
        {
            var _loc3_:b2World = null;
            var _loc5_:Sprite = null;
            var _loc6_:MovieClip = null;
            var _loc7_:MovieClip = null;
            var _loc8_:MovieClip = null;
            var _loc9_:Number = NaN;
            var _loc10_:Number = NaN;
            var _loc15_:MovieClip = null;
            var _loc16_:b2Shape = null;
            var _loc21_:int = 0;
            var _loc22_:b2Vec2 = null;
            var _loc2_:LevelB2D = Settings.currentSession.level;
            _loc3_ = Settings.currentSession.m_world;
            var _loc4_:Sprite = _loc2_.background;
            _loc5_ = _loc2_.foreground;
            _loc6_ = this._muzzleMC = new CannonMuzzleMC();
            _loc7_ = this._baseMC = new CannonBaseMC();
            this._baseMC.gotoAndStop(param1.cannonType);
            this._muzzleMC.gotoAndStop(param1.cannonType);
            if(this._showStar)
            {
                this._baseMC.star.gotoAndStop(1);
            }
            this._baseMC.meter.bar.visible = 0;
            _loc8_ = new CannonShapesRefMC();
            _loc9_ = 1 + param1.muzzleScale / 20;
            _loc10_ = param1.rotation * this.PIOverOneEighty;
            _loc6_.x = param1.x;
            _loc6_.y = param1.y;
            _loc7_.x = param1.x;
            _loc7_.y = param1.y;
            _loc6_.scaleX = _loc6_.scaleY = _loc9_;
            _loc6_.rotation = param1.rotation + param1.startRotation;
            _loc7_.rotation = param1.rotation;
            _loc5_.addChild(_loc6_);
            _loc5_.addChild(_loc7_);
            var _loc11_:b2PolygonDef = new b2PolygonDef();
            _loc11_.friction = 0.5;
            _loc11_.restitution = 0.1;
            _loc11_.filter.categoryBits = 8;
            _loc11_.density = 1;
            _loc11_.vertexCount = 4;
            var _loc12_:b2CircleDef = new b2CircleDef();
            _loc12_.friction = 0.5;
            _loc12_.restitution = 0.1;
            _loc12_.filter.categoryBits = 8;
            _loc12_.density = 1;
            _loc12_.radius = _loc8_.base.width / 2 / m_physScale * _loc9_;
            var _loc13_:b2BodyDef = new b2BodyDef();
            _loc13_.position = new b2Vec2(param1.x / m_physScale,param1.y / m_physScale);
            _loc13_.angle = param1.startRotation * this.PIOverOneEighty + _loc10_;
            _loc13_.allowSleep = false;
            var _loc14_:b2Body = this._muzzleBody = _loc3_.CreateBody(_loc13_);
            _loc14_.CreateShape(_loc12_);
            var _loc17_:int = 0;
            while(_loc17_ < 2)
            {
                _loc21_ = 0;
                while(_loc21_ < 4)
                {
                    _loc15_ = _loc8_["p" + _loc17_ + "_" + _loc21_];
                    _loc11_.vertices[_loc21_] = new b2Vec2(_loc15_.x / m_physScale * _loc9_,_loc15_.y / m_physScale * _loc9_);
                    _loc21_++;
                }
                _loc14_.CreateShape(_loc11_);
                _loc17_++;
            }
            _loc11_.vertices[0] = new b2Vec2(_loc8_.p0_1.x / m_physScale * _loc9_,_loc8_.p0_1.y / m_physScale * _loc9_);
            _loc11_.vertices[1] = new b2Vec2(_loc8_.p1_0.x / m_physScale * _loc9_,_loc8_.p1_0.y / m_physScale * _loc9_);
            _loc11_.vertices[2] = new b2Vec2(_loc8_.p1_3.x / m_physScale * _loc9_,_loc8_.p1_3.y / m_physScale * _loc9_);
            _loc11_.vertices[3] = new b2Vec2(_loc8_.p0_2.x / m_physScale * _loc9_,_loc8_.p0_2.y / m_physScale * _loc9_);
            _loc11_.isSensor = true;
            _loc11_.density = 1e-7;
            _loc11_.filter.categoryBits = 8;
            this._sensor = _loc14_.CreateShape(_loc11_);
            var _loc18_:ContactListener = Settings.currentSession.contactListener;
            _loc18_.registerListener(ContactListener.ADD,this._sensor,this.checkAdd);
            _loc18_.registerListener(ContactListener.REMOVE,this._sensor,this.checkRemove);
            _loc14_.SetMassFromShapes();
            _loc2_.paintItemVector.push(this);
            _loc21_ = 0;
            while(_loc21_ < 4)
            {
                _loc15_ = _loc8_["base" + _loc21_];
                _loc11_.vertices[_loc21_] = new b2Vec2(_loc15_.x / m_physScale,_loc15_.y / m_physScale);
                _loc21_++;
            }
            _loc11_.density = 0;
            var _loc19_:b2Mat22 = new b2Mat22(_loc10_);
            var _loc20_:b2Vec2 = new b2Vec2(param1.x / m_physScale,param1.y / m_physScale);
            _loc21_ = 0;
            while(_loc21_ < _loc11_.vertexCount)
            {
                _loc22_ = _loc11_.vertices[_loc21_];
                _loc22_.MulM(_loc19_);
                _loc22_.Add(_loc20_);
                _loc21_++;
            }
            Settings.currentSession.level.levelBody.CreateShape(_loc11_);
            Settings.currentSession.level.actionsVector.push(this);
        }
        
        override public function actions() : void
        {
            var _loc1_:int = 0;
            var _loc2_:int = 0;
            if(this.state == LOADING)
            {
                if(++this._frameCounter == this._loadingFrameCount)
                {
                    this._frameCounter = 0;
                    this._baseMC.meter.bar.scaleX = 1;
                    this.moveMuzzleToFire();
                }
                else
                {
                    this._baseMC.meter.bar.scaleX = this._frameCounter / this._loadingFrameCount;
                }
            }
            else if(this.state == AIMING)
            {
                for each(_loc2_ in this._bodiesInCannonDict)
                {
                    _loc1_ += _loc2_;
                }
                if(_loc1_ == 0)
                {
                    this.moveMuzzleToStart();
                }
                else if(Math.abs(this._firingAngle - this._startAngle - this._muzzleJoint.GetJointAngle()) <= this.PIOverOneEighty)
                {
                    this.fireCannon();
                    if(this._showStar)
                    {
                        this._baseMC.star.stop();
                    }
                }
            }
            else if(this.state == FIRING)
            {
                if(++this._frameCounter == this._firingFrameCount)
                {
                    this._frameCounter = 0;
                    this.moveMuzzleToStart();
                }
            }
            else if(this.state == RETURNING)
            {
                if(Math.abs(this._muzzleJoint.GetJointAngle()) <= this.PIOverOneEighty)
                {
                    this.setWaitState();
                }
            }
        }
        
        private function setWaitState() : *
        {
            this.state = WAITING;
            this._muzzleJoint.EnableMotor(false);
            this._muzzleJoint.m_upperAngle = this._muzzleJoint.m_lowerAngle = 0;
        }
        
        private function moveMuzzleToFire() : *
        {
            var _loc1_:Number = NaN;
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            this.state = AIMING;
            if(this._startAngle < this._firingAngle)
            {
                _loc3_ = this._muzzleMovementSpeed;
                _loc2_ = 0;
                _loc1_ = this._firingAngle - this._startAngle;
            }
            else
            {
                _loc3_ = -this._muzzleMovementSpeed;
                _loc2_ = this._firingAngle - this._startAngle;
                _loc1_ = 0;
            }
            this._muzzleJoint.m_upperAngle = _loc1_;
            this._muzzleJoint.m_lowerAngle = _loc2_;
            this._muzzleJoint.EnableLimit(true);
            this._muzzleJoint.EnableMotor(true);
            this._muzzleJoint.SetMaxMotorTorque(this._maxTorque);
            this._muzzleJoint.SetMotorSpeed(_loc3_);
        }
        
        private function moveMuzzleToStart() : *
        {
            this._baseMC.meter.bar.scaleX = 0;
            this.state = RETURNING;
            var _loc1_:Number = this._startAngle < this._firingAngle ? -this._muzzleMovementSpeed : this._muzzleMovementSpeed;
            this._muzzleJoint.SetMotorSpeed(_loc1_);
        }
        
        private function fireCannon() : *
        {
            var _loc1_:MovieClip = null;
            var _loc2_:Object = null;
            var _loc3_:b2Body = null;
            var _loc4_:Number = NaN;
            var _loc5_:Number = NaN;
            var _loc6_:Number = NaN;
            var _loc7_:Number = NaN;
            var _loc8_:b2Vec2 = null;
            _loc1_ = new MuzzleFlare();
            _loc1_.rotation = this._muzzleMC.rotation;
            _loc1_.x = this._muzzleMC.x;
            _loc1_.y = this._muzzleMC.y;
            _loc1_.scaleX = _loc1_.scaleY = this._muzzleMC.scaleX;
            Settings.currentSession.containerSprite.addChildAt(_loc1_,1);
            this.state = FIRING;
            for(_loc2_ in this._bodiesInCannonDict)
            {
                _loc3_ = _loc2_ as b2Body;
                _loc4_ = _loc3_.GetMass();
                _loc5_ = this._muzzleBody.GetAngle();
                _loc6_ = Math.sin(_loc5_);
                _loc7_ = Math.cos(_loc5_);
                _loc8_ = _loc3_.GetWorldCenter();
                _loc3_.ApplyImpulse(new b2Vec2(_loc6_ * (this._power * _loc4_ * 10),_loc7_ * -(this._power * _loc4_ * 10)),_loc8_);
            }
            SoundController.instance.playAreaSoundInstance("Cannon1",this._muzzleBody);
        }
        
        private function checkAdd(param1:b2ContactPoint) : void
        {
            var _loc2_:b2Body = param1.shape2.GetBody();
            if(this._bodiesInCannonDict[_loc2_] == null)
            {
                this._bodiesInCannonDict[_loc2_] = 1;
            }
            else
            {
                this._bodiesInCannonDict[_loc2_] += 1;
            }
            if(this.state == WAITING)
            {
                this.state = LOADING;
                if(this._showStar)
                {
                    this._baseMC.star.play();
                }
                this._baseMC.meter.bar.visible = 1;
                this._baseMC.meter.bar.scaleX = 0;
            }
        }
        
        private function checkRemove(param1:b2ContactPoint) : void
        {
            var _loc2_:b2Body = param1.shape2.GetBody();
            if(this._bodiesInCannonDict[_loc2_] == null)
            {
                trace("ERROR: something is horribly wrong because you should never have more removes than adds!!!");
            }
            this._bodiesInCannonDict[_loc2_] = Number(this._bodiesInCannonDict[_loc2_]) - 1;
            if(this._bodiesInCannonDict[_loc2_] == 0)
            {
                delete this._bodiesInCannonDict[_loc2_];
            }
        }
        
        private function createJoints(param1:CannonRef) : void
        {
            var _loc2_:b2RevoluteJointDef = new b2RevoluteJointDef();
            _loc2_.Initialize(Settings.currentSession.level.levelBody,this._muzzleBody,new b2Vec2(param1.x / m_physScale,param1.y / m_physScale));
            _loc2_.enableLimit = true;
            _loc2_.upperAngle = 0;
            _loc2_.lowerAngle = 0;
            this._muzzleJoint = Settings.currentSession.m_world.CreateJoint(_loc2_) as b2RevoluteJoint;
        }
        
        override public function paint() : void
        {
            var _loc1_:b2Vec2 = this._muzzleBody.GetWorldPoint(new b2Vec2(0,2 / m_physScale));
            this._muzzleMC.x = _loc1_.x * m_physScale;
            this._muzzleMC.y = _loc1_.y * m_physScale;
            this._muzzleMC.rotation = this._muzzleBody.GetAngle() * oneEightyOverPI % 360;
        }
    }
}

