package com.totaljerkface.game.editor
{
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.editor.actions.*;
    import com.totaljerkface.game.editor.specials.*;
    import com.totaljerkface.game.editor.trigger.*;
    import com.totaljerkface.game.editor.ui.*;
    import flash.display.*;
    import flash.events.*;
    
    public class TriggerTool extends Tool
    {
        private var cursorShape:RefTrigger;
        
        private var inputs:Array;
        
        private const windowWidth:int = 130;
        
        private const indent:int = 5;
        
        private const helpMessage:String = "<u><b>Trigger Tool Help:</b></u><br><br>The trigger tool allows you to trigger certain actions during gameplay. When the player passes through the defined shape, the selected action will occur.<br><br>If activate object is selected, you must attach the trigger to the desired object, similarly to a joint. Many times this is just waking a sleeping object, but that will be expanded in the future. Mines for example will explode when activated. Boosts and fans will turn on.<br><br>Sound effects can also be triggered. Currently you only have use of the sounds currently used in the game.<br><br>I plan on expanding this tool with ambient sounds and additional options next week (setting it up was a time-consuming pain in the ass).<br><br><u>Keyboard Shortcuts:</u><br><br><b>a,w,s,d</b>: Resize the height and width of the trigger.  Hold <b>shift</b> to resize faster.<br><br><b>z,x</b>: Rotate the trigger. Hold <b>shift</b> to rotate faster.";
        
        public function TriggerTool(param1:Editor, param2:Canvas)
        {
            super(param1,param2);
            this.init();
        }
        
        private function init() : void
        {
            this.inputs = new Array();
            this.cursorShape = new RefTrigger();
            this.cursorShape.blendMode = BlendMode.INVERT;
            this.populate();
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
        
        protected function mouseMoveHandler(param1:Event) : void
        {
            this.cursorShape.x = _canvas.mouseX;
            this.cursorShape.y = _canvas.mouseY;
            this.cursorShape.mouseChildren = false;
        }
        
        protected function populate() : void
        {
            var _loc1_:int = 0;
            var _loc3_:String = null;
            var _loc4_:InputObject = null;
            var _loc5_:int = 0;
            var _loc6_:InputObject = null;
            this.removeInputs();
            _loc1_ = 0;
            var _loc2_:int = int(this.inputs.length);
            while(_loc2_ < this.cursorShape.attributes.length)
            {
                _loc3_ = this.cursorShape.attributes[_loc2_];
                if(_loc3_ != "x" && _loc3_ != "y")
                {
                    _loc4_ = AttributeReference.buildInput(_loc3_);
                    _loc4_.y = _loc1_;
                    _loc4_.x = this.indent;
                    addChild(_loc4_);
                    _loc4_.addEventListener(ValueEvent.VALUE_CHANGE,this.inputValueChange);
                    this.inputs.push(_loc4_);
                    _loc1_ += _loc4_.height;
                    if(_loc4_.childInputs)
                    {
                        _loc5_ = 0;
                        while(_loc5_ < _loc4_.childInputs.length)
                        {
                            _loc6_ = _loc4_.childInputs[_loc5_];
                            _loc6_.y = _loc1_;
                            _loc6_.x = this.indent;
                            addChild(_loc6_);
                            _loc1_ += _loc6_.height;
                            _loc5_++;
                        }
                    }
                    this.updateInput(_loc4_);
                }
                _loc2_++;
            }
            if(window)
            {
                window.setDimensions(this.windowWidth,this.height + 5);
            }
        }
        
        private function removeInputs(param1:int = 0) : void
        {
            var _loc3_:InputObject = null;
            var _loc4_:int = 0;
            var _loc5_:InputObject = null;
            var _loc2_:int = param1;
            while(_loc2_ < this.inputs.length)
            {
                _loc3_ = this.inputs[_loc2_];
                _loc4_ = 0;
                while(_loc4_ < _loc3_.childInputs.length)
                {
                    _loc5_ = _loc3_.childInputs[_loc4_];
                    removeChild(_loc5_);
                    _loc4_++;
                }
                _loc3_.removeEventListener(ValueEvent.VALUE_CHANGE,this.inputValueChange);
                _loc3_.die();
                removeChild(_loc3_);
                this.inputs.splice(_loc2_,1);
                _loc2_--;
                _loc2_++;
            }
        }
        
        private function inputValueChange(param1:ValueEvent) : void
        {
            var _loc4_:int = 0;
            var _loc2_:InputObject = param1.inputObject;
            var _loc3_:String = _loc2_.attribute;
            this.cursorShape[_loc3_] = param1.value;
            this.updateInput(_loc2_);
            if(_loc3_ == "triggerType")
            {
                _loc4_ = int(this.inputs.indexOf(_loc2_));
                this.removeInputs(_loc4_ + 1);
                this.populate();
            }
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
            if(param1.target is Sprite)
            {
                _loc2_ = param1.target as Sprite;
                if(_loc2_ == _canvas || _loc2_.parent == _canvas)
                {
                    this.createNewShape();
                }
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
            var _loc1_:RefTrigger = this.cursorShape.clone() as RefTrigger;
            _canvas.addRefSprite(_loc1_);
            _canvas.relabelTriggers();
            var _loc2_:Action = new ActionAdd(_loc1_,_canvas,_canvas.triggers.getChildIndex(_loc1_));
            dispatchEvent(new ActionEvent(ActionEvent.GENERIC,_loc2_));
        }
        
        override public function die() : void
        {
            super.die();
        }
    }
}

