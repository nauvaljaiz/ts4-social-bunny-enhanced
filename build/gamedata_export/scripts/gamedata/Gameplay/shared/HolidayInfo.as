package gamedata.Gameplay.shared
{
   import gamedata.Gameplay.shared.definitions.HolidayTraditionStaticData;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class HolidayInfo extends OlympusObject
   {
      
      public var holiday_type:String;
      
      public var name:LocKey = new LocKey();
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var time_off_for_work:Boolean;
      
      public var time_off_for_school:Boolean;
      
      public var traditions:Array = [String];
      
      public var max_traditions:uint;
      
      public var can_be_modified:Boolean;
      
      public var lot_decoration_preset:String;
      
      public function HolidayInfo(param1:Object = null)
      {
         super(param1);
         FixupArray(this.traditions);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!this.name.IsValid)
         {
            this.name = null;
         }
      }
      
      public function GetAllTraditionCoreTags() : Array
      {
         var _loc1_:Array = null;
         var _loc2_:HolidayTraditionStaticData = null;
         var _loc3_:String = null;
         for each(_loc3_ in this.traditions)
         {
            _loc2_ = HolidayTraditionStaticData.GetStaticData(_loc3_);
            if(Boolean(_loc2_) && Boolean(_loc2_.core_object_tags.length))
            {
               _loc1_ = _loc1_ ? _loc1_.concat(_loc2_.core_object_tags) : _loc2_.core_object_tags;
            }
         }
         return _loc1_;
      }
      
      public function GetAllTraditionDecoTags() : Array
      {
         var _loc1_:Array = null;
         var _loc2_:HolidayTraditionStaticData = null;
         var _loc3_:String = null;
         for each(_loc3_ in this.traditions)
         {
            _loc2_ = HolidayTraditionStaticData.GetStaticData(_loc3_);
            if(Boolean(_loc2_) && Boolean(_loc2_.deco_object_tags.length))
            {
               _loc1_ = _loc1_ ? _loc1_.concat(_loc2_.deco_object_tags) : _loc2_.deco_object_tags;
            }
         }
         return _loc1_;
      }
   }
}

