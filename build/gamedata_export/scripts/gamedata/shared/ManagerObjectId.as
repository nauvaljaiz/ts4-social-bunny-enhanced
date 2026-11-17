package gamedata.shared
{
   import olympus.core.OlympusObject;
   
   public class ManagerObjectId extends OlympusObject
   {
      
      public static const MGR_UNMANAGED:int = 0;
      
      public static const MGR_OBJECT:int = 1;
      
      public static const MGR_SOCIAL_GROUP:int = 2;
      
      public static const MGR_SIM_INFO:int = 3;
      
      public static const MGR_CLIENT:int = 4;
      
      public static const MGR_SITUATION:int = 5;
      
      public static const MGR_PARTY:int = 6;
      
      public static const MGR_HOUSEHOLD:int = 7;
      
      public var manager_id:int;
      
      public var object_id:String;
      
      public function ManagerObjectId(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetValidatedManagerObjectId(param1:Object) : ManagerObjectId
      {
         if(Boolean(param1) && "object_id" in param1)
         {
            return new ManagerObjectId(param1);
         }
         return null;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         this.manager_id = param1["manager_id"];
         this.object_id = param1["object_id"];
      }
   }
}

