package gamedata.shared
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class ChallengeData extends OlympusObject
   {
      
      public var name:LocKey = new LocKey();
      
      public var description:LocKey = new LocKey();
      
      public var imageId:String;
      
      public var infoLink:String;
      
      public var rewards:Array = [Object];
      
      public var collectionId:String;
      
      public var eventDisplay:ChallengeEventData = new ChallengeEventData();
      
      public function ChallengeData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.rewards);
      }
   }
}

