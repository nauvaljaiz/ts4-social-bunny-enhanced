package gamedata.shared
{
   import gamedata.GameContent;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.KeysGE;
   import olympus.math.TimeSpan;
   import olympus.utils.SystemUtils;
   
   public class SaveSlotData extends OlympusObject
   {
      
      private static const HOURS_BIAS:int = -7;
      
      public var slot_id:uint;
      
      public var slot_name:String;
      
      public var slot_version:uint;
      
      public var timestamp:String;
      
      public var last_household_name:String;
      
      public var incompatible:Boolean;
      
      public var required_pack_ids:Array;
      
      public var cds_patch_base_changelists:Array;
      
      public var cds_content_patch_mounted:Boolean;
      
      public var scenario_ids:Array;
      
      public var saved_by_feature_preview_build:Boolean;
      
      public var scratch_id:int;
      
      public var isValid:Boolean;
      
      public var isLoadFile:Boolean;
      
      private var mCachedDate:Date = null;
      
      private var mCachedTimeSpan:TimeSpan = null;
      
      public function SaveSlotData(param1:Object = null)
      {
         super(param1);
         this.isValid = param1 != null;
      }
      
      public function GetMissingPackIds() : Array
      {
         var isUnavailable:Function = function(param1:int):Boolean
         {
            return !GameContent.IsPackAvailable(param1);
         };
         return this.required_pack_ids ? this.required_pack_ids.filter(isUnavailable) : [];
      }
      
      public function UsesPack(param1:int) : Boolean
      {
         return this.required_pack_ids ? this.required_pack_ids.indexOf(param1) >= 0 : false;
      }
      
      public function GetFilePath() : String
      {
         return CommunicationManager.CallGameService("GetSaveSlotFilePath",{"slot_id":this.slot_id}) as String;
      }
      
      public function GetDate() : Date
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         if(this.mCachedDate == null)
         {
            if(SystemUtils.IsConsole)
            {
               _loc1_ = Number(this.timestamp.substr(0,4));
               _loc2_ = Number(this.timestamp.substr(4,2));
               _loc3_ = Number(this.timestamp.substr(6,2));
               _loc4_ = Number(this.timestamp.substr(8,2));
               _loc5_ = Number(this.timestamp.substr(10,2));
               this.mCachedDate = new Date(_loc1_,_loc2_ - 1,_loc3_,_loc4_,_loc5_,0,0);
            }
            else
            {
               _loc6_ = Number(this.timestamp) * 1000;
               this.mCachedDate = new Date(_loc6_);
            }
         }
         return this.mCachedDate;
      }
      
      public function GetTimeSpan() : TimeSpan
      {
         var _loc1_:Date = null;
         if(this.mCachedTimeSpan == null)
         {
            _loc1_ = this.GetDate();
            this.mCachedTimeSpan = new TimeSpan(0,0,_loc1_.minutes,_loc1_.hours,_loc1_.date,_loc1_.month + 1,_loc1_.fullYear);
         }
         return this.mCachedTimeSpan;
      }
      
      public function GetTimeAsString() : String
      {
         var _loc1_:TimeSpan = this.GetTimeSpan();
         return KeysGE.SAVE_LOAD_TIMESTAMP.toString({
            "token_type":"TimeSpan",
            "token_data":_loc1_
         },{
            "token_type":"TimeSpan",
            "token_data":_loc1_
         });
      }
   }
}

