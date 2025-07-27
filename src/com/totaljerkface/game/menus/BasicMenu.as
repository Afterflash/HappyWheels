package com.totaljerkface.game.menus
{
    import com.totaljerkface.game.editor.ui.LibraryButton;
    import com.totaljerkface.game.events.NavigationEvent;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    
    public class BasicMenu extends Sprite
    {
        public var backButton:LibraryButton;
        
        public function BasicMenu()
        {
            super();
            this.backButton.addEventListener(MouseEvent.MOUSE_UP,this.backPress);
        }
        
        private function backPress(param1:MouseEvent) : void
        {
            trace("back press");
            dispatchEvent(new NavigationEvent(NavigationEvent.MAIN_MENU));
        }
        
        public function die() : void
        {
            this.backButton.removeEventListener(MouseEvent.MOUSE_UP,this.backPress);
        }
    }
}

