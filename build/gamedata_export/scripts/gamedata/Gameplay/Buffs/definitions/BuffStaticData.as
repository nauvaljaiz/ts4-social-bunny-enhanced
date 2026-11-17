package gamedata.Gameplay.Buffs.definitions
{
   import flash.utils.getDefinitionByName;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class BuffStaticData extends OlympusObject
   {
      
      protected static var sBuffStaticData:Vector.<BuffStaticData>;
      
      public static var sGetStaticDataFunc:Function;
      
      protected static var sBuffMap:Object = new Object();
      
      public var audio_sting_on_add:ResourceKey = new ResourceKey();
      
      public var audio_sting_on_remove:ResourceKey = new ResourceKey();
      
      public var description:LocKey = new LocKey();
      
      public var name:LocKey = new LocKey();
      
      public var iconInfo:ResourceKey = new ResourceKey();
      
      public var sortOrder:int;
      
      public var moodType:String;
      
      public var moodWeight:uint;
      
      public var timeout_string:LocKey = new LocKey();
      
      public var timeout_string_no_next_buff:LocKey = new LocKey();
      
      public var uid:String;
      
      public function BuffStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetStaticData(param1:String) : BuffStaticData
      {
         var _loc2_:BuffStaticData = sBuffMap[param1];
         if(_loc2_)
         {
            return _loc2_;
         }
         var _loc3_:Array = sGetStaticDataFunc([param1]);
         if(_loc3_[0])
         {
            _loc2_ = new BuffStaticData(_loc3_[0]);
            sBuffMap[param1] = _loc2_;
            return _loc2_;
         }
         return null;
      }
   }
}

