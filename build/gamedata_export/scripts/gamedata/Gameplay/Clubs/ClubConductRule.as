package gamedata.Gameplay.Clubs
{
   import gamedata.Gameplay.Clubs.constants.ClubCriteriaCategory;
   import gamedata.Gameplay.shared.definitions.ClubInteractionGroupStaticData;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.KeysGP;
   import olympus.localization.LocKey;
   
   public class ClubConductRule extends OlympusObject
   {
      
      public var encouraged:Boolean;
      
      public var interaction_group:ResourceKey = new ResourceKey();
      
      public var with_whom:ClubCriteria = new ClubCriteria();
      
      public function ClubConductRule(param1:Object = null)
      {
         super(param1);
         if(!param1 || !("with_whom" in param1))
         {
            this.with_whom = null;
         }
      }
      
      public function ToObject() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_["encouraged"] = this.encouraged;
         _loc1_["interaction_group"] = this.interaction_group.ToObject();
         if(this.with_whom)
         {
            _loc1_["with_whom"] = this.with_whom.ToObject();
         }
         return _loc1_;
      }
      
      public function GetTooltipText() : String
      {
         var _loc2_:LocKey = null;
         var _loc3_:String = null;
         var _loc4_:Object = null;
         var _loc1_:ClubInteractionGroupStaticData = ClubInteractionGroupStaticData.GetInteractionGroupStaticDataByKey(this.interaction_group.instance);
         if(_loc1_)
         {
            _loc2_ = this.encouraged ? _loc1_.tooltip_template : _loc1_.tooltip_template_negative;
            _loc3_ = "";
            _loc4_ = "";
            if(_loc1_.is_targeted)
            {
               if(this.with_whom)
               {
                  _loc3_ = ClubCriteriaCategory.GetCategoryTooltipLocKey(this.with_whom.category,true).toString();
                  _loc4_ = {
                     "type":LocKey.TOKEN_TYPE_STRING_LIST,
                     "string_list":this.with_whom.GetTooltipText(true)
                  };
               }
               else
               {
                  _loc3_ = ClubCriteriaCategory.GetCategoryTooltipLocKey(ClubCriteriaCategory.EVERYONE,true,this.encouraged).toString();
                  _loc4_ = this.encouraged ? KeysGP.CLUB_CRITERIA_CATEGORY_EVERYONE.toString() : KeysGP.CLUB_CRITERIA_CATEGORY_ANYONE.toString();
               }
            }
            return _loc2_.toString(_loc3_,_loc4_);
         }
         return null;
      }
   }
}

