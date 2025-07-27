package com.totaljerkface.game.level.userspecials
{
    import Box2D.Common.Math.b2Vec2;
    import com.totaljerkface.game.editor.specials.Special;
    import com.totaljerkface.game.level.LevelItem;
    
    public class Wheel extends LevelItem
    {
        public function Wheel(param1:Special)
        {
            super();
            this.createBody(new b2Vec2(param1.x,param1.y));
        }
        
        internal function createBody(param1:b2Vec2) : void
        {
            trace("I\'M A WHEEL");
        }
    }
}

