package gamedata.Gameplay.SimInfoHUD
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class TraitBasedUIOverrideMapping extends OlympusObject
   {
      
      public var trait_id:String;
      
      public var data_description:LocKey = new LocKey();
      
      public var fill_color:Number;
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var stat_name:LocKey = new LocKey();
      
      public var tooltip_icon_list:Array = [ResourceKey];
      
      public var priority:int = 0;
      
      public function TraitBasedUIOverrideMapping(param1:Object = null)
      {
         super(param1);
         this.stat_name = FixupLocKey(this.stat_name);
         this.data_description = FixupLocKey(this.data_description);
         FixupArray(this.tooltip_icon_list);
      }
      
      public static function GroupOverridesByDescendingPriority(param1:Array) : void
      {
         var _loc4_:TraitBasedUIOverrideMapping = null;
         var _loc5_:int = 0;
         var _loc6_:* = 0;
         var _loc7_:int = 0;
         if(param1.length <= 1)
         {
            return;
         }
         var _loc2_:int = int(param1[0].priority);
         var _loc3_:int = 1;
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1[_loc3_];
            _loc5_ = _loc4_.priority;
            if(_loc5_ > _loc2_)
            {
               _loc6_ = int(_loc3_ - 1);
               while(_loc6_ >= 0)
               {
                  _loc7_ = int(param1[_loc6_].priority);
                  if(_loc7_ >= _loc5_)
                  {
                     param1.splice(_loc3_,1);
                     param1.splice(_loc6_,0,_loc4_);
                  }
                  else if(_loc6_ == 0)
                  {
                     param1.splice(_loc3_,1);
                     param1.unshift(_loc4_);
                  }
                  _loc6_--;
               }
            }
            else if(_loc5_ < _loc2_)
            {
               _loc2_ = _loc5_;
            }
            _loc3_++;
         }
      }
   }
}

