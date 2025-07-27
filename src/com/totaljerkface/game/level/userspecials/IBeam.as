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
    import flash.geom.*;
    
    public class IBeam extends LevelItem
    {
        private var mc:MovieClip;
        
        private var body:b2Body;
        
        private var shape:b2Shape;
        
        public function IBeam(param1:Special, param2:b2Body = null, param3:Point = null)
        {
            super();
            var _loc4_:IBeamRef = param1 as IBeamRef;
            if(param2)
            {
                this.body = param2;
            }
            var _loc5_:b2Vec2 = new b2Vec2(_loc4_.x,_loc4_.y);
            if(param3)
            {
                _loc5_.Add(new b2Vec2(param3.x,param3.y));
            }
            this.createBody(_loc5_,_loc4_.rotation * Math.PI / 180,_loc4_.shapeWidth,_loc4_.shapeHeight,_loc4_.immovable2,_loc4_.sleeping);
            this.mc = new IBeamMC();
            this.mc.width = _loc4_.shapeWidth;
            this.mc.height = _loc4_.shapeHeight;
            this.mc.x = _loc4_.x;
            this.mc.y = _loc4_.y;
            this.mc.rotation = _loc4_.rotation;
            var _loc6_:Sprite = Settings.currentSession.level.background;
            _loc6_.addChild(this.mc);
        }
        
        internal function createBody(param1:b2Vec2, param2:Number, param3:Number, param4:Number, param5:Boolean, param6:Boolean) : void
        {
            var _loc7_:b2BodyDef = new b2BodyDef();
            var _loc8_:b2PolygonDef = new b2PolygonDef();
            _loc8_.density = 75;
            _loc8_.friction = 0.3;
            _loc8_.restitution = 0.1;
            _loc8_.filter.categoryBits = 8;
            if(!param5)
            {
                if(this.body)
                {
                    _loc8_.SetAsOrientedBox(param3 * 0.5 / m_physScale,param4 * 0.5 / m_physScale,new b2Vec2(param1.x / m_physScale,param1.y / m_physScale),param2);
                    this.shape = this.body.CreateShape(_loc8_);
                }
                else
                {
                    _loc8_.SetAsBox(param3 * 0.5 / m_physScale,param4 * 0.5 / m_physScale);
                    _loc7_.position.Set(param1.x / m_physScale,param1.y / m_physScale);
                    _loc7_.angle = param2;
                    _loc7_.isSleeping = param6;
                    this.body = Settings.currentSession.m_world.CreateBody(_loc7_);
                    this.shape = this.body.CreateShape(_loc8_);
                    this.body.SetMassFromShapes();
                    Settings.currentSession.level.paintItemVector.push(this);
                }
                Settings.currentSession.contactListener.registerListener(ContactListener.ADD,this.shape,this.checkAdd);
            }
            else
            {
                _loc8_.SetAsOrientedBox(param3 * 0.5 / m_physScale,param4 * 0.5 / m_physScale,new b2Vec2(param1.x / m_physScale,param1.y / m_physScale),param2);
                Settings.currentSession.level.levelBody.CreateShape(_loc8_);
            }
        }
        
        override public function paint() : void
        {
            var _loc1_:b2Vec2 = this.body.GetWorldCenter();
            this.mc.x = _loc1_.x * m_physScale;
            this.mc.y = _loc1_.y * m_physScale;
            this.mc.rotation = this.body.GetAngle() * oneEightyOverPI % 360;
        }
        
        override public function getJointBody(param1:b2Vec2 = null) : b2Body
        {
            return this.body;
        }
        
        override public function get groupDisplayObject() : DisplayObject
        {
            return this.mc;
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
                SoundController.instance.playAreaSoundInstance("IBeamHit" + _loc4_,this.body);
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

