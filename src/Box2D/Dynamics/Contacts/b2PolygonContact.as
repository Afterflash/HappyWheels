package Box2D.Dynamics.Contacts
{
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    
    public class b2PolygonContact extends b2Contact
    {
        private static const s_evalCP:b2ContactPoint = new b2ContactPoint();
        
        private var m0:b2Manifold = new b2Manifold();
        
        private var m_manifolds:Array = [new b2Manifold()];
        
        public var m_manifold:b2Manifold;
        
        public function b2PolygonContact(param1:b2Shape, param2:b2Shape)
        {
            super(param1,param2);
            this.m_manifold = this.m_manifolds[0];
            this.m_manifold.pointCount = 0;
        }
        
        public static function Create(param1:b2Shape, param2:b2Shape, param3:*) : b2Contact
        {
            return new b2PolygonContact(param1,param2);
        }
        
        public static function Destroy(param1:b2Contact, param2:*) : void
        {
        }
        
        override public function Evaluate(param1:b2ContactListener) : void
        {
            var _loc2_:b2Vec2 = null;
            var _loc3_:b2Vec2 = null;
            var _loc4_:b2ManifoldPoint = null;
            var _loc7_:b2ContactPoint = null;
            var _loc8_:int = 0;
            var _loc10_:b2ManifoldPoint = null;
            var _loc11_:Boolean = false;
            var _loc12_:* = 0;
            var _loc13_:int = 0;
            var _loc5_:b2Body = m_shape1.m_body;
            var _loc6_:b2Body = m_shape2.m_body;
            this.m0.Set(this.m_manifold);
            b2Collision.b2CollidePolygons(this.m_manifold,m_shape1 as b2PolygonShape,_loc5_.m_xf,m_shape2 as b2PolygonShape,_loc6_.m_xf);
            var _loc9_:Array = [false,false];
            _loc7_ = s_evalCP;
            _loc7_.shape1 = m_shape1;
            _loc7_.shape2 = m_shape2;
            _loc7_.friction = m_friction;
            _loc7_.restitution = m_restitution;
            if(this.m_manifold.pointCount > 0)
            {
                _loc8_ = 0;
                while(_loc8_ < this.m_manifold.pointCount)
                {
                    _loc10_ = this.m_manifold.points[_loc8_];
                    _loc10_.normalImpulse = 0;
                    _loc10_.tangentImpulse = 0;
                    _loc11_ = false;
                    _loc12_ = _loc10_.id._key;
                    _loc13_ = 0;
                    while(_loc13_ < this.m0.pointCount)
                    {
                        if(_loc9_[_loc13_] != true)
                        {
                            _loc4_ = this.m0.points[_loc13_];
                            if(_loc4_.id._key == _loc12_)
                            {
                                _loc9_[_loc13_] = true;
                                _loc10_.normalImpulse = _loc4_.normalImpulse;
                                _loc10_.tangentImpulse = _loc4_.tangentImpulse;
                                _loc11_ = true;
                                if(param1 != null)
                                {
                                    _loc7_.position = _loc5_.GetWorldPoint(_loc10_.localPoint1);
                                    _loc2_ = _loc5_.GetLinearVelocityFromLocalPoint(_loc10_.localPoint1);
                                    _loc3_ = _loc6_.GetLinearVelocityFromLocalPoint(_loc10_.localPoint2);
                                    _loc7_.velocity.Set(_loc3_.x - _loc2_.x,_loc3_.y - _loc2_.y);
                                    _loc7_.normal.SetV(this.m_manifold.normal);
                                    _loc7_.separation = _loc10_.separation;
                                    _loc7_.id.key = _loc12_;
                                    param1.Persist(_loc7_);
                                }
                                break;
                            }
                        }
                        _loc13_++;
                    }
                    if(_loc11_ == false && param1 != null)
                    {
                        _loc7_.position = _loc5_.GetWorldPoint(_loc10_.localPoint1);
                        _loc2_ = _loc5_.GetLinearVelocityFromLocalPoint(_loc10_.localPoint1);
                        _loc3_ = _loc6_.GetLinearVelocityFromLocalPoint(_loc10_.localPoint2);
                        _loc7_.velocity.Set(_loc3_.x - _loc2_.x,_loc3_.y - _loc2_.y);
                        _loc7_.normal.SetV(this.m_manifold.normal);
                        _loc7_.separation = _loc10_.separation;
                        _loc7_.id.key = _loc12_;
                        param1.Add(_loc7_);
                    }
                    _loc8_++;
                }
                m_manifoldCount = 1;
            }
            else
            {
                m_manifoldCount = 0;
            }
            if(param1 == null)
            {
                return;
            }
            _loc8_ = 0;
            while(_loc8_ < this.m0.pointCount)
            {
                if(!_loc9_[_loc8_])
                {
                    _loc4_ = this.m0.points[_loc8_];
                    _loc7_.position = _loc5_.GetWorldPoint(_loc4_.localPoint1);
                    _loc2_ = _loc5_.GetLinearVelocityFromLocalPoint(_loc4_.localPoint1);
                    _loc3_ = _loc6_.GetLinearVelocityFromLocalPoint(_loc4_.localPoint2);
                    _loc7_.velocity.Set(_loc3_.x - _loc2_.x,_loc3_.y - _loc2_.y);
                    _loc7_.normal.SetV(this.m0.normal);
                    _loc7_.separation = _loc4_.separation;
                    _loc7_.id.key = _loc4_.id._key;
                    param1.Remove(_loc7_);
                }
                _loc8_++;
            }
        }
        
        override public function GetManifolds() : Array
        {
            return this.m_manifolds;
        }
    }
}

