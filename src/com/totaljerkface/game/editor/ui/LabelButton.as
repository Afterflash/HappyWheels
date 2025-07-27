package com.totaljerkface.game.editor.ui
{
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFormat;

    [Embed(source="/_assets/assets.swf", symbol="symbol789")]
    public class LabelButton extends Sprite
    {
        public var labelText:TextField;

        public var inner:MovieClip;

        private var startY:Number;

        private var regularFormat:TextFormat;

        private var hiliteFormat:TextFormat;

        public function LabelButton(param1:String = "")
        {
            super();
            if (param1 != "")
            {
                this.labelText.text = param1;
            }
            this.init();
        }

        private function init():void
        {
            trace("label init");
            mouseChildren = false;
            this.regularFormat = new TextFormat();
            this.regularFormat.color = 16777215;
            this.hiliteFormat = new TextFormat();
            this.hiliteFormat.color = 13260;
            this.startY = this.labelText.y;
            this.labelText.setTextFormat(this.regularFormat);
            addEventListener(MouseEvent.MOUSE_OVER, this.mouseOverHandler, false, 0, false);
            addEventListener(MouseEvent.MOUSE_OUT, this.mouseOutHandler, false, 0, false);
            addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler, false, 0, false);
            addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler, false, 0, false);
        }

        private function mouseOverHandler(param1:MouseEvent):void
        {
            this.labelText.setTextFormat(this.hiliteFormat);
            if (param1.buttonDown)
            {
                this.mouseDownHandler();
            }
        }

        private function mouseOutHandler(param1:MouseEvent):void
        {
            this.labelText.setTextFormat(this.regularFormat);
            this.mouseUpHandler();
        }

        private function mouseDownHandler(param1:MouseEvent = null):void
        {
            this.inner.gotoAndStop(2);
            this.labelText.y = this.startY + 1;
        }

        private function mouseUpHandler(param1:MouseEvent = null):void
        {
            this.labelText.y = this.startY;
            this.inner.gotoAndStop(1);
        }
    }
}
