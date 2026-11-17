package gamedata.Gameplay.shared.definitions
{
   import flash.utils.getDefinitionByName;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class TimedAspirationStaticData extends OlympusObject
   {
      
      public static var sGetStaticDataFunc:Function;
      
      protected static var sAspirationMap:Object = new Object();
      
      public var description:LocKey = new LocKey();
      
      public var name:LocKey = new LocKey();
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var objectives:Array = [String];
      
      public function TimedAspirationStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetStaticData(param1:String) : TimedAspirationStaticData
      {
         var _loc2_:TimedAspirationStaticData = sAspirationMap[param1];
         if(_loc2_)
         {
            return _loc2_;
         }
         var _loc3_:Array = sGetStaticDataFunc([param1]);
         if(_loc3_[0])
         {
            _loc2_ = new TimedAspirationStaticData(_loc3_[0]);
            sAspirationMap[param1] = _loc2_;
            return _loc2_;
         }
         return null;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(Boolean(this.description) && !this.description.IsValid())
         {
            this.description = null;
         }
         if(Boolean(this.name) && !this.name.IsValid())
         {
            this.name = null;
         }
         FixupArray(this.objectives);
      }
   }
}

