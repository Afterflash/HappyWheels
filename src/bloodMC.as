package
{
    import flash.display.MovieClip;

    [Embed(source="/_assets/assets.swf", symbol="symbol351")]
    public dynamic class bloodMC extends MovieClip
    {
        public function bloodMC()
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
