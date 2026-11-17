package gamedata.Gameplay.InteractionMenu.definitions
{
   import flash.utils.getDefinitionByName;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.KeysGP;
   import olympus.localization.LocKey;
   
   public class InteractionCategoryInfo extends OlympusObject
   {
      
      protected static var sMoreCategoryInfo:InteractionCategoryInfo;
      
      protected static var sCategoryMap:Object;
      
      protected static const MORE_CATEGORY_KEY:String = "MORE_CATEGORY";
      
      public var key:String;
      
      public var display_name:LocKey = new LocKey();
      
      public var collapsible:Boolean;
      
      public var parent_key:String;
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var display_priority:int;
      
      public var mood_overrides:Array = [MoodOverride];
      
      public var always_show_disabled_interactions:Boolean;
      
      public function InteractionCategoryInfo(param1:Object = null)
      {
         super(param1);
      }
      
      protected static function EnsureInitialized() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:InteractionCategoryInfo = null;
         if(!sCategoryMap)
         {
            _loc1_ = CommunicationManager.CallGameService("GetInteractionCategoryList",null,true);
            _loc2_ = _loc1_["categories"] as Array;
            if(Boolean(_loc2_) && _loc2_.length > 0)
            {
               _loc3_ = new Object();
               _loc4_ = 0;
               _loc5_ = int(_loc2_.length);
               while(_loc4_ < _loc5_)
               {
                  _loc6_ = new InteractionCategoryInfo(_loc2_[_loc4_]);
                  _loc3_[_loc6_.key] = _loc6_;
                  _loc4_++;
               }
               sCategoryMap = _loc3_;
            }
            sMoreCategoryInfo = new InteractionCategoryInfo({
               "display_name":KeysGP.PIE_MENU_MORE_CATEGORY_LABEL,
               "key":MORE_CATEGORY_KEY
            });
         }
      }
      
      public static function get CATEGORY_MAP() : Object
      {
         EnsureInitialized();
         return sCategoryMap;
      }
      
      public static function Get(param1:String) : InteractionCategoryInfo
      {
         var _loc2_:Object = CATEGORY_MAP;
         if(_loc2_)
         {
            return _loc2_[param1];
         }
         return null;
      }
      
      public static function GetMore() : InteractionCategoryInfo
      {
         EnsureInitialized();
         return sMoreCategoryInfo;
      }
      
      public static function get MoreCategoryKey() : String
      {
         return MORE_CATEGORY_KEY;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!("icon" in param1))
         {
            this.icon = null;
         }
         FixupArray(this.mood_overrides);
      }
   }
}

