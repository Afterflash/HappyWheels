package com.totaljerkface.game.editor.ui
{
    import com.totaljerkface.game.sound.SoundController;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    
    public class LibraryButton extends Sprite
    {
        public var bg:Sprite;
        
        public var textSprite:Sprite;
        
        private var _selected:Boolean;
        
        private var offAlpha:Number = 0.8;
        
        public function LibraryButton()
        {
            super();
            mouseChildren = false;
            buttonMode = true;
            tabEnabled = false;
            this.selected = false;
            addEventListener(MouseEvent.ROLL_OVER,this.rollOverHandler,false,0,true);
            addEventListener(MouseEvent.ROLL_OUT,this.rollOutHandler,false,0,true);
            addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler,false,0,true);
        }
        
        public function get selected() : Boolean
        {
            return this._selected;
        }
        
        public function set selected(param1:Boolean) : void
        {
            this._selected = param1;
            if(this._selected)
            {
                this.rollOverHandler();
            }
            else
            {
                this.rollOutHandler();
            }
        }
        
        private function rollOverHandler(param1:MouseEvent = null) : void
        {
            this.textSprite.alpha = 1;
        }
        
        private function rollOutHandler(param1:MouseEvent = null) : void
        {
            if(this._selected)
            {
                return;
            }
            this.textSprite.alpha = this.offAlpha;
        }
        
        private function mouseUpHandler(param1:MouseEvent) : void
        {
            SoundController.instance.playSoundItem("MenuSelect");
        }
    }
}

