package gamedata.Gameplay.SituationCreation
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class SituationIDBatch extends OlympusObject
   {
      
      public var situation_session_id:uint;
      
      public var situation_resource_id:Array = [String];
      
      public var situation_name:Array = [LocKey];
      
      public var category_id:Array = [uint];
      
      public var mtx_id:Array = [String];
      
      public var highest_medal_earned:Array = [int];
      
      public var scoring_enabled:Boolean;
      
      public var tooltip:Array = [LocKey];
      
      public var allow_user_facing_goals:Array = [Boolean];
      
      public var medal_icon_override:Array = [ResourceKey];
      
      public var scoring_lock_reason:Array = [LocKey];
      
      public var new_entry:Array = [Boolean];
      
      public var mtx_entitlement:Array = new Array();
      
      public function SituationIDBatch(param1:Object = null)
      {
         super(param1);
         FixupArray(this.situation_resource_id);
         FixupArray(this.situation_name);
         FixupArray(this.category_id);
         FixupArray(this.mtx_id);
         FixupArray(this.highest_medal_earned);
         FixupArray(this.tooltip);
         FixupArray(this.allow_user_facing_goals);
         FixupArray(this.medal_icon_override);
         FixupArray(this.scoring_lock_reason);
         FixupArray(this.new_entry);
      }
   }
}

