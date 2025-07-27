package com.totaljerkface.game.editor
{
    import Box2D.Common.Math.b2Math;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Common.b2Settings;
    import com.totaljerkface.game.Settings;
    import com.totaljerkface.game.editor.actions.*;
    import com.totaljerkface.game.editor.ui.*;
    import com.totaljerkface.game.editor.vertedit.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.ui.Mouse;
    import flash.utils.*;
    
    public class PolygonTool extends Tool
    {
        public static const MAX_VERTS:int = b2Settings.b2_maxPolygonVertices;
        
        private static const MIN_SHAPE_LINE_DISTANCE:int = 5;
        
        private static const SNAP_DISTANCE:int = 5;
        
        private static const MAX_LINE_DISTANCE:int = 1000;
        
        private static const P_NORMAL:int = 0;
        
        private static const P_COMPLETE:int = 1;
        
        private static const P_DONT_UPDATE:int = 2;
        
        private static const P_REPLACE_PREV:int = 3;
        
        private static const P_END:int = 4;
        
        private static var idCounter:int = 0;
        
        protected var remainingVertsInput:TextInput;
        
        protected var densityInput:TextInput;
        
        protected var colorInput:ColorInput;
        
        protected var outlineColorInput:ColorInput;
        
        protected var opacityInput:SliderInput;
        
        protected var collisionInput:SliderInput;
        
        protected var immovableCheck:CheckBox;
        
        protected var asleepCheck:CheckBox;
        
        protected var shiftPressed:Boolean;
        
        protected var ctrlPressed:Boolean;
        
        protected var currentShape:PolygonShape;
        
        protected var nextPos:b2Vec2;
        
        protected var cursorSprite:Sprite;
        
        protected var polyState:int = 0;
        
        private const helpMessage:String = "<u><b>Polygon Tool Help:</b></u><br><br>The polygon tool can be used to make convex polygonal shapes easily. Click wherever you\'d like to place vertices and lines. Click on the first vertex again to complete the shape. <br><br>When making your shapes, you must place your points in a clockwise direction. Also, you are limited to convex polygon shapes with 10 vertices at most.<br><br><u>Keyboard Shortcuts:</u><br><br>Hold <b>shift</b> while moving your mouse to align your points to a 10 pixel grid.<br><br><b>Delete</b> or undo will remove your last placed point.<br><br><b>Enter</b> will complete the polygon immediately with the current points.";
        
        public function PolygonTool(param1:Editor, param2:Canvas)
        {
            super(param1,param2);
            this.init();
        }
        
        public static function updateIdCounter(param1:int) : void
        {
            if(param1 < idCounter)
            {
                return;
            }
            idCounter = param1 + 1;
        }
        
        public static function getIDCounter() : int
        {
            return idCounter;
        }
        
        protected function init() : void
        {
            var _loc3_:int = 0;
            this.createCursor();
            this.currentShape = new PolygonShape();
            this.currentShape.editMode = true;
            this.currentShape.mouseEnabled = false;
            idCounter = 0;
            var _loc1_:int = 0;
            var _loc2_:int = 0;
            _loc3_ = 5;
            var _loc4_:Number = 16613761;
            var _loc5_:Number = 120;
            this.remainingVertsInput = new TextInput("vertices left","vertsLeft",2,true,true);
            this.remainingVertsInput.x = _loc3_;
            this.remainingVertsInput.y = _loc3_;
            addChild(this.remainingVertsInput);
            this.colorInput = new ColorInput("shape color","color",true,true);
            this.colorInput.x = _loc3_;
            this.colorInput.y = this.remainingVertsInput.y + Math.ceil(this.remainingVertsInput.height) + 5;
            addChild(this.colorInput);
            this.outlineColorInput = new ColorInput("outline color","outlineColor",true,true);
            this.outlineColorInput.x = _loc3_;
            this.outlineColorInput.y = this.colorInput.y + Math.ceil(this.colorInput.height);
            addChild(this.outlineColorInput);
            this.opacityInput = new SliderInput("opacity","opacity",3,true,0,100,100);
            this.opacityInput.restrict = "0-9";
            this.opacityInput.helpCaption = "Transparent shapes are more cpu intensive than opaque shapes, so use transparency sparingly.  Best performance is at 100 or 0.";
            this.opacityInput.x = _loc3_;
            this.opacityInput.y = this.outlineColorInput.y + Math.ceil(this.outlineColorInput.height);
            addChild(this.opacityInput);
            this.immovableCheck = new CheckBox("fixed","immovable",true,true,true);
            this.immovableCheck.y = this.opacityInput.y + Math.ceil(this.opacityInput.height);
            this.immovableCheck.x = _loc3_;
            this.immovableCheck.helpCaption = "A fixed object will never move and will support any weight.";
            addChild(this.immovableCheck);
            this.asleepCheck = new CheckBox("sleeping","sleeping",false,false);
            this.asleepCheck.y = this.immovableCheck.y + Math.ceil(this.immovableCheck.height);
            this.asleepCheck.x = _loc3_;
            this.asleepCheck.helpCaption = "A sleeping object will remain frozen in place until it is touched by any other moving object.";
            addChild(this.asleepCheck);
            this.densityInput = new TextInput("density","density",4,true);
            this.densityInput.restrict = "0-9.";
            this.densityInput.x = _loc3_;
            this.densityInput.y = this.asleepCheck.y + Math.ceil(this.asleepCheck.height);
            this.densityInput.helpCaption = "The mass per volume of an object.  The bodies of human characters in this game are set to a density of 1.";
            addChild(this.densityInput);
            this.immovableCheck.addChildInput(this.asleepCheck);
            this.immovableCheck.addChildInput(this.densityInput);
            this.collisionInput = AttributeReference.buildInput("collision") as SliderInput;
            this.collisionInput.x = _loc3_;
            this.collisionInput.y = this.densityInput.y + Math.ceil(this.densityInput.height);
            addChild(this.collisionInput);
            this.immovableCheck.addEventListener(ValueEvent.VALUE_CHANGE,this.inputValueChange);
            this.colorInput.addEventListener(ValueEvent.VALUE_CHANGE,this.inputValueChange);
            this.outlineColorInput.addEventListener(ValueEvent.VALUE_CHANGE,this.inputValueChange);
            this.opacityInput.addEventListener(ValueEvent.VALUE_CHANGE,this.inputValueChange);
            this.collisionInput.addEventListener(ValueEvent.VALUE_CHANGE,this.inputValueChange);
            this.updateTextFields();
        }
        
        override public function activate() : void
        {
            super.activate();
            HelpWindow.instance.populate(this.helpMessage);
            window.setDimensions(130,this.height + 10);
            _canvas.parent.addChild(this.currentShape);
            stage.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
            stage.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
            stage.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
            stage.addEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
        }
        
        public function activateContinueDrawing() : void
        {
            super.activate();
            HelpWindow.instance.populate(this.helpMessage);
            window.setDimensions(130,this.height + 10);
            _canvas.parent.addChild(this.currentShape);
            stage.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
            stage.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
            stage.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
            stage.addEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
        }
        
        override public function deactivate() : void
        {
            var _loc1_:int = 0;
            var _loc2_:Action = null;
            var _loc3_:Action = null;
            var _loc4_:int = 0;
            if(this.currentShape.parent)
            {
                _canvas.parent.removeChild(this.currentShape);
                _loc1_ = this.currentShape.numVerts;
                _loc4_ = _loc1_ - 1;
                while(_loc4_ > -1)
                {
                    _loc3_ = new ActionDeleteVert(_loc4_,this.currentShape,this);
                    this.currentShape.removeVert();
                    if(_loc2_)
                    {
                        _loc2_.nextAction = _loc3_;
                    }
                    _loc2_ = _loc3_;
                    _loc4_--;
                }
                if(_loc3_)
                {
                    dispatchEvent(new ActionEvent(ActionEvent.GENERIC,_loc3_));
                }
                this.currentShape.redraw();
            }
            this.colorInput.closeColorSelector();
            this.outlineColorInput.closeColorSelector();
            this.updateRemainingVerts();
            this.cursorSprite.visible = false;
            Mouse.show();
            stage.removeEventListener(Event.ENTER_FRAME,this.frameHandler);
            stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
            stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
            stage.removeEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
            super.deactivate();
        }
        
        public function deactivateContinueDrawing() : void
        {
            trace("deactivate polygon keep selection");
            this.colorInput.closeColorSelector();
            this.outlineColorInput.closeColorSelector();
            this.cursorSprite.visible = false;
            stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
            stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
            stage.removeEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
            super.deactivate();
        }
        
        protected function createCursor() : void
        {
            this.cursorSprite = new Sprite();
            this.cursorSprite.graphics.lineStyle(1,0,1,true);
            this.cursorSprite.graphics.moveTo(-5,0);
            this.cursorSprite.graphics.lineTo(5,0);
            this.cursorSprite.graphics.moveTo(0,-5);
            this.cursorSprite.graphics.lineTo(0,5);
            this.cursorSprite.mouseEnabled = false;
            this.cursorSprite.blendMode = BlendMode.INVERT;
            this.cursorSprite.visible = false;
            canvas.parent.parent.addChild(this.cursorSprite);
        }
        
        protected function frameHandler(param1:Event) : void
        {
            var _loc3_:Vert = null;
            var _loc4_:Vert = null;
            var _loc5_:Vert = null;
            var _loc6_:Vert = null;
            var _loc7_:b2Vec2 = null;
            var _loc8_:b2Vec2 = null;
            var _loc9_:b2Vec2 = null;
            var _loc10_:b2Vec2 = null;
            var _loc11_:b2Vec2 = null;
            var _loc12_:b2Vec2 = null;
            var _loc13_:b2Vec2 = null;
            var _loc14_:Number = NaN;
            var _loc15_:Number = NaN;
            var _loc16_:Number = NaN;
            var _loc17_:Number = NaN;
            var _loc18_:b2Vec2 = null;
            var _loc19_:b2Vec2 = null;
            var _loc20_:Number = NaN;
            var _loc21_:b2Vec2 = null;
            var _loc22_:Number = NaN;
            this.polyState = P_NORMAL;
            this.nextPos = new b2Vec2(Math.round(this.currentShape.mouseX),Math.round(this.currentShape.mouseY));
            if(this.shiftPressed)
            {
                this.nextPos.x = Math.round(this.nextPos.x * 0.1) * 10;
                this.nextPos.y = Math.round(this.nextPos.y * 0.1) * 10;
            }
            var _loc2_:int = this.currentShape.numVerts;
            if(_loc2_ > 1)
            {
                _loc3_ = this.currentShape.getVertAt(0);
                _loc4_ = this.currentShape.getVertAt(1);
                _loc5_ = this.currentShape.getVertAt(_loc2_ - 2);
                _loc6_ = this.currentShape.getVertAt(_loc2_ - 1);
                _loc7_ = new b2Vec2(_loc6_.x - _loc5_.x,_loc6_.y - _loc5_.y);
                _loc8_ = new b2Vec2(_loc3_.x - _loc6_.x,_loc3_.y - _loc6_.y);
                _loc9_ = new b2Vec2(this.nextPos.x - _loc6_.x,this.nextPos.y - _loc6_.y);
                _loc10_ = _loc7_.Copy();
                _loc11_ = _loc8_.Copy();
                _loc10_.Normalize();
                _loc11_.Normalize();
                _loc12_ = new b2Vec2(_loc10_.y,-_loc10_.x);
                _loc13_ = new b2Vec2(-_loc11_.y,_loc11_.x);
                _loc14_ = b2Math.b2Dot(_loc9_,_loc10_);
                _loc15_ = b2Math.b2Dot(_loc9_,_loc11_);
                _loc16_ = b2Math.b2Dot(_loc9_,_loc12_);
                _loc17_ = b2Math.b2Dot(_loc9_,_loc13_);
                if(_loc14_ < 0 && _loc15_ < 0)
                {
                    this.nextPos.Set(_loc6_.x,_loc6_.y);
                    this.polyState = P_DONT_UPDATE;
                }
                else if(_loc14_ >= 0 && _loc16_ > 0)
                {
                    _loc18_ = _loc10_.Copy();
                    _loc18_.Multiply(_loc14_);
                    this.nextPos.Set(Math.round(_loc6_.x + _loc18_.x),Math.round(_loc6_.y + _loc18_.y));
                    this.polyState = P_REPLACE_PREV;
                }
                else if(_loc15_ >= 0 && _loc17_ > 0)
                {
                    this.nextPos.Set(_loc3_.x,_loc3_.y);
                    this.polyState = P_COMPLETE;
                }
                else if(_loc2_ == MAX_VERTS)
                {
                    this.nextPos.Set(_loc3_.x,_loc3_.y);
                    this.polyState = P_COMPLETE;
                }
                if(this.polyState != P_COMPLETE && this.polyState != P_DONT_UPDATE)
                {
                    _loc19_ = new b2Vec2(this.nextPos.x - _loc6_.x,this.nextPos.y - _loc6_.y);
                    _loc20_ = _loc19_.Length();
                    if(_loc20_ == 0)
                    {
                        this.polyState = P_DONT_UPDATE;
                    }
                    else if(_loc20_ < MIN_SHAPE_LINE_DISTANCE)
                    {
                        this.nextPos.Set(_loc6_.x,_loc6_.y);
                        this.polyState = P_DONT_UPDATE;
                    }
                    _loc21_ = new b2Vec2(_loc3_.x - this.nextPos.x,_loc3_.y - this.nextPos.y);
                    _loc20_ = _loc21_.Length();
                    if(_loc20_ < SNAP_DISTANCE * Math.pow(2,-Editor.currentZoom))
                    {
                        this.nextPos.Set(_loc3_.x,_loc3_.y);
                        this.polyState = P_COMPLETE;
                    }
                    else if(_loc2_ > 2)
                    {
                        _loc7_ = new b2Vec2(_loc3_.x - _loc4_.x,_loc3_.y - _loc4_.y);
                        _loc8_ = new b2Vec2(this.nextPos.x - _loc3_.x,this.nextPos.y - _loc3_.y);
                        _loc10_ = _loc7_.Copy();
                        _loc11_ = _loc8_.Copy();
                        _loc10_.Normalize();
                        _loc11_.Normalize();
                        _loc13_ = new b2Vec2(-_loc10_.y,_loc10_.x);
                        _loc22_ = b2Math.b2Dot(_loc8_,_loc13_);
                        if(_loc22_ > 0)
                        {
                            this.nextPos.Set(_loc3_.x,_loc3_.y);
                            this.polyState = P_COMPLETE;
                        }
                    }
                }
                if(_loc2_ == 2 && this.polyState == P_COMPLETE)
                {
                    this.nextPos.Set(_loc6_.x,_loc6_.y);
                    this.polyState = P_DONT_UPDATE;
                }
            }
            else
            {
                _loc3_ = this.currentShape.getVertAt(0);
                if(_loc3_)
                {
                    _loc19_ = new b2Vec2(this.nextPos.x - _loc3_.x,this.nextPos.y - _loc3_.y);
                    _loc20_ = _loc19_.Length();
                    if(_loc20_ == 0)
                    {
                        this.polyState = P_DONT_UPDATE;
                    }
                    else if(_loc20_ < MIN_SHAPE_LINE_DISTANCE)
                    {
                        _loc19_.Normalize();
                        _loc19_.Multiply(MIN_SHAPE_LINE_DISTANCE);
                        this.nextPos.Set(Math.round(_loc3_.x + _loc19_.x),Math.round(_loc3_.y + _loc19_.y));
                    }
                }
            }
            this.currentShape.drawEditMode(this.nextPos,this.polyState == P_COMPLETE,true);
        }
        
        protected function mouseDownHandler(param1:MouseEvent) : void
        {
            var _loc2_:Sprite = null;
            if(param1.target is Sprite)
            {
                _loc2_ = param1.target as Sprite;
                if(_canvas.contains(_loc2_))
                {
                    this.setVertex();
                    this.updateRemainingVerts();
                }
            }
        }
        
        protected function keyDownHandler(param1:KeyboardEvent) : void
        {
            switch(param1.keyCode)
            {
                case 8:
                    if(!(param1.target is TextField))
                    {
                        this.deletePreviousVertex();
                    }
                    break;
                case 13:
                    if(!(param1.target is TextField))
                    {
                        if(this.currentShape.numVerts < 3)
                        {
                            Settings.debugText.show("polygons must have at least 3 points");
                        }
                        else
                        {
                            this.currentShape.completeFill = true;
                            this.completeShape();
                        }
                    }
                    break;
                case 16:
                    this.shiftPressed = true;
                    break;
                case 17:
                    this.ctrlPressed = true;
            }
        }
        
        protected function keyUpHandler(param1:KeyboardEvent) : void
        {
            switch(param1.keyCode)
            {
                case 16:
                    this.shiftPressed = false;
                    break;
                case 17:
                    this.ctrlPressed = false;
            }
        }
        
        protected function mouseMoveHandler(param1:MouseEvent) : void
        {
            var _loc2_:Sprite = null;
            var _loc3_:DisplayObject = null;
            if(param1.target is Sprite)
            {
                _loc2_ = param1.target as Sprite;
                if(_canvas.contains(_loc2_))
                {
                    if(this.cursorSprite.visible == false)
                    {
                        this.cursorSprite.visible = true;
                        Mouse.hide();
                    }
                    _loc3_ = _canvas.parent.parent;
                    this.cursorSprite.x = _loc3_.mouseX;
                    this.cursorSprite.y = _loc3_.mouseY;
                    if(this.shiftPressed)
                    {
                    }
                }
                else if(this.cursorSprite.visible == true)
                {
                    this.cursorSprite.visible = false;
                    Mouse.show();
                }
            }
            else if(this.cursorSprite.visible == true)
            {
                this.cursorSprite.visible = false;
                Mouse.show();
            }
        }
        
        protected function setVertex() : void
        {
            var _loc1_:Vert = null;
            var _loc2_:ActionAddVert = null;
            var _loc3_:Action = null;
            if(this.currentShape.numVerts < 1)
            {
                stage.addEventListener(Event.ENTER_FRAME,this.frameHandler);
                this.currentShape.xUnbound = Math.round(_canvas.mouseX);
                this.currentShape.yUnbound = Math.round(_canvas.mouseY);
                _loc1_ = new Vert();
                this.currentShape.addVert(_loc1_);
                _loc1_.edgeShape = this.currentShape;
                _loc1_.selected = true;
                this.currentShape.vID = idCounter;
                _loc2_ = new ActionAddVert(this.currentShape.numVerts - 1,this.currentShape,this);
                dispatchEvent(new ActionEvent(ActionEvent.GENERIC,_loc2_));
            }
            else
            {
                switch(this.polyState)
                {
                    case P_NORMAL:
                        _loc1_ = this.currentShape.getVertAt(this.currentShape.numVerts - 1);
                        if(!(_loc1_.x == this.nextPos.x && _loc1_.y == this.nextPos.y))
                        {
                            _loc1_.selected = false;
                            _loc1_ = new Vert(this.nextPos.x,this.nextPos.y);
                            this.currentShape.addVert(_loc1_);
                            _loc1_.edgeShape = this.currentShape;
                            _loc1_.selected = true;
                            _loc2_ = new ActionAddVert(this.currentShape.numVerts - 1,this.currentShape,this);
                            dispatchEvent(new ActionEvent(ActionEvent.GENERIC,_loc2_));
                        }
                        break;
                    case P_COMPLETE:
                        if(this.checkVertsConvex())
                        {
                            this.currentShape.completeFill = true;
                            this.completeShape();
                        }
                        break;
                    case P_DONT_UPDATE:
                        break;
                    case P_REPLACE_PREV:
                        _loc1_ = this.currentShape.getVertAt(this.currentShape.numVerts - 1);
                        _loc1_.selected = false;
                        _loc3_ = new ActionDeleteVert(this.currentShape.numVerts - 1,this.currentShape,this);
                        this.currentShape.removeVert();
                        _loc1_ = new Vert(this.nextPos.x,this.nextPos.y);
                        this.currentShape.addVert(_loc1_);
                        _loc1_.edgeShape = this.currentShape;
                        _loc1_.selected = true;
                        _loc2_ = new ActionAddVert(this.currentShape.numVerts - 1,this.currentShape,this);
                        _loc3_.nextAction = _loc2_;
                        dispatchEvent(new ActionEvent(ActionEvent.GENERIC,_loc2_));
                }
            }
        }
        
        protected function deletePreviousVertex() : void
        {
            var _loc2_:ActionDeleteVert = null;
            var _loc3_:Vert = null;
            var _loc1_:int = this.currentShape.numVerts;
            if(_loc1_ > 0)
            {
                _loc2_ = new ActionDeleteVert(_loc1_ - 1,this.currentShape,this);
                this.currentShape.removeVert();
                if(this.currentShape.numVerts == 0)
                {
                    stage.removeEventListener(Event.ENTER_FRAME,this.frameHandler);
                    this.currentShape.graphics.clear();
                }
                else
                {
                    _loc3_ = this.currentShape.getVertAt(this.currentShape.numVerts - 1);
                    _loc3_.selected = true;
                }
                if(_loc2_)
                {
                    dispatchEvent(new ActionEvent(ActionEvent.GENERIC,_loc2_));
                }
            }
        }
        
        override public function addFrameHandler() : void
        {
            stage.addEventListener(Event.ENTER_FRAME,this.frameHandler);
        }
        
        override public function removeFrameHandler() : void
        {
            stage.removeEventListener(Event.ENTER_FRAME,this.frameHandler);
        }
        
        override public function setCurrentShape(param1:RefShape) : void
        {
            if(this.currentShape)
            {
                if(this.currentShape.parent)
                {
                    this.currentShape.parent.removeChild(this.currentShape);
                }
            }
            this.currentShape = param1 as PolygonShape;
            this.currentShape.completeFill = false;
            this.currentShape.editMode = true;
            this.currentShape.mouseEnabled = false;
            _canvas.parent.addChild(this.currentShape);
            if(this.currentShape.numVerts > 0)
            {
                stage.addEventListener(Event.ENTER_FRAME,this.frameHandler);
            }
        }
        
        protected function completeShape() : void
        {
            this.polyState = 0;
            stage.removeEventListener(Event.ENTER_FRAME,this.frameHandler);
            this.currentShape.recenter();
            this.currentShape.editMode = false;
            this.currentShape.mouseEnabled = true;
            _canvas.addRefSprite(this.currentShape);
            var _loc1_:PolygonShape = new PolygonShape(this.currentShape.interactive,this.currentShape.immovable,this.currentShape.sleeping,this.currentShape.density,this.currentShape.color,this.currentShape.outlineColor,this.currentShape.opacity,this.currentShape.collision);
            _loc1_.editMode = true;
            _loc1_.mouseEnabled = false;
            _canvas.parent.addChild(_loc1_);
            var _loc2_:ActionCompleteShape = new ActionCompleteShape(this.currentShape,_loc1_,this);
            var _loc3_:Action = new ActionAdd(this.currentShape,_canvas,_canvas.shapes.getChildIndex(this.currentShape));
            _loc2_.nextAction = _loc3_;
            dispatchEvent(new ActionEvent(ActionEvent.GENERIC,_loc3_));
            this.currentShape = _loc1_;
        }
        
        protected function checkVertsConvex() : Boolean
        {
            var _loc3_:Vert = null;
            var _loc4_:int = 0;
            var _loc5_:Vert = null;
            var _loc6_:Vert = null;
            var _loc7_:b2Vec2 = null;
            var _loc8_:b2Vec2 = null;
            var _loc9_:b2Vec2 = null;
            var _loc10_:Number = NaN;
            var _loc1_:int = this.currentShape.numVerts;
            if(_loc1_ < 3)
            {
                return false;
            }
            var _loc2_:int = 0;
            while(_loc2_ < _loc1_)
            {
                _loc3_ = this.currentShape.getVertAt(_loc2_);
                _loc4_ = _loc2_ + 1;
                if(_loc4_ > _loc1_ - 1)
                {
                    _loc4_ -= _loc1_;
                }
                _loc5_ = this.currentShape.getVertAt(_loc4_);
                _loc4_ = _loc2_ + 2;
                if(_loc4_ > _loc1_ - 1)
                {
                    _loc4_ -= _loc1_;
                }
                _loc6_ = this.currentShape.getVertAt(_loc4_);
                _loc7_ = new b2Vec2(_loc5_.x - _loc3_.x,_loc5_.y - _loc3_.y);
                _loc8_ = new b2Vec2(_loc6_.x - _loc5_.x,_loc6_.y - _loc5_.y);
                _loc7_.Normalize();
                _loc8_.Normalize();
                _loc9_ = new b2Vec2(_loc7_.y,-_loc7_.x);
                _loc10_ = b2Math.b2Dot(_loc8_,_loc9_);
                if(_loc10_ > 0)
                {
                    return false;
                }
                _loc2_++;
            }
            return true;
        }
        
        protected function updateRemainingVerts() : void
        {
            var _loc1_:int = this.currentShape.numVerts;
            var _loc2_:int = MAX_VERTS - _loc1_;
            this.remainingVertsInput.setValue("" + _loc2_);
        }
        
        protected function updateTextFields() : void
        {
            this.updateRemainingVerts();
            this.densityInput.text = "" + this.currentShape.density;
            this.immovableCheck.setValue(this.currentShape.immovable);
            this.asleepCheck.setValue(this.currentShape.sleeping);
            this.densityInput.setValue(this.currentShape.density);
            this.colorInput.setValue(this.currentShape.color);
            this.outlineColorInput.setValue(this.currentShape.outlineColor);
            this.opacityInput.setValue(this.currentShape.opacity);
            this.collisionInput.setValue(this.currentShape.collision);
        }
        
        protected function inputValueChange(param1:ValueEvent) : void
        {
            trace("INPUT VALUE CHANGE");
            var _loc2_:InputObject = param1.inputObject;
            var _loc3_:String = _loc2_.attribute;
            trace("property " + _loc3_);
            trace(param1.value);
            this.currentShape[_loc3_] = param1.value;
            this.updateTextFields();
        }
        
        override public function resizeElements() : void
        {
            var _loc3_:Vert = null;
            var _loc1_:int = this.currentShape.numVerts;
            var _loc2_:int = 0;
            while(_loc2_ < _loc1_)
            {
                _loc3_ = this.currentShape.getVertAt(_loc2_);
                _loc3_.selected = _loc3_.selected;
                _loc2_++;
            }
        }
        
        override public function die() : void
        {
            super.die();
            this.immovableCheck.removeEventListener(ValueEvent.VALUE_CHANGE,this.inputValueChange);
            this.colorInput.removeEventListener(ValueEvent.VALUE_CHANGE,this.inputValueChange);
            this.outlineColorInput.removeEventListener(ValueEvent.VALUE_CHANGE,this.inputValueChange);
            this.opacityInput.removeEventListener(ValueEvent.VALUE_CHANGE,this.inputValueChange);
            this.collisionInput.removeEventListener(ValueEvent.VALUE_CHANGE,this.inputValueChange);
            this.immovableCheck.die();
            this.colorInput.die();
            this.outlineColorInput.die();
            this.opacityInput.die();
        }
    }
}

