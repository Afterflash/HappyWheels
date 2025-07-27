package Box2D.Collision
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.*;
    import Box2D.Common.Math.*;
    
    public class b2Distance
    {
        private static var s_p1s:Array = [new b2Vec2(),new b2Vec2(),new b2Vec2()];
        
        private static var s_p2s:Array = [new b2Vec2(),new b2Vec2(),new b2Vec2()];
        
        private static var s_points:Array = [new b2Vec2(),new b2Vec2(),new b2Vec2()];
        
        private static var gPoint:b2Point = new b2Point();
        
        public static var g_GJK_Iterations:int = 0;
        
        public function b2Distance()
        {
            super();
        }
        
        public static function ProcessTwo(param1:b2Vec2, param2:b2Vec2, param3:Array, param4:Array, param5:Array) : int
        {
            var _loc9_:b2Vec2 = null;
            var _loc10_:b2Vec2 = null;
            var _loc11_:b2Vec2 = null;
            var _loc17_:Number = NaN;
            var _loc6_:b2Vec2 = param5[0];
            var _loc7_:b2Vec2 = param5[1];
            var _loc8_:b2Vec2 = param3[0];
            _loc9_ = param3[1];
            _loc10_ = param4[0];
            _loc11_ = param4[1];
            var _loc12_:Number = -_loc7_.x;
            var _loc13_:Number = -_loc7_.y;
            var _loc14_:Number = _loc6_.x - _loc7_.x;
            var _loc15_:Number = _loc6_.y - _loc7_.y;
            var _loc16_:Number = Math.sqrt(_loc14_ * _loc14_ + _loc15_ * _loc15_);
            _loc14_ /= _loc16_;
            _loc15_ /= _loc16_;
            _loc17_ = _loc12_ * _loc14_ + _loc13_ * _loc15_;
            if(_loc17_ <= 0 || _loc16_ < Number.MIN_VALUE)
            {
                param1.SetV(_loc9_);
                param2.SetV(_loc11_);
                _loc8_.SetV(_loc9_);
                _loc10_.SetV(_loc11_);
                _loc6_.SetV(_loc7_);
                return 1;
            }
            _loc17_ /= _loc16_;
            param1.x = _loc9_.x + _loc17_ * (_loc8_.x - _loc9_.x);
            param1.y = _loc9_.y + _loc17_ * (_loc8_.y - _loc9_.y);
            param2.x = _loc11_.x + _loc17_ * (_loc10_.x - _loc11_.x);
            param2.y = _loc11_.y + _loc17_ * (_loc10_.y - _loc11_.y);
            return 2;
        }
        
        public static function ProcessThree(param1:b2Vec2, param2:b2Vec2, param3:Array, param4:Array, param5:Array) : int
        {
            var _loc6_:b2Vec2 = null;
            var _loc7_:b2Vec2 = null;
            var _loc8_:b2Vec2 = null;
            var _loc9_:b2Vec2 = null;
            var _loc10_:b2Vec2 = null;
            var _loc11_:b2Vec2 = null;
            var _loc12_:b2Vec2 = null;
            var _loc13_:b2Vec2 = null;
            var _loc35_:Number = NaN;
            _loc6_ = param5[0];
            _loc7_ = param5[1];
            _loc8_ = param5[2];
            _loc9_ = param3[0];
            _loc10_ = param3[1];
            _loc11_ = param3[2];
            _loc12_ = param4[0];
            _loc13_ = param4[1];
            var _loc14_:b2Vec2 = param4[2];
            var _loc15_:Number = _loc6_.x;
            var _loc16_:Number = _loc6_.y;
            var _loc17_:Number = _loc7_.x;
            var _loc18_:Number = _loc7_.y;
            var _loc19_:Number = _loc8_.x;
            var _loc20_:Number = _loc8_.y;
            var _loc21_:Number = _loc17_ - _loc15_;
            var _loc22_:Number = _loc18_ - _loc16_;
            var _loc23_:Number = _loc19_ - _loc15_;
            var _loc24_:Number = _loc20_ - _loc16_;
            var _loc25_:Number = _loc19_ - _loc17_;
            var _loc26_:Number = _loc20_ - _loc18_;
            var _loc27_:Number = -(_loc15_ * _loc21_ + _loc16_ * _loc22_);
            var _loc28_:Number = _loc17_ * _loc21_ + _loc18_ * _loc22_;
            var _loc29_:Number = -(_loc15_ * _loc23_ + _loc16_ * _loc24_);
            var _loc30_:Number = _loc19_ * _loc23_ + _loc20_ * _loc24_;
            var _loc31_:Number = -(_loc17_ * _loc25_ + _loc18_ * _loc26_);
            var _loc32_:Number = _loc19_ * _loc25_ + _loc20_ * _loc26_;
            if(_loc30_ <= 0 && _loc32_ <= 0)
            {
                param1.SetV(_loc11_);
                param2.SetV(_loc14_);
                _loc9_.SetV(_loc11_);
                _loc12_.SetV(_loc14_);
                _loc6_.SetV(_loc8_);
                return 1;
            }
            var _loc33_:Number = _loc21_ * _loc24_ - _loc22_ * _loc23_;
            var _loc34_:Number = _loc33_ * (_loc15_ * _loc18_ - _loc16_ * _loc17_);
            var _loc36_:Number = _loc33_ * (_loc17_ * _loc20_ - _loc18_ * _loc19_);
            if(_loc36_ <= 0 && _loc31_ >= 0 && _loc32_ >= 0 && _loc31_ + _loc32_ > 0)
            {
                _loc35_ = _loc31_ / (_loc31_ + _loc32_);
                param1.x = _loc10_.x + _loc35_ * (_loc11_.x - _loc10_.x);
                param1.y = _loc10_.y + _loc35_ * (_loc11_.y - _loc10_.y);
                param2.x = _loc13_.x + _loc35_ * (_loc14_.x - _loc13_.x);
                param2.y = _loc13_.y + _loc35_ * (_loc14_.y - _loc13_.y);
                _loc9_.SetV(_loc11_);
                _loc12_.SetV(_loc14_);
                _loc6_.SetV(_loc8_);
                return 2;
            }
            var _loc37_:Number = _loc33_ * (_loc19_ * _loc16_ - _loc20_ * _loc15_);
            if(_loc37_ <= 0 && _loc29_ >= 0 && _loc30_ >= 0 && _loc29_ + _loc30_ > 0)
            {
                _loc35_ = _loc29_ / (_loc29_ + _loc30_);
                param1.x = _loc9_.x + _loc35_ * (_loc11_.x - _loc9_.x);
                param1.y = _loc9_.y + _loc35_ * (_loc11_.y - _loc9_.y);
                param2.x = _loc12_.x + _loc35_ * (_loc14_.x - _loc12_.x);
                param2.y = _loc12_.y + _loc35_ * (_loc14_.y - _loc12_.y);
                _loc10_.SetV(_loc11_);
                _loc13_.SetV(_loc14_);
                _loc7_.SetV(_loc8_);
                return 2;
            }
            var _loc38_:Number = _loc36_ + _loc37_ + _loc34_;
            _loc38_ = 1 / _loc38_;
            var _loc39_:Number = _loc36_ * _loc38_;
            var _loc40_:Number = _loc37_ * _loc38_;
            var _loc41_:Number = 1 - _loc39_ - _loc40_;
            param1.x = _loc39_ * _loc9_.x + _loc40_ * _loc10_.x + _loc41_ * _loc11_.x;
            param1.y = _loc39_ * _loc9_.y + _loc40_ * _loc10_.y + _loc41_ * _loc11_.y;
            param2.x = _loc39_ * _loc12_.x + _loc40_ * _loc13_.x + _loc41_ * _loc14_.x;
            param2.y = _loc39_ * _loc12_.y + _loc40_ * _loc13_.y + _loc41_ * _loc14_.y;
            return 3;
        }
        
        public static function InPoints(param1:b2Vec2, param2:Array, param3:int) : Boolean
        {
            var _loc6_:b2Vec2 = null;
            var _loc7_:Number = NaN;
            var _loc8_:Number = NaN;
            var _loc9_:Number = NaN;
            var _loc10_:Number = NaN;
            var _loc4_:Number = 100 * Number.MIN_VALUE;
            var _loc5_:int = 0;
            while(_loc5_ < param3)
            {
                _loc6_ = param2[_loc5_];
                _loc7_ = Math.abs(param1.x - _loc6_.x);
                _loc8_ = Math.abs(param1.y - _loc6_.y);
                _loc9_ = Math.max(Math.abs(param1.x),Math.abs(_loc6_.x));
                _loc10_ = Math.max(Math.abs(param1.y),Math.abs(_loc6_.y));
                if(_loc7_ < _loc4_ * (_loc9_ + 1) && _loc8_ < _loc4_ * (_loc10_ + 1))
                {
                    return true;
                }
                _loc5_++;
            }
            return false;
        }
        
        public static function DistanceGeneric(param1:b2Vec2, param2:b2Vec2, param3:*, param4:b2XForm, param5:*, param6:b2XForm) : Number
        {
            var _loc7_:b2Vec2 = null;
            var _loc15_:Number = NaN;
            var _loc16_:Number = NaN;
            var _loc17_:b2Vec2 = null;
            var _loc18_:b2Vec2 = null;
            var _loc19_:Number = NaN;
            var _loc20_:Number = NaN;
            var _loc21_:Number = NaN;
            var _loc22_:Number = NaN;
            var _loc23_:int = 0;
            var _loc8_:Array = s_p1s;
            var _loc9_:Array = s_p2s;
            var _loc10_:Array = s_points;
            var _loc11_:int = 0;
            param1.SetV(param3.GetFirstVertex(param4));
            param2.SetV(param5.GetFirstVertex(param6));
            var _loc12_:Number = 0;
            var _loc13_:int = 20;
            var _loc14_:int = 0;
            while(_loc14_ < _loc13_)
            {
                _loc15_ = param2.x - param1.x;
                _loc16_ = param2.y - param1.y;
                _loc17_ = param3.Support(param4,_loc15_,_loc16_);
                _loc18_ = param5.Support(param6,-_loc15_,-_loc16_);
                _loc12_ = _loc15_ * _loc15_ + _loc16_ * _loc16_;
                _loc19_ = _loc18_.x - _loc17_.x;
                _loc20_ = _loc18_.y - _loc17_.y;
                _loc21_ = _loc15_ * _loc19_ + _loc16_ * _loc20_;
                if(_loc12_ - (_loc15_ * _loc19_ + _loc16_ * _loc20_) <= 0.01 * _loc12_)
                {
                    if(_loc11_ == 0)
                    {
                        param1.SetV(_loc17_);
                        param2.SetV(_loc18_);
                    }
                    g_GJK_Iterations = _loc14_;
                    return Math.sqrt(_loc12_);
                }
                switch(_loc11_)
                {
                    case 0:
                        _loc7_ = _loc8_[0];
                        _loc7_.SetV(_loc17_);
                        _loc7_ = _loc9_[0];
                        _loc7_.SetV(_loc18_);
                        _loc7_ = _loc10_[0];
                        _loc7_.x = _loc19_;
                        _loc7_.y = _loc20_;
                        param1.SetV(_loc8_[0]);
                        param2.SetV(_loc9_[0]);
                        _loc11_++;
                        break;
                    case 1:
                        _loc7_ = _loc8_[1];
                        _loc7_.SetV(_loc17_);
                        _loc7_ = _loc9_[1];
                        _loc7_.SetV(_loc18_);
                        _loc7_ = _loc10_[1];
                        _loc7_.x = _loc19_;
                        _loc7_.y = _loc20_;
                        _loc11_ = ProcessTwo(param1,param2,_loc8_,_loc9_,_loc10_);
                        break;
                    case 2:
                        _loc7_ = _loc8_[2];
                        _loc7_.SetV(_loc17_);
                        _loc7_ = _loc9_[2];
                        _loc7_.SetV(_loc18_);
                        _loc7_ = _loc10_[2];
                        _loc7_.x = _loc19_;
                        _loc7_.y = _loc20_;
                        _loc11_ = ProcessThree(param1,param2,_loc8_,_loc9_,_loc10_);
                }
                if(_loc11_ == 3)
                {
                    g_GJK_Iterations = _loc14_;
                    return 0;
                }
                _loc22_ = -Number.MAX_VALUE;
                _loc23_ = 0;
                while(_loc23_ < _loc11_)
                {
                    _loc7_ = _loc10_[_loc23_];
                    _loc22_ = b2Math.b2Max(_loc22_,_loc7_.x * _loc7_.x + _loc7_.y * _loc7_.y);
                    _loc23_++;
                }
                if(_loc11_ == 3 || _loc12_ <= 100 * Number.MIN_VALUE * _loc22_)
                {
                    g_GJK_Iterations = _loc14_;
                    _loc15_ = param2.x - param1.x;
                    _loc16_ = param2.y - param1.y;
                    _loc12_ = _loc15_ * _loc15_ + _loc16_ * _loc16_;
                    return Math.sqrt(_loc12_);
                }
                _loc14_++;
            }
            g_GJK_Iterations = _loc13_;
            return Math.sqrt(_loc12_);
        }
        
        public static function DistanceCC(param1:b2Vec2, param2:b2Vec2, param3:b2CircleShape, param4:b2XForm, param5:b2CircleShape, param6:b2XForm) : Number
        {
            var _loc7_:b2Mat22 = null;
            var _loc8_:b2Vec2 = null;
            var _loc19_:Number = NaN;
            var _loc20_:Number = NaN;
            _loc7_ = param4.R;
            _loc8_ = param3.m_localPosition;
            var _loc9_:Number = param4.position.x + (_loc7_.col1.x * _loc8_.x + _loc7_.col2.x * _loc8_.y);
            var _loc10_:Number = param4.position.y + (_loc7_.col1.y * _loc8_.x + _loc7_.col2.y * _loc8_.y);
            _loc7_ = param6.R;
            _loc8_ = param5.m_localPosition;
            var _loc11_:Number = param6.position.x + (_loc7_.col1.x * _loc8_.x + _loc7_.col2.x * _loc8_.y);
            var _loc12_:Number = param6.position.y + (_loc7_.col1.y * _loc8_.x + _loc7_.col2.y * _loc8_.y);
            var _loc13_:Number = _loc11_ - _loc9_;
            var _loc14_:Number = _loc12_ - _loc10_;
            var _loc15_:Number = _loc13_ * _loc13_ + _loc14_ * _loc14_;
            var _loc16_:Number = param3.m_radius - b2Settings.b2_toiSlop;
            var _loc17_:Number = param5.m_radius - b2Settings.b2_toiSlop;
            var _loc18_:Number = _loc16_ + _loc17_;
            if(_loc15_ > _loc18_ * _loc18_)
            {
                _loc19_ = Math.sqrt(_loc13_ * _loc13_ + _loc14_ * _loc14_);
                _loc13_ /= _loc19_;
                _loc14_ /= _loc19_;
                _loc20_ = _loc19_ - _loc18_;
                param1.x = _loc9_ + _loc16_ * _loc13_;
                param1.y = _loc10_ + _loc16_ * _loc14_;
                param2.x = _loc11_ - _loc17_ * _loc13_;
                param2.y = _loc12_ - _loc17_ * _loc14_;
                return _loc20_;
            }
            if(_loc15_ > Number.MIN_VALUE * Number.MIN_VALUE)
            {
                _loc19_ = Math.sqrt(_loc13_ * _loc13_ + _loc14_ * _loc14_);
                _loc13_ /= _loc19_;
                _loc14_ /= _loc19_;
                param1.x = _loc9_ + _loc16_ * _loc13_;
                param1.y = _loc10_ + _loc16_ * _loc14_;
                param2.x = param1.x;
                param2.y = param1.y;
                return 0;
            }
            param1.x = _loc9_;
            param1.y = _loc10_;
            param2.x = param1.x;
            param2.y = param1.y;
            return 0;
        }
        
        public static function DistancePC(param1:b2Vec2, param2:b2Vec2, param3:b2PolygonShape, param4:b2XForm, param5:b2CircleShape, param6:b2XForm) : Number
        {
            var _loc7_:b2Mat22 = null;
            var _loc8_:b2Vec2 = null;
            var _loc12_:Number = NaN;
            var _loc13_:Number = NaN;
            var _loc14_:Number = NaN;
            var _loc9_:b2Point = gPoint;
            _loc8_ = param5.m_localPosition;
            _loc7_ = param6.R;
            _loc9_.p.x = param6.position.x + (_loc7_.col1.x * _loc8_.x + _loc7_.col2.x * _loc8_.y);
            _loc9_.p.y = param6.position.y + (_loc7_.col1.y * _loc8_.x + _loc7_.col2.y * _loc8_.y);
            var _loc10_:Number = DistanceGeneric(param1,param2,param3,param4,_loc9_,b2Math.b2XForm_identity);
            var _loc11_:Number = param5.m_radius - b2Settings.b2_toiSlop;
            if(_loc10_ > _loc11_)
            {
                _loc10_ -= _loc11_;
                _loc12_ = param2.x - param1.x;
                _loc13_ = param2.y - param1.y;
                _loc14_ = Math.sqrt(_loc12_ * _loc12_ + _loc13_ * _loc13_);
                _loc12_ /= _loc14_;
                _loc13_ /= _loc14_;
                param2.x -= _loc11_ * _loc12_;
                param2.y -= _loc11_ * _loc13_;
            }
            else
            {
                _loc10_ = 0;
                param2.x = param1.x;
                param2.y = param1.y;
            }
            return _loc10_;
        }
        
        public static function Distance(param1:b2Vec2, param2:b2Vec2, param3:b2Shape, param4:b2XForm, param5:b2Shape, param6:b2XForm) : Number
        {
            var _loc7_:int = param3.m_type;
            var _loc8_:int = param5.m_type;
            if(_loc7_ == b2Shape.e_circleShape && _loc8_ == b2Shape.e_circleShape)
            {
                return DistanceCC(param1,param2,param3 as b2CircleShape,param4,param5 as b2CircleShape,param6);
            }
            if(_loc7_ == b2Shape.e_polygonShape && _loc8_ == b2Shape.e_circleShape)
            {
                return DistancePC(param1,param2,param3 as b2PolygonShape,param4,param5 as b2CircleShape,param6);
            }
            if(_loc7_ == b2Shape.e_circleShape && _loc8_ == b2Shape.e_polygonShape)
            {
                return DistancePC(param2,param1,param5 as b2PolygonShape,param6,param3 as b2CircleShape,param4);
            }
            if(_loc7_ == b2Shape.e_polygonShape && _loc8_ == b2Shape.e_polygonShape)
            {
                return DistanceGeneric(param1,param2,param3 as b2PolygonShape,param4,param5 as b2PolygonShape,param6);
            }
            return 0;
        }
    }
}

