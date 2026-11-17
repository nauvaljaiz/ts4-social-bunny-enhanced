package gamedata.CAS.SimSelector
{
   import olympus.core.OlympusObject;
   import olympus.errors.Assert;
   import olympus.io.CommunicationManager;
   import olympus.utils.ArrayUtils;
   
   public class AddSimMenuData extends OlympusObject
   {
      
      protected static var sMenuData:AddSimMenuData = null;
      
      public var menu_items:Array = [AddSimMenuItemData];
      
      public function AddSimMenuData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function Load() : AddSimMenuData
      {
         if(sMenuData == null)
         {
            sMenuData = new AddSimMenuData(CommunicationManager.CallGameService("CasGetAddSimMenuData"));
         }
         return sMenuData;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         var _loc6_:int = 0;
         var _loc7_:AddSimMenuItemData = null;
         var _loc8_:int = 0;
         super.ParseObject(param1);
         FixupArray(this.menu_items);
         this.menu_items.sortOn("uiSortIndex",Array.NUMERIC);
         var _loc2_:AddSimMenuItemData = null;
         var _loc3_:Array = [];
         var _loc4_:uint = 0;
         var _loc5_:uint = this.menu_items.length;
         while(_loc4_ < _loc5_)
         {
            _loc7_ = this.menu_items[_loc4_];
            if(_loc7_.parent_index == 0)
            {
               if(_loc2_ != null)
               {
                  _loc2_.sub_items.sortOn("uiSortIndex",Array.NUMERIC);
               }
               _loc2_ = _loc7_;
            }
            else if(_loc7_.parent_index != _loc2_.uiSortIndex)
            {
               Assert.Throw("Add Sim Menu item shows a parent index of " + _loc7_.parent_index + " but the current parent index is " + _loc2_.uiSortIndex + ". The tuning in cas.cas_tuning is probably out of order. The Add Sim menu will be busted until the tuning is fixed. -trevor");
            }
            else
            {
               _loc2_.sub_items.push(_loc7_);
               _loc3_.push(_loc7_.uiSortIndex);
            }
            _loc4_++;
         }
         for each(_loc6_ in _loc3_)
         {
            _loc8_ = ArrayUtils.IndexOfByFieldName(this.menu_items,"uiSortIndex",_loc6_);
            if(_loc8_ != -1)
            {
               this.menu_items.splice(_loc8_,1);
            }
         }
      }
   }
}

