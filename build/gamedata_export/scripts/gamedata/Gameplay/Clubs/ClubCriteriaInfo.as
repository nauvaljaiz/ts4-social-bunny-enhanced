package gamedata.Gameplay.Clubs
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.KeysGP;
   import olympus.localization.LocKey;
   
   public class ClubCriteriaInfo extends OlympusObject
   {
      
      public var name:LocKey = new LocKey();
      
      public var tooltip_name:LocKey = new LocKey();
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var resource_value:ResourceKey = new ResourceKey();
      
      public var enum_value:uint;
      
      public var resource_id:String;
      
      public var mNameOverride:String;
      
      public function ClubCriteriaInfo(param1:Object = null)
      {
         super(param1);
      }
      
      public function GetTooltipDisplayName(param1:Boolean) : String
      {
         if(this.mNameOverride)
         {
            return this.mNameOverride;
         }
         if(param1 && this.tooltip_name.IsValid())
         {
            return this.tooltip_name.toString();
         }
         if(this.name.IsValid())
         {
            return this.name.toString();
         }
         return KeysGP.CLUB_CRITERIA_NAMELESS_CLUB_ENTRY.toString();
      }
      
      public function ToObject() : Object
      {
         var _loc1_:Object = new Object();
         if(this.name)
         {
            _loc1_["name"] = this.name.ToObject();
         }
         if(this.tooltip_name)
         {
            _loc1_["tooltip_name"] = this.tooltip_name.ToObject();
         }
         if(this.icon)
         {
            _loc1_["icon"] = this.icon.ToObject();
         }
         if(this.enum_value)
         {
            _loc1_["enum_value"] = this.enum_value;
         }
         else if(this.resource_id)
         {
            _loc1_["resource_id"] = this.resource_id;
         }
         else if(this.resource_value.instance != "0")
         {
            _loc1_["resource_value"] = this.resource_value.ToObject();
         }
         return _loc1_;
      }
      
      public function Equals(param1:ClubCriteriaInfo) : Boolean
      {
         if(this.name.hash != param1.name.hash)
         {
            return false;
         }
         var _loc2_:String = this.resource_value.instance;
         if(_loc2_ != "0")
         {
            return _loc2_ == param1.resource_value.instance;
         }
         if(this.resource_id != "0")
         {
            return this.resource_id == param1.resource_id;
         }
         return this.enum_value == param1.enum_value;
      }
   }
}

