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
    
    public class IrresponsibleDad extends BicycleGuy
    {
        internal var kid:ChildSeatKid;
        
        internal var helmetOn:Boolean;
        
        internal var helmetSmashLimit:Number = 2;
        
        internal var helmetBody:b2Body;
        
        internal var helmetShape:b2Shape;
        
        internal var helmetMC:MovieClip;
        
        public function IrresponsibleDad(param1:Number, param2:Number, param3:DisplayObject, param4:Session, param5:int = -1, param6:String = "Char3")
        {
            super(param1,param2,param3,param4,param5,param6);
            this.kid = new ChildSeatKid(param1,param2,param3["kid"],param4,-2,"Kid1",this);
        }
        
        override public function set session(param1:Session) : void
        {
            _session = param1;
            if(this.kid)
            {
                this.kid.session = _session;
            }
        }
        
        override public function checkKeyStates() : void
        {
            super.checkKeyStates();
            if(!this.kid.dead)
            {
                if(this.kid.userVehicle)
                {
                    this.kid.userVehicle.operateKeys(_session.iteration,leftPressed,rightPressed,upPressed,downPressed,spacePressed,shiftPressed,ctrlPressed,zPressed);
                }
                else
                {
                    if(leftPressed)
                    {
                        if(rightPressed)
                        {
                            this.kid.leftAndRightActions();
                        }
                        else
                        {
                            this.kid.leftPressedActions();
                        }
                    }
                    else if(rightPressed)
                    {
                        this.kid.rightPressedActions();
                    }
                    else
                    {
                        this.kid.leftAndRightActions();
                    }
                    if(upPressed)
                    {
                        if(downPressed)
                        {
                            this.kid.upAndDownActions();
                        }
                        else
                        {
                            this.kid.upPressedActions();
                        }
                    }
                    else if(downPressed)
                    {
                        this.kid.downPressedActions();
                    }
                    else
                    {
                        this.kid.upAndDownActions();
                    }
                    if(spacePressed)
                    {
                        this.kid.spacePressedActions();
                    }
                    else
                    {
                        this.kid.spaceNullActions();
                    }
                    if(shiftPressed)
                    {
                        this.kid.shiftPressedActions();
                    }
                    else
                    {
                        this.kid.shiftNullActions();
                    }
                    if(ctrlPressed)
                    {
                        this.kid.ctrlPressedActions();
                    }
                    else
                    {
                        this.kid.ctrlNullActions();
                    }
                    if(zPressed)
                    {
                        this.kid.zPressedActions();
                    }
                    else
                    {
                        this.kid.zNullActions();
                    }
                }
            }
        }
        
        override public function checkReplayData(param1:KeyDisplay, param2:String) : void
        {
            super.checkReplayData(param1,param2);
            if(!this.kid.dead)
            {
                if(this.kid.userVehicle)
                {
                    this.kid.userVehicle.operateReplayData(_session.iteration,param2);
                }
                else
                {
                    if(param2.charAt(0) == "1")
                    {
                        if(param2.charAt(1) == "1")
                        {
                            this.kid.leftAndRightActions();
                        }
                        else
                        {
                            this.kid.leftPressedActions();
                        }
                    }
                    else if(param2.charAt(1) == "1")
                    {
                        this.kid.rightPressedActions();
                    }
                    else
                    {
                        this.kid.leftAndRightActions();
                    }
                    if(param2.charAt(2) == "1")
                    {
                        if(param2.charAt(3) == "1")
                        {
                            this.kid.upAndDownActions();
                        }
                        else
                        {
                            this.kid.upPressedActions();
                        }
                    }
                    else if(param2.charAt(3) == "1")
                    {
                        this.kid.downPressedActions();
                    }
                    else
                    {
                        this.kid.upAndDownActions();
                    }
                    if(param2.charAt(4) == "1")
                    {
                        this.kid.spacePressedActions();
                    }
                    else
                    {
                        this.kid.spaceNullActions();
                    }
                    if(param2.charAt(5) == "1")
                    {
                        this.kid.shiftPressedActions();
                    }
                    else
                    {
                        this.kid.shiftNullActions();
                    }
                    if(param2.charAt(6) == "1")
                    {
                        this.kid.ctrlPressedActions();
                    }
                    else
                    {
                        this.kid.ctrlNullActions();
                    }
                    if(param2.charAt(7) == "1")
                    {
                        this.kid.zPressedActions();
                    }
                    else
                    {
                        this.kid.zNullActions();
                    }
                }
            }
        }
        
        override protected function switchCamera() : void
        {
            if(_session.camera.focus == cameraFocus)
            {
                _session.camera.focus = this.kid.cameraFocus;
            }
            else
            {
                _session.camera.focus = cameraFocus;
            }
        }
        
        override internal function shiftPressedActions() : void
        {
            eject();
        }
        
        override public function actions() : void
        {
            super.actions();
            this.kid.actions();
        }
        
        override public function create() : void
        {
            createFilters();
            createBodies();
            createJoints();
            this.createMovieClips();
            setLimits();
            this.createDictionaries();
            this.kid.create();
            dispatchEvent(new Event(Event.COMPLETE));
        }
        
        override public function reset() : void
        {
            super.reset();
            this.helmetOn = true;
            this.kid.reset();
        }
        
        override public function die() : void
        {
            super.die();
            this.helmetBody = null;
            this.kid.die();
        }
        
        override public function paint() : void
        {
            super.paint();
            this.kid.paint();
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
            this.kid.handleContactBuffer();
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
                frameSmash(_loc1_.impulse,_loc1_.normal);
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
            this.kid.checkJoints();
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

