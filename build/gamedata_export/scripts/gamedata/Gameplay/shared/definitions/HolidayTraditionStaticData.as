package gamedata.Gameplay.shared.definitions
{
   import flash.utils.getDefinitionByName;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class HolidayTraditionStaticData extends OlympusObject
   {
      
      public static var sGetStaticDataFunc:Function;
      
      public static const TYPE_HOLIDAY_TRADITION:* = 0;
      
      public static const TYPE_SITUATION_ACTIVITY:* = 1;
      
      protected static var sTraditionMap:Object = new Object();
      
      public var id:String;
      
      public var tradition_type:int;
      
      public var selectable:Boolean;
      
      public var name:LocKey;
      
      public var description:LocKey;
      
      public var icon:ResourceKey;
      
      public var core_object_tags:Array = [uint];
      
      public var deco_object_tags:Array = [uint];
      
      public var show_icon:Boolean = false;
      
      public function HolidayTraditionStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetStaticData(param1:String) : HolidayTraditionStaticData
      {
         var _loc2_:HolidayTraditionStaticData = sTraditionMap[param1];
         if(_loc2_)
         {
            return _loc2_;
         }
         var _loc3_:Array = sGetStaticDataFunc([param1]);
         if(_loc3_[0])
         {
            _loc2_ = new HolidayTraditionStaticData(_loc3_[0]);
            sTraditionMap[param1] = _loc2_;
            return _loc2_;
         }
         return null;
      }
      
      public static function SortingFunction(param1:HolidayTraditionStaticData, param2:HolidayTraditionStaticData) : Number
      {
         return param1.name.toString().localeCompare(param2.name.toString());
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if("name" in param1)
         {
            this.name = new LocKey(param1.name);
         }
         if("description" in param1)
         {
            this.description = new LocKey(param1.description);
         }
         if("icon" in param1)
         {
            this.icon = new ResourceKey(param1.icon);
         }
         FixupArray(this.core_object_tags);
         FixupArray(this.deco_object_tags);
      }
   }
}

