package com.totaljerkface.game.editor.specials.npcsprites
{
    import flash.display.Sprite;
    
    public class NPCSprite extends Sprite
    {
        public var headOuter:Sprite;
        
        public var chest:Sprite;
        
        public var pelvis:Sprite;
        
        public var arm1:Sprite;
        
        public var arm2:Sprite;
        
        public var leg1:Sprite;
        
        public var leg2:Sprite;
        
        public var head:Sprite;
        
        public var upperArm1:Sprite;
        
        public var upperArm2:Sprite;
        
        public var lowerArm1:Sprite;
        
        public var lowerArm2:Sprite;
        
        public var lowerArmOuter1:Sprite;
        
        public var lowerArmOuter2:Sprite;
        
        public var upperLeg1:Sprite;
        
        public var upperLeg2:Sprite;
        
        public var lowerLeg1:Sprite;
        
        public var lowerLeg2:Sprite;
        
        public var lowerLegOuter1:Sprite;
        
        public var lowerLegOuter2:Sprite;
        
        public var headShape:Sprite;
        
        public var chestShape:Sprite;
        
        public var pelvisShape:Sprite;
        
        public var upperArm1Shape:Sprite;
        
        public var upperArm2Shape:Sprite;
        
        public var lowerArm1Shape:Sprite;
        
        public var lowerArm2Shape:Sprite;
        
        public var upperLeg1Shape:Sprite;
        
        public var upperLeg2Shape:Sprite;
        
        public var lowerLeg1Shape:Sprite;
        
        public var lowerLeg2Shape:Sprite;
        
        public function NPCSprite()
        {
            super();
            mouseEnabled = false;
            mouseChildren = false;
            this.head = this.headOuter.getChildByName("head") as Sprite;
            this.upperArm1 = this.arm1.getChildByName("upperArm1") as Sprite;
            this.upperArm2 = this.arm2.getChildByName("upperArm2") as Sprite;
            this.lowerArmOuter1 = this.arm1.getChildByName("lowerArmOuter1") as Sprite;
            this.lowerArmOuter2 = this.arm2.getChildByName("lowerArmOuter2") as Sprite;
            this.lowerArm1 = this.lowerArmOuter1.getChildByName("lowerArm1") as Sprite;
            this.lowerArm2 = this.lowerArmOuter2.getChildByName("lowerArm2") as Sprite;
            this.upperLeg1 = this.leg1.getChildByName("upperLeg1") as Sprite;
            this.upperLeg2 = this.leg2.getChildByName("upperLeg2") as Sprite;
            this.lowerLegOuter1 = this.leg1.getChildByName("lowerLegOuter1") as Sprite;
            this.lowerLegOuter2 = this.leg2.getChildByName("lowerLegOuter2") as Sprite;
            this.lowerLeg1 = this.lowerLegOuter1.getChildByName("lowerLeg1") as Sprite;
            this.lowerLeg2 = this.lowerLegOuter2.getChildByName("lowerLeg2") as Sprite;
            this.headShape = this.head.getChildByName("shape") as Sprite;
            this.chestShape = this.chest.getChildByName("shape") as Sprite;
            this.pelvisShape = this.pelvis.getChildByName("shape") as Sprite;
            this.upperArm1Shape = this.upperArm1.getChildByName("shape") as Sprite;
            this.upperArm2Shape = this.upperArm2.getChildByName("shape") as Sprite;
            this.lowerArm1Shape = this.lowerArm1.getChildByName("shape") as Sprite;
            this.lowerArm2Shape = this.lowerArm2.getChildByName("shape") as Sprite;
            this.upperLeg1Shape = this.upperLeg1.getChildByName("shape") as Sprite;
            this.upperLeg2Shape = this.upperLeg2.getChildByName("shape") as Sprite;
            this.lowerLeg1Shape = this.lowerLeg1.getChildByName("shape") as Sprite;
            this.lowerLeg2Shape = this.lowerLeg2.getChildByName("shape") as Sprite;
            this.headShape.visible = this.chestShape.visible = this.pelvisShape.visible = this.upperArm1Shape.visible = this.upperArm2Shape.visible = this.lowerArm1Shape.visible = this.lowerArm2Shape.visible = this.upperLeg1Shape.visible = this.upperLeg2Shape.visible = this.lowerLeg1Shape.visible = this.lowerLeg2Shape.visible = false;
        }
        
        public function removeShapes() : void
        {
            this.head.removeChild(this.headShape);
            this.chest.removeChild(this.chestShape);
            this.pelvis.removeChild(this.pelvisShape);
            this.upperArm1.removeChild(this.upperArm1Shape);
            this.upperArm2.removeChild(this.upperArm2Shape);
            this.lowerArm1.removeChild(this.lowerArm1Shape);
            this.lowerArm2.removeChild(this.lowerArm2Shape);
            this.upperLeg1.removeChild(this.upperLeg1Shape);
            this.upperLeg2.removeChild(this.upperLeg2Shape);
            this.lowerLeg1.removeChild(this.lowerLeg1Shape);
            this.lowerLeg2.removeChild(this.lowerLeg2Shape);
            this.headShape = null;
            this.chestShape = null;
            this.pelvisShape = null;
            this.upperArm1Shape = null;
            this.upperArm2Shape = null;
            this.lowerArm1Shape = null;
            this.lowerArm2Shape = null;
            this.upperLeg1Shape = null;
            this.upperLeg2Shape = null;
            this.lowerLeg1Shape = null;
            this.lowerLeg2Shape = null;
        }
    }
}

