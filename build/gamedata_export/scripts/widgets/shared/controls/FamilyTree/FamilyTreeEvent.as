package widgets.shared.controls.FamilyTree
{
   import flash.events.Event;
   
   public class FamilyTreeEvent extends Event
   {
      
      public static const SIM_CLICKED:String = "FamilyTreeSimClicked";
      
      public static const SIMS_LOADED:String = "FamilyTreeSimsLoaded";
      
      public var simId:String;
      
      public function FamilyTreeEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:String = null)
      {
         super(param1,param2,param3);
         this.simId = param4;
      }
      
      override public function clone() : Event
      {
         return new FamilyTreeEvent(type,bubbles,cancelable,this.simId);
      }
      
      override public function toString() : String
      {
         return formatToString("FamilyTreeEvent","type","bubbles","cancelable","simId");
      }
   }
}

