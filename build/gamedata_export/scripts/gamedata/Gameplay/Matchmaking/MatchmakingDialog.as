package gamedata.Gameplay.Matchmaking
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   
   public class MatchmakingDialog extends OlympusObject
   {
      
      public var sim_id:String;
      
      public var trait_ids:Array = [String];
      
      public var selected_ages:Array = [int];
      
      public var selected_traits:Array = [String];
      
      public var cooldown_mins_left:int;
      
      public var num_contact_actions:int;
      
      public var profiles:Array = [MatchmakingProfile];
      
      public var is_update:Boolean;
      
      public var is_traits_display_update:Boolean;
      
      public var saved_profiles:Array = [MatchmakingProfile];
      
      public var max_save:int;
      
      public var max_contact:int;
      
      public var attracted_options:Array = [int];
      
      public var woohoo_options:Array = [int];
      
      public var res_key:ResourceKey;
      
      public var min_download_count:String;
      
      public var upload_time_range_start:String;
      
      public var update_time_range_end:String;
      
      public var bg_res_key:ResourceKey;
      
      public var gallery_sims_enabled:Boolean;
      
      public var gallery_sims_favorites_only_enabled:Boolean;
      
      public var remote_ids_on_cooldown:Array = [String];
      
      public function MatchmakingDialog(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.trait_ids);
         FixupArray(this.selected_ages);
         FixupArray(this.selected_traits);
         FixupArray(this.profiles);
         FixupArray(this.saved_profiles);
         FixupArray(this.attracted_options);
         FixupArray(this.woohoo_options);
         if("res_key" in param1)
         {
            this.res_key = new ResourceKey(param1.res_key);
         }
         if("bg_res_key" in param1)
         {
            this.bg_res_key = new ResourceKey(param1.bg_res_key);
         }
         this.remote_ids_on_cooldown = new Array();
         if("remote_ids_on_cooldown" in param1)
         {
            ConstructArrayFromArray(this.remote_ids_on_cooldown,param1.remote_ids_on_cooldown,String);
         }
      }
   }
}

