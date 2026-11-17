package gamedata.Gameplay.shared.definitions
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   
   public class RelationshipTrackStaticData extends OlympusObject
   {
      
      protected static var sRelationshipTrackData:RelationshipTrackStaticData;
      
      public var familyFilterBits:* = [String];
      
      public var friendshipTrackId:String;
      
      public var friendshipFilterThreshold:int;
      
      public var friendshipFilterBits:Array = [String];
      
      public var romanceTrackId:String;
      
      public var romanceFilterBits:Array = [String];
      
      public var romanceFilterThreshold:int;
      
      public var coworkerFilterBits:Array = [String];
      
      public var simToAnimalObjectFriendshipTrackId:String;
      
      public var simToAnimalObjectFriendshipFilterThreshold:int;
      
      public var simToPetFriendshipTrackId:String;
      
      public var simToPetFriendshipFilterThreshold:int;
      
      public var petToPetFriendshipTrackId:String;
      
      public var objectBasedFriendshipTracks:Array = [String];
      
      public var roommateFilterBits:Array = [String];
      
      public var socialMediaFilterBits:Array = [String];
      
      public var stayoverFilterBits:Array = [String];
      
      public var attractionRelationshipTrackId:String;
      
      public var attractionUnknownDescription:LocKey = new LocKey();
      
      public var attractionUnknownIcon:ResourceKey = new ResourceKey();
      
      public var attractionUnknownTitle:LocKey = new LocKey();
      
      public var relationshipSatisfactionTrackId:String;
      
      public var relationshipSatisfactionUnknownDescription:LocKey = new LocKey();
      
      public var relationshipSatisfactionUnknownIcon:ResourceKey = new ResourceKey();
      
      public var relationshipSatisfactionUnknownTitle:LocKey = new LocKey();
      
      public var multiUnitFilterBits:Array = [String];
      
      public function RelationshipTrackStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetStaticData() : RelationshipTrackStaticData
      {
         if(!sRelationshipTrackData)
         {
            sRelationshipTrackData = new RelationshipTrackStaticData(CommunicationManager.CallGameService("GetRelationshipTracksStaticData",null,true));
         }
         return sRelationshipTrackData;
      }
      
      public static function get FriendshipTrackId() : String
      {
         var _loc1_:RelationshipTrackStaticData = GetStaticData();
         return _loc1_ ? _loc1_.friendshipTrackId : null;
      }
      
      public static function get FriendshipFilterThreshold() : int
      {
         var _loc1_:RelationshipTrackStaticData = GetStaticData();
         return _loc1_ ? _loc1_.friendshipFilterThreshold : 0;
      }
      
      public static function get RomanceTrackId() : String
      {
         var _loc1_:RelationshipTrackStaticData = GetStaticData();
         return _loc1_ ? _loc1_.romanceTrackId : null;
      }
      
      public static function get RomanceFilterThreshold() : int
      {
         var _loc1_:RelationshipTrackStaticData = GetStaticData();
         return _loc1_ ? _loc1_.romanceFilterThreshold : 0;
      }
      
      public static function get FamilyFilterBits() : Array
      {
         var _loc1_:RelationshipTrackStaticData = GetStaticData();
         return _loc1_ ? _loc1_.familyFilterBits : new Array();
      }
      
      public static function get FriendshipFilterBits() : Array
      {
         var _loc1_:RelationshipTrackStaticData = GetStaticData();
         return _loc1_ ? _loc1_.friendshipFilterBits : new Array();
      }
      
      public static function get RomanceFilterBits() : Array
      {
         var _loc1_:RelationshipTrackStaticData = GetStaticData();
         return _loc1_ ? _loc1_.romanceFilterBits : new Array();
      }
      
      public static function get CoworkerFilterBits() : Array
      {
         var _loc1_:RelationshipTrackStaticData = GetStaticData();
         return _loc1_ ? _loc1_.coworkerFilterBits : new Array();
      }
      
      public static function get SimToAnimalObjectFriendshipTrackId() : String
      {
         var _loc1_:RelationshipTrackStaticData = GetStaticData();
         return _loc1_ ? _loc1_.simToAnimalObjectFriendshipTrackId : null;
      }
      
      public static function get SimToAnimalObjectFriendshipFilterThreshold() : int
      {
         var _loc1_:RelationshipTrackStaticData = GetStaticData();
         return _loc1_ ? _loc1_.simToAnimalObjectFriendshipFilterThreshold : 0;
      }
      
      public static function get SimToPetFriendshipTrackId() : String
      {
         var _loc1_:RelationshipTrackStaticData = GetStaticData();
         return _loc1_ ? _loc1_.simToPetFriendshipTrackId : null;
      }
      
      public static function get SimToPetFriendshipFilterThreshold() : int
      {
         var _loc1_:RelationshipTrackStaticData = GetStaticData();
         return _loc1_ ? _loc1_.simToPetFriendshipFilterThreshold : 0;
      }
      
      public static function get PetToPetFriendshipTrackId() : String
      {
         var _loc1_:RelationshipTrackStaticData = GetStaticData();
         return _loc1_ ? _loc1_.petToPetFriendshipTrackId : null;
      }
      
      public static function IsSimToObjFriendshipTrack(param1:String) : Boolean
      {
         var _loc2_:RelationshipTrackStaticData = GetStaticData();
         if(!_loc2_)
         {
            return false;
         }
         return _loc2_.objectBasedFriendshipTracks.indexOf(param1) != -1;
      }
      
      public static function get RoommateFilterBits() : Array
      {
         var _loc1_:RelationshipTrackStaticData = GetStaticData();
         return _loc1_ ? _loc1_.roommateFilterBits : new Array();
      }
      
      public static function get SocialMediaFilterBits() : Array
      {
         var _loc1_:RelationshipTrackStaticData = GetStaticData();
         return _loc1_ ? _loc1_.socialMediaFilterBits : new Array();
      }
      
      public static function get StayoverFilterBits() : Array
      {
         var _loc1_:RelationshipTrackStaticData = GetStaticData();
         return _loc1_ ? _loc1_.stayoverFilterBits : new Array();
      }
      
      public static function get AttractionRelationshipTrackId() : String
      {
         var _loc1_:RelationshipTrackStaticData = GetStaticData();
         return _loc1_ ? _loc1_.attractionRelationshipTrackId : null;
      }
      
      public static function HasAttractionRelTrackId() : Boolean
      {
         var _loc1_:* = AttractionRelationshipTrackId;
         return _loc1_ != null && _loc1_ != "0";
      }
      
      public static function get RelationshipSatisfactionTrackId() : String
      {
         var _loc1_:RelationshipTrackStaticData = GetStaticData();
         return _loc1_ ? _loc1_.relationshipSatisfactionTrackId : null;
      }
      
      public static function HasSatisfactionRelTrackId() : Boolean
      {
         var _loc1_:* = RelationshipSatisfactionTrackId;
         return _loc1_ != null && _loc1_ != "0";
      }
      
      public static function get MultiUnitFilterBits() : Array
      {
         var _loc1_:RelationshipTrackStaticData = GetStaticData();
         return _loc1_ ? _loc1_.multiUnitFilterBits : new Array();
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.familyFilterBits);
         FixupArray(this.friendshipFilterBits);
         FixupArray(this.romanceFilterBits);
         FixupArray(this.coworkerFilterBits);
         FixupArray(this.objectBasedFriendshipTracks);
         FixupArray(this.roommateFilterBits);
         FixupArray(this.socialMediaFilterBits);
         FixupArray(this.stayoverFilterBits);
         FixupArray(this.multiUnitFilterBits);
      }
   }
}

