package gamedata.Gameplay.SituationCreation
{
   import olympus.core.OlympusObject;
   
   public class SituationPrepare extends OlympusObject
   {
      
      public var situation_session_id:uint;
      
      public var target_id:String;
      
      public var sim_id:String;
      
      public var situation_resource_id:Array = [String];
      
      public var creation_time:String;
      
      public var edit_data:SituationEditData;
      
      public var situation_category:uint;
      
      public var is_active:Boolean;
      
      public var is_new_from_tuning:Boolean;
      
      public function SituationPrepare(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.situation_resource_id);
         if("edit_data" in param1)
         {
            this.edit_data = new SituationEditData(param1.edit_data);
            this.edit_data.fromSituationEdit = true;
            if(this.is_new_from_tuning)
            {
               this.edit_data.fromCalendar = false;
            }
         }
      }
   }
}

