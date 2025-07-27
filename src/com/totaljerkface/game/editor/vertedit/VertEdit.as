package com.totaljerkface.game.editor.vertedit
{
    import Box2D.Common.Math.b2Math;
    import Box2D.Common.Math.b2Vec2;
    import com.totaljerkface.game.Settings;
    import com.totaljerkface.game.editor.*;
    import com.totaljerkface.game.editor.actions.*;
    import flash.display.*;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    public class VertEdit extends Sprite
    {
        private static var _selectedVerts:Vector.<Vert>;
        
        public static const EDIT_COMPLETE:String = "editcomplete";
        
        private static const ADJUSTMENT_LENGTH:Number = 0.25;
        
        public var dragging:Boolean;
        
        public var translating:Boolean;
        
        private var _edgeShape:EdgeShape;
        
        private var _selectedHandle:BezierHandle;
        
        private var _mouseVert:Vert;
        
        private var _canvasIndex:int;
        
        private var _canvas:Canvas;
        
        private var boundingBoxSprite:Sprite;
        
        private var initialData:Vector.<Vector.<Number>>;
        
        public function VertEdit(param1:EdgeShape, param2:Canvas)
        {
            super();
            this._edgeShape = param1;
            this._canvas = param2;
            doubleClickEnabled = true;
            addEventListener(Event.ADDED_TO_STAGE,this.init);
        }
        
        private function init(param1:Event) : void
        {
            var _loc6_:ArtShape = null;
            var _loc8_:b2Vec2 = null;
            var _loc9_:b2Vec2 = null;
            var _loc10_:b2Vec2 = null;
            removeEventListener(Event.ADDED_TO_STAGE,this.init);
            var _loc2_:int = 20000;
            var _loc3_:int = 10000;
            graphics.beginFill(10066329,0.35);
            graphics.drawRect(0,0,_loc2_,_loc3_);
            graphics.endFill();
            this._canvasIndex = this._edgeShape.parent.getChildIndex(this._edgeShape);
            addChild(this._edgeShape);
            this._edgeShape.editMode = true;
            this._edgeShape.mouseEnabled = false;
            this._edgeShape.mouseChildren = true;
            this._edgeShape.blendMode = BlendMode.NORMAL;
            var _loc4_:Vert = this._edgeShape.getVertAt(0);
            trace("COMPLETE FILL " + this._edgeShape.completeFill);
            this._edgeShape.drawEditMode(_loc4_.position,this._edgeShape.completeFill);
            if(!_selectedVerts)
            {
                _selectedVerts = new Vector.<Vert>();
            }
            this.initialData = new Vector.<Vector.<Number>>();
            var _loc5_:int = this._edgeShape.numVerts;
            if(this._edgeShape is ArtShape)
            {
                _loc6_ = this._edgeShape as ArtShape;
            }
            var _loc7_:int = 0;
            while(_loc7_ < _loc5_)
            {
                _loc8_ = this._edgeShape.vertVector[_loc7_];
                this.initialData[_loc7_] = new Vector.<Number>(6);
                this.initialData[_loc7_][0] = _loc8_.x;
                this.initialData[_loc7_][1] = _loc8_.y;
                if(_loc6_)
                {
                    _loc9_ = _loc6_.handleVector[_loc7_ * 2];
                    _loc10_ = _loc6_.handleVector[_loc7_ * 2 + 1];
                    this.initialData[_loc7_][2] = _loc9_.x;
                    this.initialData[_loc7_][3] = _loc9_.y;
                    this.initialData[_loc7_][4] = _loc10_.x;
                    this.initialData[_loc7_][5] = _loc10_.y;
                }
                _loc7_++;
            }
            stage.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
            stage.addEventListener(MouseEvent.DOUBLE_CLICK,this.doubleClickHandler);
            stage.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
        }
        
        private function keyDownHandler(param1:KeyboardEvent) : void
        {
            switch(param1.keyCode)
            {
                case 8:
                    this.deleteSelected();
                    break;
                case 13:
                    this.insertVertSelected();
                    break;
                case 37:
                    this.moveSelected(-1,0,param1.shiftKey);
                    break;
                case 38:
                    this.moveSelected(0,-1,param1.shiftKey);
                    break;
                case 39:
                    this.moveSelected(1,0,param1.shiftKey);
                    break;
                case 40:
                    this.moveSelected(0,1,param1.shiftKey);
            }
        }
        
        private function mouseDownHandler(param1:MouseEvent) : void
        {
            var _loc2_:Action = null;
            var _loc3_:Action = null;
            var _loc4_:Vert = null;
            var _loc5_:int = 0;
            if(param1.target is Vert)
            {
                _loc4_ = param1.target as Vert;
                _loc5_ = int(_selectedVerts.indexOf(_loc4_));
                if(param1.shiftKey)
                {
                    if(_loc5_ < 0)
                    {
                        _loc2_ = this.addToSelected(_loc4_);
                        this._mouseVert = _loc4_;
                    }
                    else
                    {
                        _loc2_ = this.removeFromSelected(_loc4_);
                        this._mouseVert = null;
                    }
                    if(_selectedVerts.length > 0)
                    {
                        if(!this._mouseVert)
                        {
                            this._mouseVert = _selectedVerts[_selectedVerts.length - 1];
                        }
                        stage.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
                        stage.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveVert);
                    }
                }
                else
                {
                    if(_loc5_ < 0)
                    {
                        _loc3_ = this.deselectAll();
                        _loc2_ = this.addToSelected(_loc4_);
                        if(_loc3_)
                        {
                            _loc3_.nextAction = _loc2_;
                        }
                    }
                    this._mouseVert = _loc4_;
                    stage.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
                    stage.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveVert);
                }
            }
            else if(param1.target is BezierHandle)
            {
                this._selectedHandle = param1.target as BezierHandle;
                stage.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
                stage.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveBezHandle);
            }
            else
            {
                if(_selectedVerts.length > 0 && !param1.shiftKey)
                {
                    _loc2_ = this.deselectAll();
                }
                if(parent.contains(param1.target as DisplayObject))
                {
                    stage.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveBox);
                    stage.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
                    if(!this.boundingBoxSprite)
                    {
                        this.boundingBoxSprite = new Sprite();
                        addChild(this.boundingBoxSprite);
                        this.boundingBoxSprite.x = mouseX;
                        this.boundingBoxSprite.y = mouseY;
                        this.boundingBoxSprite.blendMode = BlendMode.INVERT;
                    }
                }
            }
            if(_loc2_)
            {
                dispatchEvent(new ActionEvent(ActionEvent.GENERIC,_loc2_));
            }
        }
        
        private function addToSelected(param1:Vert) : Action
        {
            param1.selected = true;
            _selectedVerts.push(param1);
            return new ActionSelectVert(this._edgeShape.getVertIndex(param1),this._edgeShape,_selectedVerts,_selectedVerts.length - 1);
        }
        
        private function removeFromSelected(param1:Vert) : Action
        {
            var _loc2_:Action = null;
            param1.selected = false;
            var _loc3_:int = int(_selectedVerts.indexOf(param1));
            if(_loc3_ > -1)
            {
                _selectedVerts.splice(_loc3_,1);
                _loc2_ = new ActionDeselectVert(this._edgeShape.getVertIndex(param1),this._edgeShape,_selectedVerts,_loc3_);
            }
            return _loc2_;
        }
        
        public function deselectAll() : Action
        {
            var _loc1_:Action = null;
            var _loc2_:Action = null;
            var _loc5_:Vert = null;
            var _loc3_:int = int(_selectedVerts.length);
            var _loc4_:int = _loc3_ - 1;
            while(_loc4_ > -1)
            {
                _loc5_ = _selectedVerts[_loc4_];
                _loc1_ = this.removeFromSelected(_loc5_);
                if(_loc2_)
                {
                    _loc2_.nextAction = _loc1_.firstAction;
                }
                _loc2_ = _loc1_;
                _loc4_--;
            }
            return _loc1_;
        }
        
        private function doubleClickHandler(param1:MouseEvent) : void
        {
            var _loc2_:BezierVert = null;
            if(param1.target is BezierVert)
            {
                _loc2_ = param1.target as BezierVert;
                if(_selectedVerts.indexOf(_loc2_) > -1)
                {
                    this.enableVertHandles(_loc2_);
                    this.redrawShape();
                }
            }
            else if(param1.target == this)
            {
                dispatchEvent(new Event(EDIT_COMPLETE));
            }
        }
        
        private function enableVertHandles(param1:BezierVert) : void
        {
            var _loc4_:BezierVert = null;
            var _loc5_:BezierVert = null;
            var _loc8_:Boolean = false;
            var _loc9_:Point = null;
            var _loc10_:Point = null;
            var _loc11_:Action = null;
            trace("ENABLE VERT HANDLES");
            var _loc2_:int = this._edgeShape.numVerts;
            var _loc3_:int = this._edgeShape.getVertIndex(param1);
            if(_loc3_ == 0)
            {
                _loc4_ = this._edgeShape.getVertAt(_loc2_ - 1) as BezierVert;
                _loc5_ = this._edgeShape.getVertAt(_loc3_ + 1) as BezierVert;
            }
            else if(_loc3_ == _loc2_ - 1)
            {
                _loc4_ = this._edgeShape.getVertAt(_loc3_ - 1) as BezierVert;
                _loc5_ = this._edgeShape.getVertAt(0) as BezierVert;
            }
            else
            {
                _loc4_ = this._edgeShape.getVertAt(_loc3_ - 1) as BezierVert;
                _loc5_ = this._edgeShape.getVertAt(_loc3_ + 1) as BezierVert;
            }
            var _loc6_:b2Vec2 = _loc4_.x == _loc5_.x && _loc4_.y == _loc5_.y ? new b2Vec2(_loc4_.x - param1.x,_loc4_.y - param1.y) : new b2Vec2(_loc4_.x - _loc5_.x,_loc4_.y - _loc5_.y);
            var _loc7_:Number = _loc6_.Length();
            _loc6_.Normalize();
            _loc6_.Multiply(Math.max(5,_loc7_ * 0.25));
            _loc6_.x = Math.round(_loc6_.x);
            _loc6_.y = Math.round(_loc6_.y);
            if(param1.handle1.x == 0 && param1.handle1.y == 0)
            {
                _loc8_ = true;
                _loc9_ = new Point(param1.handle1.x,param1.handle1.y);
                if(!(param1.handle2.x == 0 && param1.handle2.y == 0))
                {
                    param1.handle1.Set(-param1.handle2.x,-param1.handle2.y);
                }
                else
                {
                    param1.handle1.Set(_loc6_.x,_loc6_.y);
                }
            }
            if(param1.handle2.x == 0 && param1.handle2.y == 0)
            {
                _loc8_ = true;
                _loc10_ = new Point(param1.handle2.x,param1.handle2.y);
                if(!(param1.handle1.x == 0 && param1.handle1.y == 0))
                {
                    param1.handle2.Set(-param1.handle1.x,-param1.handle1.y);
                }
                else
                {
                    param1.handle2.Set(_loc6_.x,_loc6_.y);
                }
            }
            if(_loc8_)
            {
                _loc11_ = new ActionMoveHandle(this._edgeShape.getVertIndex(param1),this._edgeShape,_loc9_,_loc10_);
                dispatchEvent(new ActionEvent(ActionEvent.GENERIC,_loc11_));
            }
        }
        
        private function mouseUpHandler(param1:MouseEvent) : void
        {
            var _loc2_:Action = null;
            var _loc3_:Action = null;
            var _loc4_:Rectangle = null;
            var _loc5_:int = 0;
            var _loc6_:int = 0;
            var _loc7_:Vert = null;
            var _loc8_:Rectangle = null;
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveVert);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveBezHandle);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveBox);
            this.dragging = false;
            this._mouseVert = null;
            if(this._selectedHandle)
            {
                this._selectedHandle = null;
            }
            if(this.boundingBoxSprite)
            {
                _loc4_ = this.boundingBoxSprite.getBounds(this._canvas);
                removeChild(this.boundingBoxSprite);
                this.boundingBoxSprite = null;
                _loc5_ = this._edgeShape.numVerts;
                if(!param1.shiftKey)
                {
                    _loc2_ = this.deselectAll();
                }
                _loc6_ = 0;
                while(_loc6_ < _loc5_)
                {
                    _loc7_ = this._edgeShape.getVertAt(_loc6_) as Vert;
                    _loc8_ = _loc7_.getBounds(this._canvas);
                    if(_loc8_.intersects(_loc4_))
                    {
                        _loc3_ = this.addToSelected(_loc7_);
                        if(_loc2_)
                        {
                            _loc2_.nextAction = _loc3_;
                        }
                        _loc2_ = _loc3_;
                    }
                    _loc6_++;
                }
            }
            if(_loc3_)
            {
                dispatchEvent(new ActionEvent(ActionEvent.GENERIC,_loc3_));
            }
        }
        
        private function storeCoords() : Vector.<b2Vec2>
        {
            var _loc4_:Vert = null;
            var _loc1_:Vector.<b2Vec2> = new Vector.<b2Vec2>();
            var _loc2_:int = this._edgeShape.numVerts;
            var _loc3_:int = 0;
            while(_loc3_ < _loc2_)
            {
                _loc4_ = this._edgeShape.getVertAt(_loc3_);
                _loc1_.push(new b2Vec2(_loc4_.x,_loc4_.y));
                _loc3_++;
            }
            return _loc1_;
        }
        
        private function mouseMoveVert(param1:MouseEvent) : void
        {
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            var _loc4_:Number = NaN;
            var _loc5_:Number = NaN;
            var _loc6_:ActionMoveVert = null;
            var _loc7_:ActionMoveVert = null;
            var _loc8_:int = 0;
            var _loc9_:int = 0;
            var _loc10_:Vert = null;
            var _loc11_:Number = NaN;
            var _loc12_:Number = NaN;
            var _loc13_:Vector.<b2Vec2> = null;
            var _loc14_:Vector.<b2Vec2> = null;
            var _loc15_:Vector.<int> = null;
            var _loc16_:int = 0;
            var _loc17_:b2Vec2 = null;
            if(_selectedVerts.length > 0)
            {
                _loc2_ = this._mouseVert.x;
                _loc3_ = this._mouseVert.y;
                _loc4_ = Math.round(this._edgeShape.mouseX);
                _loc5_ = Math.round(this._edgeShape.mouseY);
                if(param1.shiftKey)
                {
                    _loc4_ = Math.round(_loc4_ * 0.1) * 10;
                    _loc5_ = Math.round(_loc5_ * 0.1) * 10;
                }
                _loc8_ = int(_selectedVerts.length);
                if(this._edgeShape is ArtShape)
                {
                    _loc9_ = 0;
                    while(_loc9_ < _loc8_)
                    {
                        _loc10_ = _selectedVerts[_loc9_];
                        if(!this.dragging)
                        {
                            _loc6_ = new ActionMoveVert(this._edgeShape.getVertIndex(_loc10_),this._edgeShape,new Point(_loc10_.x,_loc10_.y));
                            if(_loc7_)
                            {
                                _loc6_.prevAction = _loc7_;
                            }
                            _loc7_ = _loc6_;
                        }
                        _loc11_ = _loc10_.x - _loc2_;
                        _loc12_ = _loc10_.y - _loc3_;
                        _loc10_.x = Math.round(_loc4_ + _loc11_);
                        _loc10_.y = Math.round(_loc5_ + _loc12_);
                        _loc9_++;
                    }
                    if(!this.dragging)
                    {
                        dispatchEvent(new ActionEvent(ActionEvent.GENERIC,_loc6_));
                        this.dragging = true;
                    }
                    this.redrawShape();
                }
                else
                {
                    _loc13_ = this.storeCoords();
                    _loc14_ = this.storeCoords();
                    _loc15_ = new Vector.<int>();
                    _loc9_ = 0;
                    while(_loc9_ < _loc8_)
                    {
                        _loc10_ = _selectedVerts[_loc9_];
                        _loc16_ = this._edgeShape.getVertIndex(_loc10_);
                        _loc15_.push(_loc16_);
                        _loc17_ = _loc14_[_loc16_];
                        _loc11_ = _loc10_.x - _loc2_;
                        _loc12_ = _loc10_.y - _loc3_;
                        _loc17_.x = Math.round(_loc4_ + _loc11_);
                        _loc17_.y = Math.round(_loc5_ + _loc12_);
                        _loc9_++;
                    }
                    if(this.isConvexB2Vec2(_loc14_))
                    {
                        _loc9_ = 0;
                        while(_loc9_ < _loc8_)
                        {
                            _loc10_ = _selectedVerts[_loc9_];
                            _loc17_ = _loc14_[_loc15_[_loc9_]];
                            if(!this.dragging)
                            {
                                _loc6_ = new ActionMoveVert(this._edgeShape.getVertIndex(_loc10_),this._edgeShape,new Point(_loc10_.x,_loc10_.y));
                                if(_loc7_)
                                {
                                    _loc6_.prevAction = _loc7_;
                                }
                                _loc7_ = _loc6_;
                            }
                            _loc10_.x = _loc17_.x;
                            _loc10_.y = _loc17_.y;
                            _loc9_++;
                        }
                        if(!this.dragging)
                        {
                            dispatchEvent(new ActionEvent(ActionEvent.GENERIC,_loc6_));
                            this.dragging = true;
                        }
                        this.redrawShape();
                    }
                }
            }
        }
        
        private function isConvexB2Vec2(param1:Vector.<b2Vec2>) : Boolean
        {
            var _loc4_:b2Vec2 = null;
            var _loc5_:int = 0;
            var _loc6_:b2Vec2 = null;
            var _loc7_:b2Vec2 = null;
            var _loc8_:b2Vec2 = null;
            var _loc9_:b2Vec2 = null;
            var _loc10_:b2Vec2 = null;
            var _loc11_:Number = NaN;
            var _loc2_:int = int(param1.length);
            var _loc3_:int = 0;
            while(_loc3_ < _loc2_)
            {
                _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
                _loc4_ = param1[_loc3_];
                _loc5_ = _loc3_ + 1;
                if(_loc5_ > _loc2_ - 1)
                {
                    _loc5_ -= _loc2_;
                }
                _loc6_ = param1[_loc5_];
                _loc5_ = _loc3_ + 2;
                if(_loc5_ > _loc2_ - 1)
                {
                    _loc5_ -= _loc2_;
                }
                _loc7_ = param1[_loc5_];
                _loc8_ = new b2Vec2(_loc6_.x - _loc4_.x,_loc6_.y - _loc4_.y);
                _loc9_ = new b2Vec2(_loc7_.x - _loc6_.x,_loc7_.y - _loc6_.y);
                _loc8_.Normalize();
                _loc9_.Normalize();
                _loc10_ = new b2Vec2(_loc8_.y,-_loc8_.x);
                _loc11_ = b2Math.b2Dot(_loc9_,_loc10_);
                if(_loc11_ >= 0)
                {
                    return false;
                }
                _loc3_++;
            }
            return true;
        }
        
        private function fixConcaveViolations() : Action
        {
            var _loc1_:Action = null;
            var _loc2_:Action = null;
            var _loc3_:Boolean = false;
            var _loc5_:int = 0;
            var _loc6_:Vert = null;
            var _loc7_:int = 0;
            var _loc8_:Vert = null;
            var _loc9_:Vert = null;
            var _loc10_:b2Vec2 = null;
            var _loc11_:b2Vec2 = null;
            var _loc12_:b2Vec2 = null;
            var _loc13_:Number = NaN;
            var _loc14_:b2Vec2 = null;
            var _loc15_:b2Vec2 = null;
            var _loc4_:int = this._edgeShape.numVerts;
            do
            {
                _loc3_ = false;
                _loc5_ = 0;
                while(_loc5_ < _loc4_)
                {
                    _loc6_ = this._edgeShape.getVertAt(_loc5_);
                    _loc7_ = _loc5_ + 1;
                    if(_loc7_ > _loc4_ - 1)
                    {
                        _loc7_ -= _loc4_;
                    }
                    _loc8_ = this._edgeShape.getVertAt(_loc7_);
                    _loc7_ = _loc5_ + 2;
                    if(_loc7_ > _loc4_ - 1)
                    {
                        _loc7_ -= _loc4_;
                    }
                    _loc9_ = this._edgeShape.getVertAt(_loc7_);
                    _loc10_ = new b2Vec2(_loc8_.x - _loc6_.x,_loc8_.y - _loc6_.y);
                    _loc11_ = new b2Vec2(_loc9_.x - _loc8_.x,_loc9_.y - _loc8_.y);
                    _loc10_.Normalize();
                    _loc11_.Normalize();
                    _loc12_ = new b2Vec2(_loc10_.y,-_loc10_.x);
                    _loc13_ = b2Math.b2Dot(_loc11_,_loc12_);
                    if(_loc13_ >= 0)
                    {
                        _loc3_ = true;
                        _loc14_ = new b2Vec2(_loc9_.x - _loc6_.x,_loc9_.y - _loc6_.y);
                        _loc14_.Normalize();
                        _loc15_ = new b2Vec2(_loc14_.y,-_loc14_.x);
                        _loc13_ = b2Math.b2Dot(_loc14_,new b2Vec2(_loc8_.x - _loc6_.x,_loc8_.y - _loc6_.y));
                        _loc2_ = new ActionMoveVert(this._edgeShape.getVertIndex(_loc8_),this._edgeShape,new Point(_loc8_.x,_loc8_.y));
                        if(_loc1_)
                        {
                            _loc1_.nextAction = _loc2_;
                        }
                        _loc1_ = _loc2_;
                        _loc8_.x = _loc6_.x + _loc14_.x * _loc13_ + _loc15_.x * ADJUSTMENT_LENGTH;
                        _loc8_.y = _loc6_.y + _loc14_.y * _loc13_ + _loc15_.y * ADJUSTMENT_LENGTH;
                    }
                    _loc5_++;
                }
            }
            while(_loc3_ == true);
            
            return _loc1_;
        }
        
        private function mouseMoveBezHandle(param1:MouseEvent) : void
        {
            var _loc2_:Number = NaN;
            var _loc3_:Action = null;
            var _loc4_:BezierHandle = null;
            if(this._selectedHandle)
            {
                if(!this.dragging)
                {
                    _loc3_ = new ActionMoveHandle(this._edgeShape.getVertIndex(this._selectedHandle.vert),this._edgeShape);
                }
                this._selectedHandle.Set(Math.round(this._selectedHandle.vert.mouseX),Math.round(this._selectedHandle.vert.mouseY));
                if(param1.shiftKey)
                {
                    this._selectedHandle.Set(Math.round(this._selectedHandle.x * 0.1) * 10,Math.round(this._selectedHandle.y * 0.1) * 10);
                }
                _loc2_ = Math.sqrt(this._selectedHandle.x * this._selectedHandle.x + this._selectedHandle.y * this._selectedHandle.y);
                if(_loc2_ < 5 * Math.pow(2,-Editor.currentZoom))
                {
                    this._selectedHandle.Set(0,0);
                }
                if(!param1.altKey)
                {
                    _loc4_ = this._selectedHandle == this._selectedHandle.vert.handle1 ? this._selectedHandle.vert.handle2 : this._selectedHandle.vert.handle1;
                    _loc4_.Set(-this._selectedHandle.x,-this._selectedHandle.y);
                }
                this.redrawShape();
                if(!this.dragging)
                {
                    dispatchEvent(new ActionEvent(ActionEvent.GENERIC,_loc3_));
                    this.dragging = true;
                }
            }
        }
        
        private function mouseMoveBox(param1:MouseEvent) : void
        {
            if(this.boundingBoxSprite)
            {
                this.boundingBoxSprite.graphics.clear();
                this.boundingBoxSprite.graphics.lineStyle(1,0,1);
                this.boundingBoxSprite.graphics.drawRect(0,0,this.boundingBoxSprite.mouseX,this.boundingBoxSprite.mouseY);
            }
        }
        
        private function moveSelected(param1:Number, param2:Number, param3:Boolean) : void
        {
            var _loc5_:Action = null;
            var _loc6_:Action = null;
            var _loc7_:int = 0;
            var _loc8_:Vert = null;
            var _loc9_:Vector.<b2Vec2> = null;
            var _loc10_:Vector.<b2Vec2> = null;
            var _loc11_:Vector.<int> = null;
            var _loc12_:int = 0;
            var _loc13_:b2Vec2 = null;
            if(stage.hasEventListener(MouseEvent.MOUSE_UP))
            {
                return;
            }
            var _loc4_:int = int(_selectedVerts.length);
            if(_loc4_ == 0)
            {
                return;
            }
            if(param3)
            {
                param1 *= 10;
                param2 *= 10;
            }
            param1 *= 1 / this._canvas.parent.scaleX;
            param2 *= 1 / this._canvas.parent.scaleY;
            if(this._edgeShape is ArtShape)
            {
                _loc7_ = 0;
                while(_loc7_ < _loc4_)
                {
                    _loc8_ = _selectedVerts[_loc7_];
                    if(!this.translating)
                    {
                        _loc5_ = new ActionMoveVert(this._edgeShape.getVertIndex(_loc8_),this._edgeShape,new Point(_loc8_.x,_loc8_.y));
                        if(_loc6_)
                        {
                            _loc5_.prevAction = _loc6_;
                        }
                        _loc6_ = _loc5_;
                    }
                    _loc8_.x += param1;
                    _loc8_.y += param2;
                    _loc7_++;
                }
                if(!this.translating && Boolean(_loc5_))
                {
                    dispatchEvent(new ActionEvent(ActionEvent.GENERIC,_loc5_));
                    this.translating = true;
                }
                this.redrawShape();
            }
            else
            {
                _loc9_ = this.storeCoords();
                _loc10_ = this.storeCoords();
                _loc11_ = new Vector.<int>();
                _loc7_ = 0;
                while(_loc7_ < _loc4_)
                {
                    _loc8_ = _selectedVerts[_loc7_];
                    _loc12_ = this._edgeShape.getVertIndex(_loc8_);
                    _loc11_.push(_loc12_);
                    _loc13_ = _loc10_[_loc12_];
                    _loc13_.x += param1;
                    _loc13_.y += param2;
                    _loc7_++;
                }
                if(this.isConvexB2Vec2(_loc10_))
                {
                    _loc7_ = 0;
                    while(_loc7_ < _loc4_)
                    {
                        _loc8_ = _selectedVerts[_loc7_];
                        _loc13_ = _loc10_[_loc11_[_loc7_]];
                        if(!this.translating)
                        {
                            _loc5_ = new ActionMoveVert(this._edgeShape.getVertIndex(_loc8_),this._edgeShape,new Point(_loc8_.x,_loc8_.y));
                            if(_loc6_)
                            {
                                _loc5_.prevAction = _loc6_;
                            }
                            _loc6_ = _loc5_;
                        }
                        _loc8_.x = _loc13_.x;
                        _loc8_.y = _loc13_.y;
                        _loc7_++;
                    }
                    if(!this.translating)
                    {
                        dispatchEvent(new ActionEvent(ActionEvent.GENERIC,_loc5_));
                        this.translating = true;
                    }
                    this.redrawShape();
                }
            }
        }
        
        private function deleteSelected() : void
        {
            var _loc1_:Action = null;
            var _loc2_:Action = null;
            var _loc3_:Action = null;
            var _loc8_:Vert = null;
            var _loc9_:int = 0;
            var _loc4_:int = this._edgeShape is ArtShape ? 2 : 3;
            var _loc5_:String = this._edgeShape is ArtShape ? "Art shapes must have at least 2 vertices" : "Polygon shapes must have at least 3 vertices";
            var _loc6_:int = int(_selectedVerts.length);
            var _loc7_:int = _loc6_ - 1;
            while(_loc7_ > -1)
            {
                if(this._edgeShape.numVerts <= _loc4_)
                {
                    Settings.debugText.show(_loc5_);
                    break;
                }
                _loc8_ = _selectedVerts[_loc7_];
                _loc1_ = this.removeFromSelected(_loc8_);
                _loc9_ = this._edgeShape.getVertIndex(_loc8_);
                _loc2_ = new ActionDeleteVert(_loc9_,this._edgeShape,null);
                this._edgeShape.removeVert(_loc9_);
                _loc2_.prevAction = _loc1_;
                if(_loc3_)
                {
                    _loc3_.nextAction = _loc1_;
                }
                _loc3_ = _loc2_;
                _loc7_--;
            }
            this.redrawShape();
            if(_loc2_)
            {
                dispatchEvent(new ActionEvent(ActionEvent.GENERIC,_loc2_));
            }
        }
        
        private function insertVertSelected() : void
        {
            var _loc4_:Action = null;
            var _loc5_:Action = null;
            var _loc6_:Action = null;
            var _loc7_:Vert = null;
            var _loc8_:Vert = null;
            var _loc9_:BezierVert = null;
            var _loc10_:BezierVert = null;
            var _loc11_:* = undefined;
            var _loc12_:* = null;
            var _loc14_:Number = NaN;
            var _loc15_:Number = NaN;
            var _loc16_:Vert = null;
            var _loc17_:b2Vec2 = null;
            var _loc18_:b2Vec2 = null;
            var _loc19_:int = 0;
            var _loc1_:int = int(_selectedVerts.length);
            var _loc2_:int = this._edgeShape.numVerts;
            var _loc3_:Vert = this._edgeShape.getVertAt(_loc2_ - 1);
            if(this._edgeShape is ArtShape)
            {
                _loc11_ = ArtTool.MAX_VERTS;
                _loc12_ = "Art shapes have a maximum of " + _loc11_ + " vertices";
            }
            else
            {
                _loc11_ = PolygonTool.MAX_VERTS;
                _loc12_ = "Polygon shapes have a maximum of " + _loc11_ + " vertices";
            }
            var _loc13_:int = 0;
            while(_loc13_ < _loc1_)
            {
                _loc7_ = _selectedVerts[_loc13_];
                if(_loc2_ >= _loc11_)
                {
                    Settings.debugText.show(_loc12_);
                    break;
                }
                if(_loc7_ == _loc3_)
                {
                    if(this._edgeShape.completeFill)
                    {
                        _loc8_ = this._edgeShape.getVertAt(0);
                        if(_loc7_ is BezierVert && _loc8_ is BezierVert)
                        {
                            _loc9_ = _loc7_ as BezierVert;
                            _loc10_ = _loc8_ as BezierVert;
                            _loc14_ = ArtShape.bezierValue(0.5,_loc9_.x,_loc9_.anchor2.x,_loc10_.anchor1.x,_loc10_.x);
                            _loc15_ = ArtShape.bezierValue(0.5,_loc9_.y,_loc9_.anchor2.y,_loc10_.anchor1.y,_loc10_.y);
                            _loc16_ = new BezierVert(_loc14_,_loc15_);
                        }
                        else
                        {
                            _loc17_ = new b2Vec2(_loc8_.x - _loc7_.x,_loc8_.y - _loc7_.y);
                            _loc18_ = new b2Vec2(_loc17_.y,-_loc17_.x);
                            _loc18_.Normalize();
                            _loc14_ = _loc7_.x + _loc17_.x * 0.5 + _loc18_.x * ADJUSTMENT_LENGTH;
                            _loc15_ = _loc7_.y + _loc17_.y * 0.5 + _loc18_.y * ADJUSTMENT_LENGTH;
                            _loc16_ = new Vert(_loc14_,_loc15_);
                        }
                        _loc16_.edgeShape = this._edgeShape;
                        this._edgeShape.addVert(_loc16_);
                        _loc3_ = _loc16_;
                        _loc2_++;
                        _loc4_ = new ActionAddVert(_loc2_ - 1,this._edgeShape);
                        if(_loc5_)
                        {
                            _loc5_.nextAction = _loc4_;
                        }
                        _loc5_ = _loc4_;
                    }
                }
                else
                {
                    _loc19_ = this._edgeShape.getVertIndex(_loc7_);
                    _loc8_ = this._edgeShape.getVertAt(_loc19_ + 1);
                    if(_loc7_ is BezierVert && _loc8_ is BezierVert)
                    {
                        _loc9_ = _loc7_ as BezierVert;
                        _loc10_ = _loc8_ as BezierVert;
                        _loc14_ = ArtShape.bezierValue(0.5,_loc9_.x,_loc9_.anchor2.x,_loc10_.anchor1.x,_loc10_.x);
                        _loc15_ = ArtShape.bezierValue(0.5,_loc9_.y,_loc9_.anchor2.y,_loc10_.anchor1.y,_loc10_.y);
                        _loc16_ = new BezierVert(_loc14_,_loc15_);
                    }
                    else
                    {
                        _loc17_ = new b2Vec2(_loc8_.x - _loc7_.x,_loc8_.y - _loc7_.y);
                        _loc18_ = new b2Vec2(_loc17_.y,-_loc17_.x);
                        _loc18_.Normalize();
                        _loc14_ = _loc7_.x + _loc17_.x * 0.5 + _loc18_.x * ADJUSTMENT_LENGTH;
                        _loc15_ = _loc7_.y + _loc17_.y * 0.5 + _loc18_.y * ADJUSTMENT_LENGTH;
                        _loc16_ = new Vert(_loc14_,_loc15_);
                    }
                    _loc16_.edgeShape = this._edgeShape;
                    this._edgeShape.addVert(_loc16_,_loc19_ + 1);
                    _loc2_++;
                    _loc3_ = this._edgeShape.getVertAt(_loc2_ - 1);
                    trace(_loc19_ + 1);
                    _loc4_ = new ActionAddVert(_loc19_ + 1,this._edgeShape);
                    if(_loc5_)
                    {
                        _loc5_.nextAction = _loc4_;
                    }
                    _loc5_ = _loc4_;
                }
                _loc13_++;
            }
            if(this._edgeShape is PolygonShape)
            {
                _loc6_ = this.fixConcaveViolations();
            }
            this.redrawShape();
            if(_loc6_)
            {
                _loc4_.nextAction = _loc6_.firstAction;
                _loc4_ = _loc6_;
            }
            if(_loc4_)
            {
                dispatchEvent(new ActionEvent(ActionEvent.GENERIC,_loc4_));
            }
        }
        
        private function redrawShape() : void
        {
            var _loc1_:Vert = this._edgeShape.getVertAt(0);
            this._edgeShape.drawEditMode(_loc1_.position,this._edgeShape.completeFill);
        }
        
        public function resizeVerts() : void
        {
            this._edgeShape.resizeVerts();
        }
        
        private function isDataAltered() : Boolean
        {
            var _loc2_:ArtShape = null;
            var _loc4_:b2Vec2 = null;
            var _loc5_:b2Vec2 = null;
            var _loc6_:b2Vec2 = null;
            var _loc1_:int = this._edgeShape.numVerts;
            if(_loc1_ != this.initialData.length)
            {
                return true;
            }
            if(this._edgeShape is ArtShape)
            {
                _loc2_ = this._edgeShape as ArtShape;
            }
            var _loc3_:int = 0;
            while(_loc3_ < _loc1_)
            {
                _loc4_ = this._edgeShape.vertVector[_loc3_];
                if(this.initialData[_loc3_][0] != _loc4_.x)
                {
                    return true;
                }
                if(this.initialData[_loc3_][1] != _loc4_.y)
                {
                    return true;
                }
                if(_loc2_)
                {
                    _loc5_ = _loc2_.handleVector[_loc3_ * 2];
                    _loc6_ = _loc2_.handleVector[_loc3_ * 2 + 1];
                    if(this.initialData[_loc3_][2] != _loc5_.x)
                    {
                        return true;
                    }
                    if(this.initialData[_loc3_][3] != _loc5_.y)
                    {
                        return true;
                    }
                    if(this.initialData[_loc3_][4] != _loc6_.x)
                    {
                        return true;
                    }
                    if(this.initialData[_loc3_][5] != _loc6_.y)
                    {
                        return true;
                    }
                }
                _loc3_++;
            }
            return false;
        }
        
        public function get edgeShape() : EdgeShape
        {
            return this._edgeShape;
        }
        
        public function die() : void
        {
            stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
            stage.removeEventListener(MouseEvent.DOUBLE_CLICK,this.doubleClickHandler);
            stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveBezHandle);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveVert);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveBox);
            removeEventListener(Event.ADDED_TO_STAGE,this.init);
            if(parent)
            {
                parent.removeChild(this);
            }
            this._edgeShape.editMode = false;
            this._edgeShape.mouseEnabled = true;
            this._edgeShape.mouseChildren = false;
            trace("ALTERED " + this.isDataAltered());
            if(this.isDataAltered())
            {
                if(this._edgeShape is ArtShape)
                {
                    this._edgeShape.vID = ArtTool.getIDCounter();
                }
                else
                {
                    this._edgeShape.vID = PolygonTool.getIDCounter();
                }
            }
            this._canvas.addRefSpriteAt(this._edgeShape,this._canvasIndex);
        }
    }
}

