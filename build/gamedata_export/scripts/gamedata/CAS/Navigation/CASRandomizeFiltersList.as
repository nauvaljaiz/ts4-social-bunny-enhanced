package gamedata.CAS.Navigation
{
   import olympus.core.OlympusObject;
   import olympus.localization.KeysCAS;
   
   public class CASRandomizeFiltersList extends OlympusObject
   {
      
      public var allFlags:uint = 0;
      
      public var flagItems:Array = [CASRandomizeFilter];
      
      public var allItemIndex:int = -1;
      
      public function CASRandomizeFiltersList(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.flagItems);
         var _loc2_:CASRandomizeFilter = null;
         if(this.flagItems.length > 1)
         {
            _loc2_ = new CASRandomizeFilter();
            _loc2_.name = KeysCAS.RANDOMIZE_PROFILE_ALL;
            _loc2_.flags = this.allFlags;
            _loc2_.uiSortOrder = 0;
            this.flagItems.push(_loc2_);
         }
         this.flagItems.sortOn("uiSortOrder",Array.NUMERIC);
         this.allItemIndex = this.flagItems.indexOf(_loc2_);
      }
   }
}

