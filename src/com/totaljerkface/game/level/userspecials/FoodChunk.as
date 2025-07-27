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
    
    public class FoodChunk extends LevelItem
    {
        private var _index:int;
        
        private var _refMC:MovieClip;
        
        private var _mc:MovieClip;
        
        private var _shape:b2Shape;
        
        private var _body:b2Body;
        
        private var _pointPrefix:String = "p";
        
        private var _circlePrefix:String;
        
        public function FoodChunk(param1:int, param2:b2Body, param3:MovieClip, param4:FoodItem)
        {
            super();
            this.createBody(param1,param3,param2,param4);
        }
        
        internal function createBody(param1:int, param2:MovieClip, param3:b2Body, param4:FoodItem) : void
        {
            var _loc5_:b2Vec2 = null;
            var _loc7_:Number = NaN;
            this._mc = param2["m" + param1];
            _loc5_ = param3.GetWorldPoint(new b2Vec2(this._mc.x / m_physScale,this._mc.y / m_physScale));
            var _loc6_:Number = _loc5_.x * m_physScale;
            _loc7_ = _loc5_.y * m_physScale;
            this._mc.x = _loc6_;
            this._mc.y = _loc7_;
            this._mc.rotation = param3.GetAngle() * oneEightyOverPI % 360;
            var _loc8_:b2BodyDef = new b2BodyDef();
            var _loc9_:b2CircleDef = new b2CircleDef();
            _loc9_.density = 2;
            _loc9_.friction = 0.3;
            _loc9_.filter.categoryBits = 8;
            _loc9_.restitution = 0.1;
            _loc8_.position.Set(_loc5_.x,_loc5_.y);
            _loc8_.angle = param3.GetAngle();
            var _loc10_:b2Body = Settings.currentSession.m_world.CreateBody(_loc8_);
            _loc10_.SetLinearVelocity(param3.GetLinearVelocity());
            _loc10_.SetAngularVelocity(param3.GetAngularVelocity());
            var _loc11_:MovieClip = param2["c" + param1];
            _loc9_.radius = _loc11_.width / 2 / m_physScale;
            var _loc12_:b2Shape = _loc10_.CreateShape(_loc9_);
            _loc12_.SetMaterial(1);
            _loc12_.SetUserData(param4);
            _loc10_.SetMassFromShapes();
            Settings.currentSession.level.paintBodyVector.push(_loc10_);
            _loc10_.SetUserData(this._mc);
            Settings.currentSession.level.background.addChild(this._mc);
        }
    }
}

