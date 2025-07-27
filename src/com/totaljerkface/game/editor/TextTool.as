package com.totaljerkface.game.editor
{
    import com.totaljerkface.game.editor.actions.*;
    import com.totaljerkface.game.editor.specials.TextBoxRef;
    import com.totaljerkface.game.editor.ui.*;
    import flash.display.*;
    import flash.events.*;
    
    public class TextTool extends Tool
    {
        protected var rotationInput:TextInput;
        
        protected var colorInput:ColorInput;
        
        protected var fontInput:SliderInput;
        
        protected var sizeInput:SliderInput;
        
        protected var alignInput:SliderInput;
        
        protected var cursorShape:TextBoxRef;
        
        private const helpMessage:String = "<u><b>Text Tool Help:</b></u><br><br>Make some text.<br><br>Once placing text, type to enter your message.  Using the selection tool, you can double click on a previously placed text box to edit what you\'ve typed.<br><br>If you\'d like your text to move around, you can group it with other groupable objects.";
        
        public function TextTool(param1:Editor, param2:Canvas)
        {
            super(param1,param2);
            this.init();
        }
        
        protected function init() : void
        {
            this.createCursor();
            var _loc1_:int = 5;
            this.rotationInput = new TextInput("rotation","angle",5,true);
            this.rotationInput.restrict = "0-9\\-";
            this.rotationInput.x = _loc1_;
            this.rotationInput.y = 0;
            addChild(this.rotationInput);
            this.colorInput = new ColorInput("color","color",true);
            this.colorInput.y = this.rotationInput.y + Math.ceil(this.rotationInput.height);
            this.colorInput.x = _loc1_;
            addChild(this.colorInput);
            this.fontInput = new SliderInput("font","font",1,true,1,5,4);
            this.fontInput.y = this.colorInput.y + Math.ceil(this.colorInput.height);
            this.fontInput.x = _loc1_;
            addChild(this.fontInput);
            this.sizeInput = new SliderInput("font size","fontSize",3,true,10,100,90);
            this.sizeInput.y = this.fontInput.y + Math.ceil(this.fontInput.height);
            this.sizeInput.x = _loc1_;
            addChild(this.sizeInput);
            this.alignInput = new SliderInput("alignment","align",1,true,1,3,2);
            this.alignInput.y = this.sizeInput.y + Math.ceil(this.sizeInput.height);
            this.alignInput.x = _loc1_;
            addChild(this.alignInput);
            this.rotationInput.addEventListener(ValueEvent.VALUE_CHANGE,this.inputValueChange);
            this.colorInput.addEventListener(ValueEvent.VALUE_CHANGE,this.inputValueChange);
            this.fontInput.addEventListener(ValueEvent.VALUE_CHANGE,this.inputValueChange);
            this.sizeInput.addEventListener(ValueEvent.VALUE_CHANGE,this.inputValueChange);
            this.alignInput.addEventListener(ValueEvent.VALUE_CHANGE,this.inputValueChange);
            this.updateInputs();
        }
        
        protected function createCursor() : void
        {
            this.cursorShape = new TextBoxRef();
            this.cursorShape.blendMode = BlendMode.INVERT;
        }
        
        override public function activate() : void
        {
            super.activate();
            HelpWindow.instance.populate(this.helpMessage);
            window.setDimensions(130,180);
            _canvas.addChild(this.cursorShape);
            stage.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
            stage.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
            stage.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
        }
        
        override public function deactivate() : void
        {
            _canvas.removeChild(this.cursorShape);
            this.colorInput.closeColorSelector();
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
            stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
            stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
            super.deactivate();
        }
        
        protected function mouseMoveHandler(param1:Event = null) : void
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
                if(_loc2_ == _canvas || _loc2_.parent == _canvas)
                {
                    this.createNewTextBox();
                }
            }
        }
        
        protected function keyDownHandler(param1:KeyboardEvent) : void
        {
            switch(param1.keyCode)
            {
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
            this.updateInputs();
        }
        
        protected function updateInputs() : void
        {
            this.rotationInput.setValue(this.cursorShape.angle);
            this.colorInput.setValue(this.cursorShape.color);
            this.fontInput.setValue(this.cursorShape.font);
            this.sizeInput.setValue(this.cursorShape.fontSize);
            this.alignInput.setValue(this.cursorShape.align);
        }
        
        protected function createNewTextBox() : void
        {
            var _loc1_:TextBoxRef = this.cursorShape.clone() as TextBoxRef;
            canvas.addRefSprite(_loc1_);
            var _loc2_:Action = new ActionAdd(_loc1_,canvas,canvas.special.getChildIndex(_loc1_));
            dispatchEvent(new ActionEvent(ActionEvent.GENERIC,_loc2_));
        }
        
        protected function inputValueChange(param1:ValueEvent) : void
        {
            trace("INPUT VALUE CHANGE");
            var _loc2_:InputObject = param1.inputObject;
            var _loc3_:String = _loc2_.attribute;
            trace("property " + _loc3_);
            trace(param1.value);
            this.cursorShape[_loc3_] = param1.value;
            this.updateInputs();
        }
        
        override public function die() : void
        {
            super.die();
            this.colorInput.addEventListener(ValueEvent.VALUE_CHANGE,this.inputValueChange);
            this.fontInput.addEventListener(ValueEvent.VALUE_CHANGE,this.inputValueChange);
            this.sizeInput.removeEventListener(ValueEvent.VALUE_CHANGE,this.inputValueChange);
            this.alignInput.removeEventListener(ValueEvent.VALUE_CHANGE,this.inputValueChange);
            this.colorInput.die();
            this.fontInput.die();
            this.sizeInput.die();
            this.alignInput.die();
        }
    }
}

