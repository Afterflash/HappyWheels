package Box2D.Collision.Shapes
{
    import Box2D.Collision.*;
    import Box2D.Common.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    
    public class b2PolygonShape extends b2Shape
    {
        private static var s_computeMat:b2Mat22 = new b2Mat22();
        
        private static var s_sweptAABB1:b2AABB = new b2AABB();
        
        private static var s_sweptAABB2:b2AABB = new b2AABB();
        
        private var s_supportVec:b2Vec2;
        
        public var m_centroid:b2Vec2;
        
        public var m_obb:b2OBB;
        
        public var m_vertices:Array;
        
        public var m_normals:Array;
        
        public var m_coreVertices:Array;
        
        public var m_vertexCount:int;
        
        public function b2PolygonShape(param1:b2ShapeDef)
        {
            var _loc3_:int = 0;
            var _loc6_:Number = NaN;
            var _loc7_:Number = NaN;
            var _loc8_:Number = NaN;
            var _loc9_:Number = NaN;
            var _loc10_:Number = NaN;
            var _loc11_:Number = NaN;
            var _loc12_:Number = NaN;
            var _loc13_:Number = NaN;
            var _loc14_:Number = NaN;
            var _loc15_:Number = NaN;
            var _loc16_:Number = NaN;
            var _loc17_:Number = NaN;
            this.s_supportVec = new b2Vec2();
            this.m_obb = new b2OBB();
            this.m_vertices = new Array(b2Settings.b2_maxPolygonVertices);
            this.m_normals = new Array(b2Settings.b2_maxPolygonVertices);
            this.m_coreVertices = new Array(b2Settings.b2_maxPolygonVertices);
            super(param1);
            m_type = e_polygonShape;
            var _loc2_:b2PolygonDef = param1 as b2PolygonDef;
            this.m_vertexCount = _loc2_.vertexCount;
            var _loc4_:int = _loc3_;
            var _loc5_:int = _loc3_;
            _loc3_ = 0;
            while(_loc3_ < this.m_vertexCount)
            {
                this.m_vertices[_loc3_] = _loc2_.vertices[_loc3_].Copy();
                _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < this.m_vertexCount)
            {
                _loc4_ = _loc3_;
                _loc5_ = _loc3_ + 1 < this.m_vertexCount ? _loc3_ + 1 : 0;
                _loc6_ = this.m_vertices[_loc5_].x - this.m_vertices[_loc4_].x;
                _loc7_ = this.m_vertices[_loc5_].y - this.m_vertices[_loc4_].y;
                _loc8_ = Math.sqrt(_loc6_ * _loc6_ + _loc7_ * _loc7_);
                this.m_normals[_loc3_] = new b2Vec2(_loc7_ / _loc8_,-_loc6_ / _loc8_);
                _loc3_++;
            }
            this.m_centroid = ComputeCentroid(_loc2_.vertices,_loc2_.vertexCount);
            ComputeOBB(this.m_obb,this.m_vertices,this.m_vertexCount);
            _loc3_ = 0;
            while(_loc3_ < this.m_vertexCount)
            {
                _loc4_ = _loc3_ - 1 >= 0 ? _loc3_ - 1 : this.m_vertexCount - 1;
                _loc5_ = _loc3_;
                _loc9_ = Number(this.m_normals[_loc4_].x);
                _loc10_ = Number(this.m_normals[_loc4_].y);
                _loc11_ = Number(this.m_normals[_loc5_].x);
                _loc12_ = Number(this.m_normals[_loc5_].y);
                _loc13_ = this.m_vertices[_loc3_].x - this.m_centroid.x;
                _loc14_ = this.m_vertices[_loc3_].y - this.m_centroid.y;
                _loc15_ = _loc9_ * _loc13_ + _loc10_ * _loc14_ - b2Settings.b2_toiSlop;
                _loc16_ = _loc11_ * _loc13_ + _loc12_ * _loc14_ - b2Settings.b2_toiSlop;
                _loc17_ = 1 / (_loc9_ * _loc12_ - _loc10_ * _loc11_);
                this.m_coreVertices[_loc3_] = new b2Vec2(_loc17_ * (_loc12_ * _loc15_ - _loc10_ * _loc16_) + this.m_centroid.x,_loc17_ * (_loc9_ * _loc16_ - _loc11_ * _loc15_) + this.m_centroid.y);
                _loc3_++;
            }
        }
        
        public static function ComputeCentroid(param1:Array, param2:int) : b2Vec2
        {
            var _loc3_:b2Vec2 = null;
            var _loc7_:Number = NaN;
            var _loc9_:b2Vec2 = null;
            var _loc10_:b2Vec2 = null;
            var _loc11_:Number = NaN;
            var _loc12_:Number = NaN;
            var _loc13_:Number = NaN;
            var _loc14_:Number = NaN;
            var _loc15_:Number = NaN;
            var _loc16_:Number = NaN;
            _loc3_ = new b2Vec2();
            var _loc4_:Number = 0;
            var _loc5_:Number = 0;
            var _loc6_:Number = 0;
            _loc7_ = 0.3333333333333333;
            var _loc8_:int = 0;
            while(_loc8_ < param2)
            {
                _loc9_ = param1[_loc8_];
                _loc10_ = _loc8_ + 1 < param2 ? param1[int(_loc8_ + 1)] : param1[0];
                _loc11_ = _loc9_.x - _loc5_;
                _loc12_ = _loc9_.y - _loc6_;
                _loc13_ = _loc10_.x - _loc5_;
                _loc14_ = _loc10_.y - _loc6_;
                _loc15_ = _loc11_ * _loc14_ - _loc12_ * _loc13_;
                _loc16_ = 0.5 * _loc15_;
                _loc4_ += _loc16_;
                _loc3_.x += _loc16_ * _loc7_ * (_loc5_ + _loc9_.x + _loc10_.x);
                _loc3_.y += _loc16_ * _loc7_ * (_loc6_ + _loc9_.y + _loc10_.y);
                _loc8_++;
            }
            _loc3_.x *= 1 / _loc4_;
            _loc3_.y *= 1 / _loc4_;
            return _loc3_;
        }
        
        public static function ComputeOBB(param1:b2OBB, param2:Array, param3:int) : void
        {
            var _loc4_:int = 0;
            var _loc7_:b2Vec2 = null;
            var _loc8_:Number = NaN;
            var _loc9_:Number = NaN;
            var _loc10_:Number = NaN;
            var _loc11_:Number = NaN;
            var _loc12_:Number = NaN;
            var _loc13_:Number = NaN;
            var _loc14_:Number = NaN;
            var _loc15_:Number = NaN;
            var _loc16_:Number = NaN;
            var _loc17_:int = 0;
            var _loc18_:Number = NaN;
            var _loc19_:Number = NaN;
            var _loc20_:Number = NaN;
            var _loc21_:Number = NaN;
            var _loc22_:Number = NaN;
            var _loc23_:Number = NaN;
            var _loc24_:Number = NaN;
            var _loc25_:b2Mat22 = null;
            var _loc5_:Array = new Array(b2Settings.b2_maxPolygonVertices + 1);
            _loc4_ = 0;
            while(_loc4_ < param3)
            {
                _loc5_[_loc4_] = param2[_loc4_];
                _loc4_++;
            }
            _loc5_[param3] = _loc5_[0];
            var _loc6_:Number = Number.MAX_VALUE;
            _loc4_ = 1;
            while(_loc4_ <= param3)
            {
                _loc7_ = _loc5_[int(_loc4_ - 1)];
                _loc8_ = _loc5_[_loc4_].x - _loc7_.x;
                _loc9_ = _loc5_[_loc4_].y - _loc7_.y;
                _loc10_ = Math.sqrt(_loc8_ * _loc8_ + _loc9_ * _loc9_);
                _loc8_ /= _loc10_;
                _loc9_ /= _loc10_;
                _loc11_ = -_loc9_;
                _loc12_ = _loc8_;
                _loc13_ = Number.MAX_VALUE;
                _loc14_ = Number.MAX_VALUE;
                _loc15_ = -Number.MAX_VALUE;
                _loc16_ = -Number.MAX_VALUE;
                _loc17_ = 0;
                while(_loc17_ < param3)
                {
                    _loc19_ = _loc5_[_loc17_].x - _loc7_.x;
                    _loc20_ = _loc5_[_loc17_].y - _loc7_.y;
                    _loc21_ = _loc8_ * _loc19_ + _loc9_ * _loc20_;
                    _loc22_ = _loc11_ * _loc19_ + _loc12_ * _loc20_;
                    if(_loc21_ < _loc13_)
                    {
                        _loc13_ = _loc21_;
                    }
                    if(_loc22_ < _loc14_)
                    {
                        _loc14_ = _loc22_;
                    }
                    if(_loc21_ > _loc15_)
                    {
                        _loc15_ = _loc21_;
                    }
                    if(_loc22_ > _loc16_)
                    {
                        _loc16_ = _loc22_;
                    }
                    _loc17_++;
                }
                _loc18_ = (_loc15_ - _loc13_) * (_loc16_ - _loc14_);
                if(_loc18_ < 0.95 * _loc6_)
                {
                    _loc6_ = _loc18_;
                    param1.R.col1.x = _loc8_;
                    param1.R.col1.y = _loc9_;
                    param1.R.col2.x = _loc11_;
                    param1.R.col2.y = _loc12_;
                    _loc23_ = 0.5 * (_loc13_ + _loc15_);
                    _loc24_ = 0.5 * (_loc14_ + _loc16_);
                    _loc25_ = param1.R;
                    param1.center.x = _loc7_.x + (_loc25_.col1.x * _loc23_ + _loc25_.col2.x * _loc24_);
                    param1.center.y = _loc7_.y + (_loc25_.col1.y * _loc23_ + _loc25_.col2.y * _loc24_);
                    param1.extents.x = 0.5 * (_loc15_ - _loc13_);
                    param1.extents.y = 0.5 * (_loc16_ - _loc14_);
                }
                _loc4_++;
            }
        }
        
        override public function TestPoint(param1:b2XForm, param2:b2Vec2) : Boolean
        {
            var _loc3_:b2Vec2 = null;
            var _loc10_:Number = NaN;
            var _loc4_:b2Mat22 = param1.R;
            var _loc5_:Number = param2.x - param1.position.x;
            var _loc6_:Number = param2.y - param1.position.y;
            var _loc7_:Number = _loc5_ * _loc4_.col1.x + _loc6_ * _loc4_.col1.y;
            var _loc8_:Number = _loc5_ * _loc4_.col2.x + _loc6_ * _loc4_.col2.y;
            var _loc9_:int = 0;
            while(_loc9_ < this.m_vertexCount)
            {
                _loc3_ = this.m_vertices[_loc9_];
                _loc5_ = _loc7_ - _loc3_.x;
                _loc6_ = _loc8_ - _loc3_.y;
                _loc3_ = this.m_normals[_loc9_];
                _loc10_ = _loc3_.x * _loc5_ + _loc3_.y * _loc6_;
                if(_loc10_ > 0)
                {
                    return false;
                }
                _loc9_++;
            }
            return true;
        }
        
        override public function TestSegment(param1:b2XForm, param2:Array, param3:b2Vec2, param4:b2Segment, param5:Number) : Boolean
        {
            var _loc8_:Number = NaN;
            var _loc9_:Number = NaN;
            var _loc10_:b2Mat22 = null;
            var _loc11_:b2Vec2 = null;
            var _loc20_:Number = NaN;
            var _loc21_:Number = NaN;
            var _loc6_:Number = 0;
            var _loc7_:Number = param5;
            _loc8_ = param4.p1.x - param1.position.x;
            _loc9_ = param4.p1.y - param1.position.y;
            _loc10_ = param1.R;
            var _loc12_:Number = _loc8_ * _loc10_.col1.x + _loc9_ * _loc10_.col1.y;
            var _loc13_:Number = _loc8_ * _loc10_.col2.x + _loc9_ * _loc10_.col2.y;
            _loc8_ = param4.p2.x - param1.position.x;
            _loc9_ = param4.p2.y - param1.position.y;
            _loc10_ = param1.R;
            var _loc14_:Number = _loc8_ * _loc10_.col1.x + _loc9_ * _loc10_.col1.y;
            var _loc15_:Number = _loc8_ * _loc10_.col2.x + _loc9_ * _loc10_.col2.y;
            var _loc16_:Number = _loc14_ - _loc12_;
            var _loc17_:Number = _loc15_ - _loc13_;
            var _loc18_:int = -1;
            var _loc19_:int = 0;
            while(_loc19_ < this.m_vertexCount)
            {
                _loc11_ = this.m_vertices[_loc19_];
                _loc8_ = _loc11_.x - _loc12_;
                _loc9_ = _loc11_.y - _loc13_;
                _loc11_ = this.m_normals[_loc19_];
                _loc20_ = _loc11_.x * _loc8_ + _loc11_.y * _loc9_;
                _loc21_ = _loc11_.x * _loc16_ + _loc11_.y * _loc17_;
                if(_loc21_ < 0 && _loc20_ < _loc6_ * _loc21_)
                {
                    _loc6_ = _loc20_ / _loc21_;
                    _loc18_ = _loc19_;
                }
                else if(_loc21_ > 0 && _loc20_ < _loc7_ * _loc21_)
                {
                    _loc7_ = _loc20_ / _loc21_;
                }
                if(_loc7_ < _loc6_)
                {
                    return false;
                }
                _loc19_++;
            }
            if(_loc18_ >= 0)
            {
                param2[0] = _loc6_;
                _loc10_ = param1.R;
                _loc11_ = this.m_normals[_loc18_];
                param3.x = _loc10_.col1.x * _loc11_.x + _loc10_.col2.x * _loc11_.y;
                param3.y = _loc10_.col1.y * _loc11_.x + _loc10_.col2.y * _loc11_.y;
                return true;
            }
            return false;
        }
        
        override public function ComputeAABB(param1:b2AABB, param2:b2XForm) : void
        {
            var _loc3_:b2Mat22 = null;
            var _loc4_:b2Vec2 = null;
            var _loc5_:b2Mat22 = s_computeMat;
            _loc3_ = param2.R;
            _loc4_ = this.m_obb.R.col1;
            _loc5_.col1.x = _loc3_.col1.x * _loc4_.x + _loc3_.col2.x * _loc4_.y;
            _loc5_.col1.y = _loc3_.col1.y * _loc4_.x + _loc3_.col2.y * _loc4_.y;
            _loc4_ = this.m_obb.R.col2;
            _loc5_.col2.x = _loc3_.col1.x * _loc4_.x + _loc3_.col2.x * _loc4_.y;
            _loc5_.col2.y = _loc3_.col1.y * _loc4_.x + _loc3_.col2.y * _loc4_.y;
            _loc5_.Abs();
            var _loc6_:b2Mat22 = _loc5_;
            _loc4_ = this.m_obb.extents;
            var _loc7_:Number = _loc6_.col1.x * _loc4_.x + _loc6_.col2.x * _loc4_.y;
            var _loc8_:Number = _loc6_.col1.y * _loc4_.x + _loc6_.col2.y * _loc4_.y;
            _loc3_ = param2.R;
            _loc4_ = this.m_obb.center;
            var _loc9_:Number = param2.position.x + (_loc3_.col1.x * _loc4_.x + _loc3_.col2.x * _loc4_.y);
            var _loc10_:Number = param2.position.y + (_loc3_.col1.y * _loc4_.x + _loc3_.col2.y * _loc4_.y);
            param1.lowerBound.Set(_loc9_ - _loc7_,_loc10_ - _loc8_);
            param1.upperBound.Set(_loc9_ + _loc7_,_loc10_ + _loc8_);
        }
        
        override public function ComputeSweptAABB(param1:b2AABB, param2:b2XForm, param3:b2XForm) : void
        {
            var _loc4_:b2AABB = s_sweptAABB1;
            var _loc5_:b2AABB = s_sweptAABB2;
            this.ComputeAABB(_loc4_,param2);
            this.ComputeAABB(_loc5_,param3);
            param1.lowerBound.Set(_loc4_.lowerBound.x < _loc5_.lowerBound.x ? _loc4_.lowerBound.x : _loc5_.lowerBound.x,_loc4_.lowerBound.y < _loc5_.lowerBound.y ? _loc4_.lowerBound.y : _loc5_.lowerBound.y);
            param1.upperBound.Set(_loc4_.upperBound.x > _loc5_.upperBound.x ? _loc4_.upperBound.x : _loc5_.upperBound.x,_loc4_.upperBound.y > _loc5_.upperBound.y ? _loc4_.upperBound.y : _loc5_.upperBound.y);
        }
        
        override public function ComputeMass(param1:b2MassData) : void
        {
            var _loc10_:b2Vec2 = null;
            var _loc11_:b2Vec2 = null;
            var _loc12_:Number = NaN;
            var _loc13_:Number = NaN;
            var _loc14_:Number = NaN;
            var _loc15_:Number = NaN;
            var _loc16_:Number = NaN;
            var _loc17_:Number = NaN;
            var _loc18_:Number = NaN;
            var _loc19_:Number = NaN;
            var _loc20_:Number = NaN;
            var _loc21_:Number = NaN;
            var _loc22_:Number = NaN;
            var _loc23_:Number = NaN;
            var _loc24_:Number = NaN;
            var _loc25_:Number = NaN;
            var _loc2_:Number = 0;
            var _loc3_:Number = 0;
            var _loc4_:Number = 0;
            var _loc5_:Number = 0;
            var _loc6_:Number = 0;
            var _loc7_:Number = 0;
            var _loc8_:Number = 0.3333333333333333;
            var _loc9_:int = 0;
            while(_loc9_ < this.m_vertexCount)
            {
                _loc10_ = this.m_vertices[_loc9_];
                _loc11_ = _loc9_ + 1 < this.m_vertexCount ? this.m_vertices[int(_loc9_ + 1)] : this.m_vertices[0];
                _loc12_ = _loc10_.x - _loc6_;
                _loc13_ = _loc10_.y - _loc7_;
                _loc14_ = _loc11_.x - _loc6_;
                _loc15_ = _loc11_.y - _loc7_;
                _loc16_ = _loc12_ * _loc15_ - _loc13_ * _loc14_;
                _loc17_ = 0.5 * _loc16_;
                _loc4_ += _loc17_;
                _loc2_ += _loc17_ * _loc8_ * (_loc6_ + _loc10_.x + _loc11_.x);
                _loc3_ += _loc17_ * _loc8_ * (_loc7_ + _loc10_.y + _loc11_.y);
                _loc18_ = _loc6_;
                _loc19_ = _loc7_;
                _loc20_ = _loc12_;
                _loc21_ = _loc13_;
                _loc22_ = _loc14_;
                _loc23_ = _loc15_;
                _loc24_ = _loc8_ * (0.25 * (_loc20_ * _loc20_ + _loc22_ * _loc20_ + _loc22_ * _loc22_) + (_loc18_ * _loc20_ + _loc18_ * _loc22_)) + 0.5 * _loc18_ * _loc18_;
                _loc25_ = _loc8_ * (0.25 * (_loc21_ * _loc21_ + _loc23_ * _loc21_ + _loc23_ * _loc23_) + (_loc19_ * _loc21_ + _loc19_ * _loc23_)) + 0.5 * _loc19_ * _loc19_;
                _loc5_ += _loc16_ * (_loc24_ + _loc25_);
                _loc9_++;
            }
            param1.mass = m_density * _loc4_;
            _loc2_ *= 1 / _loc4_;
            _loc3_ *= 1 / _loc4_;
            param1.center.Set(_loc2_,_loc3_);
            param1.I = m_density * _loc5_;
        }
        
        public function GetOBB() : b2OBB
        {
            return this.m_obb;
        }
        
        public function GetCentroid() : b2Vec2
        {
            return this.m_centroid;
        }
        
        public function GetVertexCount() : int
        {
            return this.m_vertexCount;
        }
        
        public function GetVertices() : Array
        {
            return this.m_vertices;
        }
        
        public function GetCoreVertices() : Array
        {
            return this.m_coreVertices;
        }
        
        public function GetNormals() : Array
        {
            return this.m_normals;
        }
        
        public function GetFirstVertex(param1:b2XForm) : b2Vec2
        {
            return b2Math.b2MulX(param1,this.m_coreVertices[0]);
        }
        
        public function Centroid(param1:b2XForm) : b2Vec2
        {
            return b2Math.b2MulX(param1,this.m_centroid);
        }
        
        public function Support(param1:b2XForm, param2:Number, param3:Number) : b2Vec2
        {
            var _loc4_:b2Vec2 = null;
            var _loc5_:b2Mat22 = null;
            var _loc11_:Number = NaN;
            _loc5_ = param1.R;
            var _loc6_:Number = param2 * _loc5_.col1.x + param3 * _loc5_.col1.y;
            var _loc7_:Number = param2 * _loc5_.col2.x + param3 * _loc5_.col2.y;
            var _loc8_:int = 0;
            _loc4_ = this.m_coreVertices[0];
            var _loc9_:Number = _loc4_.x * _loc6_ + _loc4_.y * _loc7_;
            var _loc10_:int = 1;
            while(_loc10_ < this.m_vertexCount)
            {
                _loc4_ = this.m_coreVertices[_loc10_];
                _loc11_ = _loc4_.x * _loc6_ + _loc4_.y * _loc7_;
                if(_loc11_ > _loc9_)
                {
                    _loc8_ = _loc10_;
                    _loc9_ = _loc11_;
                }
                _loc10_++;
            }
            _loc5_ = param1.R;
            _loc4_ = this.m_coreVertices[_loc8_];
            this.s_supportVec.x = param1.position.x + (_loc5_.col1.x * _loc4_.x + _loc5_.col2.x * _loc4_.y);
            this.s_supportVec.y = param1.position.y + (_loc5_.col1.y * _loc4_.x + _loc5_.col2.y * _loc4_.y);
            return this.s_supportVec;
        }
        
        override public function UpdateSweepRadius(param1:b2Vec2) : void
        {
            var _loc2_:b2Vec2 = null;
            var _loc4_:Number = NaN;
            var _loc5_:Number = NaN;
            m_sweepRadius = 0;
            var _loc3_:int = 0;
            while(_loc3_ < this.m_vertexCount)
            {
                _loc2_ = this.m_coreVertices[_loc3_];
                _loc4_ = _loc2_.x - param1.x;
                _loc5_ = _loc2_.y - param1.y;
                _loc4_ = Math.sqrt(_loc4_ * _loc4_ + _loc5_ * _loc5_);
                if(_loc4_ > m_sweepRadius)
                {
                    m_sweepRadius = _loc4_;
                }
                _loc3_++;
            }
        }
    }
}

