package gamedata.Gameplay.shared
{
   import gamedata.GameEntry.Neighborhood.WorldDescription;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   
   public class LotInfoItem extends OlympusObject
   {
      
      public static const LOT_PRIORITY_DEFAULT:int = 0;
      
      public static const LOT_PRIORITY_HIGH:int = 1;
      
      public static const LOT_PRIORITY_TOP:int = 2;
      
      public var zone_id:String;
      
      public var name:String;
      
      public var world_id:uint;
      
      public var region_description_id:int;
      
      public var lot_template_id:uint;
      
      public var lot_description_id:String;
      
      public var household_name:String;
      
      public var related_household:Boolean;
      
      public var venue_type_name:LocKey = new LocKey();
      
      public var venue_type:ResourceKey = new ResourceKey();
      
      public var house_description_id:String;
      
      public var region_name:String;
      
      public var region_icon:ResourceKey = new ResourceKey();
      
      public var custom_schedule_name:String;
      
      public var custom_schedule_name_key:LocKey = new LocKey();
      
      public var custom_schedule_activity_names:Array = [LocKey];
      
      public var is_premade_custom_schedule:Boolean;
      
      public var getaway_lot_provides_earnings:Boolean;
      
      public var priority:int = 0;
      
      public var requires_objects_text:LocKey = new LocKey();
      
      public var neighborhood_name:String;
      
      public function LotInfoItem(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!this.venue_type_name.IsValid())
         {
            this.venue_type_name = null;
         }
         if(this.custom_schedule_name_key.IsValid())
         {
            this.custom_schedule_name = this.custom_schedule_name_key.toString();
         }
         this.SetNeighborhoodName();
         this.requires_objects_text = FixupLocKey(this.requires_objects_text);
      }
      
      public function SetNeighborhoodName() : void
      {
         var _loc1_:String = this.world_id.toString();
         var _loc2_:WorldDescription = new WorldDescription(CommunicationManager.CallGameService("GetWorldDescriptionFromWorldId",{"worldId":_loc1_}));
         var _loc3_:LocKey = _loc2_.name;
         this.neighborhood_name = _loc3_ ? _loc3_.toString() : "";
      }
   }
}

