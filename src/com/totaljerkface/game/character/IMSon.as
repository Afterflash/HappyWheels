package com.totaljerkface.game.character
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.events.ContactEvent;
    import com.totaljerkface.game.sound.SoundController;
    import flash.display.*;
    import flash.events.*;
    
    public class IMSon extends CharacterB2D
    {
        internal var mom:IrresponsibleMom;
        
        internal var ejected:Boolean;
        
        internal var detached:Boolean;
        
        protected var ejectImpulse:Number = 0.75;
        
        internal var detachLimit:Number = 100;
        
        internal var basketSmashLimit:Number = 3;
        
        private var wheelMaxSpeed:Number = 27.7;
        
        private var wheelCurrentSpeed:Number;
        
        private var wheelNewSpeed:Number;
        
        private var accelStep:Number = 1.385;
        
        internal var basketBody:b2Body;
        
        internal var basketShape1:b2Shape;
        
        internal var basketShape2:b2Shape;
        
        internal var basketShape3:b2Shape;
        
        internal var basketShape4:b2Shape;
        
        internal var basketShape5:b2Shape;
        
        internal var basketShape6:b2Shape;
        
        internal var basketMC:MovieClip;
        
        internal var connectingJoint:b2RevoluteJoint;
        
        internal var basketHand1:b2RevoluteJoint;
        
        internal var basketHand2:b2RevoluteJoint;
        
        internal var basketPelvis:b2PrismaticJoint;
        
        internal var extraFilter:b2FilterData;
        
        public function IMSon(param1:Number, param2:Number, param3:DisplayObject, param4:Session, param5:int = -3, param6:String = "kid", param7:IrresponsibleMom = null)
        {
            super(param1,param2,param3,param4,param5,param6);
            shapeRefScale = 50;
            this.mom = param7;
        }
        
        override internal function leftPressedActions() : void
        {
            if(this.ejected)
            {
                currentPose = 1;
            }
        }
        
        override internal function rightPressedActions() : void
        {
            if(this.ejected)
            {
                currentPose = 2;
            }
        }
        
        override internal function leftAndRightActions() : void
        {
            if(this.ejected)
            {
                if(_currentPose == 1 || _currentPose == 2)
                {
                    currentPose = 0;
                }
            }
        }
        
        override internal function upPressedActions() : void
        {
            if(this.ejected)
            {
                currentPose = 3;
            }
        }
        
        override internal function downPressedActions() : void
        {
            if(this.ejected)
            {
                currentPose = 4;
            }
        }
        
        override internal function upAndDownActions() : void
        {
            if(this.ejected)
            {
                if(_currentPose == 3 || _currentPose == 4)
                {
                    currentPose = 0;
                }
            }
        }
        
        override internal function spacePressedActions() : void
        {
            if(this.ejected)
            {
                startGrab();
            }
        }
        
        override internal function spaceNullActions() : void
        {
            if(this.ejected)
            {
                releaseGrip();
            }
        }
        
        override internal function zPressedActions() : void
        {
            this.eject();
        }
        
        override internal function shiftPressedActions() : void
        {
            this.eject();
        }
        
        override internal function createFilters() : void
        {
            super.createFilters();
            this.extraFilter = new b2FilterData();
            this.extraFilter.groupIndex = groupID;
            this.extraFilter.categoryBits = 260;
        }
        
        override public function reset() : void
        {
            super.reset();
            this.ejected = false;
            this.detached = false;
        }
        
        override public function die() : void
        {
            super.die();
        }
        
        override internal function createDictionaries() : void
        {
            super.createDictionaries();
            contactImpulseDict[this.basketShape1] = this.basketSmashLimit;
            contactAddSounds[this.basketShape1] = "BasketHit";
            contactAddSounds[this.basketShape2] = "BasketHit";
            contactAddSounds[this.basketShape3] = "BasketHit";
        }
        
        override internal function createBodies() : void
        {
            var _loc4_:MovieClip = null;
            super.createBodies();
            var _loc1_:b2BodyDef = new b2BodyDef();
            var _loc2_:b2PolygonDef = new b2PolygonDef();
            _loc2_.density = 1;
            _loc2_.friction = 0.3;
            _loc2_.restitution = 0.1;
            _loc2_.filter = this.mom.defaultFilter;
            this.basketBody = _session.m_world.CreateBody(_loc1_);
            _loc2_.vertexCount = 4;
            var _loc3_:int = 0;
            while(_loc3_ < 4)
            {
                _loc4_ = shapeGuide["crateRight" + [_loc3_ + 1]];
                _loc2_.vertices[_loc3_] = new b2Vec2(_startX + _loc4_.x / character_scale,_startY + _loc4_.y / character_scale);
                _loc3_++;
            }
            this.basketShape1 = this.basketBody.CreateShape(_loc2_);
            _session.contactListener.registerListener(ContactListener.RESULT,this.basketShape1,this.contactBasketResultHandler);
            _session.contactListener.registerListener(ContactListener.ADD,this.basketShape1,contactAddHandler);
            _loc3_ = 0;
            while(_loc3_ < 4)
            {
                _loc4_ = shapeGuide["crateBottom" + [_loc3_ + 1]];
                _loc2_.vertices[_loc3_] = new b2Vec2(_startX + _loc4_.x / character_scale,_startY + _loc4_.y / character_scale);
                _loc3_++;
            }
            this.basketShape2 = this.basketBody.CreateShape(_loc2_);
            _session.contactListener.registerListener(ContactListener.RESULT,this.basketShape2,this.contactBasketResultHandler);
            _session.contactListener.registerListener(ContactListener.ADD,this.basketShape2,contactAddHandler);
            _loc3_ = 0;
            while(_loc3_ < 4)
            {
                _loc4_ = shapeGuide["crateLeft" + [_loc3_ + 1]];
                _loc2_.vertices[_loc3_] = new b2Vec2(_startX + _loc4_.x / character_scale,_startY + _loc4_.y / character_scale);
                _loc3_++;
            }
            this.basketShape3 = this.basketBody.CreateShape(_loc2_);
            _session.contactListener.registerListener(ContactListener.RESULT,this.basketShape3,this.contactBasketResultHandler);
            _session.contactListener.registerListener(ContactListener.ADD,this.basketShape3,contactAddHandler);
            this.basketBody.SetMassFromShapes();
            paintVector.push(this.basketBody);
        }
        
        override internal function createMovieClips() : void
        {
            super.createMovieClips();
            var _loc1_:MovieClip = sourceObject["basketPieces"];
            _session.particleController.createBMDArray("basketPieces",_loc1_);
            this.basketMC = sourceObject["basket"];
            var _loc5_:* = 1 / mc_scale;
            this.basketMC.scaleY = 1 / mc_scale;
            this.basketMC.scaleX = _loc5_;
            var _loc2_:b2Vec2 = this.basketBody.GetLocalCenter();
            _loc2_ = new b2Vec2((_startX - _loc2_.x) * character_scale,(_startY - _loc2_.y) * character_scale);
            var _loc3_:MovieClip = shapeGuide["crateLeft1"];
            var _loc4_:b2Vec2 = new b2Vec2(_loc3_.x + _loc2_.x,_loc3_.y + _loc2_.y);
            this.basketMC.inner.x = _loc4_.x;
            this.basketMC.inner.y = _loc4_.y;
            this.basketBody.SetUserData(this.basketMC);
            _session.containerSprite.addChild(this.basketMC);
        }
        
        override internal function resetMovieClips() : void
        {
            super.resetMovieClips();
            var _loc1_:MovieClip = sourceObject["basketPieces"];
            _session.particleController.createBMDArray("basketPieces",_loc1_);
            this.basketMC.visible = true;
            this.basketMC.inner.frame.visible = false;
            this.basketBody.SetUserData(this.basketMC);
        }
        
        override internal function createJoints() : void
        {
            var _loc1_:Number = NaN;
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            super.createJoints();
            var _loc4_:Number = oneEightyOverPI;
            _loc1_ = lowerLeg1Body.GetAngle() - upperLeg1Body.GetAngle();
            _loc2_ = 50 / _loc4_ - _loc1_;
            _loc3_ = 150 / _loc4_ - _loc1_;
            kneeJoint1.SetLimits(_loc2_,_loc3_);
            _loc1_ = lowerLeg2Body.GetAngle() - upperLeg2Body.GetAngle();
            _loc2_ = 50 / _loc4_ - _loc1_;
            _loc3_ = 150 / _loc4_ - _loc1_;
            kneeJoint2.SetLimits(_loc2_,_loc3_);
            _loc1_ = upperLeg1Body.GetAngle() - pelvisBody.GetAngle();
            _loc2_ = -110 / _loc4_ - _loc1_;
            _loc3_ = -40 / _loc4_ - _loc1_;
            _loc1_ = upperLeg2Body.GetAngle() - pelvisBody.GetAngle();
            _loc2_ = -110 / _loc4_ - _loc1_;
            _loc3_ = -40 / _loc4_ - _loc1_;
            _loc1_ = lowerArm1Body.GetAngle() - upperArm1Body.GetAngle();
            _loc2_ = -160 / _loc4_ - _loc1_;
            _loc3_ = -20 / _loc4_ - _loc1_;
            elbowJoint1.SetLimits(_loc2_,_loc3_);
            _loc1_ = lowerArm2Body.GetAngle() - upperArm2Body.GetAngle();
            _loc2_ = -160 / _loc4_ - _loc1_;
            _loc3_ = -20 / _loc4_ - _loc1_;
            elbowJoint2.SetLimits(_loc2_,_loc3_);
            _loc1_ = head1Body.GetAngle() - chestBody.GetAngle();
            _loc2_ = -10 / _loc4_ - _loc1_;
            _loc3_ = 10 / _loc4_ - _loc1_;
            neckJoint.SetLimits(_loc2_,_loc3_);
            var _loc5_:b2RevoluteJointDef = new b2RevoluteJointDef();
            var _loc6_:b2Vec2 = new b2Vec2();
            var _loc7_:MovieClip = shapeGuide["crateAnchor"];
            _loc6_.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc5_.enableLimit = true;
            _loc5_.lowerAngle = 0;
            _loc5_.upperAngle = 0;
            _loc5_.Initialize(this.mom.frameBody,this.basketBody,_loc6_);
            this.connectingJoint = _session.m_world.CreateJoint(_loc5_) as b2RevoluteJoint;
            _loc5_.enableLimit = false;
            _loc6_.SetV(lowerArm1Body.GetWorldPoint(new b2Vec2(0,(lowerArm1Shape as b2PolygonShape).GetVertices()[2].y)));
            _loc5_.Initialize(this.basketBody,lowerArm1Body,_loc6_);
            this.basketHand1 = _session.m_world.CreateJoint(_loc5_) as b2RevoluteJoint;
            _loc6_.SetV(lowerArm2Body.GetWorldPoint(new b2Vec2(0,(lowerArm2Shape as b2PolygonShape).GetVertices()[2].y)));
            _loc5_.Initialize(this.basketBody,lowerArm2Body,_loc6_);
            this.basketHand2 = _session.m_world.CreateJoint(_loc5_) as b2RevoluteJoint;
            var _loc8_:b2PrismaticJointDef = new b2PrismaticJointDef();
            _loc6_.SetV(pelvisBody.GetWorldCenter());
            _loc8_.enableLimit = true;
            _loc8_.upperTranslation = 0.25;
            _loc8_.lowerTranslation = 0;
            var _loc9_:Number = 25 / _loc4_;
            _loc8_.Initialize(this.basketBody,pelvisBody,_loc6_,new b2Vec2(Math.sin(_loc9_),-Math.cos(_loc9_)));
            this.basketPelvis = _session.m_world.CreateJoint(_loc8_) as b2PrismaticJoint;
        }
        
        protected function contactBasketResultHandler(param1:ContactEvent) : void
        {
            var _loc2_:Number = param1.impulse;
            if(_loc2_ > contactImpulseDict[this.basketShape1])
            {
                if(contactResultBuffer[this.basketShape1])
                {
                    if(_loc2_ > contactResultBuffer[this.basketShape1].impulse)
                    {
                        contactResultBuffer[this.basketShape1] = param1;
                    }
                }
                else
                {
                    contactResultBuffer[this.basketShape1] = param1;
                }
            }
        }
        
        override protected function handleContactResults() : void
        {
            var _loc1_:ContactEvent = null;
            super.handleContactResults();
            if(contactResultBuffer[this.basketShape1])
            {
                _loc1_ = contactResultBuffer[this.basketShape1];
                this.basketSmash(_loc1_.impulse,_loc1_.normal);
                delete contactResultBuffer[this.basketShape1];
                delete contactAddBuffer[this.basketShape1];
                delete contactAddBuffer[this.basketShape2];
                delete contactAddBuffer[this.basketShape3];
                if(this.basketShape4)
                {
                    delete contactAddBuffer[this.basketShape4];
                    delete contactAddBuffer[this.basketShape5];
                    delete contactAddBuffer[this.basketShape6];
                }
            }
        }
        
        override public function checkJoints() : void
        {
            super.checkJoints();
            if(!this.detached)
            {
                checkRevJoint(this.connectingJoint,this.detachLimit,this.detachBasket);
            }
        }
        
        internal function detachBasket(param1:Number) : void
        {
            var _loc8_:MovieClip = null;
            trace("detach basket " + param1);
            if(this.detached)
            {
                return;
            }
            this.connectingJoint.broken = true;
            this.detached = true;
            _session.m_world.DestroyJoint(this.connectingJoint);
            this.basketBody.DestroyShape(this.basketShape1);
            this.basketBody.DestroyShape(this.basketShape2);
            this.basketBody.DestroyShape(this.basketShape3);
            var _loc2_:ContactListener = _session.contactListener;
            _loc2_.deleteListener(ContactListener.RESULT,this.basketShape1);
            _loc2_.deleteListener(ContactListener.RESULT,this.basketShape2);
            _loc2_.deleteListener(ContactListener.RESULT,this.basketShape3);
            _loc2_.deleteListener(ContactListener.ADD,this.basketShape1);
            _loc2_.deleteListener(ContactListener.ADD,this.basketShape2);
            _loc2_.deleteListener(ContactListener.ADD,this.basketShape3);
            if(!this.ejected)
            {
                this.refilterShit(head1Body.GetShapeList());
                this.refilterShit(pelvisBody.GetShapeList());
                this.refilterShit(chestBody.GetShapeList());
                this.refilterShit(upperArm1Body.GetShapeList());
                this.refilterShit(upperArm2Body.GetShapeList());
                this.refilterShit(lowerArm1Body.GetShapeList());
                this.refilterShit(lowerArm2Body.GetShapeList());
                this.refilterShit(upperLeg1Body.GetShapeList());
                this.refilterShit(upperLeg2Body.GetShapeList());
                this.refilterShit(lowerLeg1Body.GetShapeList());
                this.refilterShit(lowerLeg2Body.GetShapeList());
            }
            var _loc3_:b2PolygonDef = new b2PolygonDef();
            _loc3_.density = 1;
            _loc3_.friction = 0.3;
            _loc3_.restitution = 0.1;
            _loc3_.filter = zeroFilter;
            _loc3_.vertexCount = 4;
            var _loc4_:int = 0;
            while(_loc4_ < 4)
            {
                _loc8_ = shapeGuide["crate2Right" + [_loc4_ + 1]];
                _loc3_.vertices[_loc4_] = new b2Vec2(_startX + _loc8_.x / character_scale,_startY + _loc8_.y / character_scale);
                _loc4_++;
            }
            this.basketShape4 = this.basketBody.CreateShape(_loc3_);
            _loc2_.registerListener(ContactListener.RESULT,this.basketShape4,this.contactBasketResultHandler);
            _loc2_.registerListener(ContactListener.ADD,this.basketShape4,contactAddHandler);
            _loc4_ = 0;
            while(_loc4_ < 4)
            {
                _loc8_ = shapeGuide["crate2Bottom" + [_loc4_ + 1]];
                _loc3_.vertices[_loc4_] = new b2Vec2(_startX + _loc8_.x / character_scale,_startY + _loc8_.y / character_scale);
                _loc4_++;
            }
            this.basketShape5 = this.basketBody.CreateShape(_loc3_);
            _loc2_.registerListener(ContactListener.RESULT,this.basketShape5,this.contactBasketResultHandler);
            _loc2_.registerListener(ContactListener.ADD,this.basketShape5,contactAddHandler);
            _loc4_ = 0;
            while(_loc4_ < 4)
            {
                _loc8_ = shapeGuide["crate2Left" + [_loc4_ + 1]];
                _loc3_.vertices[_loc4_] = new b2Vec2(_startX + _loc8_.x / character_scale,_startY + _loc8_.y / character_scale);
                _loc4_++;
            }
            this.basketShape6 = this.basketBody.CreateShape(_loc3_);
            _loc2_.registerListener(ContactListener.RESULT,this.basketShape6,this.contactBasketResultHandler);
            _loc2_.registerListener(ContactListener.ADD,this.basketShape6,contactAddHandler);
            contactAddSounds[this.basketShape4] = "BasketHit";
            contactAddSounds[this.basketShape5] = "BasketHit";
            contactAddSounds[this.basketShape6] = "BasketHit";
            this.basketBody.SetMassFromShapes();
            var _loc5_:b2Vec2 = this.basketBody.GetLocalCenter();
            _loc5_ = new b2Vec2((_startX - _loc5_.x) * character_scale,(_startY - _loc5_.y) * character_scale);
            var _loc6_:MovieClip = shapeGuide["crateLeft1"];
            var _loc7_:b2Vec2 = new b2Vec2(_loc6_.x + _loc5_.x,_loc6_.y + _loc5_.y);
            this.basketMC.inner.x = _loc7_.x;
            this.basketMC.inner.y = _loc7_.y;
            this.basketMC.inner.frame.visible = false;
        }
        
        override internal function eject() : void
        {
            if(this.ejected)
            {
                return;
            }
            this.ejected = true;
            resetJointLimits();
            var _loc1_:b2World = session.m_world;
            if(this.basketPelvis)
            {
                _loc1_.DestroyJoint(this.basketPelvis);
                this.basketPelvis = null;
            }
            if(this.basketHand1)
            {
                _loc1_.DestroyJoint(this.basketHand1);
                this.basketHand1 = null;
            }
            if(this.basketHand2)
            {
                _loc1_.DestroyJoint(this.basketHand2);
                this.basketHand2 = null;
            }
            if(!this.detached)
            {
                this.refilterShit(head1Body.GetShapeList());
                this.refilterShit(pelvisBody.GetShapeList());
                this.refilterShit(chestBody.GetShapeList());
                this.refilterShit(upperArm1Body.GetShapeList());
                this.refilterShit(upperArm2Body.GetShapeList());
                this.refilterShit(lowerArm1Body.GetShapeList());
                this.refilterShit(lowerArm2Body.GetShapeList());
                this.refilterShit(upperLeg1Body.GetShapeList());
                this.refilterShit(upperLeg2Body.GetShapeList());
                this.refilterShit(lowerLeg1Body.GetShapeList());
                this.refilterShit(lowerLeg2Body.GetShapeList());
            }
            var _loc2_:Number = this.basketBody.GetAngle() - Math.PI / 2;
            var _loc3_:Number = Math.cos(_loc2_) * this.ejectImpulse;
            var _loc4_:Number = Math.sin(_loc2_) * this.ejectImpulse;
            chestBody.ApplyImpulse(new b2Vec2(_loc3_,_loc4_),chestBody.GetWorldCenter());
            pelvisBody.ApplyImpulse(new b2Vec2(_loc3_,_loc4_),pelvisBody.GetWorldCenter());
        }
        
        internal function refilterShit(param1:b2Shape) : void
        {
            if(param1.m_filter.maskBits == defaultFilter.maskBits)
            {
                param1.m_filter = this.extraFilter;
                _session.m_world.Refilter(param1);
            }
        }
        
        override public function set dead(param1:Boolean) : void
        {
            if(_dead == param1)
            {
                return;
            }
            _dead = param1;
            if(_dead)
            {
                userVehicleEject();
                currentPose = 0;
                releaseGrip();
                if(voiceSound)
                {
                    voiceSound.stopSound();
                    voiceSound = null;
                }
            }
        }
        
        internal function basketSmash(param1:Number, param2:b2Vec2) : void
        {
            trace("basket impulse " + param1);
            delete contactImpulseDict[this.basketShape1];
            var _loc3_:ContactListener = _session.contactListener;
            _loc3_.deleteListener(ContactListener.RESULT,this.basketShape1);
            _loc3_.deleteListener(ContactListener.RESULT,this.basketShape2);
            _loc3_.deleteListener(ContactListener.RESULT,this.basketShape3);
            _loc3_.deleteListener(ContactListener.ADD,this.basketShape1);
            _loc3_.deleteListener(ContactListener.ADD,this.basketShape2);
            _loc3_.deleteListener(ContactListener.ADD,this.basketShape3);
            if(this.basketShape4)
            {
                _loc3_.deleteListener(ContactListener.RESULT,this.basketShape4);
                _loc3_.deleteListener(ContactListener.RESULT,this.basketShape5);
                _loc3_.deleteListener(ContactListener.RESULT,this.basketShape6);
                _loc3_.deleteListener(ContactListener.ADD,this.basketShape4);
                _loc3_.deleteListener(ContactListener.ADD,this.basketShape5);
                _loc3_.deleteListener(ContactListener.ADD,this.basketShape6);
            }
            this.eject();
            this.detached = true;
            this.basketMC.visible = false;
            _session.m_world.DestroyJoint(this.connectingJoint);
            _session.m_world.DestroyBody(this.basketBody);
            var _loc4_:b2Vec2 = this.basketBody.GetWorldCenter();
            _session.particleController.createPointBurst("basketPieces",_loc4_.x * m_physScale,_loc4_.y * m_physScale,5,20,30);
            SoundController.instance.playAreaSoundInstance("BasketSmash",this.basketBody);
        }
        
        override internal function headSmash1(param1:Number) : void
        {
            super.headSmash1(param1);
            this.eject();
        }
        
        override internal function chestSmash(param1:Number) : void
        {
            super.chestSmash(param1);
            this.eject();
        }
        
        override internal function pelvisSmash(param1:Number) : void
        {
            super.pelvisSmash(param1);
            this.eject();
        }
        
        override internal function torsoBreak(param1:Number, param2:Boolean = true, param3:Boolean = true) : void
        {
            super.torsoBreak(param1,param2,param3);
            this.eject();
        }
        
        override internal function elbowBreak1(param1:Number) : void
        {
            super.elbowBreak1(param1);
            if(this.ejected)
            {
                return;
            }
            if(this.basketHand1)
            {
                _session.m_world.DestroyJoint(this.basketHand1);
                this.basketHand1 = null;
            }
            if(!this.basketHand2)
            {
                this.eject();
            }
        }
        
        override internal function elbowBreak2(param1:Number) : void
        {
            super.elbowBreak2(param1);
            if(this.ejected)
            {
                return;
            }
            if(this.basketHand2)
            {
                _session.m_world.DestroyJoint(this.basketHand2);
                this.basketHand2 = null;
            }
            if(!this.basketHand1)
            {
                this.eject();
            }
        }
        
        override internal function shoulderBreak1(param1:Number, param2:Boolean = true) : void
        {
            super.shoulderBreak1(param1,param2);
            if(this.ejected)
            {
                return;
            }
            if(this.basketHand1)
            {
                _session.m_world.DestroyJoint(this.basketHand1);
                this.basketHand1 = null;
            }
            if(!this.basketHand2)
            {
                this.eject();
            }
        }
        
        override internal function shoulderBreak2(param1:Number, param2:Boolean = true) : void
        {
            super.shoulderBreak2(param1,param2);
            if(this.ejected)
            {
                return;
            }
            if(this.basketHand2)
            {
                _session.m_world.DestroyJoint(this.basketHand2);
                this.basketHand2 = null;
            }
            if(!this.basketHand1)
            {
                this.eject();
            }
        }
    }
}

