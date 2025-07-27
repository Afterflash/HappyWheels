package Box2D.Collision
{
    import Box2D.Common.*;
    import Box2D.Common.Math.*;
    
    public class b2BroadPhase
    {
        public static var s_validate:Boolean = false;
        
        public static const b2_invalid:uint = b2Settings.USHRT_MAX;
        
        public static const b2_nullEdge:uint = b2Settings.USHRT_MAX;
        
        public var m_pairManager:b2PairManager;
        
        public var m_proxyPool:Array;
        
        public var m_freeProxy:uint;
        
        public var m_bounds:Array;
        
        public var m_queryResults:Array;
        
        public var m_queryResultCount:int;
        
        public var m_worldAABB:b2AABB;
        
        public var m_quantizationFactor:b2Vec2;
        
        public var m_proxyCount:int;
        
        public var m_timeStamp:uint;
        
        public function b2BroadPhase(param1:b2AABB, param2:b2PairCallback)
        {
            var _loc3_:int = 0;
            var _loc5_:Number = NaN;
            var _loc6_:b2Proxy = null;
            var _loc7_:int = 0;
            this.m_pairManager = new b2PairManager();
            this.m_proxyPool = new Array(b2Settings.b2_maxPairs);
            this.m_bounds = new Array(2 * b2Settings.b2_maxProxies);
            this.m_queryResults = new Array(b2Settings.b2_maxProxies);
            this.m_quantizationFactor = new b2Vec2();
            super();
            this.m_pairManager.Initialize(this,param2);
            this.m_worldAABB = param1;
            this.m_proxyCount = 0;
            _loc3_ = 0;
            while(_loc3_ < b2Settings.b2_maxProxies)
            {
                this.m_queryResults[_loc3_] = 0;
                _loc3_++;
            }
            this.m_bounds = new Array(2);
            _loc3_ = 0;
            while(_loc3_ < 2)
            {
                this.m_bounds[_loc3_] = new Array(2 * b2Settings.b2_maxProxies);
                _loc7_ = 0;
                while(_loc7_ < 2 * b2Settings.b2_maxProxies)
                {
                    this.m_bounds[_loc3_][_loc7_] = new b2Bound();
                    _loc7_++;
                }
                _loc3_++;
            }
            var _loc4_:Number = param1.upperBound.x - param1.lowerBound.x;
            _loc5_ = param1.upperBound.y - param1.lowerBound.y;
            this.m_quantizationFactor.x = b2Settings.USHRT_MAX / _loc4_;
            this.m_quantizationFactor.y = b2Settings.USHRT_MAX / _loc5_;
            _loc3_ = 0;
            while(_loc3_ < b2Settings.b2_maxProxies - 1)
            {
                _loc6_ = new b2Proxy();
                this.m_proxyPool[_loc3_] = _loc6_;
                _loc6_.SetNext(_loc3_ + 1);
                _loc6_.timeStamp = 0;
                _loc6_.overlapCount = b2_invalid;
                _loc6_.userData = null;
                _loc3_++;
            }
            _loc6_ = new b2Proxy();
            this.m_proxyPool[int(b2Settings.b2_maxProxies - 1)] = _loc6_;
            _loc6_.SetNext(b2Pair.b2_nullProxy);
            _loc6_.timeStamp = 0;
            _loc6_.overlapCount = b2_invalid;
            _loc6_.userData = null;
            this.m_freeProxy = 0;
            this.m_timeStamp = 1;
            this.m_queryResultCount = 0;
        }
        
        public static function BinarySearch(param1:Array, param2:int, param3:uint) : uint
        {
            var _loc6_:int = 0;
            var _loc7_:b2Bound = null;
            var _loc4_:int = 0;
            var _loc5_:int = param2 - 1;
            while(_loc4_ <= _loc5_)
            {
                _loc6_ = (_loc4_ + _loc5_) / 2;
                _loc7_ = param1[_loc6_];
                if(_loc7_.value > param3)
                {
                    _loc5_ = _loc6_ - 1;
                }
                else
                {
                    if(_loc7_.value >= param3)
                    {
                        return uint(_loc6_);
                    }
                    _loc4_ = _loc6_ + 1;
                }
            }
            return uint(_loc4_);
        }
        
        public function InRange(param1:b2AABB) : Boolean
        {
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            var _loc4_:Number = NaN;
            var _loc5_:Number = NaN;
            _loc2_ = param1.lowerBound.x;
            _loc3_ = param1.lowerBound.y;
            _loc2_ -= this.m_worldAABB.upperBound.x;
            _loc3_ -= this.m_worldAABB.upperBound.y;
            _loc4_ = this.m_worldAABB.lowerBound.x;
            _loc5_ = this.m_worldAABB.lowerBound.y;
            _loc4_ -= param1.upperBound.x;
            _loc5_ -= param1.upperBound.y;
            _loc2_ = b2Math.b2Max(_loc2_,_loc4_);
            _loc3_ = b2Math.b2Max(_loc3_,_loc5_);
            return b2Math.b2Max(_loc2_,_loc3_) < 0;
        }
        
        public function GetProxy(param1:int) : b2Proxy
        {
            var _loc2_:b2Proxy = this.m_proxyPool[param1];
            if(param1 == b2Pair.b2_nullProxy || _loc2_.IsValid() == false)
            {
                return null;
            }
            return _loc2_;
        }
        
        public function CreateProxy(param1:b2AABB, param2:*) : uint
        {
            var _loc3_:* = 0;
            var _loc4_:b2Proxy = null;
            var _loc11_:Array = null;
            var _loc12_:* = 0;
            var _loc13_:* = 0;
            var _loc14_:Array = null;
            var _loc15_:Array = null;
            var _loc16_:Array = null;
            var _loc17_:int = 0;
            var _loc18_:int = 0;
            var _loc19_:b2Bound = null;
            var _loc20_:b2Bound = null;
            var _loc21_:b2Bound = null;
            var _loc22_:int = 0;
            var _loc23_:b2Proxy = null;
            var _loc5_:uint = this.m_freeProxy;
            _loc4_ = this.m_proxyPool[_loc5_];
            this.m_freeProxy = _loc4_.GetNext();
            _loc4_.overlapCount = 0;
            _loc4_.userData = param2;
            var _loc6_:uint = 2 * this.m_proxyCount;
            var _loc7_:Array = new Array();
            var _loc8_:Array = new Array();
            this.ComputeBounds(_loc7_,_loc8_,param1);
            var _loc9_:int = 0;
            while(_loc9_ < 2)
            {
                _loc11_ = this.m_bounds[_loc9_];
                _loc14_ = [_loc12_];
                _loc15_ = [_loc13_];
                this.Query(_loc14_,_loc15_,_loc7_[_loc9_],_loc8_[_loc9_],_loc11_,_loc6_,_loc9_);
                _loc12_ = uint(_loc14_[0]);
                _loc13_ = uint(_loc15_[0]);
                _loc16_ = new Array();
                _loc18_ = _loc6_ - _loc13_;
                _loc17_ = 0;
                while(_loc17_ < _loc18_)
                {
                    _loc16_[_loc17_] = new b2Bound();
                    _loc19_ = _loc16_[_loc17_];
                    _loc20_ = _loc11_[int(_loc13_ + _loc17_)];
                    _loc19_.value = _loc20_.value;
                    _loc19_.proxyId = _loc20_.proxyId;
                    _loc19_.stabbingCount = _loc20_.stabbingCount;
                    _loc17_++;
                }
                _loc18_ = int(_loc16_.length);
                _loc22_ = _loc13_ + 2;
                _loc17_ = 0;
                while(_loc17_ < _loc18_)
                {
                    _loc20_ = _loc16_[_loc17_];
                    _loc19_ = _loc11_[int(_loc22_ + _loc17_)];
                    _loc19_.value = _loc20_.value;
                    _loc19_.proxyId = _loc20_.proxyId;
                    _loc19_.stabbingCount = _loc20_.stabbingCount;
                    _loc17_++;
                }
                _loc16_ = new Array();
                _loc18_ = _loc13_ - _loc12_;
                _loc17_ = 0;
                while(_loc17_ < _loc18_)
                {
                    _loc16_[_loc17_] = new b2Bound();
                    _loc19_ = _loc16_[_loc17_];
                    _loc20_ = _loc11_[int(_loc12_ + _loc17_)];
                    _loc19_.value = _loc20_.value;
                    _loc19_.proxyId = _loc20_.proxyId;
                    _loc19_.stabbingCount = _loc20_.stabbingCount;
                    _loc17_++;
                }
                _loc18_ = int(_loc16_.length);
                _loc22_ = _loc12_ + 1;
                _loc17_ = 0;
                while(_loc17_ < _loc18_)
                {
                    _loc20_ = _loc16_[_loc17_];
                    _loc19_ = _loc11_[int(_loc22_ + _loc17_)];
                    _loc19_.value = _loc20_.value;
                    _loc19_.proxyId = _loc20_.proxyId;
                    _loc19_.stabbingCount = _loc20_.stabbingCount;
                    _loc17_++;
                }
                _loc13_++;
                _loc19_ = _loc11_[_loc12_];
                _loc20_ = _loc11_[_loc13_];
                _loc19_.value = _loc7_[_loc9_];
                _loc19_.proxyId = _loc5_;
                _loc20_.value = _loc8_[_loc9_];
                _loc20_.proxyId = _loc5_;
                _loc21_ = _loc11_[int(_loc12_ - 1)];
                _loc19_.stabbingCount = _loc12_ == 0 ? 0 : _loc21_.stabbingCount;
                _loc21_ = _loc11_[int(_loc13_ - 1)];
                _loc20_.stabbingCount = _loc21_.stabbingCount;
                _loc3_ = _loc12_;
                while(_loc3_ < _loc13_)
                {
                    _loc21_ = _loc11_[_loc3_];
                    ++_loc21_.stabbingCount;
                    _loc3_++;
                }
                _loc3_ = _loc12_;
                while(_loc3_ < _loc6_ + 2)
                {
                    _loc19_ = _loc11_[_loc3_];
                    _loc23_ = this.m_proxyPool[_loc19_.proxyId];
                    if(_loc19_.IsLower())
                    {
                        _loc23_.lowerBounds[_loc9_] = _loc3_;
                    }
                    else
                    {
                        _loc23_.upperBounds[_loc9_] = _loc3_;
                    }
                    _loc3_++;
                }
                _loc9_++;
            }
            ++this.m_proxyCount;
            var _loc10_:int = 0;
            while(_loc10_ < this.m_queryResultCount)
            {
                this.m_pairManager.AddBufferedPair(_loc5_,this.m_queryResults[_loc10_]);
                _loc10_++;
            }
            this.m_pairManager.Commit();
            this.m_queryResultCount = 0;
            this.IncrementTimeStamp();
            return _loc5_;
        }
        
        public function DestroyProxy(param1:uint) : void
        {
            var _loc2_:b2Bound = null;
            var _loc3_:b2Bound = null;
            var _loc8_:Array = null;
            var _loc9_:* = 0;
            var _loc10_:* = 0;
            var _loc11_:* = 0;
            var _loc12_:* = 0;
            var _loc13_:Array = null;
            var _loc14_:int = 0;
            var _loc15_:int = 0;
            var _loc16_:int = 0;
            var _loc17_:* = 0;
            var _loc18_:int = 0;
            var _loc19_:b2Proxy = null;
            var _loc4_:b2Proxy = this.m_proxyPool[param1];
            var _loc5_:int = 2 * this.m_proxyCount;
            var _loc6_:int = 0;
            while(_loc6_ < 2)
            {
                _loc8_ = this.m_bounds[_loc6_];
                _loc9_ = uint(_loc4_.lowerBounds[_loc6_]);
                _loc10_ = uint(_loc4_.upperBounds[_loc6_]);
                _loc2_ = _loc8_[_loc9_];
                _loc11_ = _loc2_.value;
                _loc3_ = _loc8_[_loc10_];
                _loc12_ = _loc3_.value;
                _loc13_ = new Array();
                _loc15_ = _loc10_ - _loc9_ - 1;
                _loc14_ = 0;
                while(_loc14_ < _loc15_)
                {
                    _loc13_[_loc14_] = new b2Bound();
                    _loc2_ = _loc13_[_loc14_];
                    _loc3_ = _loc8_[int(_loc9_ + 1 + _loc14_)];
                    _loc2_.value = _loc3_.value;
                    _loc2_.proxyId = _loc3_.proxyId;
                    _loc2_.stabbingCount = _loc3_.stabbingCount;
                    _loc14_++;
                }
                _loc15_ = int(_loc13_.length);
                _loc16_ = int(_loc9_);
                _loc14_ = 0;
                while(_loc14_ < _loc15_)
                {
                    _loc3_ = _loc13_[_loc14_];
                    _loc2_ = _loc8_[int(_loc16_ + _loc14_)];
                    _loc2_.value = _loc3_.value;
                    _loc2_.proxyId = _loc3_.proxyId;
                    _loc2_.stabbingCount = _loc3_.stabbingCount;
                    _loc14_++;
                }
                _loc13_ = new Array();
                _loc15_ = _loc5_ - _loc10_ - 1;
                _loc14_ = 0;
                while(_loc14_ < _loc15_)
                {
                    _loc13_[_loc14_] = new b2Bound();
                    _loc2_ = _loc13_[_loc14_];
                    _loc3_ = _loc8_[int(_loc10_ + 1 + _loc14_)];
                    _loc2_.value = _loc3_.value;
                    _loc2_.proxyId = _loc3_.proxyId;
                    _loc2_.stabbingCount = _loc3_.stabbingCount;
                    _loc14_++;
                }
                _loc15_ = int(_loc13_.length);
                _loc16_ = int(_loc10_ - 1);
                _loc14_ = 0;
                while(_loc14_ < _loc15_)
                {
                    _loc3_ = _loc13_[_loc14_];
                    _loc2_ = _loc8_[int(_loc16_ + _loc14_)];
                    _loc2_.value = _loc3_.value;
                    _loc2_.proxyId = _loc3_.proxyId;
                    _loc2_.stabbingCount = _loc3_.stabbingCount;
                    _loc14_++;
                }
                _loc15_ = _loc5_ - 2;
                _loc17_ = _loc9_;
                while(_loc17_ < _loc15_)
                {
                    _loc2_ = _loc8_[_loc17_];
                    _loc19_ = this.m_proxyPool[_loc2_.proxyId];
                    if(_loc2_.IsLower())
                    {
                        _loc19_.lowerBounds[_loc6_] = _loc17_;
                    }
                    else
                    {
                        _loc19_.upperBounds[_loc6_] = _loc17_;
                    }
                    _loc17_++;
                }
                _loc15_ = int(_loc10_ - 1);
                _loc18_ = int(_loc9_);
                while(_loc18_ < _loc15_)
                {
                    _loc2_ = _loc8_[_loc18_];
                    --_loc2_.stabbingCount;
                    _loc18_++;
                }
                this.Query([0],[0],_loc11_,_loc12_,_loc8_,_loc5_ - 2,_loc6_);
                _loc6_++;
            }
            var _loc7_:int = 0;
            while(_loc7_ < this.m_queryResultCount)
            {
                this.m_pairManager.RemoveBufferedPair(param1,this.m_queryResults[_loc7_]);
                _loc7_++;
            }
            this.m_pairManager.Commit();
            this.m_queryResultCount = 0;
            this.IncrementTimeStamp();
            _loc4_.userData = null;
            _loc4_.overlapCount = b2_invalid;
            _loc4_.lowerBounds[0] = b2_invalid;
            _loc4_.lowerBounds[1] = b2_invalid;
            _loc4_.upperBounds[0] = b2_invalid;
            _loc4_.upperBounds[1] = b2_invalid;
            _loc4_.SetNext(this.m_freeProxy);
            this.m_freeProxy = param1;
            --this.m_proxyCount;
        }
        
        public function MoveProxy(param1:uint, param2:b2AABB) : void
        {
            var _loc3_:Array = null;
            var _loc4_:* = 0;
            var _loc5_:Number = 0;
            var _loc6_:* = 0;
            var _loc7_:b2Bound = null;
            var _loc8_:b2Bound = null;
            var _loc9_:b2Bound = null;
            var _loc10_:* = 0;
            var _loc11_:b2Proxy = null;
            var _loc16_:Array = null;
            var _loc17_:* = 0;
            var _loc18_:* = 0;
            var _loc19_:* = 0;
            var _loc20_:* = 0;
            var _loc21_:int = 0;
            var _loc22_:int = 0;
            var _loc23_:* = 0;
            var _loc24_:b2Proxy = null;
            if(param1 == b2Pair.b2_nullProxy || b2Settings.b2_maxProxies <= param1)
            {
                return;
            }
            if(param2.IsValid() == false)
            {
                return;
            }
            var _loc12_:uint = 2 * this.m_proxyCount;
            var _loc13_:b2Proxy = this.m_proxyPool[param1];
            var _loc14_:b2BoundValues = new b2BoundValues();
            this.ComputeBounds(_loc14_.lowerValues,_loc14_.upperValues,param2);
            var _loc15_:b2BoundValues = new b2BoundValues();
            _loc5_ = 0;
            while(_loc5_ < 2)
            {
                _loc7_ = this.m_bounds[_loc5_][_loc13_.lowerBounds[_loc5_]];
                _loc15_.lowerValues[_loc5_] = _loc7_.value;
                _loc7_ = this.m_bounds[_loc5_][_loc13_.upperBounds[_loc5_]];
                _loc15_.upperValues[_loc5_] = _loc7_.value;
                _loc5_++;
            }
            _loc5_ = 0;
            while(_loc5_ < 2)
            {
                _loc16_ = this.m_bounds[_loc5_];
                _loc17_ = uint(_loc13_.lowerBounds[_loc5_]);
                _loc18_ = uint(_loc13_.upperBounds[_loc5_]);
                _loc19_ = uint(_loc14_.lowerValues[_loc5_]);
                _loc20_ = uint(_loc14_.upperValues[_loc5_]);
                _loc7_ = _loc16_[_loc17_];
                _loc21_ = _loc19_ - _loc7_.value;
                _loc7_.value = _loc19_;
                _loc7_ = _loc16_[_loc18_];
                _loc22_ = _loc20_ - _loc7_.value;
                _loc7_.value = _loc20_;
                if(_loc21_ < 0)
                {
                    _loc6_ = _loc17_;
                    while(_loc6_ > 0 && _loc19_ < (_loc16_[int(_loc6_ - 1)] as b2Bound).value)
                    {
                        _loc7_ = _loc16_[_loc6_];
                        _loc8_ = _loc16_[int(_loc6_ - 1)];
                        _loc23_ = _loc8_.proxyId;
                        _loc24_ = this.m_proxyPool[_loc8_.proxyId];
                        ++_loc8_.stabbingCount;
                        if(_loc8_.IsUpper() == true)
                        {
                            if(this.TestOverlap(_loc14_,_loc24_))
                            {
                                this.m_pairManager.AddBufferedPair(param1,_loc23_);
                            }
                            _loc3_ = _loc24_.upperBounds;
                            _loc4_ = int(_loc3_[_loc5_]);
                            _loc4_ = _loc4_ + 1;
                            _loc3_[_loc5_] = _loc4_;
                            ++_loc7_.stabbingCount;
                        }
                        else
                        {
                            _loc3_ = _loc24_.lowerBounds;
                            _loc4_ = int(_loc3_[_loc5_]);
                            _loc4_ = _loc4_ + 1;
                            _loc3_[_loc5_] = _loc4_;
                            --_loc7_.stabbingCount;
                        }
                        _loc3_ = _loc13_.lowerBounds;
                        _loc4_ = int(_loc3_[_loc5_]);
                        _loc4_ = _loc4_ - 1;
                        _loc3_[_loc5_] = _loc4_;
                        _loc7_.Swap(_loc8_);
                        _loc6_--;
                    }
                }
                if(_loc22_ > 0)
                {
                    _loc6_ = _loc18_;
                    while(_loc6_ < _loc12_ - 1 && (_loc16_[int(_loc6_ + 1)] as b2Bound).value <= _loc20_)
                    {
                        _loc7_ = _loc16_[_loc6_];
                        _loc9_ = _loc16_[int(_loc6_ + 1)];
                        _loc10_ = _loc9_.proxyId;
                        _loc11_ = this.m_proxyPool[_loc10_];
                        ++_loc9_.stabbingCount;
                        if(_loc9_.IsLower() == true)
                        {
                            if(this.TestOverlap(_loc14_,_loc11_))
                            {
                                this.m_pairManager.AddBufferedPair(param1,_loc10_);
                            }
                            _loc3_ = _loc11_.lowerBounds;
                            _loc4_ = int(_loc3_[_loc5_]);
                            _loc4_ = _loc4_ - 1;
                            _loc3_[_loc5_] = _loc4_;
                            ++_loc7_.stabbingCount;
                        }
                        else
                        {
                            _loc3_ = _loc11_.upperBounds;
                            _loc4_ = int(_loc3_[_loc5_]);
                            _loc4_ = _loc4_ - 1;
                            _loc3_[_loc5_] = _loc4_;
                            --_loc7_.stabbingCount;
                        }
                        _loc3_ = _loc13_.upperBounds;
                        _loc4_ = int(_loc3_[_loc5_]);
                        _loc4_ = _loc4_ + 1;
                        _loc3_[_loc5_] = _loc4_;
                        _loc7_.Swap(_loc9_);
                        _loc6_++;
                    }
                }
                if(_loc21_ > 0)
                {
                    _loc6_ = _loc17_;
                    while(_loc6_ < _loc12_ - 1 && (_loc16_[int(_loc6_ + 1)] as b2Bound).value <= _loc19_)
                    {
                        _loc7_ = _loc16_[_loc6_];
                        _loc9_ = _loc16_[int(_loc6_ + 1)];
                        _loc10_ = _loc9_.proxyId;
                        _loc11_ = this.m_proxyPool[_loc10_];
                        --_loc9_.stabbingCount;
                        if(_loc9_.IsUpper())
                        {
                            if(this.TestOverlap(_loc15_,_loc11_))
                            {
                                this.m_pairManager.RemoveBufferedPair(param1,_loc10_);
                            }
                            _loc3_ = _loc11_.upperBounds;
                            _loc4_ = int(_loc3_[_loc5_]);
                            _loc4_ = _loc4_ - 1;
                            _loc3_[_loc5_] = _loc4_;
                            --_loc7_.stabbingCount;
                        }
                        else
                        {
                            _loc3_ = _loc11_.lowerBounds;
                            _loc4_ = int(_loc3_[_loc5_]);
                            _loc4_ = _loc4_ - 1;
                            _loc3_[_loc5_] = _loc4_;
                            ++_loc7_.stabbingCount;
                        }
                        _loc3_ = _loc13_.lowerBounds;
                        _loc4_ = int(_loc3_[_loc5_]);
                        _loc4_ = _loc4_ + 1;
                        _loc3_[_loc5_] = _loc4_;
                        _loc7_.Swap(_loc9_);
                        _loc6_++;
                    }
                }
                if(_loc22_ < 0)
                {
                    _loc6_ = _loc18_;
                    while(_loc6_ > 0 && _loc20_ < (_loc16_[int(_loc6_ - 1)] as b2Bound).value)
                    {
                        _loc7_ = _loc16_[_loc6_];
                        _loc8_ = _loc16_[int(_loc6_ - 1)];
                        _loc23_ = _loc8_.proxyId;
                        _loc24_ = this.m_proxyPool[_loc23_];
                        --_loc8_.stabbingCount;
                        if(_loc8_.IsLower() == true)
                        {
                            if(this.TestOverlap(_loc15_,_loc24_))
                            {
                                this.m_pairManager.RemoveBufferedPair(param1,_loc23_);
                            }
                            _loc3_ = _loc24_.lowerBounds;
                            _loc4_ = int(_loc3_[_loc5_]);
                            _loc4_ = _loc4_ + 1;
                            _loc3_[_loc5_] = _loc4_;
                            --_loc7_.stabbingCount;
                        }
                        else
                        {
                            _loc3_ = _loc24_.upperBounds;
                            _loc4_ = int(_loc3_[_loc5_]);
                            _loc4_ = _loc4_ + 1;
                            _loc3_[_loc5_] = _loc4_;
                            ++_loc7_.stabbingCount;
                        }
                        _loc3_ = _loc13_.upperBounds;
                        _loc4_ = int(_loc3_[_loc5_]);
                        _loc4_ = _loc4_ - 1;
                        _loc3_[_loc5_] = _loc4_;
                        _loc7_.Swap(_loc8_);
                        _loc6_--;
                    }
                }
                _loc5_++;
            }
        }
        
        public function Commit() : void
        {
            this.m_pairManager.Commit();
        }
        
        public function QueryAABB(param1:b2AABB, param2:*, param3:int) : int
        {
            var _loc6_:Number = 0;
            var _loc7_:Number = 0;
            var _loc12_:b2Proxy = null;
            var _loc4_:Array = new Array();
            var _loc5_:Array = new Array();
            this.ComputeBounds(_loc4_,_loc5_,param1);
            var _loc8_:Array = [_loc6_];
            var _loc9_:Array = [_loc7_];
            this.Query(_loc8_,_loc9_,_loc4_[0],_loc5_[0],this.m_bounds[0],2 * this.m_proxyCount,0);
            this.Query(_loc8_,_loc9_,_loc4_[1],_loc5_[1],this.m_bounds[1],2 * this.m_proxyCount,1);
            var _loc10_:int = 0;
            var _loc11_:int = 0;
            while(_loc11_ < this.m_queryResultCount && _loc10_ < param3)
            {
                _loc12_ = this.m_proxyPool[this.m_queryResults[_loc11_]];
                param2[_loc11_] = _loc12_.userData;
                _loc11_++;
                _loc10_++;
            }
            this.m_queryResultCount = 0;
            this.IncrementTimeStamp();
            return _loc10_;
        }
        
        public function Validate() : void
        {
            var _loc1_:b2Pair = null;
            var _loc2_:b2Proxy = null;
            var _loc3_:b2Proxy = null;
            var _loc4_:Boolean = false;
            var _loc6_:b2Bound = null;
            var _loc7_:* = 0;
            var _loc8_:Number = 0;
            var _loc9_:Number = 0;
            var _loc10_:b2Bound = null;
            var _loc5_:int = 0;
            while(_loc5_ < 2)
            {
                _loc6_ = this.m_bounds[_loc5_];
                _loc7_ = 2 * this.m_proxyCount;
                _loc8_ = 0;
                _loc9_ = 0;
                while(_loc9_ < _loc7_)
                {
                    _loc10_ = _loc6_[_loc9_];
                    if(_loc10_.IsLower() == true)
                    {
                        _loc8_++;
                    }
                    else
                    {
                        _loc8_--;
                    }
                    _loc9_++;
                }
                _loc5_++;
            }
        }
        
        private function ComputeBounds(param1:Array, param2:Array, param3:b2AABB) : void
        {
            var _loc4_:Number = param3.lowerBound.x;
            var _loc5_:Number = param3.lowerBound.y;
            _loc4_ = b2Math.b2Min(_loc4_,this.m_worldAABB.upperBound.x);
            _loc5_ = b2Math.b2Min(_loc5_,this.m_worldAABB.upperBound.y);
            _loc4_ = b2Math.b2Max(_loc4_,this.m_worldAABB.lowerBound.x);
            _loc5_ = b2Math.b2Max(_loc5_,this.m_worldAABB.lowerBound.y);
            var _loc6_:Number = param3.upperBound.x;
            var _loc7_:Number = param3.upperBound.y;
            _loc6_ = b2Math.b2Min(_loc6_,this.m_worldAABB.upperBound.x);
            _loc7_ = b2Math.b2Min(_loc7_,this.m_worldAABB.upperBound.y);
            _loc6_ = b2Math.b2Max(_loc6_,this.m_worldAABB.lowerBound.x);
            _loc7_ = b2Math.b2Max(_loc7_,this.m_worldAABB.lowerBound.y);
            param1[0] = uint(this.m_quantizationFactor.x * (_loc4_ - this.m_worldAABB.lowerBound.x)) & b2Settings.USHRT_MAX - 1;
            param2[0] = uint(this.m_quantizationFactor.x * (_loc6_ - this.m_worldAABB.lowerBound.x)) & 65535 | 1;
            param1[1] = uint(this.m_quantizationFactor.y * (_loc5_ - this.m_worldAABB.lowerBound.y)) & b2Settings.USHRT_MAX - 1;
            param2[1] = uint(this.m_quantizationFactor.y * (_loc7_ - this.m_worldAABB.lowerBound.y)) & 65535 | 1;
        }
        
        private function TestOverlapValidate(param1:b2Proxy, param2:b2Proxy) : Boolean
        {
            var _loc4_:Array = null;
            var _loc5_:b2Bound = null;
            var _loc6_:b2Bound = null;
            var _loc3_:int = 0;
            while(_loc3_ < 2)
            {
                _loc4_ = this.m_bounds[_loc3_];
                _loc5_ = _loc4_[param1.lowerBounds[_loc3_]];
                _loc6_ = _loc4_[param2.upperBounds[_loc3_]];
                if(_loc5_.value > _loc6_.value)
                {
                    return false;
                }
                _loc5_ = _loc4_[param1.upperBounds[_loc3_]];
                _loc6_ = _loc4_[param2.lowerBounds[_loc3_]];
                if(_loc5_.value < _loc6_.value)
                {
                    return false;
                }
                _loc3_++;
            }
            return true;
        }
        
        public function TestOverlap(param1:b2BoundValues, param2:b2Proxy) : Boolean
        {
            var _loc4_:Array = null;
            var _loc5_:b2Bound = null;
            var _loc3_:int = 0;
            while(_loc3_ < 2)
            {
                _loc4_ = this.m_bounds[_loc3_];
                _loc5_ = _loc4_[param2.upperBounds[_loc3_]];
                if(param1.lowerValues[_loc3_] > _loc5_.value)
                {
                    return false;
                }
                _loc5_ = _loc4_[param2.lowerBounds[_loc3_]];
                if(param1.upperValues[_loc3_] < _loc5_.value)
                {
                    return false;
                }
                _loc3_++;
            }
            return true;
        }
        
        private function Query(param1:Array, param2:Array, param3:uint, param4:uint, param5:Array, param6:uint, param7:int) : void
        {
            var _loc10_:b2Bound = null;
            var _loc12_:int = 0;
            var _loc13_:int = 0;
            var _loc14_:b2Proxy = null;
            var _loc8_:uint = BinarySearch(param5,param6,param3);
            var _loc9_:uint = BinarySearch(param5,param6,param4);
            var _loc11_:uint = _loc8_;
            while(_loc11_ < _loc9_)
            {
                _loc10_ = param5[_loc11_];
                if(_loc10_.IsLower())
                {
                    this.IncrementOverlapCount(_loc10_.proxyId);
                }
                _loc11_++;
            }
            if(_loc8_ > 0)
            {
                _loc12_ = int(_loc8_ - 1);
                _loc10_ = param5[_loc12_];
                _loc13_ = int(_loc10_.stabbingCount);
                while(_loc13_)
                {
                    _loc10_ = param5[_loc12_];
                    if(_loc10_.IsLower())
                    {
                        _loc14_ = this.m_proxyPool[_loc10_.proxyId];
                        if(_loc8_ <= _loc14_.upperBounds[param7])
                        {
                            this.IncrementOverlapCount(_loc10_.proxyId);
                            _loc13_--;
                        }
                    }
                    _loc12_--;
                }
            }
            param1[0] = _loc8_;
            param2[0] = _loc9_;
        }
        
        private function IncrementOverlapCount(param1:uint) : void
        {
            var _loc2_:b2Proxy = this.m_proxyPool[param1];
            if(_loc2_.timeStamp < this.m_timeStamp)
            {
                _loc2_.timeStamp = this.m_timeStamp;
                _loc2_.overlapCount = 1;
            }
            else
            {
                _loc2_.overlapCount = 2;
                this.m_queryResults[this.m_queryResultCount] = param1;
                ++this.m_queryResultCount;
            }
        }
        
        private function IncrementTimeStamp() : void
        {
            var _loc1_:Number = 0;
            if(this.m_timeStamp == b2Settings.USHRT_MAX)
            {
                _loc1_ = 0;
                while(_loc1_ < b2Settings.b2_maxProxies)
                {
                    (this.m_proxyPool[_loc1_] as b2Proxy).timeStamp = 0;
                    _loc1_++;
                }
                this.m_timeStamp = 1;
            }
            else
            {
                ++this.m_timeStamp;
            }
        }
    }
}

