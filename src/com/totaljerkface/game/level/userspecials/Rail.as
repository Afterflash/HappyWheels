package com.totaljerkface.game.level.userspecials
{
    import Box2D.Collision.Shapes.b2PolygonDef;
    import Box2D.Collision.Shapes.b2Shape;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2World;
    import com.totaljerkface.game.ContactListener;
    import com.totaljerkface.game.Settings;
    import com.totaljerkface.game.editor.specials.RailRef;
    import com.totaljerkface.game.editor.specials.Special;
    import com.totaljerkface.game.level.LevelItem;
    import flash.display.Sprite;
    import flash.geom.Point;
    import flash.utils.Dictionary;
    
    public class Rail extends LevelItem
    {
        private static var idCounter:int = 0;
        
        private const maxSounds:int = 2;
        
        private var mc:RailMC;
        
        private var segmentCount:Number = 0;
        
        private var segmentWidth:Number = 0;
        
        public var height:Number = 18;
        
        private var body:b2Body;
        
        private var sensor:b2Shape;
        
        private var baseShape:b2Shape;
        
        private var angle:Number;
        
        private var add:Boolean;
        
        private var remove:Boolean;
        
        private var bodiesToAdd:Array;
        
        private var bodiesToRemove:Array;
        
        private var bjDictionary:Dictionary;
        
        private var countDictionary:Dictionary;
        
        private var halfWidth:Number;
        
        private var soundCounter:int = 0;
        
        public function Rail(param1:Special, param2:b2Body = null, param3:Point = null)
        {
            var _loc4_:RailRef = null;
            var _loc5_:Sprite = null;
            var _loc6_:b2World = null;
            super();
            _loc4_ = param1 as RailRef;
            _loc5_ = Settings.currentSession.level.background;
            _loc6_ = Settings.currentSession.m_world;
            var _loc7_:ContactListener = Settings.currentSession.contactListener;
            this.mc = new RailMC();
            this.mc.x = _loc4_.x;
            this.mc.y = _loc4_.y;
            this.mc.width = _loc4_.shapeWidth;
            this.mc.rotation = _loc4_.rotation;
            _loc5_.addChild(this.mc);
            var _loc8_:b2PolygonDef = new b2PolygonDef();
            _loc8_.friction = 0.3;
            _loc8_.restitution = 0.1;
            _loc8_.filter.categoryBits = 8;
            var _loc9_:Number = _loc4_.shapeWidth;
            var _loc10_:Number = this.height;
            _loc8_.SetAsOrientedBox(_loc9_ / 2 / m_physScale,_loc10_ / 4 / m_physScale,new b2Vec2(0,-_loc10_ / 4 / m_physScale));
            var _loc11_:b2BodyDef = new b2BodyDef();
            _loc11_.angle = _loc4_.rotation * Math.PI / 180;
            _loc11_.position = new b2Vec2(_loc4_.x / m_physScale,_loc4_.y / m_physScale);
            var _loc12_:b2Body = _loc6_.CreateBody(_loc11_);
            var _loc13_:b2Shape = _loc12_.CreateShape(_loc8_);
            _loc13_.SetMaterial(4);
            _loc8_.SetAsOrientedBox(_loc9_ / 2 / m_physScale,_loc10_ / 4 / m_physScale,new b2Vec2(0,_loc10_ / 4 / m_physScale));
            _loc12_.CreateShape(_loc8_);
        }
    }
}

