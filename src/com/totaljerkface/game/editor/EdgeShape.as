package com.totaljerkface.game.editor
{
    import Box2D.Common.Math.b2Vec2;
    import com.totaljerkface.game.editor.vertedit.*;
    import flash.display.BlendMode;
    import flash.display.Sprite;
    
    public class EdgeShape extends RefShape
    {
        protected var _editMode:Boolean;
        
        protected var _vertContainer:Sprite;
        
        protected var _vertVector:Vector.<b2Vec2> = new Vector.<b2Vec2>();
        
        protected var _vID:int = 0;
        
        protected var _completeFill:Boolean = false;
        
        protected var _defaultWidth:Number;
        
        protected var _defaultHeight:Number;
        
        public function EdgeShape(param1:Boolean = false, param2:Boolean = false, param3:Boolean = false, param4:Number = 1, param5:uint = 4032711, param6:int = -1, param7:Number = 100, param8:int = 1)
        {
            super(param1,param2,param3,param4,param5,param6,param7,param8);
            doubleClickEnabled = true;
        }
        
        public function addVert(param1:Vert, param2:int = -1) : void
        {
            if(param2 < 0)
            {
                if(this._editMode)
                {
                    this._vertContainer.addChild(param1);
                }
                this._vertVector.push(param1.vec);
            }
            else
            {
                if(this._editMode)
                {
                    this._vertContainer.addChildAt(param1,param2);
                }
                this._vertVector.splice(param2,0,param1.vec);
            }
        }
        
        public function removeVert(param1:int = -1) : void
        {
            if(param1 < 0)
            {
                param1 = this._vertContainer.numChildren - 1;
                this._vertContainer.removeChildAt(param1);
                this._vertVector.pop();
            }
            else
            {
                this._vertContainer.removeChildAt(param1);
                this._vertVector.splice(param1,1);
            }
        }
        
        public function get numVerts() : int
        {
            return this._vertVector.length;
        }
        
        public function getVertAt(param1:int) : Vert
        {
            return this._vertContainer.getChildAt(param1) as Vert;
        }
        
        public function getVertIndex(param1:Vert) : int
        {
            return this._vertContainer.getChildIndex(param1);
        }
        
        public function deselectAllVerts() : void
        {
            var _loc3_:Vert = null;
            var _loc1_:int = this.numVerts;
            var _loc2_:int = 0;
            while(_loc2_ < _loc1_)
            {
                _loc3_ = this._vertContainer.getChildAt(_loc2_) as Vert;
                _loc3_.selected = false;
                _loc2_++;
            }
        }
        
        public function resizeVerts() : void
        {
            var _loc3_:Vert = null;
            var _loc1_:int = this.numVerts;
            var _loc2_:int = 0;
            while(_loc2_ < _loc1_)
            {
                _loc3_ = this._vertContainer.getChildAt(_loc2_) as Vert;
                _loc3_.selected = _loc3_.selected;
                _loc2_++;
            }
        }
        
        public function drawEditMode(param1:b2Vec2, param2:Boolean, param3:Boolean = false) : void
        {
        }
        
        public function redraw() : void
        {
            drawShape();
        }
        
        override public function get shapeWidth() : Number
        {
            return Math.round(scaleX * this._defaultWidth);
        }
        
        override public function set shapeWidth(param1:Number) : void
        {
            if(param1 == 0)
            {
                return;
            }
            scaleX = this._defaultWidth > 0 ? param1 / this._defaultWidth : 1;
        }
        
        override public function get shapeHeight() : Number
        {
            return Math.round(scaleY * this._defaultHeight);
        }
        
        override public function set shapeHeight(param1:Number) : void
        {
            if(param1 == 0)
            {
                return;
            }
            scaleY = this._defaultHeight > 0 ? param1 / this._defaultHeight : 1;
        }
        
        public function get defaultWidth() : Number
        {
            return this._defaultWidth;
        }
        
        public function set defaultWidth(param1:Number) : void
        {
            this._defaultWidth = param1;
        }
        
        public function get defaultHeight() : Number
        {
            return this._defaultHeight;
        }
        
        public function set defaultHeight(param1:Number) : void
        {
            this._defaultHeight = param1;
        }
        
        public function get vID() : int
        {
            return this._vID;
        }
        
        public function set vID(param1:int) : void
        {
        }
        
        public function get completeFill() : Boolean
        {
            return this._completeFill;
        }
        
        public function set completeFill(param1:Boolean) : void
        {
            this._completeFill = param1;
        }
        
        public function get vertContainer() : Sprite
        {
            return this._vertContainer;
        }
        
        public function get vertVector() : Vector.<b2Vec2>
        {
            return this._vertVector;
        }
        
        public function get editMode() : Boolean
        {
            return this._editMode;
        }
        
        public function set editMode(param1:Boolean) : void
        {
            this._editMode = param1;
            if(this._editMode)
            {
                this.populateVertContainer();
                addChild(this._vertContainer);
                blendMode = BlendMode.INVERT;
            }
            else
            {
                this.destroyVertContainer();
                drawShape();
                blendMode = BlendMode.NORMAL;
            }
        }
        
        protected function populateVertContainer() : void
        {
            var _loc3_:b2Vec2 = null;
            var _loc4_:Vert = null;
            this.destroyVertContainer();
            this._vertContainer = new Sprite();
            var _loc1_:int = int(this._vertVector.length);
            var _loc2_:int = 0;
            while(_loc2_ < _loc1_)
            {
                _loc3_ = this._vertVector[_loc2_];
                _loc4_ = new Vert();
                _loc4_.edgeShape = this;
                _loc4_.vec = _loc3_;
                this._vertContainer.addChild(_loc4_);
                _loc2_++;
            }
        }
        
        protected function destroyVertContainer() : void
        {
            if(this._vertContainer)
            {
                if(this._vertContainer.parent)
                {
                    this._vertContainer.parent.removeChild(this._vertContainer);
                }
                this._vertContainer = null;
            }
        }
        
        public function recenter() : void
        {
            var _loc9_:b2Vec2 = null;
            var _loc1_:int = this.numVerts;
            var _loc2_:int = 0;
            var _loc3_:int = 0;
            var _loc4_:int = 0;
            var _loc5_:int = 0;
            var _loc6_:int = 0;
            while(_loc6_ < _loc1_)
            {
                _loc9_ = this._vertVector[_loc6_];
                if(_loc9_.x < _loc2_)
                {
                    _loc2_ = _loc9_.x;
                }
                if(_loc9_.x > _loc4_)
                {
                    _loc4_ = _loc9_.x;
                }
                if(_loc9_.y < _loc3_)
                {
                    _loc3_ = _loc9_.y;
                }
                if(_loc9_.y > _loc5_)
                {
                    _loc5_ = _loc9_.y;
                }
                _loc6_++;
            }
            var _loc7_:int = (_loc2_ + _loc4_) * 0.5;
            var _loc8_:int = (_loc3_ + _loc5_) * 0.5;
            _loc6_ = 0;
            while(_loc6_ < _loc1_)
            {
                _loc9_ = this._vertVector[_loc6_];
                _loc9_.x -= _loc7_;
                _loc9_.y -= _loc8_;
                _loc6_++;
            }
            xUnbound = x + _loc7_;
            yUnbound = y + _loc8_;
        }
        
        protected function setDefaultDimensions() : void
        {
            var _loc7_:b2Vec2 = null;
            var _loc1_:int = this.numVerts;
            var _loc2_:int = 0;
            var _loc3_:int = 0;
            var _loc4_:int = 0;
            var _loc5_:int = 0;
            var _loc6_:int = 0;
            while(_loc6_ < _loc1_)
            {
                _loc7_ = this._vertVector[_loc6_];
                if(_loc7_.x < _loc2_)
                {
                    _loc2_ = _loc7_.x;
                }
                if(_loc7_.x > _loc4_)
                {
                    _loc4_ = _loc7_.x;
                }
                if(_loc7_.y < _loc3_)
                {
                    _loc3_ = _loc7_.y;
                }
                if(_loc7_.y > _loc5_)
                {
                    _loc5_ = _loc7_.y;
                }
                _loc6_++;
            }
            this._defaultWidth = _loc4_ - _loc2_;
            this._defaultHeight = _loc5_ - _loc3_;
        }
        
        public function reverse() : void
        {
            var _loc3_:b2Vec2 = null;
            var _loc1_:int = this.numVerts;
            this._vertVector.reverse();
            var _loc2_:int = 0;
            while(_loc2_ < _loc1_)
            {
                _loc3_ = this._vertVector[_loc2_];
                _loc3_.x = -_loc3_.x;
                _loc2_++;
            }
            drawShape();
            drawBoundingBox();
            x = x;
            y = y;
            this.vID = PolygonTool.getIDCounter();
        }
    }
}

