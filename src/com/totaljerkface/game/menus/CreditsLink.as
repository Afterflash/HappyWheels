package com.totaljerkface.game.menus
{
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.geom.ColorTransform;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;
    
    public class CreditsLink extends Sprite
    {
        private var textSprite:Sprite;
        
        private var url:String;
        
        public var colorTransform:ColorTransform;
        
        public function CreditsLink(param1:Sprite, param2:String)
        {
            super();
            this.textSprite = param1;
            this.url = param2;
            buttonMode = true;
            tabEnabled = false;
            this.colorTransform = new ColorTransform(1,1,1,1,253,-129,-129,0);
            x = param1.x;
            y = param1.y;
            param1.parent.addChild(this);
            param1.x = 0;
            param1.y = 0;
            addChild(param1);
            addEventListener(MouseEvent.ROLL_OVER,this.rollOverHandler,false,0,true);
            addEventListener(MouseEvent.ROLL_OUT,this.rollOutHandler,false,0,true);
            addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler,false,0,true);
        }
        
        private function rollOverHandler(param1:MouseEvent) : void
        {
            transform.colorTransform = this.colorTransform;
        }
        
        private function rollOutHandler(param1:MouseEvent) : void
        {
            transform.colorTransform = new ColorTransform(1,1,1,1,0,0,0,0);
        }
        
        private function mouseUpHandler(param1:MouseEvent) : void
        {
            var _loc2_:URLRequest = new URLRequest(this.url);
            navigateToURL(_loc2_,"_blank");
        }
        
        public function die() : void
        {
            removeEventListener(MouseEvent.ROLL_OVER,this.rollOverHandler);
            removeEventListener(MouseEvent.ROLL_OUT,this.rollOutHandler);
            removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
        }
    }
}

