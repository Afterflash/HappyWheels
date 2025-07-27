package com.totaljerkface.game.level.userspecials
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Collision.b2ContactPoint;
    import Box2D.Common.Math.b2Math;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.*;
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.editor.specials.*;
    import com.totaljerkface.game.events.*;
    import com.totaljerkface.game.level.*;
    import com.totaljerkface.game.sound.SoundController;
    import flash.display.*;
    
    public class Log extends LevelItem
    {
        private var mc:MovieClip;
        
        private var body:b2Body;
        
        private var shapeWidth:Number;
        
        private var shapeHeight:Number;
        
        private var center:b2Vec2;
        
        private var angle:Number;
        
        private var shape:b2Shape;
        
        public function Log(param1:Special)
        {
            super();
            var _loc2_:LogRef = param1 as LogRef;
            this.createBody(new b2Vec2(_loc2_.x,_loc2_.y),_loc2_.rotation * Math.PI / 180,_loc2_.shapeWidth,_loc2_.shapeHeight,_loc2_.immovable2,_loc2_.sleeping);
            this.shapeWidth = _loc2_.shapeWidth;
            this.shapeHeight = _loc2_.shapeHeight;
            this.mc = new LogMC();
            this.mc.width = this.shapeWidth;
            this.mc.height = this.shapeHeight;
            this.mc.x = _loc2_.x;
            this.mc.y = _loc2_.y;
            this.mc.rotation = _loc2_.rotation;
            var _loc3_:Sprite = Settings.currentSession.level.background;
            _loc3_.addChild(this.mc);
            Settings.currentSession.particleController.createBMDArray("woodchips",new WoodChipsMC());
        }
        
        internal function createBody(param1:b2Vec2, param2:Number, param3:Number, param4:Number, param5:Boolean, param6:Boolean) : void
        {
            var _loc7_:b2BodyDef = new b2BodyDef();
            var _loc8_:b2PolygonDef = new b2PolygonDef();
            _loc8_.density = 30;
            _loc8_.friction = 0.7;
            _loc8_.restitution = 0.2;
            _loc8_.filter.categoryBits = 8;
            var _loc9_:LevelB2D = Settings.currentSession.level;
            if(!param5)
            {
                _loc8_.SetAsBox(param3 * 0.5 / m_physScale,param4 * 0.5 / m_physScale);
                _loc7_.position.Set(param1.x / m_physScale,param1.y / m_physScale);
                _loc7_.angle = param2;
                _loc7_.isSleeping = param6;
                this.body = Settings.currentSession.m_world.CreateBody(_loc7_);
                this.shape = this.body.CreateShape(_loc8_);
                this.body.SetMassFromShapes();
                _loc9_.paintItemVector.push(this);
                Settings.currentSession.contactListener.registerListener(ContactListener.ADD,this.shape,this.checkAdd);
            }
            else
            {
                this.center = new b2Vec2(param1.x / m_physScale,param1.y / m_physScale);
                this.angle = param2;
                _loc8_.SetAsOrientedBox(param3 * 0.5 / m_physScale,param4 * 0.5 / m_physScale,this.center,param2);
                this.shape = _loc9_.levelBody.CreateShape(_loc8_);
                _loc9_.keepVector.push(this);
            }
            Settings.currentSession.contactListener.registerListener(ContactListener.RESULT,this.shape,this.checkContact);
        }
        
        override public function paint() : void
        {
            var _loc1_:b2Vec2 = this.body.GetWorldCenter();
            this.mc.x = _loc1_.x * m_physScale;
            this.mc.y = _loc1_.y * m_physScale;
            this.mc.rotation = this.body.GetAngle() * oneEightyOverPI % 360;
        }
        
        override public function actions() : void
        {
            var _loc2_:LevelB2D = null;
            var _loc11_:b2Vec2 = null;
            var _loc12_:b2Vec2 = null;
            var _loc13_:Number = NaN;
            var _loc14_:Number = NaN;
            var _loc1_:Session = Settings.currentSession;
            _loc2_ = _loc1_.level;
            var _loc3_:b2World = _loc1_.m_world;
            _loc2_.removeFromActionsVector(this);
            Settings.currentSession.contactListener.removeEventListener(ContactEvent.RESULT,this.checkContact);
            if(this.body)
            {
                _loc2_.removeFromPaintItemVector(this);
                _loc11_ = this.body.GetWorldCenter();
                _loc12_ = this.body.GetLinearVelocity();
                _loc13_ = this.body.GetAngularVelocity();
                _loc3_.DestroyBody(this.body);
                _loc14_ = this.body.GetAngle();
                _loc1_.particleController.createBurst("woodchips",10,30,this.body,30);
            }
            else
            {
                _loc11_ = this.center;
                _loc12_ = new b2Vec2(0,0);
                _loc13_ = 0;
                _loc14_ = this.angle;
                _loc2_.levelBody.DestroyShape(this.shape);
                _loc1_.particleController.createPointBurst("woodchips",this.center.x * m_physScale,this.center.y * m_physScale,10,30,30);
            }
            var _loc4_:b2BodyDef = new b2BodyDef();
            _loc4_.angle = _loc14_;
            _loc4_.position = _loc11_;
            var _loc5_:b2PolygonDef = new b2PolygonDef();
            _loc5_.density = 30;
            _loc5_.friction = 0.7;
            _loc5_.restitution = 0.2;
            _loc5_.filter.categoryBits = 8;
            _loc5_.SetAsOrientedBox(this.shapeWidth * 0.5 / m_physScale,this.shapeHeight * 0.25 / m_physScale,new b2Vec2(0,-this.shapeHeight * 0.25 / m_physScale),0);
            var _loc6_:b2Body = _loc3_.CreateBody(_loc4_);
            _loc6_.CreateShape(_loc5_);
            _loc6_.SetMassFromShapes();
            _loc5_.SetAsOrientedBox(this.shapeWidth * 0.5 / m_physScale,this.shapeHeight * 0.25 / m_physScale,new b2Vec2(0,this.shapeHeight * 0.25 / m_physScale),0);
            var _loc7_:b2Body = _loc3_.CreateBody(_loc4_);
            _loc7_.CreateShape(_loc5_);
            _loc7_.SetMassFromShapes();
            _loc6_.SetLinearVelocity(_loc12_);
            _loc6_.SetAngularVelocity(_loc13_);
            _loc7_.SetLinearVelocity(_loc12_);
            _loc7_.SetAngularVelocity(_loc13_);
            var _loc8_:Sprite = new LogHalf1();
            var _loc9_:Sprite = new LogHalf2();
            _loc8_.scaleX = _loc9_.scaleX = this.mc.scaleX;
            _loc8_.scaleY = _loc9_.scaleY = this.mc.scaleY;
            var _loc10_:int = _loc2_.background.getChildIndex(this.mc);
            this.mc.parent.removeChild(this.mc);
            _loc2_.background.addChildAt(_loc9_,_loc10_);
            _loc2_.background.addChildAt(_loc8_,_loc10_);
            _loc6_.SetUserData(_loc8_);
            _loc7_.SetUserData(_loc9_);
            _loc2_.paintBodyVector.push(_loc6_);
            _loc2_.paintBodyVector.push(_loc7_);
            SoundController.instance.playAreaSoundInstance("LumberBreak",_loc6_);
            this.body = null;
        }
        
        internal function checkContact(param1:ContactEvent) : void
        {
            if(param1.impulse > 2250)
            {
                trace("imp " + param1.impulse);
                Settings.currentSession.contactListener.deleteListener(ContactEvent.RESULT,this.shape);
                Settings.currentSession.contactListener.deleteListener(ContactListener.ADD,this.shape);
                Settings.currentSession.level.actionsVector.push(this);
            }
        }
        
        private function checkAdd(param1:b2ContactPoint) : void
        {
            var _loc4_:Number = NaN;
            if(param1.shape2.m_isSensor)
            {
                return;
            }
            var _loc2_:Number = param1.shape2.m_body.m_mass;
            if(_loc2_ != 0 && _loc2_ < this.body.m_mass)
            {
                return;
            }
            var _loc3_:Number = b2Math.b2Dot(param1.velocity,param1.normal);
            _loc3_ = Math.abs(_loc3_);
            if(_loc3_ > 4)
            {
                _loc4_ = Math.ceil(Math.random() * 2);
                SoundController.instance.playAreaSoundInstance("LumberHit" + _loc4_,this.body);
            }
        }
        
        override public function getJointBody(param1:b2Vec2 = null) : b2Body
        {
            return this.body;
        }
        
        override public function triggerSingleActivation(param1:Trigger, param2:String, param3:Array) : void
        {
            var _loc4_:Number = NaN;
            var _loc5_:Number = NaN;
            var _loc6_:Number = NaN;
            var _loc7_:Number = NaN;
            var _loc8_:Number = NaN;
            if(param2 == "wake from sleep")
            {
                if(this.body)
                {
                    this.body.WakeUp();
                }
            }
            else if(param2 == "apply impulse")
            {
                if(this.body)
                {
                    _loc4_ = Number(param3[0]);
                    _loc5_ = Number(param3[1]);
                    _loc6_ = this.body.GetMass();
                    this.body.ApplyImpulse(new b2Vec2(_loc4_ * _loc6_,_loc5_ * _loc6_),this.body.GetWorldCenter());
                    _loc7_ = Number(param3[2]);
                    _loc8_ = this.body.GetAngularVelocity();
                    this.body.SetAngularVelocity(_loc8_ + _loc7_);
                }
            }
        }
        
        override public function get bodyList() : Array
        {
            if(this.body)
            {
                return [this.body];
            }
            return [];
        }
    }
}

