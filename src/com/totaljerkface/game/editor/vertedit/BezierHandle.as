package com.totaljerkface.game.editor.vertedit
{
    import Box2D.Common.Math.b2Vec2;
    import flash.display.Sprite;
    
    public class BezierHandle extends Sprite
    {
        private var _vec:b2Vec2;
        
        private var _vert:BezierVert;
        
        private var _circleSprite:Sprite;
        
        public function BezierHandle(param1:BezierVert, param2:Number = 0, param3:Number = 0)
        {
            super();
            this._vec = new b2Vec2();
            this._vert = param1;
            this.x = param2;
            this.y = param3;
            this._circleSprite = new Sprite();
            this._circleSprite.mouseEnabled = false;
            addChild(this._circleSprite);
        }
        
        public function drawSelf() : void
        {
            this._circleSprite.graphics.clear();
            this._circleSprite.graphics.beginFill(16777215,0.5);
            this._circleSprite.graphics.lineStyle(0,0,1);
            var _loc1_:Number = 3;
            this._circleSprite.graphics.drawCircle(0,0,_loc1_);
            this._circleSprite.graphics.endFill();
        }
        
        public function clearSelf() : void
        {
            this._circleSprite.graphics.clear();
        }
        
        public function get vert() : BezierVert
        {
            return this._vert;
        }
        
        public function Set(param1:Number, param2:Number) : void
        {
            this.x = param1;
            this.y = param2;
            if(x == 0 && y == 0)
            {
                this.clearSelf();
            }
            else
            {
                this.drawSelf();
            }
            if(this._vert)
            {
                this._vert.drawArms();
            }
        }
        
        public function get circleSprite() : Sprite
        {
            return this._circleSprite;
        }
        
        override public function set x(param1:Number) : void
        {
            super.x = param1;
            this._vec.x = x;
        }
        
        override public function set y(param1:Number) : void
        {
            super.y = param1;
            this._vec.y = y;
        }
        
        public function get vec() : b2Vec2
        {
            return this._vec;
        }
        
        public function set vec(param1:b2Vec2) : void
        {
            this._vec = param1;
            this.x = this._vec.x;
            this.y = this._vec.y;
        }
    }
}

