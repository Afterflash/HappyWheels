package com.totaljerkface.game
{
    import Box2D.Collision.Shapes.b2CircleDef;
    import Box2D.Collision.Shapes.b2PolygonDef;
    import Box2D.Collision.b2AABB;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2DebugDraw;
    import Box2D.Dynamics.b2World;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Rectangle;
    import flash.text.AntiAliasType;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    
    public class ArchitectureTest extends Sprite
    {
        private var textField:TextField;
        
        private var m_world:b2World;
        
        private var m_iterations:int = 10;
        
        private var m_timeStep:Number = 0.03333333333333333;
        
        private var m_physScale:Number = 62.5;
        
        private var debug_sprite:Sprite;
        
        private var useDebugger:Boolean;
        
        private var debugString:String;
        
        private var totalFrames:int = 30;
        
        private var frames:int = 0;
        
        private var trackingBody:b2Body;
        
        private var _result:String;
        
        public function ArchitectureTest(param1:Boolean = false)
        {
            super();
            this.useDebugger = param1;
            if(parent)
            {
                this.useDebugger = true;
                this.test();
            }
        }
        
        public function test() : void
        {
            if(this.useDebugger)
            {
                this.debug_sprite = new Sprite();
                addChild(this.debug_sprite);
                this.useDebugger = true;
                this.createTextField();
                this.createWorld();
                this.createBodies();
                addEventListener(Event.ENTER_FRAME,this.run);
            }
            else
            {
                this.createWorld();
                this.createBodies();
                this.frames = 0;
                while(this.frames <= this.totalFrames)
                {
                    this.m_world.Step(this.m_timeStep,this.m_iterations);
                    ++this.frames;
                }
                dispatchEvent(new Event(Event.COMPLETE));
            }
        }
        
        public function get result() : String
        {
            var _loc1_:String = this.trackingBody.GetPosition().x.toString();
            while(_loc1_.length < 17)
            {
                _loc1_ = _loc1_.concat(0);
            }
            return _loc1_.substr(_loc1_.length - 8,8);
        }
        
        private function createTextField() : void
        {
            var _loc1_:TextFormat = new TextFormat("HelveticaNeueLT Std",11,0,null,null,null,null,null,TextFormatAlign.LEFT);
            this.textField = new TextField();
            this.textField.width = 390;
            this.textField.height = 10;
            this.textField.defaultTextFormat = _loc1_;
            this.textField.autoSize = TextFieldAutoSize.LEFT;
            trace(this.textField.width);
            this.textField.y = 0;
            this.textField.multiline = true;
            this.textField.selectable = true;
            this.textField.embedFonts = true;
            this.textField.antiAliasType = AntiAliasType.ADVANCED;
            addChild(this.textField);
            this.debugString = new String();
        }
        
        private function createWorld() : void
        {
            var _loc1_:b2AABB = new b2AABB();
            var _loc2_:Rectangle = new Rectangle(-500,-500,2000,2000);
            _loc1_.lowerBound.Set(_loc2_.x / this.m_physScale,_loc2_.y / this.m_physScale);
            _loc1_.upperBound.Set((_loc2_.x + _loc2_.width) / this.m_physScale,(_loc2_.y + _loc2_.height) / this.m_physScale);
            var _loc3_:b2Vec2 = new b2Vec2(0,10);
            var _loc4_:Boolean = true;
            this.m_world = new b2World(_loc1_,_loc3_,_loc4_);
            var _loc5_:b2DebugDraw = new b2DebugDraw();
            _loc5_.m_sprite = this.debug_sprite;
            _loc5_.m_drawScale = 62.5;
            _loc5_.m_fillAlpha = 0.3;
            _loc5_.m_lineThickness = 1;
            _loc5_.m_drawFlags = b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit;
            if(this.useDebugger)
            {
                this.m_world.SetDebugDraw(_loc5_);
            }
        }
        
        private function createBodies() : void
        {
            var _loc9_:int = 0;
            var _loc1_:b2BodyDef = new b2BodyDef();
            var _loc2_:b2PolygonDef = new b2PolygonDef();
            var _loc3_:b2CircleDef = new b2CircleDef();
            _loc2_.friction = _loc3_.friction = 1;
            _loc2_.restitution = _loc3_.restitution = 0.3;
            _loc2_.density = 1;
            var _loc4_:b2Body = this.m_world.CreateBody(_loc1_);
            _loc2_.SetAsOrientedBox(275 / this.m_physScale,50 / this.m_physScale,new b2Vec2(275 / this.m_physScale,400 / this.m_physScale));
            _loc4_.CreateShape(_loc2_);
            _loc2_.SetAsOrientedBox(275 / this.m_physScale,50 / this.m_physScale,new b2Vec2(275 / this.m_physScale,0 / this.m_physScale));
            _loc4_.CreateShape(_loc2_);
            _loc2_.SetAsOrientedBox(50 / this.m_physScale,200 / this.m_physScale,new b2Vec2(550 / this.m_physScale,200 / this.m_physScale));
            _loc4_.CreateShape(_loc2_);
            _loc2_.SetAsOrientedBox(50 / this.m_physScale,200 / this.m_physScale,new b2Vec2(0 / this.m_physScale,200 / this.m_physScale));
            _loc4_.CreateShape(_loc2_);
            var _loc5_:Number = 5;
            _loc2_.SetAsOrientedBox(5 / this.m_physScale,5 / this.m_physScale,new b2Vec2(0,0));
            var _loc6_:int = 255;
            var _loc7_:int = 345;
            var _loc8_:int = 0;
            while(_loc8_ < _loc5_)
            {
                _loc9_ = 0;
                while(_loc9_ < _loc5_)
                {
                    _loc1_.position.Set(_loc6_ / this.m_physScale,_loc7_ / this.m_physScale);
                    _loc4_ = this.m_world.CreateBody(_loc1_);
                    _loc4_.CreateShape(_loc2_);
                    _loc4_.SetMassFromShapes();
                    if(_loc8_ == 0 && _loc9_ == 4)
                    {
                        this.trackingBody = _loc4_;
                    }
                    _loc6_ += 10;
                    _loc9_++;
                }
                _loc6_ = 255;
                _loc7_ -= 10;
                _loc8_++;
            }
            _loc1_.position.Set(85 / this.m_physScale,315 / this.m_physScale);
            _loc4_ = this.m_world.CreateBody(_loc1_);
            _loc3_.radius = 25 / this.m_physScale;
            _loc3_.density = 3;
            _loc4_.CreateShape(_loc3_);
            _loc4_.SetMassFromShapes();
            _loc4_.SetLinearVelocity(new b2Vec2(20,0));
        }
        
        private function run(param1:Event) : void
        {
            if(this.frames == this.totalFrames)
            {
                removeEventListener(Event.ENTER_FRAME,this.run);
                this.textField.htmlText = this.debugString;
            }
            this.m_world.Step(this.m_timeStep,this.m_iterations);
            var _loc2_:* = "frame " + this.frames + " = " + this.trackingBody.GetPosition().x + "<br>";
            this.debugString = this.debugString.concat(_loc2_);
            this.frames += 1;
        }
    }
}

