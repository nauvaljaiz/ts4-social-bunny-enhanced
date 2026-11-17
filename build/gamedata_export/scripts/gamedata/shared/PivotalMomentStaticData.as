package gamedata.shared
{
   import flash.utils.getDefinitionByName;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   
   public class PivotalMomentStaticData extends OlympusObject
   {
      
      protected static var sStaticDataList:Vector.<PivotalMomentStaticData>;
      
      public var pivotal_moment_id:String;
      
      public var name:LocKey = new LocKey();
      
      public var description:LocKey = new LocKey();
      
      public var reward_icons:Array = [ResourceKey];
      
      public var activation_triggers:Array = [String];
      
      public function PivotalMomentStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get PivotalMomentsList() : Vector.<PivotalMomentStaticData>
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:Vector.<PivotalMomentStaticData> = null;
         var _loc4_:int = 0;
         if(!sStaticDataList)
         {
            _loc1_ = CommunicationManager.CallGameService("GetPivotalMomentsStaticData") as Array;
            _loc2_ = _loc1_ ? int(_loc1_.length) : 0;
            if(_loc2_ > 0)
            {
               _loc3_ = new Vector.<PivotalMomentStaticData>(_loc2_,true);
               _loc4_ = 0;
               while(_loc4_ < _loc2_)
               {
                  _loc3_[_loc4_] = new PivotalMomentStaticData(_loc1_[_loc4_]);
                  _loc4_++;
               }
               sStaticDataList = _loc3_;
            }
         }
         return sStaticDataList;
      }
      
      public static function GetPivotalMomentStaticDataById(param1:String) : PivotalMomentStaticData
      {
         var _loc3_:PivotalMomentStaticData = null;
         var _loc2_:Vector.<PivotalMomentStaticData> = PivotalMomentsList;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.pivotal_moment_id == param1)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.reward_icons);
         FixupArray(this.activation_triggers);
      }
   }
}

