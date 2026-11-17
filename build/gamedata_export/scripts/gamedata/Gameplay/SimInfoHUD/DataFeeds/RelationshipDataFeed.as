package gamedata.Gameplay.SimInfoHUD.DataFeeds
{
   import gamedata.Gameplay.shared.GameplayStateData;
   import gamedata.Gameplay.shared.definitions.RelationshipFilterTypes;
   import gamedata.Gameplay.shared.definitions.RelationshipTrackStaticData;
   import gamedata.shared.CreatureTypes;
   import gamedata.shared.ManagerObjectId;
   import gamedata.shared.Species;
   import olympus.data.ArrayDataFeed;
   import olympus.extensions.datafeed.SortFilterExtension;
   import olympus.io.CommunicationManager;
   import olympus.objects.RelationshipByIdInfo;
   import olympus.objects.RelationshipDeleteById;
   import olympus.objects.RelationshipInfo;
   import olympus.objects.RelationshipTrackInfo;
   import olympus.objects.SimPB;
   
   public class RelationshipDataFeed extends ArrayDataFeed
   {
      
      protected var mHouseholdSims:Array;
      
      protected var mFilterType:String;
      
      protected var mFilterExtension:SortFilterExtension;
      
      public var mbIgnoreUpdates:Boolean = false;
      
      public function RelationshipDataFeed()
      {
         super();
         this.mHouseholdSims = GameplayStateData.SelectableSims;
         this.mFilterExtension = this.GetExtension(SortFilterExtension) as SortFilterExtension;
      }
      
      public function get FilterType() : String
      {
         return this.mFilterType;
      }
      
      public function HandleUpdateSimRelationship(param1:RelationshipByIdInfo) : void
      {
         var _loc4_:int = 0;
         if(this.mbIgnoreUpdates)
         {
            return;
         }
         var _loc2_:ManagerObjectId = param1.managerObjectId;
         if(param1.relInfo.actorId != GameplayStateData.ActiveSimId)
         {
            return;
         }
         var _loc3_:Boolean = this.ReplaceItemByFieldName("targetId",param1.relInfo);
         if(!_loc3_)
         {
            if(!this.FilterVisibleInRelationshipPanel(param1.relInfo))
            {
               return;
            }
            this.AddItem(param1.relInfo);
         }
         else if(_loc3_ && param1.relInfo.hidden)
         {
            _loc4_ = this.GetItemIndexByFieldName("targetId",param1.relInfo.targetId);
            this.RemoveItemAt(_loc4_);
         }
      }
      
      public function HandleSimDeleteRelationship(param1:RelationshipDeleteById) : void
      {
         if(param1.actorId != GameplayStateData.ActiveSimId)
         {
            return;
         }
         var _loc2_:int = this.GetItemIndexByFieldName("targetId",param1.targetId);
         this.RemoveItemAt(_loc2_);
      }
      
      public function HandleSimActivated(param1:Object) : void
      {
         var allRelationshipInfo:Vector.<RelationshipInfo>;
         var args:Object = param1;
         this.mbIgnoreUpdates = true;
         IterateWith(function(param1:RelationshipInfo):void
         {
            if(param1.IsSimRelationship())
            {
               GameplayStateData.DisableRelationshipInfoNewValueFlags(param1.targetId,param1.actorId);
            }
         });
         this.mbIgnoreUpdates = false;
         RemoveAllItems();
         allRelationshipInfo = GameplayStateData.AllRelationshipInfo;
         this.AddItemsFromIterableConditional(allRelationshipInfo,this.FilterVisibleInRelationshipPanel);
         this.FilterOnRelationship(this.mFilterType);
      }
      
      public function HandleUpdateSelectableSims(param1:Object) : void
      {
         this.mHouseholdSims = GameplayStateData.SelectableSims;
         if(this.mFilterType == RelationshipFilterTypes.HOUSEHOLD)
         {
            this.FilterOnRelationship(this.mFilterType);
         }
      }
      
      public function HandleSimOutfitChange(param1:Object) : void
      {
         var _loc2_:String = param1.simId as String;
         var _loc3_:int = this.GetItemIndexByFieldName("targetId",_loc2_);
         this.MarkRangeDirty(_loc3_,_loc3_);
      }
      
      protected function FilterVisibleInRelationshipPanel(param1:Object) : Boolean
      {
         var _loc3_:RelationshipTrackInfo = null;
         if(param1.hidden)
         {
            return false;
         }
         var _loc2_:Array = param1.relTracks;
         for each(_loc3_ in _loc2_)
         {
            if(!_loc3_.visible_in_relationship_panel)
            {
               return false;
            }
         }
         return _loc2_.length > 0;
      }
      
      public function FilterOnRelationship(param1:String, param2:Boolean = true) : void
      {
         var _loc3_:Function = null;
         this.mFilterType = param1;
         switch(param1)
         {
            case RelationshipFilterTypes.ALL:
               _loc3_ = null;
               break;
            case RelationshipFilterTypes.FAMILY:
               _loc3_ = this.FamilyFilterFunction;
               break;
            case RelationshipFilterTypes.FRIENDS:
               _loc3_ = this.FriendsFilterFunction;
               break;
            case RelationshipFilterTypes.HOUSEHOLD:
               _loc3_ = this.HouseholdFilterFunction;
               break;
            case RelationshipFilterTypes.ROMANCE:
               _loc3_ = this.RomanceFilterFunction;
               break;
            case RelationshipFilterTypes.CLUBS:
               _loc3_ = this.ClubsFilterFunction;
               break;
            case RelationshipFilterTypes.PETS:
               _loc3_ = this.PetFilterFunction;
               break;
            case RelationshipFilterTypes.COWORKERS:
               _loc3_ = this.CoworkersFilterFunction;
               break;
            case RelationshipFilterTypes.LIVESTOCK:
               _loc3_ = this.LivestockFilterFunction;
               break;
            case RelationshipFilterTypes.SOCIAL_MEDIA_FRIEND:
               _loc3_ = this.SocialMediaFilterFunction;
         }
         var _loc4_:Number = Array.CASEINSENSITIVE;
         this.mFilterExtension.SortFilterByFunction(_loc3_,this.RelInfoSortFunction,null,param2);
      }
      
      protected function RelInfoSortFunction(param1:RelationshipInfo, param2:RelationshipInfo) : int
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         if(param1.displayOrder != param2.displayOrder)
         {
            _loc3_ = uint(param1.displayOrder);
            _loc4_ = uint(param2.displayOrder);
            return _loc4_ > _loc3_ ? 1 : -1;
         }
         if(Boolean(param1.targetFirstName) && Boolean(param2.targetFirstName))
         {
            return param1.targetFirstName.localeCompare(param2.targetFirstName);
         }
         return 1;
      }
      
      protected function FriendsFilterFunction(param1:RelationshipInfo) : Boolean
      {
         var _loc3_:RelationshipTrackInfo = null;
         var _loc2_:Array = param1.relTracks;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.track_id == RelationshipTrackStaticData.FriendshipTrackId || RelationshipTrackStaticData.IsSimToObjFriendshipTrack(_loc3_.track_id))
            {
               if(_loc3_.CurrentTrackScore >= Number(RelationshipTrackStaticData.FriendshipFilterThreshold) || param1.HasBitsInRelInfo(RelationshipTrackStaticData.FriendshipFilterBits))
               {
                  return true;
               }
            }
            else if(_loc3_.track_id == RelationshipTrackStaticData.SimToAnimalObjectFriendshipTrackId)
            {
               if(_loc3_.CurrentTrackScore >= RelationshipTrackStaticData.SimToAnimalObjectFriendshipFilterThreshold)
               {
                  return true;
               }
            }
            else if(_loc3_.track_id == RelationshipTrackStaticData.SimToPetFriendshipTrackId)
            {
               if(_loc3_.CurrentTrackScore >= RelationshipTrackStaticData.SimToPetFriendshipFilterThreshold)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      protected function HouseholdFilterFunction(param1:RelationshipInfo) : Boolean
      {
         var _loc4_:SimPB = null;
         var _loc2_:String = param1.targetId;
         var _loc3_:Array = this.mHouseholdSims;
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.id == _loc2_)
            {
               return true;
            }
         }
         return this.RoommatesFilterFunction(param1) || this.StayoverFilterFunction(param1);
      }
      
      protected function RomanceFilterFunction(param1:RelationshipInfo) : Boolean
      {
         var _loc2_:RelationshipTrackInfo = null;
         for each(_loc2_ in param1.relTracks)
         {
            if(_loc2_.track_id == RelationshipTrackStaticData.RomanceTrackId)
            {
               return true;
            }
         }
         return false;
      }
      
      protected function ClubsFilterFunction(param1:RelationshipInfo) : Boolean
      {
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc2_:Array = CommunicationManager.CallGameService("GetSimsClubs",param1.targetId) as Array;
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = _loc3_.members as Array;
            for each(_loc5_ in _loc4_)
            {
               if(_loc5_ == GameplayStateData.ActiveSimId)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      protected function PetFilterFunction(param1:RelationshipInfo) : Boolean
      {
         return Species.IsPet(param1.targetSpecies);
      }
      
      protected function CoworkersFilterFunction(param1:RelationshipInfo) : Boolean
      {
         return param1.HasBitsInRelInfo(RelationshipTrackStaticData.CoworkerFilterBits) || this.MultiUnitFilterFunction(param1);
      }
      
      protected function RoommatesFilterFunction(param1:RelationshipInfo) : Boolean
      {
         return param1.HasBitsInRelInfo(RelationshipTrackStaticData.RoommateFilterBits);
      }
      
      protected function FamilyFilterFunction(param1:RelationshipInfo) : Boolean
      {
         return param1.HasBitsInRelInfo(RelationshipTrackStaticData.FamilyFilterBits);
      }
      
      protected function LivestockFilterFunction(param1:RelationshipInfo) : Boolean
      {
         if(param1.targetManagerId == ManagerObjectId.MGR_OBJECT)
         {
            if(CreatureTypes.IsLivestock(param1.creatureType))
            {
               return true;
            }
         }
         return false;
      }
      
      protected function SocialMediaFilterFunction(param1:RelationshipInfo) : Boolean
      {
         return param1.HasBitsInRelInfo(RelationshipTrackStaticData.SocialMediaFilterBits);
      }
      
      protected function StayoverFilterFunction(param1:RelationshipInfo) : Boolean
      {
         return param1.HasBitsInRelInfo(RelationshipTrackStaticData.StayoverFilterBits);
      }
      
      protected function MultiUnitFilterFunction(param1:RelationshipInfo) : Boolean
      {
         return param1.HasBitsInRelInfo(RelationshipTrackStaticData.MultiUnitFilterBits);
      }
   }
}

