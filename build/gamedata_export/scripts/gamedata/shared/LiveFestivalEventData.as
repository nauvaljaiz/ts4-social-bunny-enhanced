package gamedata.shared
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   import olympus.utils.DateUtils;
   
   public class LiveFestivalEventData extends OlympusObject
   {
      
      public var key:String;
      
      public var name:LocKey = new LocKey();
      
      public var lot:String;
      
      public var world:String;
      
      public var startDate:Date = DateUtils.DateDST();
      
      public var endDate:Date = DateUtils.DateDST();
      
      public var streetDescriptionImage:String;
      
      public var festivalTime:Object;
      
      public function LiveFestivalEventData(param1:Object = null)
      {
         super(param1);
      }
      
      public function IsActive() : Boolean
      {
         return this.key != null;
      }
   }
}

