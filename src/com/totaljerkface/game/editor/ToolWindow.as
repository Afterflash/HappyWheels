package com.totaljerkface.game.editor
{
    import flash.display.Sprite;

    [Embed(source="/_assets/assets.swf", symbol="symbol694")]
    public class ToolWindow extends Sprite
    {
        public var bg:Sprite;

        private var content:Tool;

        private var spacing:Number = 10;

        public function ToolWindow()
        {
            super();
            visible = false;
        }

        public function populate(param1:Tool):void
        {
            if (this.content)
            {
                if (this.content == param1)
                {
                    return;
                }
                this.content.deactivate();
                removeChild(this.content);
            }
            this.content = param1;
            addChild(this.content);
            this.content.y = this.spacing;
            this.bg.width = this.content.width;
            this.bg.height = this.content.height + this.spacing;
            this.content.activate();
            visible = true;
        }

        public function deactivateCurrent():void
        {
            if (this.content)
            {
                this.content.deactivate();
                removeChild(this.content);
            }
            visible = false;
        }
    }
}
