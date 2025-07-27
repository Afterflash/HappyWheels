package com.totaljerkface.game.editor
{
    import Box2D.Common.Math.b2Vec2;
    import com.totaljerkface.game.editor.vertedit.*;
    import flash.display.*;
    
    public class PolygonShape extends EdgeShape
    {
        public function PolygonShape(param1:Boolean = true, param2:Boolean = true, param3:Boolean = false, param4:Number = 1, param5:uint = 4032711, param6:int = -1, param7:Number = 100, param8:int = 1)
        {
            _vertContainer = new Sprite();
            super(param1,param2,param3,param4,param5,param6,param7,param8);
            scalable = true;
            minDimension = 0.1;
            maxDimension = 10;
            name = "polygon shape";
            doubleClickEnabled = true;
        }
        
        override public function setAttributes() : void
        {
            if(_interactive)
            {
                _attributes = ["x","y","shapeWidth","shapeHeight","angle","color","outlineColor","opacity","immovable","collision"];
            }
            else
            {
                _attributes = ["x","y","shapeWidth","shapeHeight","angle","color","outlineColor","opacity"];
            }
            addTriggerProperties();
        }
        
        override public function get functions() : Array
        {
            var _loc1_:Array = new Array();
            _loc1_.push("reverseShape");
            _loc1_.push("resetScale");
            if(groupable)
            {
                _loc1_.push("groupSelected");
            }
            return _loc1_;
        }
        
        override public function drawEditMode(param1:b2Vec2, param2:Boolean, param3:Boolean = false) : void
        {
            var _loc7_:Vert = null;
            var _loc8_:int = 0;
            var _loc9_:Vert = null;
            var _loc10_:Vert = null;
            var _loc11_:Vert = null;
            graphics.clear();
            var _loc4_:Vector.<int> = new Vector.<int>();
            var _loc5_:Vector.<Number> = new Vector.<Number>();
            graphics.lineStyle(0,0,_opacity,false);
            if(outlineColor >= 0)
            {
                graphics.lineStyle(0,_outlineColor,_opacity,false);
            }
            if(param2)
            {
                graphics.beginFill(_color,_opacity);
            }
            var _loc6_:int = _vertContainer.numChildren;
            if(_loc6_ > 0)
            {
                _loc7_ = _vertContainer.getChildAt(0) as Vert;
                _loc4_.push(GraphicsPathCommand.MOVE_TO);
                _loc5_.push(_loc7_.x);
                _loc5_.push(_loc7_.y);
                _loc8_ = 1;
                while(_loc8_ < _loc6_)
                {
                    _loc9_ = _vertContainer.getChildAt(_loc8_) as Vert;
                    _loc4_.push(GraphicsPathCommand.LINE_TO);
                    _loc5_.push(_loc9_.x,_loc9_.y);
                    _loc7_ = _loc9_;
                    _loc8_++;
                }
            }
            if(param1)
            {
                graphics.lineStyle(0,0,0.5,false);
                _loc10_ = _vertContainer.getChildAt(_vertContainer.numChildren - 1) as Vert;
                _loc11_ = _vertContainer.getChildAt(0) as Vert;
                if(param2)
                {
                    _loc4_.push(GraphicsPathCommand.LINE_TO);
                    _loc5_.push(param1.x,param1.y);
                    graphics.drawPath(_loc4_,_loc5_,GraphicsPathWinding.EVEN_ODD);
                    graphics.endFill();
                }
                else
                {
                    if(param3)
                    {
                        _loc4_.push(GraphicsPathCommand.LINE_TO);
                        _loc5_.push(param1.x,param1.y);
                    }
                    graphics.drawPath(_loc4_,_loc5_,GraphicsPathWinding.NON_ZERO);
                }
            }
            else
            {
                graphics.drawPath(_loc4_,_loc5_,GraphicsPathWinding.NON_ZERO);
                if(param2)
                {
                    graphics.endFill();
                }
            }
        }
        
        override protected function drawShape() : void
        {
            var _loc4_:b2Vec2 = null;
            var _loc5_:int = 0;
            graphics.clear();
            var _loc1_:Vector.<int> = new Vector.<int>();
            var _loc2_:Vector.<Number> = new Vector.<Number>();
            if(outlineColor >= 0)
            {
                graphics.lineStyle(0,_outlineColor,_opacity,true);
            }
            graphics.beginFill(_color,_opacity);
            var _loc3_:int = int(_vertVector.length);
            if(_loc3_ > 0)
            {
                _loc4_ = _vertVector[0];
                _loc1_.push(GraphicsPathCommand.MOVE_TO);
                _loc2_.push(_loc4_.x);
                _loc2_.push(_loc4_.y);
                _loc5_ = 1;
                while(_loc5_ < _loc3_)
                {
                    _loc4_ = _vertVector[_loc5_];
                    _loc1_.push(GraphicsPathCommand.LINE_TO);
                    _loc2_.push(_loc4_.x);
                    _loc2_.push(_loc4_.y);
                    _loc5_++;
                }
                _loc4_ = _vertVector[0];
                _loc1_.push(GraphicsPathCommand.LINE_TO);
                _loc2_.push(_loc4_.x);
                _loc2_.push(_loc4_.y);
                graphics.drawPath(_loc1_,_loc2_,GraphicsPathWinding.NON_ZERO);
                graphics.endFill();
                setDefaultDimensions();
            }
        }
        
        override public function getFlatSprite() : Sprite
        {
            var _loc1_:Sprite = null;
            _loc1_ = new Sprite();
            if(_opacity == 0 || _outlineColor < 0 && _color < 0)
            {
                _loc1_.visible = false;
            }
            if(_outlineColor >= 0)
            {
                _loc1_.graphics.lineStyle(0,_outlineColor,1,true);
            }
            if(_color >= 0)
            {
                _loc1_.graphics.beginFill(_color,1);
            }
            var _loc2_:Vector.<int> = new Vector.<int>();
            var _loc3_:Vector.<Number> = new Vector.<Number>();
            var _loc4_:b2Vec2 = _vertVector[0];
            _loc2_.push(GraphicsPathCommand.MOVE_TO);
            _loc3_.push(_loc4_.x);
            _loc3_.push(_loc4_.y);
            var _loc5_:int = int(_vertVector.length);
            var _loc6_:int = 1;
            while(_loc6_ < _loc5_)
            {
                _loc4_ = _vertVector[_loc6_];
                _loc2_.push(GraphicsPathCommand.LINE_TO);
                _loc3_.push(_loc4_.x);
                _loc3_.push(_loc4_.y);
                _loc6_++;
            }
            _loc4_ = _vertVector[0];
            _loc2_.push(GraphicsPathCommand.LINE_TO);
            _loc3_.push(_loc4_.x);
            _loc3_.push(_loc4_.y);
            _loc1_.graphics.drawPath(_loc2_,_loc3_,GraphicsPathWinding.NON_ZERO);
            _loc1_.graphics.endFill();
            _loc1_.x = x;
            _loc1_.y = y;
            _loc1_.scaleX = scaleX;
            _loc1_.scaleY = scaleY;
            _loc1_.rotation = rotation;
            _loc1_.alpha = _opacity;
            return _loc1_;
        }
        
        public function getCenteredSprite(param1:b2Vec2) : Sprite
        {
            var _loc2_:Sprite = null;
            _loc2_ = new Sprite();
            if(_opacity == 0 || _outlineColor < 0 && _color < 0)
            {
                _loc2_.visible = false;
            }
            if(outlineColor >= 0)
            {
                _loc2_.graphics.lineStyle(0,_outlineColor,1,true);
            }
            if(color >= 0)
            {
                _loc2_.graphics.beginFill(_color,1);
            }
            var _loc3_:Vector.<int> = new Vector.<int>();
            var _loc4_:Vector.<Number> = new Vector.<Number>();
            var _loc5_:b2Vec2 = _vertVector[0];
            _loc3_.push(GraphicsPathCommand.MOVE_TO);
            _loc4_.push(scaleX * _loc5_.x - param1.x);
            _loc4_.push(scaleY * _loc5_.y - param1.y);
            var _loc6_:int = int(_vertVector.length);
            var _loc7_:int = 1;
            while(_loc7_ < _loc6_)
            {
                _loc5_ = _vertVector[_loc7_];
                _loc3_.push(GraphicsPathCommand.LINE_TO);
                _loc4_.push(scaleX * _loc5_.x - param1.x);
                _loc4_.push(scaleY * _loc5_.y - param1.y);
                _loc7_++;
            }
            _loc5_ = _loc5_ = _vertVector[0];
            _loc3_.push(GraphicsPathCommand.LINE_TO);
            _loc4_.push(scaleX * _loc5_.x - param1.x);
            _loc4_.push(scaleY * _loc5_.y - param1.y);
            _loc2_.graphics.drawPath(_loc3_,_loc4_,GraphicsPathWinding.NON_ZERO);
            _loc2_.graphics.endFill();
            _loc2_.x = x;
            _loc2_.y = y;
            _loc2_.rotation = rotation;
            _loc2_.alpha = _opacity;
            return _loc2_;
        }
        
        override public function clone() : RefSprite
        {
            var _loc4_:b2Vec2 = null;
            var _loc1_:PolygonShape = new PolygonShape(interactive,immovable,sleeping,density,color,outlineColor,opacity,collision);
            var _loc2_:int = numVerts;
            var _loc3_:int = 0;
            while(_loc3_ < _loc2_)
            {
                _loc4_ = _vertVector[_loc3_].Copy();
                _loc1_.vertVector.push(_loc4_);
                _loc3_++;
            }
            _loc1_.completeFill = completeFill;
            _loc1_.drawShape();
            _loc1_.vID = vID;
            _loc1_.scaleY = scaleY;
            _loc1_.scaleX = scaleX;
            _loc1_.angle = angle;
            _loc1_.x = x;
            _loc1_.y = y;
            _loc1_.vehicleHandle = vehicleHandle;
            transferKeyedProperties(_loc1_);
            return _loc1_;
        }
        
        override public function set vID(param1:int) : void
        {
            _vID = param1;
            PolygonTool.updateIdCounter(param1);
        }
    }
}

