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
    import flash.utils.*;
    
    public class SegwayGuyV111 extends SegwayGuy
    {
        protected var reAttachDistance:Number = 0.25;
        
        protected var ejectImpulse:Number = 4;
        
        public function SegwayGuyV111(param1:Number, param2:Number, param3:DisplayObject, param4:Session)
        {
            super(param1,param2,param3,param4);
        }
        
        override internal function grabAction(param1:b2Body, param2:b2Shape, param3:b2Body) : void
        {
            var _loc7_:b2Vec2 = null;
            var _loc8_:Vehicle = null;
            var _loc4_:b2Shape = param1.GetShapeList();
            var _loc5_:b2Vec2 = param1.GetWorldPoint(new b2Vec2(0,(_loc4_ as b2PolygonShape).GetVertices()[2].y));
            if(!frameSmashed && !_dying && !userVehicle)
            {
                _loc7_ = frameBody.GetWorldPoint(handleAnchorPoint);
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
        
        override public function reAttaching() : void
        {
            var _loc3_:b2Vec2 = null;
            var _loc4_:b2Vec2 = null;
            var _loc1_:int = 0;
            var _loc2_:b2World = _session.m_world;
            if(!frameHand1 && !elbowJoint1.broken && !shoulderJoint1.broken)
            {
                _loc3_ = lowerArm1Body.GetWorldPoint(new b2Vec2(0,(lowerArm1Shape as b2PolygonShape).GetVertices()[2].y));
                _loc4_ = frameBody.GetWorldPoint(handleAnchorPoint);
                if(Math.abs(_loc3_.x - _loc4_.x) < this.reAttachDistance && Math.abs(_loc3_.y - _loc4_.y) < this.reAttachDistance)
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
                _loc3_ = lowerArm2Body.GetWorldPoint(new b2Vec2(0,(lowerArm2Shape as b2PolygonShape).GetVertices()[2].y));
                _loc4_ = frameBody.GetWorldPoint(handleAnchorPoint);
                if(Math.abs(_loc3_.x - _loc4_.x) < this.reAttachDistance && Math.abs(_loc3_.y - _loc4_.y) < this.reAttachDistance)
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
            if(!standFoot1 && !kneeJoint1.broken && !hipJoint1.broken)
            {
                _loc3_ = lowerLeg1Body.GetWorldPoint(new b2Vec2(0,(lowerLeg1Shape as b2PolygonShape).GetVertices()[2].y));
                _loc4_ = frameBody.GetWorldPoint(footAnchorPoint);
                if(Math.abs(_loc3_.x - _loc4_.x) < 0.2 && Math.abs(_loc3_.y - _loc4_.y) < 0.2)
                {
                    standFoot1 = _loc2_.CreateJoint(standFoot1JointDef) as b2RevoluteJoint;
                    _loc1_ += 1;
                }
            }
            else
            {
                _loc1_ += 1;
            }
            if(!standFoot2 && !kneeJoint2.broken && !hipJoint2.broken)
            {
                _loc3_ = lowerLeg2Body.GetWorldPoint(new b2Vec2(0,(lowerLeg2Shape as b2PolygonShape).GetVertices()[2].y));
                _loc4_ = frameBody.GetWorldPoint(footAnchorPoint);
                if(Math.abs(_loc3_.x - _loc4_.x) < 0.2 && Math.abs(_loc3_.y - _loc4_.y) < 0.2)
                {
                    standFoot2 = _loc2_.CreateJoint(standFoot2JointDef) as b2RevoluteJoint;
                    _loc1_ += 1;
                }
            }
            else
            {
                _loc1_ += 1;
            }
            if(_loc1_ >= 4)
            {
                trace("ATTACH COMPLETE");
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
            _loc2_ = hipJoint1.m_body2.GetAngle() - hipJoint1.m_body1.GetAngle() - hipJoint1.GetJointAngle();
            _loc3_ = -50 / _loc5_ - _loc2_;
            _loc4_ = 10 / _loc5_ - _loc2_;
            hipJoint1.SetLimits(_loc3_,_loc4_);
            _loc2_ = hipJoint2.m_body2.GetAngle() - hipJoint2.m_body1.GetAngle() - hipJoint2.GetJointAngle();
            _loc3_ = -50 / _loc5_ - _loc2_;
            _loc4_ = 10 / _loc5_ - _loc2_;
            hipJoint2.SetLimits(_loc3_,_loc4_);
            _loc2_ = lowerArm1Body.GetAngle() - upperArm1Body.GetAngle() - elbowJoint1.GetJointAngle();
            _loc3_ = -60 / _loc5_ - _loc2_;
            _loc4_ = 0 / _loc5_ - _loc2_;
            elbowJoint1.SetLimits(_loc3_,_loc4_);
            _loc2_ = lowerArm2Body.GetAngle() - upperArm2Body.GetAngle() - elbowJoint2.GetJointAngle();
            _loc3_ = -60 / _loc5_ - _loc2_;
            _loc4_ = 0 / _loc5_ - _loc2_;
            elbowJoint2.SetLimits(_loc3_,_loc4_);
            _loc2_ = head1Body.GetAngle() - chestBody.GetAngle() - neckJoint.GetJointAngle();
            _loc3_ = 0 / _loc5_ - _loc2_;
            _loc4_ = 20 / _loc5_ - _loc2_;
            neckJoint.SetLimits(_loc3_,_loc4_);
            var _loc6_:b2World = _session.m_world;
            var _loc7_:b2FilterData = new b2FilterData();
            _loc7_.categoryBits = 514;
            var _loc8_:b2Shape = frameBody.GetShapeList();
            while(_loc8_)
            {
                _loc8_.SetFilterData(_loc7_);
                _loc6_.Refilter(_loc8_);
                _loc8_ = _loc8_.m_next;
            }
            _loc7_ = new b2FilterData();
            _loc7_.categoryBits = 260;
            _loc7_.maskBits = 268;
            _loc8_ = wheelBody.GetShapeList();
            _loc8_.SetFilterData(_loc7_);
            _loc6_.Refilter(_loc8_);
            if(param1 == lowerArm1Body)
            {
                frameHand1 = _loc6_.CreateJoint(frameHand1JointDef) as b2RevoluteJoint;
                lowerArm1MC.hand.gotoAndStop(1);
            }
            else
            {
                frameHand2 = _loc6_.CreateJoint(frameHand2JointDef) as b2RevoluteJoint;
                lowerArm2MC.hand.gotoAndStop(1);
            }
            actionsVector.push(this.reAttaching);
        }
        
        override internal function shoulderBreak1(param1:Number, param2:Boolean = true) : void
        {
            super.shoulderBreak1(param1,param2);
            if(ejected)
            {
                return;
            }
            if(frameHand1)
            {
                _session.m_world.DestroyJoint(frameHand1);
                frameHand1 = null;
                this.checkEject();
            }
        }
        
        override internal function shoulderBreak2(param1:Number, param2:Boolean = true) : void
        {
            super.shoulderBreak2(param1,param2);
            if(ejected)
            {
                return;
            }
            if(frameHand2)
            {
                _session.m_world.DestroyJoint(frameHand2);
                frameHand2 = null;
                this.checkEject();
            }
        }
        
        override internal function hipBreak1(param1:Number, param2:Boolean = true) : void
        {
            super.hipBreak1(param1,param2);
            if(ejected)
            {
                return;
            }
            if(standFoot1)
            {
                _session.m_world.DestroyJoint(standFoot1);
                standFoot1 = null;
            }
        }
        
        override internal function hipBreak2(param1:Number, param2:Boolean = true) : void
        {
            super.hipBreak2(param1,param2);
            if(ejected)
            {
                return;
            }
            if(standFoot2)
            {
                _session.m_world.DestroyJoint(standFoot2);
                standFoot2 = null;
            }
        }
        
        override internal function elbowBreak1(param1:Number) : void
        {
            trace(tag + " elbow1 break " + param1 + " -> " + _session.iteration);
            elbowJoint1.broken = true;
            _session.m_world.DestroyJoint(elbowJoint1);
            lowerArm1Body.GetShapeList().SetFilterData(zeroFilter);
            _session.m_world.Refilter(lowerArm1Body.GetShapeList());
            lowerArm1MC.gotoAndStop(2);
            switch(upperArm1MC.currentFrame)
            {
                case 3:
                    upperArm1MC.gotoAndStop(6);
                    break;
                case 4:
                    upperArm1MC.gotoAndStop(7);
                    break;
                default:
                    upperArm1MC.gotoAndStop(5);
            }
            lowerArm1MC.gotoAndStop(2);
            var _loc2_:Sprite = shapeGuide["lowerArm1Shape"];
            _session.particleController.createBloodBurst(5,15,lowerArm1Body,50,new b2Vec2(0,_loc2_.scaleY * -shapeRefScale / character_scale),_session.containerSprite);
            if(param1 < elbowLigamentLimit)
            {
                elbowLigament1 = new Ligament(upperArm1Body,lowerArm1Body,ligamentLength,character_scale,this);
                composites.push(elbowLigament1);
            }
            var _loc3_:int = Math.ceil(Math.random() * 4);
            SoundController.instance.playAreaSoundInstance("BoneBreak" + _loc3_,lowerArm1Body);
            addVocals("Elbow1",1);
            if(vehicleArm1Joint)
            {
                _session.m_world.DestroyJoint(vehicleArm1Joint);
                vehicleArm1Joint = null;
                if(vehicleArm2Joint == null)
                {
                    userVehicleEject();
                }
            }
            if(ejected)
            {
                return;
            }
            if(frameHand1)
            {
                trace("REMOVE FRAME HAND 1");
                _session.m_world.DestroyJoint(frameHand1);
                frameHand1 = null;
                this.checkEject();
            }
        }
        
        override internal function elbowBreak2(param1:Number) : void
        {
            trace(tag + " elbow2 break " + param1 + " -> " + _session.iteration);
            elbowJoint2.broken = true;
            _session.m_world.DestroyJoint(elbowJoint2);
            lowerArm2Body.GetShapeList().SetFilterData(zeroFilter);
            _session.m_world.Refilter(lowerArm2Body.GetShapeList());
            lowerArm2MC.gotoAndStop(2);
            switch(upperArm2MC.currentFrame)
            {
                case 3:
                    upperArm2MC.gotoAndStop(6);
                    break;
                case 4:
                    upperArm2MC.gotoAndStop(7);
                    break;
                default:
                    upperArm2MC.gotoAndStop(5);
            }
            lowerArm2MC.gotoAndStop(2);
            var _loc2_:Sprite = shapeGuide["lowerArm2Shape"];
            _session.particleController.createBloodBurst(5,15,lowerArm2Body,50,new b2Vec2(0,_loc2_.scaleY * -shapeRefScale / character_scale),_session.containerSprite);
            if(param1 < elbowLigamentLimit)
            {
                elbowLigament2 = new Ligament(upperArm2Body,lowerArm2Body,ligamentLength,character_scale,this);
                composites.push(elbowLigament2);
            }
            var _loc3_:int = Math.ceil(Math.random() * 4);
            SoundController.instance.playAreaSoundInstance("BoneBreak" + _loc3_,lowerArm2Body);
            addVocals("Elbow2",1);
            if(vehicleArm2Joint)
            {
                _session.m_world.DestroyJoint(vehicleArm2Joint);
                vehicleArm2Joint = null;
                if(vehicleArm1Joint == null)
                {
                    userVehicleEject();
                }
            }
            if(ejected)
            {
                return;
            }
            if(frameHand2)
            {
                _session.m_world.DestroyJoint(frameHand2);
                frameHand2 = null;
                this.checkEject();
            }
        }
        
        internal function checkEject() : void
        {
            if(!frameHand1 && !frameHand2)
            {
                eject();
            }
        }
    }
}

