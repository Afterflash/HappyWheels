package com.totaljerkface.game.level.userspecials
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.*;
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.editor.specials.*;
    import com.totaljerkface.game.events.*;
    import com.totaljerkface.game.level.*;
    import com.totaljerkface.game.sound.SoundController;
    import flash.display.*;
    import flash.geom.Point;
    
    public class Table extends LevelItem
    {
        private var mc:MovieClip;
        
        private var body:b2Body;
        
        private var top:b2Shape;
        
        private var leftLeg:b2Shape;
        
        private var rightLeg:b2Shape;
        
        private var break2:Boolean;
        
        private var breakLimit:int = 50;
        
        public function Table(param1:Special, param2:b2Body = null, param3:Point = null)
        {
            super();
            var _loc4_:TableRef = param1 as TableRef;
            this.mc = new TableMC();
            this.mc.gotoAndStop(1);
            this.mc.x = _loc4_.x;
            this.mc.y = _loc4_.y;
            this.mc.rotation = _loc4_.rotation;
            var _loc5_:Sprite = Settings.currentSession.level.background;
            _loc5_.addChild(this.mc);
            if(Settings.currentSession.version < 1.67)
            {
                this.createBody(new b2Vec2(_loc4_.x,_loc4_.y),_loc4_.rotation * Math.PI / 180,false);
            }
            else if(_loc4_.interactive)
            {
                this.breakLimit = 15;
                this.createBody(new b2Vec2(_loc4_.x,_loc4_.y),_loc4_.rotation * Math.PI / 180,_loc4_.sleeping);
            }
        }
        
        internal function createBody(param1:b2Vec2, param2:Number, param3:Boolean) : void
        {
            var _loc4_:b2BodyDef = new b2BodyDef();
            _loc4_.position.Set(param1.x / m_physScale,param1.y / m_physScale);
            _loc4_.angle = param2;
            _loc4_.isSleeping = param3;
            this.body = Settings.currentSession.m_world.CreateBody(_loc4_);
            var _loc5_:b2PolygonDef = new b2PolygonDef();
            _loc5_.density = 5;
            _loc5_.friction = 0.1;
            _loc5_.restitution = 0.2;
            _loc5_.filter.categoryBits = 8;
            _loc5_.SetAsOrientedBox(78 / m_physScale,3 / m_physScale,new b2Vec2(0,-3 / m_physScale),0);
            this.top = this.body.CreateShape(_loc5_);
            _loc5_.SetAsOrientedBox(3 / m_physScale,25 / m_physScale,new b2Vec2(-48 / m_physScale,25 / m_physScale),0);
            this.leftLeg = this.body.CreateShape(_loc5_);
            _loc5_.SetAsOrientedBox(3 / m_physScale,25 / m_physScale,new b2Vec2(48 / m_physScale,25 / m_physScale),0);
            this.rightLeg = this.body.CreateShape(_loc5_);
            this.body.SetMassFromShapes();
            Settings.currentSession.level.paintItemVector.push(this);
            var _loc6_:b2Vec2 = this.body.GetLocalCenter();
            this.mc.inner.y = -11;
            Settings.currentSession.contactListener.registerListener(ContactListener.RESULT,this.top,this.checkContact);
            Settings.currentSession.contactListener.registerListener(ContactListener.RESULT,this.leftLeg,this.checkContact);
            Settings.currentSession.contactListener.registerListener(ContactListener.RESULT,this.rightLeg,this.checkContact);
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
            var _loc1_:LevelB2D = null;
            var _loc2_:b2World = null;
            var _loc3_:b2Vec2 = null;
            var _loc4_:b2Vec2 = null;
            var _loc5_:Number = NaN;
            var _loc6_:Number = NaN;
            var _loc7_:b2BodyDef = null;
            var _loc8_:b2PolygonDef = null;
            var _loc9_:b2Body = null;
            var _loc10_:b2Body = null;
            var _loc11_:Sprite = null;
            var _loc12_:Sprite = null;
            var _loc13_:int = 0;
            var _loc14_:b2Body = null;
            var _loc15_:b2Body = null;
            var _loc16_:Sprite = null;
            var _loc17_:Sprite = null;
            if(!this.break2)
            {
                _loc1_ = Settings.currentSession.level;
                _loc2_ = Settings.currentSession.m_world;
                _loc1_.removeFromActionsVector(this);
                Settings.currentSession.contactListener.registerListener(ContactListener.RESULT,this.top,this.checkContact);
                _loc3_ = this.body.GetWorldCenter();
                _loc4_ = this.body.GetLinearVelocity();
                _loc5_ = this.body.GetAngularVelocity();
                _loc6_ = this.body.GetAngle();
                this.body.DestroyShape(this.leftLeg);
                this.body.DestroyShape(this.rightLeg);
                this.body.SetMassFromShapes();
                this.mc.inner.leg1.visible = false;
                this.mc.inner.leg2.visible = false;
                this.mc.inner.y = 0;
                _loc7_ = new b2BodyDef();
                _loc7_.angle = _loc6_;
                _loc7_.position = _loc3_;
                _loc8_ = new b2PolygonDef();
                _loc8_.density = 5;
                _loc8_.friction = 0.1;
                _loc8_.restitution = 0.2;
                _loc8_.filter.categoryBits = 8;
                _loc8_.SetAsOrientedBox(3 / m_physScale,25 / m_physScale,new b2Vec2(-48 / m_physScale,25 / m_physScale),0);
                _loc9_ = _loc2_.CreateBody(_loc7_);
                _loc9_.CreateShape(_loc8_);
                _loc9_.SetMassFromShapes();
                _loc8_.SetAsOrientedBox(3 / m_physScale,25 / m_physScale,new b2Vec2(48 / m_physScale,25 / m_physScale),0);
                _loc10_ = _loc2_.CreateBody(_loc7_);
                _loc10_.CreateShape(_loc8_);
                _loc10_.SetMassFromShapes();
                _loc9_.SetLinearVelocity(_loc4_);
                _loc9_.SetAngularVelocity(_loc5_);
                _loc10_.SetLinearVelocity(_loc4_);
                _loc10_.SetAngularVelocity(_loc5_);
                _loc11_ = new TableLegMC();
                _loc12_ = new TableLegMC();
                _loc13_ = _loc1_.background.getChildIndex(this.mc);
                _loc1_.background.addChildAt(_loc11_,_loc13_);
                _loc1_.background.addChildAt(_loc12_,_loc13_);
                _loc9_.SetUserData(_loc11_);
                _loc10_.SetUserData(_loc12_);
                _loc1_.paintBodyVector.push(_loc9_);
                _loc1_.paintBodyVector.push(_loc10_);
                this.break2 = true;
                this.breakLimit = Settings.currentSession.version < 1.67 ? 25 : 7;
                SoundController.instance.playAreaSoundInstance("TableBreak2",this.body);
            }
            else
            {
                _loc1_ = Settings.currentSession.level;
                _loc2_ = Settings.currentSession.m_world;
                _loc1_.removeFromPaintItemVector(this);
                _loc1_.removeFromActionsVector(this);
                _loc3_ = this.body.GetWorldCenter();
                _loc4_ = this.body.GetLinearVelocity();
                _loc5_ = this.body.GetAngularVelocity();
                _loc6_ = this.body.GetAngle();
                _loc2_.DestroyBody(this.body);
                _loc7_ = new b2BodyDef();
                _loc7_.angle = _loc6_;
                _loc7_.position = _loc3_;
                _loc8_ = new b2PolygonDef();
                _loc8_.density = 5;
                _loc8_.friction = 0.1;
                _loc8_.restitution = 0.2;
                _loc8_.filter.categoryBits = 8;
                _loc8_.SetAsOrientedBox(39 / m_physScale,3 / m_physScale,new b2Vec2(-39 / m_physScale,-3 / m_physScale),0);
                _loc14_ = _loc2_.CreateBody(_loc7_);
                _loc14_.CreateShape(_loc8_);
                _loc14_.SetMassFromShapes();
                _loc8_.SetAsOrientedBox(39 / m_physScale,3 / m_physScale,new b2Vec2(39 / m_physScale,-3 / m_physScale),0);
                _loc15_ = _loc2_.CreateBody(_loc7_);
                _loc15_.CreateShape(_loc8_);
                _loc15_.SetMassFromShapes();
                _loc14_.SetLinearVelocity(_loc4_);
                _loc14_.SetAngularVelocity(_loc5_);
                _loc15_.SetLinearVelocity(_loc4_);
                _loc15_.SetAngularVelocity(_loc5_);
                _loc16_ = new TableTop1MC();
                _loc17_ = new TableTop2MC();
                _loc13_ = _loc1_.background.getChildIndex(this.mc);
                this.mc.parent.removeChild(this.mc);
                _loc1_.background.addChildAt(_loc17_,_loc13_);
                _loc1_.background.addChildAt(_loc16_,_loc13_);
                _loc14_.SetUserData(_loc16_);
                _loc15_.SetUserData(_loc17_);
                _loc1_.paintBodyVector.push(_loc14_);
                _loc1_.paintBodyVector.push(_loc15_);
                SoundController.instance.playAreaSoundInstance("TableBreak1",_loc14_);
                this.body = null;
            }
        }
        
        internal function checkContact(param1:ContactEvent) : void
        {
            if(param1.impulse > this.breakLimit)
            {
                Settings.currentSession.contactListener.deleteListener(ContactEvent.RESULT,this.top);
                Settings.currentSession.contactListener.deleteListener(ContactEvent.RESULT,this.leftLeg);
                Settings.currentSession.contactListener.deleteListener(ContactEvent.RESULT,this.rightLeg);
                Settings.currentSession.level.actionsVector.push(this);
            }
        }
        
        override public function getJointBody(param1:b2Vec2 = null) : b2Body
        {
            return this.body;
        }
        
        override public function get groupDisplayObject() : DisplayObject
        {
            return this.mc;
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

