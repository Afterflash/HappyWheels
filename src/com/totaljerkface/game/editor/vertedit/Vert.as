package com.totaljerkface.game.editor.vertedit
{
    import Box2D.Common.Math.b2Vec2;
    import com.totaljerkface.game.editor.EdgeShape;
    import com.totaljerkface.game.editor.Editor;
    import flash.display.Sprite;
    import flash.geom.Matrix;
    
    public class Vert extends Sprite
    {
        protected var _vec:b2Vec2;
        
        protected var _selected:Boolean;
        
        protected var _sprite:Sprite;
        
        protected var _edgeShape:EdgeShape;
        
        public function Vert(param1:Number = 0, param2:Number = 0)
        {
            super();
            this._vec = new b2Vec2();
            this.x = param1;
            this.y = param2;
            this._sprite = new Sprite();
            this._sprite.mouseEnabled = false;
            addChild(this._sprite);
        }
        
        public function drawSelf() : void
        {
            var _loc3_:Matrix = null;
            graphics.clear();
            this._sprite.graphics.clear();
            var _loc1_:Number = 0;
            var _loc2_:uint = this._selected ? 16777215 : 0;
            this._sprite.graphics.lineStyle(0,_loc1_,1);
            this._sprite.graphics.beginFill(_loc2_,0.5);
            if(this._edgeShape)
            {
                _loc3_ = new Matrix();
                _loc3_.rotate(-this._edgeShape.rotation * Math.PI / 180);
                _loc3_.scale(1 / (this._edgeShape.scaleX * Math.pow(2,Editor.currentZoom)),1 / (this._edgeShape.scaleY * Math.pow(2,Editor.currentZoom)));
                this._sprite.transform.matrix = _loc3_;
            }
            this._sprite.graphics.drawCircle(0,0,3);
            this._sprite.graphics.endFill();
        }
        
        public function get position() : b2Vec2
        {
            return new b2Vec2(x,y);
        }
        
        public function get selected() : Boolean
        {
            return this._selected;
        }
        
        public function set selected(param1:Boolean) : void
        {
            this._selected = param1;
            this.drawSelf();
        }
        
        public function get edgeShape() : EdgeShape
        {
            return this._edgeShape;
        }
        
        public function set edgeShape(param1:EdgeShape) : void
        {
            this._edgeShape = param1;
            this.drawSelf();
        }
        
        public function clone() : Vert
        {
            var _loc1_:Vert = new Vert();
            _loc1_.x = x;
            _loc1_.y = y;
            return _loc1_;
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

