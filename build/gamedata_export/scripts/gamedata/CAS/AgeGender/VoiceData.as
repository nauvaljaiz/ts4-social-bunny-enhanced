package gamedata.CAS.AgeGender
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class VoiceData extends OlympusObject
   {
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var icon_selected:ResourceKey = new ResourceKey();
      
      public var tooltip:LocKey = new LocKey();
      
      public var minPitch:Number;
      
      public var maxPitch:Number;
      
      public function VoiceData(param1:Object = null)
      {
         super(param1);
      }
   }
}

