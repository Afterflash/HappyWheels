package com.totaljerkface.game.character
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Collision.b2ContactPoint;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Contacts.b2Contact;
    import Box2D.Dynamics.Joints.*;
    import com.totaljerkface.game.*;
    import flash.display.*;
    import flash.events.*;
    
    public class MopedGirl extends CharacterB2D
    {
        internal var guy:MopedCouple;
        
        private var maxTorque:Number = 30;
        
        internal var ejected:Boolean;
        
        internal var torsoHand1:b2RevoluteJoint;
        
        internal var torsoHand2:b2RevoluteJoint;
        
        internal var framePelvis:b2RevoluteJoint;
        
        internal var frameFoot1:b2RevoluteJoint;
        
        internal var frameFoot2:b2RevoluteJoint;
        
        protected var torsoAnchorPoint:b2Vec2;
        
        protected var torsoHand1JointDef:b2RevoluteJointDef;
        
        protected var torsoHand2JointDef:b2RevoluteJointDef;
        
        protected var reAttachDistance:Number = 0.25;
        
        private var upperLeg1Shape:b2Shape;
        
        private var upperLeg2Shape:b2Shape;
        
        private var leg1Contacts:int;
        
        private var leg2Contacts:int;
        
        private var skirtSprite:Sprite;
        
        internal var extraFilter:b2FilterData;
        
        public function MopedGirl(param1:Number, param2:Number, param3:DisplayObject, param4:Session, param5:int = -2, param6:String = "Char4", param7:MopedCouple = null)
        {
            super(param1,param2,param3,param4,param5,param6);
            this.guy = param7;
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
        
        override internal function shiftPressedActions() : void
        {
            this.eject();
        }
        
        override public function reset() : void
        {
            super.reset();
            this.ejected = false;
        }
        
        override public function die() : void
        {
            super.die();
        }
        
        override internal function createBodies() : void
        {
            super.createBodies();
            var _loc1_:b2Shape = this.upperLeg1Shape = upperLeg1Body.GetShapeList();
            _loc1_.m_isSensor = true;
            _loc1_ = this.upperLeg2Shape = upperLeg2Body.GetShapeList();
            _loc1_.m_isSensor = true;
            _loc1_ = lowerLeg1Body.GetShapeList();
            _loc1_.m_isSensor = true;
            _loc1_ = lowerLeg2Body.GetShapeList();
            _loc1_.m_isSensor = true;
            _loc1_ = lowerArm1Body.GetShapeList();
            _loc1_.m_isSensor = true;
            _loc1_ = lowerArm2Body.GetShapeList();
            _loc1_.m_isSensor = true;
            this.leg1Contacts = 0;
            this.leg2Contacts = 0;
            _session.contactListener.registerListener(ContactListener.ADD,this.upperLeg1Shape,this.leg1Stuck);
            _session.contactListener.registerListener(ContactListener.REMOVE,this.upperLeg1Shape,this.leg1Free);
            _session.contactListener.registerListener(ContactListener.ADD,this.upperLeg2Shape,this.leg2Stuck);
            _session.contactListener.registerListener(ContactListener.REMOVE,this.upperLeg2Shape,this.leg2Free);
        }
        
        override internal function createMovieClips() : void
        {
            super.createMovieClips();
            _session.containerSprite.addChildAt(chestMC,_session.containerSprite.getChildIndex(lowerLeg1MC));
            var _loc1_:int = _session.containerSprite.getChildIndex(this.guy.lowerLeg2MC);
            _session.containerSprite.addChildAt(lowerLeg2MC,_loc1_);
            _session.containerSprite.addChildAt(upperLeg2MC,_loc1_);
            _session.containerSprite.addChildAt(upperLeg4MC,_loc1_);
            _session.containerSprite.addChildAt(lowerArm2MC,_loc1_);
            _session.containerSprite.addChildAt(upperArm2MC,_loc1_);
            _session.containerSprite.addChildAt(upperArm4MC,_loc1_);
        }
        
        override internal function createJoints() : void
        {
            var _loc1_:Number = NaN;
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            super.createJoints();
            var _loc4_:Number = oneEightyOverPI;
            _loc1_ = upperLeg1Body.GetAngle() - pelvisBody.GetAngle();
            _loc2_ = -110 / _loc4_ - _loc1_;
            _loc3_ = 10 / _loc4_ - _loc1_;
            _loc1_ = upperLeg2Body.GetAngle() - pelvisBody.GetAngle();
            _loc2_ = -110 / _loc4_ - _loc1_;
            _loc3_ = 10 / _loc4_ - _loc1_;
            _loc1_ = lowerArm1Body.GetAngle() - upperArm1Body.GetAngle();
            _loc2_ = -90 / _loc4_ - _loc1_;
            _loc3_ = 0 / _loc4_ - _loc1_;
            elbowJoint1.SetLimits(_loc2_,_loc3_);
            _loc1_ = lowerArm2Body.GetAngle() - upperArm2Body.GetAngle();
            _loc2_ = -90 / _loc4_ - _loc1_;
            _loc3_ = 0 / _loc4_ - _loc1_;
            elbowJoint2.SetLimits(_loc2_,_loc3_);
            _loc1_ = head1Body.GetAngle() - chestBody.GetAngle();
            _loc2_ = -20 / _loc4_ - _loc1_;
            _loc3_ = 0 / _loc4_ - _loc1_;
            neckJoint.SetLimits(_loc2_,_loc3_);
            var _loc5_:b2RevoluteJointDef = new b2RevoluteJointDef();
            _loc5_.maxMotorTorque = this.maxTorque;
            var _loc6_:b2Vec2 = new b2Vec2();
            _loc6_.Set(pelvisBody.GetPosition().x,pelvisBody.GetPosition().y);
            _loc5_.Initialize(this.guy.frameBody,pelvisBody,_loc6_);
            this.framePelvis = _session.m_world.CreateJoint(_loc5_) as b2RevoluteJoint;
            var _loc7_:MovieClip = shapeGuide["handleAnchor"];
            _loc6_.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc5_.Initialize(this.guy.chestBody,lowerArm1Body,_loc6_);
            this.torsoHand1 = _session.m_world.CreateJoint(_loc5_) as b2RevoluteJoint;
            this.torsoHand1JointDef = _loc5_.clone();
            this.torsoAnchorPoint = this.guy.chestBody.GetLocalPoint(_loc6_);
            _loc5_.Initialize(this.guy.chestBody,lowerArm2Body,_loc6_);
            this.torsoHand2 = _session.m_world.CreateJoint(_loc5_) as b2RevoluteJoint;
            this.torsoHand2JointDef = _loc5_.clone();
            _loc7_ = shapeGuide["footAnchor"];
            _loc6_.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc5_.Initialize(this.guy.frameBody,lowerLeg1Body,_loc6_);
            this.frameFoot1 = _session.m_world.CreateJoint(_loc5_) as b2RevoluteJoint;
            _loc5_.Initialize(this.guy.frameBody,lowerLeg2Body,_loc6_);
            this.frameFoot2 = _session.m_world.CreateJoint(_loc5_) as b2RevoluteJoint;
        }
        
        override public function paint() : void
        {
            super.paint();
        }
        
        override internal function eject() : void
        {
            if(this.ejected)
            {
                return;
            }
            removeAction(this.reAttaching);
            this.ejected = true;
            resetJointLimits();
            var _loc1_:b2World = _session.m_world;
            _loc1_.DestroyJoint(this.framePelvis);
            this.framePelvis = null;
            if(this.frameFoot1)
            {
                _loc1_.DestroyJoint(this.frameFoot1);
                this.frameFoot1 = null;
            }
            if(this.frameFoot2)
            {
                _loc1_.DestroyJoint(this.frameFoot2);
                this.frameFoot2 = null;
            }
            if(this.torsoHand1)
            {
                _loc1_.DestroyJoint(this.torsoHand1);
                this.torsoHand1 = null;
            }
            if(this.torsoHand2)
            {
                _loc1_.DestroyJoint(this.torsoHand2);
                this.torsoHand2 = null;
            }
            if(!this.guy.tankShape)
            {
                this.leg1Contacts = 0;
                this.leg2Contacts = 0;
                this.checkLegsFree();
            }
        }
        
        private function countLegContacts() : void
        {
            var _loc4_:b2Shape = null;
            var _loc5_:b2Shape = null;
            var _loc1_:int = 0;
            var _loc2_:int = 0;
            var _loc3_:b2Contact = _session.m_world.m_contactList;
            while(_loc3_)
            {
                _loc4_ = _loc3_.m_shape1;
                _loc5_ = _loc3_.m_shape2;
                if(_loc4_ == this.upperLeg1Shape)
                {
                    if(_loc5_ == this.guy.seatShape)
                    {
                        _loc1_ += 1;
                    }
                }
                else if(_loc5_ == this.upperLeg1Shape)
                {
                    if(_loc4_ == this.guy.seatShape)
                    {
                        _loc1_ += 1;
                    }
                }
                else if(_loc4_ == this.upperLeg2Shape)
                {
                    if(_loc5_ == this.guy.seatShape)
                    {
                        _loc2_ += 1;
                    }
                }
                else if(_loc5_ == this.upperLeg2Shape)
                {
                    if(_loc4_ == this.guy.seatShape)
                    {
                        _loc2_ += 1;
                    }
                }
                _loc3_ = _loc3_.m_next;
            }
            trace("COUNT " + _loc1_ + " " + _loc2_);
        }
        
        private function leg1Stuck(param1:b2ContactPoint) : void
        {
            if(param1.shape2 == this.guy.seatShape)
            {
                this.leg1Contacts += 1;
            }
        }
        
        private function leg1Free(param1:b2ContactPoint) : void
        {
            if(param1.shape2 == this.guy.seatShape)
            {
                --this.leg1Contacts;
                if(this.ejected)
                {
                    this.checkLegsFree();
                }
            }
        }
        
        private function leg2Stuck(param1:b2ContactPoint) : void
        {
            if(param1.shape2 == this.guy.seatShape)
            {
                this.leg2Contacts += 1;
            }
        }
        
        private function leg2Free(param1:b2ContactPoint) : void
        {
            if(param1.shape2 == this.guy.seatShape)
            {
                --this.leg2Contacts;
                if(this.ejected)
                {
                    this.checkLegsFree();
                }
            }
        }
        
        private function checkLegsFree() : void
        {
            if(this.leg1Contacts == 0 && this.leg2Contacts == 0)
            {
                _session.contactListener.deleteListener(ContactListener.REMOVE,this.upperLeg1Shape);
                _session.contactListener.deleteListener(ContactListener.REMOVE,this.upperLeg2Shape);
                _session.contactListener.deleteListener(ContactListener.ADD,this.upperLeg1Shape);
                _session.contactListener.deleteListener(ContactListener.ADD,this.upperLeg2Shape);
                actionsVector.push(this.legsFree);
            }
        }
        
        private function legsFree() : void
        {
            trace("LEGS FREE");
            removeAction(this.legsFree);
            var _loc1_:b2World = _session.m_world;
            this.upperLeg1Shape.m_isSensor = false;
            if(this.upperLeg1Shape.m_body)
            {
                _loc1_.Refilter(this.upperLeg1Shape);
            }
            this.upperLeg2Shape.m_isSensor = false;
            if(this.upperLeg2Shape.m_body)
            {
                _loc1_.Refilter(this.upperLeg2Shape);
            }
            lowerLeg1Shape.m_isSensor = false;
            _loc1_.Refilter(lowerLeg1Shape);
            lowerLeg2Shape.m_isSensor = false;
            _loc1_.Refilter(lowerLeg2Shape);
            lowerArm1Shape.m_isSensor = false;
            _loc1_.Refilter(lowerArm1Shape);
            lowerArm2Shape.m_isSensor = false;
            _loc1_.Refilter(lowerArm2Shape);
        }
        
        public function releaseGuy() : void
        {
            if(this.torsoHand1)
            {
                _session.m_world.DestroyJoint(this.torsoHand1);
                this.torsoHand1 = null;
            }
            if(this.torsoHand2)
            {
                _session.m_world.DestroyJoint(this.torsoHand2);
                this.torsoHand2 = null;
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
                removeAction(this.reAttaching);
                userVehicleEject();
                currentPose = 0;
                releaseGrip();
                if(voiceSound)
                {
                    voiceSound.stopSound();
                    voiceSound = null;
                }
                this.guy.mourn();
            }
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
        
        override internal function neckBreak(param1:Number, param2:Boolean = true, param3:Boolean = true) : void
        {
            super.neckBreak(param1,param2,param3);
            if(this.torsoHand1)
            {
                _session.m_world.DestroyJoint(this.torsoHand1);
                this.torsoHand1 = null;
            }
            if(this.torsoHand2)
            {
                _session.m_world.DestroyJoint(this.torsoHand2);
                this.torsoHand2 = null;
            }
            lowerArm1Shape.m_isSensor = false;
            _session.m_world.Refilter(lowerArm1Shape);
            lowerArm2Shape.m_isSensor = false;
            _session.m_world.Refilter(lowerArm2Shape);
        }
        
        override internal function torsoBreak(param1:Number, param2:Boolean = true, param3:Boolean = true) : void
        {
            super.torsoBreak(param1,param2,param3);
            this.eject();
        }
        
        override internal function elbowBreak1(param1:Number) : void
        {
            super.elbowBreak1(param1);
            lowerArm1Shape.m_isSensor = false;
            _session.m_world.Refilter(lowerArm1Shape);
            if(this.torsoHand1)
            {
                _session.m_world.DestroyJoint(this.torsoHand1);
                this.torsoHand1 = null;
            }
        }
        
        override internal function elbowBreak2(param1:Number) : void
        {
            super.elbowBreak2(param1);
            lowerArm2Shape.m_isSensor = false;
            _session.m_world.Refilter(lowerArm2Shape);
            if(this.torsoHand2)
            {
                _session.m_world.DestroyJoint(this.torsoHand2);
                this.torsoHand2 = null;
            }
        }
        
        override internal function shoulderBreak1(param1:Number, param2:Boolean = true) : void
        {
            super.shoulderBreak1(param1,param2);
            lowerArm1Shape.m_isSensor = false;
            _session.m_world.Refilter(lowerArm1Shape);
            if(this.torsoHand1)
            {
                _session.m_world.DestroyJoint(this.torsoHand1);
                this.torsoHand1 = null;
            }
        }
        
        override internal function shoulderBreak2(param1:Number, param2:Boolean = true) : void
        {
            super.shoulderBreak2(param1,param2);
            lowerArm2Shape.m_isSensor = false;
            _session.m_world.Refilter(lowerArm2Shape);
            if(this.torsoHand2)
            {
                _session.m_world.DestroyJoint(this.torsoHand2);
                this.torsoHand2 = null;
            }
        }
        
        override internal function hipBreak1(param1:Number, param2:Boolean = true) : void
        {
            super.hipBreak1(param1,param2);
            if(this.frameFoot1)
            {
                _session.m_world.DestroyJoint(this.frameFoot1);
                this.frameFoot1 = null;
            }
        }
        
        override internal function hipBreak2(param1:Number, param2:Boolean = true) : void
        {
            super.hipBreak2(param1,param2);
            if(this.frameFoot2)
            {
                _session.m_world.DestroyJoint(this.frameFoot2);
                this.frameFoot2 = null;
            }
        }
        
        override internal function kneeBreak1(param1:Number) : void
        {
            super.kneeBreak1(param1);
            if(this.frameFoot1)
            {
                _session.m_world.DestroyJoint(this.frameFoot1);
                this.frameFoot1 = null;
            }
        }
        
        override internal function kneeBreak2(param1:Number) : void
        {
            super.kneeBreak2(param1);
            if(this.frameFoot2)
            {
                _session.m_world.DestroyJoint(this.frameFoot2);
                this.frameFoot2 = null;
            }
        }
        
        public function mourn() : void
        {
            if(!_dead)
            {
                addVocals("Mourn",3);
            }
        }
        
        public function reAttaching() : void
        {
            var _loc1_:int = 0;
            var _loc2_:b2World = null;
            var _loc3_:b2Vec2 = null;
            var _loc4_:b2Vec2 = null;
            if(!this.ejected && !dead)
            {
                _loc1_ = 0;
                _loc2_ = _session.m_world;
                if(!this.torsoHand1 && !elbowJoint1.broken && !shoulderJoint1.broken)
                {
                    _loc3_ = lowerArm1Body.GetWorldPoint(new b2Vec2(0,(lowerArm1Shape as b2PolygonShape).GetVertices()[2].y));
                    _loc4_ = this.guy.chestBody.GetWorldPoint(this.torsoAnchorPoint);
                    if(Math.abs(_loc3_.x - _loc4_.x) < this.reAttachDistance && Math.abs(_loc3_.y - _loc4_.y) < this.reAttachDistance)
                    {
                        this.torsoHand1 = _loc2_.CreateJoint(this.torsoHand1JointDef) as b2RevoluteJoint;
                        lowerArm1MC.hand.gotoAndStop(1);
                        _loc1_ += 1;
                    }
                }
                else
                {
                    _loc1_ += 1;
                }
                if(!this.torsoHand2 && !elbowJoint2.broken && !shoulderJoint2.broken)
                {
                    _loc3_ = lowerArm2Body.GetWorldPoint(new b2Vec2(0,(lowerArm2Shape as b2PolygonShape).GetVertices()[2].y));
                    _loc4_ = this.guy.chestBody.GetWorldPoint(this.torsoAnchorPoint);
                    if(Math.abs(_loc3_.x - _loc4_.x) < this.reAttachDistance && Math.abs(_loc3_.y - _loc4_.y) < this.reAttachDistance)
                    {
                        this.torsoHand2 = _loc2_.CreateJoint(this.torsoHand2JointDef) as b2RevoluteJoint;
                        lowerArm2MC.hand.gotoAndStop(1);
                        _loc1_ += 1;
                    }
                }
                else
                {
                    _loc1_ += 1;
                }
                if(_loc1_ >= 2)
                {
                    removeAction(this.reAttaching);
                }
            }
            else
            {
                removeAction(this.reAttaching);
            }
        }
    }
}

