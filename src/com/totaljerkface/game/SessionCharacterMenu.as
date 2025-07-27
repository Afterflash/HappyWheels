package com.totaljerkface.game
{
    import Box2D.Collision.Shapes.b2PolygonDef;
    import Box2D.Collision.b2AABB;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2DebugDraw;
    import Box2D.Dynamics.b2World;
    import com.totaljerkface.game.particles.ParticleController;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.geom.Rectangle;
    import flash.utils.Timer;
    
    public class SessionCharacterMenu extends Session
    {
        public function SessionCharacterMenu(param1:Sprite)
        {
            super(Settings.CURRENT_VERSION,param1,null,0);
        }
        
        override protected function setupLevel(param1:Sprite) : void
        {
        }
        
        override protected function getStartPoint() : b2Vec2
        {
            switch(Settings.characterIndex)
            {
                case 1:
                    return new b2Vec2(100,80);
                case 2:
                    return new b2Vec2(100,40);
                case 3:
                    return new b2Vec2(100,65);
                case 4:
                    return new b2Vec2(80,90);
                case 5:
                    return new b2Vec2(90,65);
                case 6:
                    return new b2Vec2(80,70);
                case 7:
                    return new b2Vec2(85,75);
                case 8:
                    return new b2Vec2(100,70);
                case 9:
                    return new b2Vec2(100,40);
                case 10:
                    return new b2Vec2(125,70);
                case 11:
                    return new b2Vec2(125,80);
                default:
                    return new b2Vec2(100,100);
            }
        }
        
        override public function create() : void
        {
            _particleController = new ParticleController(_containerSprite);
            this.createWorld();
            trace("building character");
            _character.create();
            _camera = new StageCamera(_containerSprite,_character.cameraFocus,this);
            setupTextFields();
            fpsText.visible = false;
            _containerSprite.addChild(debug_sprite);
            _character.paint();
            this.start();
        }
        
        override protected function createWorld() : void
        {
            var _loc5_:b2DebugDraw = null;
            var _loc1_:b2AABB = new b2AABB();
            var _loc2_:Rectangle = new Rectangle(0,0,1000,1000);
            _loc1_.lowerBound.Set(_loc2_.x / m_physScale,_loc2_.y / m_physScale);
            _loc1_.upperBound.Set((_loc2_.x + _loc2_.width) / m_physScale,(_loc2_.y + _loc2_.height) / m_physScale);
            var _loc3_:b2Vec2 = new b2Vec2(0,10);
            var _loc4_:Boolean = true;
            m_world = new b2World(_loc1_,_loc3_,_loc4_);
            _loc5_ = new b2DebugDraw();
            _loc5_.m_sprite = debug_sprite;
            _loc5_.m_drawScale = 62.5;
            _loc5_.m_fillAlpha = 0.3;
            _loc5_.m_lineThickness = 1;
            _loc5_.m_drawFlags = b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit;
            _contactListener = new ContactListener();
            m_world.SetContactListener(_contactListener);
            var _loc6_:b2BodyDef = new b2BodyDef();
            var _loc7_:b2PolygonDef = new b2PolygonDef();
            _loc7_.friction = 1;
            _loc7_.restitution = 0.1;
            _loc7_.filter.categoryBits = 8;
            _loc7_.filter.groupIndex = -10;
            var _loc8_:b2Body = m_world.CreateBody(_loc6_);
            _loc7_.SetAsOrientedBox(80 / m_physScale,50 / m_physScale,new b2Vec2(100 / m_physScale,225 / m_physScale));
            _loc8_.CreateShape(_loc7_);
        }
        
        override public function start() : void
        {
            paused = false;
            frames = 0;
            _iteration = 0;
            addEventListener(Event.ENTER_FRAME,this.run);
            fpsTimer = new Timer(1000,0);
            fpsTimer.addEventListener(TimerEvent.TIMER,setFps);
            fpsTimer.start();
        }
        
        override protected function run(param1:Event) : void
        {
            frames += 1;
            _character.preActions();
            _character.doNothing();
            _character.actions();
            m_world.Step(m_timeStep,m_iterations);
            _character.handleContactBuffer();
            _character.checkJoints();
            _character.paint();
            _particleController.step();
        }
        
        override public function die() : void
        {
            removeEventListener(Event.ENTER_FRAME,this.run);
            if(fpsTimer)
            {
                fpsTimer.stop();
                fpsTimer.removeEventListener(TimerEvent.TIMER,setFps);
            }
            var _loc1_:b2Body = m_world.GetBodyList();
            while(_loc1_)
            {
                m_world.DestroyBody(_loc1_);
                _loc1_ = _loc1_.m_next;
            }
            m_world = null;
            _character.die();
            _character = null;
            _particleController.die();
            _particleController = null;
        }
    }
}

