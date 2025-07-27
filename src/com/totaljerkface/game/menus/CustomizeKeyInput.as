package com.totaljerkface.game.menus
{
    import com.totaljerkface.game.editor.ui.ValueEvent;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.FocusEvent;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.filters.GlowFilter;
    import flash.text.TextField;

    [Embed(source="/_assets/assets.swf", symbol="symbol811")]
    public class CustomizeKeyInput extends Sprite
    {
        public static const FOCUS_IN:String = "focusin";

        public static const FOCUS_OUT:String = "focusout";

        public var labelText:TextField;

        public var inputText:TextField;

        public var defaultText:TextField;

        public var bg:Sprite;

        public var lastInput:String;

        private var _keyCode:uint;

        public function CustomizeKeyInput(param1:String, param2:String, param3:String)
        {
            super();
            this.labelText.text = param1;
            this.inputText.text = this.lastInput = param2;
            this.inputText.mouseEnabled = false;
            this.defaultText.text = param3;
            addEventListener(MouseEvent.MOUSE_UP, this.handleMouseUp);
            this.bg.buttonMode = true;
            this.bg.tabEnabled = false;
            this.bg.useHandCursor = true;
        }

        public function disable():void
        {
            alpha = 0.5;
            this.bg.useHandCursor = false;
            this.bg.buttonMode = false;
            removeEventListener(MouseEvent.MOUSE_UP, this.handleMouseUp);
        }

        public function enable():void
        {
            alpha = 1;
            this.bg.useHandCursor = true;
            this.bg.buttonMode = true;
            this.bg.filters = [];
            addEventListener(MouseEvent.MOUSE_UP, this.handleMouseUp);
        }

        public function highlight(param1:Boolean = false):void
        {
            var _loc2_:uint = param1 ? 16711680 : 4032711;
            this.bg.filters = [new GlowFilter(_loc2_, 1, 3, 3, 100, 3)];
            alpha = 1;
        }

        public function clearHighlight():void
        {
            alpha = 0.5;
            this.bg.filters = [];
        }

        private function handleMouseUp(param1:MouseEvent):void
        {
            if (param1.target == this.bg)
            {
                this.highlight();
                this.inputText.text = "";
                stage.addEventListener(KeyboardEvent.KEY_DOWN, this.handleKeyDown);
                dispatchEvent(new Event(FOCUS_IN));
            }
        }

        private function handleFocusOut(param1:FocusEvent):void
        {
            trace("handle focus out");
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.handleKeyDown);
            removeEventListener(FocusEvent.FOCUS_OUT, this.handleFocusOut);
        }

        private function handleKeyDown(param1:KeyboardEvent):void
        {
            this._keyCode = param1.keyCode;
            dispatchEvent(new ValueEvent(ValueEvent.VALUE_CHANGE, null, this._keyCode));
        }

        public function get keyCode():uint
        {
            return this._keyCode;
        }

        public function set keyCode(param1:uint):void
        {
            this._keyCode = param1;
        }

        public function set text(param1:String):void
        {
            this.bg.filters = [];
            this.inputText.text = param1;
            this.lastInput = param1;
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.handleKeyDown);
            dispatchEvent(new Event(FOCUS_OUT));
        }

        public function die():void
        {
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.handleKeyDown);
            removeEventListener(MouseEvent.MOUSE_UP, this.handleMouseUp);
        }
    }
}
