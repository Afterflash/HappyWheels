package com.totaljerkface.game.editor
{
    import com.totaljerkface.game.editor.ui.GenericButton;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    
    public class PromptSprite extends StatusSprite
    {
        public static const BUTTON_PRESSED:String = "buttonpressed";
        
        private var button:GenericButton;
        
        public function PromptSprite(param1:String, param2:String, param3:Boolean = true, param4:int = 200)
        {
            super(param1,param3,param4);
            this.button = new GenericButton(param2,16613761,70);
            addChild(this.button);
            this.button.x = Math.round((param4 - this.button.width) / 2);
            this.adjustSpacing();
            this.button.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler,false,0,true);
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
        
        private function adjustSpacing() : void
        {
            var _loc1_:Number = NaN;
            _loc1_ = bgHeight - 30;
            this.button.y = _loc1_;
            textField.y = (_loc1_ - textField.height) / 2;
        }
        
        private function mouseUpHandler(param1:MouseEvent) : void
        {
            dispatchEvent(new Event(BUTTON_PRESSED));
            this.die();
        }
        
        override public function die() : void
        {
            _window.closeWindow();
            this.button.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
        }
    }
}

