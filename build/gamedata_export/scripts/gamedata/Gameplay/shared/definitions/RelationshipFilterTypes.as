package gamedata.Gameplay.shared.definitions
{
   import gamedata.GameContent;
   import gamedata.Gameplay.Clubs.ClubData;
   import gamedata.Gameplay.Kingdom.KingdomStaticData;
   import gamedata.Gameplay.Pickers.UiDialogPicker;
   import gamedata.Gameplay.shared.GameplayStateData;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.objects.RelationshipInfo;
   import olympus.objects.RelationshipTrackInfo;
   
   public class RelationshipFilterTypes
   {
      
      public static const FILTER_TYPES:Array = [ALL,FRIENDS,HOUSEHOLD,ROMANCE,FAMILY,COWORKERS];
      
      public static const ALL:String = "all";
      
      public static const FRIENDS:String = "friends";
      
      public static const HOUSEHOLD:String = "household";
      
      public static const ROMANCE:String = "romance";
      
      public static const COWORKERS:String = "coworkers";
      
      public static const CLUBS:String = "clubs";
      
      public static const KNOWN:String = "known";
      
      public static const PETS:String = "pets";
      
      public static const LIVESTOCK:String = "animals";
      
      public static const FAMILY:String = "family";
      
      public static const SOCIAL_MEDIA_FRIEND:String = "social_media_friend";
      
      public static const CUSTOM:String = "custom";
      
      public static const NOBILITY:String = "nobility";
      
      public static const LEADERSHIP:String = "leadership";
      
      public static const BLACK_SHEEP:String = "black_sheep";
      
      public static const POOR_PERFORMERS:String = "poor_performers";
      
      public function RelationshipFilterTypes()
      {
         super();
      }
      
      public static function GetRelationshipInfo(param1:String) : Vector.<RelationshipInfo>
      {
         var _loc2_:Array = null;
         var _loc3_:Vector.<RelationshipInfo> = null;
         var _loc4_:Object = null;
         if(param1 == GameplayStateData.ActiveSimId)
         {
            return GameplayStateData.AllRelationshipInfo;
         }
         _loc2_ = CommunicationManager.CallGameService("GetAllSimRelationshipInfo",{"actorSimId":param1}) as Array;
         _loc3_ = new Vector.<RelationshipInfo>();
         for each(_loc4_ in _loc2_)
         {
            _loc3_.push(new RelationshipInfo(_loc4_));
         }
         return _loc3_;
      }
      
      public static function SetRelationshipInfo(param1:Array) : void
      {
         CommunicationManager.CallGameService("SetSimRelationshipInfo",{"relInfo":param1});
      }
      
      public static function IsKnown(param1:String, param2:RelationshipInfo) : Boolean
      {
         var _loc3_:RelationshipTrackInfo = null;
         for each(_loc3_ in param2.relTracks)
         {
            if(_loc3_.CurrentTrackScore > 0)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function IsFriend(param1:String, param2:RelationshipInfo) : Boolean
      {
         var _loc3_:RelationshipTrackInfo = null;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         for each(_loc3_ in param2.relTracks)
         {
            _loc4_ = (_loc3_.track_id == RelationshipTrackStaticData.FriendshipTrackId || RelationshipTrackStaticData.IsSimToObjFriendshipTrack(_loc3_.track_id)) && (_loc3_.CurrentTrackScore >= RelationshipTrackStaticData.FriendshipFilterThreshold || param2.HasBitsInRelInfo(RelationshipTrackStaticData.FriendshipFilterBits));
            _loc5_ = _loc3_.track_id == RelationshipTrackStaticData.SimToAnimalObjectFriendshipTrackId && _loc3_.CurrentTrackScore >= RelationshipTrackStaticData.SimToAnimalObjectFriendshipFilterThreshold;
            _loc6_ = _loc3_.track_id == RelationshipTrackStaticData.SimToPetFriendshipTrackId && _loc3_.CurrentTrackScore >= RelationshipTrackStaticData.SimToPetFriendshipFilterThreshold;
            if(_loc4_ || _loc6_ || _loc5_)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function HasRomance(param1:String, param2:RelationshipInfo) : Boolean
      {
         var _loc3_:RelationshipTrackInfo = null;
         for each(_loc3_ in param2.relTracks)
         {
            if(_loc3_.track_id == RelationshipTrackStaticData.RomanceTrackId)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function IsSimInClub(param1:String, param2:Array) : Boolean
      {
         var _loc4_:ClubData = null;
         var _loc5_:ClubData = null;
         var _loc3_:Array = CommunicationManager.CallGameService("GetSimsClubs",param1) as Array;
         OlympusObject.ConstructArrayInPlace(_loc3_,ClubData);
         for each(_loc4_ in _loc3_)
         {
            for each(_loc5_ in param2)
            {
               if(_loc4_.club_id == _loc5_.club_id)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public static function IsCoworker(param1:String, param2:RelationshipInfo) : Boolean
      {
         return param2.HasBitsInRelInfo(RelationshipTrackStaticData.CoworkerFilterBits);
      }
      
      public static function IsFamily(param1:String, param2:RelationshipInfo) : Boolean
      {
         return param2.HasBitsInRelInfo(RelationshipTrackStaticData.FamilyFilterBits);
      }
      
      public static function IsRoommate(param1:String, param2:RelationshipInfo) : Boolean
      {
         return param2.HasBitsInRelInfo(RelationshipTrackStaticData.RoommateFilterBits);
      }
      
      public static function IsSocialMediaFriend(param1:String, param2:RelationshipInfo) : Boolean
      {
         return param2.HasBitsInRelInfo(RelationshipTrackStaticData.SocialMediaFilterBits);
      }
      
      public static function IsStayover(param1:String, param2:RelationshipInfo) : Boolean
      {
         return param2.HasBitsInRelInfo(RelationshipTrackStaticData.StayoverFilterBits);
      }
      
      public static function IsNoble(param1:String) : Boolean
      {
         var _loc5_:Object = null;
         var _loc2_:Array = CommunicationManager.CallGameService("GetSimCareerInfo",param1) as Array;
         var _loc3_:String = KingdomStaticData.GetStaticData().noble_career;
         var _loc4_:* = false;
         for each(_loc5_ in _loc2_)
         {
            _loc4_ = _loc5_.career_uid == _loc3_ ? true : false;
         }
         return _loc4_;
      }
      
      public static function GetFunctionFromFilterType(param1:String) : Function
      {
         switch(param1)
         {
            case FRIENDS:
               return IsFriend;
            case FAMILY:
               return IsFamily;
            case ROMANCE:
               return HasRomance;
            case KNOWN:
               return IsKnown;
            case CLUBS:
               return IsSimInClub;
            case COWORKERS:
               return IsCoworker;
            case HOUSEHOLD:
               return null;
            case PETS:
               return null;
            case LIVESTOCK:
               return null;
            case SOCIAL_MEDIA_FRIEND:
               return IsSocialMediaFriend;
            case NOBILITY:
               return IsNoble;
            default:
               return null;
         }
      }
      
      public static function GetFilters(param1:int) : Array
      {
         var _loc2_:Array = RelationshipFilterTypes.FILTER_TYPES.concat();
         if(GameContent.HAS_EP02)
         {
            _loc2_.push(RelationshipFilterTypes.CLUBS);
         }
         if(param1 == UiDialogPicker.OBJECTPICKERTYPE_SIM_CLUB)
         {
            _loc2_.splice(1,0,RelationshipFilterTypes.KNOWN);
         }
         else if(GameContent.HAS_EP04)
         {
            _loc2_.push(RelationshipFilterTypes.PETS);
         }
         return _loc2_;
      }
   }
}

