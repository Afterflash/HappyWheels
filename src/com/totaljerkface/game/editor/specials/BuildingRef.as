package com.totaljerkface.game.editor.specials
{
    import com.totaljerkface.game.editor.RefSprite;
    import flash.display.BitmapData;
    
    public class BuildingRef extends Special
    {
        protected var tileWidth:Number = 300;
        
        protected var tileHeight:Number = 165;
        
        protected var roofHeight:Number = 100;
        
        protected var minFloors:int = 3;
        
        protected var maxFloors:int = 50;
        
        protected var minFloorWidth:int = 1;
        
        protected var maxFloorWidth:int = 10;
        
        protected var _numFloors:int = 3;
        
        protected var _floorWidth:int = 1;
        
        protected var roofBMD:BitmapData;
        
        protected var floorBMD:BitmapData;
        
        public function BuildingRef()
        {
            super();
            _shapesUsed = 1;
            rotatable = false;
            scalable = false;
            mouseChildren = false;
            this.createTextures();
            this.drawBuilding();
        }
        
        override public function setAttributes() : void
        {
            _type = "BuildingRef";
            _attributes = ["x","y","floorWidth","numFloors"];
        }
        
        protected function createTextures() : void
        {
        }
        
        protected function drawBuilding() : void
        {
        }
        
        override public function clone() : RefSprite
        {
            var _loc1_:BuildingRef = null;
            _loc1_ = new BuildingRef();
            _loc1_.x = x;
            _loc1_.y = y;
            _loc1_.numFloors = this._numFloors;
            _loc1_.floorWidth = this._floorWidth;
            return _loc1_;
        }
        
        public function get numFloors() : int
        {
            return this._numFloors;
        }
        
        public function set numFloors(param1:int) : void
        {
            if(param1 < this.minFloors)
            {
                param1 = this.minFloors;
            }
            if(param1 > this.maxFloors)
            {
                param1 = this.maxFloors;
            }
            if(this._numFloors == param1)
            {
                return;
            }
            this._numFloors = param1;
            this.drawBuilding();
            if(_selected)
            {
                drawBoundingBox();
            }
            x = x;
            y = y;
        }
        
        public function get floorWidth() : int
        {
            return this._floorWidth;
        }
        
        public function set floorWidth(param1:int) : void
        {
            if(param1 < this.minFloorWidth)
            {
                param1 = this.minFloorWidth;
            }
            if(param1 > this.maxFloorWidth)
            {
                param1 = this.maxFloorWidth;
            }
            if(this._floorWidth == param1)
            {
                return;
            }
            this._floorWidth = param1;
            this.drawBuilding();
            if(_selected)
            {
                drawBoundingBox();
            }
            x = x;
            y = y;
        }
    }
}

