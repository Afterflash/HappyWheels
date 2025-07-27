package com.totaljerkface.game.level.userspecials
{
    import Box2D.Collision.Shapes.b2PolygonDef;
    import Box2D.Collision.Shapes.b2Shape;
    import Box2D.Collision.b2AABB;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import com.totaljerkface.game.Session;
    import com.totaljerkface.game.Settings;
    import com.totaljerkface.game.editor.specials.FinishLineRef;
    import com.totaljerkface.game.editor.specials.Special;
    import com.totaljerkface.game.events.ContactEvent;
    import com.totaljerkface.game.level.LevelB2D;
    import com.totaljerkface.game.level.LevelItem;
    import com.totaljerkface.game.particles.ParticleController;
    import com.totaljerkface.game.sound.SoundController;
    import flash.display.Sprite;
    
    public class FinishLine extends LevelItem
    {
        private static var idCounter:int = 0;
        
        private var mc:FinishLineMC;
        
        private var id:String;
        
        private var shape:b2Shape;
        
        private var aabb:b2AABB;
        
        private var sparkCoords:b2Vec2;
        
        public function FinishLine(param1:Special)
        {
            super();
            var _loc2_:FinishLineRef = param1 as FinishLineRef;
            this.createBodies(new b2Vec2(_loc2_.x,_loc2_.y));
            trace(_loc2_.x + " " + _loc2_.y);
            this.mc = new FinishLineMC();
            this.mc.x = _loc2_.x;
            this.mc.y = _loc2_.y;
            this.mc.rotation = _loc2_.rotation;
            var _loc3_:LevelB2D = Settings.currentSession.level;
            var _loc4_:Sprite = _loc3_.background;
            _loc4_.addChild(this.mc);
            _loc3_.foreground.addChild(this.mc.flag);
            this.mc.flag.x = _loc2_.x - 200;
            this.mc.flag.y = _loc2_.y - 220;
            Settings.currentSession.particleController.createBMDArray("sparks",new SparksMC());
            Settings.currentSession.contactListener.registerListener(ContactEvent.RESULT,this.shape,this.checkResult);
        }
        
        internal function createBodies(param1:b2Vec2) : void
        {
            var _loc2_:b2PolygonDef = new b2PolygonDef();
            _loc2_.friction = 0.3;
            _loc2_.restitution = 0.1;
            _loc2_.filter.categoryBits = 8;
            _loc2_.SetAsOrientedBox(200 / m_physScale,20 / m_physScale,new b2Vec2(param1.x / m_physScale,param1.y / m_physScale),0);
            this.shape = Settings.currentSession.level.levelBody.CreateShape(_loc2_);
            this.aabb = new b2AABB();
            this.aabb.lowerBound = new b2Vec2((param1.x - 200) / m_physScale,(param1.y - 200) / m_physScale);
            this.aabb.upperBound = new b2Vec2((param1.x + 200) / m_physScale,param1.y / m_physScale);
            this.sparkCoords = new b2Vec2(param1.x - 196,param1.y - 230);
            Settings.currentSession.level.keepVector.push(this);
        }
        
        private function checkResult(param1:ContactEvent) : void
        {
            var _loc5_:int = 0;
            var _loc6_:ParticleController = null;
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
                _loc5_ = _loc2_.containerSprite.getChildIndex(_loc2_.level.foreground);
                _loc6_ = _loc2_.particleController;
                _loc6_.createPointFlow("sparks",this.sparkCoords.x,this.sparkCoords.y,2,5,-65,1000,_loc5_);
                _loc6_.createPointFlow("sparks",this.sparkCoords.x,this.sparkCoords.y,2,5,-115,1000,_loc5_);
                SoundController.instance.playSoundItem("Victory");
            }
        }
    }
}

