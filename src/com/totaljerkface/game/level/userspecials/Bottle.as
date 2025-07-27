package com.totaljerkface.game.level.userspecials
{
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.*;
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.editor.specials.*;
    import com.totaljerkface.game.events.*;
    import com.totaljerkface.game.level.*;
    import com.totaljerkface.game.sound.*;
    import flash.display.*;
    import flash.geom.Point;
    import flash.utils.getDefinitionByName;
    
    public class Bottle extends LevelItem
    {
        private var _shape:b2Shape;
        
        private var _body:b2Body;
        
        private var _interactive:Boolean;
        
        private var _bottleType:int;
        
        private var mc:MovieClip;
        
        public function Bottle(param1:Special, param2:b2Body = null, param3:Point = null)
        {
            super();
            this.createBody(param1);
        }
        
        internal function createBody(param1:Special) : void
        {
            var _loc2_:LevelB2D = null;
            var _loc4_:BottleRef = null;
            _loc2_ = Settings.currentSession.level;
            var _loc3_:Sprite = _loc2_.background;
            _loc4_ = param1 as BottleRef;
            _loc4_ = _loc4_.clone() as BottleRef;
            var _loc5_:int = this._bottleType = _loc4_.bottleType;
            var _loc6_:Class = getDefinitionByName("BottleShards" + _loc5_ + "MC") as Class;
            var _loc7_:MovieClip = new _loc6_();
            Settings.currentSession.particleController.createBMDArray("bottleShards" + _loc5_,_loc7_);
            this._interactive = _loc4_.interactive;
            this.mc = new BottleMC();
            this.mc.gotoAndStop(_loc5_);
            _loc3_.addChild(this.mc);
            this.mc.x = param1.x;
            this.mc.y = param1.y;
            this.mc.rotation = param1.rotation;
            if(!this._interactive)
            {
                return;
            }
            var _loc8_:b2Vec2 = new b2Vec2(_loc4_.x,_loc4_.y);
            var _loc9_:Number = _loc4_.rotation;
            var _loc10_:b2BodyDef = new b2BodyDef();
            var _loc11_:b2PolygonDef = new b2PolygonDef();
            _loc11_.density = 2;
            _loc11_.friction = 0.3;
            _loc11_.filter.categoryBits = 8;
            _loc11_.restitution = 0.1;
            _loc11_.SetAsBox(5 / m_physScale,14.5 / m_physScale);
            _loc10_.position.Set(_loc8_.x / m_physScale,_loc8_.y / m_physScale);
            _loc10_.angle = _loc9_ * Math.PI / 180;
            _loc10_.isSleeping = _loc4_.sleeping;
            var _loc12_:b2Body = this._body = Settings.currentSession.m_world.CreateBody(_loc10_);
            this._shape = _loc12_.CreateShape(_loc11_) as b2PolygonShape;
            _loc12_.SetMassFromShapes();
            _loc2_.paintBodyVector.push(_loc12_);
            _loc12_.SetUserData(this.mc);
            Settings.currentSession.contactListener.registerListener(ContactListener.RESULT,this._shape,this.checkContact);
        }
        
        override public function get groupDisplayObject() : DisplayObject
        {
            return this.mc;
        }
        
        private function checkContact(param1:ContactEvent) : void
        {
            if(param1.impulse > 1.78)
            {
                Settings.currentSession.contactListener.deleteListener(ContactEvent.RESULT,this._shape);
                Settings.currentSession.level.singleActionVector.push(this);
            }
        }
        
        override public function singleAction() : void
        {
            var _loc1_:LevelB2D = Settings.currentSession.level;
            var _loc2_:Sprite = _loc1_.background;
            _loc1_.removeFromActionsVector(this);
            _loc1_.removeFromPaintBodyVector(this._body);
            var _loc3_:Number = Math.ceil(Math.random() * 2);
            Settings.currentSession.particleController.createRectBurst("bottleShards" + this._bottleType,10,this._body,30);
            SoundController.instance.playAreaSoundInstance("GlassLight" + _loc3_,this._body);
            _loc1_.background.removeChild(this.mc);
            Settings.currentSession.m_world.DestroyBody(this._body);
            this._body = null;
        }
        
        override public function getJointBody(param1:b2Vec2 = null) : b2Body
        {
            return this._body;
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
                if(this._body)
                {
                    this._body.WakeUp();
                }
            }
            else if(param2 == "apply impulse")
            {
                if(this._body)
                {
                    _loc4_ = Number(param3[0]);
                    _loc5_ = Number(param3[1]);
                    _loc6_ = this._body.GetMass();
                    this._body.ApplyImpulse(new b2Vec2(_loc4_ * _loc6_,_loc5_ * _loc6_),this._body.GetWorldCenter());
                    _loc7_ = Number(param3[2]);
                    _loc8_ = this._body.GetAngularVelocity();
                    this._body.SetAngularVelocity(_loc8_ + _loc7_);
                }
            }
        }
        
        override public function get bodyList() : Array
        {
            if(this._body)
            {
                return [this._body];
            }
            return [];
        }
    }
}

