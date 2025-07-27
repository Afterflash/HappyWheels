package
{
    import flash.display.MovieClip;

    [Embed(source="/_assets/assets.swf", symbol="symbol195")]
    public dynamic class Explosion2 extends MovieClip
    {
        public function Explosion2()
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
