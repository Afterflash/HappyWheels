package com.totaljerkface.game.level
{
    import Box2D.Collision.Shapes.b2CircleDef;
    import Box2D.Collision.Shapes.b2CircleShape;
    import Box2D.Collision.Shapes.b2PolygonDef;
    import Box2D.Collision.Shapes.b2PolygonShape;
    import Box2D.Collision.Shapes.b2Shape;
    import Box2D.Common.Math.b2Mat22;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.*;
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.editor.PolygonShape;
    import com.totaljerkface.game.editor.RefSprite;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.Rectangle;
    
    public class TargetAction extends LevelItem
    {
        protected var _refSprite:RefSprite;
        
        protected var _shape:b2Shape;
        
        protected var _sprite:Sprite;
        
        protected var _actionIndex:int;
        
        protected var _properties:Array;
        
        protected var _instant:Boolean;
        
        protected var _lastAngle:Number;
        
        protected var counter:int = 0;
        
        public function TargetAction(param1:RefSprite, param2:b2Shape, param3:Sprite, param4:String, param5:Array)
        {
            super();
            this._refSprite = param1;
            this._shape = param2;
            this._sprite = param3;
            this._actionIndex = param1.triggerActionList.indexOf(param4);
            this._lastAngle = param1.rotation * Math.PI / 180;
            if(this._actionIndex < 0)
            {
                throw new Error("Target Action not in Shape Action List");
            }
            this._instant = param4 == "change opacity" ? false : true;
            this._properties = param5;
        }
        
        override public function singleAction() : void
        {
            var _loc2_:Boolean = false;
            var _loc3_:int = 0;
            var _loc4_:b2Body = null;
            var _loc5_:LevelB2D = null;
            var _loc6_:b2Body = null;
            var _loc7_:b2World = null;
            var _loc8_:b2Vec2 = null;
            var _loc9_:Number = NaN;
            var _loc10_:b2PolygonShape = null;
            var _loc11_:Array = null;
            var _loc12_:b2PolygonDef = null;
            var _loc13_:b2Mat22 = null;
            var _loc14_:int = 0;
            var _loc15_:Sprite = null;
            var _loc16_:DisplayObjectContainer = null;
            var _loc17_:int = 0;
            var _loc18_:Rectangle = null;
            var _loc19_:Rectangle = null;
            var _loc20_:b2Vec2 = null;
            var _loc21_:b2Vec2 = null;
            var _loc22_:b2CircleShape = null;
            var _loc23_:b2CircleDef = null;
            var _loc24_:b2BodyDef = null;
            var _loc25_:b2Body = null;
            var _loc26_:PolygonShape = null;
            var _loc27_:b2Vec2 = null;
            var _loc28_:b2Vec2 = null;
            var _loc29_:Number = NaN;
            var _loc30_:Number = NaN;
            var _loc31_:Number = NaN;
            var _loc32_:Number = NaN;
            var _loc33_:Number = NaN;
            var _loc1_:Number = Settings.currentSession.levelVersion;
            switch(this._actionIndex)
            {
                case 0:
                    if(this._shape)
                    {
                        _loc4_ = this._shape.GetBody();
                        if(_loc4_)
                        {
                            _loc4_.WakeUp();
                        }
                    }
                    break;
                case 1:
                    if(this._shape)
                    {
                        _loc4_ = this._shape.GetBody();
                        if(_loc4_.m_mass > 0)
                        {
                            _loc5_ = Settings.currentSession.level;
                            _loc6_ = _loc5_.levelBody;
                            _loc7_ = Settings.currentSession.m_world;
                            _loc8_ = _loc4_.GetWorldCenter();
                            _loc9_ = this._lastAngle = _loc4_.GetAngle();
                            this._sprite.x = _loc8_.x * m_physScale;
                            this._sprite.y = _loc8_.y * m_physScale;
                            this._sprite.rotation = _loc9_ * oneEightyOverPI % 360;
                            if(this._shape is b2PolygonShape)
                            {
                                _loc10_ = this._shape as b2PolygonShape;
                                if(this._refSprite is PolygonShape)
                                {
                                    _loc15_ = (this._refSprite as PolygonShape).getFlatSprite();
                                    _loc16_ = this._sprite.parent;
                                    _loc17_ = _loc16_.getChildIndex(this._sprite);
                                    _loc16_.addChildAt(_loc15_,_loc17_);
                                    _loc15_.rotation = this._sprite.rotation;
                                    _loc18_ = this._sprite.getBounds(_loc16_);
                                    _loc19_ = _loc15_.getBounds(_loc16_);
                                    _loc15_.x -= _loc19_.x - _loc18_.x;
                                    _loc15_.y -= _loc19_.y - _loc18_.y;
                                    _loc16_.removeChild(this._sprite);
                                    _loc15_.alpha = this._sprite.alpha;
                                    this._sprite = _loc15_;
                                    _loc8_ = _loc4_.GetPosition();
                                }
                                _loc11_ = _loc10_.GetVertices();
                                _loc12_ = new b2PolygonDef();
                                _loc12_.density = _loc10_.m_density;
                                _loc12_.filter = _loc10_.m_filter.Copy();
                                if(_loc1_ > 1.84)
                                {
                                    if(_loc12_.filter.categoryBits == 8)
                                    {
                                        _loc12_.filter.categoryBits = 24;
                                        if(_loc12_.filter.maskBits == 8)
                                        {
                                            _loc12_.filter.maskBits = 56;
                                        }
                                        else if(_loc12_.filter.groupIndex == 0)
                                        {
                                            _loc12_.filter.groupIndex = -10;
                                        }
                                    }
                                    else if(_loc12_.filter.categoryBits == 16)
                                    {
                                        _loc12_.filter.maskBits = 48;
                                        _loc12_.filter.groupIndex = 0;
                                    }
                                    else if(_loc12_.filter.categoryBits == 32)
                                    {
                                        _loc12_.filter.categoryBits = 48;
                                    }
                                }
                                else if(_loc12_.filter.maskBits == 65535 && _loc12_.filter.groupIndex == 0)
                                {
                                    _loc12_.filter.groupIndex = -10;
                                    _loc12_.filter.categoryBits = 24;
                                }
                                _loc12_.vertexCount = _loc10_.m_vertexCount;
                                _loc13_ = new b2Mat22(_loc9_);
                                _loc14_ = 0;
                                while(_loc14_ < _loc10_.m_vertexCount)
                                {
                                    _loc20_ = _loc11_[_loc14_];
                                    _loc21_ = _loc20_.Copy();
                                    _loc21_.MulM(_loc13_);
                                    _loc21_.x += _loc8_.x;
                                    _loc21_.y += _loc8_.y;
                                    _loc12_.vertices[_loc14_] = _loc21_;
                                    _loc14_++;
                                }
                                this._shape = _loc6_.CreateShape(_loc12_);
                            }
                            else
                            {
                                if(!(this._shape is b2CircleShape))
                                {
                                    throw new Error("WHAT THE FUCK IS THIS SHAPE?");
                                }
                                _loc22_ = this._shape as b2CircleShape;
                                _loc23_ = new b2CircleDef();
                                _loc23_.radius = _loc22_.m_radius;
                                _loc23_.density = _loc22_.m_density;
                                _loc23_.filter = _loc22_.m_filter.Copy();
                                if(_loc1_ > 1.84)
                                {
                                    if(_loc23_.filter.categoryBits == 8)
                                    {
                                        _loc23_.filter.categoryBits = 24;
                                        if(_loc23_.filter.maskBits == 8)
                                        {
                                            _loc23_.filter.maskBits = 56;
                                        }
                                        else if(_loc23_.filter.groupIndex == 0)
                                        {
                                            _loc23_.filter.groupIndex = -10;
                                        }
                                    }
                                    else if(_loc23_.filter.categoryBits == 16)
                                    {
                                        _loc23_.filter.maskBits = 48;
                                        _loc23_.filter.groupIndex = 0;
                                    }
                                    else if(_loc23_.filter.categoryBits == 32)
                                    {
                                        _loc23_.filter.categoryBits = 48;
                                    }
                                }
                                else if(_loc23_.filter.maskBits == 65535 && _loc23_.filter.groupIndex == 0)
                                {
                                    _loc23_.filter.groupIndex = -10;
                                    _loc23_.filter.categoryBits = 24;
                                }
                                _loc23_.localPosition.SetV(_loc8_);
                                this._shape = _loc6_.CreateShape(_loc23_);
                            }
                            _loc7_.DestroyBody(_loc4_);
                            _loc5_.removeFromPaintBodyVector(_loc4_);
                            _loc5_.updateTargetActionsFor(this._refSprite,this._shape,this._sprite,this._lastAngle);
                        }
                    }
                    break;
                case 2:
                    if(this._shape)
                    {
                        trace("SHAPE !");
                        _loc4_ = this._shape.GetBody();
                        trace(_loc4_.GetMass());
                        if(_loc4_.m_mass == 0)
                        {
                            _loc5_ = Settings.currentSession.level;
                            _loc6_ = _loc5_.levelBody;
                            _loc7_ = Settings.currentSession.m_world;
                            _loc24_ = new b2BodyDef();
                            _loc25_ = _loc7_.CreateBody(_loc24_);
                            if(this._shape is b2PolygonShape)
                            {
                                _loc10_ = this._shape as b2PolygonShape;
                                _loc8_ = _loc10_.GetCentroid();
                                _loc25_.SetXForm(_loc8_,this._lastAngle);
                                _loc11_ = _loc10_.GetVertices();
                                _loc12_ = new b2PolygonDef();
                                _loc12_.density = _loc10_.m_density > 0 ? _loc10_.m_density : 1;
                                _loc12_.filter = _loc10_.m_filter.Copy();
                                if(_loc1_ > 1.84)
                                {
                                    if(_loc12_.filter.categoryBits == 24)
                                    {
                                        _loc12_.filter.categoryBits = 8;
                                        if(_loc12_.filter.maskBits == 56)
                                        {
                                            _loc12_.filter.maskBits = 8;
                                        }
                                        else if(_loc12_.filter.groupIndex == -10)
                                        {
                                            _loc12_.filter.groupIndex = 0;
                                        }
                                    }
                                    else if(_loc12_.filter.categoryBits == 16)
                                    {
                                        _loc12_.filter.maskBits = 16;
                                        _loc12_.filter.groupIndex = -322;
                                    }
                                    else if(_loc12_.filter.categoryBits == 48)
                                    {
                                        _loc12_.filter.categoryBits = 32;
                                    }
                                }
                                else if(_loc12_.filter.groupIndex == -10 && _loc12_.filter.maskBits == 65535)
                                {
                                    _loc12_.filter.groupIndex = 0;
                                    _loc12_.filter.categoryBits = 8;
                                }
                                _loc12_.vertexCount = _loc10_.m_vertexCount;
                                _loc13_ = new b2Mat22(-this._lastAngle);
                                _loc14_ = 0;
                                while(_loc14_ < _loc10_.m_vertexCount)
                                {
                                    _loc20_ = _loc11_[_loc14_];
                                    _loc21_ = _loc20_.Copy();
                                    _loc21_.x -= _loc8_.x;
                                    _loc21_.y -= _loc8_.y;
                                    _loc21_.MulM(_loc13_);
                                    _loc12_.vertices[_loc14_] = _loc21_;
                                    _loc14_++;
                                }
                                this._shape = _loc25_.CreateShape(_loc12_);
                                _loc6_.DestroyShape(_loc10_);
                                if(this._refSprite is PolygonShape)
                                {
                                    _loc26_ = this._refSprite as PolygonShape;
                                    _loc27_ = new b2Vec2();
                                    _loc28_ = _loc26_.vertVector[0];
                                    _loc27_.x = _loc26_.scaleX * _loc28_.x - _loc12_.vertices[0].x * m_physScale;
                                    _loc27_.y = _loc26_.scaleY * _loc28_.y - _loc12_.vertices[0].y * m_physScale;
                                    _loc15_ = (this._refSprite as PolygonShape).getCenteredSprite(_loc27_);
                                    _loc16_ = this._sprite.parent;
                                    _loc17_ = _loc16_.getChildIndex(this._sprite);
                                    _loc16_.addChildAt(_loc15_,_loc17_);
                                    _loc16_.removeChild(this._sprite);
                                    _loc15_.alpha = this._sprite.alpha;
                                    this._sprite = _loc15_;
                                }
                            }
                            else
                            {
                                if(!(this._shape is b2CircleShape))
                                {
                                    throw new Error("WHAT THE FUCK IS THIS SHAPE?");
                                }
                                _loc22_ = this._shape as b2CircleShape;
                                _loc23_ = new b2CircleDef();
                                _loc23_.radius = _loc22_.m_radius;
                                _loc23_.density = _loc22_.m_density > 0 ? _loc22_.m_density : 1;
                                _loc23_.filter = _loc22_.m_filter.Copy();
                                if(_loc1_ > 1.84)
                                {
                                    if(_loc23_.filter.categoryBits == 24)
                                    {
                                        _loc23_.filter.categoryBits = 8;
                                        if(_loc23_.filter.maskBits == 56)
                                        {
                                            _loc23_.filter.maskBits = 8;
                                        }
                                        else if(_loc23_.filter.groupIndex == -10)
                                        {
                                            _loc23_.filter.groupIndex = 0;
                                        }
                                    }
                                    else if(_loc23_.filter.categoryBits == 16)
                                    {
                                        _loc23_.filter.maskBits = 16;
                                        _loc23_.filter.groupIndex = -322;
                                    }
                                    else if(_loc23_.filter.categoryBits == 48)
                                    {
                                        _loc23_.filter.categoryBits = 32;
                                    }
                                }
                                else if(_loc23_.filter.groupIndex == -10 && _loc23_.filter.maskBits == 65535)
                                {
                                    _loc23_.filter.groupIndex = 0;
                                    _loc23_.filter.categoryBits = 8;
                                }
                                _loc8_ = _loc22_.GetLocalPosition();
                                _loc25_.SetXForm(_loc8_,this._lastAngle);
                                this._shape = _loc25_.CreateShape(_loc23_);
                                _loc6_.DestroyShape(_loc22_);
                            }
                            _loc25_.SetMassFromShapes();
                            _loc25_.m_userData = this._sprite;
                            _loc5_.registerShapeSound(this._shape,_loc25_);
                            _loc5_.paintBodyVector.push(_loc25_);
                            _loc5_.updateTargetActionsFor(this._refSprite,this._shape,this._sprite,this._lastAngle,true);
                        }
                    }
                    break;
                case 4:
                    if(this._shape)
                    {
                        _loc4_ = this._shape.GetBody();
                        _loc29_ = _loc4_.m_mass;
                        if(_loc29_ > 0)
                        {
                            _loc30_ = Number(this._properties[0]);
                            _loc31_ = Number(this._properties[1]);
                            _loc32_ = Number(this._properties[2]);
                            _loc4_.ApplyImpulse(new b2Vec2(_loc30_ * _loc29_,_loc31_ * _loc29_),_loc4_.GetWorldCenter());
                            if(_loc32_)
                            {
                                _loc33_ = _loc4_.GetAngularVelocity();
                                _loc4_.SetAngularVelocity(_loc33_ + _loc32_);
                            }
                        }
                    }
                    break;
                case 5:
                    if(this._shape)
                    {
                        _loc4_ = this._shape.GetBody();
                        _loc29_ = _loc4_.m_mass;
                        _loc5_ = Settings.currentSession.level;
                        _loc6_ = _loc5_.levelBody;
                        _loc7_ = Settings.currentSession.m_world;
                        if(_loc29_ > 0)
                        {
                            _loc7_.DestroyBody(_loc4_);
                            this._shape = null;
                            _loc5_.removeFromPaintBodyVector(_loc4_);
                        }
                        else
                        {
                            _loc6_.DestroyShape(this._shape);
                            this._shape = null;
                        }
                        _loc5_.updateTargetActionsFor(this._refSprite,this._shape,this._sprite,this._lastAngle);
                    }
                    break;
                case 6:
                    _loc5_ = Settings.currentSession.level;
                    if(this._shape)
                    {
                        _loc4_ = this._shape.GetBody();
                        _loc29_ = _loc4_.m_mass;
                        _loc6_ = _loc5_.levelBody;
                        _loc7_ = Settings.currentSession.m_world;
                        if(_loc29_ > 0)
                        {
                            _loc7_.DestroyBody(_loc4_);
                            this._shape = null;
                            _loc5_.removeFromPaintBodyVector(_loc4_);
                        }
                        else
                        {
                            _loc4_.DestroyShape(this._shape);
                            this._shape = null;
                        }
                    }
                    if(this._sprite.parent)
                    {
                        this._sprite.parent.removeChild(this._sprite);
                    }
                    _loc5_.updateTargetActionsFor(this._refSprite,this._shape,this._sprite,this._lastAngle);
                    break;
                case 7:
                    _loc5_ = Settings.currentSession.level;
                    _loc2_ = this._shape.m_body.m_mass == 0 ? true : false;
                    _loc3_ = int(this._properties[0]);
                    if(this._shape)
                    {
                        if(_loc3_ == 2)
                        {
                            this._shape.m_filter.categoryBits = 8;
                            this._shape.m_filter.maskBits = 8;
                            this._shape.m_filter.groupIndex = 0;
                            if(_loc1_ > 1.84 && _loc2_)
                            {
                                this._shape.m_filter.categoryBits = 24;
                                this._shape.m_filter.maskBits = 56;
                            }
                        }
                        else if(_loc3_ == 3)
                        {
                            if(_loc1_ < 1.82)
                            {
                                this._shape.m_filter.categoryBits = 1;
                                this._shape.m_filter.maskBits = 1;
                                this._shape.m_filter.groupIndex = -10;
                            }
                            else
                            {
                                this._shape.m_filter.categoryBits = 0;
                                this._shape.m_filter.maskBits = 0;
                                this._shape.m_filter.groupIndex = 0;
                            }
                        }
                        else if(_loc3_ == 4)
                        {
                            this._shape.m_filter.categoryBits = 8;
                            this._shape.m_filter.maskBits = 65535;
                            this._shape.m_filter.groupIndex = -321;
                            if(_loc1_ > 1.84 && _loc2_)
                            {
                                this._shape.m_filter.categoryBits = 24;
                            }
                        }
                        else if(_loc3_ == 5)
                        {
                            this._shape.m_filter.categoryBits = 16;
                            this._shape.m_filter.maskBits = 16;
                            this._shape.m_filter.groupIndex = -322;
                            if(_loc1_ > 1.84 && _loc2_)
                            {
                                this._shape.m_filter.maskBits = 48;
                                this._shape.m_filter.groupIndex = 0;
                            }
                        }
                        else if(_loc3_ == 6)
                        {
                            this._shape.m_filter.categoryBits = 16;
                            this._shape.m_filter.maskBits = 16;
                            this._shape.m_filter.groupIndex = 0;
                            if(_loc1_ > 1.84)
                            {
                                this._shape.m_filter.categoryBits = _loc2_ ? 48 : 32;
                                this._shape.m_filter.maskBits = 48;
                            }
                        }
                        else if(_loc3_ == 7)
                        {
                            this._shape.m_filter.categoryBits = 15;
                            this._shape.m_filter.maskBits = 3840;
                            this._shape.m_filter.groupIndex = 0;
                        }
                        else
                        {
                            this._shape.m_filter.categoryBits = 8;
                            this._shape.m_filter.maskBits = 65535;
                            if(_loc2_)
                            {
                                this._shape.m_filter.categoryBits = 24;
                                this._shape.m_filter.groupIndex = -10;
                            }
                        }
                        this._shape.m_isSensor = _loc3_ == 3 && _loc1_ < 1.82 ? true : false;
                        Settings.currentSession.m_world.Refilter(this._shape);
                        _loc5_.updateTargetActionsFor(this._refSprite,this._shape,this._sprite,this._lastAngle);
                    }
                    trace("CHANGE COLLISION");
            }
        }
        
        override public function actions() : void
        {
            var _loc1_:Number = NaN;
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            var _loc4_:Number = NaN;
            switch(this._actionIndex)
            {
                case 3:
                    _loc1_ = Number(this._properties[0]);
                    _loc2_ = Number(this._properties[1]);
                    _loc1_ *= 0.01;
                    _loc2_ = Math.round(_loc2_ * 30);
                    if(this.counter == _loc2_)
                    {
                        if(Settings.currentSession.levelVersion > 1.8)
                        {
                            this.counter = 0;
                        }
                        this._sprite.visible = _loc1_ == 0 ? false : true;
                        this._sprite.alpha = _loc1_;
                        Settings.currentSession.level.removeFromActionsVector(this);
                        return;
                    }
                    _loc3_ = this._sprite.alpha;
                    _loc4_ = _loc1_ - _loc3_;
                    this._sprite.alpha = _loc3_ + _loc4_ / (_loc2_ - this.counter);
                    this._sprite.visible = this._sprite.alpha == 0 ? false : true;
                    break;
            }
            this.counter += 1;
        }
        
        public function get lastAngle() : Number
        {
            return this._lastAngle;
        }
        
        public function set lastAngle(param1:Number) : void
        {
            this._lastAngle = param1;
        }
        
        public function get shape() : b2Shape
        {
            return this._shape;
        }
        
        public function set shape(param1:b2Shape) : void
        {
            this._shape = param1;
        }
        
        public function get sprite() : Sprite
        {
            return this._sprite;
        }
        
        public function set sprite(param1:Sprite) : void
        {
            this._sprite = param1;
        }
        
        public function get instant() : Boolean
        {
            return this._instant;
        }
    }
}

