package com.totaljerkface.game.level
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Collision.b2AABB;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.*;
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.events.*;
    import com.totaljerkface.game.sound.SoundController;
    import flash.display.*;
    import flash.events.EventDispatcher;
    
    public class EndBlock extends EventDispatcher
    {
        internal var session:Session;
        
        internal var m_physScale:Number;
        
        internal var body:b2Body;
        
        internal var shape:b2Shape;
        
        internal var aabb:b2AABB;
        
        public function EndBlock()
        {
            super();
            this.session = Settings.currentSession;
            this.m_physScale = this.session.m_physScale;
            this.create();
        }
        
        private function create() : void
        {
            var _loc1_:b2BodyDef = new b2BodyDef();
            this.body = this.session.m_world.CreateBody(_loc1_);
            var _loc2_:b2PolygonDef = new b2PolygonDef();
            _loc2_.friction = 1;
            _loc2_.restitution = 0.1;
            _loc2_.filter.categoryBits = 8;
            var _loc3_:DisplayObject = this.session.level.shapeGuide["end"];
            var _loc4_:Number = _loc3_.rotation * Math.PI / 180;
            var _loc5_:b2Vec2 = new b2Vec2();
            _loc5_.Set(_loc3_.x / this.m_physScale,_loc3_.y / this.m_physScale);
            var _loc6_:Number = _loc3_.scaleX * 5 / this.m_physScale;
            var _loc7_:Number = _loc3_.scaleY * 5 / this.m_physScale;
            _loc2_.SetAsOrientedBox(_loc6_,_loc7_,_loc5_,_loc4_);
            this.shape = this.body.CreateShape(_loc2_);
            this.aabb = new b2AABB();
            this.aabb.lowerBound.Set(_loc5_.x - _loc6_,_loc5_.y - _loc6_ * 2);
            this.aabb.upperBound.Set(_loc5_.x + _loc6_,_loc5_.y);
            this.session.contactListener.registerListener(ContactEvent.RESULT,this.shape,this.checkEnd);
        }
        
        private function checkEnd(param1:ContactEvent) : void
        {
            var _loc2_:Session = Settings.currentSession;
            if(_loc2_.character.dead)
            {
                _loc2_.contactListener.deleteListener(ContactEvent.RESULT,this.shape);
                return;
            }
            var _loc3_:b2Body = _loc2_.character.cameraFocus;
            var _loc4_:b2Vec2 = _loc3_.GetWorldCenter();
            if(_loc4_.x < this.aabb.upperBound.x && _loc4_.x > this.aabb.lowerBound.x && _loc4_.y < this.aabb.upperBound.y && _loc4_.y > this.aabb.lowerBound.y)
            {
                _loc2_.contactListener.deleteListener(ContactEvent.RESULT,this.shape);
                if(!_loc2_.isReplay)
                {
                    trace("session is not replay");
                    _loc2_.levelComplete();
                }
                SoundController.instance.playSoundItem("Victory");
            }
        }
        
        public function die() : void
        {
            this.session.contactListener.deleteListener(ContactEvent.RESULT,this.shape);
        }
    }
}

