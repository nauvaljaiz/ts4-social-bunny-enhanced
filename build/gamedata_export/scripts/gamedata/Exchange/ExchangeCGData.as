package gamedata.Exchange
{
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.utils.SystemUtils;
   import widgets.Exchange.Detail.constants.ExchangeDetailTunables;
   import widgets.shared.utils.SharedExchangeUtils;
   
   public class ExchangeCGData extends OlympusObject
   {
      
      protected static var sCurrentDigest:String;
      
      public static const TELEMETRY_REPORT_SOURCE_TYPE_EVAL:String = "evaluation";
      
      public static const TELEMETRY_REPORT_SOURCE_TYPE_CG:String = "cg_tab";
      
      public static const TELEMETRY_REPORT_SOURCE_TYPE_GALL:String = "gallery_tab";
      
      public static const TELEMETRY_REPORT_SOURCE_TYPE_BANNER:String = "banner";
      
      public static const TELEMETRY_REPORT_SOURCE_TYPE_DIALOG:String = "dialog";
      
      public static const TELEMETRY_REPORT_SOURCE_TYPE_COMMENT:String = "comments";
      
      public static const TELEMETRY_REPORT_SOURCE_TYPE_PLINFO:String = "player_info";
      
      protected static var sCGVotingDataList:Array = null;
      
      protected static var sCGVotingDataListPendingUpdate:Boolean = false;
      
      protected static var sCGVotingPairs:Array = null;
      
      protected static var sCGVotingPairsVoted:Array = null;
      
      protected static var sCurrentDigestSize:uint = 0;
      
      public function ExchangeCGData()
      {
         super();
      }
      
      public static function get CGVotingsData() : Array
      {
         if(!sCGVotingDataList || sCGVotingDataList.length < 1)
         {
            sCGVotingDataList = new Array();
            CommunicationManager.AddMessageListenerByName("CGVotingResponse",CGVotingDataResponse,"ExchangeCGData");
            sCGVotingDataListPendingUpdate = true;
            CommunicationManager.CallGameService("RequestCGVotingMessages");
         }
         return sCGVotingDataList;
      }
      
      public static function get ActiveCGVotingData() : CGVotingData
      {
         var _loc1_:CGVotingData = null;
         for each(_loc1_ in CGVotingsData)
         {
            if(_loc1_.Active)
            {
               return _loc1_;
            }
         }
         return null;
      }
      
      public static function GetVotingItemsToVote(param1:uint) : Array
      {
         var _loc3_:CGVotingCandidateData = null;
         if(param1 == ExchangeData.TYPE_ALL)
         {
            return sCGVotingPairs;
         }
         var _loc2_:Array = new Array();
         for each(_loc3_ in sCGVotingPairs)
         {
            if(_loc3_.category == param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public static function GetVotingPairOfSameType(param1:uint) : Array
      {
         var _loc4_:CGVotingCandidateData = null;
         var _loc2_:Array = GetVotingItemsToVote(param1);
         if(!_loc2_ || _loc2_.length < 2)
         {
            return null;
         }
         var _loc3_:CGVotingCandidateData = _loc2_[0];
         for each(_loc4_ in _loc2_)
         {
            if(_loc4_ != _loc3_ && _loc4_.category == _loc3_.category)
            {
               return new Array(_loc3_,_loc4_);
            }
         }
         return null;
      }
      
      public static function FetchVotingPairs(param1:uint, param2:String) : void
      {
         var _loc4_:Object = null;
         if(!sCGVotingPairs)
         {
            sCGVotingPairs = new Array();
         }
         var _loc3_:Array = GetVotingPairOfSameType(param1);
         if(!_loc3_ || _loc3_.length < 2)
         {
            if(Boolean(sCGVotingPairsVoted) && sCGVotingPairsVoted.length > 0)
            {
               ReportVotes();
            }
            _loc4_ = new Object();
            _loc4_["type"] = param1;
            _loc4_["resultsCount"] = ExchangeDetailTunables.CG_VOTING_CANDIDATES_PER_SET;
            _loc4_["hashtag"] = param2;
            if(SystemUtils.IsConsole && !SharedExchangeUtils.CheckCrossPlatformPlayPermitted())
            {
               _loc4_["platform_restriction"] = SystemUtils.IsPS4 ? "PS" : "XBOX";
            }
            CommunicationManager.CallGameService("RequestCGVotingCandidates",_loc4_);
         }
      }
      
      public static function GetExchangeDataForPair(param1:String, param2:String, param3:String) : *
      {
         var _loc4_:Object = new Object();
         _loc4_["transactionId"] = param1;
         _loc4_["leftRemoteId"] = param2;
         _loc4_["rightRemoteId"] = param3;
         CommunicationManager.CallGameService("RequestGalleryItemsById",_loc4_);
      }
      
      public static function HandleDataResponse(param1:Object) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         ClearVotingPairs();
         if(!sCGVotingPairs)
         {
            sCGVotingPairs = new Array();
         }
         var _loc2_:Array = param1["items"];
         if(_loc2_)
         {
            _loc3_ = int(_loc2_.length);
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               sCGVotingPairs.push(new CGVotingCandidateData(_loc2_[_loc4_]));
               _loc4_++;
            }
            sCGVotingPairs.sort(RandomSort);
            sCurrentDigest = param1["digest"];
            sCurrentDigestSize = param1["digest_size"];
         }
      }
      
      protected static function RandomSort(param1:CGVotingCandidateData, param2:CGVotingCandidateData) : Number
      {
         return Math.random() < 0.5 ? -1 : 1;
      }
      
      public static function HandleSearchResponse(param1:Object, param2:CGVotingCandidateData, param3:CGVotingCandidateData) : *
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:ExchangeData = null;
         var _loc4_:Array = param1["items"];
         if(_loc4_)
         {
            _loc5_ = int(_loc4_.length);
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc7_ = new ExchangeData(_loc4_[_loc6_]);
               if(param2.remote_id == _loc7_.remote_id)
               {
                  param2.mExchangeData = _loc7_;
               }
               else if(param3.remote_id == _loc7_.remote_id)
               {
                  param3.mExchangeData = _loc7_;
               }
               _loc6_++;
            }
         }
      }
      
      public static function RecordPairVote(param1:CGVotingCandidateData, param2:CGVotingCandidateData) : void
      {
         if(!sCGVotingPairsVoted)
         {
            sCGVotingPairsVoted = new Array();
         }
         sCGVotingPairsVoted.push({
            "win":param1,
            "lsr":param2
         });
         RemoveVotingCandidate(param1);
         RemoveVotingCandidate(param2);
         if(sCGVotingPairs.length == 0)
         {
            ReportVotes();
         }
      }
      
      public static function RemoveVotingCandidate(param1:CGVotingCandidateData) : void
      {
         sCGVotingPairs.splice(sCGVotingPairs.indexOf(param1),1);
      }
      
      public static function ReportVotes() : void
      {
         var _loc4_:uint = 0;
         var _loc5_:Object = null;
         if(!sCurrentDigest)
         {
            return;
         }
         var _loc1_:Object = new Object();
         var _loc2_:Array = new Array();
         var _loc3_:Array = new Array();
         if(sCGVotingPairsVoted)
         {
            _loc4_ = 0;
            while(_loc4_ < sCGVotingPairsVoted.length)
            {
               _loc5_ = sCGVotingPairsVoted[_loc4_];
               _loc2_[_loc4_] = _loc5_.win.remote_id;
               _loc3_[_loc4_] = _loc5_.lsr.remote_id;
               _loc4_++;
            }
         }
         _loc1_["winner_ids"] = _loc2_;
         _loc1_["loser_ids"] = _loc3_;
         _loc1_["digest"] = sCurrentDigest;
         _loc1_["digest_size"] = sCurrentDigestSize;
         CommunicationManager.CallGameService("SubmitCGVoting",_loc1_);
         ClearVotes();
         sCurrentDigest = null;
         sCurrentDigestSize = 0;
      }
      
      public static function RefreshVotingContent() : void
      {
         ReportVotes();
         ClearVotes();
         ClearVotingPairs();
      }
      
      protected static function ClearVotingPairs() : void
      {
         if(!sCGVotingPairs)
         {
            return;
         }
         sCGVotingPairs.length = 0;
      }
      
      protected static function ClearVotes() : void
      {
         if(!sCGVotingPairsVoted)
         {
            return;
         }
         sCGVotingPairsVoted.length = 0;
      }
      
      protected static function CGVotingDataResponse(param1:Object) : void
      {
         var _loc5_:CGVotingData = null;
         if(!param1)
         {
            return;
         }
         CommunicationManager.RemoveMessageListenerByName("CGVotingResponse",CGVotingDataResponse,"ExchangeCGData");
         sCGVotingDataListPendingUpdate = false;
         var _loc2_:Array = param1["CGVotingData"];
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = new CGVotingData(_loc2_[_loc4_]);
            sCGVotingDataList[_loc4_] = _loc5_;
            _loc4_++;
         }
         CommunicationManager.SendMessage("CGVotingDataUpdated",sCGVotingDataList);
      }
   }
}

