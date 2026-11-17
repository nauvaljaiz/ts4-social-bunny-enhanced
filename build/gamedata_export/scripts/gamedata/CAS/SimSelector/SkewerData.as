package gamedata.CAS.SimSelector
{
   import olympus.core.OlympusObject;
   
   public class SkewerData extends OlympusObject
   {
      
      public var selected_sim:int = -1;
      
      public var selected_layer:int = 0;
      
      public var sim_data:Array = [SimLayerSkewerData];
      
      public var sim_occult_data:Array = [SimLayerSkewerData];
      
      public function SkewerData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.sim_data);
         FixupArray(this.sim_occult_data);
      }
   }
}

