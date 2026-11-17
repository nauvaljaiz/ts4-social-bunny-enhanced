package gamedata.CAS.shared
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   
   public class CASPaintPose extends OlympusObject
   {
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var icon_selected:ResourceKey = new ResourceKey();
      
      public var pose:int;
      
      public var occults_blacklist:Array = [int];
      
      public function CASPaintPose(param1:Object = null)
      {
         super(param1);
         FixupArray(this.occults_blacklist);
      }
   }
}

