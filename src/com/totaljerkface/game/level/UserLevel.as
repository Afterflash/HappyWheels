package com.totaljerkface.game.level
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Collision.b2ContactPoint;
    import Box2D.Common.Math.b2Math;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.editor.*;
    import com.totaljerkface.game.editor.specials.*;
    import com.totaljerkface.game.editor.trigger.RefTrigger;
    import com.totaljerkface.game.level.groups.Vehicle;
    import com.totaljerkface.game.level.userspecials.*;
    import com.totaljerkface.game.level.visuals.*;
    import com.totaljerkface.game.sound.SoundController;
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.geom.Rectangle;
    import flash.text.*;
    import flash.utils.*;
    
    public class UserLevel extends LevelB2D
    {
        internal var shapeDictionary:Dictionary;
        
        internal var spriteDictionary:Dictionary;
        
        internal var specialDictionary:Dictionary;
        
        internal var groupDictionary:Dictionary;
        
        internal var jointDictionary:Dictionary;
        
        internal var triggerDictionary:Dictionary;
        
        internal var vehicleDictionary:Dictionary;
        
        protected var targetActionDictionary:Dictionary;
        
        protected var refTriggerDictionary:Dictionary;
        
        protected var impactDictionary:Dictionary;
        
        protected var contactAddBuffer:Dictionary;
        
        protected var contactAddSounds:Dictionary;
        
        protected var tokens:int = 0;
        
        protected var totalTokens:int;
        
        private var tokenField:TextField;
        
        private var tokenIcon:Sprite;
        
        private var triggers:Vector.<Trigger>;
        
        protected var borderThickness:Number = 250;
        
        protected var skyHeight:Number = 5000;
        
        public function UserLevel(param1:Sprite, param2:Session)
        {
            super(param1,param2);
            this.levelData = null;
            shapeGuide = param1;
        }
        
        override public function create() : void
        {
            paintBodyVector = new Vector.<b2Body>();
            paintItemVector = new Vector.<LevelItem>();
            actionsVector = new Vector.<LevelItem>();
            actionsToRemove = new Vector.<LevelItem>();
            singleActionVector = new Vector.<LevelItem>();
            keepVector = new Vector.<LevelItem>();
            this.triggers = new Vector.<Trigger>();
            this.impactDictionary = new Dictionary();
            this.contactAddBuffer = new Dictionary();
            this.contactAddSounds = new Dictionary();
            this.createBackDrops();
            this.createMovieClips();
            this.createStaticShapes();
            this.createDynamicShapes();
            this.createSpecials();
            this.createGroups();
            this.createJoints();
            this.createTriggers();
            this.createItems();
            this.createTokenHUD();
        }
        
        override public function reset() : void
        {
            this.die();
            _session.containerSprite.removeChild(background);
            _session.containerSprite.removeChild(characterLayer);
            _session.containerSprite.removeChild(foreground);
            this.tokens = 0;
            paintBodyVector = new Vector.<b2Body>();
            paintItemVector = new Vector.<LevelItem>();
            actionsVector = new Vector.<LevelItem>();
            actionsToRemove = new Vector.<LevelItem>();
            singleActionVector = new Vector.<LevelItem>();
            keepVector = new Vector.<LevelItem>();
            this.triggers = new Vector.<Trigger>();
            this.createMovieClips();
            this.createStaticShapes();
            this.createDynamicShapes();
            this.createSpecials();
            this.createGroups();
            this.createJoints();
            this.createTriggers();
            this.createItems();
            this.createTokenHUD();
        }
        
        override public function die() : void
        {
            super.die();
            this.targetActionDictionary = null;
            this.refTriggerDictionary = null;
            this.triggerDictionary = null;
        }
        
        override public function get startPoint() : b2Vec2
        {
            var _loc1_:Sprite = shapeGuide.getChildByName("main character") as Sprite;
            return new b2Vec2(_loc1_.x,_loc1_.y);
        }
        
        override internal function createStaticShapes() : void
        {
            var _loc7_:Number = NaN;
            var _loc11_:Sprite = null;
            var _loc13_:DisplayObject = null;
            var _loc14_:RefShape = null;
            var _loc15_:RectangleShape = null;
            var _loc16_:b2Shape = null;
            var _loc17_:CircleShape = null;
            var _loc18_:TriangleShape = null;
            var _loc19_:int = 0;
            var _loc20_:b2Vec2 = null;
            var _loc21_:Number = NaN;
            var _loc22_:Number = NaN;
            var _loc23_:PolygonShape = null;
            var _loc24_:int = 0;
            var _loc25_:b2Vec2 = null;
            var _loc26_:b2Vec2 = null;
            this.shapeDictionary = new Dictionary();
            this.spriteDictionary = new Dictionary();
            var _loc1_:b2BodyDef = new b2BodyDef();
            levelBody = _session.m_world.CreateBody(_loc1_);
            var _loc2_:b2PolygonDef = new b2PolygonDef();
            var _loc3_:b2CircleDef = new b2CircleDef();
            var _loc4_:b2PolygonDef = new b2PolygonDef();
            var _loc5_:b2PolygonDef = new b2PolygonDef();
            _loc2_.friction = 1;
            _loc2_.restitution = 0.1;
            _loc2_.filter.categoryBits = 8;
            _loc2_.filter.groupIndex = -10;
            var _loc6_:b2Vec2 = new b2Vec2();
            var _loc8_:Number = this.borderThickness * 0.5 / m_physScale;
            var _loc9_:Number = (this.borderThickness + (Canvas.canvasHeight + this.skyHeight) * 0.5) / m_physScale;
            _loc6_.Set(-_loc8_,(Canvas.canvasHeight - this.skyHeight) * 0.5 / m_physScale);
            _loc2_.SetAsOrientedBox(_loc8_,_loc9_,_loc6_,0);
            levelBody.CreateShape(_loc2_);
            _loc6_.Set((Canvas.canvasWidth + this.borderThickness * 0.5) / m_physScale,(Canvas.canvasHeight - this.skyHeight) * 0.5 / m_physScale);
            _loc2_.SetAsOrientedBox(_loc8_,_loc9_,_loc6_,0);
            levelBody.CreateShape(_loc2_);
            _loc8_ = (this.borderThickness + Canvas.canvasWidth * 0.5) / m_physScale;
            _loc9_ = this.borderThickness * 0.5 / m_physScale;
            _loc6_.Set(Canvas.canvasWidth * 0.5 / m_physScale,-(this.borderThickness * 0.5 + this.skyHeight) / m_physScale);
            _loc2_.SetAsOrientedBox(_loc8_,_loc9_,_loc6_,0);
            levelBody.CreateShape(_loc2_);
            var _loc10_:Sprite = shapeGuide.getChildByName("shapes") as Sprite;
            var _loc12_:int = 0;
            while(_loc12_ < _loc10_.numChildren)
            {
                _loc13_ = _loc10_.getChildAt(_loc12_);
                if(_loc13_ is RefShape)
                {
                    _loc14_ = _loc13_ as RefShape;
                    if(_loc14_.immovable)
                    {
                        _loc11_ = _loc14_.getFlatSprite();
                        background.addChild(_loc11_);
                        this.spriteDictionary[_loc13_] = _loc11_;
                        if(_loc14_.interactive)
                        {
                            _loc7_ = _loc13_.rotation * Math.PI / 180;
                            _loc6_.Set(_loc13_.x / m_physScale,_loc13_.y / m_physScale);
                            if(_loc14_ is RectangleShape)
                            {
                                _loc2_ = new b2PolygonDef();
                                this.setShapeFilter(_loc14_.collision,_loc14_.immovable,_loc2_);
                                _loc15_ = _loc13_ as RectangleShape;
                                _loc2_.SetAsOrientedBox(_loc13_.scaleX * 50 / m_physScale,_loc13_.scaleY * 50 / m_physScale,_loc6_,_loc7_);
                                _loc16_ = levelBody.CreateShape(_loc2_);
                            }
                            else if(_loc14_ is CircleShape)
                            {
                                _loc3_ = new b2CircleDef();
                                this.setShapeFilter(_loc14_.collision,_loc14_.immovable,_loc3_);
                                _loc17_ = _loc13_ as CircleShape;
                                _loc3_.localPosition.Set(_loc6_.x,_loc6_.y);
                                _loc3_.radius = _loc13_.scaleX * 50 / m_physScale;
                                _loc16_ = levelBody.CreateShape(_loc3_);
                            }
                            else if(_loc14_ is TriangleShape)
                            {
                                _loc4_ = new b2PolygonDef();
                                this.setShapeFilter(_loc14_.collision,_loc14_.immovable,_loc4_);
                                _loc4_.vertexCount = 3;
                                _loc18_ = _loc13_ as TriangleShape;
                                _loc8_ = _loc13_.scaleX * 50 / m_physScale;
                                _loc9_ = _loc13_.scaleY * 100 / m_physScale;
                                _loc4_.vertices[0] = new b2Vec2(0,_loc9_ * -2);
                                _loc4_.vertices[1] = new b2Vec2(_loc8_,_loc9_);
                                _loc4_.vertices[2] = new b2Vec2(-_loc8_,_loc9_);
                                _loc19_ = 0;
                                while(_loc19_ < 3)
                                {
                                    _loc20_ = _loc4_.vertices[_loc19_];
                                    _loc21_ = Math.cos(_loc7_) * _loc20_.x - Math.sin(_loc7_) * _loc20_.y;
                                    _loc22_ = Math.cos(_loc7_) * _loc20_.y + Math.sin(_loc7_) * _loc20_.x;
                                    _loc4_.vertices[_loc19_] = new b2Vec2(_loc6_.x + _loc21_,_loc6_.y + _loc22_);
                                    _loc19_++;
                                }
                                _loc16_ = levelBody.CreateShape(_loc4_);
                            }
                            else if(_loc14_ is PolygonShape)
                            {
                                _loc5_ = new b2PolygonDef();
                                this.setShapeFilter(_loc14_.collision,_loc14_.immovable,_loc5_);
                                _loc23_ = _loc13_ as PolygonShape;
                                _loc24_ = _loc5_.vertexCount = _loc23_.numVerts;
                                _loc19_ = 0;
                                while(_loc19_ < _loc24_)
                                {
                                    _loc25_ = _loc23_.vertVector[_loc19_];
                                    _loc26_ = new b2Vec2(_loc23_.scaleX * _loc25_.x / m_physScale,_loc23_.scaleY * _loc25_.y / m_physScale);
                                    _loc21_ = Math.cos(_loc7_) * _loc26_.x - Math.sin(_loc7_) * _loc26_.y;
                                    _loc22_ = Math.cos(_loc7_) * _loc26_.y + Math.sin(_loc7_) * _loc26_.x;
                                    _loc5_.vertices[_loc19_] = new b2Vec2(_loc6_.x + _loc21_,_loc6_.y + _loc22_);
                                    _loc19_++;
                                }
                                _loc16_ = levelBody.CreateShape(_loc5_);
                            }
                            this.shapeDictionary[_loc13_] = _loc16_;
                        }
                    }
                }
                _loc12_++;
            }
        }
        
        override internal function createDynamicShapes() : void
        {
            var _loc2_:Number = NaN;
            var _loc5_:DisplayObject = null;
            var _loc6_:RefShape = null;
            var _loc7_:Sprite = null;
            var _loc8_:RectangleShape = null;
            var _loc9_:b2BodyDef = null;
            var _loc10_:b2Body = null;
            var _loc11_:b2PolygonDef = null;
            var _loc12_:b2Shape = null;
            var _loc13_:CircleShape = null;
            var _loc14_:b2BodyDef = null;
            var _loc15_:b2CircleDef = null;
            var _loc16_:TriangleShape = null;
            var _loc17_:b2BodyDef = null;
            var _loc18_:b2PolygonDef = null;
            var _loc19_:Number = NaN;
            var _loc20_:Number = NaN;
            var _loc21_:PolygonShape = null;
            var _loc22_:b2BodyDef = null;
            var _loc23_:b2PolygonDef = null;
            var _loc24_:int = 0;
            var _loc25_:int = 0;
            var _loc26_:b2Vec2 = null;
            var _loc27_:b2Vec2 = null;
            var _loc1_:b2Vec2 = new b2Vec2();
            var _loc3_:Sprite = shapeGuide.getChildByName("shapes") as Sprite;
            var _loc4_:int = 0;
            while(_loc4_ < _loc3_.numChildren)
            {
                _loc5_ = _loc3_.getChildAt(_loc4_);
                if(_loc5_ is RefShape)
                {
                    _loc6_ = _loc5_ as RefShape;
                    if(!_loc6_.immovable)
                    {
                        _loc7_ = _loc6_.getFlatSprite();
                        if(session.levelVersion >= 1.8)
                        {
                            background.addChildAt(_loc7_,_loc4_);
                        }
                        else
                        {
                            background.addChild(_loc7_);
                        }
                        this.spriteDictionary[_loc5_] = _loc7_;
                        if(_loc6_.interactive)
                        {
                            _loc2_ = _loc5_.rotation * Math.PI / 180;
                            _loc1_.Set(_loc5_.x / m_physScale,_loc5_.y / m_physScale);
                            if(_loc5_ is RectangleShape)
                            {
                                _loc8_ = _loc5_ as RectangleShape;
                                _loc9_ = new b2BodyDef();
                                _loc9_.position.Set(_loc1_.x,_loc1_.y);
                                _loc9_.angle = _loc2_;
                                _loc9_.isSleeping = _loc8_.sleeping;
                                _loc10_ = _session.m_world.CreateBody(_loc9_);
                                _loc10_.m_userData = _loc7_;
                                _loc11_ = new b2PolygonDef();
                                _loc11_.density = _loc8_.density;
                                this.setShapeFilter(_loc6_.collision,_loc6_.immovable,_loc11_);
                                _loc11_.SetAsBox(_loc5_.scaleX * 50 / m_physScale,_loc5_.scaleY * 50 / m_physScale);
                                _loc12_ = _loc10_.CreateShape(_loc11_);
                                _loc10_.SetMassFromShapes();
                                paintBodyVector.push(_loc10_);
                                this.shapeDictionary[_loc5_] = _loc12_;
                            }
                            else if(_loc5_ is CircleShape)
                            {
                                _loc13_ = _loc5_ as CircleShape;
                                _loc14_ = new b2BodyDef();
                                _loc14_.position.Set(_loc1_.x,_loc1_.y);
                                _loc14_.angle = _loc2_;
                                _loc14_.isSleeping = _loc13_.sleeping;
                                _loc10_ = _session.m_world.CreateBody(_loc14_);
                                _loc10_.m_userData = _loc7_;
                                _loc15_ = new b2CircleDef();
                                _loc15_.density = _loc13_.density;
                                this.setShapeFilter(_loc6_.collision,_loc6_.immovable,_loc15_);
                                _loc15_.localPosition.Set(0,0);
                                _loc15_.radius = _loc5_.scaleX * 50 / m_physScale;
                                _loc12_ = _loc10_.CreateShape(_loc15_);
                                _loc10_.SetMassFromShapes();
                                paintBodyVector.push(_loc10_);
                                this.shapeDictionary[_loc5_] = _loc12_;
                            }
                            else if(_loc5_ is TriangleShape)
                            {
                                _loc16_ = _loc5_ as TriangleShape;
                                _loc17_ = new b2BodyDef();
                                _loc17_.isSleeping = _loc16_.sleeping;
                                _loc17_.position.Set(_loc1_.x,_loc1_.y);
                                _loc17_.angle = _loc2_;
                                _loc10_ = _session.m_world.CreateBody(_loc17_);
                                _loc10_.m_userData = _loc7_;
                                _loc18_ = new b2PolygonDef();
                                _loc18_.density = _loc16_.density;
                                this.setShapeFilter(_loc6_.collision,_loc6_.immovable,_loc18_);
                                _loc18_.vertexCount = 3;
                                _loc19_ = _loc16_.scaleX * 50 / m_physScale;
                                _loc20_ = _loc16_.scaleY * 100 / m_physScale;
                                _loc18_.vertices[0] = new b2Vec2(0,_loc20_ * -2);
                                _loc18_.vertices[1] = new b2Vec2(_loc19_,_loc20_);
                                _loc18_.vertices[2] = new b2Vec2(-_loc19_,_loc20_);
                                _loc12_ = _loc10_.CreateShape(_loc18_);
                                _loc10_.SetMassFromShapes();
                                paintBodyVector.push(_loc10_);
                                this.shapeDictionary[_loc5_] = _loc12_;
                            }
                            else if(_loc5_ is PolygonShape)
                            {
                                _loc21_ = _loc5_ as PolygonShape;
                                _loc22_ = new b2BodyDef();
                                _loc22_.isSleeping = _loc21_.sleeping;
                                _loc22_.position.Set(_loc1_.x,_loc1_.y);
                                _loc22_.angle = _loc2_;
                                _loc10_ = _session.m_world.CreateBody(_loc22_);
                                _loc23_ = new b2PolygonDef();
                                _loc23_.density = _loc21_.density;
                                this.setShapeFilter(_loc6_.collision,_loc6_.immovable,_loc23_);
                                _loc24_ = _loc23_.vertexCount = _loc21_.numVerts;
                                _loc25_ = 0;
                                while(_loc25_ < _loc24_)
                                {
                                    _loc27_ = _loc21_.vertVector[_loc25_];
                                    _loc23_.vertices[_loc25_] = new b2Vec2(_loc21_.scaleX * _loc27_.x / m_physScale,_loc21_.scaleY * _loc27_.y / m_physScale);
                                    _loc25_++;
                                }
                                _loc12_ = _loc10_.CreateShape(_loc23_);
                                _loc10_.SetMassFromShapes();
                                _loc26_ = _loc10_.GetLocalCenter().Copy();
                                _loc26_.x *= m_physScale;
                                _loc26_.y *= m_physScale;
                                background.removeChild(_loc7_);
                                _loc7_ = _loc21_.getCenteredSprite(_loc26_);
                                background.addChild(_loc7_);
                                _loc10_.m_userData = _loc7_;
                                paintBodyVector.push(_loc10_);
                                this.shapeDictionary[_loc5_] = _loc12_;
                                this.spriteDictionary[_loc5_] = _loc7_;
                            }
                            this.registerShapeSound(_loc12_,_loc10_);
                        }
                    }
                }
                _loc4_++;
            }
        }
        
        private function setShapeFilter(param1:int, param2:Boolean, param3:b2ShapeDef) : void
        {
            param3.friction = 1;
            param3.restitution = 0.1;
            if(param1 == 2)
            {
                param3.filter.categoryBits = 8;
                param3.filter.maskBits = 8;
                if(_levelVersion > 1.84 && param2)
                {
                    param3.filter.categoryBits = 24;
                    param3.filter.maskBits = 56;
                }
            }
            else if(param1 == 3)
            {
                if(_levelVersion < 1.85)
                {
                    param3.filter.categoryBits = 1;
                    param3.filter.maskBits = 1;
                    param3.filter.groupIndex = -10;
                    param3.isSensor = true;
                }
                else
                {
                    param3.filter.categoryBits = 0;
                    param3.filter.maskBits = 0;
                }
            }
            else if(param1 == 4)
            {
                param3.filter.categoryBits = 8;
                param3.filter.groupIndex = -321;
                if(_levelVersion > 1.84 && param2)
                {
                    param3.filter.categoryBits = 24;
                }
            }
            else if(param1 == 5)
            {
                param3.filter.categoryBits = 16;
                param3.filter.maskBits = 16;
                param3.filter.groupIndex = -322;
                if(_levelVersion > 1.84 && param2)
                {
                    param3.filter.maskBits = 48;
                    param3.filter.groupIndex = 0;
                }
            }
            else if(param1 == 6)
            {
                if(_levelVersion > 1.84)
                {
                    param3.filter.categoryBits = param2 ? 48 : 32;
                    param3.filter.maskBits = 48;
                }
                else
                {
                    param3.filter.categoryBits = 16;
                    param3.filter.maskBits = 16;
                }
            }
            else if(param1 == 7)
            {
                param3.filter.categoryBits = 15;
                param3.filter.maskBits = 3840;
            }
            else if(param2)
            {
                param3.filter.categoryBits = 24;
                param3.filter.groupIndex = -10;
            }
            else
            {
                param3.filter.categoryBits = 8;
            }
        }
        
        internal function _createSpecials() : void
        {
            var _loc3_:Special = null;
            var _loc4_:Van = null;
            var _loc5_:Table = null;
            var _loc6_:Mine = null;
            var _loc7_:IBeam = null;
            var _loc8_:Log = null;
            var _loc9_:SpringBox = null;
            var _loc10_:Spikes = null;
            var _loc11_:WreckingBall = null;
            var _loc12_:Fan = null;
            var _loc13_:FinishLine = null;
            var _loc14_:SoccerBall = null;
            var _loc15_:Meteor = null;
            var _loc16_:Boost = null;
            var _loc17_:Building1 = null;
            var _loc18_:Building2 = null;
            var _loc19_:HarpoonGun = null;
            var _loc20_:TextBox = null;
            var _loc21_:NPCharacter = null;
            var _loc22_:Glass = null;
            var _loc23_:Chair = null;
            var _loc24_:Bottle = null;
            var _loc25_:TV = null;
            var _loc26_:Boombox = null;
            var _loc27_:Toilet = null;
            var _loc28_:SignPost = null;
            var _loc29_:HomingMine = null;
            var _loc30_:TrashCan = null;
            var _loc31_:Jet = null;
            var _loc32_:Rail = null;
            var _loc33_:ArrowGun = null;
            var _loc34_:Chain = null;
            var _loc35_:Token = null;
            var _loc36_:FoodItem = null;
            var _loc37_:Cannon = null;
            var _loc38_:BladeWeapon = null;
            var _loc39_:Wheel = null;
            var _loc40_:Paddle = null;
            var _loc1_:Sprite = shapeGuide.getChildByName("special") as Sprite;
            var _loc2_:int = 0;
            while(_loc2_ < _loc1_.numChildren)
            {
                _loc3_ = _loc1_.getChildAt(_loc2_) as Special;
                if(!(_loc3_ is StartPlaceHolder))
                {
                    if(_loc3_ is VanRef)
                    {
                        _loc4_ = new Van(_loc3_ as VanRef);
                    }
                    else if(_loc3_ is TableRef)
                    {
                        _loc5_ = new Table(_loc3_ as TableRef);
                    }
                    else if(_loc3_ is MineRef)
                    {
                        _loc6_ = new Mine(_loc3_ as MineRef);
                    }
                    else if(_loc3_ is IBeamRef)
                    {
                        _loc7_ = new IBeam(_loc3_ as IBeamRef);
                    }
                    else if(_loc3_ is LogRef)
                    {
                        _loc8_ = new Log(_loc3_ as LogRef);
                    }
                    else if(_loc3_ is SpringBoxRef)
                    {
                        _loc9_ = new SpringBox(_loc3_ as SpringBoxRef);
                    }
                    else if(_loc3_ is SpikesRef)
                    {
                        _loc10_ = new Spikes(_loc3_ as SpikesRef);
                    }
                    else if(_loc3_ is WreckingBallRef)
                    {
                        _loc11_ = new WreckingBall(_loc3_ as WreckingBallRef);
                    }
                    else if(_loc3_ is FanRef)
                    {
                        _loc12_ = new Fan(_loc3_ as FanRef);
                    }
                    else if(_loc3_ is FinishLineRef)
                    {
                        _loc13_ = new FinishLine(_loc3_ as FinishLineRef);
                    }
                    else if(_loc3_ is SoccerBallRef)
                    {
                        _loc14_ = new SoccerBall(_loc3_ as SoccerBallRef);
                    }
                    else if(_loc3_ is MeteorRef)
                    {
                        _loc15_ = new Meteor(_loc3_ as MeteorRef);
                    }
                    else if(_loc3_ is BoostRef)
                    {
                        _loc16_ = new Boost(_loc3_ as BoostRef);
                    }
                    else if(_loc3_ is Building1Ref)
                    {
                        _loc17_ = new Building1(_loc3_ as Building1Ref);
                    }
                    else if(_loc3_ is Building2Ref)
                    {
                        _loc18_ = new Building2(_loc3_ as Building2Ref);
                    }
                    else if(_loc3_ is HarpoonGunRef)
                    {
                        _loc19_ = new HarpoonGun(_loc3_ as HarpoonGunRef);
                    }
                    else if(_loc3_ is TextBoxRef)
                    {
                        _loc20_ = new TextBox(_loc3_ as TextBoxRef);
                    }
                    else if(_loc3_ is NPCharacterRef)
                    {
                        _loc21_ = new NPCharacter(_loc3_ as NPCharacterRef);
                    }
                    else if(_loc3_ is GlassRef)
                    {
                        _loc22_ = new Glass(_loc3_ as GlassRef);
                    }
                    else if(_loc3_ is ChairRef)
                    {
                        _loc23_ = new Chair(_loc3_ as ChairRef);
                    }
                    else if(_loc3_ is BottleRef)
                    {
                        _loc24_ = new Bottle(_loc3_ as BottleRef);
                    }
                    else if(_loc3_ is TVRef)
                    {
                        _loc25_ = new TV(_loc3_ as TVRef);
                    }
                    else if(_loc3_ is BoomboxRef)
                    {
                        _loc26_ = new Boombox(_loc3_ as BoomboxRef);
                    }
                    else if(_loc3_ is ToiletRef)
                    {
                        _loc27_ = new Toilet(_loc3_ as ToiletRef);
                    }
                    else if(_loc3_ is SignPostRef)
                    {
                        _loc28_ = new SignPost(_loc3_ as SignPostRef);
                    }
                    else if(_loc3_ is HomingMineRef)
                    {
                        _loc29_ = new HomingMine(_loc3_ as HomingMineRef);
                    }
                    else if(_loc3_ is TrashCanRef)
                    {
                        _loc30_ = new TrashCan(_loc3_ as TrashCanRef);
                    }
                    else if(_loc3_ is JetRef)
                    {
                        _loc31_ = new Jet(_loc3_ as JetRef);
                    }
                    else if(_loc3_ is RailRef)
                    {
                        _loc32_ = new Rail(_loc3_ as RailRef);
                    }
                    else if(_loc3_ is ArrowGunRef)
                    {
                        _loc33_ = new ArrowGun(_loc3_ as ArrowGunRef);
                    }
                    else if(_loc3_ is ChainRef)
                    {
                        _loc34_ = new Chain(_loc3_ as ChainRef);
                    }
                    else if(_loc3_ is Token)
                    {
                        _loc35_ = new Token(_loc3_ as TokenRef);
                    }
                    else if(_loc3_ is FoodItem)
                    {
                        _loc36_ = new FoodItem(_loc3_ as FoodItemRef);
                    }
                    else if(_loc3_ is CannonRef)
                    {
                        _loc37_ = new Cannon(_loc3_ as CannonRef);
                    }
                    else if(_loc3_ is BladeWeaponRef)
                    {
                        _loc38_ = new BladeWeapon(_loc3_ as BladeWeaponRef);
                    }
                    else if(_loc3_ is WheelRef)
                    {
                        _loc39_ = new Wheel(_loc3_ as WheelRef);
                    }
                    else if(_loc3_ is PaddleRef)
                    {
                        _loc40_ = new Paddle(_loc3_ as PaddleRef);
                    }
                }
                _loc2_++;
            }
        }
        
        internal function createSpecials() : void
        {
            var _loc3_:Special = null;
            var _loc4_:String = null;
            var _loc5_:Array = null;
            var _loc6_:String = null;
            var _loc7_:String = null;
            var _loc8_:Class = null;
            var _loc9_:LevelItem = null;
            var _loc1_:Sprite = shapeGuide.getChildByName("special") as Sprite;
            this.specialDictionary = new Dictionary();
            var _loc2_:int = 0;
            while(_loc2_ < _loc1_.numChildren)
            {
                _loc3_ = _loc1_.getChildAt(_loc2_) as Special;
                _loc4_ = getQualifiedClassName(_loc3_);
                _loc5_ = _loc4_.split("::");
                _loc6_ = _loc5_[_loc5_.length - 1];
                _loc7_ = _loc6_.substring(0,_loc6_.length - 3);
                _loc8_ = getDefinitionByName("com.totaljerkface.game.level.userspecials." + _loc7_) as Class;
                _loc9_ = new _loc8_(_loc3_);
                if(_loc9_ is Token)
                {
                    ++this.tokens;
                }
                this.specialDictionary[_loc3_] = _loc9_;
                _loc2_++;
            }
            this.totalTokens = this.tokens;
        }
        
        internal function createGroups() : void
        {
            var _loc4_:RefGroup = null;
            var _loc5_:Number = NaN;
            var _loc6_:b2Vec2 = null;
            var _loc7_:b2BodyDef = null;
            var _loc8_:b2Body = null;
            var _loc9_:Sprite = null;
            var _loc10_:Sprite = null;
            var _loc11_:int = 0;
            var _loc12_:b2Vec2 = null;
            var _loc13_:RefVehicle = null;
            var _loc14_:Vehicle = null;
            var _loc15_:RefShape = null;
            var _loc16_:Sprite = null;
            var _loc17_:Boolean = false;
            var _loc18_:b2PolygonDef = null;
            var _loc19_:b2Shape = null;
            var _loc20_:b2CircleDef = null;
            var _loc21_:b2PolygonDef = null;
            var _loc22_:Number = NaN;
            var _loc23_:Number = NaN;
            var _loc24_:int = 0;
            var _loc25_:b2Vec2 = null;
            var _loc26_:Number = NaN;
            var _loc27_:Number = NaN;
            var _loc28_:b2PolygonDef = null;
            var _loc29_:PolygonShape = null;
            var _loc30_:int = 0;
            var _loc31_:b2Vec2 = null;
            var _loc32_:b2Vec2 = null;
            var _loc33_:Special = null;
            var _loc34_:String = null;
            var _loc35_:Array = null;
            var _loc36_:String = null;
            var _loc37_:String = null;
            var _loc38_:Class = null;
            var _loc39_:LevelItem = null;
            var _loc40_:DisplayObject = null;
            var _loc41_:b2Vec2 = null;
            var _loc42_:b2MassData = null;
            var _loc1_:Sprite = shapeGuide.getChildByName("groups") as Sprite;
            this.groupDictionary = new Dictionary();
            this.vehicleDictionary = new Dictionary();
            var _loc2_:Number = Math.PI / 180;
            var _loc3_:int = 0;
            while(_loc3_ < _loc1_.numChildren)
            {
                _loc4_ = _loc1_.getChildAt(_loc3_) as RefGroup;
                _loc5_ = _loc4_.rotation * _loc2_;
                _loc6_ = new b2Vec2(_loc4_.x / m_physScale,_loc4_.y / m_physScale);
                if(_loc4_.shapesUsed > 0)
                {
                    _loc7_ = new b2BodyDef();
                    _loc7_.position.Set(_loc6_.x,_loc6_.y);
                    _loc7_.angle = _loc5_;
                    _loc7_.isSleeping = _loc4_.sleeping;
                    _loc7_.fixedRotation = _loc4_.fixedRotation;
                    _loc8_ = _session.m_world.CreateBody(_loc7_);
                    _loc9_ = new Sprite();
                    _loc10_ = new Sprite();
                    _loc9_.addChild(_loc10_);
                    _loc8_.m_userData = _loc9_;
                    _loc9_.alpha = _loc4_.opacity * 0.01;
                    if(_loc4_.foreground)
                    {
                        foreground.addChild(_loc9_);
                    }
                    else
                    {
                        background.addChild(_loc9_);
                    }
                    if(_loc4_ is RefVehicle)
                    {
                        _loc13_ = _loc4_ as RefVehicle;
                        _loc14_ = new Vehicle(_loc13_,_loc8_);
                        this.vehicleDictionary[_loc4_] = _loc14_;
                    }
                    _loc11_ = 0;
                    while(_loc11_ < _loc4_.shapeContainer.numChildren)
                    {
                        _loc15_ = _loc4_.shapeContainer.getChildAt(_loc11_) as RefShape;
                        if(_loc15_.interactive)
                        {
                            _loc6_.Set((_loc15_.x + _loc4_.offset.x) / m_physScale,(_loc15_.y + _loc4_.offset.y) / m_physScale);
                            _loc5_ = _loc15_.rotation * _loc2_;
                            _loc17_ = _levelVersion > 1.84 ? _loc4_.immovable : _loc15_.immovable;
                            if(_loc15_ is RectangleShape)
                            {
                                _loc18_ = new b2PolygonDef();
                                _loc18_.density = _loc15_.density;
                                this.setShapeFilter(_loc15_.collision,_loc17_,_loc18_);
                                _loc18_.SetAsOrientedBox(_loc15_.scaleX * 50 / m_physScale,_loc15_.scaleY * 50 / m_physScale,_loc6_,_loc5_);
                                _loc19_ = _loc8_.CreateShape(_loc18_);
                            }
                            else if(_loc15_ is CircleShape)
                            {
                                _loc20_ = new b2CircleDef();
                                _loc20_.density = _loc15_.density;
                                this.setShapeFilter(_loc15_.collision,_loc17_,_loc20_);
                                _loc20_.localPosition.Set(_loc6_.x,_loc6_.y);
                                _loc20_.radius = _loc15_.scaleX * 50 / m_physScale;
                                _loc19_ = _loc8_.CreateShape(_loc20_);
                            }
                            else if(_loc15_ is TriangleShape)
                            {
                                _loc21_ = new b2PolygonDef();
                                _loc21_.density = _loc15_.density;
                                this.setShapeFilter(_loc15_.collision,_loc17_,_loc21_);
                                _loc21_.vertexCount = 3;
                                _loc22_ = _loc15_.scaleX * 50 / m_physScale;
                                _loc23_ = _loc15_.scaleY * 100 / m_physScale;
                                _loc21_.vertices[0] = new b2Vec2(0,_loc23_ * -2);
                                _loc21_.vertices[1] = new b2Vec2(_loc22_,_loc23_);
                                _loc21_.vertices[2] = new b2Vec2(-_loc22_,_loc23_);
                                _loc24_ = 0;
                                while(_loc24_ < 3)
                                {
                                    _loc25_ = _loc21_.vertices[_loc24_];
                                    _loc26_ = Math.cos(_loc5_) * _loc25_.x - Math.sin(_loc5_) * _loc25_.y;
                                    _loc27_ = Math.cos(_loc5_) * _loc25_.y + Math.sin(_loc5_) * _loc25_.x;
                                    _loc21_.vertices[_loc24_] = new b2Vec2(_loc6_.x + _loc26_,_loc6_.y + _loc27_);
                                    _loc24_++;
                                }
                                _loc19_ = _loc8_.CreateShape(_loc21_);
                            }
                            else
                            {
                                if(!(_loc15_ is PolygonShape))
                                {
                                    throw new Error("shape isn\'t a defined type ");
                                }
                                _loc28_ = new b2PolygonDef();
                                _loc28_.density = _loc15_.density;
                                this.setShapeFilter(_loc15_.collision,_loc17_,_loc28_);
                                _loc29_ = _loc15_ as PolygonShape;
                                _loc30_ = _loc28_.vertexCount = _loc29_.numVerts;
                                _loc24_ = 0;
                                while(_loc24_ < _loc30_)
                                {
                                    _loc31_ = _loc29_.vertVector[_loc24_];
                                    _loc32_ = new b2Vec2(_loc29_.scaleX * _loc31_.x / m_physScale,_loc29_.scaleY * _loc31_.y / m_physScale);
                                    _loc26_ = Math.cos(_loc5_) * _loc32_.x - Math.sin(_loc5_) * _loc32_.y;
                                    _loc27_ = Math.cos(_loc5_) * _loc32_.y + Math.sin(_loc5_) * _loc32_.x;
                                    _loc28_.vertices[_loc24_] = new b2Vec2(_loc6_.x + _loc26_,_loc6_.y + _loc27_);
                                    _loc24_++;
                                }
                                _loc19_ = _loc8_.CreateShape(_loc28_);
                            }
                            _loc19_.SetMaterial(8);
                            if(_loc15_.vehicleHandle && Boolean(_loc14_))
                            {
                                _loc14_.addHandle(_loc19_);
                            }
                        }
                        _loc16_ = _loc15_.getFlatSprite();
                        _loc16_.x += _loc4_.offset.x;
                        _loc16_.y += _loc4_.offset.y;
                        _loc10_.addChild(_loc16_);
                        _loc11_++;
                    }
                    _loc11_ = 0;
                    while(_loc11_ < _loc4_.specialContainer.numChildren)
                    {
                        _loc33_ = _loc4_.specialContainer.getChildAt(_loc11_) as Special;
                        _loc34_ = getQualifiedClassName(_loc33_);
                        _loc35_ = _loc34_.split("::");
                        _loc36_ = _loc35_[_loc35_.length - 1];
                        _loc37_ = _loc36_.substring(0,_loc36_.length - 3);
                        _loc38_ = getDefinitionByName("com.totaljerkface.game.level.userspecials." + _loc37_) as Class;
                        _loc39_ = new _loc38_(_loc33_,_loc8_,_loc4_.offset);
                        _loc40_ = _loc39_.groupDisplayObject;
                        _loc40_.x += _loc4_.offset.x;
                        _loc40_.y += _loc4_.offset.y;
                        _loc10_.addChild(_loc40_);
                        if(_loc39_ is ArrowGun && Boolean(_loc14_))
                        {
                            _loc14_.checkAddSpecial(_loc39_);
                        }
                        _loc11_++;
                    }
                    _loc8_.SetMassFromShapes();
                    _loc12_ = _loc8_.GetLocalCenter();
                    _loc10_.x = -_loc12_.x * m_physScale;
                    _loc10_.y = -_loc12_.y * m_physScale;
                    paintBodyVector.push(_loc8_);
                    this.groupDictionary[_loc4_] = _loc8_;
                    if(_loc14_)
                    {
                        _loc14_.setShitUp();
                        _loc14_ = null;
                    }
                    if(_loc4_.immovable)
                    {
                        if(_loc8_.m_mass > 0)
                        {
                            _loc41_ = _loc8_.GetWorldCenter();
                            _loc8_.m_userData.x = _loc41_.x * m_physScale;
                            _loc8_.m_userData.y = _loc41_.y * m_physScale;
                            _loc8_.m_userData.rotation = _loc8_.GetAngle() * oneEightyOverPI % 360;
                            _loc42_ = new b2MassData();
                            _loc42_.center = new b2Vec2();
                            _loc42_.mass = 0;
                            _loc42_.I = 0;
                            _loc8_.SetMass(_loc42_);
                            _loc8_.SetLinearVelocity(new b2Vec2());
                            _loc8_.SetAngularVelocity(0);
                            removeFromPaintBodyVector(_loc8_);
                        }
                    }
                }
                else
                {
                    _loc9_ = new Sprite();
                    _loc10_ = new Sprite();
                    _loc9_.addChild(_loc10_);
                    _loc9_.alpha = _loc4_.opacity * 0.01;
                    if(_loc4_.foreground)
                    {
                        foreground.addChild(_loc9_);
                    }
                    else
                    {
                        background.addChild(_loc9_);
                    }
                    _loc11_ = 0;
                    while(_loc11_ < _loc4_.shapeContainer.numChildren)
                    {
                        _loc15_ = _loc4_.shapeContainer.getChildAt(_loc11_) as RefShape;
                        _loc16_ = _loc15_.getFlatSprite();
                        _loc16_.x += _loc4_.offset.x;
                        _loc16_.y += _loc4_.offset.y;
                        _loc10_.addChild(_loc16_);
                        _loc11_++;
                    }
                    _loc11_ = 0;
                    while(_loc11_ < _loc4_.specialContainer.numChildren)
                    {
                        _loc33_ = _loc4_.specialContainer.getChildAt(_loc11_) as Special;
                        _loc34_ = getQualifiedClassName(_loc33_);
                        _loc35_ = _loc34_.split("::");
                        _loc36_ = _loc35_[_loc35_.length - 1];
                        _loc37_ = _loc36_.substring(0,_loc36_.length - 3);
                        _loc38_ = getDefinitionByName("com.totaljerkface.game.level.userspecials." + _loc37_) as Class;
                        _loc39_ = new _loc38_(_loc33_,null,_loc4_.offset);
                        _loc40_ = _loc39_.groupDisplayObject;
                        _loc40_.x += _loc4_.offset.x;
                        _loc40_.y += _loc4_.offset.y;
                        _loc10_.addChild(_loc40_);
                        _loc11_++;
                    }
                    _loc9_.x = _loc4_.x;
                    _loc9_.y = _loc4_.y;
                    _loc9_.rotation = _loc4_.rotation;
                }
                this.spriteDictionary[_loc4_] = _loc9_;
                _loc3_++;
            }
        }
        
        internal function createJoints() : void
        {
            var _loc4_:b2Body = null;
            var _loc5_:b2Body = null;
            var _loc6_:Vehicle = null;
            var _loc7_:Vehicle = null;
            var _loc10_:DisplayObject = null;
            var _loc11_:PinJoint = null;
            var _loc12_:b2RevoluteJointDef = null;
            var _loc13_:b2Vec2 = null;
            var _loc14_:b2RevoluteJoint = null;
            var _loc15_:LevelItem = null;
            var _loc16_:RefSprite = null;
            var _loc17_:b2Shape = null;
            var _loc18_:PrisJoint = null;
            var _loc19_:b2PrismaticJointDef = null;
            var _loc20_:b2Vec2 = null;
            var _loc21_:b2PrismaticJoint = null;
            this.jointDictionary = new Dictionary();
            var _loc1_:b2Vec2 = new b2Vec2();
            var _loc2_:Sprite = shapeGuide.getChildByName("joints") as Sprite;
            var _loc3_:Sprite = shapeGuide.getChildByName("shapes") as Sprite;
            var _loc8_:NPCharacter = null;
            var _loc9_:int = 0;
            while(_loc9_ < _loc2_.numChildren)
            {
                _loc10_ = _loc2_.getChildAt(_loc9_);
                if(_loc10_ is PinJoint)
                {
                    _loc11_ = _loc10_ as PinJoint;
                    _loc12_ = new b2RevoluteJointDef();
                    _loc13_ = new b2Vec2();
                    _loc13_.Set(_loc11_.x / m_physScale,_loc11_.y / m_physScale);
                    if(_loc11_.body1)
                    {
                        if(_loc11_.body1 is Special)
                        {
                            _loc15_ = this.specialDictionary[_loc11_.body1] as LevelItem;
                            _loc4_ = _loc15_.getJointBody(_loc13_);
                            if(_loc15_ is NPCharacter)
                            {
                                _loc8_ = _loc15_ as NPCharacter;
                            }
                        }
                        else if(_loc11_.body1 is RefGroup)
                        {
                            _loc4_ = this.groupDictionary[_loc11_.body1];
                            if(this.vehicleDictionary[_loc11_.body1])
                            {
                                _loc6_ = this.vehicleDictionary[_loc11_.body1];
                                if(_loc11_.body2)
                                {
                                    _loc16_ = _loc11_.body2;
                                    if(_loc16_ is Special)
                                    {
                                        _loc6_.checkAddSpecial(this.specialDictionary[_loc16_]);
                                    }
                                    else if(_loc16_ is RefVehicle)
                                    {
                                        _loc6_.checkAddVehicle(this.vehicleDictionary[_loc16_]);
                                    }
                                }
                            }
                        }
                        else
                        {
                            _loc17_ = this.shapeDictionary[_loc11_.body1];
                            _loc4_ = _loc17_.GetBody();
                        }
                    }
                    else
                    {
                        _loc4_ = levelBody;
                    }
                    if(_loc11_.body2)
                    {
                        if(_loc11_.body2 is Special)
                        {
                            _loc15_ = this.specialDictionary[_loc11_.body2] as LevelItem;
                            _loc5_ = _loc15_.getJointBody(_loc13_);
                            if(_loc15_ is NPCharacter)
                            {
                                _loc8_ = _loc15_ as NPCharacter;
                            }
                        }
                        else if(_loc11_.body2 is RefGroup)
                        {
                            _loc5_ = this.groupDictionary[_loc11_.body2];
                            if(this.vehicleDictionary[_loc11_.body2])
                            {
                                _loc7_ = this.vehicleDictionary[_loc11_.body2];
                                if(_loc11_.body1)
                                {
                                    _loc16_ = _loc11_.body1;
                                    if(_loc16_ is Special)
                                    {
                                        _loc7_.checkAddSpecial(this.specialDictionary[_loc16_]);
                                    }
                                    else if(_loc16_ is RefVehicle)
                                    {
                                        _loc7_.checkAddVehicle(this.vehicleDictionary[_loc16_]);
                                    }
                                }
                            }
                        }
                        else
                        {
                            _loc17_ = this.shapeDictionary[_loc11_.body2];
                            _loc5_ = _loc17_.GetBody();
                        }
                    }
                    else
                    {
                        _loc5_ = levelBody;
                    }
                    _loc12_.Initialize(_loc4_,_loc5_,_loc13_);
                    if(_loc11_.limit)
                    {
                        _loc12_.enableLimit = true;
                        _loc12_.upperAngle = _loc11_.upperAngle * Math.PI / 180;
                        _loc12_.lowerAngle = _loc11_.lowerAngle * Math.PI / 180;
                    }
                    _loc12_.maxMotorTorque = 50;
                    if(_loc11_.motor)
                    {
                        _loc12_.enableMotor = true;
                        _loc12_.maxMotorTorque = _loc11_.torque;
                        _loc12_.motorSpeed = _loc11_.speed;
                    }
                    if(_levelVersion > 1.84)
                    {
                        _loc12_.upperAngle = _loc11_.upperAngle * Math.PI / 180;
                        _loc12_.lowerAngle = _loc11_.lowerAngle * Math.PI / 180;
                        _loc12_.maxMotorTorque = _loc11_.torque;
                        _loc12_.motorSpeed = _loc11_.speed;
                    }
                    if(_loc11_.collideSelf)
                    {
                        _loc12_.collideConnected = true;
                    }
                    _loc14_ = _session.m_world.CreateJoint(_loc12_) as b2RevoluteJoint;
                    if(Boolean(_loc6_) && _loc11_.vehicleControlled)
                    {
                        _loc6_.addJoint(_loc14_);
                    }
                    if(Boolean(_loc7_) && _loc11_.vehicleControlled)
                    {
                        _loc7_.addJoint(_loc14_);
                    }
                    if(_loc8_)
                    {
                        _loc8_.addUserJoint(_loc14_);
                    }
                    _loc6_ = _loc7_ = null;
                    _loc8_ = null;
                    this.jointDictionary[_loc10_] = _loc14_;
                }
                else if(_loc10_ is PrisJoint)
                {
                    _loc18_ = _loc10_ as PrisJoint;
                    _loc19_ = new b2PrismaticJointDef();
                    _loc13_ = new b2Vec2();
                    _loc13_.Set(_loc18_.x / m_physScale,_loc18_.y / m_physScale);
                    if(_loc18_.body1)
                    {
                        if(_loc18_.body1 is Special)
                        {
                            _loc15_ = this.specialDictionary[_loc18_.body1] as LevelItem;
                            _loc4_ = _loc15_.getJointBody(_loc13_);
                            if(_loc15_ is NPCharacter)
                            {
                                _loc8_ = _loc15_ as NPCharacter;
                            }
                        }
                        else if(_loc18_.body1 is RefGroup)
                        {
                            _loc4_ = this.groupDictionary[_loc18_.body1];
                            if(this.vehicleDictionary[_loc18_.body1])
                            {
                                _loc6_ = this.vehicleDictionary[_loc18_.body1];
                                if(_loc18_.body2)
                                {
                                    _loc16_ = _loc18_.body2;
                                    if(_loc16_ is Special)
                                    {
                                        _loc6_.checkAddSpecial(this.specialDictionary[_loc16_]);
                                    }
                                    else if(_loc16_ is RefVehicle)
                                    {
                                        _loc6_.checkAddVehicle(this.vehicleDictionary[_loc16_]);
                                    }
                                }
                            }
                        }
                        else
                        {
                            _loc17_ = this.shapeDictionary[_loc18_.body1];
                            _loc4_ = _loc17_.GetBody();
                        }
                    }
                    else
                    {
                        _loc4_ = levelBody;
                    }
                    if(_loc18_.body2)
                    {
                        if(_loc18_.body2 is Special)
                        {
                            _loc15_ = this.specialDictionary[_loc18_.body2] as LevelItem;
                            _loc5_ = _loc15_.getJointBody(_loc13_);
                            if(_loc15_ is NPCharacter)
                            {
                                _loc8_ = _loc15_ as NPCharacter;
                            }
                        }
                        else if(_loc18_.body2 is RefGroup)
                        {
                            _loc5_ = this.groupDictionary[_loc18_.body2];
                            if(this.vehicleDictionary[_loc18_.body2])
                            {
                                _loc7_ = this.vehicleDictionary[_loc18_.body2];
                                if(_loc18_.body1)
                                {
                                    _loc16_ = _loc18_.body1;
                                    if(_loc16_ is Special)
                                    {
                                        _loc7_.checkAddSpecial(this.specialDictionary[_loc16_]);
                                    }
                                    else if(_loc16_ is RefVehicle)
                                    {
                                        _loc7_.checkAddVehicle(this.vehicleDictionary[_loc16_]);
                                    }
                                }
                            }
                        }
                        else
                        {
                            _loc17_ = this.shapeDictionary[_loc18_.body2];
                            _loc5_ = _loc17_.GetBody();
                        }
                    }
                    else
                    {
                        _loc5_ = levelBody;
                    }
                    _loc20_ = new b2Vec2(Math.cos(_loc18_.axisAngle * PIOverOneEighty),Math.sin(_loc18_.axisAngle * PIOverOneEighty));
                    _loc19_.Initialize(_loc4_,_loc5_,_loc13_,_loc20_);
                    if(_loc18_.limit)
                    {
                        _loc19_.enableLimit = true;
                    }
                    _loc19_.upperTranslation = _loc18_.upperLimit / m_physScale;
                    _loc19_.lowerTranslation = _loc18_.lowerLimit / m_physScale;
                    if(_loc18_.motor)
                    {
                        _loc19_.enableMotor = true;
                    }
                    _loc19_.maxMotorForce = _loc18_.force;
                    _loc19_.motorSpeed = _loc18_.speed;
                    if(_loc18_.collideSelf)
                    {
                        _loc19_.collideConnected = true;
                    }
                    _loc21_ = _session.m_world.CreateJoint(_loc19_) as b2PrismaticJoint;
                    if(Boolean(_loc6_) && _loc18_.vehicleControlled)
                    {
                        _loc6_.addJoint(_loc21_);
                    }
                    if(Boolean(_loc7_) && _loc18_.vehicleControlled)
                    {
                        _loc7_.addJoint(_loc21_);
                    }
                    if(_loc8_)
                    {
                        _loc8_.addUserJoint(_loc21_);
                    }
                    _loc6_ = _loc7_ = null;
                    _loc8_ = null;
                    this.jointDictionary[_loc10_] = _loc21_;
                }
                _loc9_++;
            }
        }
        
        internal function createTriggers() : void
        {
            var _loc2_:int = 0;
            var _loc3_:RefTrigger = null;
            var _loc4_:Trigger = null;
            var _loc5_:Array = null;
            var _loc6_:int = 0;
            var _loc7_:int = 0;
            var _loc8_:RefSprite = null;
            var _loc9_:b2Shape = null;
            var _loc10_:Sprite = null;
            var _loc11_:Array = null;
            var _loc12_:int = 0;
            var _loc13_:int = 0;
            var _loc14_:String = null;
            var _loc15_:int = 0;
            var _loc16_:Array = null;
            var _loc17_:Array = null;
            var _loc18_:TargetAction = null;
            var _loc19_:int = 0;
            var _loc20_:String = null;
            var _loc21_:Dictionary = null;
            var _loc22_:Vector.<LevelItem> = null;
            var _loc23_:Vector.<Trigger> = null;
            var _loc24_:LevelItem = null;
            var _loc25_:Array = null;
            var _loc26_:TargetActionSpecial = null;
            var _loc27_:b2Body = null;
            var _loc28_:TargetActionGroup = null;
            var _loc29_:b2RevoluteJoint = null;
            var _loc30_:TargetActionRevJoint = null;
            var _loc31_:b2PrismaticJoint = null;
            var _loc32_:TargetActionPrisJoint = null;
            var _loc33_:Trigger = null;
            var _loc34_:TargetActionTrigger = null;
            this.targetActionDictionary = new Dictionary();
            this.refTriggerDictionary = new Dictionary();
            this.triggerDictionary = new Dictionary();
            var _loc1_:Sprite = shapeGuide.getChildByName("triggers") as Sprite;
            _loc2_ = 0;
            while(_loc2_ < _loc1_.numChildren)
            {
                _loc3_ = _loc1_.getChildAt(_loc2_) as RefTrigger;
                _loc4_ = new Trigger(_loc3_,_loc2_);
                this.triggers.push(_loc4_);
                this.triggerDictionary[_loc3_] = _loc4_;
                _loc2_++;
            }
            _loc2_ = 0;
            while(_loc2_ < _loc1_.numChildren)
            {
                _loc3_ = _loc1_.getChildAt(_loc2_) as RefTrigger;
                _loc4_ = this.triggerDictionary[_loc3_];
                if(_loc3_.typeIndex == 1)
                {
                    _loc5_ = _loc3_.targets;
                    _loc6_ = int(_loc5_.length);
                    _loc7_ = 0;
                    while(_loc7_ < _loc6_)
                    {
                        _loc8_ = _loc5_[_loc7_];
                        if(_loc8_ is RefShape)
                        {
                            _loc9_ = this.shapeDictionary[_loc8_];
                            _loc10_ = this.spriteDictionary[_loc8_];
                            _loc11_ = _loc8_.triggerActions[_loc3_];
                            _loc12_ = int(_loc11_.length);
                            _loc13_ = 0;
                            while(_loc13_ < _loc12_)
                            {
                                _loc14_ = _loc11_[_loc13_];
                                _loc15_ = int(_loc8_.triggerActionList.indexOf(_loc14_));
                                _loc16_ = _loc8_.triggerActionListProperties[_loc15_];
                                _loc17_ = null;
                                if(_loc16_)
                                {
                                    _loc17_ = new Array();
                                    _loc19_ = 0;
                                    while(_loc19_ < _loc16_.length)
                                    {
                                        _loc20_ = _loc16_[_loc19_];
                                        _loc21_ = _loc8_.keyedPropertyObject[_loc20_];
                                        _loc17_.push(_loc21_[_loc3_][_loc13_]);
                                        _loc19_++;
                                    }
                                }
                                _loc18_ = _loc4_.addTargetActionShape(_loc8_,_loc9_,_loc10_,_loc14_,_loc17_);
                                if(this.targetActionDictionary[_loc8_])
                                {
                                    _loc22_ = this.targetActionDictionary[_loc8_];
                                }
                                else
                                {
                                    _loc22_ = new Vector.<LevelItem>();
                                    this.targetActionDictionary[_loc8_] = _loc22_;
                                }
                                _loc22_.push(_loc18_);
                                _loc13_++;
                            }
                            if(this.refTriggerDictionary[_loc8_])
                            {
                                _loc23_ = this.refTriggerDictionary[_loc8_];
                            }
                            else
                            {
                                _loc23_ = new Vector.<Trigger>();
                                this.refTriggerDictionary[_loc8_] = _loc23_;
                            }
                            _loc23_.push(_loc4_);
                        }
                        else if(_loc8_ is Special)
                        {
                            _loc24_ = this.specialDictionary[_loc8_];
                            _loc25_ = _loc8_.triggerActionList;
                            _loc14_ = undefined;
                            _loc17_ = null;
                            if(_loc25_)
                            {
                                _loc11_ = _loc8_.triggerActions[_loc3_];
                                _loc12_ = int(_loc11_.length);
                                _loc13_ = 0;
                                while(_loc13_ < _loc12_)
                                {
                                    _loc14_ = _loc11_[_loc13_];
                                    _loc15_ = int(_loc8_.triggerActionList.indexOf(_loc14_));
                                    _loc16_ = _loc8_.triggerActionListProperties[_loc15_];
                                    if(_loc16_)
                                    {
                                        _loc17_ = new Array();
                                        _loc19_ = 0;
                                        while(_loc19_ < _loc16_.length)
                                        {
                                            _loc20_ = _loc16_[_loc19_];
                                            _loc21_ = _loc8_.keyedPropertyObject[_loc20_];
                                            _loc17_.push(_loc21_[_loc3_][_loc13_]);
                                            _loc19_++;
                                        }
                                    }
                                    _loc26_ = _loc4_.addTargetItemSpecial(_loc24_,_loc8_,_loc14_,_loc17_);
                                    _loc13_++;
                                }
                            }
                            else
                            {
                                _loc26_ = _loc4_.addTargetItemSpecial(_loc24_,_loc8_,_loc14_,_loc17_);
                            }
                            _loc24_.prepareForTrigger();
                        }
                        else if(_loc8_ is RefGroup)
                        {
                            _loc27_ = this.groupDictionary[_loc8_];
                            _loc10_ = this.spriteDictionary[_loc8_];
                            _loc11_ = _loc8_.triggerActions[_loc3_];
                            _loc12_ = int(_loc11_.length);
                            _loc13_ = 0;
                            while(_loc13_ < _loc12_)
                            {
                                _loc14_ = _loc11_[_loc13_];
                                _loc15_ = int(_loc8_.triggerActionList.indexOf(_loc14_));
                                _loc16_ = _loc8_.triggerActionListProperties[_loc15_];
                                if(_loc16_)
                                {
                                    _loc17_ = new Array();
                                    _loc19_ = 0;
                                    while(_loc19_ < _loc16_.length)
                                    {
                                        _loc20_ = _loc16_[_loc19_];
                                        _loc21_ = _loc8_.keyedPropertyObject[_loc20_];
                                        _loc17_.push(_loc21_[_loc3_][_loc13_]);
                                        _loc19_++;
                                    }
                                }
                                _loc28_ = _loc4_.addTargetActionGroup(_loc8_,_loc27_,_loc10_,_loc14_,_loc17_);
                                _loc13_++;
                            }
                            if(this.targetActionDictionary[_loc8_])
                            {
                                _loc22_ = this.targetActionDictionary[_loc8_];
                            }
                            else
                            {
                                _loc22_ = new Vector.<LevelItem>();
                                this.targetActionDictionary[_loc8_] = _loc22_;
                            }
                            _loc22_.push(_loc28_);
                        }
                        else if(_loc8_ is RefJoint)
                        {
                            if(_loc8_ is PinJoint)
                            {
                                _loc29_ = this.jointDictionary[_loc8_];
                                _loc11_ = _loc8_.triggerActions[_loc3_];
                                _loc12_ = int(_loc11_.length);
                                _loc13_ = 0;
                                while(_loc13_ < _loc12_)
                                {
                                    _loc14_ = _loc11_[_loc13_];
                                    _loc15_ = int(_loc8_.triggerActionList.indexOf(_loc14_));
                                    _loc16_ = _loc8_.triggerActionListProperties[_loc15_];
                                    if(_loc16_)
                                    {
                                        _loc17_ = new Array();
                                        _loc19_ = 0;
                                        while(_loc19_ < _loc16_.length)
                                        {
                                            _loc20_ = _loc16_[_loc19_];
                                            _loc21_ = _loc8_.keyedPropertyObject[_loc20_];
                                            _loc17_.push(_loc21_[_loc3_][_loc13_]);
                                            _loc19_++;
                                        }
                                    }
                                    _loc30_ = _loc4_.addTargetActionRevJoint(_loc8_,_loc29_,_loc14_,_loc17_);
                                    _loc13_++;
                                }
                            }
                            else if(_loc8_ is PrisJoint)
                            {
                                _loc31_ = this.jointDictionary[_loc8_];
                                _loc11_ = _loc8_.triggerActions[_loc3_];
                                _loc12_ = int(_loc11_.length);
                                _loc13_ = 0;
                                while(_loc13_ < _loc12_)
                                {
                                    _loc14_ = _loc11_[_loc13_];
                                    _loc15_ = int(_loc8_.triggerActionList.indexOf(_loc14_));
                                    _loc16_ = _loc8_.triggerActionListProperties[_loc15_];
                                    if(_loc16_)
                                    {
                                        _loc17_ = new Array();
                                        _loc19_ = 0;
                                        while(_loc19_ < _loc16_.length)
                                        {
                                            _loc20_ = _loc16_[_loc19_];
                                            _loc21_ = _loc8_.keyedPropertyObject[_loc20_];
                                            _loc17_.push(_loc21_[_loc3_][_loc13_]);
                                            _loc19_++;
                                        }
                                    }
                                    _loc32_ = _loc4_.addTargetActionPrisJoint(_loc8_,_loc31_,_loc14_,_loc17_);
                                    _loc13_++;
                                }
                            }
                        }
                        else
                        {
                            if(!(_loc8_ is RefTrigger))
                            {
                                throw new Error("what the fuck is this target");
                            }
                            _loc33_ = this.triggerDictionary[_loc8_];
                            _loc14_ = _loc8_.triggerActions[_loc3_];
                            _loc15_ = int(_loc8_.triggerActionList.indexOf(_loc14_));
                            _loc16_ = _loc8_.triggerActionListProperties[_loc15_];
                            if(_loc16_)
                            {
                                _loc17_ = new Array();
                                _loc19_ = 0;
                                while(_loc19_ < _loc16_.length)
                                {
                                    _loc20_ = _loc16_[_loc19_];
                                    _loc21_ = _loc8_.keyedPropertyObject[_loc20_];
                                    _loc17_.push(_loc21_[_loc3_]);
                                    _loc19_++;
                                }
                            }
                            _loc34_ = _loc4_.addTargetActionTrigger(_loc8_,_loc4_,_loc33_,_loc14_,_loc17_);
                        }
                        _loc7_++;
                    }
                }
                if(_loc3_.triggeredBy == 4)
                {
                    _loc5_ = _loc3_.targets;
                    _loc6_ = int(_loc5_.length);
                    _loc7_ = 0;
                    while(_loc7_ < _loc6_)
                    {
                        _loc8_ = _loc5_[_loc7_];
                        if(_loc8_ is RefShape)
                        {
                            _loc9_ = this.shapeDictionary[_loc8_];
                            if(_loc9_)
                            {
                                _loc27_ = _loc9_.GetBody();
                                if(_loc27_.m_mass > 0 && _loc9_.m_isSensor == false)
                                {
                                    _loc4_.addActivationBody([_loc27_]);
                                }
                            }
                        }
                        else if(_loc8_ is Special)
                        {
                            _loc24_ = this.specialDictionary[_loc8_];
                            _loc4_.addActivationBody(_loc24_.bodyList);
                        }
                        else if(_loc8_ is RefGroup)
                        {
                            _loc27_ = this.groupDictionary[_loc8_];
                            if(_loc27_)
                            {
                                _loc4_.addActivationBody([_loc27_]);
                            }
                        }
                        else if(!(_loc8_ is RefJoint))
                        {
                            if(!(_loc8_ is RefTrigger))
                            {
                                throw new Error("what the fuck is this target");
                            }
                        }
                        _loc7_++;
                    }
                }
                if(_loc3_.startDisabled)
                {
                    _loc4_.disabled = true;
                }
                _loc2_++;
            }
            this.shapeDictionary = null;
            this.spriteDictionary = null;
            this.specialDictionary = null;
            this.groupDictionary = null;
            this.vehicleDictionary = null;
        }
        
        override internal function createMovieClips() : void
        {
            foreground = new Sprite();
            characterLayer = new Sprite();
            background = new Sprite();
            if(Settings.bdIndex == 0)
            {
                background.graphics.beginFill(Settings.bdColor,1);
                background.graphics.drawRect(0,0,20000,10000);
                background.graphics.endFill();
            }
            _session.containerSprite.addChildAt(characterLayer,0);
            _session.containerSprite.addChildAt(background,0);
            _session.containerSprite.addChild(foreground);
            _session.particleController.placeBloodBitmap();
        }
        
        override internal function createBackDrops() : void
        {
            var _loc1_:BackDrop = null;
            var _loc2_:Sprite = null;
            backDrops = new Vector.<BackDrop>();
            switch(Settings.bdIndex)
            {
                case 0:
                    break;
                case 1:
                    _loc2_ = new GreenSource1();
                    _loc1_ = new BackDrop(_loc2_,0.1,true,3);
                    _session.addChildAt(_loc1_,0);
                    backDrops.push(_loc1_);
                    _loc2_ = new GreenSource2();
                    _loc1_ = new BackDrop(_loc2_,0.05,true,6);
                    _session.addChildAt(_loc1_,0);
                    backDrops.push(_loc1_);
                    _loc2_ = new GreenSource3();
                    _loc1_ = new BackDrop(_loc2_,0.01,true,7);
                    _session.addChildAt(_loc1_,0);
                    backDrops.push(_loc1_);
                    _loc2_ = new GreenSource4();
                    _loc1_ = new BackDrop(_loc2_,0,false);
                    _session.addChildAt(_loc1_,0);
                    backDrops.push(_loc1_);
                    break;
                case 2:
                    _loc1_ = new CityBackDrop1();
                    _session.addChildAt(_loc1_,0);
                    backDrops.push(_loc1_);
                    _loc1_ = new CityBackDrop2();
                    _session.addChildAt(_loc1_,0);
                    backDrops.push(_loc1_);
                    _loc2_ = new CitySource3();
                    _loc1_ = new BackDrop(_loc2_,0,false);
                    _session.addChildAt(_loc1_,0);
                    backDrops.push(_loc1_);
            }
        }
        
        override internal function createItems() : void
        {
        }
        
        private function createTokenHUD() : void
        {
            var _loc1_:Sprite = null;
            var _loc2_:Sprite = null;
            var _loc3_:TextFormat = null;
            var _loc4_:DropShadowFilter = null;
            if(this.totalTokens > 0)
            {
                _loc1_ = new Sprite();
                _loc2_ = this.tokenIcon = new TokenIcon();
                _loc3_ = new TextFormat("Clarendon LT Std",18,4032711,true,null,null,null,null,TextFormatAlign.LEFT);
                this.tokenField = new TextField();
                this.tokenField.defaultTextFormat = _loc3_;
                this.tokenField.autoSize = TextFieldAutoSize.RIGHT;
                this.tokenField.wordWrap = false;
                this.tokenField.multiline = false;
                this.tokenField.selectable = false;
                this.tokenField.embedFonts = true;
                this.tokenField.antiAliasType = AntiAliasType.ADVANCED;
                this.tokenField.text = "0/" + this.totalTokens;
                _loc1_.addChild(_loc2_);
                _loc1_.addChild(this.tokenField);
                this.tokenField.x = -this.tokenField.width - 8;
                _loc2_.y = this.tokenField.height / 2 + 1;
                _loc2_.x = this.tokenField.x - this.tokenIcon.width / 2 - 3;
                _session.addChild(_loc1_);
                _loc1_.x = 900;
                _loc1_.y = 4;
                _loc4_ = new DropShadowFilter(2,90,0,1,2,2,0.25);
                _loc1_.filters = [_loc4_];
            }
        }
        
        override public function actions() : void
        {
            super.actions();
            this.handleContactAdds();
        }
        
        public function tokenFound() : void
        {
            var _loc1_:Session = null;
            --this.tokens;
            this.tokenField.text = this.totalTokens - this.tokens + "/" + this.totalTokens;
            this.tokenIcon.x = this.tokenField.x - this.tokenIcon.width / 2 - 3;
            if(this.tokens == 0)
            {
                _loc1_ = Settings.currentSession;
                if(!_loc1_.isReplay)
                {
                    Settings.currentSession.levelComplete();
                }
                SoundController.instance.playSoundItem("Victory");
            }
        }
        
        override public function get cameraBounds() : Rectangle
        {
            return new Rectangle(0,0,20000,10000);
        }
        
        override public function get worldBounds() : Rectangle
        {
            return new Rectangle(-this.borderThickness,-(this.borderThickness + this.skyHeight),20000 + this.borderThickness * 2,10000 + this.skyHeight + this.borderThickness * 2);
        }
        
        override public function registerShapeSound(param1:b2Shape, param2:b2Body) : void
        {
            if(param2.m_mass > 15)
            {
                this.contactAddSounds[param1] = "ShapeHit4";
                _session.contactListener.registerListener(ContactListener.ADD,param1,this.shapeContactAdd);
            }
            else if(param2.m_mass > 10)
            {
                this.contactAddSounds[param1] = "ShapeHit3";
                _session.contactListener.registerListener(ContactListener.ADD,param1,this.shapeContactAdd);
            }
            else if(param2.m_mass > 5)
            {
                this.contactAddSounds[param1] = "ShapeHit2";
                _session.contactListener.registerListener(ContactListener.ADD,param1,this.shapeContactAdd);
            }
            else if(param2.m_mass > 1)
            {
                this.contactAddSounds[param1] = "ShapeHit1";
                _session.contactListener.registerListener(ContactListener.ADD,param1,this.shapeContactAdd);
            }
        }
        
        protected function shapeContactAdd(param1:b2ContactPoint) : void
        {
            var _loc2_:b2Shape = param1.shape1;
            var _loc3_:b2Body = _loc2_.m_body;
            var _loc4_:b2Shape = param1.shape2;
            var _loc5_:b2Body = _loc4_.m_body;
            var _loc6_:Number = _loc5_.m_mass;
            if(Boolean(this.contactAddBuffer[_loc2_]) || _loc4_.m_isSensor)
            {
                return;
            }
            if(_loc6_ != 0 && _loc6_ < _loc3_.m_mass)
            {
                return;
            }
            var _loc7_:Number = b2Math.b2Dot(param1.velocity,param1.normal);
            _loc7_ = Math.abs(_loc7_);
            if(_loc7_ > 4)
            {
                this.contactAddBuffer[_loc2_] = _loc7_;
            }
        }
        
        protected function handleContactAdds() : void
        {
            var _loc1_:* = undefined;
            var _loc2_:b2Shape = null;
            var _loc3_:String = null;
            var _loc4_:Number = NaN;
            var _loc5_:Number = NaN;
            for(_loc1_ in this.contactAddBuffer)
            {
                _loc2_ = _loc1_ as b2Shape;
                _loc3_ = this.contactAddSounds[_loc2_];
                _loc4_ = Number(this.contactAddBuffer[_loc2_]);
                _loc5_ = Math.min(_loc4_ / 12,1);
                SoundController.instance.playAreaSoundInstance(_loc3_,_loc2_.m_body,_loc5_);
                delete this.contactAddBuffer[_loc1_];
            }
        }
        
        override public function updateTargetActionsFor(param1:RefSprite, param2:b2Shape, param3:Sprite, param4:Number, param5:Boolean = false) : void
        {
            var _loc9_:TargetAction = null;
            var _loc10_:Vector.<Trigger> = null;
            var _loc11_:Trigger = null;
            var _loc6_:Vector.<LevelItem> = this.targetActionDictionary[param1];
            var _loc7_:int = int(_loc6_.length);
            var _loc8_:int = 0;
            while(_loc8_ < _loc7_)
            {
                _loc9_ = _loc6_[_loc8_] as TargetAction;
                _loc9_.shape = param2;
                _loc9_.sprite = param3;
                _loc9_.lastAngle = param4;
                _loc8_++;
            }
            if(param5)
            {
                _loc10_ = this.refTriggerDictionary[param1];
                if(!_loc10_)
                {
                    return;
                }
                _loc7_ = int(_loc10_.length);
                _loc8_ = 0;
                while(_loc8_ < _loc7_)
                {
                    _loc11_ = _loc10_[_loc8_];
                    _loc11_.addActivationBody([param2.GetBody()]);
                    _loc8_++;
                }
            }
        }
        
        override public function updateTargetActionGroupsFor(param1:RefSprite, param2:b2Body, param3:Sprite) : void
        {
            var _loc7_:TargetActionGroup = null;
            var _loc4_:Vector.<LevelItem> = this.targetActionDictionary[param1];
            var _loc5_:int = int(_loc4_.length);
            var _loc6_:int = 0;
            while(_loc6_ < _loc5_)
            {
                _loc7_ = _loc4_[_loc6_] as TargetActionGroup;
                _loc7_.body = param2;
                _loc7_.sprite = param3;
                _loc6_++;
            }
        }
        
        override public function mouseClickTrigger(param1:MouseData) : void
        {
            var _loc3_:RefTrigger = null;
            var _loc4_:Trigger = null;
            trace("MOUSECLICKTRIGGER ");
            var _loc2_:Sprite = shapeGuide.getChildByName("triggers") as Sprite;
            if(param1.first == 0)
            {
                if(param1.click)
                {
                    _loc3_ = _loc2_.getChildAt(param1.clickTriggerIndex) as RefTrigger;
                    _loc4_ = this.triggerDictionary[_loc3_];
                    _loc4_.mouseUpHandler(null);
                }
                if(param1.rollOut)
                {
                    _loc3_ = _loc2_.getChildAt(param1.rollOutTriggerIndex) as RefTrigger;
                    _loc4_ = this.triggerDictionary[_loc3_];
                    _loc4_.mouseOutHandler(null);
                }
            }
            else
            {
                if(param1.rollOut)
                {
                    _loc3_ = _loc2_.getChildAt(param1.rollOutTriggerIndex) as RefTrigger;
                    _loc4_ = this.triggerDictionary[_loc3_];
                    _loc4_.mouseOutHandler(null);
                }
                if(param1.click)
                {
                    _loc3_ = _loc2_.getChildAt(param1.clickTriggerIndex) as RefTrigger;
                    _loc4_ = this.triggerDictionary[_loc3_];
                    _loc4_.mouseUpHandler(null);
                }
            }
        }
    }
}

