package com.totaljerkface.game.level
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.*;
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.editor.RefSprite;
    import com.totaljerkface.game.level.visuals.BackDrop;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.Rectangle;
    import flash.system.*;
    import flash.utils.*;
    
    public class LevelB2D extends EventDispatcher
    {
        protected static const oneEightyOverPI:Number = 180 / Math.PI;
        
        protected static const PIOverOneEighty:Number = Math.PI / 180;
        
        protected var _levelVersion:Number = 0;
        
        public var levelData:Sprite;
        
        public var background:Sprite;
        
        public var characterLayer:Sprite;
        
        public var foreground:Sprite;
        
        public var backDrops:Vector.<BackDrop>;
        
        public var shapeGuide:Sprite;
        
        protected var _session:Session;
        
        internal var m_physScale:Number;
        
        public var levelBody:b2Body;
        
        public var endBlock:EndBlock;
        
        public var paintBodyVector:Vector.<b2Body>;
        
        public var paintItemVector:Vector.<LevelItem>;
        
        public var actionsVector:Vector.<LevelItem>;
        
        public var actionsToRemove:Vector.<LevelItem>;
        
        public var singleActionVector:Vector.<LevelItem>;
        
        public var keepVector:Vector.<LevelItem>;
        
        public function LevelB2D(param1:Sprite, param2:Session)
        {
            super();
            this.session = param2;
            this.m_physScale = param2.m_physScale;
            this.levelData = param1;
            this._levelVersion = param2.levelVersion;
            if(param1.getChildByName("shapeGuide"))
            {
                this.shapeGuide = param1.getChildByName("shapeGuide") as Sprite;
                this.shapeGuide.x = 0;
                this.shapeGuide.y = 0;
            }
        }
        
        public function get session() : Session
        {
            return this._session;
        }
        
        public function set session(param1:Session) : void
        {
            this._session = param1;
        }
        
        public function create() : void
        {
            this.paintBodyVector = new Vector.<b2Body>();
            this.paintItemVector = new Vector.<LevelItem>();
            this.actionsVector = new Vector.<LevelItem>();
            this.actionsToRemove = new Vector.<LevelItem>();
            this.singleActionVector = new Vector.<LevelItem>();
            this.keepVector = new Vector.<LevelItem>();
            this._session.containerSprite.addChildAt(this.shapeGuide,0);
            this.createBackDrops();
            this.createMovieClips();
            this.createStaticShapes();
            this.createDynamicShapes();
            this.createItems();
        }
        
        public function reset() : void
        {
            this.paintBodyVector = new Vector.<b2Body>();
            this.paintItemVector = new Vector.<LevelItem>();
            this.actionsVector = new Vector.<LevelItem>();
            this.actionsToRemove = new Vector.<LevelItem>();
            this.singleActionVector = new Vector.<LevelItem>();
            this.keepVector = new Vector.<LevelItem>();
            this.createStaticShapes();
            this.createDynamicShapes();
            this.createItems();
        }
        
        public function die() : void
        {
            var _loc1_:int = 0;
            var _loc2_:LevelItem = null;
            trace("LEVEL DIE");
            if(this.endBlock)
            {
                this.endBlock.die();
            }
            if(this.actionsVector)
            {
                _loc1_ = 0;
                while(_loc1_ < this.actionsVector.length)
                {
                    _loc2_ = this.actionsVector[_loc1_];
                    _loc2_.die();
                    _loc1_++;
                }
            }
            this.paintBodyVector = null;
            this.paintItemVector = null;
            this.actionsVector = null;
            this.actionsToRemove = null;
            this.singleActionVector = null;
            this.keepVector = null;
        }
        
        public function get startPoint() : b2Vec2
        {
            return new b2Vec2(400,100);
        }
        
        internal function createStaticShapes() : void
        {
            var _loc6_:Number = NaN;
            var _loc8_:DisplayObject = null;
            var _loc9_:Number = NaN;
            var _loc10_:Number = NaN;
            var _loc11_:b2BodyDef = null;
            var _loc12_:b2Body = null;
            var _loc13_:b2PolygonDef = null;
            var _loc14_:int = 0;
            var _loc15_:b2Vec2 = null;
            var _loc16_:Number = NaN;
            var _loc17_:Number = NaN;
            var _loc1_:b2BodyDef = new b2BodyDef();
            this.levelBody = this._session.m_world.CreateBody(_loc1_);
            var _loc2_:b2PolygonDef = new b2PolygonDef();
            var _loc3_:b2CircleDef = new b2CircleDef();
            var _loc4_:b2PolygonDef = new b2PolygonDef();
            _loc2_.friction = 1;
            _loc2_.restitution = 0.1;
            _loc2_.filter.categoryBits = 8;
            _loc2_.filter.groupIndex = -10;
            _loc3_.friction = 1;
            _loc3_.restitution = 0.1;
            _loc3_.filter.categoryBits = 8;
            _loc3_.filter.groupIndex = -10;
            _loc4_.friction = 1;
            _loc4_.restitution = 0.1;
            _loc4_.filter.categoryBits = 8;
            _loc4_.vertexCount = 3;
            _loc4_.filter.groupIndex = -10;
            var _loc5_:b2Vec2 = new b2Vec2();
            var _loc7_:int = 0;
            while(_loc7_ < this.shapeGuide.numChildren)
            {
                _loc8_ = this.shapeGuide.getChildAt(_loc7_);
                _loc8_.visible = false;
                _loc6_ = _loc8_.rotation * Math.PI / 180;
                _loc5_.Set(_loc8_.x / this.m_physScale,_loc8_.y / this.m_physScale);
                switch(_loc8_.name)
                {
                    case "rp":
                        _loc2_.SetAsOrientedBox(_loc8_.scaleX * 5 / this.m_physScale,_loc8_.scaleY * 5 / this.m_physScale,_loc5_,_loc6_);
                        this.levelBody.CreateShape(_loc2_);
                        break;
                    case "cp":
                        _loc3_.localPosition.Set(_loc5_.x,_loc5_.y);
                        _loc3_.radius = _loc8_.scaleX * 5 / this.m_physScale;
                        this.levelBody.CreateShape(_loc3_);
                        break;
                    case "tp":
                        _loc9_ = _loc8_.scaleX * 5 / this.m_physScale;
                        _loc10_ = _loc8_.scaleY * 10 / this.m_physScale;
                        _loc4_.vertices[0] = new b2Vec2(0,_loc10_ * -2);
                        _loc4_.vertices[1] = new b2Vec2(_loc9_,_loc10_);
                        _loc4_.vertices[2] = new b2Vec2(-_loc9_,_loc10_);
                        _loc14_ = 0;
                        while(_loc14_ < 3)
                        {
                            _loc15_ = _loc4_.vertices[_loc14_];
                            _loc16_ = Math.cos(_loc6_) * _loc15_.x - Math.sin(_loc6_) * _loc15_.y;
                            _loc17_ = Math.cos(_loc6_) * _loc15_.y + Math.sin(_loc6_) * _loc15_.x;
                            _loc4_.vertices[_loc14_] = new b2Vec2(_loc5_.x + _loc16_,_loc5_.y + _loc17_);
                            _loc14_++;
                        }
                        this.levelBody.CreateShape(_loc4_);
                        break;
                    case "rpd":
                        _loc11_ = new b2BodyDef();
                        _loc11_.isSleeping = true;
                        _loc12_ = this._session.m_world.CreateBody(_loc11_);
                        _loc13_ = new b2PolygonDef();
                        _loc13_.density = 1;
                        _loc13_.friction = 1;
                        _loc13_.restitution = 0.1;
                        _loc13_.filter.categoryBits = 8;
                        _loc13_.SetAsOrientedBox(_loc8_.scaleX * 5 / this.m_physScale,_loc8_.scaleY * 5 / this.m_physScale,_loc5_,_loc6_);
                        _loc12_.CreateShape(_loc13_);
                        _loc12_.SetMassFromShapes();
                        break;
                    case "cb":
                        break;
                    case "tb":
                        break;
                }
                _loc7_++;
            }
        }
        
        internal function createDynamicShapes() : void
        {
            var _loc2_:Number = NaN;
            var _loc5_:DisplayObject = null;
            var _loc6_:Array = null;
            var _loc7_:MovieClip = null;
            var _loc8_:b2BodyDef = null;
            var _loc9_:b2Body = null;
            var _loc10_:b2PolygonDef = null;
            var _loc1_:b2Vec2 = new b2Vec2();
            var _loc3_:* = "com.totaljerkface.game.level::LevelRectMC";
            var _loc4_:int = 0;
            while(_loc4_ < this.shapeGuide.numChildren)
            {
                _loc5_ = this.shapeGuide.getChildAt(_loc4_);
                _loc2_ = _loc5_.rotation * Math.PI / 180;
                _loc1_.Set(_loc5_.x / this.m_physScale,_loc5_.y / this.m_physScale);
                if(getQualifiedClassName(_loc5_) == _loc3_)
                {
                    _loc5_.visible = false;
                    _loc6_ = _loc5_.name.split("_");
                    _loc7_ = this.background[_loc6_[0] + "mc"];
                    _loc8_ = new b2BodyDef();
                    if(_loc6_[2] == "sleep")
                    {
                        _loc8_.isSleeping = true;
                    }
                    _loc9_ = this._session.m_world.CreateBody(_loc8_);
                    _loc9_.m_userData = _loc7_;
                    _loc10_ = new b2PolygonDef();
                    _loc10_.density = Number(_loc6_[1]);
                    _loc10_.friction = 1;
                    _loc10_.restitution = 0.1;
                    _loc10_.filter.categoryBits = 8;
                    _loc10_.SetAsOrientedBox(_loc5_.scaleX * 5 / this.m_physScale,_loc5_.scaleY * 5 / this.m_physScale,_loc1_,_loc2_);
                    _loc9_.CreateShape(_loc10_);
                    _loc9_.SetMassFromShapes();
                    this.paintBodyVector.push(_loc9_);
                }
                _loc4_++;
            }
        }
        
        internal function createBackDrops() : void
        {
            this.backDrops = new Vector.<BackDrop>();
        }
        
        public function insertBackDrops() : void
        {
            var _loc3_:BackDrop = null;
            var _loc1_:int = int(this.backDrops.length);
            var _loc2_:int = 0;
            while(_loc2_ < _loc1_)
            {
                _loc3_ = this.backDrops[_loc2_];
                this._session.addChildAt(_loc3_,0);
                _loc2_++;
            }
        }
        
        internal function createMovieClips() : void
        {
            this.foreground = this.levelData.getChildByName("foreGround") as Sprite;
            this._session.containerSprite.addChild(this.foreground);
            this._session.particleController.placeBloodBitmap();
            this.background = this.levelData.getChildByName("backGround") as Sprite;
            this._session.containerSprite.addChildAt(this.background,1);
            this.convertBackground();
        }
        
        internal function convertBackground() : void
        {
            var _loc2_:DisplayObject = null;
            var _loc3_:Bitmap = null;
            var _loc1_:int = 0;
            while(_loc1_ < this.background.numChildren)
            {
                _loc2_ = this.background.getChildAt(_loc1_);
                if(_loc2_.name == "bm")
                {
                    _loc3_ = this.createBitmap(_loc2_);
                    this.background.addChildAt(_loc3_,_loc1_);
                    _loc3_.x = _loc2_.x;
                    _loc3_.y = _loc2_.y;
                    this.background.removeChild(_loc2_);
                }
                _loc1_++;
            }
        }
        
        internal function createBitmap(param1:DisplayObject) : Bitmap
        {
            var _loc2_:BitmapData = new BitmapData(param1.width,param1.height,true,16777215);
            _loc2_.draw(param1);
            return new Bitmap(_loc2_);
        }
        
        internal function createItems() : void
        {
            this.endBlock = new EndBlock();
        }
        
        internal function addListeners() : void
        {
        }
        
        public function removeFromPaintBodyVector(param1:b2Body) : void
        {
            var _loc2_:int = int(this.paintBodyVector.indexOf(param1));
            if(_loc2_ > -1)
            {
                this.paintBodyVector.splice(_loc2_,1);
            }
        }
        
        public function removeFromPaintItemVector(param1:LevelItem) : void
        {
            var _loc2_:int = int(this.paintItemVector.indexOf(param1));
            if(_loc2_ > -1)
            {
                this.paintItemVector.splice(_loc2_,1);
            }
        }
        
        public function removeFromActionsVector(param1:LevelItem) : void
        {
            this.actionsToRemove.push(param1);
        }
        
        public function paint() : void
        {
            var _loc3_:b2Body = null;
            var _loc4_:b2Vec2 = null;
            var _loc5_:LevelItem = null;
            var _loc1_:int = int(this.paintBodyVector.length);
            var _loc2_:int = 0;
            while(_loc2_ < _loc1_)
            {
                _loc3_ = this.paintBodyVector[_loc2_];
                _loc4_ = _loc3_.GetWorldCenter();
                _loc3_.m_userData.x = _loc4_.x * this.m_physScale;
                _loc3_.m_userData.y = _loc4_.y * this.m_physScale;
                _loc3_.m_userData.rotation = _loc3_.GetAngle() * oneEightyOverPI % 360;
                _loc2_++;
            }
            _loc1_ = int(this.paintItemVector.length);
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
                _loc5_ = this.paintItemVector[_loc2_];
                _loc5_.paint();
                _loc2_++;
            }
        }
        
        public function actions() : void
        {
            var _loc3_:LevelItem = null;
            var _loc4_:int = 0;
            var _loc1_:int = int(this.singleActionVector.length);
            var _loc2_:int = 0;
            while(_loc2_ < _loc1_)
            {
                _loc3_ = this.singleActionVector[_loc2_];
                _loc3_.singleAction();
                _loc2_++;
            }
            this.singleActionVector = new Vector.<LevelItem>();
            _loc1_ = int(this.actionsVector.length);
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
                _loc3_ = this.actionsVector[_loc2_];
                _loc3_.actions();
                _loc2_++;
            }
            _loc1_ = int(this.actionsToRemove.length);
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
                _loc3_ = this.actionsToRemove[_loc2_];
                _loc4_ = int(this.actionsVector.indexOf(_loc3_));
                if(_loc4_ > -1)
                {
                    this.actionsVector.splice(_loc4_,1);
                }
                _loc2_++;
            }
            this.actionsToRemove = new Vector.<LevelItem>();
        }
        
        public function get cameraBounds() : Rectangle
        {
            var _loc1_:Sprite = this.shapeGuide.getChildByName("camUpper") as Sprite;
            var _loc2_:Sprite = this.shapeGuide.getChildByName("camLower") as Sprite;
            return new Rectangle(_loc2_.x,_loc2_.y,_loc1_.x - _loc2_.x,_loc1_.y - _loc2_.y);
        }
        
        public function get worldBounds() : Rectangle
        {
            var _loc1_:Sprite = this.shapeGuide.getChildByName("upper") as Sprite;
            var _loc2_:Sprite = this.shapeGuide.getChildByName("lower") as Sprite;
            return new Rectangle(_loc2_.x,_loc2_.y,_loc1_.x - _loc2_.x,_loc1_.y - _loc2_.y);
        }
        
        public function registerShapeSound(param1:b2Shape, param2:b2Body) : void
        {
        }
        
        public function updateTargetActionsFor(param1:RefSprite, param2:b2Shape, param3:Sprite, param4:Number, param5:Boolean = false) : void
        {
        }
        
        public function updateTargetActionGroupsFor(param1:RefSprite, param2:b2Body, param3:Sprite) : void
        {
        }
        
        public function get levelVersion() : Number
        {
            return this._levelVersion;
        }
        
        public function set levelVersion(param1:Number) : void
        {
            this._levelVersion = param1;
        }
        
        public function mouseClickTrigger(param1:MouseData) : void
        {
        }
    }
}

