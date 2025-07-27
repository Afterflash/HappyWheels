package com.totaljerkface.game.editor.poser
{
    import Box2D.Common.Math.b2Vec2;
    import com.totaljerkface.game.editor.ActionEvent;
    import com.totaljerkface.game.editor.actions.*;
    import com.totaljerkface.game.editor.specials.NPCharacterRef;
    import com.totaljerkface.game.editor.specials.npcsprites.NPCSprite;
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;
    
    public class Poser extends Sprite
    {
        public static const POSE_COMPLETE:String = "posecomplete";
        
        private var npcRef:NPCharacterRef;
        
        private var bodyHolder:Sprite;
        
        private var head:Sprite;
        
        private var chest:Sprite;
        
        private var pelvis:Sprite;
        
        private var upperArm1:Sprite;
        
        private var upperArm2:Sprite;
        
        private var lowerArm1:Sprite;
        
        private var lowerArm2:Sprite;
        
        private var upperLeg1:Sprite;
        
        private var upperLeg2:Sprite;
        
        private var lowerLeg1:Sprite;
        
        private var lowerLeg2:Sprite;
        
        private var headSegment:PoserSegment;
        
        private var upperArm1Segment:PoserSegment;
        
        private var upperArm2Segment:PoserSegment;
        
        private var lowerArm1Segment:PoserSegment;
        
        private var lowerArm2Segment:PoserSegment;
        
        private var upperLeg1Segment:PoserSegment;
        
        private var upperLeg2Segment:PoserSegment;
        
        private var lowerLeg1Segment:PoserSegment;
        
        private var lowerLeg2Segment:PoserSegment;
        
        private var currentSegment:PoserSegment;
        
        private var spriteSegments:Dictionary;
        
        private var segmentProperties:Dictionary;
        
        public function Poser(param1:NPCharacterRef)
        {
            super();
            this.npcRef = param1;
            param1.npcSprite.visible = false;
            addEventListener(Event.ADDED_TO_STAGE,this.init);
        }
        
        private function init(param1:Event) : void
        {
            var _loc5_:NPCSprite = null;
            var _loc7_:DisplayObject = null;
            removeEventListener(Event.ADDED_TO_STAGE,this.init);
            var _loc2_:int = 20000;
            var _loc3_:int = 10000;
            graphics.beginFill(10066329,0.35);
            graphics.drawRect(0,0,_loc2_,_loc3_);
            graphics.endFill();
            var _loc4_:Class = getDefinitionByName("com.totaljerkface.game.editor.specials.npcsprites.NPCSprite" + this.npcRef.charIndex) as Class;
            _loc5_ = new _loc4_();
            this.bodyHolder = new Sprite();
            addChild(this.bodyHolder);
            this.bodyHolder.scaleY = 0.5;
            this.bodyHolder.scaleX = this.npcRef.reverse ? -0.5 : 0.5;
            this.bodyHolder.x = this.npcRef.x;
            this.bodyHolder.y = this.npcRef.y;
            this.bodyHolder.rotation = this.npcRef.rotation;
            this.head = _loc5_.headOuter;
            this.chest = _loc5_.chest;
            this.pelvis = _loc5_.pelvis;
            this.upperArm1 = _loc5_.arm1;
            this.upperArm2 = _loc5_.arm2;
            this.lowerArm1 = _loc5_.lowerArmOuter1;
            this.lowerArm2 = _loc5_.lowerArmOuter2;
            this.upperLeg1 = _loc5_.leg1;
            this.upperLeg2 = _loc5_.leg2;
            this.lowerLeg1 = _loc5_.lowerLegOuter1;
            this.lowerLeg2 = _loc5_.lowerLegOuter2;
            this.head.mouseChildren = this.chest.mouseChildren = this.pelvis.mouseChildren = false;
            this.upperArm1.mouseChildren = this.lowerArm1.mouseChildren = this.upperArm2.mouseChildren = this.lowerArm2.mouseChildren = false;
            this.upperLeg1.mouseChildren = this.lowerLeg1.mouseChildren = this.upperLeg2.mouseChildren = this.lowerLeg2.mouseChildren = false;
            this.chest.mouseEnabled = this.pelvis.mouseEnabled = false;
            var _loc6_:int = 6;
            while(_loc6_ > -1)
            {
                _loc7_ = _loc5_.getChildAt(_loc6_);
                switch(_loc7_)
                {
                    case this.upperArm1:
                        this.bodyHolder.addChildAt(this.lowerArm1,0);
                        break;
                    case this.upperArm2:
                        this.bodyHolder.addChildAt(this.lowerArm2,0);
                        break;
                    case this.upperLeg1:
                        this.bodyHolder.addChildAt(this.lowerLeg1,0);
                        break;
                    case this.upperLeg2:
                        this.bodyHolder.addChildAt(this.lowerLeg2,0);
                        break;
                }
                this.bodyHolder.addChildAt(_loc7_,0);
                _loc6_--;
            }
            this.lowerArm1.x = this.upperArm1.x + this.lowerArm1.x;
            this.lowerArm1.y = this.upperArm1.y + this.lowerArm1.y;
            this.lowerArm2.x = this.upperArm2.x + this.lowerArm2.x;
            this.lowerArm2.y = this.upperArm2.y + this.lowerArm2.y;
            this.lowerLeg1.x = this.upperLeg1.x + this.lowerLeg1.x;
            this.lowerLeg1.y = this.upperLeg1.y + this.lowerLeg1.y;
            this.lowerLeg2.x = this.upperLeg2.x + this.lowerLeg2.x;
            this.lowerLeg2.y = this.upperLeg2.y + this.lowerLeg2.y;
            this.headSegment = new PoserSegment(this.head,new b2Vec2(this.head.x + _loc5_.head.x,this.head.y + _loc5_.head.y),-90,-20,20);
            this.upperArm1Segment = new PoserSegment(this.upperArm1,new b2Vec2(this.lowerArm1.x,this.lowerArm1.y),90,-180,60);
            this.upperArm2Segment = new PoserSegment(this.upperArm2,new b2Vec2(this.lowerArm2.x,this.lowerArm2.y),90,-180,60);
            this.lowerArm1Segment = new PoserSegment(this.lowerArm1,new b2Vec2(this.lowerArm1.x,this.lowerArm1.y + this.lowerArm1.height * 0.8),90,-160,0,this.upperArm1Segment);
            this.lowerArm2Segment = new PoserSegment(this.lowerArm2,new b2Vec2(this.lowerArm2.x,this.lowerArm2.y + this.lowerArm2.height * 0.8),90,-160,0,this.upperArm2Segment);
            this.upperLeg1Segment = new PoserSegment(this.upperLeg1,new b2Vec2(this.lowerLeg1.x,this.lowerLeg1.y),90,-150,10);
            this.upperLeg2Segment = new PoserSegment(this.upperLeg2,new b2Vec2(this.lowerLeg2.x,this.lowerLeg2.y),90,-150,10);
            this.lowerLeg1Segment = new PoserSegment(this.lowerLeg1,new b2Vec2(this.lowerLeg1.x,this.lowerLeg1.y + this.lowerLeg1.height * 0.8),90,0,150,this.upperLeg1Segment);
            this.lowerLeg2Segment = new PoserSegment(this.lowerLeg2,new b2Vec2(this.lowerLeg2.x,this.lowerLeg2.y + this.lowerLeg2.height * 0.8),90,0,150,this.upperLeg2Segment);
            this.spriteSegments = new Dictionary();
            this.spriteSegments[this.head] = this.headSegment;
            this.spriteSegments[this.upperArm1] = this.upperArm1Segment;
            this.spriteSegments[this.lowerArm1] = this.lowerArm1Segment;
            this.spriteSegments[this.upperArm2] = this.upperArm2Segment;
            this.spriteSegments[this.lowerArm2] = this.lowerArm2Segment;
            this.spriteSegments[this.upperLeg1] = this.upperLeg1Segment;
            this.spriteSegments[this.lowerLeg1] = this.lowerLeg1Segment;
            this.spriteSegments[this.upperLeg2] = this.upperLeg2Segment;
            this.spriteSegments[this.lowerLeg2] = this.lowerLeg2Segment;
            this.segmentProperties = new Dictionary();
            this.segmentProperties[this.headSegment] = "neckAngle";
            this.segmentProperties[this.upperArm1Segment] = "shoulder1Angle";
            this.segmentProperties[this.lowerArm1Segment] = "elbow1Angle";
            this.segmentProperties[this.upperArm2Segment] = "shoulder2Angle";
            this.segmentProperties[this.lowerArm2Segment] = "elbow2Angle";
            this.segmentProperties[this.upperLeg1Segment] = "hip1Angle";
            this.segmentProperties[this.lowerLeg1Segment] = "knee1Angle";
            this.segmentProperties[this.upperLeg2Segment] = "hip2Angle";
            this.segmentProperties[this.lowerLeg2Segment] = "knee2Angle";
            this.matchRealCharacter();
            doubleClickEnabled = true;
            stage.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler,false,0,true);
            stage.addEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler,false,0,true);
            addEventListener(MouseEvent.DOUBLE_CLICK,this.doubleClickHandler);
        }
        
        private function matchRealCharacter() : void
        {
            this.headSegment.modelAngleDegrees = this.npcRef.neckAngle;
            this.upperArm1Segment.modelAngleDegrees = this.npcRef.shoulder1Angle;
            this.upperArm2Segment.modelAngleDegrees = this.npcRef.shoulder2Angle;
            this.lowerArm1Segment.modelAngleDegrees = this.npcRef.elbow1Angle;
            this.lowerArm2Segment.modelAngleDegrees = this.npcRef.elbow2Angle;
            this.upperLeg1Segment.modelAngleDegrees = this.npcRef.hip1Angle;
            this.upperLeg2Segment.modelAngleDegrees = this.npcRef.hip2Angle;
            this.lowerLeg1Segment.modelAngleDegrees = this.npcRef.knee1Angle;
            this.lowerLeg2Segment.modelAngleDegrees = this.npcRef.knee2Angle;
        }
        
        private function setRealCharacter() : void
        {
            this.npcRef.neckAngle = this.headSegment.modelAngleDegrees;
            this.npcRef.shoulder1Angle = this.upperArm1Segment.modelAngleDegrees;
            this.npcRef.shoulder2Angle = this.upperArm2Segment.modelAngleDegrees;
            this.npcRef.elbow1Angle = this.lowerArm1Segment.modelAngleDegrees;
            this.npcRef.elbow2Angle = this.lowerArm2Segment.modelAngleDegrees;
            this.npcRef.hip1Angle = this.upperLeg1Segment.modelAngleDegrees;
            this.npcRef.hip2Angle = this.upperLeg2Segment.modelAngleDegrees;
            this.npcRef.knee1Angle = this.lowerLeg1Segment.modelAngleDegrees;
            this.npcRef.knee2Angle = this.lowerLeg2Segment.modelAngleDegrees;
        }
        
        private function mouseDownHandler(param1:MouseEvent) : void
        {
            if(this.spriteSegments[param1.target])
            {
                this.currentSegment = this.spriteSegments[param1.target] as PoserSegment;
                this.dragIK();
                stage.addEventListener(MouseEvent.MOUSE_MOVE,this.dragIK);
                stage.addEventListener(MouseEvent.MOUSE_UP,this.endIKDrag);
                stage.removeEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
            }
        }
        
        private function dragIK(param1:MouseEvent = null) : void
        {
            PoserSolver.solve(this.bodyHolder.mouseX,this.bodyHolder.mouseY,this.currentSegment);
        }
        
        private function endIKDrag(param1:MouseEvent) : void
        {
            var _loc2_:Action = null;
            var _loc3_:Action = null;
            var _loc4_:String = null;
            if(this.currentSegment)
            {
                stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.dragIK);
                stage.removeEventListener(MouseEvent.MOUSE_UP,this.endIKDrag);
                stage.addEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler,false,0,true);
                _loc4_ = this.segmentProperties[this.currentSegment];
                _loc2_ = this.npcRef.setProperty(_loc4_,this.currentSegment.modelAngleDegrees);
                if(this.currentSegment.parentSegment)
                {
                    _loc4_ = this.segmentProperties[this.currentSegment.parentSegment];
                    _loc3_ = this.npcRef.setProperty(_loc4_,this.currentSegment.parentSegment.modelAngleDegrees);
                    if(_loc3_)
                    {
                        if(_loc2_)
                        {
                            _loc3_.nextAction = _loc2_;
                        }
                        else
                        {
                            _loc2_ = _loc3_;
                        }
                    }
                }
                if(_loc2_)
                {
                    dispatchEvent(new ActionEvent(ActionEvent.GENERIC,_loc2_));
                }
                this.currentSegment = null;
            }
        }
        
        private function mouseOverHandler(param1:MouseEvent) : void
        {
            if(param1.target == this.upperArm2 || param1.target == this.lowerArm2)
            {
                this.chest.alpha = this.pelvis.alpha = 0.4;
            }
            else
            {
                this.chest.alpha = this.pelvis.alpha = 1;
            }
        }
        
        private function doubleClickHandler(param1:MouseEvent) : void
        {
            dispatchEvent(new Event(POSE_COMPLETE));
        }
        
        public function die() : void
        {
            this.npcRef.npcSprite.visible = true;
            this.segmentProperties = null;
            this.spriteSegments = null;
            stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.dragIK);
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.endIKDrag);
            stage.removeEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
            removeEventListener(MouseEvent.DOUBLE_CLICK,this.doubleClickHandler);
            removeEventListener(Event.ADDED_TO_STAGE,this.init);
            if(parent)
            {
                parent.removeChild(this);
            }
        }
    }
}

