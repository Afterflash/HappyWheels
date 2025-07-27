package com.totaljerkface.game.editor.poser
{
    import Box2D.Common.Math.b2Math;
    import Box2D.Common.Math.b2Vec2;
    
    public class PoserSolver
    {
        private static const numIterations:int = 100;
        
        private static const distanceError:int = 1;
        
        private static const PIoverOneEighty:Number = Math.PI / 180;
        
        private static const PI_2:Number = Math.PI * 2;
        
        private static const dampingAngle:Number = Math.PI / 6;
        
        public function PoserSolver()
        {
            super();
        }
        
        public static function solve(param1:Number, param2:Number, param3:PoserSegment) : void
        {
            var _loc5_:PoserSegment = null;
            var _loc6_:Number = NaN;
            var _loc7_:Number = NaN;
            var _loc8_:b2Vec2 = null;
            var _loc9_:b2Vec2 = null;
            var _loc10_:b2Vec2 = null;
            var _loc11_:b2Vec2 = null;
            var _loc12_:Number = NaN;
            var _loc13_:Number = NaN;
            var _loc14_:Number = NaN;
            var _loc4_:int = 0;
            while(_loc4_ < numIterations)
            {
                _loc5_ = param3;
                while(_loc5_)
                {
                    _loc8_ = new b2Vec2(_loc5_.x,_loc5_.y);
                    _loc9_ = param3.endPoint;
                    _loc6_ = Math.abs(param1 - _loc9_.x);
                    _loc7_ = Math.abs(param2 - _loc9_.y);
                    if(_loc6_ < distanceError && _loc7_ < distanceError)
                    {
                        drawSegments(param3);
                        return;
                    }
                    _loc10_ = new b2Vec2(param1 - _loc8_.x,param2 - _loc8_.y);
                    _loc11_ = new b2Vec2(_loc9_.x - _loc8_.x,_loc9_.y - _loc8_.y);
                    _loc10_.Normalize();
                    _loc11_.Normalize();
                    _loc12_ = b2Math.b2Dot(_loc10_,_loc11_);
                    if(_loc12_ < 0.9999)
                    {
                        _loc13_ = b2Math.b2CrossVV(_loc10_,_loc11_);
                        if(_loc13_ > 0)
                        {
                            _loc14_ = Math.acos(_loc12_);
                            _loc5_.angle -= _loc14_;
                        }
                        else if(_loc13_ < 0)
                        {
                            _loc14_ = Math.acos(_loc12_);
                            _loc5_.angle += _loc14_;
                        }
                    }
                    _loc5_ = _loc5_.parentSegment;
                }
                _loc9_ = param3.endPoint;
                _loc6_ = Math.abs(param1 - _loc9_.x);
                _loc7_ = Math.abs(param2 - _loc9_.y);
                if(_loc6_ < distanceError && _loc7_ < distanceError)
                {
                    drawSegments(param3);
                    return;
                }
                _loc4_++;
            }
            drawSegments(param3);
        }
        
        private static function drawSegments(param1:PoserSegment) : void
        {
            while(param1)
            {
                param1.drawSegment();
                param1 = param1.parentSegment;
            }
        }
    }
}

