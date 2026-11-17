package gamedata.shared
{
   import flash.utils.Dictionary;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   
   public class CurrencyBuckData extends OlympusObject
   {
      
      protected static var sCurrencyBuckDatas:Array = null;
      
      protected static var sCurrencyBuckMap:Dictionary = null;
      
      public var buckType:uint;
      
      public var gainKey:LocKey;
      
      public var loseKey:LocKey;
      
      public var valueKey:LocKey;
      
      public var flyawayGainAudio:String;
      
      public var flyawayLossAudio:String;
      
      public function CurrencyBuckData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetCurrencyBuckDatas() : Array
      {
         if(sCurrencyBuckDatas == null)
         {
            sCurrencyBuckDatas = CommunicationManager.CallGameService("GetCurrencyBucks") as Array;
            ConstructArrayInPlace(sCurrencyBuckDatas,CurrencyBuckData);
         }
         return sCurrencyBuckDatas;
      }
      
      public static function GetCurrencyBuckData(param1:uint) : CurrencyBuckData
      {
         var _loc2_:Array = null;
         var _loc3_:CurrencyBuckData = null;
         if(sCurrencyBuckMap == null)
         {
            sCurrencyBuckMap = new Dictionary();
            _loc2_ = CurrencyBuckData.GetCurrencyBuckDatas();
            for each(_loc3_ in _loc2_)
            {
               sCurrencyBuckMap[_loc3_.buckType] = _loc3_;
            }
         }
         if(param1 in sCurrencyBuckMap)
         {
            return sCurrencyBuckMap[param1];
         }
         return null;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         this.buckType = param1["buckType"];
         this.gainKey = new LocKey(param1["gainKey"]);
         this.loseKey = new LocKey(param1["loseKey"]);
         this.valueKey = new LocKey(param1["valueKey"]);
         this.flyawayGainAudio = param1["flyawayGainAudio"];
         this.flyawayLossAudio = param1["flyawayLossAudio"];
      }
   }
}

