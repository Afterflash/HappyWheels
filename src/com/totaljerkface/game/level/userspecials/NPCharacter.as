package com.totaljerkface.game.level.userspecials
{
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.character.CharacterB2D;
    import com.totaljerkface.game.editor.specials.*;
    import com.totaljerkface.game.editor.specials.npcsprites.*;
    import com.totaljerkface.game.events.*;
    import com.totaljerkface.game.level.*;
    import com.totaljerkface.game.particles.*;
    import com.totaljerkface.game.sound.*;
    import flash.display.*;
    import flash.geom.Point;
    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;
    
    public class NPCharacter extends LevelItem
    {
        public static var GROUP_ID_COUNT:int = -40;
        
        public static const GRIND_STATE:int = 1;
        
        private var mc_scale:Number = 2;
        
        private var character_scale:Number;
        
        private var session:Session;
        
        private var characterLayer:Sprite;
        
        private var headBody:b2Body;
        
        private var chestBody:b2Body;
        
        private var pelvisBody:b2Body;
        
        private var upperArm1Body:b2Body;
        
        private var upperArm2Body:b2Body;
        
        private var lowerArm1Body:b2Body;
        
        private var lowerArm2Body:b2Body;
        
        private var upperLeg1Body:b2Body;
        
        private var upperLeg2Body:b2Body;
        
        private var lowerLeg1Body:b2Body;
        
        private var lowerLeg2Body:b2Body;
        
        private var heartBody:b2Body;
        
        private var headShape:b2Shape;
        
        private var chestShape:b2Shape;
        
        private var pelvisShape:b2Shape;
        
        private var neckJoint:b2RevoluteJoint;
        
        private var waistJoint:b2RevoluteJoint;
        
        private var shoulderJoint1:b2RevoluteJoint;
        
        private var shoulderJoint2:b2RevoluteJoint;
        
        private var elbowJoint1:b2RevoluteJoint;
        
        private var elbowJoint2:b2RevoluteJoint;
        
        private var hipJoint1:b2RevoluteJoint;
        
        private var hipJoint2:b2RevoluteJoint;
        
        private var kneeJoint1:b2RevoluteJoint;
        
        private var kneeJoint2:b2RevoluteJoint;
        
        private var headMC:MovieClip;
        
        private var chestMC:MovieClip;
        
        private var pelvisMC:MovieClip;
        
        private var upperLeg1MC:MovieClip;
        
        private var upperLeg2MC:MovieClip;
        
        private var upperArm1MC:MovieClip;
        
        private var upperArm2MC:MovieClip;
        
        private var lowerArm1MC:MovieClip;
        
        private var lowerArm2MC:MovieClip;
        
        private var lowerLeg1MC:MovieClip;
        
        private var lowerLeg2MC:MovieClip;
        
        private var defaultFilter:b2FilterData;
        
        private var zeroFilter:b2FilterData;
        
        private var lowerBodyFilter:b2FilterData;
        
        private var headSmashLimit:Number;
        
        private var chestSmashLimit:Number;
        
        private var pelvisSmashLimit:Number;
        
        private var footSmashLimit:Number;
        
        private var neckBreakLimit:int;
        
        private var torsoBreakLimit:int;
        
        private var shoulderBreakLimit:int;
        
        private var hipBreakLimit:int;
        
        private var elbowBreakLimit:int;
        
        private var kneeBreakLimit:int;
        
        private var headChunkRadius:Number;
        
        private var chestChunkRadius:Number;
        
        private var pelvisChunkRadius:Number;
        
        private var brainRadius:Number = 12;
        
        private var headBloodFlow:Emitter;
        
        private var neckBloodFlow:Emitter;
        
        private var stomachBloodFlow:Emitter;
        
        private var shoulder1BloodFlow:Emitter;
        
        private var shoulder2BloodFlow:Emitter;
        
        private var arm1BloodFlow:Emitter;
        
        private var arm2BloodFlow:Emitter;
        
        private var hip1BloodFlow:Emitter;
        
        private var hip2BloodFlow:Emitter;
        
        private var thigh1BloodFlow:Emitter;
        
        private var thigh2BloodFlow:Emitter;
        
        private var contactImpulseDict:Dictionary;
        
        private var contactResultBuffer:Dictionary;
        
        private var contactAddBuffer:Dictionary;
        
        private var contactAddSounds:Dictionary;
        
        private var voiceSound:AreaSoundInstance;
        
        private var voicePriority:int = -1;
        
        private var voiceArray:Array;
        
        private var tag:String;
        
        private var paintVector:Vector.<b2Body>;
        
        private var _dead:Boolean;
        
        private var reversed:Boolean;
        
        private var destroyJointsUponDeath:Boolean = false;
        
        private var charSprite:NPCSprite;
        
        private var userJoints:Array;
        
        public function NPCharacter(param1:Special, param2:b2Body = null, param3:Point = null)
        {
            var _loc4_:NPCharacterRef = null;
            super();
            _loc4_ = param1 as NPCharacterRef;
            _loc4_ = _loc4_.clone() as NPCharacterRef;
            this.destroyJointsUponDeath = _loc4_.destroyJointsUponDeath;
            this.tag = _loc4_.tag;
            this.character_scale = m_physScale * this.mc_scale;
            this.paintVector = new Vector.<b2Body>();
            this.voiceArray = new Array();
            this.session = Settings.currentSession;
            this.characterLayer = this.session.level.characterLayer;
            this.reversed = _loc4_.reverse;
            if(!_loc4_.interactive)
            {
                this.charSprite = _loc4_.npcSprite;
                this.charSprite.x = _loc4_.x;
                this.charSprite.y = _loc4_.y;
                this.charSprite.rotation = _loc4_.rotation;
                this.characterLayer.addChild(this.charSprite);
            }
            else
            {
                this.createFilters();
                this.createBodies(_loc4_);
                this.createJoints(_loc4_);
                this.createMovieClips(_loc4_);
                this.setBreakLimits();
                this.createDictionaries();
                Settings.currentSession.level.paintItemVector.push(this);
                Settings.currentSession.level.actionsVector.push(this);
            }
        }
        
        public function addUserJoint(param1:b2Joint) : void
        {
            if(!this.userJoints)
            {
                this.userJoints = new Array();
            }
            this.userJoints.push(param1);
        }
        
        override public function actions() : void
        {
            this.handleContactResults();
            this.handleContactAdds();
            this.checkJoints();
            if(!this._dead)
            {
                this.checkVocals();
                this.voiceArray = new Array();
            }
        }
        
        private function createFilters() : void
        {
            this.defaultFilter = new b2FilterData();
            this.defaultFilter.groupIndex = GROUP_ID_COUNT;
            this.defaultFilter.categoryBits = 260;
            this.zeroFilter = new b2FilterData();
            this.zeroFilter.groupIndex = 0;
            this.zeroFilter.categoryBits = 260;
            this.lowerBodyFilter = new b2FilterData();
            this.lowerBodyFilter.categoryBits = 260;
            this.lowerBodyFilter.groupIndex = GROUP_ID_COUNT - 1;
            GROUP_ID_COUNT -= 2;
        }
        
        private function createDictionaries() : void
        {
            this.contactResultBuffer = new Dictionary();
            this.contactAddBuffer = new Dictionary();
            this.contactAddSounds = new Dictionary();
            this.contactImpulseDict = new Dictionary();
            this.contactImpulseDict[this.headShape] = this.headSmashLimit;
            this.contactImpulseDict[this.chestShape] = this.chestSmashLimit;
            this.contactImpulseDict[this.pelvisShape] = this.pelvisSmashLimit;
            this.contactAddSounds[this.headShape] = "Thud1";
            this.contactAddSounds[this.chestShape] = "Thud2";
            this.contactAddSounds[this.pelvisShape] = "Thud2";
        }
        
        private function setBreakLimits() : void
        {
            var _loc1_:Number = this.headBody.GetMass() / CharacterB2D.DEF_HEAD_MASS;
            var _loc2_:Number = this.chestBody.GetMass() / CharacterB2D.DEF_CHEST_MASS;
            var _loc3_:Number = this.pelvisBody.GetMass() / CharacterB2D.DEF_PELVIS_MASS;
            var _loc4_:Number = this.upperArm1Body.GetMass() / CharacterB2D.DEF_UPPERARM_MASS;
            var _loc5_:Number = this.lowerArm1Body.GetMass() / CharacterB2D.DEF_LOWERARM_MASS;
            var _loc6_:Number = this.upperLeg1Body.GetMass() / CharacterB2D.DEF_UPPERLEG_MASS;
            var _loc7_:Number = this.lowerLeg1Body.GetMass() / CharacterB2D.DEF_LOWERLEG_MASS;
            this.headSmashLimit = CharacterB2D.DEF_HEAD_SMASH * _loc1_;
            this.chestSmashLimit = CharacterB2D.DEF_CHEST_SMASH * _loc2_;
            this.pelvisSmashLimit = CharacterB2D.DEF_PELVIS_SMASH * _loc3_;
            this.footSmashLimit = CharacterB2D.DEF_FOOT_SMASH * _loc7_;
            this.neckBreakLimit = Math.pow(Math.round(85 * _loc1_),2);
            this.torsoBreakLimit = Math.pow(Math.round(180 * _loc3_),2);
            this.shoulderBreakLimit = Math.pow(Math.round(75 * _loc4_),2);
            this.hipBreakLimit = Math.pow(Math.round(95 * _loc6_),2);
            this.elbowBreakLimit = Math.pow(Math.round(70 * _loc5_),2);
            this.kneeBreakLimit = Math.pow(Math.round(80 * _loc7_),2);
        }
        
        private function createBodies(param1:NPCharacterRef) : void
        {
            var _loc2_:b2World = this.session.m_world;
            var _loc3_:b2BodyDef = new b2BodyDef();
            var _loc4_:b2PolygonDef = new b2PolygonDef();
            var _loc5_:b2CircleDef = new b2CircleDef();
            _loc4_.density = 1;
            _loc4_.friction = 0.3;
            _loc4_.restitution = 0.1;
            _loc4_.filter = this.defaultFilter;
            _loc5_.density = 1;
            _loc5_.friction = 0.3;
            _loc5_.restitution = 0.1;
            _loc5_.filter = this.defaultFilter;
            var _loc6_:Number = param1.x / m_physScale;
            var _loc7_:Number = param1.y / m_physScale;
            var _loc8_:NPCSprite = param1.npcSprite;
            var _loc9_:Number = this.reversed ? -1 : 1;
            _loc3_.isSleeping = param1.sleeping;
            _loc3_.position.Set(param1.x / m_physScale,param1.y / m_physScale);
            _loc3_.angle = param1.rotation / oneEightyOverPI;
            _loc4_.SetAsBox(_loc8_.chestShape.scaleX * 50 / this.character_scale,_loc8_.chestShape.scaleY * 50 / this.character_scale);
            this.chestBody = _loc2_.CreateBody(_loc3_);
            this.chestShape = this.chestBody.CreateShape(_loc4_);
            this.chestShape.SetMaterial(2);
            this.chestShape.SetUserData(this);
            this.session.contactListener.registerListener(ContactListener.RESULT,this.chestShape,this.contactResultHandler);
            this.session.contactListener.registerListener(ContactListener.ADD,this.chestShape,this.contactAddHandler);
            this.chestBody.SetMassFromShapes();
            this.paintVector.push(this.chestBody);
            var _loc10_:Point = new Point(_loc8_.head.x,_loc8_.head.y);
            _loc10_ = _loc8_.headOuter.transform.matrix.transformPoint(_loc10_);
            _loc10_ = _loc8_.transform.matrix.transformPoint(_loc10_);
            _loc10_ = param1.transform.matrix.transformPoint(_loc10_);
            _loc3_.position.Set(_loc10_.x / m_physScale,_loc10_.y / m_physScale);
            _loc3_.angle = (param1.rotation + _loc9_ * _loc8_.headOuter.rotation) / oneEightyOverPI;
            _loc5_.radius = _loc8_.headShape.scaleX * 50 / this.character_scale;
            this.headBody = _loc2_.CreateBody(_loc3_);
            this.headShape = this.headBody.CreateShape(_loc5_);
            this.headShape.SetMaterial(2);
            this.headShape.SetUserData(this);
            this.session.contactListener.registerListener(ContactListener.RESULT,this.headShape,this.contactResultHandler);
            this.session.contactListener.registerListener(ContactListener.ADD,this.headShape,this.contactAddHandler);
            this.headBody.SetMassFromShapes();
            this.paintVector.push(this.headBody);
            _loc10_ = new Point(_loc8_.pelvis.x,_loc8_.pelvis.y);
            _loc10_ = _loc8_.transform.matrix.transformPoint(_loc10_);
            _loc10_ = param1.transform.matrix.transformPoint(_loc10_);
            _loc3_.position.Set(_loc10_.x / m_physScale,_loc10_.y / m_physScale);
            _loc3_.angle = (param1.rotation + _loc9_ * _loc8_.pelvis.rotation) / oneEightyOverPI;
            _loc4_.SetAsBox(_loc8_.pelvisShape.scaleX * 50 / this.character_scale,_loc8_.pelvisShape.scaleY * 50 / this.character_scale);
            this.pelvisBody = _loc2_.CreateBody(_loc3_);
            this.pelvisShape = this.pelvisBody.CreateShape(_loc4_);
            this.pelvisShape.SetMaterial(2);
            this.pelvisShape.SetUserData(this);
            this.session.contactListener.registerListener(ContactListener.RESULT,this.pelvisShape,this.contactResultHandler);
            this.session.contactListener.registerListener(ContactListener.ADD,this.pelvisShape,this.contactAddHandler);
            this.pelvisBody.SetMassFromShapes();
            this.paintVector.push(this.pelvisBody);
            _loc10_ = new Point(_loc8_.upperArm1.x,_loc8_.upperArm1.y);
            _loc10_ = _loc8_.arm1.transform.matrix.transformPoint(_loc10_);
            _loc10_ = _loc8_.transform.matrix.transformPoint(_loc10_);
            _loc10_ = param1.transform.matrix.transformPoint(_loc10_);
            _loc3_.position.Set(_loc10_.x / m_physScale,_loc10_.y / m_physScale);
            _loc3_.angle = (param1.rotation + _loc9_ * _loc8_.arm1.rotation) / oneEightyOverPI;
            _loc4_.SetAsBox(_loc8_.upperArm1Shape.scaleX * 50 / this.character_scale,_loc8_.upperArm1Shape.scaleY * 50 / this.character_scale);
            this.upperArm1Body = _loc2_.CreateBody(_loc3_);
            var _loc11_:b2Shape = this.upperArm1Body.CreateShape(_loc4_);
            _loc11_.SetMaterial(1);
            _loc11_.SetUserData(this);
            this.upperArm1Body.SetMassFromShapes();
            this.paintVector.push(this.upperArm1Body);
            _loc10_ = new Point(_loc8_.upperArm2.x,_loc8_.upperArm2.y);
            _loc10_ = _loc8_.arm2.transform.matrix.transformPoint(_loc10_);
            _loc10_ = _loc8_.transform.matrix.transformPoint(_loc10_);
            _loc10_ = param1.transform.matrix.transformPoint(_loc10_);
            _loc3_.position.Set(_loc10_.x / m_physScale,_loc10_.y / m_physScale);
            _loc3_.angle = (param1.rotation + _loc9_ * _loc8_.arm2.rotation) / oneEightyOverPI;
            _loc4_.SetAsBox(_loc8_.upperArm2Shape.scaleX * 50 / this.character_scale,_loc8_.upperArm2Shape.scaleY * 50 / this.character_scale);
            this.upperArm2Body = _loc2_.CreateBody(_loc3_);
            _loc11_ = this.upperArm2Body.CreateShape(_loc4_);
            _loc11_.SetMaterial(1);
            _loc11_.SetUserData(this);
            this.upperArm2Body.SetMassFromShapes();
            this.paintVector.push(this.upperArm2Body);
            _loc10_ = new Point(_loc8_.lowerArm1.x,_loc8_.lowerArm1.y);
            _loc10_ = _loc8_.lowerArmOuter1.transform.matrix.transformPoint(_loc10_);
            _loc10_ = _loc8_.arm1.transform.matrix.transformPoint(_loc10_);
            _loc10_ = _loc8_.transform.matrix.transformPoint(_loc10_);
            _loc10_ = param1.transform.matrix.transformPoint(_loc10_);
            _loc3_.position.Set(_loc10_.x / m_physScale,_loc10_.y / m_physScale);
            _loc3_.angle = (param1.rotation + _loc9_ * (_loc8_.arm1.rotation + _loc8_.lowerArmOuter1.rotation)) / oneEightyOverPI;
            _loc4_.SetAsBox(_loc8_.lowerArm1Shape.scaleX * 50 / this.character_scale,_loc8_.lowerArm1Shape.scaleY * 50 / this.character_scale);
            this.lowerArm1Body = _loc2_.CreateBody(_loc3_);
            _loc11_ = this.lowerArm1Body.CreateShape(_loc4_);
            _loc11_.SetMaterial(1);
            _loc11_.SetUserData(this);
            this.lowerArm1Body.SetMassFromShapes();
            this.paintVector.push(this.lowerArm1Body);
            _loc10_ = new Point(_loc8_.lowerArm2.x,_loc8_.lowerArm2.y);
            _loc10_ = _loc8_.lowerArmOuter2.transform.matrix.transformPoint(_loc10_);
            _loc10_ = _loc8_.arm2.transform.matrix.transformPoint(_loc10_);
            _loc10_ = _loc8_.transform.matrix.transformPoint(_loc10_);
            _loc10_ = param1.transform.matrix.transformPoint(_loc10_);
            _loc3_.position.Set(_loc10_.x / m_physScale,_loc10_.y / m_physScale);
            _loc3_.angle = (param1.rotation + _loc9_ * (_loc8_.arm2.rotation + _loc8_.lowerArmOuter2.rotation)) / oneEightyOverPI;
            _loc4_.SetAsBox(_loc8_.lowerArm2Shape.scaleX * 50 / this.character_scale,_loc8_.lowerArm2Shape.scaleY * 50 / this.character_scale);
            this.lowerArm2Body = _loc2_.CreateBody(_loc3_);
            _loc11_ = this.lowerArm2Body.CreateShape(_loc4_);
            _loc11_.SetMaterial(1);
            _loc11_.SetUserData(this);
            this.lowerArm2Body.SetMassFromShapes();
            this.paintVector.push(this.lowerArm2Body);
            _loc10_ = new Point(_loc8_.upperLeg1.x,_loc8_.upperLeg1.y);
            _loc10_ = _loc8_.leg1.transform.matrix.transformPoint(_loc10_);
            _loc10_ = _loc8_.transform.matrix.transformPoint(_loc10_);
            _loc10_ = param1.transform.matrix.transformPoint(_loc10_);
            _loc3_.position.Set(_loc10_.x / m_physScale,_loc10_.y / m_physScale);
            _loc3_.angle = (param1.rotation + _loc9_ * _loc8_.leg1.rotation) / oneEightyOverPI;
            _loc4_.SetAsBox(_loc8_.upperLeg1Shape.scaleX * 50 / this.character_scale,_loc8_.upperLeg1Shape.scaleY * 50 / this.character_scale);
            this.upperLeg1Body = _loc2_.CreateBody(_loc3_);
            _loc11_ = this.upperLeg1Body.CreateShape(_loc4_);
            _loc11_.SetMaterial(1);
            _loc11_.SetUserData(this);
            this.upperLeg1Body.SetMassFromShapes();
            this.paintVector.push(this.upperLeg1Body);
            _loc10_ = new Point(_loc8_.upperLeg2.x,_loc8_.upperLeg2.y);
            _loc10_ = _loc8_.leg2.transform.matrix.transformPoint(_loc10_);
            _loc10_ = _loc8_.transform.matrix.transformPoint(_loc10_);
            _loc10_ = param1.transform.matrix.transformPoint(_loc10_);
            _loc3_.position.Set(_loc10_.x / m_physScale,_loc10_.y / m_physScale);
            _loc3_.angle = (param1.rotation + _loc9_ * _loc8_.leg2.rotation) / oneEightyOverPI;
            _loc4_.SetAsBox(_loc8_.upperLeg2Shape.scaleX * 50 / this.character_scale,_loc8_.upperLeg2Shape.scaleY * 50 / this.character_scale);
            this.upperLeg2Body = _loc2_.CreateBody(_loc3_);
            _loc11_ = this.upperLeg2Body.CreateShape(_loc4_);
            _loc11_.SetMaterial(1);
            _loc11_.SetUserData(this);
            this.upperLeg2Body.SetMassFromShapes();
            this.paintVector.push(this.upperLeg2Body);
            _loc10_ = new Point(_loc8_.lowerLeg1.x,_loc8_.lowerLeg1.y);
            _loc10_ = _loc8_.lowerLegOuter1.transform.matrix.transformPoint(_loc10_);
            _loc10_ = _loc8_.leg1.transform.matrix.transformPoint(_loc10_);
            _loc10_ = _loc8_.transform.matrix.transformPoint(_loc10_);
            _loc10_ = param1.transform.matrix.transformPoint(_loc10_);
            _loc3_.position.Set(_loc10_.x / m_physScale,_loc10_.y / m_physScale);
            _loc3_.angle = (param1.rotation + _loc9_ * (_loc8_.leg1.rotation + _loc8_.lowerLegOuter1.rotation)) / oneEightyOverPI;
            _loc4_.SetAsBox(_loc8_.lowerLeg1Shape.scaleX * 50 / this.character_scale,_loc8_.lowerLeg1Shape.scaleY * 50 / this.character_scale);
            this.lowerLeg1Body = _loc2_.CreateBody(_loc3_);
            _loc11_ = this.lowerLeg1Body.CreateShape(_loc4_);
            _loc11_.SetMaterial(1);
            _loc11_.SetUserData(this);
            this.lowerLeg1Body.SetMassFromShapes();
            this.paintVector.push(this.lowerLeg1Body);
            _loc10_ = new Point(_loc8_.lowerLeg2.x,_loc8_.lowerLeg2.y);
            _loc10_ = _loc8_.lowerLegOuter2.transform.matrix.transformPoint(_loc10_);
            _loc10_ = _loc8_.leg2.transform.matrix.transformPoint(_loc10_);
            _loc10_ = _loc8_.transform.matrix.transformPoint(_loc10_);
            _loc10_ = param1.transform.matrix.transformPoint(_loc10_);
            _loc3_.position.Set(_loc10_.x / m_physScale,_loc10_.y / m_physScale);
            _loc3_.angle = (param1.rotation + _loc9_ * (_loc8_.leg2.rotation + _loc8_.lowerLegOuter2.rotation)) / oneEightyOverPI;
            _loc4_.SetAsBox(_loc8_.lowerLeg2Shape.scaleX * 50 / this.character_scale,_loc8_.lowerLeg2Shape.scaleY * 50 / this.character_scale);
            this.lowerLeg2Body = _loc2_.CreateBody(_loc3_);
            _loc11_ = this.lowerLeg2Body.CreateShape(_loc4_);
            _loc11_.SetMaterial(1);
            _loc11_.SetUserData(this);
            this.lowerLeg2Body.SetMassFromShapes();
            this.paintVector.push(this.lowerLeg2Body);
            this.headChunkRadius = Math.round(_loc8_.headShape.scaleX * 50 * 0.5);
            this.pelvisChunkRadius = Math.round(_loc8_.headShape.scaleX * 50 * 0.75);
            this.chestChunkRadius = Math.round(_loc8_.headShape.scaleX * 50 * 0.95);
            this.brainRadius = 12;
        }
        
        private function createJoints(param1:NPCharacterRef) : void
        {
            var _loc4_:Number = NaN;
            var _loc2_:b2World = this.session.m_world;
            var _loc3_:b2RevoluteJointDef = new b2RevoluteJointDef();
            _loc3_.enableLimit = true;
            _loc3_.maxMotorTorque = 4;
            if(param1.holdPose && this.session.levelVersion < 1.75)
            {
                _loc3_.enableMotor = true;
                _loc3_.motorSpeed = 0;
            }
            var _loc5_:b2Vec2 = new b2Vec2();
            var _loc6_:NPCSprite = param1.npcSprite;
            var _loc7_:Number = this.reversed ? -1 : 1;
            var _loc8_:Point = new Point(_loc6_.headOuter.x,_loc6_.headOuter.y);
            _loc8_ = _loc6_.transform.matrix.transformPoint(_loc8_);
            _loc8_ = param1.transform.matrix.transformPoint(_loc8_);
            _loc5_.Set(_loc8_.x / m_physScale,_loc8_.y / m_physScale);
            _loc4_ = this.headBody.GetAngle() - this.chestBody.GetAngle();
            _loc3_.lowerAngle = -20 / oneEightyOverPI - _loc4_;
            _loc3_.upperAngle = 20 / oneEightyOverPI - _loc4_;
            _loc3_.Initialize(this.chestBody,this.headBody,_loc5_);
            this.neckJoint = _loc2_.CreateJoint(_loc3_) as b2RevoluteJoint;
            _loc8_ = new Point(_loc6_.pelvis.x,_loc6_.pelvis.y);
            _loc8_.y -= _loc6_.pelvis.height * 0.5;
            _loc8_ = _loc6_.transform.matrix.transformPoint(_loc8_);
            _loc8_ = param1.transform.matrix.transformPoint(_loc8_);
            _loc5_.Set(_loc8_.x / m_physScale,_loc8_.y / m_physScale);
            _loc4_ = this.pelvisBody.GetAngle() - this.chestBody.GetAngle();
            _loc3_.lowerAngle = -5 / oneEightyOverPI - _loc4_;
            _loc3_.upperAngle = 5 / oneEightyOverPI - _loc4_;
            _loc3_.Initialize(this.chestBody,this.pelvisBody,_loc5_);
            this.waistJoint = _loc2_.CreateJoint(_loc3_) as b2RevoluteJoint;
            _loc8_ = new Point(_loc6_.arm1.x,_loc6_.arm1.y);
            _loc8_ = _loc6_.transform.matrix.transformPoint(_loc8_);
            _loc8_ = param1.transform.matrix.transformPoint(_loc8_);
            _loc5_.Set(_loc8_.x / m_physScale,_loc8_.y / m_physScale);
            _loc4_ = this.upperArm1Body.GetAngle() - this.chestBody.GetAngle();
            if(this.reversed)
            {
                _loc3_.lowerAngle = -60 / oneEightyOverPI - _loc4_;
                _loc3_.upperAngle = 180 / oneEightyOverPI - _loc4_;
            }
            else
            {
                _loc3_.lowerAngle = -180 / oneEightyOverPI - _loc4_;
                _loc3_.upperAngle = 60 / oneEightyOverPI - _loc4_;
            }
            _loc3_.Initialize(this.chestBody,this.upperArm1Body,_loc5_);
            this.shoulderJoint1 = _loc2_.CreateJoint(_loc3_) as b2RevoluteJoint;
            _loc8_ = new Point(_loc6_.arm2.x,_loc6_.arm2.y);
            _loc8_ = _loc6_.transform.matrix.transformPoint(_loc8_);
            _loc8_ = param1.transform.matrix.transformPoint(_loc8_);
            _loc5_.Set(_loc8_.x / m_physScale,_loc8_.y / m_physScale);
            _loc4_ = this.upperArm2Body.GetAngle() - this.chestBody.GetAngle();
            if(this.reversed)
            {
                _loc3_.lowerAngle = -60 / oneEightyOverPI - _loc4_;
                _loc3_.upperAngle = 180 / oneEightyOverPI - _loc4_;
            }
            else
            {
                _loc3_.lowerAngle = -180 / oneEightyOverPI - _loc4_;
                _loc3_.upperAngle = 60 / oneEightyOverPI - _loc4_;
            }
            _loc3_.Initialize(this.chestBody,this.upperArm2Body,_loc5_);
            this.shoulderJoint2 = _loc2_.CreateJoint(_loc3_) as b2RevoluteJoint;
            _loc8_ = new Point(_loc6_.lowerArmOuter1.x,_loc6_.lowerArmOuter1.y);
            _loc8_ = _loc6_.arm1.transform.matrix.transformPoint(_loc8_);
            _loc8_ = _loc6_.transform.matrix.transformPoint(_loc8_);
            _loc8_ = param1.transform.matrix.transformPoint(_loc8_);
            _loc5_.Set(_loc8_.x / m_physScale,_loc8_.y / m_physScale);
            _loc4_ = this.lowerArm1Body.GetAngle() - this.upperArm1Body.GetAngle();
            if(this.reversed)
            {
                _loc3_.lowerAngle = 0 / oneEightyOverPI - _loc4_;
                _loc3_.upperAngle = 160 / oneEightyOverPI - _loc4_;
            }
            else
            {
                _loc3_.lowerAngle = -160 / oneEightyOverPI - _loc4_;
                _loc3_.upperAngle = 0 / oneEightyOverPI - _loc4_;
            }
            _loc3_.Initialize(this.upperArm1Body,this.lowerArm1Body,_loc5_);
            this.elbowJoint1 = _loc2_.CreateJoint(_loc3_) as b2RevoluteJoint;
            _loc8_ = new Point(_loc6_.lowerArmOuter2.x,_loc6_.lowerArmOuter2.y);
            _loc8_ = _loc6_.arm2.transform.matrix.transformPoint(_loc8_);
            _loc8_ = _loc6_.transform.matrix.transformPoint(_loc8_);
            _loc8_ = param1.transform.matrix.transformPoint(_loc8_);
            _loc5_.Set(_loc8_.x / m_physScale,_loc8_.y / m_physScale);
            _loc4_ = this.lowerArm2Body.GetAngle() - this.upperArm2Body.GetAngle();
            if(this.reversed)
            {
                _loc3_.lowerAngle = 0 / oneEightyOverPI - _loc4_;
                _loc3_.upperAngle = 160 / oneEightyOverPI - _loc4_;
            }
            else
            {
                _loc3_.lowerAngle = -160 / oneEightyOverPI - _loc4_;
                _loc3_.upperAngle = 0 / oneEightyOverPI - _loc4_;
            }
            _loc3_.Initialize(this.upperArm2Body,this.lowerArm2Body,_loc5_);
            this.elbowJoint2 = _loc2_.CreateJoint(_loc3_) as b2RevoluteJoint;
            _loc8_ = new Point(_loc6_.leg1.x,_loc6_.leg1.y);
            _loc8_ = _loc6_.transform.matrix.transformPoint(_loc8_);
            _loc8_ = param1.transform.matrix.transformPoint(_loc8_);
            _loc5_.Set(_loc8_.x / m_physScale,_loc8_.y / m_physScale);
            _loc4_ = this.upperLeg1Body.GetAngle() - this.pelvisBody.GetAngle();
            if(this.reversed)
            {
                _loc3_.lowerAngle = -10 / oneEightyOverPI - _loc4_;
                _loc3_.upperAngle = 150 / oneEightyOverPI - _loc4_;
            }
            else
            {
                _loc3_.lowerAngle = -150 / oneEightyOverPI - _loc4_;
                _loc3_.upperAngle = 10 / oneEightyOverPI - _loc4_;
            }
            _loc3_.Initialize(this.pelvisBody,this.upperLeg1Body,_loc5_);
            this.hipJoint1 = _loc2_.CreateJoint(_loc3_) as b2RevoluteJoint;
            _loc8_ = new Point(_loc6_.leg2.x,_loc6_.leg2.y);
            _loc8_ = _loc6_.transform.matrix.transformPoint(_loc8_);
            _loc8_ = param1.transform.matrix.transformPoint(_loc8_);
            _loc5_.Set(_loc8_.x / m_physScale,_loc8_.y / m_physScale);
            _loc4_ = this.upperLeg2Body.GetAngle() - this.pelvisBody.GetAngle();
            if(this.reversed)
            {
                _loc3_.lowerAngle = -10 / oneEightyOverPI - _loc4_;
                _loc3_.upperAngle = 150 / oneEightyOverPI - _loc4_;
            }
            else
            {
                _loc3_.lowerAngle = -150 / oneEightyOverPI - _loc4_;
                _loc3_.upperAngle = 10 / oneEightyOverPI - _loc4_;
            }
            _loc3_.Initialize(this.pelvisBody,this.upperLeg2Body,_loc5_);
            this.hipJoint2 = _loc2_.CreateJoint(_loc3_) as b2RevoluteJoint;
            _loc8_ = new Point(_loc6_.lowerLegOuter1.x,_loc6_.lowerLegOuter1.y);
            _loc8_ = _loc6_.leg1.transform.matrix.transformPoint(_loc8_);
            _loc8_ = _loc6_.transform.matrix.transformPoint(_loc8_);
            _loc8_ = param1.transform.matrix.transformPoint(_loc8_);
            _loc5_.Set(_loc8_.x / m_physScale,_loc8_.y / m_physScale);
            _loc4_ = this.lowerLeg1Body.GetAngle() - this.upperLeg1Body.GetAngle();
            if(this.reversed)
            {
                _loc3_.lowerAngle = -150 / oneEightyOverPI - _loc4_;
                _loc3_.upperAngle = 0 / oneEightyOverPI - _loc4_;
            }
            else
            {
                _loc3_.lowerAngle = 0 / oneEightyOverPI - _loc4_;
                _loc3_.upperAngle = 150 / oneEightyOverPI - _loc4_;
            }
            _loc3_.Initialize(this.upperLeg1Body,this.lowerLeg1Body,_loc5_);
            this.kneeJoint1 = _loc2_.CreateJoint(_loc3_) as b2RevoluteJoint;
            _loc8_ = new Point(_loc6_.lowerLegOuter2.x,_loc6_.lowerLegOuter2.y);
            _loc8_ = _loc6_.leg2.transform.matrix.transformPoint(_loc8_);
            _loc8_ = _loc6_.transform.matrix.transformPoint(_loc8_);
            _loc8_ = param1.transform.matrix.transformPoint(_loc8_);
            _loc5_.Set(_loc8_.x / m_physScale,_loc8_.y / m_physScale);
            _loc4_ = this.lowerLeg2Body.GetAngle() - this.upperLeg2Body.GetAngle();
            if(this.reversed)
            {
                _loc3_.lowerAngle = -150 / oneEightyOverPI - _loc4_;
                _loc3_.upperAngle = 0 / oneEightyOverPI - _loc4_;
            }
            else
            {
                _loc3_.lowerAngle = 0 / oneEightyOverPI - _loc4_;
                _loc3_.upperAngle = 150 / oneEightyOverPI - _loc4_;
            }
            _loc3_.Initialize(this.upperLeg2Body,this.lowerLeg2Body,_loc5_);
            this.kneeJoint2 = _loc2_.CreateJoint(_loc3_) as b2RevoluteJoint;
            if(param1.holdPose && this.session.levelVersion >= 1.75)
            {
                this.lockPose();
            }
        }
        
        private function createMovieClips(param1:NPCharacterRef) : void
        {
            var _loc4_:DisplayObject = null;
            var _loc2_:Class = getDefinitionByName("com.totaljerkface.game.editor.specials.npcsprites.NPCSprite" + param1.charIndex) as Class;
            var _loc3_:NPCSprite = new _loc2_();
            _loc3_.removeShapes();
            this.headMC = _loc3_.head as MovieClip;
            this.chestMC = _loc3_.chest as MovieClip;
            this.pelvisMC = _loc3_.pelvis as MovieClip;
            this.upperArm1MC = _loc3_.upperArm1 as MovieClip;
            this.upperArm2MC = _loc3_.upperArm2 as MovieClip;
            this.lowerArm1MC = _loc3_.lowerArm1 as MovieClip;
            this.lowerArm2MC = _loc3_.lowerArm2 as MovieClip;
            this.upperLeg1MC = _loc3_.upperLeg1 as MovieClip;
            this.upperLeg2MC = _loc3_.upperLeg2 as MovieClip;
            this.lowerLeg1MC = _loc3_.lowerLeg1 as MovieClip;
            this.lowerLeg2MC = _loc3_.lowerLeg2 as MovieClip;
            this.headMC.scaleX = this.headMC.scaleY = 0.5;
            this.chestMC.scaleX = this.chestMC.scaleY = 0.5;
            this.pelvisMC.scaleX = this.pelvisMC.scaleY = 0.5;
            this.upperArm1MC.scaleX = this.upperArm1MC.scaleY = 0.5;
            this.upperArm2MC.scaleX = this.upperArm2MC.scaleY = 0.5;
            this.lowerArm1MC.scaleX = this.lowerArm1MC.scaleY = 0.5;
            this.lowerArm2MC.scaleX = this.lowerArm2MC.scaleY = 0.5;
            this.upperLeg1MC.scaleX = this.upperLeg1MC.scaleY = 0.5;
            this.upperLeg2MC.scaleX = this.upperLeg2MC.scaleY = 0.5;
            this.lowerLeg1MC.scaleX = this.lowerLeg1MC.scaleY = 0.5;
            this.lowerLeg2MC.scaleX = this.lowerLeg2MC.scaleY = 0.5;
            if(this.reversed)
            {
                this.headMC.scaleX = -0.5;
                this.chestMC.scaleX = -0.5;
                this.pelvisMC.scaleX = -0.5;
                this.upperArm1MC.scaleX = -0.5;
                this.upperArm2MC.scaleX = -0.5;
                this.lowerArm1MC.scaleX = -0.5;
                this.lowerArm2MC.scaleX = -0.5;
                this.upperLeg1MC.scaleX = -0.5;
                this.upperLeg2MC.scaleX = -0.5;
                this.lowerLeg1MC.scaleX = -0.5;
                this.lowerLeg2MC.scaleX = -0.5;
            }
            while(_loc3_.numChildren > 0)
            {
                _loc4_ = _loc3_.getChildAt(0);
                switch(_loc4_)
                {
                    case _loc3_.arm2:
                        this.characterLayer.addChild(this.upperArm2MC);
                        this.characterLayer.addChild(this.lowerArm2MC);
                        _loc3_.removeChild(_loc3_.arm2);
                        break;
                    case _loc3_.arm1:
                        this.characterLayer.addChild(this.upperArm1MC);
                        this.characterLayer.addChild(this.lowerArm1MC);
                        _loc3_.removeChild(_loc3_.arm1);
                        break;
                    case _loc3_.headOuter:
                        this.characterLayer.addChild(this.headMC);
                        _loc3_.removeChild(_loc3_.headOuter);
                        break;
                    case _loc3_.chest:
                        this.characterLayer.addChild(this.chestMC);
                        break;
                    case _loc3_.pelvis:
                        this.characterLayer.addChild(this.pelvisMC);
                        break;
                    case _loc3_.leg2:
                        this.characterLayer.addChild(this.upperLeg2MC);
                        this.characterLayer.addChild(this.lowerLeg2MC);
                        _loc3_.removeChild(_loc3_.leg2);
                        break;
                    case _loc3_.leg1:
                        this.characterLayer.addChild(this.upperLeg1MC);
                        this.characterLayer.addChild(this.lowerLeg1MC);
                        _loc3_.removeChild(_loc3_.leg1);
                        break;
                }
            }
            this.headBody.SetUserData(this.headMC);
            this.chestBody.SetUserData(this.chestMC);
            this.pelvisBody.SetUserData(this.pelvisMC);
            this.upperArm1Body.SetUserData(this.upperArm1MC);
            this.upperArm2Body.SetUserData(this.upperArm2MC);
            this.lowerArm1Body.SetUserData(this.lowerArm1MC);
            this.lowerArm2Body.SetUserData(this.lowerArm2MC);
            this.upperLeg1Body.SetUserData(this.upperLeg1MC);
            this.upperLeg2Body.SetUserData(this.upperLeg2MC);
            this.lowerLeg1Body.SetUserData(this.lowerLeg1MC);
            this.lowerLeg2Body.SetUserData(this.lowerLeg2MC);
        }
        
        override public function getJointBody(param1:b2Vec2 = null) : b2Body
        {
            var _loc3_:b2Body = null;
            var _loc6_:b2Body = null;
            var _loc7_:b2Vec2 = null;
            var _loc8_:b2Vec2 = null;
            var _loc9_:* = undefined;
            var _loc10_:int = 0;
            var _loc11_:b2JointEdge = null;
            var _loc2_:Number = 10000000;
            var _loc4_:int = int(this.paintVector.length);
            var _loc5_:int = 0;
            while(_loc5_ < _loc4_)
            {
                _loc6_ = this.paintVector[_loc5_];
                _loc7_ = _loc6_.GetWorldCenter();
                _loc8_ = new b2Vec2(param1.x - _loc7_.x,param1.y - _loc7_.y);
                _loc9_ = _loc8_.x * _loc8_.x + _loc8_.y * _loc8_.y;
                if(_loc9_ < _loc2_)
                {
                    _loc10_ = 0;
                    _loc11_ = _loc6_.m_jointList;
                    while(_loc11_)
                    {
                        _loc10_ += 1;
                        _loc11_ = _loc11_.next;
                    }
                    if(!((_loc6_ == this.lowerArm1Body || _loc6_ == this.lowerArm2Body || _loc6_ == this.lowerLeg1Body || _loc6_ == this.lowerLeg2Body) && _loc10_ > 1))
                    {
                        _loc2_ = _loc9_;
                        _loc3_ = _loc6_;
                    }
                }
                _loc5_++;
            }
            return _loc3_;
        }
        
        override public function get groupDisplayObject() : DisplayObject
        {
            return this.charSprite;
        }
        
        override public function paint() : void
        {
            var _loc3_:b2Body = null;
            var _loc4_:b2Vec2 = null;
            var _loc1_:int = int(this.paintVector.length);
            var _loc2_:int = 0;
            while(_loc2_ < _loc1_)
            {
                _loc3_ = this.paintVector[_loc2_];
                _loc4_ = _loc3_.GetWorldCenter();
                _loc3_.m_userData.x = _loc4_.x * m_physScale;
                _loc3_.m_userData.y = _loc4_.y * m_physScale;
                _loc3_.m_userData.rotation = _loc3_.GetAngle() * oneEightyOverPI % 360;
                _loc2_++;
            }
        }
        
        public function contactResultHandler(param1:ContactEvent) : void
        {
            var _loc2_:b2Shape = param1.shape;
            var _loc3_:Number = param1.impulse;
            if(_loc3_ > this.contactImpulseDict[_loc2_])
            {
                if(this.contactResultBuffer[_loc2_])
                {
                    if(_loc3_ > this.contactResultBuffer[_loc2_].impulse)
                    {
                        this.contactResultBuffer[_loc2_] = param1;
                    }
                }
                else
                {
                    this.contactResultBuffer[_loc2_] = param1;
                }
            }
        }
        
        public function contactAddHandler(param1:b2ContactPoint) : void
        {
            var _loc2_:b2Shape = param1.shape1;
            var _loc3_:b2Body = _loc2_.m_body;
            var _loc4_:b2Shape = param1.shape2;
            var _loc5_:b2Body = _loc4_.m_body;
            var _loc6_:Number = _loc5_.m_mass;
            if(Boolean(this.contactAddBuffer[_loc2_]) || _loc4_.m_isSensor)
            {
                return;
            }
            if(_loc6_ != 0 && _loc6_ < _loc3_.m_mass)
            {
                return;
            }
            var _loc7_:Number = b2Math.b2Dot(param1.velocity,param1.normal);
            _loc7_ = Math.abs(_loc7_);
            if(_loc7_ > 4)
            {
                this.contactAddBuffer[_loc2_] = _loc7_;
            }
        }
        
        protected function handleContactResults() : void
        {
            var _loc1_:ContactEvent = null;
            if(this.contactResultBuffer[this.headShape])
            {
                _loc1_ = this.contactResultBuffer[this.headShape];
                this.headSmash(_loc1_.impulse);
                delete this.contactResultBuffer[this.headShape];
                delete this.contactAddBuffer[this.headShape];
            }
            if(this.contactResultBuffer[this.chestShape])
            {
                _loc1_ = this.contactResultBuffer[this.chestShape];
                this.chestSmash(_loc1_.impulse);
                delete this.contactResultBuffer[this.chestShape];
                delete this.contactAddBuffer[this.chestShape];
            }
            if(this.contactResultBuffer[this.pelvisShape])
            {
                _loc1_ = this.contactResultBuffer[this.pelvisShape];
                this.pelvisSmash(_loc1_.impulse);
                delete this.contactResultBuffer[this.pelvisShape];
                delete this.contactAddBuffer[this.pelvisShape];
            }
        }
        
        private function handleContactAdds() : void
        {
            var _loc1_:* = undefined;
            var _loc2_:b2Shape = null;
            var _loc3_:String = null;
            for(_loc1_ in this.contactAddBuffer)
            {
                _loc2_ = _loc1_ as b2Shape;
                _loc3_ = this.contactAddSounds[_loc2_];
                SoundController.instance.playAreaSoundInstance(_loc3_,_loc2_.m_body);
                delete this.contactAddBuffer[_loc1_];
            }
        }
        
        private function checkJoints() : void
        {
            this.checkRevJoint(this.waistJoint,this.torsoBreakLimit,this.torsoBreak);
            this.checkRevJoint(this.neckJoint,this.neckBreakLimit,this.neckBreak);
            this.checkRevJoint(this.shoulderJoint1,this.shoulderBreakLimit,this.shoulderBreak1);
            this.checkRevJoint(this.shoulderJoint2,this.shoulderBreakLimit,this.shoulderBreak2);
            this.checkRevJoint(this.elbowJoint1,this.elbowBreakLimit,this.elbowBreak1);
            this.checkRevJoint(this.elbowJoint2,this.elbowBreakLimit,this.elbowBreak2);
            this.checkRevJoint(this.hipJoint1,this.hipBreakLimit,this.hipBreak1);
            this.checkRevJoint(this.hipJoint2,this.hipBreakLimit,this.hipBreak2);
            this.checkRevJoint(this.kneeJoint1,this.kneeBreakLimit,this.kneeBreak1);
            this.checkRevJoint(this.kneeJoint2,this.kneeBreakLimit,this.kneeBreak2);
        }
        
        private function checkRevJoint(param1:b2Joint, param2:Number, param3:*) : void
        {
            var _loc4_:b2Vec2 = null;
            var _loc5_:Number = NaN;
            var _loc6_:* = undefined;
            var _loc7_:* = undefined;
            var _loc8_:Number = NaN;
            var _loc9_:Number = NaN;
            var _loc10_:Number = NaN;
            if(!param1.broken)
            {
                _loc4_ = param1.GetReactionForce();
                _loc5_ = _loc4_.LengthSquared();
                if(_loc5_ > param2)
                {
                    param3(_loc5_);
                    return;
                }
                _loc6_ = param1.GetAnchor1();
                _loc7_ = param1.GetAnchor2();
                _loc8_ = _loc7_.x - _loc6_.x;
                _loc9_ = _loc7_.y - _loc6_.y;
                _loc10_ = _loc8_ * _loc8_ + _loc9_ * _loc9_;
                if(_loc10_ > 0.25)
                {
                    param3(1000);
                }
            }
        }
        
        public function get dead() : Boolean
        {
            return this._dead;
        }
        
        public function set dead(param1:Boolean) : void
        {
            this._dead = param1;
            if(this._dead)
            {
                if(this.voiceSound)
                {
                    this.voiceSound.stopSound();
                    this.voiceSound = null;
                }
                if(this.destroyJointsUponDeath)
                {
                    this.destroyUserJoints();
                }
                if(this.session.levelVersion < 1.75)
                {
                    this.cancelPose();
                }
                else
                {
                    this.releasePose();
                }
            }
        }
        
        private function destroyUserJoints() : void
        {
            var _loc1_:String = null;
            for(_loc1_ in this.userJoints)
            {
                this.session.m_world.DestroyJoint(this.userJoints[_loc1_]);
            }
            this.userJoints = null;
        }
        
        private function cancelPose() : void
        {
            this.neckJoint.EnableMotor(false);
            this.shoulderJoint1.EnableMotor(false);
            this.shoulderJoint2.EnableMotor(false);
            this.elbowJoint1.EnableMotor(false);
            this.elbowJoint2.EnableMotor(false);
            this.hipJoint1.EnableMotor(false);
            this.hipJoint2.EnableMotor(false);
            this.kneeJoint1.EnableMotor(false);
            this.kneeJoint2.EnableMotor(false);
        }
        
        private function headSmash(param1:Number) : void
        {
            var _loc11_:DisplayObject = null;
            var _loc12_:Number = NaN;
            var _loc13_:b2BodyDef = null;
            var _loc14_:b2Body = null;
            var _loc15_:b2Shape = null;
            delete this.contactImpulseDict[this.headShape];
            this.session.contactListener.deleteListener(ContactListener.RESULT,this.headShape);
            this.session.contactListener.deleteListener(ContactListener.ADD,this.headShape);
            this.dead = true;
            if(!this.neckJoint.broken)
            {
                this.neckJoint.broken = true;
                this.chestMC.nextFrame();
                if(this.chestShape.m_userData != GRIND_STATE)
                {
                    _loc11_ = this.chestMC.getChildByName("spineRef");
                    _loc12_ = this.reversed ? -1 : 1;
                    this.neckBloodFlow = this.session.particleController.createBloodFlow(2.5,4,this.chestBody,new b2Vec2(_loc12_ * _loc11_.x / this.character_scale,_loc11_.y / this.character_scale),270,500,this.characterLayer,this.characterLayer.getChildIndex(this.chestMC));
                }
            }
            else
            {
                this.headBloodFlow.stopSpewing();
            }
            var _loc2_:b2CircleDef = new b2CircleDef();
            _loc2_.density = 1;
            _loc2_.friction = 0.3;
            _loc2_.restitution = 0.1;
            _loc2_.radius = this.headChunkRadius / this.character_scale;
            _loc2_.filter = this.zeroFilter;
            var _loc3_:b2Vec2 = this.headBody.GetPosition();
            var _loc4_:Number = this.headBody.GetAngle();
            var _loc5_:Number = 4 / this.character_scale;
            var _loc6_:b2Vec2 = new b2Vec2();
            this.headMC.gotoAndStop(3);
            this.headMC.visible = false;
            var _loc7_:int = this.characterLayer.getChildIndex(this.headMC);
            var _loc8_:int = 1;
            while(_loc8_ < 5)
            {
                _loc13_ = new b2BodyDef();
                _loc11_ = this.headMC.getChildByName("chunk" + _loc8_);
                _loc11_.scaleX = _loc11_.scaleY = 0.5;
                this.characterLayer.addChildAt(_loc11_,_loc7_);
                _loc13_.userData = _loc11_;
                _loc13_.position.Set(_loc3_.x + Math.sin(_loc4_) * _loc5_,_loc3_.y + Math.cos(_loc4_) * _loc5_);
                _loc14_ = this.session.m_world.CreateBody(_loc13_);
                _loc15_ = _loc14_.CreateShape(_loc2_);
                _loc15_.SetMaterial(1);
                _loc14_.SetMassFromShapes();
                _loc14_.SetLinearVelocity(this.headBody.GetLinearVelocityFromWorldPoint(_loc13_.position));
                _loc14_.SetAngularVelocity(this.headBody.GetAngularVelocity());
                this.paintVector.push(_loc14_);
                _loc4_ += Math.PI / 2;
                _loc8_++;
            }
            _loc2_.radius = this.brainRadius / this.character_scale;
            var _loc9_:b2BodyDef = new b2BodyDef();
            _loc11_ = this.headMC.getChildByName("brain");
            _loc11_.scaleX = _loc11_.scaleY = 0.5;
            this.characterLayer.addChildAt(_loc11_,_loc7_);
            _loc9_.userData = _loc11_;
            _loc9_.position.Set(_loc3_.x,_loc3_.y);
            _loc9_.angle = this.headBody.GetAngle();
            var _loc10_:b2Body = this.session.m_world.CreateBody(_loc9_);
            _loc15_ = _loc10_.CreateShape(_loc2_);
            _loc15_.SetMaterial(1);
            _loc10_.SetMassFromShapes();
            _loc10_.SetLinearVelocity(this.headBody.GetLinearVelocity());
            _loc10_.SetAngularVelocity(this.headBody.GetAngularVelocity());
            this.paintVector.push(_loc10_);
            this.session.particleController.createBloodBurst(5,15,this.headBody,200,new b2Vec2(),this.characterLayer);
            SoundController.instance.playAreaSoundInstance("HeadSmash",this.headBody);
            this.session.m_world.DestroyBody(this.headBody);
        }
        
        private function chestSmash(param1:Number) : void
        {
            var _loc10_:b2BodyDef = null;
            var _loc11_:DisplayObject = null;
            var _loc12_:b2Body = null;
            var _loc13_:b2Shape = null;
            delete this.contactImpulseDict[this.chestShape];
            this.session.contactListener.deleteListener(ContactListener.RESULT,this.chestShape);
            this.session.contactListener.deleteListener(ContactListener.ADD,this.chestShape);
            this.dead = true;
            if(!this.neckJoint.broken)
            {
                this.neckBreak(0,false,false);
            }
            if(this.shoulderJoint1)
            {
                if(!this.shoulderJoint1.broken)
                {
                    this.shoulderBreak1(0,false);
                }
            }
            if(this.shoulderJoint2)
            {
                if(!this.shoulderJoint2.broken)
                {
                    this.shoulderBreak2(0,false);
                }
            }
            if(!this.waistJoint.broken)
            {
                this.torsoBreak(0,false);
            }
            var _loc2_:b2CircleDef = new b2CircleDef();
            _loc2_.density = 1;
            _loc2_.friction = 0.3;
            _loc2_.restitution = 0.1;
            _loc2_.radius = this.chestChunkRadius / this.character_scale;
            _loc2_.filter = this.zeroFilter;
            var _loc3_:b2Vec2 = this.chestBody.GetPosition();
            var _loc4_:Number = this.chestBody.GetAngle() + Math.PI / 4;
            var _loc5_:Number = 5 / this.character_scale;
            var _loc6_:b2Vec2 = new b2Vec2();
            this.chestMC.gotoAndStop(9);
            this.chestMC.visible = false;
            var _loc7_:int = this.characterLayer.getChildIndex(this.chestMC);
            var _loc8_:int = 1;
            while(_loc8_ < 5)
            {
                _loc10_ = new b2BodyDef();
                _loc11_ = this.chestMC.getChildByName("chunk" + _loc8_);
                _loc11_.scaleX = _loc11_.scaleY = 0.5;
                this.characterLayer.addChildAt(_loc11_,_loc7_);
                _loc10_.userData = _loc11_;
                _loc10_.position.Set(_loc3_.x + Math.sin(_loc4_) * _loc5_,_loc3_.y + Math.cos(_loc4_) * _loc5_);
                _loc10_.angle = this.chestBody.GetAngle();
                _loc12_ = this.session.m_world.CreateBody(_loc10_);
                _loc13_ = _loc12_.CreateShape(_loc2_);
                _loc13_.SetMaterial(1);
                _loc12_.SetMassFromShapes();
                _loc12_.SetLinearVelocity(this.chestBody.GetLinearVelocityFromWorldPoint(_loc10_.position));
                _loc12_.SetAngularVelocity(this.chestBody.GetAngularVelocity());
                this.paintVector.push(_loc12_);
                _loc4_ += Math.PI / 2;
                _loc8_++;
            }
            _loc2_.radius = this.headChunkRadius / this.character_scale;
            var _loc9_:b2BodyDef = new b2BodyDef();
            _loc11_ = this.chestMC.getChildByName("heart");
            _loc11_.scaleX = _loc11_.scaleY = 0.5;
            this.characterLayer.addChildAt(_loc11_,_loc7_);
            (_loc11_ as MovieClip).play();
            _loc9_.userData = _loc11_;
            _loc9_.position.Set(_loc3_.x,_loc3_.y);
            _loc9_.angle = this.chestBody.GetAngle();
            this.heartBody = this.session.m_world.CreateBody(_loc9_);
            _loc13_ = this.heartBody.CreateShape(_loc2_);
            _loc13_.SetMaterial(1);
            this.heartBody.SetMassFromShapes();
            this.heartBody.SetLinearVelocity(this.chestBody.GetLinearVelocity());
            this.heartBody.SetAngularVelocity(this.chestBody.GetAngularVelocity());
            this.paintVector.push(this.heartBody);
            if(this.stomachBloodFlow)
            {
                this.stomachBloodFlow.stopSpewing();
            }
            if(this.neckBloodFlow)
            {
                this.neckBloodFlow.stopSpewing();
            }
            if(this.shoulder1BloodFlow)
            {
                this.shoulder1BloodFlow.stopSpewing();
            }
            if(this.shoulder2BloodFlow)
            {
                this.shoulder2BloodFlow.stopSpewing();
            }
            this.session.particleController.createBloodBurst(5,20,this.chestBody,300,new b2Vec2(),this.characterLayer,_loc7_);
            SoundController.instance.playAreaSoundInstance("ChestSmash",this.chestBody);
            this.chestBody.SetAngularVelocity(0);
            this.chestBody.SetLinearVelocity(new b2Vec2());
            this.session.m_world.DestroyBody(this.chestBody);
            this.chestMC.visible = false;
        }
        
        private function pelvisSmash(param1:Number) : void
        {
            var _loc9_:b2BodyDef = null;
            var _loc10_:DisplayObject = null;
            var _loc11_:b2Body = null;
            var _loc12_:b2Shape = null;
            delete this.contactImpulseDict[this.pelvisShape];
            this.session.contactListener.deleteListener(ContactListener.RESULT,this.pelvisShape);
            this.session.contactListener.deleteListener(ContactListener.ADD,this.pelvisShape);
            if(this.hipJoint1)
            {
                if(!this.hipJoint1.broken)
                {
                    this.hipBreak1(0,false);
                }
            }
            if(this.hipJoint2)
            {
                if(!this.hipJoint2.broken)
                {
                    this.hipBreak2(0,false);
                }
            }
            if(!this.waistJoint.broken)
            {
                this.torsoBreak(0);
            }
            if(this.hip1BloodFlow)
            {
                this.hip1BloodFlow.stopSpewing();
            }
            if(this.hip2BloodFlow)
            {
                this.hip2BloodFlow.stopSpewing();
            }
            var _loc2_:b2CircleDef = new b2CircleDef();
            _loc2_.density = 1;
            _loc2_.friction = 0.3;
            _loc2_.restitution = 0.1;
            _loc2_.radius = this.pelvisChunkRadius / this.character_scale;
            _loc2_.filter = this.zeroFilter;
            var _loc3_:b2Vec2 = this.pelvisBody.GetPosition();
            var _loc4_:Number = this.pelvisBody.GetAngle();
            var _loc5_:Number = 3 / this.character_scale;
            var _loc6_:b2Vec2 = new b2Vec2();
            this.pelvisMC.gotoAndStop(5);
            this.pelvisMC.visible = false;
            var _loc7_:int = this.characterLayer.getChildIndex(this.pelvisMC);
            var _loc8_:int = 1;
            while(_loc8_ < 4)
            {
                _loc9_ = new b2BodyDef();
                _loc10_ = this.pelvisMC.getChildByName("chunk" + _loc8_);
                _loc10_.scaleX = _loc10_.scaleY = 0.5;
                this.characterLayer.addChildAt(_loc10_,_loc7_);
                _loc9_.userData = _loc10_;
                _loc9_.position.Set(_loc3_.x + Math.sin(_loc4_) * _loc5_,_loc3_.y + Math.cos(_loc4_) * _loc5_);
                _loc9_.angle = this.pelvisBody.GetAngle();
                _loc11_ = this.session.m_world.CreateBody(_loc9_);
                _loc12_ = _loc11_.CreateShape(_loc2_);
                _loc12_.SetMaterial(1);
                _loc11_.SetMassFromShapes();
                _loc11_.SetLinearVelocity(this.pelvisBody.GetLinearVelocityFromWorldPoint(_loc9_.position));
                _loc11_.SetAngularVelocity(this.pelvisBody.GetAngularVelocity());
                this.paintVector.push(_loc11_);
                _loc4_ += Math.PI * 2 / 3;
                _loc8_++;
            }
            this.session.particleController.createBloodBurst(5,15,this.pelvisBody,200,new b2Vec2(),this.characterLayer,_loc7_);
            SoundController.instance.playAreaSoundInstance("PelvisSmash",this.pelvisBody);
            this.session.m_world.DestroyBody(this.pelvisBody);
            this.pelvisMC.visible = false;
            this.addVocals("Pelvis",5);
        }
        
        private function torsoBreak(param1:Number, param2:Boolean = true, param3:Boolean = true) : void
        {
            this.waistJoint.broken = true;
            this.session.m_world.DestroyJoint(this.waistJoint);
            var _loc4_:int = this.chestMC.currentFrame;
            this.chestMC.gotoAndStop(_loc4_ + 4);
            this.pelvisMC.nextFrame();
            var _loc5_:b2Vec2 = this.chestBody.GetPosition();
            var _loc6_:b2Vec2 = this.pelvisBody.GetPosition();
            if(this.pelvisShape.m_userData != GRIND_STATE)
            {
                this.pelvisBody.GetShapeList().SetFilterData(this.lowerBodyFilter);
                this.session.m_world.Refilter(this.pelvisBody.GetShapeList());
            }
            var _loc7_:b2Shape = this.upperLeg1Body.GetShapeList();
            if(_loc7_.m_filter.groupIndex != -3)
            {
                _loc7_.SetFilterData(this.lowerBodyFilter);
                this.session.m_world.Refilter(_loc7_);
            }
            _loc7_ = this.upperLeg2Body.GetShapeList();
            if(_loc7_.m_filter.groupIndex != -3)
            {
                _loc7_.SetFilterData(this.lowerBodyFilter);
                this.session.m_world.Refilter(_loc7_);
            }
            _loc7_ = this.lowerLeg1Body.GetShapeList();
            if(_loc7_.m_filter.groupIndex != -3)
            {
                _loc7_.SetFilterData(this.lowerBodyFilter);
                this.session.m_world.Refilter(_loc7_);
            }
            _loc7_ = this.lowerLeg2Body.GetShapeList();
            if(_loc7_.m_filter.groupIndex != -3)
            {
                _loc7_.SetFilterData(this.lowerBodyFilter);
                this.session.m_world.Refilter(_loc7_);
            }
            if(param2 && this.chestShape.m_userData != GRIND_STATE)
            {
                this.stomachBloodFlow = this.session.particleController.createBloodFlow(2,3,this.chestBody,new b2Vec2(0,0),90,500,this.characterLayer,this.characterLayer.getChildIndex(this.chestMC));
            }
            if(param3)
            {
                SoundController.instance.playAreaSoundInstance("LimbRip1",this.pelvisBody);
            }
            this.addVocals("Torso",5);
        }
        
        private function neckBreak(param1:Number, param2:Boolean = true, param3:Boolean = true) : void
        {
            var _loc4_:DisplayObject = null;
            var _loc5_:Number = NaN;
            this.dead = true;
            this.neckJoint.broken = true;
            this.session.m_world.DestroyJoint(this.neckJoint);
            this.headMC.gotoAndStop(2);
            this.chestMC.nextFrame();
            if(this.headShape.m_userData != GRIND_STATE)
            {
                this.headBody.GetShapeList().SetFilterData(this.zeroFilter);
                this.session.m_world.Refilter(this.headBody.GetShapeList());
                this.headBloodFlow = this.session.particleController.createBloodFlow(2.5,4,this.headBody,new b2Vec2(0,0),90,150,this.characterLayer,this.characterLayer.getChildIndex(this.headMC));
            }
            if(param2 && this.chestShape.m_userData != GRIND_STATE)
            {
                _loc4_ = this.chestMC.getChildByName("spineRef");
                _loc5_ = this.reversed ? -1 : 1;
                this.neckBloodFlow = this.session.particleController.createBloodFlow(2.5,4,this.chestBody,new b2Vec2(_loc5_ * _loc4_.x / this.character_scale,_loc4_.y / this.character_scale),270,500,this.characterLayer,this.characterLayer.getChildIndex(this.chestMC));
            }
            if(param3)
            {
                SoundController.instance.playAreaSoundInstance("NeckBreak",this.headBody);
            }
        }
        
        private function shoulderBreak1(param1:Number, param2:Boolean = true) : void
        {
            this.shoulderJoint1.broken = true;
            var _loc3_:b2Vec2 = this.shoulderJoint1.m_localAnchor1;
            var _loc4_:b2Vec2 = this.shoulderJoint1.m_localAnchor2;
            this.session.m_world.DestroyJoint(this.shoulderJoint1);
            var _loc5_:b2Shape = this.upperArm1Body.GetShapeList();
            if(_loc5_.m_filter.groupIndex != -3)
            {
                _loc5_.SetFilterData(this.zeroFilter);
                this.session.m_world.Refilter(_loc5_);
                _loc5_.SetMaterial(2);
                _loc5_.SetUserData(this);
                this.arm1BloodFlow = this.session.particleController.createBloodFlow(1,3,this.upperArm1Body,_loc4_,270,200,this.characterLayer,this.characterLayer.getChildIndex(this.upperArm1MC));
            }
            _loc5_ = this.lowerArm1Body.GetShapeList();
            if(_loc5_.m_filter.groupIndex != -3)
            {
                _loc5_.SetFilterData(this.zeroFilter);
                this.session.m_world.Refilter(_loc5_);
            }
            this.upperArm1MC.nextFrame();
            this.chestMC.nextFrame();
            this.chestMC.nextFrame();
            if(param2 && this.chestShape.m_userData != GRIND_STATE)
            {
                this.shoulder1BloodFlow = this.session.particleController.createBloodFlow(0,1,this.chestBody,_loc3_,270,500,this.characterLayer,this.characterLayer.getChildIndex(this.upperArm1MC));
                SoundController.instance.playAreaSoundInstance("LimbRip2",this.upperArm1Body);
            }
            this.addVocals("Shoulder1",3);
        }
        
        private function shoulderBreak2(param1:Number, param2:Boolean = true) : void
        {
            this.shoulderJoint2.broken = true;
            var _loc3_:b2Vec2 = this.shoulderJoint2.m_localAnchor1;
            var _loc4_:b2Vec2 = this.shoulderJoint2.m_localAnchor2;
            this.session.m_world.DestroyJoint(this.shoulderJoint2);
            var _loc5_:b2Shape = this.upperArm2Body.GetShapeList();
            if(_loc5_.m_filter.groupIndex != -3)
            {
                _loc5_.SetFilterData(this.zeroFilter);
                this.session.m_world.Refilter(_loc5_);
                _loc5_.SetMaterial(2);
                _loc5_.SetUserData(this);
                this.arm2BloodFlow = this.session.particleController.createBloodFlow(1,3,this.upperArm2Body,_loc4_,270,200,this.characterLayer,this.characterLayer.getChildIndex(this.chestMC));
            }
            _loc5_ = this.lowerArm2Body.GetShapeList();
            if(_loc5_.m_filter.groupIndex != -3)
            {
                _loc5_.SetFilterData(this.zeroFilter);
                this.session.m_world.Refilter(_loc5_);
            }
            this.upperArm2MC.nextFrame();
            if(param2 && this.chestShape.m_userData != GRIND_STATE)
            {
                this.shoulder2BloodFlow = this.session.particleController.createBloodFlow(0,1,this.chestBody,_loc3_,270,500,this.characterLayer,this.characterLayer.getChildIndex(this.upperArm2MC));
                SoundController.instance.playAreaSoundInstance("LimbRip2",this.upperArm2Body);
            }
            this.addVocals("Shoulder2",3);
        }
        
        private function elbowBreak1(param1:Number) : void
        {
            var _loc4_:b2Shape = null;
            this.elbowJoint1.broken = true;
            var _loc2_:b2Vec2 = this.elbowJoint1.m_localAnchor2;
            this.session.m_world.DestroyJoint(this.elbowJoint1);
            var _loc3_:b2JointEdge = this.lowerArm1Body.m_jointList;
            while(_loc3_)
            {
                _loc4_ = _loc3_.other.GetShapeList();
                if(!_loc4_.m_isSensor)
                {
                    this.session.m_world.DestroyJoint(_loc3_.joint);
                }
                _loc3_ = _loc3_.next;
            }
            _loc4_ = this.lowerArm1Body.GetShapeList();
            if(_loc4_.m_filter.groupIndex != -3)
            {
                _loc4_.SetFilterData(this.zeroFilter);
                this.session.m_world.Refilter(_loc4_);
            }
            this.lowerArm1MC.gotoAndStop(2);
            var _loc5_:int = this.upperArm1MC.currentFrame;
            this.upperArm1MC.gotoAndStop(_loc5_ + 2);
            this.session.particleController.createBloodBurst(5,15,this.lowerArm1Body,50,_loc2_,this.characterLayer);
            var _loc6_:int = Math.ceil(Math.random() * 4);
            SoundController.instance.playAreaSoundInstance("BoneBreak" + _loc6_,this.lowerArm1Body);
            this.addVocals("Elbow1",1);
        }
        
        private function elbowBreak2(param1:Number) : void
        {
            var _loc4_:b2Shape = null;
            this.elbowJoint2.broken = true;
            var _loc2_:b2Vec2 = this.elbowJoint1.m_localAnchor2;
            this.session.m_world.DestroyJoint(this.elbowJoint2);
            var _loc3_:b2JointEdge = this.lowerArm2Body.m_jointList;
            while(_loc3_)
            {
                _loc4_ = _loc3_.other.GetShapeList();
                if(!_loc4_.m_isSensor)
                {
                    this.session.m_world.DestroyJoint(_loc3_.joint);
                }
                _loc3_ = _loc3_.next;
            }
            _loc4_ = this.lowerArm2Body.GetShapeList();
            if(_loc4_.m_filter.groupIndex != -3)
            {
                _loc4_.SetFilterData(this.zeroFilter);
                this.session.m_world.Refilter(_loc4_);
            }
            this.lowerArm2MC.gotoAndStop(2);
            var _loc5_:int = this.upperArm2MC.currentFrame;
            this.upperArm2MC.gotoAndStop(_loc5_ + 2);
            this.session.particleController.createBloodBurst(5,15,this.lowerArm2Body,50,_loc2_,this.characterLayer);
            var _loc6_:int = Math.ceil(Math.random() * 4);
            SoundController.instance.playAreaSoundInstance("BoneBreak" + _loc6_,this.lowerArm2Body);
            this.addVocals("Elbow2",1);
        }
        
        private function hipBreak1(param1:Number, param2:Boolean = true) : void
        {
            this.hipJoint1.broken = true;
            var _loc3_:b2Vec2 = this.hipJoint1.m_localAnchor1;
            var _loc4_:b2Vec2 = this.hipJoint1.m_localAnchor2;
            this.session.m_world.DestroyJoint(this.hipJoint1);
            var _loc5_:b2Shape = this.upperLeg1Body.GetShapeList();
            if(_loc5_.m_filter.groupIndex != -3)
            {
                _loc5_.SetFilterData(this.zeroFilter);
                this.session.m_world.Refilter(_loc5_);
                _loc5_.SetMaterial(2);
                _loc5_.SetUserData(this);
                this.thigh1BloodFlow = this.session.particleController.createBloodFlow(1,3,this.upperLeg1Body,_loc4_,270,200,this.characterLayer,this.characterLayer.getChildIndex(this.upperLeg1MC));
            }
            _loc5_ = this.lowerLeg1Body.GetShapeList();
            if(_loc5_.m_filter.groupIndex != -3)
            {
                _loc5_.SetFilterData(this.zeroFilter);
                this.session.m_world.Refilter(_loc5_);
            }
            this.upperLeg1MC.nextFrame();
            var _loc6_:int = this.pelvisMC.currentFrame;
            this.pelvisMC.gotoAndStop(_loc6_ + 2);
            if(param2 && this.pelvisShape.m_userData != GRIND_STATE)
            {
                this.hip1BloodFlow = this.session.particleController.createBloodFlow(0,1,this.pelvisBody,new b2Vec2(0,0),90,500,this.characterLayer,this.characterLayer.getChildIndex(this.upperLeg1MC));
                SoundController.instance.playAreaSoundInstance("LimbRip3",this.upperLeg1Body);
            }
            this.addVocals("Hip1",4);
        }
        
        private function hipBreak2(param1:Number, param2:Boolean = true) : void
        {
            this.hipJoint2.broken = true;
            var _loc3_:b2Vec2 = this.hipJoint2.m_localAnchor1;
            var _loc4_:b2Vec2 = this.hipJoint2.m_localAnchor2;
            this.session.m_world.DestroyJoint(this.hipJoint2);
            var _loc5_:b2Shape = this.upperLeg2Body.GetShapeList();
            if(_loc5_.m_filter.groupIndex != -3)
            {
                _loc5_.SetFilterData(this.zeroFilter);
                this.session.m_world.Refilter(_loc5_);
                _loc5_.SetMaterial(2);
                _loc5_.SetUserData(this);
                this.thigh2BloodFlow = this.session.particleController.createBloodFlow(1,3,this.upperLeg2Body,_loc4_,270,200,this.characterLayer,this.characterLayer.getChildIndex(this.upperLeg2MC));
            }
            _loc5_ = this.lowerLeg2Body.GetShapeList();
            if(_loc5_.m_filter.groupIndex != -3)
            {
                _loc5_.SetFilterData(this.zeroFilter);
                this.session.m_world.Refilter(_loc5_);
            }
            this.upperLeg2MC.nextFrame();
            if(param2 && this.pelvisShape.m_userData != GRIND_STATE)
            {
                this.hip2BloodFlow = this.session.particleController.createBloodFlow(0,1,this.pelvisBody,new b2Vec2(0,0),90,500,this.characterLayer,this.characterLayer.getChildIndex(this.upperLeg2MC));
                SoundController.instance.playAreaSoundInstance("LimbRip4",this.upperLeg2Body);
            }
            this.addVocals("Hip2",4);
        }
        
        private function kneeBreak1(param1:Number) : void
        {
            var _loc4_:b2Shape = null;
            this.kneeJoint1.broken = true;
            var _loc2_:b2Vec2 = this.kneeJoint1.m_localAnchor2;
            this.session.m_world.DestroyJoint(this.kneeJoint1);
            var _loc3_:b2JointEdge = this.lowerLeg1Body.m_jointList;
            while(_loc3_)
            {
                _loc4_ = _loc3_.other.GetShapeList();
                if(!_loc4_.m_isSensor)
                {
                    this.session.m_world.DestroyJoint(_loc3_.joint);
                }
                _loc3_ = _loc3_.next;
            }
            _loc4_ = this.lowerLeg1Body.GetShapeList();
            if(_loc4_.m_filter.groupIndex != -3)
            {
                _loc4_.SetFilterData(this.zeroFilter);
                _loc4_.m_isSensor = false;
            }
            this.session.m_world.Refilter(_loc4_);
            this.lowerLeg1MC.gotoAndStop(2);
            var _loc5_:int = this.upperLeg1MC.currentFrame;
            this.upperLeg1MC.gotoAndStop(_loc5_ + 2);
            this.session.particleController.createBloodBurst(5,15,this.lowerLeg1Body,50,_loc2_,this.characterLayer);
            var _loc6_:int = Math.ceil(Math.random() * 4);
            SoundController.instance.playAreaSoundInstance("BoneBreak" + _loc6_,this.upperLeg1Body);
            this.addVocals("Knee1",2);
        }
        
        private function kneeBreak2(param1:Number) : void
        {
            var _loc4_:b2Shape = null;
            this.kneeJoint2.broken = true;
            var _loc2_:b2Vec2 = this.kneeJoint2.m_localAnchor2;
            this.session.m_world.DestroyJoint(this.kneeJoint2);
            var _loc3_:b2JointEdge = this.lowerLeg2Body.m_jointList;
            while(_loc3_)
            {
                _loc4_ = _loc3_.other.GetShapeList();
                if(!_loc4_.m_isSensor)
                {
                    this.session.m_world.DestroyJoint(_loc3_.joint);
                }
                _loc3_ = _loc3_.next;
            }
            _loc4_ = this.lowerLeg2Body.GetShapeList();
            if(_loc4_.m_filter.groupIndex != -3)
            {
                _loc4_.SetFilterData(this.zeroFilter);
                _loc4_.m_isSensor = false;
            }
            this.session.m_world.Refilter(_loc4_);
            this.lowerLeg2MC.gotoAndStop(2);
            var _loc5_:int = this.upperLeg2MC.currentFrame;
            this.upperLeg2MC.gotoAndStop(_loc5_ + 2);
            this.session.particleController.createBloodBurst(5,15,this.lowerLeg2Body,50,_loc2_,this.characterLayer);
            var _loc6_:int = Math.ceil(Math.random() * 4);
            SoundController.instance.playAreaSoundInstance("BoneBreak" + _loc6_,this.upperLeg2Body);
            this.addVocals("Knee2",2);
        }
        
        protected function checkVocals() : void
        {
            var _loc2_:String = null;
            var _loc1_:int = int(this.voiceArray.length - 1);
            if(this.voiceSound)
            {
                if(this.voiceSound.soundChannel)
                {
                    if(_loc1_ > this.voicePriority)
                    {
                        this.voiceSound.stopSound();
                        _loc2_ = this.voiceArray[_loc1_];
                        this.voiceSound = SoundController.instance.playAreaSoundInstance(this.tag + _loc2_,this.headBody);
                        this.voicePriority = _loc1_;
                    }
                    return;
                }
                this.voiceSound = null;
                this.voicePriority = -1;
            }
            if(_loc1_ < 0)
            {
                return;
            }
            _loc2_ = this.voiceArray[_loc1_];
            this.voiceSound = SoundController.instance.playAreaSoundInstance(this.tag + _loc2_,this.headBody);
            this.voicePriority = _loc1_;
        }
        
        public function addVocals(param1:String, param2:int) : void
        {
            this.voiceArray[param2] = param1;
        }
        
        protected function randomVocals(param1:int) : String
        {
            var _loc2_:Array = ["Elbow1","Elbow2","Knee1","Knee2","Shoulder1","Shoulder2","Hip1","Hip2","Knee1","Spikes"];
            return _loc2_[param1];
        }
        
        public function shapeImpale(param1:b2Shape, param2:Boolean = true, param3:b2Vec2 = null, param4:Number = 0) : void
        {
            var _loc5_:String = null;
            var _loc6_:int = 0;
            var _loc7_:b2Vec2 = null;
            var _loc8_:b2Vec2 = null;
            var _loc9_:Number = NaN;
            if(Settings.currentSession.version < 1.35)
            {
                return;
            }
            if(param1 == this.chestShape || param1 == this.pelvisShape)
            {
                _loc5_ = param1.GetBody().GetPosition().x.toString();
                _loc6_ = int(_loc5_.charAt(_loc5_.length - 1));
                this.addVocals(this.randomVocals(_loc6_),5);
            }
            else if(param1 == this.headShape)
            {
                if(param2)
                {
                    if(param3)
                    {
                        _loc7_ = param1.GetBody().GetWorldCenter();
                        _loc8_ = new b2Vec2(param3.x - _loc7_.x,param3.y - _loc7_.y);
                        _loc9_ = _loc8_.LengthSquared();
                        if(_loc9_ < param4)
                        {
                            this.dead = true;
                        }
                        else
                        {
                            _loc5_ = param1.GetBody().GetPosition().x.toString();
                            _loc6_ = int(_loc5_.charAt(_loc5_.length - 1));
                            this.addVocals(this.randomVocals(_loc6_),5);
                        }
                    }
                    else
                    {
                        this.dead = true;
                    }
                }
                else
                {
                    _loc5_ = param1.GetBody().GetPosition().x.toString();
                    _loc6_ = int(_loc5_.charAt(_loc5_.length - 1));
                    this.addVocals(this.randomVocals(_loc6_),5);
                }
            }
        }
        
        public function grindShape(param1:b2Shape) : void
        {
            switch(param1)
            {
                case this.headShape:
                    this.headShape.SetUserData(GRIND_STATE);
                    delete this.contactResultBuffer[this.headShape];
                    delete this.contactAddBuffer[this.headShape];
                    this.session.contactListener.deleteListener(ContactListener.RESULT,this.headShape);
                    this.session.contactListener.deleteListener(ContactListener.ADD,this.headShape);
                    if(this.headBloodFlow)
                    {
                        this.headBloodFlow.stopSpewing();
                    }
                    break;
                case this.chestShape:
                    this.chestShape.SetUserData(GRIND_STATE);
                    delete this.contactResultBuffer[this.chestShape];
                    delete this.contactAddBuffer[this.chestShape];
                    this.session.contactListener.deleteListener(ContactListener.RESULT,this.chestShape);
                    this.session.contactListener.deleteListener(ContactListener.ADD,this.chestShape);
                    if(this.neckBloodFlow)
                    {
                        this.neckBloodFlow.stopSpewing();
                    }
                    if(this.shoulder1BloodFlow)
                    {
                        this.shoulder1BloodFlow.stopSpewing();
                    }
                    if(this.shoulder2BloodFlow)
                    {
                        this.shoulder2BloodFlow.stopSpewing();
                    }
                    if(this.stomachBloodFlow)
                    {
                        this.stomachBloodFlow.stopSpewing();
                    }
                    break;
                case this.pelvisShape:
                    this.pelvisShape.SetUserData(GRIND_STATE);
                    delete this.contactResultBuffer[this.pelvisShape];
                    delete this.contactAddBuffer[this.pelvisShape];
                    this.session.contactListener.deleteListener(ContactListener.RESULT,this.pelvisShape);
                    this.session.contactListener.deleteListener(ContactListener.ADD,this.pelvisShape);
                    if(this.hip1BloodFlow)
                    {
                        this.hip1BloodFlow.stopSpewing();
                    }
                    if(this.hip2BloodFlow)
                    {
                        this.hip2BloodFlow.stopSpewing();
                    }
                    break;
                case this.upperArm1Body.GetShapeList():
                    if(this.arm1BloodFlow)
                    {
                        this.arm1BloodFlow.stopSpewing();
                    }
                    break;
                case this.upperArm2Body.GetShapeList():
                    if(this.arm2BloodFlow)
                    {
                        this.arm2BloodFlow.stopSpewing();
                    }
                    break;
                case this.upperLeg1Body.GetShapeList():
                    if(this.thigh1BloodFlow)
                    {
                        this.thigh1BloodFlow.stopSpewing();
                    }
                    break;
                case this.upperLeg2Body.GetShapeList():
                    if(this.thigh2BloodFlow)
                    {
                        this.thigh2BloodFlow.stopSpewing();
                    }
            }
        }
        
        public function removeBody(param1:b2Body) : void
        {
            switch(param1)
            {
                case this.headBody:
                    if(!this.neckJoint.broken)
                    {
                        this.neckBreak(0,true,true);
                    }
                    break;
                case this.chestBody:
                    if(!this.neckJoint.broken)
                    {
                        this.neckBreak(0,true,true);
                    }
                    if(!this.shoulderJoint1.broken)
                    {
                        this.shoulderBreak1(0,true);
                    }
                    if(!this.shoulderJoint2.broken)
                    {
                        this.shoulderBreak2(0,true);
                    }
                    if(!this.waistJoint.broken)
                    {
                        this.torsoBreak(0);
                    }
                    break;
                case this.pelvisBody:
                    if(!this.hipJoint1.broken)
                    {
                        this.hipBreak1(0,true);
                    }
                    if(!this.hipJoint2.broken)
                    {
                        this.hipBreak2(0,true);
                    }
                    if(!this.waistJoint.broken)
                    {
                        this.torsoBreak(0);
                    }
                    break;
                case this.upperArm1Body:
                    if(!this.shoulderJoint1.broken)
                    {
                        this.shoulderBreak1(0,true);
                    }
                    if(!this.elbowJoint1.broken)
                    {
                        this.elbowBreak1(0);
                    }
                    break;
                case this.upperArm2Body:
                    if(!this.shoulderJoint2.broken)
                    {
                        this.shoulderBreak2(0,true);
                    }
                    if(!this.elbowJoint2.broken)
                    {
                        this.elbowBreak2(0);
                    }
                    break;
                case this.upperLeg1Body:
                    if(!this.hipJoint1.broken)
                    {
                        this.hipBreak1(0,true);
                    }
                    if(!this.kneeJoint1.broken)
                    {
                        this.kneeBreak1(0);
                    }
                    break;
                case this.upperLeg2Body:
                    if(!this.hipJoint2.broken)
                    {
                        this.hipBreak2(0,true);
                    }
                    if(!this.kneeJoint2.broken)
                    {
                        this.kneeBreak2(0);
                    }
            }
        }
        
        public function explodeShape(param1:b2Shape, param2:Number) : void
        {
            var _loc3_:Number = NaN;
            var _loc4_:Number = NaN;
            var _loc5_:Number = NaN;
            switch(param1)
            {
                case this.headShape:
                    if(param2 > 0.85)
                    {
                        delete this.contactResultBuffer[this.headShape];
                        delete this.contactAddBuffer[this.headShape];
                        this.headSmash(0);
                    }
                    break;
                case this.chestShape:
                    _loc3_ = this.chestBody.GetMass() / CharacterB2D.DEF_CHEST_MASS;
                    _loc4_ = Math.max(1 - 0.15 * _loc3_,0.7);
                    if(param2 > _loc4_)
                    {
                        delete this.contactResultBuffer[this.chestShape];
                        delete this.contactAddBuffer[this.chestShape];
                        this.chestSmash(0);
                    }
                    break;
                case this.pelvisShape:
                    _loc5_ = this.pelvisBody.GetMass() / CharacterB2D.DEF_PELVIS_MASS;
                    _loc4_ = Math.max(1 - 0.15 * _loc5_,0.7);
                    if(param2 > _loc4_)
                    {
                        delete this.contactResultBuffer[this.pelvisShape];
                        delete this.contactAddBuffer[this.pelvisShape];
                        this.pelvisSmash(0);
                    }
            }
        }
        
        public function get centralBody() : b2Body
        {
            if(this.heartBody)
            {
                return this.heartBody;
            }
            return this.chestBody;
        }
        
        override public function triggerSingleActivation(param1:Trigger, param2:String, param3:Array) : void
        {
            var _loc4_:Number = NaN;
            var _loc5_:Number = NaN;
            var _loc6_:Number = NaN;
            var _loc7_:Array = null;
            var _loc8_:int = 0;
            var _loc9_:int = 0;
            var _loc10_:b2Body = null;
            var _loc11_:Number = NaN;
            var _loc12_:Number = NaN;
            if(param2 == "wake from sleep")
            {
                if(this.chestBody)
                {
                    this.chestBody.WakeUp();
                }
            }
            else if(param2 == "apply impulse")
            {
                if(this.destroyJointsUponDeath && this._dead)
                {
                    return;
                }
                if(this.chestBody)
                {
                    _loc4_ = Number(param3[0]);
                    _loc5_ = Number(param3[1]);
                    _loc6_ = Number(param3[2]);
                    _loc7_ = [this.chestBody,this.headBody,this.pelvisBody];
                    if(!this.shoulderJoint1.broken)
                    {
                        _loc7_.push(this.upperArm1Body);
                        if(!this.elbowJoint1.broken)
                        {
                            _loc7_.push(this.lowerArm1Body);
                        }
                    }
                    if(!this.shoulderJoint2.broken)
                    {
                        _loc7_.push(this.upperArm2Body);
                        if(!this.elbowJoint2.broken)
                        {
                            _loc7_.push(this.lowerArm2Body);
                        }
                    }
                    if(!this.hipJoint1.broken)
                    {
                        _loc7_.push(this.upperLeg1Body);
                        if(!this.kneeJoint1.broken)
                        {
                            _loc7_.push(this.lowerLeg1Body);
                        }
                    }
                    if(!this.hipJoint2.broken)
                    {
                        _loc7_.push(this.upperLeg2Body);
                        if(!this.kneeJoint2.broken)
                        {
                            _loc7_.push(this.lowerLeg2Body);
                        }
                    }
                    _loc8_ = int(_loc7_.length);
                    _loc9_ = 0;
                    while(_loc9_ < _loc8_)
                    {
                        _loc10_ = _loc7_[_loc9_];
                        _loc11_ = _loc10_.GetMass();
                        _loc10_.ApplyImpulse(new b2Vec2(_loc4_ * _loc11_,_loc5_ * _loc11_),_loc10_.GetWorldCenter());
                        _loc9_++;
                    }
                    if(_loc6_)
                    {
                        _loc12_ = this.chestBody.GetAngularVelocity();
                        this.chestBody.SetAngularVelocity(_loc12_ + _loc6_ * 10);
                    }
                }
            }
            else if(param2 == "hold pose")
            {
                if(this.destroyJointsUponDeath && this._dead)
                {
                    return;
                }
                if(this.chestBody)
                {
                    this.lockPose();
                }
            }
            else
            {
                param2 = "release pose";
                if(param2)
                {
                    if(this.destroyJointsUponDeath && this._dead)
                    {
                        return;
                    }
                    if(this.chestBody)
                    {
                        this.releasePose();
                    }
                }
            }
        }
        
        override public function get bodyList() : Array
        {
            if(this.chestBody)
            {
                return [this.chestBody,this.headBody];
            }
            return [];
        }
        
        private function lockPose() : void
        {
            trace("LOCK POSE");
            var _loc1_:Number = 0;
            var _loc2_:Number = this.neckJoint.GetJointAngle();
            this.neckJoint.m_lowerAngle = _loc2_ - _loc1_;
            this.neckJoint.m_upperAngle = _loc2_ + _loc1_;
            _loc2_ = this.waistJoint.GetJointAngle();
            this.waistJoint.m_lowerAngle = _loc2_ - _loc1_;
            this.waistJoint.m_upperAngle = _loc2_ + _loc1_;
            _loc2_ = this.shoulderJoint1.GetJointAngle();
            this.shoulderJoint1.m_lowerAngle = _loc2_ - _loc1_;
            this.shoulderJoint1.m_upperAngle = _loc2_ + _loc1_;
            _loc2_ = this.elbowJoint1.GetJointAngle();
            this.elbowJoint1.m_lowerAngle = _loc2_ - _loc1_;
            this.elbowJoint1.m_upperAngle = _loc2_ + _loc1_;
            _loc2_ = this.shoulderJoint2.GetJointAngle();
            this.shoulderJoint2.m_lowerAngle = _loc2_ - _loc1_;
            this.shoulderJoint2.m_upperAngle = _loc2_ + _loc1_;
            _loc2_ = this.elbowJoint2.GetJointAngle();
            this.elbowJoint2.m_lowerAngle = _loc2_ - _loc1_;
            this.elbowJoint2.m_upperAngle = _loc2_ + _loc1_;
            _loc2_ = this.hipJoint1.GetJointAngle();
            this.hipJoint1.m_lowerAngle = _loc2_ - _loc1_;
            this.hipJoint1.m_upperAngle = _loc2_ + _loc1_;
            _loc2_ = this.kneeJoint1.GetJointAngle();
            this.kneeJoint1.m_lowerAngle = _loc2_ - _loc1_;
            this.kneeJoint1.m_upperAngle = _loc2_ + _loc1_;
            _loc2_ = this.hipJoint2.GetJointAngle();
            this.hipJoint2.m_lowerAngle = _loc2_ - _loc1_;
            this.hipJoint2.m_upperAngle = _loc2_ + _loc1_;
            _loc2_ = this.kneeJoint2.GetJointAngle();
            this.kneeJoint2.m_lowerAngle = _loc2_ - _loc1_;
            this.kneeJoint2.m_upperAngle = _loc2_ + _loc1_;
        }
        
        private function releasePose() : void
        {
            trace("RELEASE POSE");
            var _loc1_:Number = this.reversed ? -1 : 1;
            this.neckJoint.m_lowerAngle = -20 / oneEightyOverPI - this.neckJoint.m_referenceAngle;
            this.neckJoint.m_upperAngle = 20 / oneEightyOverPI - this.neckJoint.m_referenceAngle;
            this.waistJoint.m_lowerAngle = -5 / oneEightyOverPI - this.waistJoint.m_referenceAngle;
            this.waistJoint.m_upperAngle = 5 / oneEightyOverPI - this.waistJoint.m_referenceAngle;
            if(this.reversed)
            {
                this.shoulderJoint1.m_lowerAngle = -60 / oneEightyOverPI - this.shoulderJoint1.m_referenceAngle;
                this.shoulderJoint1.m_upperAngle = 180 / oneEightyOverPI - this.shoulderJoint1.m_referenceAngle;
                this.shoulderJoint2.m_lowerAngle = -60 / oneEightyOverPI - this.shoulderJoint2.m_referenceAngle;
                this.shoulderJoint2.m_upperAngle = 180 / oneEightyOverPI - this.shoulderJoint2.m_referenceAngle;
                this.elbowJoint1.m_lowerAngle = 0 / oneEightyOverPI - this.elbowJoint1.m_referenceAngle;
                this.elbowJoint1.m_upperAngle = 160 / oneEightyOverPI - this.elbowJoint1.m_referenceAngle;
                this.elbowJoint2.m_lowerAngle = 0 / oneEightyOverPI - this.elbowJoint2.m_referenceAngle;
                this.elbowJoint2.m_upperAngle = 160 / oneEightyOverPI - this.elbowJoint2.m_referenceAngle;
                this.hipJoint1.m_lowerAngle = -10 / oneEightyOverPI - this.hipJoint1.m_referenceAngle;
                this.hipJoint1.m_upperAngle = 150 / oneEightyOverPI - this.hipJoint1.m_referenceAngle;
                this.hipJoint2.m_lowerAngle = -10 / oneEightyOverPI - this.hipJoint2.m_referenceAngle;
                this.hipJoint2.m_upperAngle = 150 / oneEightyOverPI - this.hipJoint2.m_referenceAngle;
                this.kneeJoint1.m_lowerAngle = -150 / oneEightyOverPI - this.kneeJoint1.m_referenceAngle;
                this.kneeJoint1.m_upperAngle = 0 / oneEightyOverPI - this.kneeJoint1.m_referenceAngle;
                this.kneeJoint2.m_lowerAngle = -150 / oneEightyOverPI - this.kneeJoint2.m_referenceAngle;
                this.kneeJoint2.m_upperAngle = 0 / oneEightyOverPI - this.kneeJoint2.m_referenceAngle;
            }
            else
            {
                this.shoulderJoint1.m_lowerAngle = -180 / oneEightyOverPI - this.shoulderJoint1.m_referenceAngle;
                this.shoulderJoint1.m_upperAngle = 60 / oneEightyOverPI - this.shoulderJoint1.m_referenceAngle;
                this.shoulderJoint2.m_lowerAngle = -180 / oneEightyOverPI - this.shoulderJoint2.m_referenceAngle;
                this.shoulderJoint2.m_upperAngle = 60 / oneEightyOverPI - this.shoulderJoint2.m_referenceAngle;
                this.elbowJoint1.m_lowerAngle = -160 / oneEightyOverPI - this.elbowJoint1.m_referenceAngle;
                this.elbowJoint1.m_upperAngle = 0 / oneEightyOverPI - this.elbowJoint1.m_referenceAngle;
                this.elbowJoint2.m_lowerAngle = -160 / oneEightyOverPI - this.elbowJoint2.m_referenceAngle;
                this.elbowJoint2.m_upperAngle = 0 / oneEightyOverPI - this.elbowJoint2.m_referenceAngle;
                this.hipJoint1.m_lowerAngle = -150 / oneEightyOverPI - this.hipJoint1.m_referenceAngle;
                this.hipJoint1.m_upperAngle = 10 / oneEightyOverPI - this.hipJoint1.m_referenceAngle;
                this.hipJoint2.m_lowerAngle = -150 / oneEightyOverPI - this.hipJoint2.m_referenceAngle;
                this.hipJoint2.m_upperAngle = 10 / oneEightyOverPI - this.hipJoint2.m_referenceAngle;
                this.kneeJoint1.m_lowerAngle = 0 / oneEightyOverPI - this.kneeJoint1.m_referenceAngle;
                this.kneeJoint1.m_upperAngle = 150 / oneEightyOverPI - this.kneeJoint1.m_referenceAngle;
                this.kneeJoint2.m_lowerAngle = 0 / oneEightyOverPI - this.kneeJoint2.m_referenceAngle;
                this.kneeJoint2.m_upperAngle = 150 / oneEightyOverPI - this.kneeJoint2.m_referenceAngle;
            }
        }
    }
}

