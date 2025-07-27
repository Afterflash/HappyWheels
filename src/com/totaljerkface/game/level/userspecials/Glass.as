package com.totaljerkface.game.level.userspecials
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Collision.b2ContactPoint;
    import Box2D.Common.Math.b2Math;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.*;
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.editor.specials.*;
    import com.totaljerkface.game.events.*;
    import com.totaljerkface.game.level.*;
    import com.totaljerkface.game.sound.SoundController;
    import flash.display.*;
    
    public class Glass extends LevelItem
    {
        private var mc:Sprite;
        
        private var body:b2Body;
        
        private var shapeWidth:Number;
        
        private var shapeHeight:Number;
        
        private var smashImpulse:int;
        
        private var glassParticles:int;
        
        private var soundSuffix:String;
        
        private var impactPosition:b2Vec2;
        
        private var center:b2Vec2;
        
        private var angle:Number;
        
        private var shape:b2PolygonShape;
        
        private var stabbing:Boolean;
        
        private var leftX:Number;
        
        private var rightX:Number;
        
        private var topY:Number;
        
        private var bottomY:Number;
        
        private var allSides:Array;
        
        private var triggerLocation:b2Vec2;
        
        private const minDistEdge:Number = 0.05;
        
        public function Glass(param1:Special)
        {
            super();
            var _loc2_:GlassRef = param1 as GlassRef;
            this.createBody(new b2Vec2(_loc2_.x,_loc2_.y),_loc2_.rotation * Math.PI / 180,_loc2_.shapeWidth,_loc2_.shapeHeight,_loc2_.sleeping,_loc2_.shatterStrength);
            this.shapeWidth = _loc2_.shapeWidth;
            this.shapeHeight = _loc2_.shapeHeight;
            this.stabbing = _loc2_.stabbing;
            this.mc = new Sprite();
            this.mc.graphics.beginFill(6737151,0.35);
            this.mc.graphics.drawRect(-50,-50,100,100);
            this.mc.graphics.endFill();
            this.mc.width = _loc2_.shapeWidth;
            this.mc.height = _loc2_.shapeHeight;
            this.mc.x = _loc2_.x;
            this.mc.y = _loc2_.y;
            this.mc.rotation = _loc2_.rotation;
            var _loc3_:Sprite = Settings.currentSession.level.background;
            _loc3_.addChild(this.mc);
            this.body.SetUserData(this.mc);
            Settings.currentSession.particleController.createBMDArray("glass",new GlassShardsMC());
        }
        
        internal function createBody(param1:b2Vec2, param2:Number, param3:Number, param4:Number, param5:Boolean, param6:int) : void
        {
            var _loc7_:b2BodyDef = new b2BodyDef();
            var _loc8_:b2PolygonDef = new b2PolygonDef();
            _loc8_.density = 2;
            _loc8_.friction = 0.3;
            _loc8_.restitution = 0.1;
            _loc8_.filter.categoryBits = 8;
            var _loc9_:LevelB2D = Settings.currentSession.level;
            _loc8_.SetAsBox(param3 * 0.5 / m_physScale,param4 * 0.5 / m_physScale);
            _loc7_.position.Set(param1.x / m_physScale,param1.y / m_physScale);
            _loc7_.angle = param2;
            _loc7_.isSleeping = param5;
            this.body = Settings.currentSession.m_world.CreateBody(_loc7_);
            this.shape = this.body.CreateShape(_loc8_) as b2PolygonShape;
            this.body.SetMassFromShapes();
            _loc9_.paintBodyVector.push(this.body);
            Settings.currentSession.contactListener.registerListener(ContactListener.ADD,this.shape,this.checkAdd);
            var _loc10_:Number = this.body.GetMass();
            var _loc11_:Number = 0.128;
            var _loc12_:Number = 12.8;
            var _loc13_:Number = _loc12_ - _loc11_;
            var _loc14_:Number = (_loc10_ - _loc11_) / _loc13_;
            if(_loc10_ < 0.75)
            {
                this.soundSuffix = "Light";
                this.glassParticles = 100;
            }
            else if(_loc10_ < 4)
            {
                this.soundSuffix = "Mid";
                this.glassParticles = 150;
            }
            else
            {
                this.soundSuffix = "Heavy";
                this.glassParticles = 200;
            }
            this.smashImpulse = Math.round(_loc10_ * param6);
            var _loc15_:Array = this.shape.GetVertices();
            this.leftX = _loc15_[0].x;
            this.rightX = _loc15_[1].x;
            this.topY = _loc15_[0].y;
            this.bottomY = _loc15_[2].y;
            var _loc16_:Array = [[this.leftX,this.topY],[0,this.topY],[this.rightX,this.topY]];
            var _loc17_:Array = [[this.rightX,this.topY],[this.rightX,0],[this.rightX,this.bottomY]];
            var _loc18_:Array = [[this.rightX,this.bottomY],[0,this.bottomY],[this.leftX,this.bottomY]];
            var _loc19_:Array = [[this.leftX,this.bottomY],[this.leftX,0],[this.leftX,this.topY]];
            this.allSides = [_loc16_,_loc17_,_loc18_,_loc19_];
            Settings.currentSession.contactListener.registerListener(ContactListener.RESULT,this.shape,this.checkContact);
        }
        
        override public function singleAction() : void
        {
            var _loc1_:Session = Settings.currentSession;
            if(_loc1_.version < 1.36)
            {
                this.shatterOld();
                return;
            }
            this.shatter();
        }
        
        private function shatterOld() : void
        {
            var _loc16_:Array = null;
            var _loc17_:int = 0;
            var _loc18_:b2Body = null;
            var _loc19_:b2Vec2 = null;
            var _loc20_:b2Vec2 = null;
            var _loc21_:b2Vec2 = null;
            var _loc22_:Sprite = null;
            var _loc23_:Sprite = null;
            var _loc24_:GlassShard = null;
            var _loc1_:Session = Settings.currentSession;
            var _loc2_:LevelB2D = _loc1_.level;
            var _loc3_:b2World = _loc1_.m_world;
            var _loc4_:Number = Math.ceil(Math.random() * 2);
            Settings.currentSession.particleController.createRectBurst("glass",10,this.body,this.glassParticles);
            SoundController.instance.playAreaSoundInstance("Glass" + this.soundSuffix + _loc4_,this.body);
            _loc2_.removeFromPaintBodyVector(this.body);
            if(this.body.GetMass() < 0.75)
            {
                _loc3_.DestroyBody(this.body);
                this.mc.parent.removeChild(this.mc);
                return;
            }
            var _loc5_:b2Vec2 = this.body.GetWorldCenter();
            var _loc6_:b2Vec2 = this.body.GetLinearVelocity();
            var _loc7_:Number = this.body.GetAngularVelocity();
            _loc3_.DestroyBody(this.body);
            var _loc8_:Number = this.body.GetAngle();
            var _loc9_:int = 0;
            if(this.impactPosition.x - (this.leftX + this.minDistEdge) <= 0)
            {
                this.impactPosition.x = this.leftX;
                this.allSides[3] = null;
                _loc9_ += 1;
            }
            else if(this.impactPosition.x - (this.rightX - this.minDistEdge) >= 0)
            {
                this.impactPosition.x = this.rightX;
                this.allSides[1] = null;
                _loc9_ += 1;
            }
            if(this.impactPosition.y - (this.topY + this.minDistEdge) <= 0)
            {
                this.impactPosition.y = this.topY;
                this.allSides[0] = null;
                _loc9_ += 1;
            }
            else if(this.impactPosition.y - (this.bottomY - this.minDistEdge) >= 0)
            {
                this.impactPosition.y = this.bottomY;
                this.allSides[2] = null;
                _loc9_ += 1;
            }
            var _loc10_:b2BodyDef = new b2BodyDef();
            _loc10_.angle = _loc8_;
            _loc10_.position = _loc5_;
            var _loc11_:b2PolygonDef = new b2PolygonDef();
            _loc11_.density = 2;
            _loc11_.friction = 0.3;
            _loc11_.restitution = 0.1;
            _loc11_.filter.categoryBits = 8;
            _loc11_.vertexCount = 3;
            var _loc12_:b2Vec2 = new b2Vec2(this.impactPosition.x * m_physScale,this.impactPosition.y * m_physScale);
            var _loc13_:Sprite = this.mc.parent as Sprite;
            var _loc14_:int = _loc13_.getChildIndex(this.mc);
            var _loc15_:int = 0;
            while(_loc15_ < 4)
            {
                if(this.allSides[_loc15_])
                {
                    _loc16_ = this.allSides[_loc15_];
                    _loc17_ = 0;
                    while(_loc17_ < 2)
                    {
                        _loc18_ = _loc3_.CreateBody(_loc10_);
                        _loc11_.vertices[0] = this.impactPosition;
                        _loc19_ = new b2Vec2(_loc16_[_loc17_][0],_loc16_[_loc17_][1]);
                        _loc11_.vertices[1] = _loc19_;
                        _loc20_ = new b2Vec2(_loc16_[_loc17_ + 1][0],_loc16_[_loc17_ + 1][1]);
                        _loc11_.vertices[2] = _loc20_;
                        _loc18_.CreateShape(_loc11_);
                        _loc18_.SetMassFromShapes();
                        _loc21_ = _loc18_.GetWorldCenter();
                        _loc18_.SetAngularVelocity(_loc7_);
                        _loc18_.SetLinearVelocity(this.body.GetLinearVelocityFromWorldPoint(_loc21_));
                        _loc19_.Set(_loc19_.x * m_physScale,_loc19_.y * m_physScale);
                        _loc20_.Set(_loc20_.x * m_physScale,_loc20_.y * m_physScale);
                        _loc22_ = new Sprite();
                        _loc23_ = new Sprite();
                        _loc22_.graphics.beginFill(6737151,0.35);
                        _loc23_.graphics.beginFill(65280);
                        _loc22_.graphics.moveTo(_loc12_.x,_loc12_.y);
                        _loc23_.graphics.moveTo(_loc12_.x,_loc12_.y);
                        _loc22_.graphics.lineTo(_loc19_.x,_loc19_.y);
                        _loc23_.graphics.lineTo(_loc19_.x,_loc19_.y);
                        _loc22_.graphics.lineTo(_loc20_.x,_loc20_.y);
                        _loc23_.graphics.lineTo(_loc20_.x,_loc20_.y);
                        _loc22_.graphics.lineTo(_loc12_.x,_loc12_.y);
                        _loc23_.graphics.lineTo(_loc12_.x,_loc12_.y);
                        _loc22_.graphics.endFill();
                        _loc23_.graphics.endFill();
                        _loc13_.addChildAt(_loc22_,_loc14_);
                        _loc18_.SetUserData(_loc22_);
                        _loc24_ = new GlassShard(_loc18_,_loc22_,_loc23_);
                        _loc17_++;
                    }
                }
                _loc15_++;
            }
            this.mc.parent.removeChild(this.mc);
            this.body = null;
        }
        
        private function shatter() : void
        {
            var _loc16_:Array = null;
            var _loc17_:int = 0;
            var _loc18_:b2Body = null;
            var _loc19_:b2Vec2 = null;
            var _loc20_:b2Vec2 = null;
            var _loc21_:b2Vec2 = null;
            var _loc22_:Sprite = null;
            var _loc23_:Sprite = null;
            var _loc24_:GlassShard = null;
            var _loc1_:Session = Settings.currentSession;
            var _loc2_:LevelB2D = _loc1_.level;
            var _loc3_:b2World = _loc1_.m_world;
            var _loc4_:Number = Math.ceil(Math.random() * 2);
            Settings.currentSession.particleController.createRectBurst("glass",10,this.body,this.glassParticles);
            SoundController.instance.playAreaSoundInstance("Glass" + this.soundSuffix + _loc4_,this.body);
            _loc2_.removeFromPaintBodyVector(this.body);
            var _loc5_:b2Vec2 = this.body.GetWorldCenter();
            var _loc6_:b2Vec2 = this.body.GetLinearVelocity();
            var _loc7_:Number = this.body.GetAngularVelocity();
            _loc3_.DestroyBody(this.body);
            var _loc8_:Number = this.body.GetAngle();
            var _loc9_:int = 0;
            if(this.impactPosition.x - (this.leftX + this.minDistEdge) <= 0)
            {
                this.impactPosition.x = this.leftX;
                this.allSides[3] = null;
                _loc9_ += 1;
            }
            else if(this.impactPosition.x - (this.rightX - this.minDistEdge) >= 0)
            {
                this.impactPosition.x = this.rightX;
                this.allSides[1] = null;
                _loc9_ += 1;
            }
            if(this.impactPosition.y - (this.topY + this.minDistEdge) <= 0)
            {
                this.impactPosition.y = this.topY;
                this.allSides[0] = null;
                _loc9_ += 1;
            }
            else if(this.impactPosition.y - (this.bottomY - this.minDistEdge) >= 0)
            {
                this.impactPosition.y = this.bottomY;
                this.allSides[2] = null;
                _loc9_ += 1;
            }
            var _loc10_:b2BodyDef = new b2BodyDef();
            _loc10_.angle = _loc8_;
            _loc10_.position = _loc5_;
            var _loc11_:b2PolygonDef = new b2PolygonDef();
            _loc11_.density = 2;
            _loc11_.friction = 0.3;
            _loc11_.restitution = 0.1;
            _loc11_.filter.categoryBits = 8;
            _loc11_.vertexCount = 3;
            var _loc12_:b2Vec2 = new b2Vec2(this.impactPosition.x * m_physScale,this.impactPosition.y * m_physScale);
            var _loc13_:Sprite = this.mc.parent as Sprite;
            var _loc14_:int = _loc13_.getChildIndex(this.mc);
            var _loc15_:int = 0;
            while(_loc15_ < 4)
            {
                if(this.allSides[_loc15_])
                {
                    _loc16_ = this.allSides[_loc15_];
                    _loc17_ = 0;
                    while(_loc17_ < 2)
                    {
                        _loc18_ = _loc3_.CreateBody(_loc10_);
                        _loc11_.vertices[0] = this.impactPosition;
                        _loc19_ = new b2Vec2(_loc16_[_loc17_][0],_loc16_[_loc17_][1]);
                        _loc11_.vertices[1] = _loc19_;
                        _loc20_ = new b2Vec2(_loc16_[_loc17_ + 1][0],_loc16_[_loc17_ + 1][1]);
                        _loc11_.vertices[2] = _loc20_;
                        _loc18_.CreateShape(_loc11_);
                        _loc18_.SetMassFromShapes();
                        _loc21_ = _loc18_.GetWorldCenter();
                        _loc18_.SetAngularVelocity(_loc7_);
                        _loc18_.SetLinearVelocity(this.body.GetLinearVelocityFromWorldPoint(_loc21_));
                        _loc19_.Set(_loc19_.x * m_physScale,_loc19_.y * m_physScale);
                        _loc20_.Set(_loc20_.x * m_physScale,_loc20_.y * m_physScale);
                        _loc22_ = new Sprite();
                        _loc23_ = new Sprite();
                        _loc22_.graphics.beginFill(6737151,0.35);
                        _loc23_.graphics.beginFill(65280);
                        _loc22_.graphics.moveTo(_loc12_.x,_loc12_.y);
                        _loc23_.graphics.moveTo(_loc12_.x,_loc12_.y);
                        _loc22_.graphics.lineTo(_loc19_.x,_loc19_.y);
                        _loc23_.graphics.lineTo(_loc19_.x,_loc19_.y);
                        _loc22_.graphics.lineTo(_loc20_.x,_loc20_.y);
                        _loc23_.graphics.lineTo(_loc20_.x,_loc20_.y);
                        _loc22_.graphics.lineTo(_loc12_.x,_loc12_.y);
                        _loc23_.graphics.lineTo(_loc12_.x,_loc12_.y);
                        _loc22_.graphics.endFill();
                        _loc23_.graphics.endFill();
                        _loc13_.addChildAt(_loc22_,_loc14_);
                        _loc18_.SetUserData(_loc22_);
                        _loc24_ = new GlassShard2(_loc18_,_loc22_,_loc23_,this.stabbing);
                        _loc17_++;
                    }
                }
                _loc15_++;
            }
            this.mc.parent.removeChild(this.mc);
            this.body = null;
        }
        
        internal function checkContact(param1:ContactEvent) : void
        {
            if(param1.impulse > this.smashImpulse)
            {
                this.impactPosition = this.body.GetLocalPoint(param1.position);
                Settings.currentSession.contactListener.deleteListener(ContactEvent.RESULT,this.shape);
                Settings.currentSession.contactListener.deleteListener(ContactListener.ADD,this.shape);
                Settings.currentSession.level.singleActionVector.push(this);
            }
        }
        
        private function checkAdd(param1:b2ContactPoint) : void
        {
            var _loc4_:Number = NaN;
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
                _loc4_ = Math.ceil(Math.random() * 2);
                SoundController.instance.playAreaSoundInstance("GlassImpact" + _loc4_,this.body);
            }
        }
        
        override public function getJointBody(param1:b2Vec2 = null) : b2Body
        {
            return this.body;
        }
        
        override public function triggerSingleActivation(param1:Trigger, param2:String, param3:Array) : void
        {
            var _loc4_:Number = NaN;
            var _loc5_:Number = NaN;
            var _loc6_:Number = NaN;
            var _loc7_:Number = NaN;
            var _loc8_:Number = NaN;
            var _loc9_:b2Vec2 = null;
            var _loc10_:b2Vec2 = null;
            var _loc11_:Number = NaN;
            var _loc12_:Number = NaN;
            var _loc13_:Number = NaN;
            var _loc14_:b2Vec2 = null;
            var _loc15_:Number = NaN;
            var _loc16_:b2Vec2 = null;
            if(param2 == "wake from sleep")
            {
                if(this.body)
                {
                    this.body.WakeUp();
                }
            }
            else if(param2 == "apply impulse")
            {
                if(this.body)
                {
                    _loc4_ = Number(param3[0]);
                    _loc5_ = Number(param3[1]);
                    _loc6_ = this.body.GetMass();
                    this.body.ApplyImpulse(new b2Vec2(_loc4_ * _loc6_,_loc5_ * _loc6_),this.body.GetWorldCenter());
                    _loc7_ = Number(param3[2]);
                    _loc8_ = this.body.GetAngularVelocity();
                    this.body.SetAngularVelocity(_loc8_ + _loc7_);
                }
            }
            else if(param2 == "shatter")
            {
                if(this.impactPosition)
                {
                    return;
                }
                if(this.body)
                {
                    Settings.currentSession.contactListener.deleteListener(ContactEvent.RESULT,this.shape);
                    Settings.currentSession.contactListener.deleteListener(ContactListener.ADD,this.shape);
                    this.body.WakeUp();
                    _loc9_ = new b2Vec2(param1.x / m_physScale,param1.y / m_physScale);
                    _loc10_ = this.body.GetLocalPoint(_loc9_);
                    _loc11_ = _loc10_.y / _loc10_.x;
                    _loc12_ = _loc10_.x < 0 ? this.leftX : this.rightX;
                    _loc13_ = _loc10_.y < 0 ? this.topY : this.bottomY;
                    _loc14_ = new b2Vec2(_loc12_,_loc13_);
                    if(_loc12_ == this.leftX && _loc13_ == this.topY || _loc12_ == this.rightX && _loc13_ == this.bottomY)
                    {
                        _loc16_ = new b2Vec2(-_loc14_.y,_loc14_.x);
                    }
                    else
                    {
                        _loc16_ = new b2Vec2(_loc14_.y,-_loc14_.x);
                    }
                    _loc15_ = b2Math.b2Dot(_loc10_,_loc16_);
                    this.impactPosition = new b2Vec2();
                    if(_loc15_ > 0)
                    {
                        this.impactPosition.y = _loc13_;
                        this.impactPosition.x = _loc13_ / _loc11_;
                    }
                    else
                    {
                        this.impactPosition.x = _loc12_;
                        this.impactPosition.y = _loc12_ * _loc11_;
                    }
                    this.shatter();
                }
            }
        }
        
        override public function get bodyList() : Array
        {
            if(this.body)
            {
                return [this.body];
            }
            return [];
        }
    }
}

