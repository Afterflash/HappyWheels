package
{
    import flash.display.MovieClip;

    [Embed(source="/_assets/assets.swf", symbol="symbol680")]
    public dynamic class VanBodyMC extends MovieClip
    {
        public function VanBodyMC()
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
