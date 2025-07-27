package game_fla
{
    import flash.display.MovieClip;

    [Embed(source="/_assets/assets.swf", symbol="symbol2790")]
    public dynamic class window1_159 extends MovieClip
    {
        public var ac:MovieClip;

        public var frameShadow:MovieClip;

        public var frame:MovieClip;

        public var bg:MovieClip;

        public var shade:MovieClip;

        public function window1_159()
        {
            super();
            addFrameScript(0, this.frame1);
        }

        public function randomize():*
        {
            var _loc1_:Number = Math.random();
            this.ac.visible = true;
            if (_loc1_ < 0.1)
            {
                this.frame.y = 16;
            }
            else
            {
                this.ac.visible = false;
                this.frame.y = Math.ceil(Math.random() * 86);
            }
            this.frameShadow.y = this.frame.y + 8;
            this.shade.scaleY = Math.random() * 0.8 + 0.2;
        }

        internal function frame1():*
        {
        }
    }
}
