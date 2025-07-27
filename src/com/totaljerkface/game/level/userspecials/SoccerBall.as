package com.totaljerkface.game.level.userspecials
{
    import Box2D.Collision.Shapes.b2CircleDef;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import com.totaljerkface.game.Settings;
    import com.totaljerkface.game.editor.specials.Special;
    import com.totaljerkface.game.level.LevelB2D;
    import com.totaljerkface.game.level.LevelItem;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    
    public class SoccerBall extends LevelItem
    {
        public function SoccerBall(param1:Special)
        {
            super();
            this.createBody(new b2Vec2(param1.x,param1.y));
        }
        
        internal function createBody(param1:b2Vec2) : void
        {
            var _loc2_:b2BodyDef = null;
            _loc2_ = new b2BodyDef();
            var _loc3_:b2CircleDef = new b2CircleDef();
            _loc3_.density = 0.5;
            _loc3_.friction = 0.1;
            _loc3_.restitution = 0.5;
            _loc3_.filter.categoryBits = 8;
            _loc3_.radius = 10 / m_physScale;
            _loc2_.position.Set(param1.x / m_physScale,param1.y / m_physScale);
            var _loc4_:b2Body = Settings.currentSession.m_world.CreateBody(_loc2_);
            _loc4_.CreateShape(_loc3_);
            _loc4_.SetMassFromShapes();
            var _loc5_:LevelB2D = Settings.currentSession.level;
            var _loc6_:MovieClip = new SoccerBallMC();
            var _loc7_:Sprite = _loc5_.background;
            _loc7_.addChild(_loc6_);
            _loc4_.SetUserData(_loc6_);
            _loc5_.paintBodyVector.push(_loc4_);
        }
    }
}

