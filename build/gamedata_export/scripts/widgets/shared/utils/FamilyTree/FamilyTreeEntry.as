package widgets.shared.utils.FamilyTree
{
   import olympus.utils.Functional;
   
   public class FamilyTreeEntry
   {
      
      public static const RELATION_DEFAULT:uint = 0;
      
      public static const RELATION_MARRIED:uint = 1;
      
      public static const RELATION_DIVORCED:uint = 2;
      
      public static const RELATION_NONE:uint = 3;
      
      protected var mLeftSim:String;
      
      protected var mRightSim:String;
      
      protected var mOuterLeftSim:String;
      
      protected var mOuterRightSim:String;
      
      protected var mMainRelationType:uint;
      
      protected var mOuterLeftRelationType:uint;
      
      protected var mOuterRightRelationType:uint;
      
      protected var mChildrenGroupsOfIds:Object;
      
      protected var mChildrenGroupsOfEntries:Object;
      
      protected var mFakeEntryChildrenEntries:Array;
      
      protected var mParentEntry:FamilyTreeEntry = null;
      
      protected var mbIsRoot:Boolean = false;
      
      protected var mbIsFakeEntry:Boolean = false;
      
      protected var mLeftSiblingEntry:FamilyTreeEntry = null;
      
      protected var mRightSiblingEntry:FamilyTreeEntry = null;
      
      protected var mLeftmostChildEntry:FamilyTreeEntry = null;
      
      protected var mRightmostChildEntry:FamilyTreeEntry = null;
      
      protected var mWidth:int = 1;
      
      protected var mMod:int = 0;
      
      protected var mShift:int;
      
      protected var mXPos:int;
      
      protected var mGeneration:int = 0;
      
      protected var mDepth:int = 0;
      
      protected var mbFirstPlacementPassComplete:Boolean = false;
      
      protected var mbSecondPlacementPassComplete:Boolean = false;
      
      protected var mbThirdPlacementPassComplete:Boolean = false;
      
      public function FamilyTreeEntry(param1:int = 0, param2:Boolean = false)
      {
         super();
         this.mGeneration = param1;
         this.mbIsFakeEntry = param2;
         this.mChildrenGroupsOfIds = {};
         this.mChildrenGroupsOfEntries = {};
      }
      
      public function get LeftSim() : String
      {
         return this.mLeftSim;
      }
      
      public function set LeftSim(param1:String) : void
      {
         this.mLeftSim = param1;
      }
      
      public function get RightSim() : String
      {
         return this.mRightSim;
      }
      
      public function set RightSim(param1:String) : void
      {
         this.mRightSim = param1;
      }
      
      public function get OuterLeftSim() : String
      {
         return this.mOuterLeftSim;
      }
      
      public function set OuterLeftSim(param1:String) : void
      {
         this.mOuterLeftSim = param1;
      }
      
      public function get OuterRightSim() : String
      {
         return this.mOuterRightSim;
      }
      
      public function set OuterRightSim(param1:String) : void
      {
         this.mOuterRightSim = param1;
      }
      
      public function get MainRelationType() : uint
      {
         return this.mMainRelationType;
      }
      
      public function set MainRelationType(param1:uint) : void
      {
         this.mMainRelationType = param1;
      }
      
      public function get OuterLeftRelationType() : uint
      {
         return this.mOuterLeftRelationType;
      }
      
      public function set OuterLeftRelationType(param1:uint) : void
      {
         this.mOuterLeftRelationType = param1;
      }
      
      public function get OuterRightRelationType() : uint
      {
         return this.mOuterRightRelationType;
      }
      
      public function set OuterRightRelationType(param1:uint) : void
      {
         this.mOuterRightRelationType = param1;
      }
      
      public function get ChildrenGroupsOfIds() : Object
      {
         return this.mChildrenGroupsOfIds;
      }
      
      public function set ChildrenGroupsOfIds(param1:Object) : void
      {
         this.mChildrenGroupsOfIds = param1;
      }
      
      public function get ChildrenGroupsOfEntries() : Object
      {
         return this.mChildrenGroupsOfEntries;
      }
      
      public function set ChildrenGroupsOfEntries(param1:Object) : void
      {
         this.mChildrenGroupsOfEntries = param1;
      }
      
      public function get FakeEntryChildrenEntries() : Array
      {
         return this.mFakeEntryChildrenEntries;
      }
      
      public function set FakeEntryChildrenEntries(param1:Array) : void
      {
         this.mFakeEntryChildrenEntries = param1;
      }
      
      public function get ParentEntry() : FamilyTreeEntry
      {
         return this.mParentEntry;
      }
      
      public function set ParentEntry(param1:FamilyTreeEntry) : void
      {
         this.mParentEntry = param1;
      }
      
      public function get IsRoot() : Boolean
      {
         return this.mbIsRoot;
      }
      
      public function set IsRoot(param1:Boolean) : void
      {
         this.mbIsRoot = param1;
      }
      
      public function get IsFakeEntry() : Boolean
      {
         return this.mbIsFakeEntry;
      }
      
      public function set IsFakeEntry(param1:Boolean) : void
      {
         this.mbIsFakeEntry = param1;
      }
      
      public function get LeftSiblingEntry() : FamilyTreeEntry
      {
         return this.mLeftSiblingEntry;
      }
      
      public function set LeftSiblingEntry(param1:FamilyTreeEntry) : void
      {
         this.mLeftSiblingEntry = param1;
      }
      
      public function get RightSiblingEntry() : FamilyTreeEntry
      {
         return this.mRightSiblingEntry;
      }
      
      public function set RightSiblingEntry(param1:FamilyTreeEntry) : void
      {
         this.mRightSiblingEntry = param1;
      }
      
      public function get LeftmostChildEntry() : FamilyTreeEntry
      {
         return this.mLeftmostChildEntry;
      }
      
      public function set LeftmostChildEntry(param1:FamilyTreeEntry) : void
      {
         this.mLeftmostChildEntry = param1;
      }
      
      public function get RightmostChildEntry() : FamilyTreeEntry
      {
         return this.mRightmostChildEntry;
      }
      
      public function set RightmostChildEntry(param1:FamilyTreeEntry) : void
      {
         this.mRightmostChildEntry = param1;
      }
      
      public function get Width() : int
      {
         return this.mWidth;
      }
      
      public function set Width(param1:int) : void
      {
         this.mWidth = param1;
      }
      
      public function get Mod() : int
      {
         return this.mMod;
      }
      
      public function set Mod(param1:int) : void
      {
         this.mMod = param1;
      }
      
      public function get Shift() : int
      {
         return this.mShift;
      }
      
      public function set Shift(param1:int) : void
      {
         this.mShift = param1;
      }
      
      public function get XPos() : int
      {
         return this.mXPos;
      }
      
      public function set XPos(param1:int) : void
      {
         this.mXPos = param1;
      }
      
      public function get Depth() : int
      {
         return this.mDepth;
      }
      
      public function set Depth(param1:int) : void
      {
         this.mDepth = param1;
      }
      
      public function get Generation() : int
      {
         return this.mGeneration;
      }
      
      public function set Generation(param1:int) : void
      {
         this.mGeneration = param1;
      }
      
      public function get FirstPlacementPassComplete() : Boolean
      {
         return this.mbFirstPlacementPassComplete;
      }
      
      public function set FirstPlacementPassComplete(param1:Boolean) : void
      {
         this.mbFirstPlacementPassComplete = param1;
      }
      
      public function get SecondPlacementPassComplete() : Boolean
      {
         return this.mbSecondPlacementPassComplete;
      }
      
      public function set SecondPlacementPassComplete(param1:Boolean) : void
      {
         this.mbSecondPlacementPassComplete = param1;
      }
      
      public function get ThirdPlacementPassComplete() : Boolean
      {
         return this.mbThirdPlacementPassComplete;
      }
      
      public function set ThirdPlacementPassComplete(param1:Boolean) : void
      {
         this.mbThirdPlacementPassComplete = param1;
      }
      
      public function UpdateEntryWidth() : void
      {
         var _loc1_:int = 0;
         if(this.mLeftSim)
         {
            _loc1_++;
         }
         if(this.mRightSim)
         {
            _loc1_++;
         }
         if(this.mOuterLeftSim)
         {
            _loc1_++;
         }
         if(this.mOuterRightSim)
         {
            _loc1_++;
         }
         this.mWidth = _loc1_ * 2 - 1;
      }
      
      public function CombineIds(param1:String, param2:String = null) : String
      {
         var _loc3_:String = null;
         var _loc4_:Array = null;
         if(Boolean(param1) && Boolean(param2))
         {
            _loc4_ = param1 > param2 ? [param2,param1] : [param1,param2];
            _loc3_ = _loc4_[0] + "," + _loc4_[1];
         }
         else
         {
            _loc3_ = param1;
         }
         return _loc3_;
      }
      
      public function EnsureChildGroupExists(param1:String) : void
      {
         if(!(param1 in this.mChildrenGroupsOfIds))
         {
            this.mChildrenGroupsOfIds[param1] = [];
         }
         if(!(param1 in this.mChildrenGroupsOfEntries))
         {
            this.mChildrenGroupsOfEntries[param1] = [];
         }
      }
      
      public function AddChildId(param1:String, param2:String, param3:String = null) : void
      {
         var _loc5_:Array = null;
         var _loc4_:String = this.CombineIds(param2,param3);
         if(_loc4_)
         {
            this.EnsureChildGroupExists(_loc4_);
            _loc5_ = this.mChildrenGroupsOfIds[_loc4_];
            _loc5_.push(param1);
            _loc5_.sort(Array.NUMERIC);
         }
      }
      
      public function AddChildrenIds(param1:Array, param2:String, param3:String = null) : void
      {
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc4_:String = this.CombineIds(param2,param3);
         if(_loc4_)
         {
            this.EnsureChildGroupExists(_loc4_);
            _loc5_ = this.mChildrenGroupsOfIds[_loc4_];
            for each(_loc6_ in param1)
            {
               if(_loc5_.indexOf(_loc6_) == -1)
               {
                  _loc5_.push(_loc6_);
               }
            }
            _loc5_.sort(Array.NUMERIC);
         }
      }
      
      public function SetChildrenIds(param1:Array, param2:String, param3:String = null) : void
      {
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc4_:String = this.CombineIds(param2,param3);
         if(_loc4_)
         {
            this.mChildrenGroupsOfIds[_loc4_] = [];
            _loc5_ = this.mChildrenGroupsOfIds[_loc4_];
            for each(_loc6_ in param1)
            {
               if(_loc5_.indexOf(_loc6_) == -1)
               {
                  _loc5_.push(_loc6_);
               }
            }
            _loc5_.sort(Array.NUMERIC);
         }
      }
      
      public function ClearRedundantChildrenIds() : void
      {
         if(Boolean(this.mOuterLeftSim) && Boolean(this.mLeftSim))
         {
            this._ClearRedundantChildrenIdsFromGroup(this.mOuterLeftSim,this.mLeftSim);
         }
         if(Boolean(this.mLeftSim) && Boolean(this.mRightSim))
         {
            this._ClearRedundantChildrenIdsFromGroup(this.mLeftSim,this.mRightSim);
         }
         if(Boolean(this.mRightSim) && Boolean(this.mOuterRightSim))
         {
            this._ClearRedundantChildrenIdsFromGroup(this.mRightSim,this.mOuterRightSim);
         }
      }
      
      public function GetSimIds() : Array
      {
         return [this.mOuterLeftSim,this.mLeftSim,this.mRightSim,this.mOuterRightSim].filter(Functional.IsNotNull);
      }
      
      public function GetChildrenIdsOf(param1:String, param2:String = null) : Array
      {
         var _loc3_:String = this.CombineIds(param1,param2);
         this.EnsureChildGroupExists(_loc3_);
         return this.mChildrenGroupsOfIds[_loc3_];
      }
      
      public function GetChildrenEntriesOf(param1:String, param2:String = null) : Array
      {
         var _loc3_:String = this.CombineIds(param1,param2);
         this.EnsureChildGroupExists(_loc3_);
         return this.mChildrenGroupsOfEntries[_loc3_];
      }
      
      public function AddChildEntryByKey(param1:FamilyTreeEntry, param2:String) : void
      {
         var _loc3_:Array = null;
         if(Boolean(param2) && Boolean(param1))
         {
            this.EnsureChildGroupExists(param2);
            _loc3_ = this.mChildrenGroupsOfEntries[param2];
            _loc3_.push(param1);
         }
      }
      
      public function IsSingleSim() : Boolean
      {
         return this.mLeftSim && !this.mRightSim && !this.mOuterLeftSim && !this.mOuterRightSim;
      }
      
      public function ContainsSimId(param1:String) : Boolean
      {
         return param1 ? this.mLeftSim == param1 || this.mRightSim == param1 || this.mOuterLeftSim == param1 || this.mOuterRightSim == param1 : false;
      }
      
      public function GetChildKeysInOrder() : Array
      {
         return [this.mOuterLeftSim,this.CombineIds(this.mOuterLeftSim,this.mLeftSim),this.mLeftSim,this.CombineIds(this.mRightSim,this.mLeftSim),this.mRightSim,this.CombineIds(this.mOuterRightSim,this.mRightSim),this.mOuterRightSim].filter(Functional.IsNotNull);
      }
      
      public function GetAllChildrenSimIds() : Array
      {
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc1_:Array = [];
         var _loc2_:Array = this.GetChildKeysInOrder();
         for each(_loc3_ in _loc2_)
         {
            this.EnsureChildGroupExists(_loc3_);
            _loc4_ = this.mChildrenGroupsOfIds[_loc3_];
            _loc1_ = _loc1_.concat(_loc4_);
         }
         return _loc1_;
      }
      
      public function GetAllChildrenSimIdsWithKeys() : Array
      {
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc1_:Array = [];
         var _loc2_:Array = this.GetChildKeysInOrder();
         for each(_loc3_ in _loc2_)
         {
            this.EnsureChildGroupExists(_loc3_);
            _loc4_ = this.mChildrenGroupsOfIds[_loc3_];
            for each(_loc5_ in _loc4_)
            {
               _loc1_.push({
                  "childId":_loc5_,
                  "childKey":_loc3_
               });
            }
         }
         return _loc1_;
      }
      
      public function AddFakeEntryChildrenEntry(param1:FamilyTreeEntry, param2:Boolean = false) : void
      {
         this.mbIsFakeEntry = true;
         if(!this.mFakeEntryChildrenEntries || param2)
         {
            this.mFakeEntryChildrenEntries = [];
         }
         this.mFakeEntryChildrenEntries.push(param1);
      }
      
      public function GetAllChildren() : Array
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc1_:Array = [];
         if(this.mbIsFakeEntry && Boolean(this.mFakeEntryChildrenEntries))
         {
            _loc1_ = this.mFakeEntryChildrenEntries;
         }
         else
         {
            _loc2_ = this.GetChildKeysInOrder();
            for each(_loc3_ in _loc2_)
            {
               this.EnsureChildGroupExists(_loc3_);
               _loc4_ = this.mChildrenGroupsOfEntries[_loc3_];
               _loc1_ = _loc1_.concat(_loc4_);
            }
         }
         return _loc1_;
      }
      
      public function GetAllChildrenThatHasEntryAsParent() : Array
      {
         var _loc2_:Array = null;
         var _loc3_:FamilyTreeEntry = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc1_:Array = [];
         if(this.mbIsFakeEntry && Boolean(this.mFakeEntryChildrenEntries))
         {
            _loc1_ = this.mFakeEntryChildrenEntries;
         }
         else
         {
            _loc4_ = this.GetChildKeysInOrder();
            for each(_loc5_ in _loc4_)
            {
               this.EnsureChildGroupExists(_loc5_);
               _loc6_ = this.mChildrenGroupsOfEntries[_loc5_];
               _loc1_ = _loc1_.concat(_loc6_);
            }
         }
         _loc2_ = [];
         for each(_loc3_ in _loc1_)
         {
            if(_loc3_.mParentEntry == this && _loc2_.indexOf(_loc3_) == -1)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public function GetChildEntryThatContainsSimId(param1:String) : FamilyTreeEntry
      {
         var _loc3_:FamilyTreeEntry = null;
         var _loc2_:Array = this.GetAllChildren();
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.ContainsSimId(param1))
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public function GetLeftmostChild() : FamilyTreeEntry
      {
         var _loc1_:Array = null;
         if(this.mLeftmostChildEntry == null)
         {
            _loc1_ = this.GetAllChildren();
            if(_loc1_.length > 0)
            {
               this.mLeftmostChildEntry = _loc1_[0];
            }
         }
         return this.mLeftmostChildEntry;
      }
      
      public function GetRightmostChild() : FamilyTreeEntry
      {
         var _loc1_:Array = null;
         if(this.mRightmostChildEntry == null)
         {
            _loc1_ = this.GetAllChildren();
            if(_loc1_.length > 0)
            {
               this.mRightmostChildEntry = _loc1_[_loc1_.length - 1];
            }
         }
         return this.mRightmostChildEntry;
      }
      
      public function HasChildrenIds() : Boolean
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc1_:Array = this.GetChildKeysInOrder();
         for each(_loc2_ in _loc1_)
         {
            this.EnsureChildGroupExists(_loc2_);
            _loc3_ = this.mChildrenGroupsOfIds[_loc2_];
            if(_loc3_.length > 0)
            {
               return true;
            }
         }
         return false;
      }
      
      public function HasChildrenEntries() : Boolean
      {
         if(this.mbIsFakeEntry && Boolean(this.mFakeEntryChildrenEntries))
         {
            return this.mFakeEntryChildrenEntries.length > 0;
         }
         return this.GetAllChildrenThatHasEntryAsParent().length > 0;
      }
      
      public function GetMidpointOfChildren() : Number
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         if(Boolean(this.mLeftmostChildEntry) && Boolean(this.mRightmostChildEntry))
         {
            _loc1_ = this.mLeftmostChildEntry.mXPos + this.mLeftmostChildEntry.mShift;
            _loc2_ = this.mRightmostChildEntry.mXPos + this.mRightmostChildEntry.mShift + (this.mRightmostChildEntry.mWidth - 1);
            return (_loc1_ + _loc2_) / 2;
         }
         return 0;
      }
      
      public function GetAmountOfChildrenGroupsFilled() : int
      {
         var _loc3_:String = null;
         var _loc1_:int = 0;
         var _loc2_:Array = this.GetChildKeysInOrder();
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_ in this.mChildrenGroupsOfIds && this.mChildrenGroupsOfIds[_loc3_].length > 0)
            {
               _loc1_++;
            }
         }
         return _loc1_;
      }
      
      public function IsRelationshipInEntry(param1:String, param2:String) : Boolean
      {
         if(this.mOuterLeftSim == param1 || this.mLeftSim == param2 || (this.mOuterLeftSim == param2 || this.mLeftSim == param1))
         {
            return true;
         }
         if(this.mLeftSim == param1 || this.mRightSim == param2 || (this.mLeftSim == param2 || this.mRightSim == param1))
         {
            return true;
         }
         if(this.mRightSim == param1 || this.mOuterRightSim == param2 || (this.mRightSim == param1 || this.mOuterRightSim == param2))
         {
            return true;
         }
         return false;
      }
      
      private function _ClearRedundantChildrenIdsFromGroup(param1:String, param2:String) : void
      {
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc3_:String = this.CombineIds(param1,param2);
         var _loc4_:Array = this.mChildrenGroupsOfIds[_loc3_];
         for each(_loc5_ in _loc4_)
         {
            _loc6_ = int(this.mChildrenGroupsOfIds[param1].indexOf(_loc5_));
            if(_loc6_ != -1)
            {
               this.mChildrenGroupsOfIds[param1].splice(_loc6_,1);
            }
            _loc7_ = int(this.mChildrenGroupsOfIds[param2].indexOf(_loc5_));
            if(_loc7_ != -1)
            {
               this.mChildrenGroupsOfIds[param2].splice(_loc7_,1);
            }
         }
      }
   }
}

