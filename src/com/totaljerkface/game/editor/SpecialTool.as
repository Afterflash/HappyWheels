package com.totaljerkface.game.editor
{
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.editor.actions.*;
    import com.totaljerkface.game.editor.specials.*;
    import com.totaljerkface.game.editor.ui.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.getDefinitionByName;
    
    public class SpecialTool extends Tool
    {
        private var menu:SpecialMenu;
        
        private var menuWindow:Window;
        
        private var menuItems:Array;
        
        private var cursorShape:Special;
        
        private var currentType:String;
        
        private var inputs:Array;
        
        private const windowWidth:int = 130;
        
        private const indent:int = 5;
        
        private var menuPosX:Number = 700;
        
        private var menuPosY:Number = 200;
        
        private const helpMessage:String = "<u><b>Special Tool Help:</b></u><br><br>The special tool allows you to create new special objects on stage.  Choose your special object from the list on the right.  Set parameters of the object before placing.  Some of the simpler special items can be grouped or used in joints.  You <b>must</b> place a finish line if you\'d like users to be able to complete your level.<br><br><u>Keyboard Shortcuts:</u><br><br><b>a,w,s,d</b>: Resize the height and width of the current object (if possible).  Hold <b>shift</b> to resize faster.<br><br><b>z,x</b>: Rotate the current object (if possible).  Hold <b>shift</b> to rotate faster.";
        
        public function SpecialTool(param1:Editor, param2:Canvas)
        {
            super(param1,param2);
            this.init();
        }
        
        private function init() : void
        {
            this.inputs = new Array();
            this.menu = new SpecialMenu();
            this.populate("IBeamRef");
        }
        
        override public function activate() : void
        {
            super.activate();
            HelpWindow.instance.populate(this.helpMessage);
            window.setDimensions(this.windowWidth,this.height + 5);
            this.menuWindow = new Window(false,this.menu);
            this.menuWindow.x = 900 - (this.menuWindow.width + 20);
            this.menuWindow.y = 500 - (this.menuWindow.height + 20);
            trace(this.menuWindow.x + " " + this.menuWindow.y);
            _canvas.parent.parent.addChild(this.menuWindow);
            _canvas.addChild(this.cursorShape);
            stage.addEventListener(Event.ENTER_FRAME,this.mouseMoveHandler);
            stage.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
            stage.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
            this.menu.addEventListener(SpecialMenu.SPECIAL_CHOSEN,this.specialChosen);
        }
        
        override public function deactivate() : void
        {
            this.menuPosX = this.menuWindow.x;
            this.menuPosY = this.menuWindow.y;
            this.menuWindow.closeWindow();
            _canvas.removeChild(this.cursorShape);
            stage.removeEventListener(Event.ENTER_FRAME,this.mouseMoveHandler);
            stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
            stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
            this.menu.removeEventListener(SpecialMenu.SPECIAL_CHOSEN,this.specialChosen);
            super.deactivate();
        }
        
        protected function mouseMoveHandler(param1:Event) : void
        {
            this.cursorShape.x = _canvas.mouseX;
            this.cursorShape.y = _canvas.mouseY;
            this.cursorShape.mouseChildren = false;
        }
        
        protected function specialChosen(param1:Event) : void
        {
            this.populate(this.menu.selectedClassName);
            _canvas.addChild(this.cursorShape);
        }
        
        protected function populate(param1:String) : void
        {
            var _loc5_:String = null;
            var _loc6_:InputObject = null;
            var _loc7_:int = 0;
            var _loc8_:InputObject = null;
            trace("specialtype " + param1);
            this.removeInputs();
            var _loc2_:Class = getDefinitionByName(Settings.specialClassPath + param1) as Class;
            if(this.cursorShape)
            {
                _canvas.removeChild(this.cursorShape);
                this.cursorShape = null;
            }
            this.cursorShape = new _loc2_();
            this.cursorShape.blendMode = BlendMode.INVERT;
            var _loc3_:int = 0;
            var _loc4_:int = 0;
            while(_loc4_ < this.cursorShape.attributes.length)
            {
                _loc5_ = this.cursorShape.attributes[_loc4_];
                if(_loc5_ != "x" && _loc5_ != "y")
                {
                    _loc6_ = AttributeReference.buildInput(_loc5_);
                    _loc6_.y = _loc3_;
                    _loc6_.x = this.indent;
                    addChild(_loc6_);
                    _loc6_.addEventListener(ValueEvent.VALUE_CHANGE,this.inputValueChange);
                    this.inputs.push(_loc6_);
                    _loc3_ += _loc6_.height;
                    if(_loc6_.childInputs)
                    {
                        _loc7_ = 0;
                        while(_loc7_ < _loc6_.childInputs.length)
                        {
                            _loc8_ = _loc6_.childInputs[_loc7_];
                            _loc8_.y = _loc3_;
                            _loc8_.x = this.indent;
                            addChild(_loc8_);
                            _loc3_ += _loc8_.height;
                            _loc7_++;
                        }
                    }
                    this.updateInput(_loc6_);
                }
                _loc4_++;
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
        
        protected function mouseDownHandler(param1:MouseEvent) : void
        {
            var _loc2_:Sprite = null;
            var _loc3_:MenuItem = null;
            if(param1.target is Sprite)
            {
                _loc2_ = param1.target as Sprite;
                if(_loc2_ == _canvas || _loc2_.parent == _canvas)
                {
                    this.createNewShape();
                }
            }
            if(param1.target is MenuItem)
            {
                _loc3_ = param1.target as MenuItem;
                this.populate(_loc3_.classType);
                _canvas.addChild(this.cursorShape);
            }
        }
        
        protected function keyDownHandler(param1:KeyboardEvent) : void
        {
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
            if(!this.cursorShape.scalable)
            {
                return;
            }
            if(param3)
            {
                param1 *= 10;
                param2 *= 10;
            }
            this.cursorShape.shapeWidth += param1;
            this.cursorShape.shapeHeight += param2;
            this.updateInputValues();
        }
        
        protected function adjustRotation(param1:Number, param2:Boolean) : void
        {
            if(!this.cursorShape.rotatable)
            {
                return;
            }
            if(param2)
            {
                param1 *= 10;
            }
            this.cursorShape.angle += param1;
            this.updateInputValues();
        }
        
        protected function createNewShape() : void
        {
            var _loc1_:Special = this.cursorShape.clone() as Special;
            _canvas.addRefSprite(_loc1_);
            var _loc2_:Action = new ActionAdd(_loc1_,_canvas,_canvas.special.getChildIndex(_loc1_));
            dispatchEvent(new ActionEvent(ActionEvent.GENERIC,_loc2_));
        }
        
        override public function die() : void
        {
            this.menu.die();
            super.die();
        }
    }
}

