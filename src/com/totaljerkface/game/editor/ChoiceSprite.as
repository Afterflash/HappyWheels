package com.totaljerkface.game.editor
{
    import com.totaljerkface.game.editor.ui.GenericButton;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    
    public class ChoiceSprite extends StatusSprite
    {
        public static const ANSWER_CHOSEN:String = "answerchosen";
        
        public var answer1Btn:GenericButton;
        
        public var answer2Btn:GenericButton;
        
        private var _index:int;
        
        public function ChoiceSprite(param1:String, param2:String, param3:String, param4:Boolean = true, param5:int = 200, param6:int = 70, param7:uint = 16613761, param8:uint = 16613761, param9:uint = 16777215, param10:uint = 16777215)
        {
            super(param1,param4,param5);
            this.createButtons(param2,param3,param6,param7,param8,param9,param10);
            this.adjustSpacing();
            addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler,false,0,true);
        }
        
        override protected function createBg() : void
        {
            bgHeight = Math.max(Math.round(textField.height + 40),100);
            bg = new Sprite();
            bg.graphics.beginFill(13421772);
            bg.graphics.drawRect(0,0,bgWidth,bgHeight);
            bg.graphics.endFill();
            addChildAt(bg,0);
        }
        
        private function createButtons(param1:String, param2:String, param3:int, param4:uint, param5:uint, param6:uint, param7:uint) : void
        {
            var _loc8_:int = 0;
            var _loc10_:int = 0;
            this.answer1Btn = new GenericButton(param1,param4,param3,param6);
            this.answer2Btn = new GenericButton(param2,param5,param3,param7);
            addChild(this.answer1Btn);
            addChild(this.answer2Btn);
            _loc8_ = 20;
            var _loc9_:int = param3 * 2 + _loc8_;
            _loc10_ = bgWidth * 0.5;
            this.answer1Btn.x = _loc10_ - _loc9_ * 0.5;
            this.answer2Btn.x = _loc10_ + _loc8_ * 0.5;
        }
        
        private function adjustSpacing() : void
        {
            var _loc1_:Number = bgHeight - 30;
            this.answer1Btn.y = this.answer2Btn.y = _loc1_;
            textField.y = (_loc1_ - textField.height) / 2;
        }
        
        private function mouseUpHandler(param1:MouseEvent) : void
        {
            if(param1.target == this.answer1Btn)
            {
                this._index = 0;
            }
            else
            {
                if(param1.target != this.answer2Btn)
                {
                    return;
                }
                this._index = 1;
            }
            dispatchEvent(new Event(ANSWER_CHOSEN));
        }
        
        public function get index() : int
        {
            return this._index;
        }
        
        override public function die() : void
        {
            _window.closeWindow();
            removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
        }
    }
}

