package game_fla
{
    import flash.display.MovieClip;

    [Embed(source="/_assets/assets.swf", symbol="symbol1888")]
    public dynamic class pelvis_552 extends MovieClip
    {
        public var wound:MovieClip;

        public var shape:MovieClip;

        public var chunk1:MovieClip;

        public var chunk2:MovieClip;

        public var chunk3:MovieClip;

        public function pelvis_552()
        {
            super();
            addFrameScript(0, this.frame1);
        }

        internal function frame1():*
        {
            stop();
        }
    }
}
