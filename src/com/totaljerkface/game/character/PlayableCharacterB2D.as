package com.totaljerkface.game.character
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.*;
    import com.totaljerkface.game.ContactListener;
    import com.totaljerkface.game.Session;
    import com.totaljerkface.game.Settings;
    import com.totaljerkface.game.events.ContactEvent;
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    
    public class PlayableCharacterB2D extends CharacterB2D
    {
        private const tags:Array = ["Char1","Char2","Char3","Char4","Char8","Char11","Char2","Santa","Char12","Char4","Heli"];
        
        private const polyChestedChars:Array = [4,6,8,11];
        
        private const helmetedChars:Array = [2,3,8,9,10,11];
        
        private const newScaleChars:Array = [8,9,10,11];
        
        private var helmeted:Boolean = false;
        
        internal var helmetSmashLimit:Number = 2;
        
        protected var helmetShape:b2Shape;
        
        protected var helmetBody:b2Body;
        
        protected var helmetMC:MovieClip;
        
        public function PlayableCharacterB2D(param1:Number, param2:Number, param3:DisplayObject, param4:Session, param5:int = -1, param6:String = "Char1")
        {
            param6 = this.tags[Settings.characterIndex - 1];
            if(this.helmetedChars.indexOf(Settings.characterIndex) > -1)
            {
                this.helmeted = true;
            }
            super(param1,param2,param3,param4,param5,param6);
            if(this.newScaleChars.indexOf(Settings.characterIndex) > -1)
            {
                shapeRefScale = 50;
            }
        }
        
        override internal function leftPressedActions() : void
        {
            currentPose = 1;
        }
        
        override internal function rightPressedActions() : void
        {
            currentPose = 2;
        }
        
        override internal function leftAndRightActions() : void
        {
            if(_currentPose == 1 || _currentPose == 2)
            {
                currentPose = 0;
            }
        }
        
        override internal function upPressedActions() : void
        {
            currentPose = 3;
        }
        
        override internal function downPressedActions() : void
        {
            currentPose = 4;
        }
        
        override internal function upAndDownActions() : void
        {
            if(_currentPose == 3 || _currentPose == 4)
            {
                currentPose = 0;
            }
        }
        
        override internal function spacePressedActions() : void
        {
            startGrab();
        }
        
        override internal function spaceNullActions() : void
        {
            releaseGrip();
        }
        
        override internal function createDictionaries() : void
        {
            super.createDictionaries();
            if(this.helmeted)
            {
                this.helmetShape = head1Shape;
                contactImpulseDict[this.helmetShape] = this.helmetSmashLimit;
            }
        }
        
        override internal function createBodies() : void
        {
            var _loc7_:MovieClip = null;
            super.createBodies();
            if(this.polyChestedChars.indexOf(Settings.characterIndex) == -1)
            {
                return;
            }
            var _loc1_:b2PolygonDef = new b2PolygonDef();
            var _loc2_:b2CircleDef = new b2CircleDef();
            var _loc3_:b2BodyDef = new b2BodyDef();
            var _loc4_:b2BodyDef = new b2BodyDef();
            _loc1_.density = 1;
            _loc1_.friction = 0.3;
            _loc1_.restitution = 0.1;
            _loc1_.filter = defaultFilter;
            paintVector.splice(paintVector.indexOf(chestBody),1);
            paintVector.splice(paintVector.indexOf(pelvisBody),1);
            _session.m_world.DestroyBody(chestBody);
            _session.m_world.DestroyBody(pelvisBody);
            var _loc5_:MovieClip = shapeGuide["chestShape"];
            _loc3_.position.Set(_startX + _loc5_.x / character_scale,_startY + _loc5_.y / character_scale);
            _loc3_.angle = _loc5_.rotation / (180 / Math.PI);
            chestBody = _session.m_world.CreateBody(_loc3_);
            _loc1_.vertexCount = 6;
            var _loc6_:int = 0;
            while(_loc6_ < 6)
            {
                _loc7_ = shapeGuide["chestVert" + [_loc6_]];
                _loc1_.vertices[_loc6_] = new b2Vec2(_loc7_.x / character_scale,_loc7_.y / character_scale);
                _loc6_++;
            }
            chestShape = chestBody.CreateShape(_loc1_);
            chestShape.SetMaterial(2);
            chestShape.SetUserData(this);
            _session.contactListener.registerListener(ContactListener.RESULT,chestShape,contactResultHandler);
            _session.contactListener.registerListener(ContactListener.ADD,chestShape,contactAddHandler);
            chestBody.SetMassFromShapes();
            chestBody.AllowSleeping(false);
            paintVector.push(chestBody);
            cameraFocus = chestBody;
            _loc5_ = shapeGuide["pelvisShape"];
            _loc4_.position.Set(_startX + _loc5_.x / character_scale,_startY + _loc5_.y / character_scale);
            _loc4_.angle = _loc5_.rotation / (180 / Math.PI);
            pelvisBody = _session.m_world.CreateBody(_loc4_);
            _loc1_.vertexCount = 5;
            _loc6_ = 0;
            while(_loc6_ < 5)
            {
                _loc7_ = shapeGuide["pelvisVert" + [_loc6_]];
                _loc1_.vertices[_loc6_] = new b2Vec2(_loc7_.x / character_scale,_loc7_.y / character_scale);
                _loc6_++;
            }
            pelvisShape = pelvisBody.CreateShape(_loc1_);
            pelvisShape.SetMaterial(2);
            pelvisShape.SetUserData(this);
            _session.contactListener.registerListener(ContactListener.RESULT,pelvisShape,contactResultHandler);
            _session.contactListener.registerListener(ContactListener.ADD,pelvisShape,contactAddHandler);
            pelvisBody.SetMassFromShapes();
            pelvisBody.AllowSleeping(false);
            paintVector.push(pelvisBody);
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
            super.handleContactResults();
        }
        
        override internal function createMovieClips() : void
        {
            var _loc2_:int = 0;
            super.createMovieClips();
            if(this.helmeted)
            {
                this.helmetMC = sourceObject["helmet"];
                var _loc3_:* = 1 / mc_scale;
                this.helmetMC.scaleY = 1 / mc_scale;
                this.helmetMC.scaleX = _loc3_;
                this.helmetMC.visible = false;
                _session.containerSprite.addChildAt(this.helmetMC,_session.containerSprite.getChildIndex(chestMC));
            }
            var _loc1_:Sprite = _session.containerSprite;
            if(Settings.characterIndex == 8)
            {
                _loc2_ = _loc1_.getChildIndex(chestMC);
                _loc1_.setChildIndex(lowerLeg1MC,--_loc2_);
                _loc1_.setChildIndex(upperLeg1MC,--_loc2_);
                _loc1_.setChildIndex(pelvisMC,--_loc2_);
            }
            else if(Settings.characterIndex == 4 || Settings.characterIndex == 6 || Settings.characterIndex == 11)
            {
                _loc2_ = _loc1_.getChildIndex(pelvisMC);
                _loc1_.setChildIndex(chestMC,++_loc2_);
                _loc2_ = _loc1_.getChildIndex(lowerLeg1MC);
                _loc1_.setChildIndex(upperArm1MC,++_loc2_);
                _loc1_.setChildIndex(lowerArm1MC,++_loc2_);
            }
            else if(Settings.characterIndex == 7)
            {
                _loc2_ = _loc1_.getChildIndex(upperLeg1MC);
                _loc1_.setChildIndex(chestMC,++_loc2_);
                _loc2_ = _loc1_.getChildIndex(lowerLeg1MC);
                _loc1_.setChildIndex(upperArm1MC,++_loc2_);
                _loc1_.setChildIndex(lowerArm1MC,++_loc2_);
            }
        }
        
        internal function helmetSmash(param1:Number) : void
        {
            var _loc6_:MovieClip = null;
            trace("helmet impulse " + param1 + " -> " + _session.iteration);
            delete contactImpulseDict[this.helmetShape];
            head1Shape = this.helmetShape;
            contactImpulseDict[head1Shape] = headSmashLimit;
            this.helmetShape = null;
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
        
        override internal function resetMovieClips() : void
        {
            super.resetMovieClips();
            if(this.helmeted)
            {
                this.helmetMC.visible = false;
                head1MC.helmet.visible = true;
            }
        }
        
        override public function explodeShape(param1:b2Shape, param2:Number) : void
        {
            if(param1 == this.helmetShape)
            {
                if(param2 > 0.85)
                {
                    this.helmetSmash(0);
                }
                return;
            }
            super.explodeShape(param1,param2);
        }
    }
}

