package com.totaljerkface.game.editor.ui
{
    import flash.display.MovieClip;
    import flash.text.TextField;

    [Embed(source="/_assets/assets.swf", symbol="symbol768")]
    public dynamic class MenuItem extends MovieClip
    {
        public var labelText:TextField;

        public var inner:MovieClip;

        public function MenuItem()
        {
            super();
        }
    }
}
