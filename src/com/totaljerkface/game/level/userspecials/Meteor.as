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
    
    public class Meteor extends LevelItem
    {
        private var shape:b2Shape;
        
        private var body:b2Body;
        
        private var mc:Sprite;
        
        public function Meteor(param1:Special)
        {
            super();
            var _loc2_:MeteorRef = param1 as MeteorRef;
            this.createBody(new b2Vec2(_loc2_.x,_loc2_.y),_loc2_.shapeWidth,_loc2_.immovable2,_loc2_.sleeping);
        }
        
        internal function createBody(param1:b2Vec2, param2:Number, param3:Boolean, param4:Boolean) : void
        {
            var _loc8_:b2CircleDef = null;
            var _loc5_:b2BodyDef = new b2BodyDef();
            this.mc = new MeteorMC();
            this.mc.width = 407.1 * param2 / 400;
            this.mc.height = 401.4 * param2 / 400;
            this.mc.x = param1.x;
            this.mc.y = param1.y;
            var _loc6_:LevelB2D = Settings.currentSession.level;
            var _loc7_:Sprite = _loc6_.background;
            _loc7_.addChild(this.mc);
            _loc8_ = new b2CircleDef();
            _loc8_.density = 75;
            _loc8_.friction = 0.5;
            _loc8_.restitution = 0.1;
            _loc8_.radius = param2 * 0.5 / m_physScale;
            _loc8_.filter.categoryBits = 8;
            if(!param3)
            {
                _loc5_.position.Set(param1.x / m_physScale,param1.y / m_physScale);
                _loc5_.isSleeping = param4;
                this.body = Settings.currentSession.m_world.CreateBody(_loc5_);
                this.shape = this.body.CreateShape(_loc8_);
                this.body.SetMassFromShapes();
                this.body.SetUserData(this.mc);
                _loc6_.paintItemVector.push(this);
                Settings.currentSession.contactListener.registerListener(ContactListener.ADD,this.shape,this.checkAdd);
            }
            else
            {
                _loc8_.localPosition.Set(param1.x / m_physScale,param1.y / m_physScale);
                _loc6_.levelBody.CreateShape(_loc8_);
            }
        }
        
        override public function paint() : void
        {
            var _loc1_:b2Vec2 = this.body.GetWorldCenter();
            this.mc.x = _loc1_.x * m_physScale;
            this.mc.y = _loc1_.y * m_physScale;
            this.mc.rotation = this.body.GetAngle() * oneEightyOverPI % 360;
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
            if(_loc3_ > 2)
            {
                SoundController.instance.playAreaSoundInstance("MeteorImpact",this.body);
            }
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

