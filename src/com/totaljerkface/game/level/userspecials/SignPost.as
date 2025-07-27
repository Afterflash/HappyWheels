package com.totaljerkface.game.level.userspecials
{
    import Box2D.Dynamics.b2Body;
    import com.totaljerkface.game.Settings;
    import com.totaljerkface.game.editor.specials.SignPostRef;
    import com.totaljerkface.game.editor.specials.Special;
    import com.totaljerkface.game.level.LevelB2D;
    import com.totaljerkface.game.level.LevelItem;
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.geom.Point;
    
    public class SignPost extends LevelItem
    {
        private var mc:MovieClip;
        
        public function SignPost(param1:Special, param2:b2Body = null, param3:Point = null)
        {
            var _loc7_:MovieClip = null;
            super();
            var _loc4_:SignPostRef = param1 as SignPostRef;
            _loc4_ = _loc4_.clone() as SignPostRef;
            var _loc5_:LevelB2D = Settings.currentSession.level;
            var _loc6_:Sprite = _loc5_.background;
            this.mc = new SignMC();
            this.mc.gotoAndStop(_loc4_.signPostType);
            _loc6_.addChild(this.mc);
            this.mc.x = param1.x;
            this.mc.y = param1.y;
            if(_loc4_.signPost)
            {
                _loc7_ = new PostMC();
                this.mc.addChildAt(_loc7_,0);
            }
            this.mc.rotation = _loc4_.rotation;
        }
        
        override public function get groupDisplayObject() : DisplayObject
        {
            return this.mc;
        }
    }
}

