package com.totaljerkface.game.editor
{
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;

    [Embed(source="/_assets/assets.swf", symbol="symbol829")]
    public class CanvasHorizontalScroller extends Sprite
    {
        public var scrollTab:Sprite;

        public var bg:Sprite;

        private var container:Sprite;

        private var canvasHolder:Sprite;

        private var totalWidth:int = 900;

        private var spacing:int;

        private var dragging:Boolean;

        public function CanvasHorizontalScroller(param1:Sprite, param2:Sprite, param3:int)
        {
            super();
            this.container = param1;
            this.canvasHolder = param2;
            this.spacing = param3;
            this.updateScrollTab();
            addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
        }

        public function updateScrollTab():void
        {
            var _loc1_:Number = NaN;
            _loc1_ = this.canvasHolder.scaleX * Canvas.canvasWidth + this.spacing * 2;
            var _loc2_:Number = this.totalWidth / _loc1_;
            if (_loc2_ > 1)
            {
                visible = false;
                return;
            }
            visible = true;
            this.scrollTab.width = _loc2_ * this.bg.width;
            this.scrollTab.x = (this.canvasHolder.x - this.spacing) * -this.bg.width / _loc1_;
        }

        private function updateCanvas(param1:MouseEvent = null):void
        {
            var _loc2_:Number = this.canvasHolder.scaleX * Canvas.canvasWidth + this.spacing * 2;
            this.canvasHolder.x = this.scrollTab.x * _loc2_ / -this.bg.width + this.spacing;
        }

        private function mouseDownHandler(param1:MouseEvent):void
        {
            switch (param1.target)
            {
                case this.scrollTab:
                    if (!this.dragging)
                    {
                        this.startScrollDrag();
                    }
                    break;
                case this.bg:
                    this.bgPress();
            }
        }

        private function bgPress():void
        {
            if (this.bg.mouseX > this.scrollTab.x)
            {
                this.scrollTab.x += this.scrollTab.width;
                if (this.scrollTab.x + this.scrollTab.width > this.bg.width)
                {
                    this.scrollTab.x = this.bg.width - this.scrollTab.width;
                }
            }
            else
            {
                this.scrollTab.x -= this.scrollTab.width;
                if (this.scrollTab.x < 0)
                {
                    this.scrollTab.x = 0;
                }
            }
            this.updateCanvas();
        }

        private function mouseUpHandler(param1:MouseEvent):void
        {
            stage.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.updateCanvas);
            this.stopScrollDrag();
        }

        private function startScrollDrag():void
        {
            this.dragging = true;
            stage.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            stage.addEventListener(MouseEvent.MOUSE_MOVE, this.updateCanvas);
            this.scrollTab.startDrag(false, new Rectangle(0, 0, this.bg.width - this.scrollTab.width, 0));
        }

        private function stopScrollDrag():void
        {
            this.dragging = false;
            this.scrollTab.stopDrag();
        }

        public function die():void
        {
            stage.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.updateCanvas);
            removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
        }
    }
}
