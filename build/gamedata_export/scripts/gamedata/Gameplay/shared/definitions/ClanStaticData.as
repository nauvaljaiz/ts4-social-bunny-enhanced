package gamedata.Gameplay.shared.definitions
{
   import flash.utils.getDefinitionByName;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   
   public class ClanStaticData extends OlympusObject
   {
      
      protected static var sDataMap:Object;
      
      public static const CLAN_ALLIANCE_STATE_ALLIED:int = 0;
      
      public static const CLAN_ALLIANCE_STATE_NEUTRAL:int = 1;
      
      public static const CLAN_ALLIANCE_STATE_FEUDING:int = 2;
      
      public var clan_id:String;
      
      public var name:LocKey = new LocKey();
      
      public var description:LocKey = new LocKey();
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var tooltip:LocKey = new LocKey();
      
      public var clan_hierarchy_ranked_stat:String;
      
      public var clan_value_ids:Array = [String];
      
      public function ClanStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get StaticDataMap() : Object
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:ClanStaticData = null;
         if(!sDataMap)
         {
            sDataMap = new Object();
            _loc1_ = CommunicationManager.CallGameService("GetAllClans") as Array;
            _loc2_ = int(_loc1_.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = new ClanStaticData(_loc1_[_loc3_]);
               sDataMap[_loc4_.clan_id] = _loc4_;
               _loc3_++;
            }
         }
         return sDataMap;
      }
      
      public static function GetStaticData(param1:String) : ClanStaticData
      {
         return StaticDataMap[param1];
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         this.name = FixupLocKey(this.name);
         this.description = FixupLocKey(this.description);
         this.tooltip = FixupLocKey(this.tooltip);
         FixupArray(this.clan_value_ids);
      }
   }
}

