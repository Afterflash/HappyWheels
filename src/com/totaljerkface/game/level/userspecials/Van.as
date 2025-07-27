package com.totaljerkface.game.level.userspecials
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Collision.b2ContactPoint;
    import Box2D.Common.Math.b2Math;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.editor.specials.Special;
    import com.totaljerkface.game.editor.specials.VanRef;
    import com.totaljerkface.game.events.*;
    import com.totaljerkface.game.level.*;
    import com.totaljerkface.game.sound.SoundController;
    import flash.display.*;
    import flash.geom.Point;
    
    public class Van extends LevelItem
    {
        private var vanMC:MovieClip;
        
        private var lTireMC:Sprite;
        
        private var rTireMC:Sprite;
        
        private var vanBody:b2Body;
        
        private var lTireBody:b2Body;
        
        private var rTireBody:b2Body;
        
        private var vanShape:b2Shape;
        
        private var lTireShape:b2Shape;
        
        private var rTireShape:b2Shape;
        
        private var leftJoint:b2RevoluteJoint;
        
        private var rightJoint:b2RevoluteJoint;
        
        private var hit:Boolean;
        
        public function Van(param1:Special, param2:b2Body = null, param3:Point = null)
        {
            var _loc5_:ContactListener = null;
            super();
            var _loc4_:VanRef = param1 as VanRef;
            this.createMovieClips(_loc4_);
            trace("VANREF " + _loc4_.interactive);
            if(_loc4_.interactive)
            {
                this.createBody(new b2Vec2(_loc4_.x,_loc4_.y),_loc4_.rotation * Math.PI / 180,_loc4_.sleeping);
                this.createJoints();
                _loc5_ = Settings.currentSession.contactListener;
                _loc5_.registerListener(ContactListener.RESULT,this.vanShape,this.checkContact);
                _loc5_.registerListener(ContactListener.ADD,this.vanShape,this.vanAddContact);
                _loc5_.registerListener(ContactListener.ADD,this.lTireShape,this.tireAddContact);
                _loc5_.registerListener(ContactListener.ADD,this.rTireShape,this.tireAddContact);
            }
        }
        
        private function createBody(param1:b2Vec2, param2:Number, param3:Boolean = false) : void
        {
            var _loc4_:b2BodyDef = null;
            trace("rot2 " + param2);
            _loc4_ = new b2BodyDef();
            _loc4_.position.Set(param1.x / m_physScale,param1.y / m_physScale);
            _loc4_.angle = param2;
            _loc4_.isSleeping = param3;
            var _loc5_:b2World = Settings.currentSession.m_world;
            this.vanBody = _loc5_.CreateBody(_loc4_);
            var _loc6_:b2PolygonDef = new b2PolygonDef();
            _loc6_.density = 10;
            _loc6_.friction = 0.3;
            _loc6_.restitution = 0.1;
            _loc6_.filter.categoryBits = 8;
            _loc6_.SetAsBox(66 / m_physScale,58 / m_physScale);
            this.vanShape = this.vanBody.CreateShape(_loc6_);
            this.vanBody.SetMassFromShapes();
            _loc4_.position = this.vanBody.GetWorldPoint(new b2Vec2(-58 / m_physScale,48 / m_physScale));
            this.lTireBody = _loc5_.CreateBody(_loc4_);
            _loc6_.friction = 1;
            _loc6_.restitution = 0.3;
            _loc6_.SetAsBox(10 / m_physScale,22.5 / m_physScale);
            this.lTireShape = this.lTireBody.CreateShape(_loc6_);
            this.lTireBody.SetMassFromShapes();
            _loc4_.position = this.vanBody.GetWorldPoint(new b2Vec2(58 / m_physScale,48 / m_physScale));
            this.rTireBody = _loc5_.CreateBody(_loc4_);
            this.rTireShape = this.rTireBody.CreateShape(_loc6_);
            this.rTireBody.SetMassFromShapes();
            Settings.currentSession.level.paintItemVector.push(this);
        }
        
        private function createJoints() : void
        {
            var _loc1_:b2RevoluteJointDef = new b2RevoluteJointDef();
            var _loc2_:b2Vec2 = new b2Vec2();
            _loc1_.enableLimit = true;
            _loc1_.upperAngle = 0;
            _loc1_.lowerAngle = 0;
            _loc2_ = this.lTireBody.GetWorldCenter();
            _loc1_.Initialize(this.vanBody,this.lTireBody,_loc2_);
            var _loc3_:b2World = Settings.currentSession.m_world;
            this.leftJoint = _loc3_.CreateJoint(_loc1_) as b2RevoluteJoint;
            _loc2_ = this.rTireBody.GetWorldCenter();
            _loc1_.Initialize(this.vanBody,this.rTireBody,_loc2_);
            this.rightJoint = _loc3_.CreateJoint(_loc1_) as b2RevoluteJoint;
        }
        
        private function createMovieClips(param1:VanRef) : void
        {
            this.vanMC = new VanBodyMC();
            this.vanMC.x = param1.x;
            this.vanMC.y = param1.y;
            this.vanMC.rotation = param1.rotation;
            this.lTireMC = new VanTireMC();
            this.rTireMC = new VanTireMC();
            var _loc2_:Sprite = Settings.currentSession.level.background;
            _loc2_.addChild(this.lTireMC);
            _loc2_.addChild(this.rTireMC);
            _loc2_.addChild(this.vanMC);
            if(!param1.interactive)
            {
                this.vanMC.addChildAt(this.lTireMC,0);
                this.vanMC.addChildAt(this.rTireMC,0);
                this.lTireMC.x = -58;
                this.rTireMC.x = 58;
                this.lTireMC.y = this.rTireMC.y = 48;
            }
        }
        
        override public function paint() : void
        {
            var _loc1_:b2Vec2 = this.vanBody.GetWorldCenter();
            this.vanMC.x = _loc1_.x * m_physScale;
            this.vanMC.y = _loc1_.y * m_physScale;
            this.vanMC.rotation = this.vanBody.GetAngle() * oneEightyOverPI % 360;
            _loc1_ = this.lTireBody.GetWorldCenter();
            this.lTireMC.x = _loc1_.x * m_physScale;
            this.lTireMC.y = _loc1_.y * m_physScale;
            this.lTireMC.rotation = this.lTireBody.GetAngle() * oneEightyOverPI % 360;
            _loc1_ = this.rTireBody.GetWorldCenter();
            this.rTireMC.x = _loc1_.x * m_physScale;
            this.rTireMC.y = _loc1_.y * m_physScale;
            this.rTireMC.rotation = this.rTireBody.GetAngle() * oneEightyOverPI % 360;
        }
        
        private function checkContact(param1:ContactEvent) : void
        {
            if(param1.impulse > 150)
            {
                trace("van impulse " + param1.impulse);
                Settings.currentSession.contactListener.deleteListener(ContactEvent.RESULT,this.vanShape);
                Settings.currentSession.contactListener.deleteListener(ContactEvent.ADD,this.vanShape);
                Settings.currentSession.level.actionsVector.push(this);
            }
        }
        
        override public function actions() : void
        {
            Settings.currentSession.level.removeFromActionsVector(this);
            this.vanBody.DestroyShape(this.vanBody.m_shapeList);
            var _loc1_:b2PolygonDef = new b2PolygonDef();
            _loc1_.density = 10;
            _loc1_.friction = 0.3;
            _loc1_.restitution = 0.1;
            _loc1_.filter.categoryBits = 8;
            _loc1_.SetAsBox(66 / m_physScale,52.5 / m_physScale);
            this.vanBody.CreateShape(_loc1_);
            this.vanBody.SetMassFromShapes();
            this.vanMC.gotoAndStop(3);
            var _loc2_:b2World = Settings.currentSession.m_world;
            _loc2_.DestroyJoint(this.leftJoint);
            _loc2_.DestroyJoint(this.rightJoint);
            Settings.currentSession.particleController.createBurst("vanglass",50,30,this.vanBody,20,-1);
            SoundController.instance.playAreaSoundInstance("VanSmash",this.vanBody);
        }
        
        private function vanAddContact(param1:b2ContactPoint) : void
        {
            if(param1.shape2.m_isSensor)
            {
                return;
            }
            var _loc2_:Number = param1.shape2.m_body.m_mass;
            if(_loc2_ != 0 && _loc2_ < this.vanBody.m_mass)
            {
                return;
            }
            var _loc3_:Number = b2Math.b2Dot(param1.velocity,param1.normal);
            _loc3_ = Math.abs(_loc3_);
            if(_loc3_ > 4)
            {
                SoundController.instance.playAreaSoundInstance("VanHit",this.vanBody);
            }
        }
        
        private function tireAddContact(param1:b2ContactPoint) : void
        {
            if(param1.shape2.m_isSensor)
            {
                return;
            }
            var _loc2_:Number = param1.shape2.m_body.m_mass;
            var _loc3_:b2Body = param1.shape1.m_body;
            if(_loc2_ != 0 && _loc2_ < _loc3_.m_mass)
            {
                return;
            }
            var _loc4_:Number = b2Math.b2Dot(param1.velocity,param1.normal);
            _loc4_ = Math.abs(_loc4_);
            if(_loc4_ > 4)
            {
                SoundController.instance.playAreaSoundInstance("CarTire1",_loc3_);
            }
        }
        
        override public function getJointBody(param1:b2Vec2 = null) : b2Body
        {
            var _loc3_:b2Body = null;
            var _loc6_:b2Body = null;
            var _loc7_:b2Vec2 = null;
            var _loc8_:b2Vec2 = null;
            var _loc9_:* = undefined;
            var _loc2_:Number = 10000000;
            var _loc4_:Array = [this.vanBody,this.lTireBody,this.rTireBody];
            var _loc5_:int = 0;
            while(_loc5_ < _loc4_.length)
            {
                _loc6_ = _loc4_[_loc5_];
                _loc7_ = _loc6_.GetWorldCenter();
                _loc8_ = new b2Vec2(param1.x - _loc7_.x,param1.y - _loc7_.y);
                _loc9_ = _loc8_.x * _loc8_.x + _loc8_.y * _loc8_.y;
                if(_loc9_ < _loc2_)
                {
                    _loc2_ = _loc9_;
                    _loc3_ = _loc6_;
                }
                _loc5_++;
            }
            return _loc3_;
        }
        
        override public function get groupDisplayObject() : DisplayObject
        {
            return this.vanMC;
        }
        
        override public function triggerSingleActivation(param1:Trigger, param2:String, param3:Array) : void
        {
            var _loc4_:Number = NaN;
            var _loc5_:Number = NaN;
            var _loc6_:Number = NaN;
            var _loc7_:Number = NaN;
            var _loc8_:Number = NaN;
            if(param2 == "wake from sleep")
            {
                if(this.vanBody)
                {
                    this.vanBody.WakeUp();
                }
            }
            else if(param2 == "apply impulse")
            {
                if(this.vanBody)
                {
                    _loc4_ = Number(param3[0]);
                    _loc5_ = Number(param3[1]);
                    _loc6_ = this.vanBody.GetMass();
                    this.vanBody.ApplyImpulse(new b2Vec2(_loc4_ * _loc6_,_loc5_ * _loc6_),this.vanBody.GetWorldCenter());
                    _loc7_ = Number(param3[2]);
                    _loc8_ = this.vanBody.GetAngularVelocity();
                    this.vanBody.SetAngularVelocity(_loc8_ + _loc7_);
                }
            }
        }
        
        override public function get bodyList() : Array
        {
            if(this.vanBody)
            {
                return [this.vanBody];
            }
            return [];
        }
    }
}

