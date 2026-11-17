package gamedata.CAS.SimSelector
{
   import olympus.core.OlympusObject;
   
   public class SimSkewerData extends OlympusObject
   {
      
      public var sim_layers:Array = [SimLayerSkewerData];
      
      public var mbAllowCopyAltForm:Boolean = true;
      
      public function SimSkewerData(param1:Object = null)
      {
         super(param1);
      }
   }
}

