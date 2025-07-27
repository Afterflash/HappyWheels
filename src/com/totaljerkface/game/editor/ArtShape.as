package com.totaljerkface.game.editor
{
    import Box2D.Common.Math.b2Vec2;
    import com.totaljerkface.game.editor.vertedit.*;
    import flash.display.*;
    
    public class ArtShape extends EdgeShape
    {
        protected var _handleVector:Vector.<b2Vec2>;
        
        public function ArtShape(param1:Boolean = false, param2:Boolean = false, param3:Boolean = false, param4:Number = 1, param5:uint = 4032711, param6:int = -1, param7:Number = 100, param8:int = 1)
        {
            super(param1,param2,param3,param4,param5,param6,param7,param8);
            this._handleVector = new Vector.<b2Vec2>();
            scalable = true;
            joinable = false;
            minDimension = 0.1;
            maxDimension = 10;
            name = "art shape";
        }
        
        public static function bezierValue(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number) : Number
        {
            var _loc6_:Number = param5 - 3 * param4 + 3 * param3 - param2;
            var _loc7_:Number = 3 * param4 - 6 * param3 + 3 * param2;
            var _loc8_:Number = 3 * param3 - 3 * param2;
            var _loc9_:Number = param2;
            return ((_loc6_ * param1 + _loc7_) * param1 + _loc8_) * param1 + _loc9_;
        }
        
        override public function setAttributes() : void
        {
            _attributes = ["x","y","shapeWidth","shapeHeight","angle","color","outlineColor","opacity"];
            addTriggerProperties();
        }
        
        override public function get functions() : Array
        {
            var _loc1_:Array = new Array();
            _loc1_.push("reverseShape");
            _loc1_.push("resetScale");
            if(groupable)
            {
                _loc1_.push("groupSelected");
            }
            return _loc1_;
        }
        
        override public function addVert(param1:Vert, param2:int = -1) : void
        {
            var _loc3_:BezierVert = param1 as BezierVert;
            if(!_loc3_)
            {
                throw new Error("trying to add a regular vert into an art shape");
            }
            if(param2 < 0)
            {
                if(_editMode)
                {
                    _vertContainer.addChild(param1);
                }
                _vertVector.push(param1.vec);
                this._handleVector.push(_loc3_.handle1.vec);
                this._handleVector.push(_loc3_.handle2.vec);
            }
            else
            {
                if(_editMode)
                {
                    _vertContainer.addChildAt(param1,param2);
                }
                _vertVector.splice(param2,0,param1.vec);
                this._handleVector.splice(param2 * 2,0,_loc3_.handle1.vec,_loc3_.handle2.vec);
            }
        }
        
        override public function removeVert(param1:int = -1) : void
        {
            if(param1 < 0)
            {
                param1 = _vertContainer.numChildren - 1;
                _vertContainer.removeChildAt(param1);
                _vertVector.pop();
                this._handleVector.pop();
                this._handleVector.pop();
            }
            else
            {
                _vertContainer.removeChildAt(param1);
                _vertVector.splice(param1,1);
                this._handleVector.splice(param1 * 2,2);
            }
        }
        
        private function addBezierCommands(param1:Vector.<int>, param2:Vector.<Number>, param3:b2Vec2, param4:b2Vec2, param5:b2Vec2, param6:b2Vec2) : void
        {
            if(param5.x == 0 && param5.y == 0 && param6.x == 0 && param6.y == 0)
            {
                param1.push(GraphicsPathCommand.LINE_TO);
                param2.push(param4.x,param4.y);
            }
            else
            {
                param1.push(GraphicsPathCommand.CUBIC_CURVE_TO);
                param2.push(param5.x,param5.y);
                param2.push(param6.x,param6.y);
                param2.push(param4.x,param4.y);
            }
        }
        
        override public function drawEditMode(param1:b2Vec2, param2:Boolean, param3:Boolean = false) : void
        {
            var _loc7_:BezierVert = null;
            var _loc8_:int = 0;
            var _loc9_:BezierVert = null;
            var _loc10_:BezierVert = null;
            var _loc11_:BezierVert = null;
            graphics.clear();
            var _loc4_:Vector.<int> = new Vector.<int>();
            var _loc5_:Vector.<Number> = new Vector.<Number>();
            graphics.lineStyle(0,0,_opacity,false);
            if(outlineColor >= 0)
            {
                graphics.lineStyle(0,_outlineColor,_opacity,false);
            }
            if(param2)
            {
                graphics.beginFill(_color,_opacity);
            }
            var _loc6_:int = _vertContainer.numChildren;
            if(_loc6_ > 0)
            {
                _loc7_ = _vertContainer.getChildAt(0) as BezierVert;
                _loc4_.push(GraphicsPathCommand.MOVE_TO);
                _loc5_.push(_loc7_.x);
                _loc5_.push(_loc7_.y);
                _loc8_ = 1;
                while(_loc8_ < _loc6_)
                {
                    _loc9_ = _vertContainer.getChildAt(_loc8_) as BezierVert;
                    this.addBezierCommands(_loc4_,_loc5_,_loc7_.position,_loc9_.position,_loc7_.anchor2,_loc9_.anchor1);
                    _loc7_ = _loc9_;
                    _loc8_++;
                }
            }
            if(param1)
            {
                graphics.lineStyle(0,0,0.5,false);
                _loc10_ = _vertContainer.getChildAt(_vertContainer.numChildren - 1) as BezierVert;
                _loc11_ = _vertContainer.getChildAt(0) as BezierVert;
                if(param2)
                {
                    this.addBezierCommands(_loc4_,_loc5_,_loc10_.position,_loc11_.position,_loc10_.anchor2,_loc11_.anchor1);
                    graphics.drawPath(_loc4_,_loc5_,GraphicsPathWinding.EVEN_ODD);
                    graphics.endFill();
                }
                else
                {
                    if(param3)
                    {
                        this.addBezierCommands(_loc4_,_loc5_,_loc10_.position,param1,_loc10_.anchor2,param1);
                    }
                    graphics.drawPath(_loc4_,_loc5_,GraphicsPathWinding.NON_ZERO);
                }
            }
            else
            {
                graphics.drawPath(_loc4_,_loc5_,GraphicsPathWinding.NON_ZERO);
                if(param2)
                {
                    graphics.endFill();
                }
            }
        }
        
        override protected function drawShape() : void
        {
            var _loc4_:b2Vec2 = null;
            var _loc5_:int = 0;
            var _loc6_:b2Vec2 = null;
            var _loc7_:b2Vec2 = null;
            var _loc8_:b2Vec2 = null;
            graphics.clear();
            var _loc1_:Vector.<int> = new Vector.<int>();
            var _loc2_:Vector.<Number> = new Vector.<Number>();
            if(outlineColor >= 0)
            {
                graphics.lineStyle(0,_outlineColor,_opacity,false);
            }
            if(_completeFill)
            {
                graphics.beginFill(_color,_opacity);
            }
            else if(_outlineColor == -1)
            {
                graphics.lineStyle(0,0,_opacity,false);
            }
            var _loc3_:int = int(_vertVector.length);
            if(_loc3_ > 0)
            {
                _loc4_ = _vertVector[0];
                _loc1_.push(GraphicsPathCommand.MOVE_TO);
                _loc2_.push(_loc4_.x);
                _loc2_.push(_loc4_.y);
                _loc5_ = 1;
                while(_loc5_ < _loc3_)
                {
                    _loc6_ = _vertVector[_loc5_];
                    _loc7_ = this._handleVector[(_loc5_ - 1) * 2 + 1].Copy();
                    _loc8_ = this._handleVector[_loc5_ * 2].Copy();
                    _loc7_.Add(_loc4_);
                    _loc8_.Add(_loc6_);
                    this.addBezierCommands(_loc1_,_loc2_,_loc4_,_loc6_,_loc7_,_loc8_);
                    _loc4_ = _loc6_;
                    _loc5_++;
                }
                if(_completeFill)
                {
                    _loc6_ = _vertVector[0];
                    _loc7_ = this._handleVector[(_loc5_ - 1) * 2 + 1].Copy();
                    _loc8_ = this._handleVector[0].Copy();
                    _loc7_.Add(_loc4_);
                    _loc8_.Add(_loc6_);
                    this.addBezierCommands(_loc1_,_loc2_,_loc4_,_loc6_,_loc7_,_loc8_);
                    graphics.drawPath(_loc1_,_loc2_,GraphicsPathWinding.NON_ZERO);
                    graphics.endFill();
                }
                else
                {
                    graphics.drawPath(_loc1_,_loc2_,GraphicsPathWinding.NON_ZERO);
                }
                setDefaultDimensions();
            }
        }
        
        override public function getFlatSprite() : Sprite
        {
            var _loc1_:Sprite = null;
            var _loc7_:b2Vec2 = null;
            var _loc8_:b2Vec2 = null;
            var _loc9_:b2Vec2 = null;
            _loc1_ = new Sprite();
            if(_opacity == 0 || _outlineColor < 0 && _color < 0)
            {
                _loc1_.visible = false;
            }
            if(_outlineColor >= 0)
            {
                _loc1_.graphics.lineStyle(0,_outlineColor,1,false);
            }
            if(_completeFill)
            {
                if(_color >= 0)
                {
                    _loc1_.graphics.beginFill(_color,1);
                }
            }
            else if(_outlineColor == -1)
            {
                _loc1_.graphics.lineStyle(0,0,1,false);
            }
            var _loc2_:Vector.<int> = new Vector.<int>();
            var _loc3_:Vector.<Number> = new Vector.<Number>();
            var _loc4_:b2Vec2 = _vertVector[0];
            _loc2_.push(GraphicsPathCommand.MOVE_TO);
            _loc3_.push(_loc4_.x);
            _loc3_.push(_loc4_.y);
            var _loc5_:int = int(_vertVector.length);
            var _loc6_:int = 1;
            while(_loc6_ < _loc5_)
            {
                _loc7_ = _vertVector[_loc6_];
                _loc8_ = this._handleVector[(_loc6_ - 1) * 2 + 1].Copy();
                _loc9_ = this._handleVector[_loc6_ * 2].Copy();
                _loc8_.Add(_loc4_);
                _loc9_.Add(_loc7_);
                this.addBezierCommands(_loc2_,_loc3_,_loc4_,_loc7_,_loc8_,_loc9_);
                _loc4_ = _loc7_;
                _loc6_++;
            }
            if(_completeFill)
            {
                _loc7_ = _vertVector[0];
                _loc8_ = this._handleVector[(_loc6_ - 1) * 2 + 1].Copy();
                _loc9_ = this._handleVector[0].Copy();
                _loc8_.Add(_loc4_);
                _loc9_.Add(_loc7_);
                this.addBezierCommands(_loc2_,_loc3_,_loc4_,_loc7_,_loc8_,_loc9_);
                _loc1_.graphics.drawPath(_loc2_,_loc3_,GraphicsPathWinding.NON_ZERO);
                _loc1_.graphics.endFill();
            }
            else
            {
                _loc1_.graphics.drawPath(_loc2_,_loc3_,GraphicsPathWinding.NON_ZERO);
            }
            _loc1_.x = x;
            _loc1_.y = y;
            _loc1_.scaleX = scaleX;
            _loc1_.scaleY = scaleY;
            _loc1_.rotation = rotation;
            _loc1_.alpha = _opacity;
            return _loc1_;
        }
        
        override public function clone() : RefSprite
        {
            var _loc4_:b2Vec2 = null;
            var _loc5_:int = 0;
            var _loc6_:b2Vec2 = null;
            var _loc7_:b2Vec2 = null;
            var _loc1_:ArtShape = new ArtShape(interactive,immovable,sleeping,density,color,outlineColor,opacity,collision);
            var _loc2_:int = int(_vertVector.length);
            var _loc3_:int = 0;
            while(_loc3_ < _loc2_)
            {
                _loc4_ = _vertVector[_loc3_].Copy();
                _loc1_.vertVector.push(_loc4_);
                _loc5_ = _loc3_ * 2;
                _loc6_ = this._handleVector[_loc5_].Copy();
                _loc7_ = this._handleVector[_loc5_ + 1].Copy();
                _loc1_.handleVector.push(_loc6_,_loc7_);
                _loc3_++;
            }
            _loc1_.completeFill = completeFill;
            _loc1_.drawShape();
            _loc1_.vID = vID;
            _loc1_.scaleY = scaleY;
            _loc1_.scaleX = scaleX;
            _loc1_.angle = angle;
            _loc1_.x = x;
            _loc1_.y = y;
            _loc1_.vehicleHandle = vehicleHandle;
            transferKeyedProperties(_loc1_);
            return _loc1_;
        }
        
        override public function set vID(param1:int) : void
        {
            _vID = param1;
            ArtTool.updateIdCounter(param1);
        }
        
        override protected function populateVertContainer() : void
        {
            var _loc3_:BezierVert = null;
            var _loc4_:int = 0;
            destroyVertContainer();
            _vertContainer = new Sprite();
            var _loc1_:int = int(_vertVector.length);
            var _loc2_:int = 0;
            while(_loc2_ < _loc1_)
            {
                _loc3_ = new BezierVert();
                _loc3_.edgeShape = this;
                _loc3_.vec = _vertVector[_loc2_];
                _loc4_ = _loc2_ * 2;
                _loc3_.handle1.vec = this._handleVector[_loc4_];
                _loc3_.handle2.vec = this._handleVector[_loc4_ + 1];
                _vertContainer.addChild(_loc3_);
                _loc2_++;
            }
        }
        
        override public function reverse() : void
        {
            var _loc3_:b2Vec2 = null;
            var _loc4_:b2Vec2 = null;
            var _loc5_:b2Vec2 = null;
            var _loc1_:int = numVerts;
            _vertVector.reverse();
            this._handleVector.reverse();
            var _loc2_:int = 0;
            while(_loc2_ < _loc1_)
            {
                _loc3_ = _vertVector[_loc2_];
                _loc3_.x = -_loc3_.x;
                _loc4_ = this._handleVector[_loc2_ * 2];
                _loc5_ = this._handleVector[_loc2_ * 2 + 1];
                _loc4_.x = -_loc4_.x;
                _loc5_.x = -_loc5_.x;
                _loc2_++;
            }
            this.drawShape();
            drawBoundingBox();
            x = x;
            y = y;
            this.vID = ArtTool.getIDCounter();
        }
        
        public function get handleVector() : Vector.<b2Vec2>
        {
            return this._handleVector;
        }
    }
}

