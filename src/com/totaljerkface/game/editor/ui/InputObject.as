package com.totaljerkface.game.editor.ui
{
    import com.totaljerkface.game.editor.MouseHelper;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    
    public class InputObject extends Sprite
    {
        protected var _editable:Boolean;
        
        protected var _ambiguous:Boolean;
        
        protected var _multipleIndex:int = 0;
        
        protected var _multipleKey:Object;
        
        protected var _expandable:Boolean;
        
        public var attribute:String;
        
        public var childInputs:Array;
        
        public var parentInput:InputObject;
        
        protected var _helpCaption:String;
        
        protected var _defaultValue:*;
        
        public function InputObject()
        {
            super();
        }
        
        public function set editable(param1:Boolean) : void
        {
            this._editable = param1;
        }
        
        public function get editable() : Boolean
        {
            return this._editable;
        }
        
        public function die() : void
        {
            removeEventListener(MouseEvent.ROLL_OVER,this.mouseOverHandler);
        }
        
        public function setToAmbiguous() : void
        {
        }
        
        public function get ambiguous() : Boolean
        {
            return this._ambiguous;
        }
        
        public function get multipleIndex() : int
        {
            return this._multipleIndex;
        }
        
        public function set multipleIndex(param1:int) : void
        {
            this._multipleIndex = param1;
        }
        
        public function get multipleKey() : Object
        {
            return this._multipleKey;
        }
        
        public function set multipleKey(param1:Object) : void
        {
            this._multipleKey = param1;
        }
        
        public function setValue(param1:*) : void
        {
        }
        
        public function get helpCaption() : String
        {
            return this._helpCaption;
        }
        
        public function set helpCaption(param1:String) : void
        {
            this._helpCaption = param1;
            if(this._helpCaption)
            {
                addEventListener(MouseEvent.ROLL_OVER,this.mouseOverHandler);
            }
        }
        
        protected function mouseOverHandler(param1:MouseEvent) : void
        {
            if(!this._editable)
            {
                return;
            }
            MouseHelper.instance.show(this._helpCaption,this);
        }
        
        public function get defaultValue() : *
        {
            return this._defaultValue;
        }
        
        public function set defaultValue(param1:*) : void
        {
            this._defaultValue = param1;
        }
        
        public function get expandable() : Boolean
        {
            return this._expandable;
        }
    }
}

