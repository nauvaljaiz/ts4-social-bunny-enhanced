package gamedata.Gameplay.shared.definitions
{
   import olympus.localization.LocKey;
   
   public class AspirationSimInfoStaticData extends AspirationBasicStaticData
   {
      
      protected static var sAspirationsPerCategory:Array;
      
      public var categoryIndex:String;
      
      public var displayName:LocKey = new LocKey();
      
      public var descriptiveText:LocKey = new LocKey();
      
      public var categoryIndexNumber:uint;
      
      public function AspirationSimInfoStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function INIT_DATA() : void
      {
         var _loc5_:AspirationSimInfoStaticData = null;
         var _loc6_:Vector.<AspirationSimInfoStaticData> = null;
         var _loc1_:Array = AspirationBasicStaticData.INIT_STATIC_DATA("GetAspirationSimInfoStaticData",AspirationSimInfoStaticData);
         if(!_loc1_)
         {
            return;
         }
         var _loc2_:Array = CategoryStaticData.CATEGORIES;
         sAspirationsPerCategory = new Array(_loc2_.length);
         var _loc3_:int = int(_loc1_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc1_[_loc4_] as AspirationSimInfoStaticData;
            _loc6_ = sAspirationsPerCategory[_loc5_.categoryIndexNumber];
            if(!_loc6_)
            {
               _loc6_ = new Vector.<AspirationSimInfoStaticData>();
            }
            _loc6_.push(_loc5_);
            sAspirationsPerCategory[_loc5_.categoryIndexNumber] = _loc6_;
            _loc4_++;
         }
      }
      
      private static function get STATIC_DATA_PER_CATEGORY() : Array
      {
         if(!sAspirationsPerCategory)
         {
            INIT_DATA();
         }
         return sAspirationsPerCategory;
      }
      
      public static function GetAspirationInCategory(param1:uint) : Array
      {
         var _loc2_:Array = STATIC_DATA_PER_CATEGORY;
         var _loc3_:Vector.<AspirationSimInfoStaticData> = _loc2_[param1] as Vector.<AspirationSimInfoStaticData>;
         if(!_loc3_)
         {
            return null;
         }
         var _loc4_:int = int(_loc3_.length);
         var _loc5_:Array = new Array(_loc4_);
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc5_[_loc6_] = _loc3_[_loc6_];
            _loc6_++;
         }
         return _loc5_;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(param1)
         {
            this.categoryIndexNumber = uint(this.categoryIndex);
         }
      }
   }
}

