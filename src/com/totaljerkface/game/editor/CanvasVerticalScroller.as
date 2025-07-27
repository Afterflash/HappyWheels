package com.totaljerkface.game.editor
{
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;

    [Embed(source="/_assets/assets.swf", symbol="symbol826")]
    public class CanvasVerticalScroller extends Sprite
    {
        public var scrollTab:Sprite;

        public var bg:Sprite;

        private var container:Sprite;

        private var canvasHolder:Sprite;

        private var totalHeight:int = 500;

        private var spacing:int;

        private var dragging:Boolean;

        public function CanvasVerticalScroller(param1:Sprite, param2:Sprite, param3:int)
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
            _loc1_ = this.canvasHolder.scaleY * Canvas.canvasHeight + this.spacing * 2;
            var _loc2_:Number = this.totalHeight / _loc1_;
            if (_loc2_ > 1)
            {
                visible = false;
                return;
            }
            visible = true;
            this.scrollTab.height = _loc2_ * this.bg.height;
            this.scrollTab.y = (this.canvasHolder.y - this.spacing) * -this.bg.height / _loc1_;
        }

        private function updateCanvas(param1:MouseEvent = null):void
        {
            var _loc2_:Number = this.canvasHolder.scaleY * Canvas.canvasHeight + this.spacing * 2;
            this.canvasHolder.y = this.scrollTab.y * _loc2_ / -this.bg.height + this.spacing;
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
            if (this.bg.mouseY > this.scrollTab.y)
            {
                this.scrollTab.y += this.scrollTab.height;
                if (this.scrollTab.y + this.scrollTab.height > this.bg.height)
                {
                    this.scrollTab.y = this.bg.height - this.scrollTab.height;
                }
            }
            else
            {
                this.scrollTab.y -= this.scrollTab.height;
                if (this.scrollTab.y < 0)
                {
                    this.scrollTab.y = 0;
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
            this.scrollTab.startDrag(false, new Rectangle(0, 0, 0, this.bg.height - this.scrollTab.height));
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
