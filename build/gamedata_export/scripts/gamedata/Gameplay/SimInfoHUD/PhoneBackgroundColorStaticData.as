package gamedata.Gameplay.SimInfoHUD
{
   import flash.utils.getDefinitionByName;
   import gamedata.GameContent;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   
   public class PhoneBackgroundColorStaticData extends OlympusObject
   {
      
      protected static var sPhoneBackgroundColorStaticData:Vector.<PhoneBackgroundColorStaticData>;
      
      public var bgImage:String;
      
      public var icon:String;
      
      public var requiredPacks:Array = [uint];
      
      public function PhoneBackgroundColorStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get PhoneBackgroundColorData() : Vector.<PhoneBackgroundColorStaticData>
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:uint = 0;
         if(!sPhoneBackgroundColorStaticData)
         {
            _loc1_ = CommunicationManager.CallGameService("GetPhoneBackgroundColorStaticData") as Array;
            _loc2_ = _loc1_ ? int(_loc1_.length) : 0;
            if(_loc2_ > 0)
            {
               sPhoneBackgroundColorStaticData = new Vector.<PhoneBackgroundColorStaticData>();
               _loc3_ = 0;
               for(; _loc3_ < _loc2_; _loc3_++)
               {
                  if(_loc1_[_loc3_].requiredPacks.length > 0)
                  {
                     _loc4_ = false;
                     for each(_loc5_ in _loc1_[_loc3_].requiredPacks)
                     {
                        if(GameContent.IsPackAvailable(_loc5_))
                        {
                           _loc4_ = true;
                           break;
                        }
                     }
                     if(!_loc4_)
                     {
                        continue;
                     }
                  }
                  sPhoneBackgroundColorStaticData.push(new PhoneBackgroundColorStaticData(_loc1_[_loc3_]));
               }
            }
         }
         return sPhoneBackgroundColorStaticData;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.requiredPacks);
      }
   }
}

