package com.totaljerkface.game.editor
{
    import com.totaljerkface.game.editor.ui.Window;
    import flash.display.Sprite;
    
    public class Tool extends Sprite
    {
        private static var windowX:Number = 54;
        
        private static var windowY:Number = 30;
        
        protected var _canvas:Canvas;
        
        protected var _editor:Editor;
        
        protected var window:Window;
        
        public function Tool(param1:Editor, param2:Canvas)
        {
            super();
            this._editor = param1;
            this._canvas = param2;
        }
        
        public function activate() : void
        {
            this.window = new Window(false,this);
            this.window.x = windowX;
            this.window.y = windowY;
            this._canvas.parent.parent.addChild(this.window);
        }
        
        public function deactivate() : void
        {
            windowX = this.window.x;
            windowY = this.window.y;
            this.window.closeWindow();
            this.window = null;
        }
        
        public function resetActionVars(param1:String) : void
        {
        }
        
        public function addFrameHandler() : void
        {
        }
        
        public function removeFrameHandler() : void
        {
        }
        
        public function setCurrentShape(param1:RefShape) : void
        {
        }
        
        public function die() : void
        {
            if(this.window)
            {
                this.deactivate();
            }
        }
        
        public function get canvas() : Canvas
        {
            return this._canvas;
        }
        
        public function get editor() : Editor
        {
            return this._editor;
        }
        
        public function remoteButtonPress() : void
        {
            if(this is PolygonTool)
            {
                this._editor.toolBar.pressButton(ToolBar.POLYGON);
            }
            else if(this is ArtTool)
            {
                this._editor.toolBar.pressButton(ToolBar.ART);
            }
        }
        
        public function resizeElements() : void
        {
        }
    }
}

