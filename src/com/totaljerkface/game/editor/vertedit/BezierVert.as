package com.totaljerkface.game.editor.vertedit
{
    import Box2D.Common.Math.b2Vec2;
    import com.totaljerkface.game.editor.Editor;
    import flash.geom.Matrix;
    
    public class BezierVert extends Vert
    {
        private var _handle1:BezierHandle;
        
        private var _handle2:BezierHandle;
        
        public function BezierVert(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Number = 0, param6:Number = 0)
        {
            super(param1,param2);
            this._handle1 = new BezierHandle(this);
            this._handle2 = new BezierHandle(this);
            addChild(this._handle1);
            addChild(this._handle2);
            this._handle1.Set(param3,param4);
            this._handle2.Set(param5,param6);
            this._handle1.visible = false;
            this._handle2.visible = false;
            doubleClickEnabled = true;
        }
        
        override public function drawSelf() : void
        {
            var _loc5_:Matrix = null;
            graphics.clear();
            _sprite.graphics.clear();
            var _loc1_:Number = 0;
            var _loc2_:uint = _selected ? 16777215 : 0;
            _sprite.graphics.lineStyle(0,_loc1_,1);
            _sprite.graphics.beginFill(_loc2_,0.5);
            if(_edgeShape)
            {
                _loc5_ = new Matrix();
                _loc5_.rotate(-_edgeShape.rotation * Math.PI / 180);
                _loc5_.scale(1 / (_edgeShape.scaleX * Math.pow(2,Editor.currentZoom)),1 / (_edgeShape.scaleY * Math.pow(2,Editor.currentZoom)));
                _sprite.transform.matrix = _loc5_;
                this._handle1.circleSprite.transform.matrix = _loc5_;
                this._handle2.circleSprite.transform.matrix = _loc5_;
            }
            var _loc3_:Number = 5;
            var _loc4_:Number = _loc3_ * 0.5;
            _sprite.graphics.drawRect(-_loc4_,-_loc4_,_loc3_,_loc3_);
            _sprite.graphics.endFill();
        }
        
        public function drawArms(param1:Boolean = true, param2:Boolean = true) : void
        {
            this.drawSelf();
            graphics.lineStyle(0,0,1);
            if(param1 && !(this._handle1.x == 0 && this._handle1.y == 0))
            {
                graphics.moveTo(0,0);
                graphics.lineTo(this._handle1.x,this._handle1.y);
                this.handle1.drawSelf();
            }
            if(param2 && !(this._handle2.x == 0 && this._handle2.y == 0))
            {
                graphics.moveTo(0,0);
                graphics.lineTo(this._handle2.x,this._handle2.y);
                this.handle2.drawSelf();
            }
            this._handle1.visible = param1;
            this._handle2.visible = param2;
        }
        
        public function clearArms() : void
        {
            this.drawSelf();
            this._handle1.visible = false;
            this._handle2.visible = false;
            this._handle1.clearSelf();
            this._handle2.clearSelf();
        }
        
        public function get handle1() : BezierHandle
        {
            return this._handle1;
        }
        
        public function get handle2() : BezierHandle
        {
            return this._handle2;
        }
        
        public function get anchor1() : b2Vec2
        {
            return new b2Vec2(x + this._handle1.x,y + this._handle1.y);
        }
        
        public function get anchor2() : b2Vec2
        {
            return new b2Vec2(x + this._handle2.x,y + this._handle2.y);
        }
        
        override public function set selected(param1:Boolean) : void
        {
            _selected = param1;
            if(_selected)
            {
                this.drawArms(true,true);
            }
            else
            {
                this.clearArms();
            }
        }
        
        public function hasHandles() : Boolean
        {
            if(this._handle1.x == 0 && this._handle1.y == 0 && this._handle2.x == 0 && this._handle2.y == 0)
            {
                return false;
            }
            return true;
        }
        
        override public function clone() : Vert
        {
            var _loc1_:BezierVert = new BezierVert();
            _loc1_.x = x;
            _loc1_.y = y;
            _loc1_.handle1.Set(this.handle1.x,this.handle1.y);
            _loc1_.handle2.Set(this.handle2.x,this.handle2.y);
            return _loc1_;
        }
    }
}

