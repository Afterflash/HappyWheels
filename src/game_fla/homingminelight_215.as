package game_fla
{
    import flash.display.MovieClip;

    [Embed(source="/_assets/assets.swf", symbol="symbol2621")]
    public dynamic class homingminelight_215 extends MovieClip
    {
        public function homingminelight_215()
        {
            super();
            addFrameScript(0, this.frame1, 6, this.frame7);
        }

        internal function frame1():*
        {
            stop();
        }

        internal function frame7():*
        {
            gotoAndPlay(5);
        }
    }
}
