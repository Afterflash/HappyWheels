package
{
    import flash.display.MovieClip;

    [Embed(source="/_assets/assets.swf", symbol="symbol65")]
    public dynamic class MouseClickMC extends MovieClip
    {
        public function MouseClickMC()
        {
            super();
            addFrameScript(15, this.frame16);
        }

        internal function frame16():*
        {
            if (parent)
            {
                parent.removeChild(this);
            }
        }
    }
}
