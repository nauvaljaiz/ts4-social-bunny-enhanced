package gamedata.Gameplay.SimInfoHUD
{
   import olympus.core.OlympusObject;
   
   public class RelationshipPreferenceData extends OlympusObject
   {
      
      public static const RELATIONSHIP_EXPECTATIONS_FRAME:* = "RomanticBoundaries";
      
      public static const SEXUAL_ORIENTAITON_FRAME:* = "default";
      
      public var icon:String;
      
      public var title:String;
      
      public var subtitle:String;
      
      public var tooltip:String;
      
      public var frame:String = "default";
      
      public function RelationshipPreferenceData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
      }
   }
}

