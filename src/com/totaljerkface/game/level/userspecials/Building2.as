package com.totaljerkface.game.level.userspecials
{
    import Box2D.Collision.Shapes.b2PolygonDef;
    import Box2D.Common.Math.b2Vec2;
    import com.totaljerkface.game.BitmapManager;
    import com.totaljerkface.game.Settings;
    import com.totaljerkface.game.editor.specials.Building2Ref;
    import com.totaljerkface.game.editor.specials.Special;
    import com.totaljerkface.game.level.LevelItem;
    import flash.display.Sprite;
    import flash.geom.Matrix;
    
    public class Building2 extends LevelItem
    {
        private var sprite:Sprite;
        
        public function Building2(param1:Special)
        {
            var _loc2_:Building2Ref = null;
            var _loc4_:Number = NaN;
            var _loc6_:Number = NaN;
            var _loc7_:Number = NaN;
            super();
            _loc2_ = param1 as Building2Ref;
            var _loc3_:b2PolygonDef = new b2PolygonDef();
            _loc3_.friction = 0.3;
            _loc3_.restitution = 0.1;
            _loc3_.filter.categoryBits = 8;
            _loc4_ = _loc2_.floorWidth * 500 + 226;
            var _loc5_:Number = _loc2_.numFloors * 180 + 120;
            _loc6_ = 0;
            _loc7_ = 0;
            var _loc8_:b2Vec2 = new b2Vec2(_loc2_.x + _loc6_ + _loc4_ * 0.5,_loc2_.y + _loc7_ + _loc5_ * 0.5);
            _loc3_.SetAsOrientedBox(_loc4_ * 0.5 / m_physScale,_loc5_ * 0.5 / m_physScale,new b2Vec2(_loc8_.x / m_physScale,_loc8_.y / m_physScale),0);
            Settings.currentSession.level.levelBody.CreateShape(_loc3_);
            var _loc9_:BitmapManager = BitmapManager.instance;
            this.sprite = new Sprite();
            this.sprite.x = param1.x;
            this.sprite.y = param1.y;
            var _loc10_:Matrix = new Matrix(1,0,0,1,_loc6_,_loc7_);
            this.sprite.graphics.beginBitmapFill(_loc9_.getTexture(Building2Ref.B2_ROOF),_loc10_,true,false);
            this.sprite.graphics.drawRect(_loc6_,_loc7_,_loc4_,120);
            this.sprite.graphics.endFill();
            _loc7_ += 120;
            _loc10_ = new Matrix(1,0,0,1,_loc6_,_loc7_);
            this.sprite.graphics.beginBitmapFill(_loc9_.getTexture(Building2Ref.B2_FLOOR),_loc10_,true,false);
            this.sprite.graphics.drawRect(_loc6_,_loc7_,_loc4_,180 * _loc2_.numFloors);
            this.sprite.graphics.endFill();
            var _loc11_:Sprite = Settings.currentSession.level.background;
            _loc11_.addChild(this.sprite);
        }
    }
}

