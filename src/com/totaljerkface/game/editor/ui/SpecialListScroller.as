package com.totaljerkface.game.editor.ui
{
    import com.totaljerkface.game.menus.ListScroller;
    import flash.display.CapsStyle;
    import flash.display.JointStyle;
    import flash.display.LineScaleMode;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    
    public class SpecialListScroller extends ListScroller
    {
        public function SpecialListScroller(param1:Sprite, param2:Sprite, param3:int = 10)
        {
            super(param1,param2,param3);
        }
        
        override protected function createParts() : void
        {
            bg = new Sprite();
            addChild(bg);
            bg.graphics.beginFill(6710886);
            bg.graphics.drawRect(0,0,12,100);
            bg.graphics.endFill();
            bg.scale9Grid = new Rectangle(2,5,8,90);
            scrollTab = new Sprite();
            addChild(scrollTab);
            scrollTab.graphics.lineStyle(0,10066329,1,true,LineScaleMode.NONE,CapsStyle.NONE,JointStyle.MITER,3);
            scrollTab.graphics.beginFill(13421772);
            scrollTab.graphics.drawRect(0,0,12,100);
            scrollTab.graphics.endFill();
            scrollTab.scale9Grid = new Rectangle(2,5,8,90);
        }
        
        override protected function mouseUpHandler(param1:MouseEvent) : void
        {
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,updateContent);
            stopScrollDrag();
        }
    }
}

