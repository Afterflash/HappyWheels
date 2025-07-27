package
{
    import flash.display.MovieClip;

    [Embed(source="/_assets/assets.swf", symbol="symbol2888")]
    public dynamic class MuzzleFlare extends MovieClip
    {
        public function MuzzleFlare()
        {
            super();
            addFrameScript(22, this.frame23);
        }

        internal function frame23():*
        {
            stop();
            this.parent.removeChild(this);
        }
    }
}
