package gamedata.shared.CustomSchedule
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class AssignmentListData extends OlympusObject
   {
      
      public var name:String;
      
      public var is_immutable:Boolean;
      
      public var premade_name:LocKey = new LocKey();
      
      public function AssignmentListData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(Boolean(this.premade_name) && this.premade_name.IsValid())
         {
            this.name = this.premade_name.toString();
         }
      }
   }
}

