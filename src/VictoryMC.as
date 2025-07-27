package
{
    import flash.display.MovieClip;

    [Embed(source="/_assets/assets.swf", symbol="symbol86")]
    public dynamic class VictoryMC extends MovieClip
    {
        public var timeText:MovieClip;

        public function VictoryMC()
        {
            super();
            addFrameScript(15, this.frame16);
        }

        internal function frame16():*
        {
            stop();
        }
    }
}
