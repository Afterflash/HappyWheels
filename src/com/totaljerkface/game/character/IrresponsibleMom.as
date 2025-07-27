package com.totaljerkface.game.character
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.events.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;
    
    public class IrresponsibleMom extends BicycleGuy
    {
        internal var daughter:IMDaughter;
        
        internal var son:IMSon;
        
        internal var helmetOn:Boolean;
        
        internal var helmetSmashLimit:Number = 2;
        
        internal var helmetBody:b2Body;
        
        internal var helmetShape:b2Shape;
        
        internal var helmetMC:MovieClip;
        
        public function IrresponsibleMom(param1:Number, param2:Number, param3:DisplayObject, param4:Session, param5:int = -1, param6:String = "Char4")
        {
            super(param1,param2,param3,param4,param5,param6);
            shapeRefScale = 50;
            frameSmashLimit = 100;
            this.daughter = new IMDaughter(param1,param2,param3["daughter"],param4,-2,"Kid2",this);
            this.son = new IMSon(param1,param2,param3["son"],param4,-3,"Kid1",this);
        }
        
        override public function set session(param1:Session) : void
        {
            _session = param1;
            if(this.daughter)
            {
                this.daughter.session = _session;
            }
            if(this.son)
            {
                this.son.session = _session;
            }
        }
        
        override public function checkKeyStates() : void
        {
            super.checkKeyStates();
            if(!this.daughter.dead)
            {
                if(this.daughter.userVehicle)
                {
                    this.daughter.userVehicle.operateKeys(_session.iteration,leftPressed,rightPressed,upPressed,downPressed,spacePressed,shiftPressed,ctrlPressed,zPressed);
                }
                else
                {
                    if(leftPressed)
                    {
                        if(rightPressed)
                        {
                            this.daughter.leftAndRightActions();
                        }
                        else
                        {
                            this.daughter.leftPressedActions();
                        }
                    }
                    else if(rightPressed)
                    {
                        this.daughter.rightPressedActions();
                    }
                    else
                    {
                        this.daughter.leftAndRightActions();
                    }
                    if(upPressed)
                    {
                        if(downPressed)
                        {
                            this.daughter.upAndDownActions();
                        }
                        else
                        {
                            this.daughter.upPressedActions();
                        }
                    }
                    else if(downPressed)
                    {
                        this.daughter.downPressedActions();
                    }
                    else
                    {
                        this.daughter.upAndDownActions();
                    }
                    if(spacePressed)
                    {
                        this.daughter.spacePressedActions();
                    }
                    else
                    {
                        this.daughter.spaceNullActions();
                    }
                    if(shiftPressed)
                    {
                        this.daughter.shiftPressedActions();
                    }
                    else
                    {
                        this.daughter.shiftNullActions();
                    }
                    if(ctrlPressed)
                    {
                        this.daughter.ctrlPressedActions();
                    }
                    else
                    {
                        this.daughter.ctrlNullActions();
                    }
                    if(zPressed)
                    {
                        this.daughter.zPressedActions();
                    }
                    else
                    {
                        this.daughter.zNullActions();
                    }
                }
            }
            if(!this.son.dead)
            {
                if(this.son.userVehicle)
                {
                    this.son.userVehicle.operateKeys(_session.iteration,leftPressed,rightPressed,upPressed,downPressed,spacePressed,shiftPressed,ctrlPressed,zPressed);
                }
                else
                {
                    if(leftPressed)
                    {
                        if(rightPressed)
                        {
                            this.son.leftAndRightActions();
                        }
                        else
                        {
                            this.son.leftPressedActions();
                        }
                    }
                    else if(rightPressed)
                    {
                        this.son.rightPressedActions();
                    }
                    else
                    {
                        this.son.leftAndRightActions();
                    }
                    if(upPressed)
                    {
                        if(downPressed)
                        {
                            this.son.upAndDownActions();
                        }
                        else
                        {
                            this.son.upPressedActions();
                        }
                    }
                    else if(downPressed)
                    {
                        this.son.downPressedActions();
                    }
                    else
                    {
                        this.son.upAndDownActions();
                    }
                    if(spacePressed)
                    {
                        this.son.spacePressedActions();
                    }
                    else
                    {
                        this.son.spaceNullActions();
                    }
                    if(shiftPressed)
                    {
                        this.son.shiftPressedActions();
                    }
                    else
                    {
                        this.son.shiftNullActions();
                    }
                    if(ctrlPressed)
                    {
                        this.son.ctrlPressedActions();
                    }
                    else
                    {
                        this.son.ctrlNullActions();
                    }
                    if(zPressed)
                    {
                        this.son.zPressedActions();
                    }
                    else
                    {
                        this.son.zNullActions();
                    }
                }
            }
        }
        
        override public function checkReplayData(param1:KeyDisplay, param2:String) : void
        {
            super.checkReplayData(param1,param2);
            if(!this.daughter.dead)
            {
                if(this.daughter.userVehicle)
                {
                    this.daughter.userVehicle.operateReplayData(_session.iteration,param2);
                }
                else
                {
                    if(param2.charAt(0) == "1")
                    {
                        if(param2.charAt(1) == "1")
                        {
                            this.daughter.leftAndRightActions();
                        }
                        else
                        {
                            this.daughter.leftPressedActions();
                        }
                    }
                    else if(param2.charAt(1) == "1")
                    {
                        this.daughter.rightPressedActions();
                    }
                    else
                    {
                        this.daughter.leftAndRightActions();
                    }
                    if(param2.charAt(2) == "1")
                    {
                        if(param2.charAt(3) == "1")
                        {
                            this.daughter.upAndDownActions();
                        }
                        else
                        {
                            this.daughter.upPressedActions();
                        }
                    }
                    else if(param2.charAt(3) == "1")
                    {
                        this.daughter.downPressedActions();
                    }
                    else
                    {
                        this.daughter.upAndDownActions();
                    }
                    if(param2.charAt(4) == "1")
                    {
                        this.daughter.spacePressedActions();
                    }
                    else
                    {
                        this.daughter.spaceNullActions();
                    }
                    if(param2.charAt(5) == "1")
                    {
                        this.daughter.shiftPressedActions();
                    }
                    else
                    {
                        this.daughter.shiftNullActions();
                    }
                    if(param2.charAt(6) == "1")
                    {
                        this.daughter.ctrlPressedActions();
                    }
                    else
                    {
                        this.daughter.ctrlNullActions();
                    }
                    if(param2.charAt(7) == "1")
                    {
                        this.daughter.zPressedActions();
                    }
                    else
                    {
                        this.daughter.zNullActions();
                    }
                }
            }
            if(!this.son.dead)
            {
                if(this.son.userVehicle)
                {
                    this.son.userVehicle.operateReplayData(_session.iteration,param2);
                }
                else
                {
                    if(param2.charAt(0) == "1")
                    {
                        if(param2.charAt(1) == "1")
                        {
                            this.son.leftAndRightActions();
                        }
                        else
                        {
                            this.son.leftPressedActions();
                        }
                    }
                    else if(param2.charAt(1) == "1")
                    {
                        this.son.rightPressedActions();
                    }
                    else
                    {
                        this.son.leftAndRightActions();
                    }
                    if(param2.charAt(2) == "1")
                    {
                        if(param2.charAt(3) == "1")
                        {
                            this.son.upAndDownActions();
                        }
                        else
                        {
                            this.son.upPressedActions();
                        }
                    }
                    else if(param2.charAt(3) == "1")
                    {
                        this.son.downPressedActions();
                    }
                    else
                    {
                        this.son.upAndDownActions();
                    }
                    if(param2.charAt(4) == "1")
                    {
                        this.son.spacePressedActions();
                    }
                    else
                    {
                        this.son.spaceNullActions();
                    }
                    if(param2.charAt(5) == "1")
                    {
                        this.son.shiftPressedActions();
                    }
                    else
                    {
                        this.son.shiftNullActions();
                    }
                    if(param2.charAt(6) == "1")
                    {
                        this.son.ctrlPressedActions();
                    }
                    else
                    {
                        this.son.ctrlNullActions();
                    }
                    if(param2.charAt(7) == "1")
                    {
                        this.son.zPressedActions();
                    }
                    else
                    {
                        this.son.zNullActions();
                    }
                }
            }
        }
        
        override protected function switchCamera() : void
        {
            if(_session.camera.focus == cameraFocus)
            {
                _session.camera.focus = this.daughter.cameraFocus;
            }
            else if(_session.camera.focus == this.daughter.cameraFocus)
            {
                _session.camera.focus = this.son.cameraFocus;
            }
            else
            {
                _session.camera.focus = cameraFocus;
            }
        }
        
        override public function actions() : void
        {
            super.actions();
            this.daughter.actions();
            this.son.actions();
        }
        
        override public function create() : void
        {
            createFilters();
            createBodies();
            createJoints();
            this.createMovieClips();
            setLimits();
            this.createDictionaries();
            this.daughter.create();
            this.son.create();
            if(_session is SessionCharacterMenu)
            {
                this.daughter.wheelJoint.SetMotorSpeed(0);
                this.daughter.wheelJoint.EnableMotor(true);
            }
            dispatchEvent(new Event(Event.COMPLETE));
        }
        
        override public function reset() : void
        {
            super.reset();
            this.helmetOn = true;
            this.daughter.reset();
            this.son.reset();
        }
        
        override public function die() : void
        {
            super.die();
            this.helmetBody = null;
            this.daughter.die();
            this.son.die();
        }
        
        override public function paint() : void
        {
            super.paint();
            this.daughter.paint();
            this.son.paint();
        }
        
        override internal function createMovieClips() : void
        {
            super.createMovieClips();
            this.helmetMC = sourceObject["helmet"];
            var _loc1_:* = 1 / mc_scale;
            this.helmetMC.scaleY = 1 / mc_scale;
            this.helmetMC.scaleX = _loc1_;
            this.helmetMC.visible = false;
            _session.containerSprite.addChildAt(this.helmetMC,_session.containerSprite.getChildIndex(chestMC));
        }
        
        override internal function resetMovieClips() : void
        {
            super.resetMovieClips();
            this.helmetMC.visible = false;
            head1MC.helmet.visible = true;
        }
        
        override internal function createDictionaries() : void
        {
            super.createDictionaries();
            this.helmetShape = head1Shape;
            contactImpulseDict[this.helmetShape] = this.helmetSmashLimit;
        }
        
        override public function handleContactBuffer() : void
        {
            super.handleContactBuffer();
            this.daughter.handleContactBuffer();
            this.son.handleContactBuffer();
        }
        
        override protected function handleContactResults() : void
        {
            var _loc1_:ContactEvent = null;
            if(contactResultBuffer[this.helmetShape])
            {
                _loc1_ = contactResultBuffer[this.helmetShape];
                this.helmetSmash(_loc1_.impulse);
                delete contactResultBuffer[head1Shape];
                delete contactAddBuffer[head1Shape];
            }
            if(contactResultBuffer[head1Shape])
            {
                _loc1_ = contactResultBuffer[head1Shape];
                headSmash1(_loc1_.impulse);
                delete contactResultBuffer[head1Shape];
                delete contactAddBuffer[head1Shape];
            }
            if(contactResultBuffer[chestShape])
            {
                _loc1_ = contactResultBuffer[chestShape];
                chestSmash(_loc1_.impulse);
                delete contactResultBuffer[chestShape];
                delete contactAddBuffer[chestShape];
            }
            if(contactResultBuffer[pelvisShape])
            {
                _loc1_ = contactResultBuffer[pelvisShape];
                pelvisSmash(_loc1_.impulse);
                delete contactResultBuffer[pelvisShape];
                delete contactAddBuffer[pelvisShape];
            }
            if(contactResultBuffer[lowerLeg1Shape])
            {
                _loc1_ = contactResultBuffer[lowerLeg1Shape];
                footSmash1(_loc1_.impulse);
                delete contactResultBuffer[lowerLeg1Shape];
                delete contactAddBuffer[lowerLeg1Shape];
            }
            if(contactResultBuffer[lowerLeg2Shape])
            {
                _loc1_ = contactResultBuffer[lowerLeg2Shape];
                footSmash2(_loc1_.impulse);
                delete contactResultBuffer[lowerLeg2Shape];
                delete contactAddBuffer[lowerLeg2Shape];
            }
            if(contactResultBuffer[frameShape1])
            {
                _loc1_ = contactResultBuffer[frameShape1];
                this.frameSmash(_loc1_.impulse,_loc1_.normal);
                delete contactResultBuffer[frameShape1];
            }
            if(contactResultBuffer[frontWheelShape])
            {
                _loc1_ = contactResultBuffer[frontWheelShape];
                frontWheelSmash(_loc1_.impulse,_loc1_.normal);
                delete contactResultBuffer[frontWheelShape];
                delete contactAddBuffer[frontWheelShape];
            }
            if(contactResultBuffer[backWheelShape])
            {
                _loc1_ = contactResultBuffer[backWheelShape];
                backWheelSmash(_loc1_.impulse,_loc1_.normal);
                delete contactResultBuffer[backWheelShape];
                delete contactAddBuffer[backWheelShape];
            }
            if(contactResultBuffer[lowerArm1Shape])
            {
                _loc1_ = contactResultBuffer[lowerArm1Shape];
                grabAction(lowerArm1Body,_loc1_.otherShape,_loc1_.otherShape.GetBody());
                delete contactResultBuffer[lowerArm1Shape];
            }
            if(contactResultBuffer[lowerArm2Shape])
            {
                _loc1_ = contactResultBuffer[lowerArm2Shape];
                grabAction(lowerArm2Body,_loc1_.otherShape,_loc1_.otherShape.GetBody());
                delete contactResultBuffer[lowerArm2Shape];
            }
        }
        
        override public function checkJoints() : void
        {
            super.checkJoints();
            this.daughter.checkJoints();
            this.son.checkJoints();
        }
        
        override internal function frameSmash(param1:Number, param2:b2Vec2) : void
        {
            super.frameSmash(param1,param2);
            this.daughter.detachFrame(0);
            this.son.detachBasket(0);
        }
        
        internal function helmetSmash(param1:Number) : void
        {
            var _loc6_:MovieClip = null;
            trace("helmet impulse " + param1 + " -> " + _session.iteration);
            delete contactImpulseDict[this.helmetShape];
            head1Shape = this.helmetShape;
            contactImpulseDict[head1Shape] = headSmashLimit;
            this.helmetShape = null;
            this.helmetOn = false;
            var _loc2_:b2PolygonDef = new b2PolygonDef();
            var _loc3_:b2BodyDef = new b2BodyDef();
            _loc2_.density = 1;
            _loc2_.friction = 0.3;
            _loc2_.restitution = 0.1;
            _loc2_.filter = zeroFilter;
            var _loc4_:b2Vec2 = head1Body.GetPosition();
            _loc3_.position = _loc4_;
            _loc3_.angle = head1Body.GetAngle();
            _loc3_.userData = this.helmetMC;
            this.helmetMC.visible = true;
            head1MC.helmet.visible = false;
            _loc2_.vertexCount = 4;
            var _loc5_:int = 0;
            while(_loc5_ < 4)
            {
                _loc6_ = shapeGuide["helmetVert" + [_loc5_ + 1]];
                _loc2_.vertices[_loc5_] = new b2Vec2(_loc6_.x / character_scale,_loc6_.y / character_scale);
                _loc5_++;
            }
            this.helmetBody = _session.m_world.CreateBody(_loc3_);
            this.helmetBody.CreateShape(_loc2_);
            this.helmetBody.SetMassFromShapes();
            this.helmetBody.SetLinearVelocity(head1Body.GetLinearVelocity());
            this.helmetBody.SetAngularVelocity(head1Body.GetAngularVelocity());
            paintVector.push(this.helmetBody);
        }
        
        public function mourn() : void
        {
            if(!_dead)
            {
                addVocals("Damnit",3);
            }
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
            if(frameHand2)
            {
                _session.m_world.DestroyJoint(frameHand2);
                frameHand2 = null;
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
            if(gearFoot1)
            {
                _session.m_world.DestroyJoint(gearFoot1);
                gearFoot1 = null;
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
            if(gearFoot2)
            {
                _session.m_world.DestroyJoint(gearFoot2);
                gearFoot2 = null;
            }
            checkEject();
        }
        
        override public function explodeShape(param1:b2Shape, param2:Number) : void
        {
            var _loc3_:Number = NaN;
            var _loc4_:Number = NaN;
            var _loc5_:Number = NaN;
            switch(param1)
            {
                case this.helmetShape:
                    if(param2 > 0.85)
                    {
                        this.helmetSmash(0);
                    }
                    break;
                case head1Shape:
                    if(param2 > 0.85)
                    {
                        headSmash1(0);
                    }
                    break;
                case chestShape:
                    _loc3_ = chestBody.GetMass() / DEF_CHEST_MASS;
                    _loc4_ = Math.max(1 - 0.15 * _loc3_,0.7);
                    trace("new chest ratio " + _loc4_);
                    if(param2 > _loc4_)
                    {
                        chestSmash(0);
                    }
                    break;
                case pelvisShape:
                    _loc5_ = pelvisBody.GetMass() / DEF_PELVIS_MASS;
                    _loc4_ = Math.max(1 - 0.15 * _loc5_,0.7);
                    trace("new pelvis ratio " + _loc4_);
                    if(param2 > _loc4_)
                    {
                        pelvisSmash(0);
                    }
            }
        }
    }
}

