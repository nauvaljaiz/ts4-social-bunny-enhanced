package gamedata.Gameplay.shared.definitions
{
   import flash.utils.getDefinitionByName;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   
   public class HoverTipStaticData extends OlympusObject
   {
      
      protected static var mStaticData:Object = null;
      
      public var field_name:String;
      
      public var index:int;
      
      public var hovertip_style:String;
      
      public var skill_id:String;
      
      public var skill_points:int;
      
      public function HoverTipStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      protected static function STATIC_DATA() : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:HoverTipStaticData = null;
         var _loc1_:Object = new Object();
         var _loc2_:Array = CommunicationManager.CallGameService("GetHoverTipStaticData",null,true) as Array;
         if(_loc2_)
         {
            _loc3_ = int(_loc2_.length);
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc5_ = new HoverTipStaticData(_loc2_[_loc4_]);
               if(_loc5_)
               {
                  if(!(_loc5_.hovertip_style in _loc1_))
                  {
                     _loc1_[_loc5_.hovertip_style] = new Vector.<HoverTipStaticData>();
                  }
                  _loc1_[_loc5_.hovertip_style].push(_loc5_);
               }
               _loc4_++;
            }
         }
         mStaticData = _loc1_;
      }
      
      public static function GetHoverTipStaticDataForStyle(param1:String) : Vector.<HoverTipStaticData>
      {
         if(!mStaticData)
         {
            STATIC_DATA();
         }
         if(param1 in mStaticData)
         {
            return mStaticData[param1];
         }
         return null;
      }
   }
}

