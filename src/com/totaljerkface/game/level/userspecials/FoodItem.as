package com.totaljerkface.game.level.userspecials
{
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.b2Math;
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
    
    public class FoodItem extends LevelItem
    {
        public static const FOOD_TAG:String = "food_tag";
        
        private var _foodItemType:int;
        
        private var _shape:b2Shape;
        
        private var _body:b2Body;
        
        private var _interactive:Boolean;
        
        private var _willSmash:Boolean = false;
        
        private var _crackImpulse:int = 7;
        
        private var _smashImpulse:int = 20;
        
        private var _chunksMC:MovieClip;
        
        private var _MCNames:Array = ["WatermelonMC","PumpkinMC","PineappleMC"];
        
        private var _particleMCs:Array = ["WatermelonParticlesMC","PumpkinParticlesMC","PineappleParticlesMC"];
        
        private var _juiceColor:Array = [13703445,15695667,15066224];
        
        private var _initialStateShapeCount:Array = [1,1,1];
        
        private var _initialSmashImpulse:Array = [8,8,3];
        
        private var _shapes:Array = [];
        
        private var _break:Boolean = false;
        
        private var mc:MovieClip;
        
        public function FoodItem(param1:Special, param2:b2Body = null, param3:Point = null)
        {
            super();
            var _loc4_:FoodItemRef = param1 as FoodItemRef;
            this.createBody(_loc4_);
        }
        
        public static function getChildrenWithPrefix(param1:MovieClip, param2:String) : Array
        {
            var _loc3_:Array = [];
            var _loc4_:int = 0;
            while(_loc4_ < param1.numChildren)
            {
                if(param1.getChildAt(_loc4_).name.indexOf(param2) == 0)
                {
                    _loc3_.push(param1.getChildAt(_loc4_));
                }
                _loc4_++;
            }
            return _loc3_;
        }
        
        public function get juiceColor() : Number
        {
            return this._juiceColor[this._foodItemType - 1];
        }
        
        public function get particleType() : String
        {
            return this._particleMCs[this._foodItemType - 1];
        }
        
        internal function createBody(param1:FoodItemRef) : void
        {
            var _loc3_:Sprite = null;
            var _loc12_:int = 0;
            var _loc13_:MovieClip = null;
            var _loc14_:int = 0;
            var _loc15_:int = 0;
            var _loc16_:int = 0;
            var _loc17_:* = null;
            var _loc18_:b2PolygonShape = null;
            var _loc20_:Array = null;
            this._foodItemType = param1.foodItemType;
            var _loc2_:LevelB2D = Settings.currentSession.level;
            _loc3_ = _loc2_.background;
            this._interactive = param1.interactive;
            var _loc4_:Class = getDefinitionByName(this._MCNames[param1.foodItemType - 1]) as Class;
            this.mc = new _loc4_();
            var _loc5_:MovieClip = this.mc.shapes;
            this.mc.removeChild(this.mc.shapes);
            this._chunksMC = this.mc.chunks;
            this.mc.removeChild(this.mc.chunks);
            this.mc.x = param1.x;
            this.mc.y = param1.y;
            this.mc.rotation = param1.rotation;
            _loc3_.addChild(this.mc);
            if(!this._interactive)
            {
                return;
            }
            var _loc6_:Class = getDefinitionByName(this._particleMCs[this._foodItemType - 1]) as Class;
            var _loc7_:MovieClip = new _loc6_();
            Settings.currentSession.particleController.createBMDArray(this._particleMCs[this._foodItemType - 1],_loc7_);
            var _loc8_:b2Vec2 = new b2Vec2(param1.x,param1.y);
            var _loc9_:Number = param1.rotation;
            var _loc10_:b2BodyDef = new b2BodyDef();
            var _loc11_:b2PolygonDef = new b2PolygonDef();
            _loc11_.density = 2;
            _loc11_.friction = 0.3;
            _loc11_.filter.categoryBits = 8;
            _loc11_.restitution = 0.1;
            _loc10_.position.Set(_loc8_.x / m_physScale,_loc8_.y / m_physScale);
            _loc10_.angle = _loc9_ * Math.PI / 180;
            _loc10_.isSleeping = param1.sleeping;
            var _loc19_:b2Body = this._body = Settings.currentSession.m_world.CreateBody(_loc10_);
            _loc15_ = 0;
            while(_loc15_ < this._initialStateShapeCount[param1.foodItemType - 1])
            {
                _loc12_ = 0;
                _loc20_ = getChildrenWithPrefix(_loc5_,"p" + _loc15_);
                _loc14_ = 0;
                while(_loc14_ < _loc20_.length)
                {
                    _loc13_ = _loc5_["p" + _loc15_ + "_" + _loc14_];
                    _loc11_.vertexCount = _loc20_.length;
                    _loc11_.vertices[_loc14_] = new b2Vec2(_loc13_.x / m_physScale,_loc13_.y / m_physScale);
                    _loc14_++;
                }
                _loc18_ = _loc19_.CreateShape(_loc11_) as b2PolygonShape;
                _loc18_.SetMaterial(4);
                _loc18_.SetUserData(this);
                Settings.currentSession.contactListener.registerListener(ContactListener.RESULT,_loc18_,this.checkContact);
                this._shapes.push(_loc18_);
                _loc15_++;
            }
            _loc19_.SetMassFromShapes();
            _loc2_.paintBodyVector.push(_loc19_);
            _loc19_.SetUserData(this.mc);
        }
        
        private function checkContact(param1:ContactEvent) : void
        {
            if(param1.impulse > this._initialSmashImpulse[this._foodItemType - 1])
            {
                this._willSmash = true;
                Settings.currentSession.level.singleActionVector.push(this);
                this.removeListeners();
            }
        }
        
        private function removeListeners() : void
        {
            if(!this._shapes)
            {
                return;
            }
            var _loc1_:int = 0;
            while(_loc1_ < this._shapes.length)
            {
                Settings.currentSession.contactListener.deleteListener(ContactEvent.RESULT,this._shapes[_loc1_]);
                _loc1_++;
            }
            this._shapes = null;
        }
        
        public function grindShape(param1:b2Shape) : *
        {
            this._willSmash = false;
            this.removeListeners();
        }
        
        override public function singleAction() : void
        {
            var _loc2_:FoodChunk = null;
            if(!this._willSmash)
            {
                return;
            }
            var _loc1_:int = int(getChildrenWithPrefix(this._chunksMC,"m").length);
            var _loc3_:int = 0;
            while(_loc3_ < _loc1_)
            {
                _loc2_ = new FoodChunk(_loc3_,this._body,this._chunksMC,this);
                _loc3_++;
            }
            Settings.currentSession.level.removeFromPaintBodyVector(this._body);
            var _loc4_:Number = Math.ceil(Math.random() * 3);
            SoundController.instance.playAreaSoundInstance("FoodSplat" + _loc4_,this._body);
            Settings.currentSession.particleController.createRectBurst(this._particleMCs[this._foodItemType - 1],10,this._body,30);
            Settings.currentSession.m_world.DestroyBody(this._body);
            Settings.currentSession.level.background.removeChild(this.mc);
            this.mc = null;
            this._chunksMC = null;
        }
        
        override public function getJointBody(param1:b2Vec2 = null) : b2Body
        {
            return this._body;
        }
        
        private function checkAdd(param1:b2ContactPoint) : void
        {
            if(param1.shape2.m_isSensor)
            {
                return;
            }
            var _loc2_:Number = param1.shape2.m_body.m_mass;
            if(_loc2_ != 0 && _loc2_ < this._body.m_mass)
            {
                return;
            }
            var _loc3_:Number = b2Math.b2Dot(param1.velocity,param1.normal);
            _loc3_ = Math.abs(_loc3_);
            if(_loc3_ > 4)
            {
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
        
        override public function get groupDisplayObject() : DisplayObject
        {
            return this.mc;
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

