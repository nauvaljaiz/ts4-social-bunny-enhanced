package gamedata.Gameplay.Business
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class BusinessSummaryEntry extends OlympusObject
   {
      
      public static const BUSINESS_SUMMARY_ENTRY_TYPE_DEFAULT:int = 0;
      
      public static const BUSINESS_SUMMARY_ENTRY_TYPE_TOTAL:int = 1;
      
      public static const BUSINESS_SUMMARY_ENTRY_TYPE_SUB_TOTAL:int = 2;
      
      public static const BUSINESS_SUMMARY_ENTRY_TYPE_WITH_BEVEL:int = 3;
      
      public static const BUSINESS_SUMMARY_ENTRY_TYPE_WITH_SUBTITLE:int = 4;
      
      public static const BUSINESS_SUMMARY_ENTRY_TYPE_TOTAL_WITH_BUCKS:int = 5;
      
      public static const BUSINESS_SUMMARY_ENTRY_TYPE_CUSTOM_BACKGROUND:int = 6;
      
      public var entry_name:LocKey = new LocKey();
      
      public var entry_value:LocKey = new LocKey();
      
      public var entry_type:int = 0;
      
      public var entry_subtitle:LocKey = new LocKey();
      
      public var entry_bucks:LocKey = new LocKey();
      
      public var tooltip:LocKey = new LocKey();
      
      public var is_locked:Boolean = false;
      
      public function BusinessSummaryEntry(param1:Object = null)
      {
         super(param1);
      }
   }
}

