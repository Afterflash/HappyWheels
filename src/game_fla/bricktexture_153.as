package game_fla
{
    import adobe.utils.*;
    import flash.accessibility.*;
    import flash.desktop.*;
    import flash.display.*;
    import flash.errors.*;
    import flash.events.*;
    import flash.external.*;
    import flash.filters.*;
    import flash.geom.*;
    import flash.globalization.*;
    import flash.media.*;
    import flash.net.*;
    import flash.net.drm.*;
    import flash.printing.*;
    import flash.profiler.*;
    import flash.sampler.*;
    import flash.sensors.*;
    import flash.system.*;
    import flash.text.*;
    import flash.text.engine.*;
    import flash.text.ime.*;
    import flash.ui.*;
    import flash.utils.*;
    import flash.xml.*;

    [Embed(source="/_assets/assets.swf", symbol="symbol2768")]
    public dynamic class bricktexture_153 extends MovieClip
    {
        public var b35:MovieClip;

        public var b26:MovieClip;

        public var b17:MovieClip;

        public var b36:MovieClip;

        public var b27:MovieClip;

        public var b18:MovieClip;

        public var b37:MovieClip;

        public var b28:MovieClip;

        public var b19:MovieClip;

        public var b38:MovieClip;

        public var b29:MovieClip;

        public var b39:MovieClip;

        public var b40:MovieClip;

        public var b41:MovieClip;

        public var b1:MovieClip;

        public var b42:MovieClip;

        public var b2:MovieClip;

        public var b43:MovieClip;

        public var b3:MovieClip;

        public var b44:MovieClip;

        public var b4:MovieClip;

        public var b45:MovieClip;

        public var b10:MovieClip;

        public var b5:MovieClip;

        public var b20:MovieClip;

        public var b11:MovieClip;

        public var b6:MovieClip;

        public var b30:MovieClip;

        public var b21:MovieClip;

        public var b12:MovieClip;

        public var b7:MovieClip;

        public var b31:MovieClip;

        public var b22:MovieClip;

        public var b13:MovieClip;

        public var b8:MovieClip;

        public var b32:MovieClip;

        public var b23:MovieClip;

        public var b14:MovieClip;

        public var b9:MovieClip;

        public var b33:MovieClip;

        public var b24:MovieClip;

        public var b15:MovieClip;

        public var b34:MovieClip;

        public var b25:MovieClip;

        public var b16:MovieClip;

        public function bricktexture_153()
        {
            super();
            addFrameScript(0, this.frame1);
        }

        public function randomize():*
        {
            var _loc2_:MovieClip = null;
            var _loc1_:int = 1;
            while (_loc1_ < 46)
            {
                _loc2_ = this["b" + _loc1_];
                _loc2_.gotoAndStop(Math.ceil(Math.random() * 9));
                _loc1_++;
            }
        }

        internal function frame1():*
        {
        }
    }
}
