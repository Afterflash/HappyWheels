package com.totaljerkface.game.level.userspecials
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.b2PrismaticJoint;
    import Box2D.Dynamics.Joints.b2PrismaticJointDef;
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.editor.specials.*;
    import com.totaljerkface.game.events.*;
    import com.totaljerkface.game.level.*;
    import com.totaljerkface.game.sound.SoundController;
    import flash.display.*;
    import flash.text.TextField;
    
    public class SpringBox extends LevelItem
    {
        private static var idCounter:int = 0;
        
        private var id:String;
        
        private var mc:SpringBoxMC;
        
        private var timerText:TextField;
        
        private var body:b2Body;
        
        private var glow:Sprite;
        
        private var padShape:b2Shape;
        
        private var joint:b2PrismaticJoint;
        
        private var hit:Boolean;
        
        private var delayCounter:int = 0;
        
        private var delayTotal:int = 0;
        
        private var delayTimeString:String;
        
        public function SpringBox(param1:Special)
        {
            var _loc2_:SpringBoxRef = null;
            var _loc3_:LevelB2D = null;
            super();
            _loc2_ = param1 as SpringBoxRef;
            this.createBody(new b2Vec2(_loc2_.x,_loc2_.y),_loc2_.rotation * Math.PI / 180);
            this.createJoint(_loc2_.rotation * Math.PI / 180);
            _loc3_ = Settings.currentSession.level;
            this.mc = new SpringBoxMC();
            var _loc4_:Sprite = _loc3_.background;
            _loc4_.addChild(this.mc);
            this.mc.pad.y = -1 * this.body.GetLocalCenter().y * m_physScale;
            this.timerText = this.mc.base.timerText;
            this.timerText.maxChars = 3;
            this.glow = this.mc.base.glow;
            this.glow.visible = false;
            var _loc5_:Sprite = this.mc.base;
            var _loc6_:Sprite = _loc3_.foreground;
            _loc6_.addChild(_loc5_);
            _loc5_.x = _loc2_.x;
            _loc5_.y = _loc2_.y;
            _loc5_.rotation = _loc2_.rotation;
            this.delayTotal = Math.round(_loc2_.springDelay * 30);
            this.delayCounter = this.delayTotal;
            var _loc7_:Number = this.delayCounter / 30;
            this.delayTimeString = _loc7_.toFixed(2);
            this.timerText.text = this.delayTimeString;
            _loc3_.paintItemVector.push(this);
            _loc3_.actionsVector.push(this);
            Settings.currentSession.contactListener.registerListener(ContactEvent.RESULT,this.padShape,this.checkContact);
        }
        
        internal function createBody(param1:b2Vec2, param2:Number) : void
        {
            var _loc3_:b2BodyDef = new b2BodyDef();
            _loc3_.position.Set(param1.x / m_physScale,param1.y / m_physScale);
            _loc3_.angle = param2;
            this.body = Settings.currentSession.m_world.CreateBody(_loc3_);
            var _loc4_:b2PolygonDef = new b2PolygonDef();
            _loc4_.density = 200;
            _loc4_.friction = 0.5;
            _loc4_.restitution = 0.1;
            _loc4_.filter.categoryBits = 8;
            _loc4_.SetAsOrientedBox(175 / m_physScale,11 / m_physScale,new b2Vec2(0,-9 / m_physScale),0);
            this.padShape = this.body.CreateShape(_loc4_);
            _loc4_.SetAsOrientedBox(13 / m_physScale,9 / m_physScale,new b2Vec2(-120 / m_physScale,11 / m_physScale),0);
            this.body.CreateShape(_loc4_);
            _loc4_.SetAsOrientedBox(13 / m_physScale,9 / m_physScale,new b2Vec2(120 / m_physScale,11 / m_physScale),0);
            this.body.CreateShape(_loc4_);
            this.body.SetMassFromShapes();
            _loc4_.SetAsOrientedBox(175 / m_physScale,16 / m_physScale,this.body.GetWorldPoint(new b2Vec2(0,4 / m_physScale)),param2);
            Settings.currentSession.level.levelBody.CreateShape(_loc4_);
        }
        
        internal function createJoint(param1:Number) : void
        {
            var _loc2_:b2PrismaticJointDef = new b2PrismaticJointDef();
            _loc2_.Initialize(Settings.currentSession.level.levelBody,this.body,this.body.GetWorldCenter(),new b2Vec2(Math.sin(param1),-Math.cos(param1)));
            _loc2_.enableLimit = true;
            _loc2_.upperTranslation = 0;
            _loc2_.lowerTranslation = 0;
            _loc2_.enableMotor = false;
            _loc2_.maxMotorForce = 1000000;
            this.joint = Settings.currentSession.m_world.CreateJoint(_loc2_) as b2PrismaticJoint;
        }
        
        override public function paint() : void
        {
            var _loc1_:b2Vec2 = null;
            _loc1_ = this.body.GetWorldCenter();
            this.mc.x = _loc1_.x * m_physScale;
            this.mc.y = _loc1_.y * m_physScale;
            this.mc.rotation = this.body.GetAngle() * (180 / Math.PI);
        }
        
        override public function actions() : void
        {
            var _loc1_:Number = NaN;
            if(this.hit)
            {
                if(this.delayCounter == 0)
                {
                    this.glow.visible = true;
                    this.hit = false;
                    this.body.WakeUp();
                    this.joint.SetMotorSpeed(10);
                    this.joint.SetLimits(0,32 / m_physScale);
                    this.joint.EnableMotor(true);
                    this.delayCounter = this.delayTotal;
                    this.timerText.text = "0.00";
                    SoundController.instance.playAreaSoundInstance("SpringBoxBounce",this.body);
                }
                else
                {
                    _loc1_ = this.delayCounter / 30;
                    this.timerText.text = _loc1_.toFixed(2);
                    --this.delayCounter;
                }
            }
            else if(this.joint.IsMotorEnabled())
            {
                if(this.joint.GetMotorSpeed() > 0)
                {
                    if(this.joint.GetJointTranslation() * m_physScale > 32)
                    {
                        this.joint.SetMotorSpeed(-1);
                    }
                }
                else if(this.joint.GetMotorSpeed() < 0)
                {
                    if(this.joint.GetJointTranslation() * m_physScale < 0)
                    {
                        this.joint.EnableMotor(false);
                        this.joint.SetLimits(0,0);
                        this.joint.SetMotorSpeed(0);
                        Settings.currentSession.contactListener.registerListener(ContactEvent.RESULT,this.padShape,this.checkContact);
                        this.timerText.text = this.delayTimeString;
                        this.glow.visible = false;
                    }
                }
            }
        }
        
        protected function checkContact(param1:ContactEvent) : void
        {
            Settings.currentSession.contactListener.deleteListener(ContactEvent.RESULT,this.padShape);
            this.hit = true;
        }
    }
}

