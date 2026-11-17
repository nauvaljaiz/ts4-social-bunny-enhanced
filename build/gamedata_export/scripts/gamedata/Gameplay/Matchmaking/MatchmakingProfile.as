package gamedata.Gameplay.Matchmaking
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   
   public class MatchmakingProfile extends OlympusObject
   {
      
      public static const PROFILE_TYPE_WORLD_NPC:int = 0;
      
      public static const PROFILE_TYPE_GENERATED_NPC:int = 1;
      
      public static const PROFILE_TYPE_GALLERY_NPC:int = 2;
      
      public var sim_id:String;
      
      public var contacted:Boolean;
      
      public var rel_is_hidden:Boolean;
      
      public var profile_type:int;
      
      public var thumbnail_url:String;
      
      public var name:String;
      
      public var real_sim_id:String;
      
      public var display_traits:Array = [TraitAttractionScore];
      
      public var profile_bg_res_key:ResourceKey;
      
      public var pose_index:int = 0;
      
      public var reported:Boolean;
      
      public var region_name:String;
      
      public var exchange_data_creator_name:String;
      
      public var exchange_data_household_id:int;
      
      public var exchange_data_remote_id:String;
      
      public var exchange_data_type:int;
      
      public function MatchmakingProfile(param1:Object = null)
      {
         super(param1);
         FixupArray(this.display_traits);
         if("profile_bg_res_key" in param1)
         {
            this.profile_bg_res_key = new ResourceKey(param1.profile_bg_res_key);
         }
      }
   }
}

