package gamedata.Gameplay.InteractionMenu
{
   import gamedata.Gameplay.InteractionMenu.definitions.InteractionCategoryInfo;
   import olympus.localization.LocKey;
   
   public class InteractionCategory
   {
      
      protected static const LOOP_BACK_STR:String = "-1";
      
      public var items:Array = new Array();
      
      public var disabledText:LocKey = new LocKey();
      
      public var displayText:LocKey = new LocKey();
      
      protected var mCategoryInfo:InteractionCategoryInfo;
      
      protected var mLoopCategory:InteractionCategory;
      
      protected var mRootCategory:InteractionCategory;
      
      protected var mPhoneNotificationCount:uint = 0;
      
      public function InteractionCategory(param1:InteractionCategoryInfo)
      {
         super();
         this.mCategoryInfo = param1;
         this.displayText = param1.display_name;
      }
      
      public static function Create(param1:String) : InteractionCategory
      {
         var _loc2_:InteractionCategoryInfo = InteractionCategoryInfo.Get(param1);
         if(_loc2_)
         {
            return new InteractionCategory(_loc2_);
         }
         throw Error("Failed to locate category info for interaction category with key: " + param1);
      }
      
      public static function FindDisabledText(param1:Object) : String
      {
         var _loc3_:InteractionMenuItem = null;
         var _loc2_:InteractionCategory = param1 as InteractionCategory;
         if(_loc2_ != null)
         {
            if(_loc2_.LoopCategory)
            {
               return LOOP_BACK_STR;
            }
            return _loc2_.DetermineDisabledText();
         }
         _loc3_ = param1 as InteractionMenuItem;
         return _loc3_.disabled_text.toString();
      }
      
      public function get CategoryInfo() : InteractionCategoryInfo
      {
         return this.mCategoryInfo;
      }
      
      public function get LoopCategory() : InteractionCategory
      {
         return this.mLoopCategory;
      }
      
      public function set LoopCategory(param1:InteractionCategory) : void
      {
         this.mLoopCategory = param1;
      }
      
      public function get RootCategory() : InteractionCategory
      {
         return this.mRootCategory;
      }
      
      public function set RootCategory(param1:InteractionCategory) : void
      {
         this.mRootCategory = param1;
      }
      
      public function get PhoneNotificationCount() : uint
      {
         return this.mPhoneNotificationCount;
      }
      
      public function set PhoneNotificationCount(param1:uint) : void
      {
         this.mPhoneNotificationCount = param1;
      }
      
      public function ShouldDisplayNotification() : Boolean
      {
         return this.mPhoneNotificationCount > 0;
      }
      
      public function AddItem(param1:Object) : void
      {
         this.items.push(param1);
         if(param1.display_notification)
         {
            ++this.mPhoneNotificationCount;
         }
      }
      
      public function AddItemToFront(param1:Object) : void
      {
         this.items.unshift(param1);
      }
      
      public function DetermineDisabledText() : String
      {
         var _loc5_:String = null;
         var _loc1_:String = this.disabledText.toString();
         if(_loc1_ != "" || this.items.length == 0 || this.mCategoryInfo.always_show_disabled_interactions)
         {
            return _loc1_;
         }
         var _loc2_:String = FindDisabledText(this.items[0]);
         var _loc3_:int = int(this.items.length);
         var _loc4_:int = 1;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = FindDisabledText(this.items[_loc4_]);
            if(_loc5_ != LOOP_BACK_STR)
            {
               if(_loc5_ != _loc2_)
               {
                  return _loc1_;
               }
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function IsMoreChoicesCategory() : Boolean
      {
         return this.mCategoryInfo.key == InteractionCategoryInfo.MoreCategoryKey;
      }
   }
}

