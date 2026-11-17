package gamedata.Gameplay.AgeUpPanel
{
   import gamedata.Dialog.UiDialogMessage;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class SimPersonalityAssignmentDialog extends OlympusObject
   {
      
      public var sim_id:String;
      
      public var dialog:UiDialogMessage = new UiDialogMessage();
      
      public var secondary_title:LocKey = new LocKey();
      
      public var age_description:LocKey = new LocKey();
      
      public var naming_title_text:LocKey = new LocKey();
      
      public var available_trait_slots:String;
      
      public var current_personality_trait_ids:Array = [String];
      
      public var current_aspiration_id:String;
      
      public var current_aspiration_trait_id:String;
      
      public var available_personality_trait_ids:Array = [String];
      
      public var available_aspiration_ids:Array = [String];
      
      public var is_female:Boolean;
      
      public var aspirations_and_trait_assignment_text:LocKey = new LocKey();
      
      public var replace_trait_id:String;
      
      public var reward_trait_id:String;
      
      public var current_skill_ids:Array = [String];
      
      public var previous_skill_levels:Array = [int];
      
      public var unlocked_trait_ids:Array = [String];
      
      public var age_up_reward_trait_text:LocKey = new LocKey();
      
      public var pregnancy_parent_id:String;
      
      public var parent_pregnancy_partner_id:String;
      
      public var parent_partner_id:String;
      
      public var parent_partner_relbit_id:String;
      
      public function SimPersonalityAssignmentDialog(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!("dialog" in param1))
         {
            this.dialog = null;
         }
         if(!("secondary_title" in param1) || !param1.secondary_title)
         {
            this.secondary_title = null;
         }
         if(!("age_description" in param1) || !param1.age_description)
         {
            this.age_description = null;
         }
         if(!("naming_title_text" in param1) || !param1.naming_title_text)
         {
            this.naming_title_text = null;
         }
         if(!("aspirations_and_trait_assignment_text" in param1) || !param1.aspirations_and_trait_assignment_text)
         {
            this.aspirations_and_trait_assignment_text = null;
         }
         if(!("age_up_reward_trait_text" in param1) || !param1.age_up_reward_trait_text)
         {
            this.age_up_reward_trait_text = null;
         }
         FixupArray(this.current_personality_trait_ids);
         FixupArray(this.available_personality_trait_ids);
         FixupArray(this.available_aspiration_ids);
         FixupArray(this.current_skill_ids);
         FixupArray(this.previous_skill_levels);
         FixupArray(this.unlocked_trait_ids);
      }
   }
}

