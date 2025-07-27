package com.totaljerkface.game.editor
{
    import com.totaljerkface.game.events.CanvasEvent;
    import flash.display.Sprite;
    
    public class GroupCanvas extends Canvas
    {
        private var _refGroup:RefGroup;
        
        private var _groupIndex:int;
        
        private var centerMarker:Sprite;
        
        public function GroupCanvas(param1:RefGroup, param2:Canvas, param3:int)
        {
            this._refGroup = param1;
            this._groupIndex = param3;
            _mainCanvas = param2;
            super();
            doubleClickEnabled = true;
        }
        
        override protected function init() : void
        {
            _canvasWidth = 20000;
            _canvasHeight = 10000;
            graphics.beginFill(10066329,0.35);
            graphics.drawRect(0,0,_canvasWidth,_canvasHeight);
            graphics.endFill();
            graphics.lineStyle(0,16777215,1,true);
            graphics.moveTo(this._refGroup.x - 5,this.refGroup.y);
            graphics.lineTo(this._refGroup.x + 5,this.refGroup.y);
            graphics.moveTo(this._refGroup.x,this.refGroup.y - 5);
            graphics.lineTo(this._refGroup.x,this.refGroup.y + 5);
            shapes = new Sprite();
            shapes.name = "shapes";
            special = new Sprite();
            special.name = "special";
            addChild(shapes);
            addChild(special);
            addEventListener(CanvasEvent.ART,artStatusHandler,false,0,true);
            addEventListener(CanvasEvent.SHAPE,shapeStatusHandler,false,0,true);
        }
        
        override public function get shapeCount() : int
        {
            return _mainCanvas.shapeCount;
        }
        
        override public function set shapeCount(param1:int) : void
        {
            _mainCanvas.shapeCount = param1;
        }
        
        override protected function setTextField() : void
        {
        }
        
        public function get refGroup() : RefGroup
        {
            return this._refGroup;
        }
        
        public function get groupIndex() : int
        {
            return this._groupIndex;
        }
    }
}

