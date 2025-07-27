package com.totaljerkface.game.editor
{
    import com.totaljerkface.game.editor.ui.GenericButton;
    
    public class FunctionReference
    {
        public function FunctionReference()
        {
            super();
        }
        
        public static function buildButton(param1:String) : GenericButton
        {
            var _loc2_:GenericButton = null;
            switch(param1)
            {
                case "groupSelected":
                    _loc2_ = new GenericButton("Group Items",16613761,120);
                    break;
                case "breakSelectedGroups":
                    _loc2_ = new GenericButton("Break Group",16613761,120);
                    break;
                case "convertGroupToVehicle":
                    _loc2_ = new GenericButton("Set as Vehicle",16776805,120,0);
                    break;
                case "convertVehicleToGroup":
                    _loc2_ = new GenericButton("Revert to Group",16613761,120);
                    break;
                case "setShapeAsHandle":
                    _loc2_ = new GenericButton("Set as Handle",16776805,120,0);
                    break;
                case "removeHandleProperty":
                    _loc2_ = new GenericButton("Remove Handle",16613761,120);
                    break;
                case "addNewTarget":
                    _loc2_ = new GenericButton("Add New Target",16776805,120,0);
                    break;
                case "removeTarget":
                    _loc2_ = new GenericButton("Remove Target",16613761,120);
                    break;
                case "resetScale":
                    _loc2_ = new GenericButton("Reset Scale",16613761,120);
                    break;
                case "reverseShape":
                    _loc2_ = new GenericButton("Reverse Shape",16613761,120);
                    break;
                default:
                    return null;
            }
            _loc2_.functionString = param1;
            return _loc2_;
        }
    }
}

