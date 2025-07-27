package com.totaljerkface.game.character
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import com.totaljerkface.game.*;
    import flash.display.*;
    import flash.events.*;
    
    public class MopedCouple extends MopedGuy
    {
        internal var girl:MopedGirl;
        
        public function MopedCouple(param1:Number, param2:Number, param3:DisplayObject, param4:Session)
        {
            super(param1,param2,param3,param4);
            this.girl = new MopedGirl(param1,param2,param3["girl"],param4,-2,"Char9",this);
        }
        
        override public function set session(param1:Session) : void
        {
            _session = param1;
            if(this.girl)
            {
                this.girl.session = _session;
            }
        }
        
        override public function checkKeyStates() : void
        {
            super.checkKeyStates();
            if(!this.girl.dead)
            {
                if(this.girl.userVehicle)
                {
                    this.girl.userVehicle.operateKeys(_session.iteration,leftPressed,rightPressed,upPressed,downPressed,spacePressed,shiftPressed,ctrlPressed,zPressed);
                }
                else
                {
                    if(leftPressed)
                    {
                        if(rightPressed)
                        {
                            this.girl.leftAndRightActions();
                        }
                        else
                        {
                            this.girl.leftPressedActions();
                        }
                    }
                    else if(rightPressed)
                    {
                        this.girl.rightPressedActions();
                    }
                    else
                    {
                        this.girl.leftAndRightActions();
                    }
                    if(upPressed)
                    {
                        if(downPressed)
                        {
                            this.girl.upAndDownActions();
                        }
                        else
                        {
                            this.girl.upPressedActions();
                        }
                    }
                    else if(downPressed)
                    {
                        this.girl.downPressedActions();
                    }
                    else
                    {
                        this.girl.upAndDownActions();
                    }
                    if(spacePressed)
                    {
                        this.girl.spacePressedActions();
                    }
                    else
                    {
                        this.girl.spaceNullActions();
                    }
                    if(shiftPressed)
                    {
                        this.girl.shiftPressedActions();
                    }
                    else
                    {
                        this.girl.shiftNullActions();
                    }
                    if(ctrlPressed)
                    {
                        this.girl.ctrlPressedActions();
                    }
                    else
                    {
                        this.girl.ctrlNullActions();
                    }
                    if(zPressed)
                    {
                        this.girl.zPressedActions();
                    }
                    else
                    {
                        this.girl.zNullActions();
                    }
                }
            }
        }
        
        override public function checkReplayData(param1:KeyDisplay, param2:String) : void
        {
            super.checkReplayData(param1,param2);
            if(!this.girl.dead)
            {
                if(this.girl.userVehicle)
                {
                    this.girl.userVehicle.operateReplayData(_session.iteration,param2);
                }
                else
                {
                    if(param2.charAt(0) == "1")
                    {
                        if(param2.charAt(1) == "1")
                        {
                            this.girl.leftAndRightActions();
                        }
                        else
                        {
                            this.girl.leftPressedActions();
                        }
                    }
                    else if(param2.charAt(1) == "1")
                    {
                        this.girl.rightPressedActions();
                    }
                    else
                    {
                        this.girl.leftAndRightActions();
                    }
                    if(param2.charAt(2) == "1")
                    {
                        if(param2.charAt(3) == "1")
                        {
                            this.girl.upAndDownActions();
                        }
                        else
                        {
                            this.girl.upPressedActions();
                        }
                    }
                    else if(param2.charAt(3) == "1")
                    {
                        this.girl.downPressedActions();
                    }
                    else
                    {
                        this.girl.upAndDownActions();
                    }
                    if(param2.charAt(4) == "1")
                    {
                        this.girl.spacePressedActions();
                    }
                    else
                    {
                        this.girl.spaceNullActions();
                    }
                    if(param2.charAt(5) == "1")
                    {
                        this.girl.shiftPressedActions();
                    }
                    else
                    {
                        this.girl.shiftNullActions();
                    }
                    if(param2.charAt(6) == "1")
                    {
                        this.girl.ctrlPressedActions();
                    }
                    else
                    {
                        this.girl.ctrlNullActions();
                    }
                    if(param2.charAt(7) == "1")
                    {
                        this.girl.zPressedActions();
                    }
                    else
                    {
                        this.girl.zNullActions();
                    }
                }
            }
        }
        
        override protected function switchCamera() : void
        {
            if(_session.camera.focus == cameraFocus)
            {
                _session.camera.focus = this.girl.cameraFocus;
            }
            else
            {
                _session.camera.focus = cameraFocus;
            }
        }
        
        override internal function shiftPressedActions() : void
        {
            this.girl.eject();
        }
        
        override public function actions() : void
        {
            super.actions();
            this.girl.actions();
        }
        
        override public function create() : void
        {
            createFilters();
            createBodies();
            createJoints();
            createMovieClips();
            setLimits();
            createDictionaries();
            this.girl.create();
            dispatchEvent(new Event(Event.COMPLETE));
        }
        
        override public function reset() : void
        {
            super.reset();
            this.girl.reset();
        }
        
        override public function die() : void
        {
            super.die();
            this.girl.die();
        }
        
        override public function paint() : void
        {
            super.paint();
            this.girl.paint();
        }
        
        override public function handleContactBuffer() : void
        {
            super.handleContactBuffer();
            this.girl.handleContactBuffer();
        }
        
        override public function checkJoints() : void
        {
            super.checkJoints();
            this.girl.checkJoints();
        }
        
        override internal function eject() : void
        {
            if(ejected)
            {
                this.girl.releaseGuy();
            }
            super.eject();
        }
        
        override public function set dead(param1:Boolean) : void
        {
            _dead = param1;
            if(_dead)
            {
                this.girl.mourn();
                userVehicleEject();
                currentPose = 0;
                releaseGrip();
                backWheelJoint.EnableMotor(false);
                frontWheelJoint.EnableMotor(false);
                if(voiceSound)
                {
                    voiceSound.stopSound();
                    voiceSound = null;
                }
            }
        }
        
        override internal function frameSmash(param1:Number, param2:b2Vec2) : void
        {
            super.frameSmash(param1,param2);
            this.girl.eject();
        }
        
        public function mourn() : void
        {
            if(_dead)
            {
            }
        }
        
        override public function reAttaching() : void
        {
            var _loc7_:b2Vec2 = null;
            var _loc8_:b2Vec2 = null;
            var _loc9_:b2Shape = null;
            var _loc1_:int = 0;
            var _loc2_:b2World = _session.m_world;
            if(!frameHand1 && !elbowJoint1.broken && !shoulderJoint1.broken)
            {
                _loc7_ = lowerArm1Body.GetWorldPoint(new b2Vec2(0,(lowerArm1Shape as b2PolygonShape).GetVertices()[2].y));
                _loc8_ = frameBody.GetWorldPoint(handleAnchorPoint);
                if(Math.abs(_loc7_.x - _loc8_.x) < reAttachDistance && Math.abs(_loc7_.y - _loc8_.y) < reAttachDistance)
                {
                    frameHand1 = _loc2_.CreateJoint(frameHand1JointDef) as b2RevoluteJoint;
                    lowerArm1MC.hand.gotoAndStop(1);
                    _loc1_ += 1;
                }
            }
            else
            {
                _loc1_ += 1;
            }
            if(!frameHand2 && !elbowJoint2.broken && !shoulderJoint2.broken)
            {
                _loc7_ = lowerArm2Body.GetWorldPoint(new b2Vec2(0,(lowerArm2Shape as b2PolygonShape).GetVertices()[2].y));
                _loc8_ = frameBody.GetWorldPoint(handleAnchorPoint);
                if(Math.abs(_loc7_.x - _loc8_.x) < reAttachDistance && Math.abs(_loc7_.y - _loc8_.y) < reAttachDistance)
                {
                    frameHand2 = _loc2_.CreateJoint(frameHand2JointDef) as b2RevoluteJoint;
                    lowerArm2MC.hand.gotoAndStop(1);
                    _loc1_ += 1;
                }
            }
            else
            {
                _loc1_ += 1;
            }
            var _loc3_:Number = -0.87;
            var _loc4_:Number = Number(hipJoint1.GetJointAngle());
            var _loc5_:Number = Number(hipJoint2.GetJointAngle());
            var _loc6_:Boolean = (_loc4_ < _loc3_ || Boolean(hipJoint1.broken)) && (_loc5_ < _loc3_ || Boolean(hipJoint2.broken)) ? true : false;
            if(!framePelvis)
            {
                _loc7_ = pelvisBody.GetPosition();
                _loc8_ = frameBody.GetWorldPoint(pelvisAnchorPoint);
                if(Math.abs(_loc7_.x - _loc8_.x) < reAttachDistance && Math.abs(_loc7_.y - _loc8_.y) < reAttachDistance && _loc6_)
                {
                    trace("frame PELVIS " + _loc4_ + " " + _loc5_);
                    framePelvis = _loc2_.CreateJoint(framePelvisJointDef) as b2RevoluteJoint;
                    _loc9_ = upperLeg1Body.GetShapeList();
                    _loc9_.m_isSensor = true;
                    _loc2_.Refilter(_loc9_);
                    _loc9_ = upperLeg2Body.GetShapeList();
                    _loc9_.m_isSensor = true;
                    _loc2_.Refilter(_loc9_);
                    _loc1_ += 1;
                    this.girl.actionsVector.push(this.girl.reAttaching);
                }
            }
            else
            {
                _loc1_ += 1;
            }
            if(framePelvis)
            {
                if(!frameFoot1 && !kneeJoint1.broken && !hipJoint1.broken)
                {
                    _loc7_ = lowerLeg1Body.GetWorldPoint(new b2Vec2(0,(lowerLeg1Shape as b2PolygonShape).GetVertices()[2].y));
                    _loc8_ = frameBody.GetWorldPoint(footAnchorPoint);
                    if(Math.abs(_loc7_.x - _loc8_.x) < reAttachDistance && Math.abs(_loc7_.y - _loc8_.y) < reAttachDistance)
                    {
                        frameFoot1 = _loc2_.CreateJoint(frameFoot1JointDef) as b2RevoluteJoint;
                        _loc1_ += 1;
                    }
                }
                else
                {
                    _loc1_ += 1;
                }
                if(!frameFoot2 && !kneeJoint2.broken && !hipJoint2.broken)
                {
                    _loc7_ = lowerLeg2Body.GetWorldPoint(new b2Vec2(0,(lowerLeg2Shape as b2PolygonShape).GetVertices()[2].y));
                    _loc8_ = frameBody.GetWorldPoint(footAnchorPoint);
                    if(Math.abs(_loc7_.x - _loc8_.x) < reAttachDistance && Math.abs(_loc7_.y - _loc8_.y) < reAttachDistance)
                    {
                        frameFoot2 = _loc2_.CreateJoint(frameFoot2JointDef) as b2RevoluteJoint;
                        _loc1_ += 1;
                    }
                }
                else
                {
                    _loc1_ += 1;
                }
            }
            if(_loc1_ >= 5)
            {
                trace("ATTACH COMPLETE");
                trace("currpose " + _currentPose);
                removeAction(this.reAttaching);
            }
        }
    }
}

