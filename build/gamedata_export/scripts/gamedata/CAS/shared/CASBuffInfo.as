package gamedata.CAS.shared
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class CASBuffInfo extends OlympusObject
   {
      
      public var buff_name:LocKey = new LocKey();
      
      public var buff_description:LocKey = new LocKey();
      
      public var buff_icon:ResourceKey = new ResourceKey();
      
      public function CASBuffInfo(param1:Object)
      {
         super(param1);
      }
   }
}

