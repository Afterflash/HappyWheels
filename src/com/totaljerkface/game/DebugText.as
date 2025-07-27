package com.totaljerkface.game
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    import flash.utils.Timer;
    
    public class DebugText extends Sprite
    {
        private var _textField:TextField;
        
        private var _timer:Timer;
        
        private var fadeTime:int;
        
        private var counter:int;
        
        public function DebugText()
        {
            super();
            this._textField = new TextField();
            var _loc1_:TextFormat = new TextFormat("HelveticaNeueLT Std",12,16711680,null,null,null,null,null,TextFormatAlign.CENTER);
            this._textField.defaultTextFormat = _loc1_;
            this._textField.multiline = true;
            this._textField.height = 20;
            this._textField.width = 300;
            this._textField.x = 300;
            this._textField.mouseEnabled = false;
            this._textField.selectable = false;
            this._textField.embedFonts = true;
            this._textField.autoSize = TextFieldAutoSize.CENTER;
            this._textField.wordWrap = true;
            addChild(this._textField);
            mouseEnabled = false;
            mouseChildren = false;
        }
        
        public function set text(param1:String) : void
        {
            this.removeListeners();
            alpha = 1;
            this._textField.text = param1;
        }
        
        public function set htmlText(param1:String) : void
        {
            this.removeListeners();
            alpha = 1;
            this._textField.htmlText = param1;
        }
        
        public function appendText(param1:String) : void
        {
            this.removeListeners();
            alpha = 1;
            this._textField.appendText(param1);
        }
        
        private function removeListeners() : void
        {
            if(this._timer)
            {
                this._timer.stop();
                this._timer.removeEventListener(TimerEvent.TIMER,this.startFade);
                this._timer = null;
            }
            removeEventListener(Event.ENTER_FRAME,this.fadeOut);
        }
        
        public function show(param1:String, param2:Number = 2, param3:Number = 1) : void
        {
            alpha = 1;
            this._textField.text = param1;
            if(this._timer)
            {
                this._timer.stop();
                this._timer.removeEventListener(TimerEvent.TIMER,this.startFade);
                removeEventListener(Event.ENTER_FRAME,this.fadeOut);
                this._timer = null;
            }
            this.fadeTime = param3 * 30;
            this._timer = new Timer(param2 * 1000,1);
            this._timer.addEventListener(TimerEvent.TIMER,this.startFade);
            this._timer.start();
        }
        
        private function startFade(param1:TimerEvent) : void
        {
            if(this._timer)
            {
                this._timer.stop();
                this._timer.removeEventListener(TimerEvent.TIMER,this.startFade);
                this._timer = null;
            }
            this.counter = 0;
            addEventListener(Event.ENTER_FRAME,this.fadeOut);
        }
        
        private function fadeOut(param1:Event) : void
        {
            ++this.counter;
            alpha = (this.fadeTime - this.counter) / this.fadeTime;
            if(this.counter == this.fadeTime)
            {
                removeEventListener(Event.ENTER_FRAME,this.fadeOut);
            }
        }
    }
}

