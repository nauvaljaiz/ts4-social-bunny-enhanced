package gamedata.Gameplay.shared
{
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.math.TimeSpan;
   
   public class ScreenshotInfo extends OlympusObject
   {
      
      public var memory_id:String;
      
      public var photo_id:String;
      
      public var original_sim_ids:Array = [String];
      
      public var sim_ids:Array = [String];
      
      public var comment:String;
      
      public var time_stamp:TimeSpan;
      
      public var like_count:uint;
      
      public var type_id:String;
      
      public var favorite:Boolean;
      
      public var share:Boolean;
      
      public var household_id:String;
      
      public function ScreenshotInfo(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetScreenshotInfoFromId(param1:String) : ScreenshotInfo
      {
         var _loc4_:Object = null;
         var _loc2_:Array = CommunicationManager.CallGameService("ScreenshotGetProperties",{"screenshotId":param1}) as Array;
         if(!_loc2_ || _loc2_.length == 0)
         {
            return null;
         }
         var _loc3_:Object = {"photo_id":param1};
         for each(_loc4_ in _loc2_)
         {
            _loc3_[_loc4_.key] = _loc4_.value;
         }
         return new ScreenshotInfo(_loc3_);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         var _loc2_:Array = null;
         this.memory_id = "memory_id" in param1 ? param1.memory_id : "-1";
         this.photo_id = "photo_id" in param1 ? param1.photo_id : "-1";
         this.original_sim_ids = param1.original_sim_ids ? (param1.original_sim_ids as String).split(",") : [];
         this.sim_ids = param1.sim_ids ? (param1.sim_ids as String).split(",") : [];
         this.comment = "comment" in param1 ? param1.comment : "";
         if("time_stamp" in param1)
         {
            _loc2_ = (param1.time_stamp as String).split(",");
            this.time_stamp = new TimeSpan(_loc2_[6],_loc2_[5],_loc2_[4],_loc2_[3],_loc2_[2],_loc2_[1],_loc2_[0]);
         }
         else
         {
            this.time_stamp = new TimeSpan();
         }
         this.like_count = "like_count" in param1 ? uint(param1.like_count) : uint(-1);
         this.type_id = "type_id" in param1 ? param1.type_id : "0";
         this.favorite = "favorite" in param1 ? param1.favorite != "0" : false;
         this.share = "share" in param1 ? param1.share != "0" : false;
         this.household_id = "household_id" in param1 ? param1.household_id : "-1";
      }
      
      public function IsTagged(param1:String) : Boolean
      {
         return Boolean(this.sim_ids) && this.sim_ids.indexOf(param1) != -1;
      }
      
      public function get HasMemory() : Boolean
      {
         return this.memory_id != null && this.memory_id != "-1";
      }
      
      public function get HasValidMemoryType() : Boolean
      {
         return this.type_id != null && this.type_id != "0" && this.type_id != "-1";
      }
   }
}

