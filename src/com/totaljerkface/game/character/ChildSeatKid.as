package com.totaljerkface.game.character
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import com.totaljerkface.game.*;
    import flash.display.*;
    import flash.events.*;
    
    public class ChildSeatKid extends CharacterB2D
    {
        internal var dad:IrresponsibleDad;
        
        internal var ejected:Boolean;
        
        internal var detached:Boolean;
        
        internal var detachLimit:Number = 200;
        
        internal var seatBody:b2Body;
        
        internal var seatShape1:b2Shape;
        
        internal var seatMC:MovieClip;
        
        internal var frameSeatJoint:b2RevoluteJoint;
        
        internal var seatChest:b2RevoluteJoint;
        
        internal var seatPelvis:b2RevoluteJoint;
        
        internal var seatLeg1:b2RevoluteJoint;
        
        internal var seatLeg2:b2RevoluteJoint;
        
        internal var extraFilter:b2FilterData;
        
        public function ChildSeatKid(param1:Number, param2:Number, param3:DisplayObject, param4:Session, param5:int = -2, param6:String = "kid", param7:IrresponsibleDad = null)
        {
            super(param1,param2,param3,param4,param5,param6);
            this.dad = param7;
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
        
        override internal function ctrlPressedActions() : void
        {
            this.eject();
        }
        
        override internal function createFilters() : void
        {
            defaultFilter = new b2FilterData();
            defaultFilter.groupIndex = groupID;
            defaultFilter.categoryBits = 260;
            defaultFilter.maskBits = 270;
            zeroFilter = new b2FilterData();
            zeroFilter.groupIndex = 0;
            zeroFilter.categoryBits = 260;
            lowerBodyFilter = new b2FilterData();
            lowerBodyFilter.categoryBits = 260;
            lowerBodyFilter.groupIndex = groupID - 5;
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
            this.seatBody = null;
        }
        
        override internal function createDictionaries() : void
        {
            super.createDictionaries();
            contactAddSounds[this.seatShape1] = "BikeHit3";
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
            _loc2_.filter = defaultFilter;
            _loc2_.vertexCount = 4;
            var _loc3_:int = 0;
            while(_loc3_ < 4)
            {
                _loc4_ = shapeGuide["seat1Vert" + [_loc3_ + 1]];
                _loc2_.vertices[_loc3_] = new b2Vec2(_startX + _loc4_.x / character_scale,_startY + _loc4_.y / character_scale);
                _loc3_++;
            }
            this.seatBody = _session.m_world.CreateBody(_loc1_);
            this.seatShape1 = this.seatBody.CreateShape(_loc2_);
            _session.contactListener.registerListener(ContactListener.ADD,this.seatShape1,contactAddHandler);
            _loc3_ = 0;
            while(_loc3_ < 4)
            {
                _loc4_ = shapeGuide["seat2Vert" + [_loc3_ + 1]];
                _loc2_.vertices[_loc3_] = new b2Vec2(_startX + _loc4_.x / character_scale,_startY + _loc4_.y / character_scale);
                _loc3_++;
            }
            this.seatBody.CreateShape(_loc2_);
            _loc3_ = 0;
            while(_loc3_ < 4)
            {
                _loc4_ = shapeGuide["seat3Vert" + [_loc3_ + 1]];
                _loc2_.vertices[_loc3_] = new b2Vec2(_startX + _loc4_.x / character_scale,_startY + _loc4_.y / character_scale);
                _loc3_++;
            }
            _loc2_.isSensor = true;
            this.seatBody.CreateShape(_loc2_);
            this.seatBody.SetMassFromShapes();
            paintVector.push(this.seatBody);
        }
        
        override internal function createMovieClips() : void
        {
            super.createMovieClips();
            this.seatMC = sourceObject["seat"];
            var _loc4_:* = 1 / mc_scale;
            this.seatMC.scaleY = 1 / mc_scale;
            this.seatMC.scaleX = _loc4_;
            var _loc1_:b2Vec2 = this.seatBody.GetLocalCenter();
            _loc1_ = new b2Vec2((_startX - _loc1_.x) * character_scale,(_startY - _loc1_.y) * character_scale);
            var _loc2_:MovieClip = shapeGuide["seat3Vert3"];
            var _loc3_:b2Vec2 = new b2Vec2(_loc2_.x + _loc1_.x,_loc2_.y + _loc1_.y);
            this.seatMC.inner.x = _loc3_.x;
            this.seatMC.inner.y = _loc3_.y;
            this.seatBody.SetUserData(this.seatMC);
            _session.containerSprite.addChildAt(this.seatMC,_session.containerSprite.getChildIndex(upperArm1MC));
        }
        
        override internal function resetMovieClips() : void
        {
            super.resetMovieClips();
            this.seatBody.SetUserData(this.seatMC);
        }
        
        override internal function createJoints() : void
        {
            super.createJoints();
            var _loc1_:b2RevoluteJointDef = new b2RevoluteJointDef();
            var _loc2_:b2Vec2 = new b2Vec2();
            var _loc3_:IrresponsibleDad = _session.character as IrresponsibleDad;
            var _loc4_:MovieClip = shapeGuide["frameSeatAnchor"];
            _loc1_.enableLimit = true;
            _loc1_.lowerAngle = 0;
            _loc1_.upperAngle = 0;
            _loc2_.Set(_startX + _loc4_.x / character_scale,_startY + _loc4_.y / character_scale);
            _loc1_.Initialize(_loc3_.frameBody,this.seatBody,_loc2_);
            this.frameSeatJoint = _session.m_world.CreateJoint(_loc1_) as b2RevoluteJoint;
            _loc1_.enableLimit = false;
            _loc2_.Set(chestBody.GetPosition().x,chestBody.GetPosition().y);
            _loc1_.Initialize(this.seatBody,chestBody,_loc2_);
            this.seatChest = _session.m_world.CreateJoint(_loc1_) as b2RevoluteJoint;
            _loc2_.Set(pelvisBody.GetPosition().x,pelvisBody.GetPosition().y);
            _loc1_.Initialize(this.seatBody,pelvisBody,_loc2_);
            this.seatPelvis = _session.m_world.CreateJoint(_loc1_) as b2RevoluteJoint;
            _loc2_.Set(upperLeg1Body.GetPosition().x,upperLeg1Body.GetPosition().y);
            _loc1_.Initialize(this.seatBody,upperLeg1Body,_loc2_);
            this.seatLeg1 = _session.m_world.CreateJoint(_loc1_) as b2RevoluteJoint;
            _loc2_.Set(upperLeg2Body.GetPosition().x,upperLeg2Body.GetPosition().y);
            _loc1_.Initialize(this.seatBody,upperLeg2Body,_loc2_);
            this.seatLeg2 = _session.m_world.CreateJoint(_loc1_) as b2RevoluteJoint;
        }
        
        override public function checkJoints() : void
        {
            super.checkJoints();
            checkRevJoint(this.frameSeatJoint,this.detachLimit,this.detachSeat);
        }
        
        internal function detachSeat(param1:Number) : void
        {
            var _loc2_:b2Shape = null;
            trace("detach seat " + param1);
            this.frameSeatJoint.broken = true;
            this.detached = true;
            _session.m_world.DestroyJoint(this.frameSeatJoint);
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
                _loc2_ = this.seatBody.GetShapeList();
                while(_loc2_)
                {
                    _loc2_.SetFilterData(this.extraFilter);
                    _loc2_.m_isSensor = false;
                    _session.m_world.Refilter(_loc2_);
                    _loc2_ = _loc2_.m_next;
                }
            }
            else
            {
                _loc2_ = this.seatBody.GetShapeList();
                while(_loc2_)
                {
                    _loc2_.m_isSensor = false;
                    _session.m_world.Refilter(_loc2_);
                    _loc2_ = _loc2_.m_next;
                }
            }
        }
        
        override internal function eject() : void
        {
            if(this.ejected)
            {
                return;
            }
            this.ejected = true;
            resetJointLimits();
            _session.m_world.DestroyJoint(this.seatPelvis);
            this.seatPelvis = null;
            _session.m_world.DestroyJoint(this.seatChest);
            this.seatChest = null;
            if(this.seatLeg1)
            {
                _session.m_world.DestroyJoint(this.seatLeg1);
                this.seatLeg1 = null;
            }
            if(this.seatLeg2)
            {
                _session.m_world.DestroyJoint(this.seatLeg2);
                this.seatLeg2 = null;
            }
            var _loc1_:b2World = _session.m_world;
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
            var _loc2_:b2Shape = this.seatBody.GetShapeList();
            while(_loc2_)
            {
                _loc2_.SetFilterData(zeroFilter);
                _loc1_.Refilter(_loc2_);
                _loc2_ = _loc2_.m_next;
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
                this.dad.mourn();
            }
        }
        
        internal function refilterShit(param1:b2Shape) : void
        {
            if(param1.m_filter.maskBits == defaultFilter.maskBits)
            {
                param1.m_filter = this.extraFilter;
                _session.m_world.Refilter(param1);
            }
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
        
        override internal function hipBreak1(param1:Number, param2:Boolean = true) : void
        {
            super.hipBreak1(param1,param2);
            if(this.seatLeg1)
            {
                _session.m_world.DestroyJoint(this.seatLeg1);
                this.seatLeg1 = null;
            }
        }
        
        override internal function hipBreak2(param1:Number, param2:Boolean = true) : void
        {
            super.hipBreak2(param1,param2);
            if(this.seatLeg2)
            {
                _session.m_world.DestroyJoint(this.seatLeg2);
                this.seatLeg2 = null;
            }
        }
    }
}

