package Box2D.Dynamics
{
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.Contacts.*;
    import flash.display.Sprite;
    
    public class b2DebugDraw
    {
        public static var e_shapeBit:uint = 1;
        
        public static var e_jointBit:uint = 2;
        
        public static var e_coreShapeBit:uint = 4;
        
        public static var e_aabbBit:uint = 8;
        
        public static var e_obbBit:uint = 16;
        
        public static var e_pairBit:uint = 32;
        
        public static var e_centerOfMassBit:uint = 64;
        
        public var m_drawFlags:uint;
        
        public var m_sprite:Sprite;
        
        public var m_drawScale:Number = 1;
        
        public var m_lineThickness:Number = 1;
        
        public var m_alpha:Number = 1;
        
        public var m_fillAlpha:Number = 1;
        
        public var m_xformScale:Number = 1;
        
        public function b2DebugDraw()
        {
            super();
            this.m_drawFlags = 0;
        }
        
        public function SetFlags(param1:uint) : void
        {
            this.m_drawFlags = param1;
        }
        
        public function GetFlags() : uint
        {
            return this.m_drawFlags;
        }
        
        public function AppendFlags(param1:uint) : void
        {
            this.m_drawFlags |= param1;
        }
        
        public function ClearFlags(param1:uint) : void
        {
            this.m_drawFlags &= ~param1;
        }
        
        public function DrawPolygon(param1:Array, param2:int, param3:b2Color) : void
        {
            this.m_sprite.graphics.lineStyle(this.m_lineThickness,param3.color,this.m_alpha);
            this.m_sprite.graphics.moveTo(param1[0].x * this.m_drawScale,param1[0].y * this.m_drawScale);
            var _loc4_:int = 1;
            while(_loc4_ < param2)
            {
                this.m_sprite.graphics.lineTo(param1[_loc4_].x * this.m_drawScale,param1[_loc4_].y * this.m_drawScale);
                _loc4_++;
            }
            this.m_sprite.graphics.lineTo(param1[0].x * this.m_drawScale,param1[0].y * this.m_drawScale);
        }
        
        public function DrawSolidPolygon(param1:Array, param2:int, param3:b2Color) : void
        {
            this.m_sprite.graphics.lineStyle(this.m_lineThickness,param3.color,this.m_alpha);
            this.m_sprite.graphics.moveTo(param1[0].x * this.m_drawScale,param1[0].y * this.m_drawScale);
            this.m_sprite.graphics.beginFill(param3.color,this.m_fillAlpha);
            var _loc4_:int = 1;
            while(_loc4_ < param2)
            {
                this.m_sprite.graphics.lineTo(param1[_loc4_].x * this.m_drawScale,param1[_loc4_].y * this.m_drawScale);
                _loc4_++;
            }
            this.m_sprite.graphics.lineTo(param1[0].x * this.m_drawScale,param1[0].y * this.m_drawScale);
            this.m_sprite.graphics.endFill();
        }
        
        public function DrawCircle(param1:b2Vec2, param2:Number, param3:b2Color) : void
        {
            this.m_sprite.graphics.lineStyle(this.m_lineThickness,param3.color,this.m_alpha);
            this.m_sprite.graphics.drawCircle(param1.x * this.m_drawScale,param1.y * this.m_drawScale,param2 * this.m_drawScale);
        }
        
        public function DrawSolidCircle(param1:b2Vec2, param2:Number, param3:b2Vec2, param4:b2Color) : void
        {
            this.m_sprite.graphics.lineStyle(this.m_lineThickness,param4.color,this.m_alpha);
            this.m_sprite.graphics.moveTo(0,0);
            this.m_sprite.graphics.beginFill(param4.color,this.m_fillAlpha);
            this.m_sprite.graphics.drawCircle(param1.x * this.m_drawScale,param1.y * this.m_drawScale,param2 * this.m_drawScale);
            this.m_sprite.graphics.endFill();
            this.m_sprite.graphics.moveTo(param1.x * this.m_drawScale,param1.y * this.m_drawScale);
            this.m_sprite.graphics.lineTo((param1.x + param3.x * param2) * this.m_drawScale,(param1.y + param3.y * param2) * this.m_drawScale);
        }
        
        public function DrawSegment(param1:b2Vec2, param2:b2Vec2, param3:b2Color) : void
        {
            this.m_sprite.graphics.lineStyle(this.m_lineThickness,param3.color,this.m_alpha);
            this.m_sprite.graphics.moveTo(param1.x * this.m_drawScale,param1.y * this.m_drawScale);
            this.m_sprite.graphics.lineTo(param2.x * this.m_drawScale,param2.y * this.m_drawScale);
        }
        
        public function DrawXForm(param1:b2XForm) : void
        {
            this.m_sprite.graphics.lineStyle(this.m_lineThickness,16711680,this.m_alpha);
            this.m_sprite.graphics.moveTo(param1.position.x * this.m_drawScale,param1.position.y * this.m_drawScale);
            this.m_sprite.graphics.lineTo((param1.position.x + this.m_xformScale * param1.R.col1.x) * this.m_drawScale,(param1.position.y + this.m_xformScale * param1.R.col1.y) * this.m_drawScale);
            this.m_sprite.graphics.lineStyle(this.m_lineThickness,65280,this.m_alpha);
            this.m_sprite.graphics.moveTo(param1.position.x * this.m_drawScale,param1.position.y * this.m_drawScale);
            this.m_sprite.graphics.lineTo((param1.position.x + this.m_xformScale * param1.R.col2.x) * this.m_drawScale,(param1.position.y + this.m_xformScale * param1.R.col2.y) * this.m_drawScale);
        }
    }
}

