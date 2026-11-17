package gamedata.Gameplay.shared.definitions
{
   import olympus.localization.LocKey;
   
   public class AspirationStaticData extends AspirationBasicStaticData
   {
      
      protected static var sAspirations:Array;
      
      public var displayName:LocKey = new LocKey();
      
      public var descriptiveText:LocKey = new LocKey();
      
      public var aspirationValidAgeType:int;
      
      public var level:int;
      
      public function AspirationStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetStaticData(param1:String) : AspirationStaticData
      {
         var _loc2_:AspirationStaticData = null;
         if(!sAspirations)
         {
            sAspirations = AspirationBasicStaticData.INIT_STATIC_DATA("GetAspirationStaticData",AspirationStaticData);
         }
         for each(_loc2_ in sAspirations)
         {
            if(_loc2_.uid == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
   }
}

