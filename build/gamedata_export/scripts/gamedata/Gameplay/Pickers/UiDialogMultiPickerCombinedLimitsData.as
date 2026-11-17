package gamedata.Gameplay.Pickers
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class UiDialogMultiPickerCombinedLimitsData extends OlympusObject
   {
      
      public var picker_ids:Array = [uint];
      
      public var max_selectable:uint;
      
      public var min_selectable:uint;
      
      public var min_selectable_tooltip:LocKey = new LocKey();
      
      public var max_selectable_tooltip:LocKey = new LocKey();
      
      public function UiDialogMultiPickerCombinedLimitsData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         this.min_selectable_tooltip = FixupLocKey(this.min_selectable_tooltip);
         this.max_selectable_tooltip = FixupLocKey(this.max_selectable_tooltip);
      }
      
      public function GetAffectedPickerIds(param1:uint) : Array
      {
         var pickerId:uint = param1;
         if(pickerId == 0)
         {
            return this.picker_ids;
         }
         if(this.picker_ids.indexOf(pickerId) == -1)
         {
            return [];
         }
         return this.picker_ids.filter(function(param1:uint):Boolean
         {
            return param1 != pickerId;
         });
      }
      
      protected function GetSelectionCount(param1:Object) : int
      {
         var _loc3_:uint = 0;
         var _loc4_:Array = null;
         var _loc2_:uint = 0;
         for each(_loc3_ in this.picker_ids)
         {
            _loc4_ = param1[_loc3_];
            if(_loc4_ != null)
            {
               _loc2_ += _loc4_.length;
            }
         }
         return _loc2_;
      }
      
      public function GetTotalFree(param1:Object) : int
      {
         if(this.max_selectable == 0)
         {
            return int.MAX_VALUE;
         }
         return this.max_selectable - this.GetSelectionCount(param1);
      }
      
      public function GetErrorTooltip(param1:Object) : LocKey
      {
         var _loc2_:uint = uint(this.GetSelectionCount(param1));
         if(_loc2_ < this.min_selectable)
         {
            return this.min_selectable_tooltip;
         }
         if(this.max_selectable != 0 && _loc2_ > this.max_selectable)
         {
            return this.max_selectable_tooltip;
         }
         return null;
      }
   }
}

