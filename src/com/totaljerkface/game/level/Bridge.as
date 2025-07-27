package com.totaljerkface.game.level
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.b2RevoluteJointDef;
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.events.*;
    import flash.display.*;
    
    public class Bridge extends LevelItem
    {
        private var total:int;
        
        private var bodies:Array;
        
        private var id:String;
        
        public function Bridge(param1:String, param2:int)
        {
            super();
            this.id = param1;
            this.total = param2;
            this.createBodies();
            this.createJoints();
            this.createMCs();
        }
        
        internal function createBodies() : void
        {
            var _loc1_:b2PolygonDef = null;
            var _loc2_:Number = NaN;
            var _loc7_:MovieClip = null;
            var _loc8_:b2BodyDef = null;
            var _loc9_:b2Body = null;
            _loc1_ = new b2PolygonDef();
            _loc1_.density = 1;
            _loc1_.friction = 1;
            _loc1_.restitution = 0.1;
            _loc1_.filter.categoryBits = 8;
            _loc1_.filter.groupIndex = -10;
            var _loc3_:b2Vec2 = new b2Vec2();
            this.bodies = new Array();
            var _loc4_:LevelB2D = Settings.currentSession.level;
            var _loc5_:b2World = Settings.currentSession.m_world;
            var _loc6_:int = 0;
            while(_loc6_ < this.total)
            {
                _loc7_ = _loc4_.shapeGuide[this.id + _loc6_];
                _loc8_ = new b2BodyDef();
                _loc2_ = _loc7_.rotation * Math.PI / 180;
                _loc3_.Set(_loc7_.x / m_physScale,_loc7_.y / m_physScale);
                _loc1_.SetAsOrientedBox(_loc7_.scaleX * 5 / m_physScale,_loc7_.scaleY * 5 / m_physScale,_loc3_,_loc2_);
                _loc9_ = _loc5_.CreateBody(_loc8_);
                _loc9_.CreateShape(_loc1_);
                _loc9_.SetMassFromShapes();
                this.bodies.push(_loc9_);
                _loc6_++;
            }
        }
        
        internal function createJoints() : void
        {
            var _loc9_:int = 0;
            var _loc1_:b2RevoluteJointDef = new b2RevoluteJointDef();
            var _loc2_:b2Vec2 = new b2Vec2();
            var _loc3_:LevelB2D = Settings.currentSession.level;
            var _loc4_:b2World = Settings.currentSession.m_world;
            var _loc5_:MovieClip = _loc3_.shapeGuide[this.id + _loc9_];
            var _loc6_:MovieClip = _loc3_.shapeGuide[this.id + (_loc9_ + 1)];
            var _loc7_:b2Body = this.bodies[0];
            var _loc8_:b2Body = this.bodies[_loc9_];
            _loc2_.Set((_loc5_.x - _loc5_.width / 2) / m_physScale,_loc5_.y / m_physScale);
            _loc1_.Initialize(_loc3_.levelBody,_loc7_,_loc2_);
            _loc4_.CreateJoint(_loc1_);
            _loc9_ = 0;
            while(_loc9_ < this.total - 1)
            {
                _loc5_ = _loc3_.shapeGuide[this.id + _loc9_];
                _loc6_ = _loc3_.shapeGuide[this.id + (_loc9_ + 1)];
                _loc7_ = this.bodies[_loc9_];
                _loc8_ = this.bodies[_loc9_ + 1];
                _loc2_.Set((_loc5_.x + _loc6_.x) / 2 / m_physScale,_loc5_.y / m_physScale);
                _loc1_.Initialize(_loc7_,_loc8_,_loc2_);
                _loc4_.CreateJoint(_loc1_);
                _loc9_++;
            }
            _loc2_.Set((_loc6_.x + _loc6_.width / 2) / m_physScale,_loc6_.y / m_physScale);
            _loc1_.Initialize(_loc3_.levelBody,_loc8_,_loc2_);
            _loc4_.CreateJoint(_loc1_);
        }
        
        internal function createMCs() : void
        {
            var _loc2_:MovieClip = null;
            var _loc3_:b2Body = null;
            var _loc1_:int = 0;
            while(_loc1_ < this.total)
            {
                _loc2_ = Settings.currentSession.level.background[this.id + "mc" + _loc1_];
                _loc3_ = this.bodies[_loc1_];
                _loc3_.SetUserData(_loc2_);
                _loc1_++;
            }
        }
        
        override public function paint() : void
        {
            var _loc2_:b2Body = null;
            var _loc3_:MovieClip = null;
            var _loc4_:b2Vec2 = null;
            var _loc1_:int = 0;
            while(_loc1_ < this.total)
            {
                _loc2_ = this.bodies[_loc1_];
                _loc3_ = _loc2_.m_userData;
                _loc4_ = _loc2_.GetWorldCenter();
                _loc3_.x = _loc4_.x * m_physScale;
                _loc3_.y = _loc4_.y * m_physScale;
                _loc3_.rotation = _loc2_.GetAngle() * (180 / Math.PI);
                _loc1_++;
            }
        }
    }
}

