package Box2D.Collision
{
    import Box2D.Common.b2Settings;
    
    public class b2Pair
    {
        public static var b2_nullPair:uint = b2Settings.USHRT_MAX;
        
        public static var b2_nullProxy:uint = b2Settings.USHRT_MAX;
        
        public static var b2_tableCapacity:int = b2Settings.b2_maxPairs;
        
        public static var b2_tableMask:int = b2_tableCapacity - 1;
        
        public static var e_pairBuffered:uint = 1;
        
        public static var e_pairRemoved:uint = 2;
        
        public static var e_pairFinal:uint = 4;
        
        public var userData:* = null;
        
        public var proxyId1:uint;
        
        public var proxyId2:uint;
        
        public var next:uint;
        
        public var status:uint;
        
        public function b2Pair()
        {
            super();
        }
        
        public function SetBuffered() : void
        {
            this.status |= e_pairBuffered;
        }
        
        public function ClearBuffered() : void
        {
            this.status &= ~e_pairBuffered;
        }
        
        public function IsBuffered() : Boolean
        {
            return (this.status & e_pairBuffered) == e_pairBuffered;
        }
        
        public function SetRemoved() : void
        {
            this.status |= e_pairRemoved;
        }
        
        public function ClearRemoved() : void
        {
            this.status &= ~e_pairRemoved;
        }
        
        public function IsRemoved() : Boolean
        {
            return (this.status & e_pairRemoved) == e_pairRemoved;
        }
        
        public function SetFinal() : void
        {
            this.status |= e_pairFinal;
        }
        
        public function IsFinal() : Boolean
        {
            return (this.status & e_pairFinal) == e_pairFinal;
        }
    }
}

