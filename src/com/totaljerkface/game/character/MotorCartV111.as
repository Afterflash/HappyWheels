package com.totaljerkface.game.character
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.events.*;
    import com.totaljerkface.game.level.groups.Vehicle;
    import com.totaljerkface.game.sound.*;
    import flash.display.*;
    import flash.events.*;
    
    public class MotorCartV111 extends MotorCart
    {
        protected var reAttachDistance:Number = 0.25;
        
        protected var ejectImpulse:Number = 4;
        
        public function MotorCartV111(param1:Number, param2:Number, param3:DisplayObject, param4:Session)
        {
            super(param1,param2,param3,param4);
        }
        
        override internal function grabAction(param1:b2Body, param2:b2Shape, param3:b2Body) : void
        {
            var _loc7_:b2Vec2 = null;
            var _loc8_:Vehicle = null;
            var _loc4_:b2Shape = param1.GetShapeList();
            var _loc5_:b2Vec2 = param1.GetWorldPoint(new b2Vec2(0,(_loc4_ as b2PolygonShape).GetVertices()[2].y));
            if(!mainSmashed && !_dying && !userVehicle)
            {
                _loc7_ = mainBody.GetWorldPoint(handleAnchorPoint);
                if(Math.abs(_loc5_.x - _loc7_.x) < this.reAttachDistance && Math.abs(_loc5_.y - _loc7_.y) < this.reAttachDistance)
                {
                    this.reAttach(param1);
                    return;
                }
            }
            var _loc6_:b2RevoluteJointDef = new b2RevoluteJointDef();
            if(!param3.IsStatic())
            {
                _loc6_.enableLimit = true;
            }
            _loc6_.maxMotorTorque = 4;
            _loc6_.Initialize(param3,param1,_loc5_);
            if(param1 == lowerArm1Body)
            {
                lowerArm1MC.hand.gotoAndStop(1);
                _session.contactListener.deleteListener(ContactListener.RESULT,lowerArm1Shape);
                if(param2.GetUserData() is Vehicle)
                {
                    _loc8_ = param2.GetUserData();
                    if(Boolean(userVehicle) && _loc8_ != userVehicle)
                    {
                        gripJoint1 = _session.m_world.CreateJoint(_loc6_) as b2RevoluteJoint;
                    }
                    else
                    {
                        userVehicle = param2.GetUserData();
                        userVehicle.addCharacter(this);
                        vehicleArm1Joint = _session.m_world.CreateJoint(_loc6_) as b2RevoluteJoint;
                        currentPose = 0;
                        switch(userVehicle.characterPose)
                        {
                            case 0:
                                break;
                            case 1:
                                currentPose = 10;
                                break;
                            case 2:
                                currentPose = 11;
                                break;
                            case 3:
                                currentPose = 12;
                        }
                    }
                }
                else
                {
                    gripJoint1 = _session.m_world.CreateJoint(_loc6_) as b2RevoluteJoint;
                }
            }
            if(param1 == lowerArm2Body)
            {
                lowerArm2MC.hand.gotoAndStop(1);
                _session.contactListener.deleteListener(ContactListener.RESULT,lowerArm2Shape);
                if(param2.GetUserData() is Vehicle)
                {
                    _loc8_ = param2.GetUserData();
                    if(Boolean(userVehicle) && _loc8_ != userVehicle)
                    {
                        gripJoint2 = _session.m_world.CreateJoint(_loc6_) as b2RevoluteJoint;
                    }
                    else
                    {
                        userVehicle = param2.GetUserData();
                        userVehicle.addCharacter(this);
                        vehicleArm2Joint = _session.m_world.CreateJoint(_loc6_) as b2RevoluteJoint;
                        currentPose = 0;
                        switch(userVehicle.characterPose)
                        {
                            case 0:
                                break;
                            case 1:
                                currentPose = 10;
                                break;
                            case 2:
                                currentPose = 11;
                                break;
                            case 3:
                                currentPose = 12;
                        }
                    }
                }
                else
                {
                    gripJoint2 = _session.m_world.CreateJoint(_loc6_) as b2RevoluteJoint;
                }
            }
        }
        
        override internal function eject() : void
        {
            if(ejected)
            {
                return;
            }
            super.eject();
            var _loc1_:Number = mainBody.GetAngle() - Math.PI / 2;
            var _loc2_:Number = Math.cos(_loc1_) * this.ejectImpulse;
            var _loc3_:Number = Math.sin(_loc1_) * this.ejectImpulse;
            chestBody.ApplyImpulse(new b2Vec2(_loc2_,_loc3_),chestBody.GetWorldCenter());
            pelvisBody.ApplyImpulse(new b2Vec2(_loc2_,_loc3_),pelvisBody.GetWorldCenter());
        }
        
        override public function reAttaching() : void
        {
            var _loc8_:b2Vec2 = null;
            var _loc9_:b2Vec2 = null;
            var _loc1_:int = 0;
            var _loc2_:b2World = _session.m_world;
            if(!mainHand1 && !elbowJoint1.broken && !shoulderJoint1.broken)
            {
                _loc8_ = lowerArm1Body.GetWorldPoint(new b2Vec2(0,(lowerArm1Shape as b2PolygonShape).GetVertices()[2].y));
                _loc9_ = mainBody.GetWorldPoint(handleAnchorPoint);
                if(Math.abs(_loc8_.x - _loc9_.x) < this.reAttachDistance && Math.abs(_loc8_.y - _loc9_.y) < this.reAttachDistance)
                {
                    mainHand1 = _loc2_.CreateJoint(mainHand1JointDef) as b2RevoluteJoint;
                    lowerArm1MC.hand.gotoAndStop(1);
                    _loc1_ += 1;
                }
            }
            else
            {
                _loc1_ += 1;
            }
            if(!mainHand2 && !elbowJoint2.broken && !shoulderJoint2.broken)
            {
                _loc8_ = lowerArm2Body.GetWorldPoint(new b2Vec2(0,(lowerArm2Shape as b2PolygonShape).GetVertices()[2].y));
                _loc9_ = mainBody.GetWorldPoint(handleAnchorPoint);
                if(Math.abs(_loc8_.x - _loc9_.x) < this.reAttachDistance && Math.abs(_loc8_.y - _loc9_.y) < this.reAttachDistance)
                {
                    mainHand2 = _loc2_.CreateJoint(mainHand2JointDef) as b2RevoluteJoint;
                    lowerArm2MC.hand.gotoAndStop(1);
                    _loc1_ += 1;
                }
            }
            else
            {
                _loc1_ += 1;
            }
            var _loc3_:Number = 0.5;
            var _loc4_:Number = 0.25;
            var _loc5_:Number = Number(kneeJoint1.GetJointAngle());
            var _loc6_:Number = Number(kneeJoint2.GetJointAngle());
            var _loc7_:Boolean = (_loc5_ < _loc3_ && _loc5_ > _loc4_ || Boolean(kneeJoint1.broken)) && (_loc6_ < _loc3_ && _loc6_ > _loc4_ || Boolean(kneeJoint2.broken)) ? true : false;
            if(!mainPelvis)
            {
                _loc8_ = pelvisBody.GetPosition();
                _loc9_ = mainBody.GetWorldPoint(pelvisAnchorPoint);
                if(Math.abs(_loc8_.x - _loc9_.x) < this.reAttachDistance && Math.abs(_loc8_.y - _loc9_.y) < this.reAttachDistance && _loc7_)
                {
                    trace("MAIN PELVIS " + _loc5_ + " " + _loc6_);
                    mainPelvis = _loc2_.CreateJoint(mainPelvisJointDef) as b2RevoluteJoint;
                    _loc1_ += 1;
                }
            }
            else
            {
                _loc1_ += 1;
            }
            if(mainPelvis)
            {
                if(!mainLeg1)
                {
                    _loc8_ = upperLeg1Body.GetPosition();
                    _loc9_ = mainBody.GetWorldPoint(leg1AnchorPoint);
                    if(Math.abs(_loc8_.x - _loc9_.x) < this.reAttachDistance && Math.abs(_loc8_.y - _loc9_.y) < this.reAttachDistance && _loc7_)
                    {
                        mainLeg1 = _loc2_.CreateJoint(mainLeg1JointDef) as b2RevoluteJoint;
                        _loc1_ += 1;
                    }
                }
                else
                {
                    _loc1_ += 1;
                }
                if(!mainLeg2)
                {
                    _loc8_ = upperLeg2Body.GetPosition();
                    _loc9_ = mainBody.GetWorldPoint(leg2AnchorPoint);
                    if(Math.abs(_loc8_.x - _loc9_.x) < this.reAttachDistance && Math.abs(_loc8_.y - _loc9_.y) < this.reAttachDistance && _loc7_)
                    {
                        mainLeg2 = _loc2_.CreateJoint(mainLeg2JointDef) as b2RevoluteJoint;
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
                trace(kneeJoint1.GetJointAngle());
                trace(kneeJoint2.GetJointAngle());
                removeAction(this.reAttaching);
            }
        }
        
        override protected function reAttach(param1:b2Body) : void
        {
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            var _loc4_:Number = NaN;
            trace("RE ATTACH");
            _session.contactListener.deleteListener(ContactListener.RESULT,lowerArm1Shape);
            _session.contactListener.deleteListener(ContactListener.RESULT,lowerArm2Shape);
            delete contactResultBuffer[lowerArm1Shape];
            delete contactResultBuffer[lowerArm2Shape];
            ejected = false;
            currentPose = 0;
            releaseGrip();
            var _loc5_:Number = 180 / Math.PI;
            _loc2_ = head1Body.GetAngle() - chestBody.GetAngle() - neckJoint.GetJointAngle();
            _loc3_ = -10 / _loc5_ - _loc2_;
            _loc4_ = 10 / _loc5_ - _loc2_;
            neckJoint.SetLimits(_loc3_,_loc4_);
            var _loc6_:b2World = _session.m_world;
            if(param1 == lowerArm1Body)
            {
                mainHand1 = _loc6_.CreateJoint(mainHand1JointDef) as b2RevoluteJoint;
                lowerArm1MC.hand.gotoAndStop(1);
            }
            else
            {
                mainHand2 = _loc6_.CreateJoint(mainHand2JointDef) as b2RevoluteJoint;
                lowerArm2MC.hand.gotoAndStop(1);
            }
            var _loc7_:b2FilterData = new b2FilterData();
            _loc7_.categoryBits = 513;
            _loc7_.groupIndex = -2;
            handleShape.SetFilterData(_loc7_);
            _loc6_.Refilter(handleShape);
            _loc7_ = zeroFilter.Copy();
            _loc7_.groupIndex = -2;
            shaftShape.SetFilterData(_loc7_);
            _loc6_.Refilter(shaftShape);
            actionsVector.push(this.reAttaching);
        }
        
        override internal function shoulderBreak1(param1:Number, param2:Boolean = true) : void
        {
            super.shoulderBreak1(param1,param2);
            if(ejected)
            {
                return;
            }
            if(mainHand1)
            {
                _session.m_world.DestroyJoint(mainHand1);
                mainHand1 = null;
            }
            checkEject();
        }
        
        override internal function shoulderBreak2(param1:Number, param2:Boolean = true) : void
        {
            super.shoulderBreak2(param1,param2);
            if(ejected)
            {
                return;
            }
            if(mainHand2)
            {
                _session.m_world.DestroyJoint(mainHand2);
                mainHand2 = null;
            }
            checkEject();
        }
        
        override internal function hipBreak1(param1:Number, param2:Boolean = true) : void
        {
            super.hipBreak1(param1,param2);
            if(ejected)
            {
                return;
            }
            if(mainLeg1)
            {
                _session.m_world.DestroyJoint(mainLeg1);
                mainLeg1 = null;
            }
            checkEject();
        }
        
        override internal function hipBreak2(param1:Number, param2:Boolean = true) : void
        {
            super.hipBreak2(param1,param2);
            if(ejected)
            {
                return;
            }
            if(mainLeg2)
            {
                _session.m_world.DestroyJoint(mainLeg2);
                mainLeg2 = null;
            }
            checkEject();
        }
    }
}

