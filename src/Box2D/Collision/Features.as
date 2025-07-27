package Box2D.Collision
{
    public class Features
    {
        public var _referenceEdge:int;
        
        public var _incidentEdge:int;
        
        public var _incidentVertex:int;
        
        public var _flip:int;
        
        public var _m_id:b2ContactID;
        
        public function Features()
        {
            super();
        }
        
        public function set referenceEdge(param1:int) : void
        {
            this._referenceEdge = param1;
            this._m_id._key = this._m_id._key & 4294967040 | this._referenceEdge & 255;
        }
        
        public function get referenceEdge() : int
        {
            return this._referenceEdge;
        }
        
        public function set incidentEdge(param1:int) : void
        {
            this._incidentEdge = param1;
            this._m_id._key = this._m_id._key & 4294902015 | this._incidentEdge << 8 & 65280;
        }
        
        public function get incidentEdge() : int
        {
            return this._incidentEdge;
        }
        
        public function set incidentVertex(param1:int) : void
        {
            this._incidentVertex = param1;
            this._m_id._key = this._m_id._key & 4278255615 | this._incidentVertex << 16 & 16711680;
        }
        
        public function get incidentVertex() : int
        {
            return this._incidentVertex;
        }
        
        public function set flip(param1:int) : void
        {
            this._flip = param1;
            this._m_id._key = this._m_id._key & 16777215 | this._flip << 24 & 4278190080;
        }
        
        public function get flip() : int
        {
            return this._flip;
        }
    }
}

