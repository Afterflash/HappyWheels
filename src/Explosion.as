package
{
    import flash.display.MovieClip;

    [Embed(source="/_assets/assets.swf", symbol="symbol241")]
    public dynamic class Explosion extends MovieClip
    {
        public function Explosion()
        {
            super();
            addFrameScript(47, this.frame48);
        }

        internal function frame48():*
        {
            stop();
            this.parent.removeChild(this);
        }
    }
}
