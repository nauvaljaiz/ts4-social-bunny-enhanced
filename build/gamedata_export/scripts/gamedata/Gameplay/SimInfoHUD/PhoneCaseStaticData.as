package gamedata.Gameplay.SimInfoHUD
{
   import flash.utils.getDefinitionByName;
   import gamedata.GameContent;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   
   public class PhoneCaseStaticData extends OlympusObject
   {
      
      protected static var sPhoneCaseStaticData:Vector.<PhoneCaseStaticData>;
      
      public var icon:String;
      
      public var requiredPacks:Array = [uint];
      
      public var traitId:String;
      
      public function PhoneCaseStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get PhoneCaseData() : Vector.<PhoneCaseStaticData>
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:uint = 0;
         if(!sPhoneCaseStaticData)
         {
            _loc1_ = CommunicationManager.CallGameService("GetPhoneCaseStaticData") as Array;
            _loc2_ = _loc1_ ? int(_loc1_.length) : 0;
            if(_loc2_ > 0)
            {
               sPhoneCaseStaticData = new Vector.<PhoneCaseStaticData>();
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
                  sPhoneCaseStaticData.push(new PhoneCaseStaticData(_loc1_[_loc3_]));
               }
            }
         }
         return sPhoneCaseStaticData;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.requiredPacks);
      }
   }
}

