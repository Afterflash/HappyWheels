package com.totaljerkface.game.editor.ui
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;

    [Embed(source="/_assets/assets.swf", symbol="symbol686")]
    public class Window extends Sprite
    {
        public static const WINDOW_CLOSED:String = "windowClosed";

        public var frame:Sprite;

        public var shadow:Sprite;

        public var closeButton:Sprite;

        public var content:Sprite;

        private var verticalSpace:int = 17;

        private var horizontalSpace:int = 4;

        private var border:int = 2;

        private var stageCover:Sprite;

        public function Window(param1:Boolean = true, param2:Sprite = null, param3:Boolean = false)
        {
            super();
            if (param2)
            {
                this.populate(param2);
            }
            if (param3)
            {
                this.createStageCover();
            }
            if (!param1)
            {
                this.closeButton.visible = false;
            }
        }

        private function addListeners():void
        {
            this.frame.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
            this.frame.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            this.closeButton.addEventListener(MouseEvent.MOUSE_UP, this.closeWindow);
        }

        private function removeListeners():void
        {
            this.frame.removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
            this.frame.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            this.closeButton.removeEventListener(MouseEvent.MOUSE_UP, this.closeWindow);
        }

        private function mouseDownHandler(param1:Event):void
        {
            startDrag();
        }

        private function mouseUpHandler(param1:Event):void
        {
            stopDrag();
        }

        public function populate(param1:Sprite):*
        {
            this.content = param1;
            addChild(param1);
            param1.x = this.horizontalSpace - this.border;
            param1.y = this.verticalSpace - this.border;
            this.resize();
            this.addListeners();
        }

        public function resize():void
        {
            this.frame.width = Math.max(10, this.content.width) + this.horizontalSpace;
            this.frame.height = Math.max(10, this.content.height) + this.verticalSpace;
            this.shadow.width = this.frame.width;
            this.shadow.height = this.frame.height;
            this.closeButton.x = this.frame.width - 11;
        }

        public function setDimensions(param1:Number, param2:Number):void
        {
            this.frame.width = Math.max(10, param1) + this.horizontalSpace;
            this.frame.height = Math.max(10, param2) + this.verticalSpace;
            this.shadow.width = this.frame.width;
            this.shadow.height = this.frame.height;
            this.closeButton.x = this.frame.width - 11;
        }

        public function closeWindow(param1:MouseEvent = null):*
        {
            if (this.content)
            {
                removeChild(this.content);
                this.content = null;
            }
            if (parent)
            {
                parent.removeChild(this);
            }
            this.removeListeners();
            dispatchEvent(new Event(WINDOW_CLOSED, true));
        }

        private function createStageCover():void
        {
            this.stageCover = new Sprite();
            addChildAt(this.stageCover, 0);
            this.stageCover.graphics.beginFill(0, 0.5);
            this.stageCover.graphics.drawRect(-1000, -500, 3000, 1500);
            this.stageCover.graphics.endFill();
        }

        override public function get width():Number
        {
            return this.frame.width;
        }

        override public function get height():Number
        {
            return this.frame.height;
        }

        public function center():void
        {
            x = Math.round((stage.stageWidth - this.frame.width) / 2);
            y = Math.round((stage.stageHeight - this.frame.height) / 2);
        }
    }
}
