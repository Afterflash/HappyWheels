package com.totaljerkface.game.editor
{
    import com.totaljerkface.game.editor.actions.*;
    import com.totaljerkface.game.editor.ui.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.Point;
    
    public class JointTool extends Tool
    {
        private static const PIN:String = "pin";
        
        private static const SLIDE:String = "slide";
        
        protected var pinButton:GenericButton;
        
        protected var slideButton:GenericButton;
        
        protected var snapRange:Number = 10;
        
        protected var currentJoint:String;
        
        protected var selectedButton:GenericButton;
        
        protected var cursorShape:RefJoint;
        
        private var inputs:Array;
        
        private const windowWidth:int = 130;
        
        private const indent:int = 5;
        
        private var menuPosX:Number = 700;
        
        private var menuPosY:Number = 200;
        
        private var lastPin:PinJoint;
        
        private var lastSlide:PrisJoint;
        
        private const helpMessage:String = "<u><b>Joint Tool Help:</b></u><br><br>The joint tool can be used to create different types of joints.  A joint is used to hold two joinable objects together.  Currently, you can create pin and sliding joints.<br><br><u>Pin Joint:</u><br><br>Place a pin joint by clicking the cursor on one or two overlapping joinable objects (such as two non-fixed rectangle shapes).  If only one object is used, the joint will be made between the object and the background itself.<br><br>A pin joint forces 2 bodies to rotate around the specified anchor point.  A good real life example would be a wheel on a car.  The wheel is one body, the car is the other, and the anchor point is the axle where the wheel is connected.<br><br>You can set a limit for the pin joint, so that the angle between the two bodies cannot leave a certain range.<br><br>You can also enable a motor for each joint.  The motor allows you to rotate the pin joint automatically.  You can use this to automate wheels or rotating platforms.  I\'ve given the user a lot of freedom in the possible motor values, so there\'s a large potential for some cool creations as well as some horrible failures.<br><br><u>Sliding Joint:</u><br><br>A sliding joint is created similarly to the pin joint. Sliding joints constrain bodies to a single axis along the plane of the screen. If only one body is used, that body is constrained to the non-moving background. An example of this would be an elevator moving through floors of a static building. If two bodies are used, both bodies can move freely, but relative to each other they are constrained to their local axis. An example of this would be a forklift. The frame is one body, and the lifting fork is the other.<br><br>Limits will constrain the range of this axis. Motors will allow the bodies to move along the axis within the given limits at a chosen speed. The closer the body is to the anchor of the joint, which is where you place the actual joint, the better the joint will function. Bodies very far from the anchor will have a tougher time sticking to the axis, and the lighter the body, the easier it will be to push it off of the axis.";
        
        public function JointTool(param1:Editor, param2:Canvas)
        {
            super(param1,param2);
            this.init();
        }
        
        protected function init() : void
        {
            this.currentJoint = PIN;
            var _loc1_:int = 0;
            var _loc2_:int = 0;
            var _loc3_:int = 5;
            var _loc4_:Number = 16613761;
            var _loc5_:Number = 120;
            this.pinButton = new GenericButton("Pin Joint",_loc4_,_loc5_);
            this.pinButton.x = _loc3_;
            this.pinButton.y = _loc3_;
            addChild(this.pinButton);
            this.slideButton = new GenericButton("Sliding Joint",_loc4_,_loc5_);
            addChild(this.slideButton);
            this.slideButton.x = _loc3_;
            this.slideButton.y = this.pinButton.y + this.slideButton.height + 5;
            this.inputs = new Array();
            this.populate(PIN);
            this.selectedButton = this.pinButton;
            this.selectedButton.selected = true;
            this.pinButton.addEventListener(MouseEvent.MOUSE_UP,this.jointChosen);
            this.slideButton.addEventListener(MouseEvent.MOUSE_UP,this.jointChosen);
        }
        
        override public function activate() : void
        {
            super.activate();
            HelpWindow.instance.populate(this.helpMessage);
            window.setDimensions(this.windowWidth,this.height + 5);
            _canvas.addChild(this.cursorShape);
            stage.addEventListener(Event.ENTER_FRAME,this.mouseMoveHandler);
            stage.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
            stage.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
        }
        
        override public function deactivate() : void
        {
            _canvas.removeChild(this.cursorShape);
            stage.removeEventListener(Event.ENTER_FRAME,this.mouseMoveHandler);
            stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
            stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
            super.deactivate();
        }
        
        protected function mouseMoveHandler(param1:Event = null) : void
        {
            var _loc2_:RefShape = null;
            var _loc3_:Number = NaN;
            var _loc4_:Number = NaN;
            this.cursorShape.x = _canvas.mouseX;
            this.cursorShape.y = _canvas.mouseY;
            if(param1.target is RefShape)
            {
                _loc2_ = param1.target as RefShape;
                if(!_loc2_.immovable)
                {
                    _loc3_ = Math.abs(_loc2_.x - this.cursorShape.x);
                    _loc4_ = Math.abs(_loc2_.y - this.cursorShape.y);
                    if(_loc3_ < this.snapRange && _loc4_ < this.snapRange)
                    {
                        this.cursorShape.x = _loc2_.x;
                        this.cursorShape.y = _loc2_.y;
                    }
                }
            }
        }
        
        protected function mouseDownHandler(param1:MouseEvent) : void
        {
            var _loc2_:Sprite = null;
            if(param1.target is Sprite)
            {
                _loc2_ = param1.target as Sprite;
                if(_canvas.contains(_loc2_))
                {
                    this.createNewJoint();
                }
            }
        }
        
        protected function keyDownHandler(param1:KeyboardEvent) : void
        {
        }
        
        protected function jointChosen(param1:Event) : void
        {
            var _loc2_:GenericButton = param1.target as GenericButton;
            if(_loc2_ == this.selectedButton)
            {
                return;
            }
            this.selectedButton.selected = false;
            this.selectedButton = _loc2_;
            this.selectedButton.selected = true;
            if(this.cursorShape is PinJoint)
            {
                this.lastPin = this.cursorShape.clone() as PinJoint;
            }
            else if(this.cursorShape is PrisJoint)
            {
                this.lastSlide = this.cursorShape.clone() as PrisJoint;
            }
            _canvas.removeChild(this.cursorShape);
            if(_loc2_ == this.pinButton)
            {
                this.populate(PIN);
            }
            else if(_loc2_ == this.slideButton)
            {
                this.populate(SLIDE);
            }
            _canvas.addChild(this.cursorShape);
        }
        
        protected function populate(param1:String) : void
        {
            var _loc4_:String = null;
            var _loc5_:InputObject = null;
            var _loc6_:int = 0;
            var _loc7_:InputObject = null;
            trace("jointType " + param1);
            this.removeInputs();
            this.currentJoint = param1;
            if(param1 == PIN)
            {
                this.cursorShape = !!this.lastPin ? this.lastPin.clone() as RefJoint : new PinJoint() as RefJoint;
            }
            else if(param1 == SLIDE)
            {
                this.cursorShape = !!this.lastSlide ? this.lastSlide.clone() as RefJoint : new PrisJoint() as RefJoint;
            }
            this.cursorShape.blendMode = BlendMode.INVERT;
            var _loc2_:int = this.height + 10;
            var _loc3_:int = 0;
            while(_loc3_ < this.cursorShape.attributes.length)
            {
                _loc4_ = this.cursorShape.attributes[_loc3_];
                if(_loc4_ != "x" && _loc4_ != "y")
                {
                    _loc5_ = AttributeReference.buildInput(_loc4_);
                    _loc5_.y = _loc2_;
                    _loc5_.x = this.indent;
                    addChild(_loc5_);
                    _loc5_.addEventListener(ValueEvent.VALUE_CHANGE,this.inputValueChange);
                    this.inputs.push(_loc5_);
                    _loc2_ += _loc5_.height;
                    if(_loc5_.childInputs)
                    {
                        _loc6_ = 0;
                        while(_loc6_ < _loc5_.childInputs.length)
                        {
                            _loc7_ = _loc5_.childInputs[_loc6_];
                            _loc7_.y = _loc2_;
                            _loc7_.x = this.indent;
                            addChild(_loc7_);
                            _loc2_ += _loc7_.height;
                            _loc6_++;
                        }
                    }
                    this.updateInput(_loc5_);
                }
                _loc3_++;
            }
            if(window)
            {
                window.setDimensions(this.windowWidth,this.height + 5);
            }
        }
        
        private function removeInputs() : void
        {
            var _loc2_:InputObject = null;
            var _loc3_:int = 0;
            var _loc4_:InputObject = null;
            var _loc1_:int = 0;
            while(_loc1_ < this.inputs.length)
            {
                _loc2_ = this.inputs[_loc1_];
                _loc3_ = 0;
                while(_loc3_ < _loc2_.childInputs.length)
                {
                    _loc4_ = _loc2_.childInputs[_loc3_];
                    removeChild(_loc4_);
                    _loc3_++;
                }
                _loc2_.removeEventListener(ValueEvent.VALUE_CHANGE,this.inputValueChange);
                _loc2_.die();
                removeChild(_loc2_);
                _loc1_++;
            }
            this.inputs = new Array();
        }
        
        private function inputValueChange(param1:ValueEvent) : void
        {
            var _loc2_:InputObject = param1.inputObject;
            var _loc3_:String = _loc2_.attribute;
            this.cursorShape[_loc3_] = param1.value;
            this.updateInput(_loc2_);
        }
        
        private function updateInputValues() : void
        {
            var _loc2_:InputObject = null;
            var _loc1_:int = 0;
            while(_loc1_ < this.inputs.length)
            {
                _loc2_ = this.inputs[_loc1_] as InputObject;
                this.updateInput(_loc2_);
                _loc1_++;
            }
        }
        
        private function updateInput(param1:InputObject) : void
        {
            var _loc5_:InputObject = null;
            var _loc2_:String = param1.attribute;
            var _loc3_:* = this.cursorShape[_loc2_];
            param1.setValue(_loc3_);
            var _loc4_:int = 0;
            while(_loc4_ < param1.childInputs.length)
            {
                _loc5_ = param1.childInputs[_loc4_];
                this.updateInput(_loc5_);
                _loc4_++;
            }
        }
        
        protected function createNewJoint() : void
        {
            var _loc2_:Action = null;
            var _loc3_:Action = null;
            var _loc4_:Point = null;
            _canvas.addRefSprite(this.cursorShape);
            this.cursorShape.blendMode = BlendMode.NORMAL;
            this.cursorShape.identifyBodies();
            if(this.cursorShape.body1)
            {
                _loc2_ = new ActionAdd(this.cursorShape,_canvas,_canvas.joints.getChildIndex(this.cursorShape));
                _loc3_ = _loc2_;
                _loc4_ = new Point(this.cursorShape.x,this.cursorShape.y);
                _loc2_ = new ActionProperty(this.cursorShape,"body1",null,this.cursorShape.body1,_loc4_,_loc4_);
                _loc3_.nextAction = _loc2_;
                _loc3_ = _loc2_;
                if(this.cursorShape.body2)
                {
                    _loc2_ = new ActionProperty(this.cursorShape,"body2",null,this.cursorShape.body2,_loc4_,_loc4_);
                    _loc3_.nextAction = _loc2_;
                }
                dispatchEvent(new ActionEvent(ActionEvent.GENERIC,_loc2_));
            }
            var _loc1_:RefJoint = this.cursorShape.clone() as RefJoint;
            this.cursorShape = _loc1_;
            this.cursorShape.blendMode = BlendMode.INVERT;
            _canvas.addChild(this.cursorShape);
            this.cursorShape.x = _canvas.mouseX;
            this.cursorShape.y = _canvas.mouseY;
        }
        
        override public function die() : void
        {
            super.die();
            this.pinButton.addEventListener(MouseEvent.MOUSE_UP,this.jointChosen);
            this.slideButton.addEventListener(MouseEvent.MOUSE_UP,this.jointChosen);
        }
    }
}

