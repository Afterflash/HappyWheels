package com.totaljerkface.game.editor
{
    import com.totaljerkface.game.editor.actions.*;
    import com.totaljerkface.game.editor.ui.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.utils.*;
    
    public class ShapeTool extends Tool
    {
        private static const RECTANGLE:String = "rectangle";
        
        private static const CIRCLE:String = "circle";
        
        private static const TRIANGLE:String = "triangle";
        
        protected var rectButton:GenericButton;
        
        protected var circleButton:GenericButton;
        
        protected var triButton:GenericButton;
        
        protected var _selectedButton:GenericButton;
        
        protected var widthInput:TextInput;
        
        protected var heightInput:TextInput;
        
        protected var rotationInput:TextInput;
        
        protected var densityInput:TextInput;
        
        protected var colorInput:ColorInput;
        
        protected var outlineColorInput:ColorInput;
        
        protected var opacityInput:SliderInput;
        
        protected var innerCutoutInput:SliderInput;
        
        protected var collisionInput:SliderInput;
        
        protected var inputs:Array;
        
        protected var interactiveCheck:CheckBox;
        
        protected var immovableCheck:CheckBox;
        
        protected var asleepCheck:CheckBox;
        
        protected var minDimension:Number = 0.1;
        
        protected var maxDimension:Number = 50;
        
        protected var cursorShape:RefShape;
        
        protected var currentDensity:Number = 1;
        
        protected var _innerCutout:int = 0;
        
        protected var maxDensity:Number = 100;
        
        protected var minDensity:Number = 0.1;
        
        private var currentShape:String;
        
        private var lastRectangle:RectangleShape;
        
        private var lastCircle:CircleShape;
        
        private var lastTriangle:TriangleShape;
        
        private const helpMessage:String = "<u><b>Shape Tool Help:</b></u><br><br>The shape tool works like a stamp and allows you to create new shapes on stage.  Select the type and parameters of the shape you\'d like before placing.<br><br><u>Keyboard Shortcuts:</u><br><br><b>a,w,s,d</b>: Resize the height and width of the current shape.  Hold <b>shift</b> to resize faster.<br><br><b>z,x</b>: Rotate the current shape.  Hold <b>shift</b> to rotate faster.";
        
        public function ShapeTool(param1:Editor, param2:Canvas)
        {
            super(param1,param2);
            this.init();
        }
        
        protected function init() : void
        {
            var _loc4_:Number = 0;
            var _loc5_:Number = NaN;
            this.currentShape = RECTANGLE;
            this.createCursor();
            var _loc1_:int = 0;
            var _loc2_:int = 0;
            var _loc3_:int = 5;
            _loc4_ = 16613761;
            _loc5_ = 120;
            this.rectButton = new GenericButton("Rectangle Shape",_loc4_,_loc5_);
            this.rectButton.x = _loc3_;
            this.rectButton.y = _loc3_;
            addChild(this.rectButton);
            this.circleButton = new GenericButton("Circle Shape",_loc4_,_loc5_);
            addChild(this.circleButton);
            this.circleButton.x = _loc3_;
            this.circleButton.y = this.rectButton.y + this.rectButton.height + 5;
            this.triButton = new GenericButton("Triangle Shape",_loc4_,_loc5_);
            addChild(this.triButton);
            this.triButton.x = _loc3_;
            this.triButton.y = this.circleButton.y + this.circleButton.height + 5;
            this.widthInput = new TextInput("width","shapeWidth",7,true);
            this.widthInput.restrict = "0-9.";
            addChild(this.widthInput);
            this.widthInput.x = _loc3_;
            this.widthInput.y = this.triButton.y + this.triButton.height + 5;
            this.heightInput = new TextInput("height","shapeHeight",7,true);
            this.heightInput.restrict = "0-9.";
            this.heightInput.x = _loc3_;
            this.heightInput.y = this.widthInput.y + Math.ceil(this.widthInput.height);
            addChild(this.heightInput);
            this.rotationInput = new TextInput("rotation","angle",5,true);
            this.rotationInput.restrict = "0-9\\-";
            this.rotationInput.x = _loc3_;
            this.rotationInput.y = this.heightInput.y + Math.ceil(this.heightInput.height);
            addChild(this.rotationInput);
            this.colorInput = new ColorInput("shape color","color",true,true);
            this.colorInput.x = _loc3_;
            this.colorInput.y = this.rotationInput.y + Math.ceil(this.rotationInput.height);
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
            this.interactiveCheck = new CheckBox("interactive","interactive");
            this.interactiveCheck.y = this.opacityInput.y + Math.ceil(this.opacityInput.height);
            this.interactiveCheck.x = _loc3_;
            this.interactiveCheck.helpCaption = "Setting interactive to false will treat the shape like flat artwork.  The shape will only move if part of a group, and will not take away from the total available shapecount allowed in your level.  Useful when just adding visual detail to already interactive larger shapes or groups.";
            addChild(this.interactiveCheck);
            this.immovableCheck = new CheckBox("fixed","immovable",true,true,true);
            this.immovableCheck.y = this.interactiveCheck.y + Math.ceil(this.interactiveCheck.height);
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
            this.innerCutoutInput = new SliderInput("inner cutout","innerCutout",3,true,0,100,100);
            this.innerCutoutInput.restrict = "0-9";
            this.innerCutoutInput.helpCaption = "";
            this.innerCutoutInput.x = _loc3_;
            this.innerCutoutInput.y = this.collisionInput.y + Math.ceil(this.collisionInput.height);
            this.rectButton.addEventListener(MouseEvent.MOUSE_UP,this.shapeChosen);
            this.circleButton.addEventListener(MouseEvent.MOUSE_UP,this.shapeChosen);
            this.triButton.addEventListener(MouseEvent.MOUSE_UP,this.shapeChosen);
            this.widthInput.addEventListener(ValueEvent.VALUE_CHANGE,this.inputValueChange);
            this.heightInput.addEventListener(ValueEvent.VALUE_CHANGE,this.inputValueChange);
            this.rotationInput.addEventListener(ValueEvent.VALUE_CHANGE,this.inputValueChange);
            this.immovableCheck.addEventListener(ValueEvent.VALUE_CHANGE,this.inputValueChange);
            this.colorInput.addEventListener(ValueEvent.VALUE_CHANGE,this.inputValueChange);
            this.outlineColorInput.addEventListener(ValueEvent.VALUE_CHANGE,this.inputValueChange);
            this.opacityInput.addEventListener(ValueEvent.VALUE_CHANGE,this.inputValueChange);
            this.innerCutoutInput.addEventListener(ValueEvent.VALUE_CHANGE,this.inputValueChange);
            this.collisionInput.addEventListener(ValueEvent.VALUE_CHANGE,this.inputValueChange);
            this.interactiveCheck.addEventListener(ValueEvent.VALUE_CHANGE,this.interactiveChange);
            this._selectedButton = this.rectButton;
            this.rectButton.selected = true;
            this.updateTextFields();
        }
        
        protected function createCursor() : void
        {
            if(this.cursorShape)
            {
                _canvas.removeChild(this.cursorShape);
            }
            switch(this.currentShape)
            {
                case RECTANGLE:
                    if(this.lastRectangle)
                    {
                        this.cursorShape = this.lastRectangle.clone() as RefShape;
                    }
                    else
                    {
                        this.cursorShape = new RectangleShape(true);
                        this.cursorShape.shapeWidth = 300;
                        this.cursorShape.shapeHeight = 100;
                    }
                    break;
                case CIRCLE:
                    if(this.lastCircle)
                    {
                        this.cursorShape = this.lastCircle.clone() as RefShape;
                    }
                    else
                    {
                        this.cursorShape = new CircleShape(true);
                        this.cursorShape.shapeWidth = 200;
                        this.cursorShape.shapeHeight = 200;
                    }
                    break;
                case TRIANGLE:
                    if(this.lastTriangle)
                    {
                        this.cursorShape = this.lastTriangle.clone() as RefShape;
                    }
                    else
                    {
                        this.cursorShape = new TriangleShape(true);
                        this.cursorShape.shapeWidth = 200;
                        this.cursorShape.shapeHeight = 200;
                    }
                    break;
                default:
                    throw Error("not a cursor type");
            }
            this.cursorShape.blendMode = BlendMode.INVERT;
        }
        
        override public function activate() : void
        {
            super.activate();
            HelpWindow.instance.populate(this.helpMessage);
            window.setDimensions(130,this.height + 5);
            _canvas.addChild(this.cursorShape);
            stage.addEventListener(Event.ENTER_FRAME,this.mouseMoveHandler);
            stage.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
            stage.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
        }
        
        override public function deactivate() : void
        {
            _canvas.removeChild(this.cursorShape);
            this.colorInput.closeColorSelector();
            this.outlineColorInput.closeColorSelector();
            stage.removeEventListener(Event.ENTER_FRAME,this.mouseMoveHandler);
            stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
            stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
            super.deactivate();
        }
        
        protected function mouseMoveHandler(param1:Event) : void
        {
            this.cursorShape.x = _canvas.mouseX;
            this.cursorShape.y = _canvas.mouseY;
        }
        
        protected function mouseDownHandler(param1:MouseEvent) : void
        {
            var _loc2_:Sprite = null;
            if(param1.target is Sprite)
            {
                _loc2_ = param1.target as Sprite;
                if(_canvas.contains(_loc2_))
                {
                    this.createNewShape();
                }
            }
        }
        
        protected function createNewShape() : void
        {
            _canvas.addRefSprite(this.cursorShape);
            this.cursorShape.blendMode = BlendMode.NORMAL;
            var _loc1_:Action = new ActionAdd(this.cursorShape,_canvas,_canvas.shapes.getChildIndex(this.cursorShape));
            dispatchEvent(new ActionEvent(ActionEvent.GENERIC,_loc1_));
            this.cursorShape = this.cursorShape.clone() as RefShape;
            this.cursorShape.blendMode = BlendMode.INVERT;
            _canvas.addChild(this.cursorShape);
        }
        
        protected function keyDownHandler(param1:KeyboardEvent) : void
        {
            if(param1.target is TextField)
            {
                return;
            }
            switch(param1.keyCode)
            {
                case 65:
                    this.adjustScale(-1,0,param1.shiftKey);
                    break;
                case 87:
                    this.adjustScale(0,1,param1.shiftKey);
                    break;
                case 68:
                    this.adjustScale(1,0,param1.shiftKey);
                    break;
                case 83:
                    this.adjustScale(0,-1,param1.shiftKey);
                    break;
                case 90:
                    if(!param1.ctrlKey)
                    {
                        this.adjustRotation(-1,param1.shiftKey);
                    }
                    break;
                case 88:
                    this.adjustRotation(1,param1.shiftKey);
            }
        }
        
        protected function adjustScale(param1:Number, param2:Number, param3:Boolean) : void
        {
            if(param3)
            {
                param1 *= 10;
                param2 *= 10;
            }
            this.cursorShape.shapeWidth += param1;
            this.cursorShape.shapeHeight += param2;
            this.updateTextFields();
        }
        
        protected function updateTextFields() : void
        {
            this.widthInput.text = "" + this.cursorShape.shapeWidth;
            this.heightInput.text = "" + this.cursorShape.shapeHeight;
            this.rotationInput.text = "" + this.cursorShape.angle;
            this.densityInput.text = "" + this.cursorShape.density;
            this.interactiveCheck.setValue(this.cursorShape.interactive);
            this.immovableCheck.setValue(this.cursorShape.immovable);
            this.asleepCheck.setValue(this.cursorShape.sleeping);
            this.densityInput.setValue(this.cursorShape.density);
            this.colorInput.setValue(this.cursorShape.color);
            this.outlineColorInput.setValue(this.cursorShape.outlineColor);
            this.opacityInput.setValue(this.cursorShape.opacity);
            this.collisionInput.setValue(this.cursorShape.collision);
        }
        
        protected function adjustRotation(param1:Number, param2:Boolean) : void
        {
            if(param2)
            {
                param1 *= 10;
            }
            this.cursorShape.angle += param1;
            this.rotationInput.text = "" + this.cursorShape.angle;
        }
        
        protected function shapeChosen(param1:MouseEvent) : void
        {
            var _loc2_:GenericButton = param1.target as GenericButton;
            this.selectedButton = _loc2_;
        }
        
        protected function get selectedButton() : GenericButton
        {
            return this._selectedButton;
        }
        
        public function get innerCutout() : int
        {
            return this._innerCutout;
        }
        
        public function set innerCutout(param1:int) : void
        {
            if(param1 < 0)
            {
                param1 = 0;
            }
            if(param1 > 100)
            {
                param1 = 100;
            }
            this._innerCutout = param1;
        }
        
        protected function set selectedButton(param1:GenericButton) : void
        {
            if(param1 == this._selectedButton)
            {
                return;
            }
            this._selectedButton.selected = false;
            this._selectedButton = param1;
            this._selectedButton.selected = true;
            if(contains(this.innerCutoutInput))
            {
                removeChild(this.innerCutoutInput);
            }
            switch(this._selectedButton)
            {
                case this.rectButton:
                    this.currentShape = RECTANGLE;
                    break;
                case this.circleButton:
                    addChild(this.innerCutoutInput);
                    this.currentShape = CIRCLE;
                    break;
                case this.triButton:
                    this.currentShape = TRIANGLE;
            }
            if(this.cursorShape is RectangleShape)
            {
                this.lastRectangle = this.cursorShape.clone() as RectangleShape;
            }
            else if(this.cursorShape is CircleShape)
            {
                this.lastCircle = this.cursorShape.clone() as CircleShape;
            }
            else if(this.cursorShape is TriangleShape)
            {
                this.lastTriangle = this.cursorShape.clone() as TriangleShape;
            }
            this.createCursor();
            _canvas.addChild(this.cursorShape);
            this.updateTextFields();
            window.setDimensions(130,this.height + 5);
        }
        
        protected function inputValueChange(param1:ValueEvent) : void
        {
            trace("INPUT VALUE CHANGE");
            var _loc2_:InputObject = param1.inputObject;
            var _loc3_:String = _loc2_.attribute;
            trace("property " + _loc3_);
            trace(param1.value);
            this.cursorShape[_loc3_] = param1.value;
            if(param1.resetInputs)
            {
                this.updateTextFields();
            }
        }
        
        protected function interactiveChange(param1:ValueEvent) : void
        {
            this.cursorShape.interactive = param1.value;
            if(this.cursorShape.interactive)
            {
                addChild(this.immovableCheck);
                addChild(this.asleepCheck);
                addChild(this.densityInput);
                addChild(this.collisionInput);
            }
            else
            {
                removeChild(this.immovableCheck);
                removeChild(this.asleepCheck);
                removeChild(this.densityInput);
                removeChild(this.collisionInput);
            }
            window.setDimensions(130,this.height + 5);
            this.updateTextFields();
        }
        
        override public function die() : void
        {
            super.die();
            this.rectButton.removeEventListener(MouseEvent.MOUSE_UP,this.shapeChosen);
            this.circleButton.removeEventListener(MouseEvent.MOUSE_UP,this.shapeChosen);
            this.triButton.removeEventListener(MouseEvent.MOUSE_UP,this.shapeChosen);
            this.widthInput.removeEventListener(ValueEvent.VALUE_CHANGE,this.inputValueChange);
            this.heightInput.removeEventListener(ValueEvent.VALUE_CHANGE,this.inputValueChange);
            this.rotationInput.removeEventListener(ValueEvent.VALUE_CHANGE,this.inputValueChange);
            this.immovableCheck.removeEventListener(ValueEvent.VALUE_CHANGE,this.inputValueChange);
            this.colorInput.removeEventListener(ValueEvent.VALUE_CHANGE,this.inputValueChange);
            this.outlineColorInput.removeEventListener(ValueEvent.VALUE_CHANGE,this.inputValueChange);
            this.opacityInput.removeEventListener(ValueEvent.VALUE_CHANGE,this.inputValueChange);
            this.innerCutoutInput.removeEventListener(ValueEvent.VALUE_CHANGE,this.inputValueChange);
            this.collisionInput.removeEventListener(ValueEvent.VALUE_CHANGE,this.inputValueChange);
            this.interactiveCheck.removeEventListener(ValueEvent.VALUE_CHANGE,this.interactiveChange);
            this.widthInput.die();
            this.heightInput.die();
            this.rotationInput.die();
            this.interactiveCheck.die();
            this.immovableCheck.die();
            this.colorInput.die();
            this.outlineColorInput.die();
            this.opacityInput.die();
        }
    }
}

