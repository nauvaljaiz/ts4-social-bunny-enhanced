package widgets.shared.utils.FamilyTree
{
   import gamedata.FamilyTree.DisplayFamilyTree;
   import gamedata.FamilyTree.FamilyTreeServiceNode;
   import gamedata.GameContent;
   import gamedata.Gameplay.Dynasty.DynastyData;
   import gamedata.Gameplay.Dynasty.DynastyMemberData;
   import olympus.io.CommunicationManager;
   import olympus.localization.KeysGP;
   import olympus.localization.LocKey;
   import olympus.objects.RelationshipBitInfo;
   import olympus.utils.Functional;
   
   public class FamilyTreeUtils
   {
      
      public static var X_OFFSET_BETWEEN_NODES_OF_ENTRY:uint = 2;
      
      public static var GENDERLESS_FAMILY_RELBIT_NAMES:Object = {
         "15822":KeysGP.FAMILY_TREE_GENDERLESS_MARRIED_LABEL,
         "8809":KeysGP.FAMILY_TREE_GENDERLESS_PARENT_LABEL,
         "8808":KeysGP.FAMILY_TREE_GENDERLESS_GRANDPARENT_LABEL,
         "468799":KeysGP.FAMILY_TREE_GENDERLESS_GREAT_GRANDPARENT_LABEL,
         "8805":KeysGP.FAMILY_TREE_GENDERLESS_CHILD_LABEL,
         "8802":KeysGP.FAMILY_TREE_GENDERLESS_SIBLING_LABEL,
         "8829":KeysGP.FAMILY_TREE_GENDERLESS_SIBLING_OF_PARENT_LABEL,
         "468860":KeysGP.FAMILY_TREE_GENDERLESS_GRANDPIBLING_LABEL,
         "8807":KeysGP.FAMILY_TREE_GENDERLESS_GRANDCHILD_LABEL,
         "9989":KeysGP.FAMILY_TREE_GENDERLESS_NIBLING_LABEL,
         "8826":KeysGP.FAMILY_TREE_GENDERLESS_COUSIN_LABEL,
         "468795":KeysGP.FAMILY_TREE_GENDERLESS_PARENTS_COUSIN,
         "468797":KeysGP.FAMILY_TREE_GENDERLESS_GREAT_GRANDCHILD_LABEL,
         "468796":KeysGP.FAMILY_TREE_GENDERLESS_GRANDNIBLING_LABEL,
         "500510":KeysGP.FAMILY_TREE_GENDERLESS_COUSINS_CHILD_LABEL,
         "468541":KeysGP.FAMILY_TREE_GENDERLESS_DISTANT_RELATIVE_LABEL,
         "500440":KeysGP.FAMILY_TREE_GENDERLESS_DEAD_SPOUSE_LABEL,
         "479960":KeysGP.FAMILY_TREE_GENDERLESS_ANCESTOR_LABEL,
         "479961":KeysGP.FAMILY_TREE_GENDERLESS_DESCENDANT_LABEL,
         "15815":KeysGP.FAMILY_TREE_GENDERLESS_DIVORCED_LABEL,
         "470945":KeysGP.FAMILY_TREE_GENDERLESS_DISTANT_RELATIVE_IN_LAW_LABEL,
         "468542":KeysGP.FAMILY_TREE_GENDERLESS_HALF_SIBLING_LABEL,
         "467759":KeysGP.FAMILY_TREE_GENDERLESS_PARENT_IN_LAW_LABEL,
         "467871":KeysGP.FAMILY_TREE_GENDERLESS_CHILD_IN_LAW_LABEL,
         "467761":KeysGP.FAMILY_TREE_GENDERLESS_SIBLING_IN_LAW_LABEL,
         "474025":KeysGP.FAMILY_TREE_GENDERLESS_RELATIVE_IN_LAW_LABEL,
         "468544":KeysGP.FAMILY_TREE_GENDERLESS_STEP_CHILD_LABEL,
         "468543":KeysGP.FAMILY_TREE_GENDERLESS_STEP_PARENT_LABEL,
         "8824":KeysGP.FAMILY_TREE_GENDERLESS_STEP_SIBLING_LABEL
      };
      
      public function FamilyTreeUtils()
      {
         super();
      }
      
      public static function GetGenderlessNameForRelbit(param1:RelationshipBitInfo) : LocKey
      {
         var _loc2_:LocKey = null;
         if(param1)
         {
            if(param1.bitId)
            {
               if(param1.bitId in GENDERLESS_FAMILY_RELBIT_NAMES)
               {
                  _loc2_ = GENDERLESS_FAMILY_RELBIT_NAMES[param1.bitId];
               }
            }
         }
         return _loc2_;
      }
      
      public static function FillInEP21Data(param1:DisplayFamilyTree) : void
      {
         var _loc2_:Object = null;
         var _loc3_:DynastyData = null;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:FamilyTreeServiceNode = null;
         var _loc8_:String = null;
         var _loc9_:Boolean = false;
         var _loc10_:Object = null;
         var _loc11_:DynastyData = null;
         var _loc12_:Object = null;
         var _loc13_:DynastyMemberData = null;
         var _loc14_:Boolean = false;
         var _loc15_:Boolean = false;
         var _loc16_:Object = null;
         var _loc17_:Object = null;
         if(GameContent.HAS_EP21)
         {
            _loc2_ = CommunicationManager.CallGameService("GetSimDynastyData",param1.root_id);
            _loc3_ = _loc2_ ? new DynastyData(_loc2_) : null;
            if(_loc3_)
            {
               _loc4_ = CommunicationManager.CallGameService("GetDynastyAlliesRivalsData",_loc3_.dynasty_id);
            }
            _loc5_ = int(param1.family_nodes.length);
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc7_ = param1.family_nodes[_loc6_];
               _loc8_ = _loc7_.sim_id;
               _loc9_ = (Boolean(_loc8_)) && _loc8_ != "0" && CommunicationManager.CallGameService("DoesSimExist",_loc8_) as Boolean;
               if(_loc9_)
               {
                  _loc10_ = CommunicationManager.CallGameService("GetSimDynastyData",_loc8_);
                  _loc11_ = _loc10_ ? new DynastyData(_loc10_) : null;
                  _loc12_ = CommunicationManager.CallGameService("GetKingdomData",{"sim_id":_loc8_});
                  if(_loc11_ != null)
                  {
                     _loc7_.has_dynasty = true;
                     _loc7_.dynasty_id = _loc11_.dynasty_id;
                     _loc7_.dynasty_icon = _loc11_.icon;
                     _loc7_.dynasty_icon_background = _loc11_.icon_background;
                     _loc7_.dynasty_name = _loc11_.name;
                     _loc7_.is_dynasty_head = _loc11_.head_sim_id == _loc8_;
                     _loc7_.is_dynasty_heir = _loc11_.heir_sim_id == _loc8_;
                     for each(_loc13_ in _loc11_.members)
                     {
                        if(_loc13_.member_id == _loc8_)
                        {
                           _loc7_.is_dynasty_black_sheep = _loc13_.is_black_sheep;
                           break;
                        }
                     }
                     if(Boolean(_loc4_) && _loc3_.dynasty_id != _loc11_.dynasty_id)
                     {
                        _loc14_ = false;
                        _loc15_ = false;
                        for each(_loc16_ in _loc4_.alliances)
                        {
                           if(_loc16_.dynasty_id == _loc11_.dynasty_id)
                           {
                              _loc14_ = true;
                              break;
                           }
                        }
                        if(!_loc14_)
                        {
                           for each(_loc17_ in _loc4_.rivalries)
                           {
                              if(_loc17_.dynasty_id == _loc11_.dynasty_id)
                              {
                                 _loc15_ = true;
                                 break;
                              }
                           }
                        }
                        _loc7_.is_dynasty_ally = _loc14_;
                        _loc7_.is_dynasty_rival = _loc15_;
                     }
                  }
                  if(_loc12_ != null)
                  {
                     _loc7_.has_kingdom = true;
                     _loc7_.kingdom_level = _loc12_.level;
                     _loc7_.kingdom_title = _loc12_.title;
                     if(_loc12_.hasOwnProperty("region_name"))
                     {
                        _loc7_.kingdom_neighborhood_name = LocKey.FromHash(_loc12_.region_name.hash).toString();
                     }
                  }
               }
               _loc6_++;
            }
         }
      }
      
      public static function GetTreeLayout(param1:DisplayFamilyTree) : Object
      {
         var _loc10_:FamilyTreeServiceNode = null;
         var _loc11_:String = null;
         var _loc2_:Object = {};
         var _loc3_:int = int(param1.family_nodes.length);
         var _loc4_:Vector.<FamilyTreeServiceNode> = new Vector.<FamilyTreeServiceNode>();
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc10_ = param1.family_nodes[_loc5_];
            _loc11_ = _loc10_.sim_id;
            _loc2_[_loc11_] = _loc10_;
            if(_loc10_.spouse)
            {
               _loc4_.push(_loc10_);
            }
            _loc5_++;
         }
         FillSpouseReferences(_loc2_,_loc4_);
         var _loc6_:Vector.<Vector.<FamilyTreeEntry>> = GenerateEntriesByGeneration(_loc2_,param1.root_id);
         var _loc7_:FamilyTreeEntry = EnsureAndObtainSingleRoot(_loc6_);
         ComputeTreeEntriesPosition(_loc7_);
         var _loc8_:Vector.<Vector.<FamilyTreeServiceNode>> = ExtractPositionOfNodesFromEntries(_loc2_,_loc6_);
         var _loc9_:Vector.<FamilyTreeEdge> = ComputeEdgesFromEntries(_loc2_,_loc6_);
         return {
            "nodes":_loc8_,
            "edges":_loc9_
         };
      }
      
      public static function ComputeTreeEntriesPosition(param1:FamilyTreeEntry, param2:Number = 1, param3:Number = 2, param4:Number = 1) : void
      {
         FirstPass(param1,param2,param3);
         var _loc5_:Object = SecondPass(param1,param4);
         var _loc6_:Number = Number(_loc5_.shiftAmount);
         var _loc7_:Number = Number(_loc5_.lowestX);
         ThirdPass(param1,_loc6_ - _loc7_);
      }
      
      protected static function FillSpouseReferences(param1:Object, param2:Vector.<FamilyTreeServiceNode>) : void
      {
         var _loc3_:FamilyTreeServiceNode = null;
         var _loc4_:String = null;
         var _loc5_:FamilyTreeServiceNode = null;
         for each(_loc3_ in param2)
         {
            if(!_loc3_.spouse_node)
            {
               _loc4_ = _loc3_.spouse;
               if(_loc4_)
               {
                  _loc5_ = param1[_loc4_];
                  if(_loc5_)
                  {
                     _loc3_.spouse_node = _loc5_;
                     _loc5_.spouse_node = _loc3_;
                  }
               }
            }
         }
      }
      
      protected static function GenerateEntriesByGeneration(param1:Object, param2:String) : Vector.<Vector.<FamilyTreeEntry>>
      {
         var _loc12_:Object = null;
         var _loc13_:String = null;
         var _loc14_:int = 0;
         var _loc15_:FamilyTreeEntry = null;
         var _loc16_:int = 0;
         var _loc17_:FamilyTreeServiceNode = null;
         var _loc18_:Array = null;
         var _loc19_:String = null;
         var _loc20_:int = 0;
         var _loc21_:FamilyTreeEntry = null;
         var _loc22_:Boolean = false;
         var _loc23_:Array = null;
         var _loc24_:String = null;
         var _loc25_:int = 0;
         var _loc26_:FamilyTreeServiceNode = null;
         var _loc27_:FamilyTreeServiceNode = null;
         var _loc28_:FamilyTreeServiceNode = null;
         var _loc29_:FamilyTreeServiceNode = null;
         var _loc30_:FamilyTreeEntry = null;
         var _loc31_:Array = null;
         var _loc32_:Vector.<FamilyTreeEntry> = null;
         var _loc33_:int = 0;
         var _loc34_:int = 0;
         var _loc35_:FamilyTreeEntry = null;
         var _loc36_:Array = null;
         var _loc37_:Array = null;
         var _loc38_:Object = null;
         var _loc39_:String = null;
         var _loc40_:String = null;
         var _loc41_:FamilyTreeEntry = null;
         var _loc3_:Vector.<Vector.<FamilyTreeEntry>> = new Vector.<Vector.<FamilyTreeEntry>>();
         var _loc4_:FamilyTreeServiceNode = GetNodeFromDict(param1,param2);
         if(!_loc4_)
         {
            return _loc3_;
         }
         var _loc5_:FamilyTreeEntry = GenerateEntry(param2,param1,null,0);
         if(!_loc5_)
         {
            _loc5_ = new FamilyTreeEntry();
            _loc5_.LeftSim = param2;
            _loc5_.Depth = 0;
            AddToDictWithDepth(param1,param2,0);
         }
         var _loc6_:Array = [];
         var _loc7_:Array = [];
         _loc7_.push({
            "simId":param2,
            "depth":0,
            "entry":_loc5_
         });
         var _loc8_:Object = {};
         _loc8_[0] = [_loc5_];
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         while(_loc7_.length > 0)
         {
            _loc12_ = _loc7_.shift();
            _loc13_ = _loc12_.simId;
            _loc14_ = int(_loc12_.depth);
            _loc15_ = _loc12_.entry;
            _loc16_ = _loc14_ + 1;
            if(_loc6_.indexOf(_loc13_) == -1)
            {
               _loc17_ = GetNodeFromDict(param1,_loc13_);
               _loc6_.push(_loc13_);
               if(_loc17_)
               {
                  AddToDictWithDepth(param1,_loc13_,_loc14_);
                  _loc18_ = [];
                  for each(_loc19_ in _loc17_.parents)
                  {
                     if(GetNodeFromDict(param1,_loc19_))
                     {
                        _loc18_.push(_loc19_);
                     }
                  }
                  _loc20_ = int(_loc18_.length);
                  _loc21_ = null;
                  _loc22_ = false;
                  if(_loc20_ > 0)
                  {
                     if(!(_loc16_ in _loc8_))
                     {
                        _loc8_[_loc16_] = [];
                     }
                     if(_loc20_ == 1)
                     {
                        if(Boolean(_loc15_.LeftSim) && Boolean(_loc15_.RightSim))
                        {
                           _loc26_ = GetNodeFromDict(param1,_loc15_.LeftSim);
                           _loc27_ = GetNodeFromDict(param1,_loc15_.RightSim);
                           _loc28_ = Boolean(_loc26_) && _loc26_.parents.length == 1 ? GetNodeFromDict(param1,_loc26_.parents[0]) : null;
                           _loc29_ = Boolean(_loc27_) && _loc27_.parents.length == 1 ? GetNodeFromDict(param1,_loc27_.parents[0]) : null;
                           if(Boolean(_loc28_) && Boolean(_loc29_))
                           {
                              _loc21_ = GetExistingEntryThatContainsSimRelationship(_loc28_.sim_id,_loc29_.sim_id,_loc8_[_loc16_]);
                              if(!_loc21_)
                              {
                                 _loc21_ = GenerateTwoSeparatedParentsEntry(_loc28_.sim_id,_loc29_.sim_id,param1,_loc16_);
                                 _loc22_ = true;
                              }
                           }
                        }
                        if(!_loc21_)
                        {
                           _loc21_ = GetExistingEntryThatContainsSim(_loc18_[0],_loc8_[_loc16_]);
                           if(!_loc21_)
                           {
                              _loc21_ = GenerateSingleParentEntry(_loc18_[0],param1,_loc16_);
                              _loc22_ = true;
                           }
                        }
                     }
                     else
                     {
                        _loc21_ = GetExistingEntryThatContainsSimRelationship(_loc18_[0],_loc18_[1],_loc8_[_loc16_]);
                        if(!_loc21_)
                        {
                           _loc21_ = GenerateTwoParentsEntry(_loc18_[0],_loc18_[1],param1,_loc16_);
                           _loc22_ = true;
                        }
                     }
                     _loc15_.ParentEntry = _loc21_;
                     _loc7_.push({
                        "simId":_loc18_[0],
                        "depth":_loc16_,
                        "entry":_loc21_
                     });
                     if(_loc20_ > 1)
                     {
                        _loc7_.push({
                           "simId":_loc18_[1],
                           "depth":_loc16_,
                           "entry":_loc21_
                        });
                     }
                     if(_loc22_)
                     {
                        _loc8_[_loc16_].push(_loc21_);
                     }
                  }
                  _loc23_ = [];
                  for each(_loc24_ in _loc17_.known_secret_parents)
                  {
                     if(GetNodeFromDict(param1,_loc24_))
                     {
                        _loc23_.push(_loc24_);
                     }
                  }
                  _loc25_ = int(_loc23_.length);
                  if(_loc25_ > 0)
                  {
                     if(!_loc21_ || Boolean(_loc21_) && Boolean(!_loc21_.ContainsSimId(_loc23_[0])))
                     {
                        _loc30_ = GenerateSingleParentEntry(_loc23_[0],param1,_loc16_);
                        _loc8_[_loc16_].push(_loc30_);
                     }
                  }
                  if(_loc16_ > _loc10_)
                  {
                     _loc10_ = _loc16_;
                  }
               }
            }
         }
         _loc6_ = [];
         var _loc11_:* = _loc10_;
         while(_loc11_ >= _loc9_)
         {
            _loc31_ = _loc8_[_loc11_];
            _loc32_ = new Vector.<FamilyTreeEntry>();
            _loc33_ = int(_loc3_.length);
            _loc34_ = _loc11_ - 1;
            for each(_loc35_ in _loc31_)
            {
               _loc36_ = _loc35_.GetAllChildrenSimIdsWithKeys();
               if(_loc36_.length > 0)
               {
                  if(!(_loc34_ in _loc8_))
                  {
                     _loc8_[_loc34_] = [];
                     if(_loc34_ < _loc9_)
                     {
                        _loc9_ = _loc34_;
                     }
                  }
                  _loc37_ = _loc8_[_loc34_];
                  for each(_loc38_ in _loc36_)
                  {
                     _loc39_ = _loc38_.childId;
                     _loc40_ = _loc38_.childKey;
                     _loc6_.push(_loc39_);
                     _loc6_.push(_loc40_.split(","));
                     _loc41_ = GenerateEntry(_loc39_,param1,_loc8_,_loc34_);
                     if(_loc41_)
                     {
                        _loc41_.ParentEntry = _loc35_;
                        _loc37_.push(_loc41_);
                     }
                     if(!_loc41_)
                     {
                        _loc41_ = FindSimIdInListOfEntries(_loc39_,_loc37_);
                     }
                     if(_loc41_)
                     {
                        _loc35_.AddChildEntryByKey(_loc41_,_loc40_);
                     }
                  }
               }
               _loc35_.Generation = _loc33_;
               _loc32_.push(_loc35_);
            }
            if(_loc32_.length > 0)
            {
               _loc3_.push(_loc32_);
            }
            _loc11_--;
         }
         FillSiblingReferences(_loc3_);
         return _loc3_;
      }
      
      protected static function FillSiblingReferences(param1:Vector.<Vector.<FamilyTreeEntry>>) : void
      {
         var _loc2_:Vector.<FamilyTreeEntry> = null;
         var _loc3_:FamilyTreeEntry = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:FamilyTreeEntry = null;
         var _loc7_:FamilyTreeEntry = null;
         for each(_loc2_ in param1)
         {
            for each(_loc3_ in _loc2_)
            {
               _loc4_ = _loc3_.GetAllChildrenThatHasEntryAsParent();
               _loc5_ = int(_loc4_.length);
               if(_loc5_ > 0)
               {
                  _loc3_.LeftmostChildEntry = _loc4_[0];
                  _loc3_.RightmostChildEntry = _loc4_[_loc5_ - 1];
                  _loc6_ = null;
                  for each(_loc7_ in _loc4_)
                  {
                     if(_loc6_)
                     {
                        _loc6_.RightSiblingEntry = _loc7_;
                        _loc7_.LeftSiblingEntry = _loc6_;
                     }
                     _loc6_ = _loc7_;
                  }
               }
            }
         }
      }
      
      protected static function GenerateEntry(param1:String, param2:Object, param3:Object = null, param4:int = 0) : FamilyTreeEntry
      {
         var _loc6_:FamilyTreeEntry = null;
         var _loc7_:String = null;
         var _loc8_:FamilyTreeServiceNode = null;
         var _loc9_:Array = null;
         var _loc10_:String = null;
         var _loc11_:FamilyTreeServiceNode = null;
         var _loc12_:Array = null;
         var _loc13_:String = null;
         var _loc5_:FamilyTreeServiceNode = GetNodeFromDict(param2,param1);
         if(_loc5_)
         {
            if(Boolean(param3) && param4 in param3)
            {
               _loc6_ = FindSimIdInListOfEntries(param1,param3[param4]);
            }
            if(_loc6_)
            {
               return null;
            }
            _loc6_ = new FamilyTreeEntry();
            _loc6_.Depth = param4;
            _loc6_.LeftSim = _loc5_.sim_id;
            AddToDictWithDepth(param2,_loc5_.sim_id,param4);
            _loc7_ = _loc5_.spouse ? _loc5_.spouse : (_loc5_.latest_ex_spouse ? _loc5_.latest_ex_spouse : null);
            if(_loc7_)
            {
               _loc8_ = GetNodeFromDict(param2,_loc7_);
               if((Boolean(_loc8_)) && !(Boolean(param3) && param4 in param3 && IsSimIdInListOfEntries(_loc7_,param3[param4])))
               {
                  _loc6_.RightSim = _loc7_;
                  _loc6_.MainRelationType = GetRelationTypeBetweenNodes(_loc5_,_loc8_);
                  AddToDictWithDepth(param2,_loc7_,param4);
               }
            }
            _loc9_ = GetOtherParentsOfChildrenOfSim(_loc5_.sim_id,param2);
            for each(_loc10_ in _loc9_)
            {
               if(!_loc6_.ContainsSimId(_loc10_) && !IsSimIdInObjectOfEntries(_loc10_,param3))
               {
                  _loc11_ = GetNodeFromDict(param2,_loc10_);
                  if(_loc11_)
                  {
                     _loc6_.OuterLeftSim = _loc10_;
                     _loc6_.OuterLeftRelationType = GetRelationTypeBetweenNodes(_loc5_,_loc11_);
                     AddToDictWithDepth(param2,_loc10_,param4);
                     break;
                  }
               }
            }
            if(_loc8_)
            {
               _loc12_ = GetOtherParentsOfChildrenOfSim(_loc8_.sim_id,param2);
               for each(_loc13_ in _loc12_)
               {
                  if(!_loc6_.ContainsSimId(_loc13_) && !IsSimIdInObjectOfEntries(_loc13_,param3))
                  {
                     _loc11_ = GetNodeFromDict(param2,_loc13_);
                     if(_loc11_)
                     {
                        _loc6_.OuterRightSim = _loc13_;
                        _loc6_.OuterRightRelationType = GetRelationTypeBetweenNodes(_loc8_,_loc11_);
                        AddToDictWithDepth(param2,_loc13_,param4);
                        break;
                     }
                  }
               }
            }
            FillEntryChildrenIds(_loc6_,param2);
            _loc6_.UpdateEntryWidth();
            return _loc6_;
         }
         return null;
      }
      
      protected static function GenerateSingleParentEntry(param1:String, param2:Object, param3:int = 0) : FamilyTreeEntry
      {
         var _loc6_:String = null;
         var _loc7_:FamilyTreeServiceNode = null;
         var _loc4_:FamilyTreeEntry = new FamilyTreeEntry();
         _loc4_.LeftSim = param1;
         _loc4_.Depth = param3;
         AddToDictWithDepth(param2,param1,param3);
         var _loc5_:FamilyTreeServiceNode = GetNodeFromDict(param2,param1);
         if(_loc5_)
         {
            _loc6_ = _loc5_.spouse ? _loc5_.spouse : (_loc5_.latest_ex_spouse ? _loc5_.latest_ex_spouse : null);
            _loc7_ = GetNodeFromDict(param2,_loc6_);
            if(_loc7_)
            {
               _loc4_.OuterLeftSim = _loc7_.sim_id;
               AddToDictWithDepth(param2,_loc7_.sim_id,param3);
               _loc4_.OuterLeftRelationType = GetRelationTypeBetweenNodes(_loc5_,_loc7_);
            }
         }
         FillEntryChildrenIds(_loc4_,param2);
         _loc4_.UpdateEntryWidth();
         return _loc4_;
      }
      
      protected static function GenerateTwoParentsEntry(param1:String, param2:String, param3:Object, param4:int = 0) : FamilyTreeEntry
      {
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:FamilyTreeServiceNode = null;
         var _loc11_:FamilyTreeServiceNode = null;
         var _loc5_:FamilyTreeEntry = new FamilyTreeEntry();
         _loc5_.LeftSim = param1;
         _loc5_.RightSim = param2;
         _loc5_.Depth = param4;
         AddToDictWithDepth(param3,param1,param4);
         AddToDictWithDepth(param3,param2,param4);
         var _loc6_:FamilyTreeServiceNode = GetNodeFromDict(param3,param1);
         var _loc7_:FamilyTreeServiceNode = GetNodeFromDict(param3,param2);
         if(Boolean(_loc6_) && Boolean(_loc7_))
         {
            _loc5_.MainRelationType = GetRelationTypeBetweenNodes(_loc6_,_loc7_);
            switch(_loc5_.MainRelationType)
            {
               case FamilyTreeEntry.RELATION_MARRIED:
                  _loc8_ = _loc6_.latest_ex_spouse;
                  _loc9_ = _loc7_.latest_ex_spouse;
                  break;
               case FamilyTreeEntry.RELATION_DIVORCED:
                  _loc8_ = _loc6_.spouse;
                  _loc9_ = _loc7_.spouse;
            }
            _loc10_ = GetNodeFromDict(param3,_loc8_);
            _loc11_ = GetNodeFromDict(param3,_loc9_);
            if(_loc10_)
            {
               _loc5_.OuterLeftSim = _loc8_;
               _loc5_.OuterLeftRelationType = GetRelationTypeBetweenNodes(_loc6_,_loc10_);
               AddToDictWithDepth(param3,_loc8_,param4);
            }
            if(_loc11_)
            {
               _loc5_.OuterRightSim = _loc9_;
               _loc5_.OuterRightRelationType = GetRelationTypeBetweenNodes(_loc7_,_loc11_);
               AddToDictWithDepth(param3,_loc9_,param4);
            }
         }
         FillEntryChildrenIds(_loc5_,param3);
         _loc5_.UpdateEntryWidth();
         return _loc5_;
      }
      
      protected static function GenerateTwoSeparatedParentsEntry(param1:String, param2:String, param3:Object, param4:int = 0) : FamilyTreeEntry
      {
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:FamilyTreeServiceNode = null;
         var _loc11_:FamilyTreeServiceNode = null;
         var _loc5_:FamilyTreeEntry = new FamilyTreeEntry();
         _loc5_.LeftSim = param1;
         _loc5_.RightSim = param2;
         _loc5_.Depth = param4;
         AddToDictWithDepth(param3,param1,param4);
         AddToDictWithDepth(param3,param2,param4);
         var _loc6_:FamilyTreeServiceNode = GetNodeFromDict(param3,param1);
         var _loc7_:FamilyTreeServiceNode = GetNodeFromDict(param3,param2);
         if(Boolean(_loc6_) && Boolean(_loc7_))
         {
            _loc5_.MainRelationType = FamilyTreeEntry.RELATION_NONE;
            _loc8_ = _loc6_.spouse;
            _loc9_ = _loc7_.spouse;
            _loc10_ = GetNodeFromDict(param3,_loc8_);
            _loc11_ = GetNodeFromDict(param3,_loc9_);
            if(_loc10_)
            {
               _loc5_.OuterLeftSim = _loc8_;
               _loc5_.OuterLeftRelationType = GetRelationTypeBetweenNodes(_loc6_,_loc10_);
               AddToDictWithDepth(param3,_loc8_,param4);
            }
            if(_loc11_)
            {
               _loc5_.OuterRightSim = _loc9_;
               _loc5_.OuterRightRelationType = GetRelationTypeBetweenNodes(_loc7_,_loc11_);
               AddToDictWithDepth(param3,_loc9_,param4);
            }
         }
         FillEntryChildrenIds(_loc5_,param3);
         _loc5_.UpdateEntryWidth();
         return _loc5_;
      }
      
      public static function GetExistingEntryThatContainsSimRelationship(param1:String, param2:String, param3:Array) : FamilyTreeEntry
      {
         var _loc4_:FamilyTreeEntry = null;
         for each(_loc4_ in param3)
         {
            if(_loc4_.IsRelationshipInEntry(param1,param2))
            {
               return _loc4_;
            }
         }
         return null;
      }
      
      public static function GetExistingEntryThatContainsSim(param1:String, param2:Array) : FamilyTreeEntry
      {
         var _loc3_:FamilyTreeEntry = null;
         for each(_loc3_ in param2)
         {
            if(_loc3_.ContainsSimId(param1))
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      protected static function GetOtherParentsOfChildrenOfSim(param1:String, param2:Object) : Array
      {
         var childrenIds:Array = null;
         var childId:String = null;
         var childrenNode:FamilyTreeServiceNode = null;
         var childrenParents:Array = null;
         var childrenParent:String = null;
         var parentNode:FamilyTreeServiceNode = null;
         var simId:String = param1;
         var nodesDictionary:Object = param2;
         var childrenParentsIdsArray:Array = [];
         var mainNode:FamilyTreeServiceNode = GetNodeFromDict(nodesDictionary,simId);
         if(mainNode)
         {
            childrenIds = mainNode.children.concat(mainNode.known_secret_children);
            for each(childId in childrenIds)
            {
               childrenNode = GetNodeFromDict(nodesDictionary,childId);
               if(childrenNode)
               {
                  childrenParents = childrenNode.parents.concat(childrenNode.known_secret_parents);
                  childrenParents = childrenParents.filter(function(param1:String):Boolean
                  {
                     return param1 != simId;
                  });
                  for each(childrenParent in childrenParents)
                  {
                     if(childrenParentsIdsArray.indexOf(childrenParent) == -1)
                     {
                        parentNode = GetNodeFromDict(nodesDictionary,childrenParent);
                        if(!(Boolean(parentNode) && (IsEdgeSecret(parentNode,childrenNode) && IsEdgeForged(mainNode,childrenNode) || IsEdgeSecret(mainNode,childrenNode) && IsEdgeForged(parentNode,childrenNode))))
                        {
                           childrenParentsIdsArray.push(childrenParent);
                        }
                     }
                  }
               }
            }
         }
         return childrenParentsIdsArray;
      }
      
      protected static function FindSimIdInObjectOfEntries(param1:String, param2:Object) : FamilyTreeEntry
      {
         var _loc3_:Array = null;
         var _loc4_:FamilyTreeEntry = null;
         for each(_loc3_ in param2)
         {
            _loc4_ = FindSimIdInListOfEntries(param1,_loc3_);
            if(_loc4_)
            {
               return _loc4_;
            }
         }
         return null;
      }
      
      protected static function IsSimIdInObjectOfEntries(param1:String, param2:Object) : Boolean
      {
         return FindSimIdInObjectOfEntries(param1,param2) != null;
      }
      
      protected static function FindSimIdInListOfEntries(param1:String, param2:Array) : FamilyTreeEntry
      {
         var _loc3_:FamilyTreeEntry = null;
         if(param2)
         {
            for each(_loc3_ in param2)
            {
               if(_loc3_.ContainsSimId(param1))
               {
                  return _loc3_;
               }
            }
         }
         return null;
      }
      
      protected static function IsSimIdInListOfEntries(param1:String, param2:Array) : Boolean
      {
         return FindSimIdInListOfEntries(param1,param2) != null;
      }
      
      protected static function FillEntryChildrenIds(param1:FamilyTreeEntry, param2:Object) : void
      {
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         var _loc11_:Array = null;
         var _loc12_:Array = null;
         var _loc13_:Array = null;
         var _loc14_:Array = null;
         var _loc15_:Array = null;
         var _loc16_:String = null;
         var _loc3_:FamilyTreeServiceNode = GetNodeFromDict(param2,param1.LeftSim);
         var _loc4_:FamilyTreeServiceNode = GetNodeFromDict(param2,param1.RightSim);
         var _loc5_:FamilyTreeServiceNode = GetNodeFromDict(param2,param1.OuterLeftSim);
         var _loc6_:FamilyTreeServiceNode = GetNodeFromDict(param2,param1.OuterRightSim);
         if(param1.IsSingleSim() && Boolean(_loc3_))
         {
            param1.AddChildrenIds(_loc3_.children.concat(_loc3_.known_secret_children),param1.LeftSim);
         }
         else
         {
            if(Boolean(_loc3_) && Boolean(_loc4_))
            {
               _loc14_ = GetChildrenBetweenTwoNodes(_loc3_,_loc4_,param2);
               _loc9_ = _loc14_[0];
               _loc10_ = _loc14_[1];
               _loc11_ = _loc14_[2];
               param1.SetChildrenIds(_loc9_,_loc3_.sim_id);
               param1.SetChildrenIds(_loc10_,_loc3_.sim_id,_loc4_.sim_id);
               param1.SetChildrenIds(_loc11_,_loc4_.sim_id);
            }
            if(Boolean(_loc3_) && Boolean(_loc5_))
            {
               _loc14_ = GetChildrenBetweenTwoNodes(_loc3_,_loc5_,param2);
               _loc9_ = _loc14_[0];
               _loc8_ = _loc14_[1];
               _loc7_ = _loc14_[2];
               param1.SetChildrenIds(_loc9_,_loc3_.sim_id);
               param1.SetChildrenIds(_loc8_,_loc3_.sim_id,_loc5_.sim_id);
               param1.SetChildrenIds(_loc7_,_loc5_.sim_id);
            }
            if(Boolean(_loc4_) && Boolean(_loc6_))
            {
               _loc14_ = GetChildrenBetweenTwoNodes(_loc4_,_loc6_,param2);
               _loc11_ = _loc14_[0];
               _loc12_ = _loc14_[1];
               _loc13_ = _loc14_[2];
               param1.SetChildrenIds(_loc11_,_loc4_.sim_id);
               param1.SetChildrenIds(_loc12_,_loc4_.sim_id,_loc6_.sim_id);
               param1.SetChildrenIds(_loc13_,_loc6_.sim_id);
            }
            if(_loc3_)
            {
               _loc15_ = [];
               for each(_loc16_ in _loc3_.known_secret_children)
               {
                  if(!_loc8_ || Boolean(_loc8_) && Boolean(_loc8_.indexOf(_loc16_) < 0))
                  {
                     _loc15_.push(_loc16_);
                  }
               }
               if(_loc15_.length)
               {
                  param1.AddChildrenIds(_loc15_,_loc3_.sim_id);
               }
            }
            if(_loc4_)
            {
               _loc15_ = [];
               for each(_loc16_ in _loc4_.known_secret_children)
               {
                  if(!_loc12_ || Boolean(_loc12_) && Boolean(_loc12_.indexOf(_loc16_) < 0))
                  {
                     _loc15_.push(_loc16_);
                  }
               }
               if(_loc15_.length)
               {
                  param1.AddChildrenIds(_loc15_,_loc4_.sim_id);
               }
            }
         }
         param1.ClearRedundantChildrenIds();
      }
      
      protected static function GetChildrenBetweenTwoNodes(param1:FamilyTreeServiceNode, param2:FamilyTreeServiceNode, param3:Object) : Array
      {
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:FamilyTreeServiceNode = null;
         var _loc4_:Array = [];
         var _loc5_:Array = [];
         var _loc6_:Array = [];
         var _loc7_:Array = param1.children.concat(param1.known_secret_children);
         var _loc8_:Array = param2.children.concat(param2.known_secret_children);
         for each(_loc9_ in _loc7_)
         {
            if(_loc8_.indexOf(_loc9_) != -1)
            {
               _loc5_.push(_loc9_);
            }
            else
            {
               _loc11_ = GetNodeFromDict(param3,_loc9_);
               if(_loc11_)
               {
                  _loc4_.push(_loc9_);
               }
            }
         }
         for each(_loc10_ in _loc8_)
         {
            if(_loc7_.indexOf(_loc10_) == -1)
            {
               _loc11_ = GetNodeFromDict(param3,_loc10_);
               if(_loc11_)
               {
                  _loc6_.push(_loc10_);
               }
            }
         }
         _loc4_.sort(Array.NUMERIC);
         _loc5_.sort(Array.NUMERIC);
         _loc6_.sort(Array.NUMERIC);
         return [_loc4_,_loc5_,_loc6_];
      }
      
      protected static function GetNodeFromDict(param1:Object, param2:String, param3:int = 2147483647) : FamilyTreeServiceNode
      {
         var _loc4_:String = param3 == int.MAX_VALUE ? param2 : param2 + "_" + param3;
         return Boolean(param2) && _loc4_ in param1 ? param1[_loc4_] : null;
      }
      
      protected static function AddToDictWithDepth(param1:Object, param2:String, param3:int) : void
      {
         var _loc4_:String = param2 + "_" + param3;
         var _loc5_:FamilyTreeServiceNode = GetNodeFromDict(param1,param2);
         if((Boolean(_loc5_)) && !(_loc4_ in param1))
         {
            param1[_loc4_] = _loc5_.Clone();
         }
      }
      
      protected static function GetRelationTypeBetweenNodes(param1:FamilyTreeServiceNode, param2:FamilyTreeServiceNode) : uint
      {
         if(Boolean(param1) && Boolean(param2))
         {
            return param1.spouse == param2.sim_id ? FamilyTreeEntry.RELATION_MARRIED : (param1.latest_ex_spouse == param2.sim_id ? FamilyTreeEntry.RELATION_DIVORCED : FamilyTreeEntry.RELATION_DEFAULT);
         }
         return FamilyTreeEntry.RELATION_DEFAULT;
      }
      
      protected static function EnsureAndObtainSingleRoot(param1:Vector.<Vector.<FamilyTreeEntry>>) : FamilyTreeEntry
      {
         var _loc5_:Vector.<FamilyTreeEntry> = null;
         var _loc6_:FamilyTreeEntry = null;
         var _loc7_:Vector.<FamilyTreeEntry> = null;
         var _loc8_:* = 0;
         var _loc9_:FamilyTreeEntry = null;
         var _loc10_:FamilyTreeEntry = null;
         var _loc11_:FamilyTreeEntry = null;
         var _loc12_:FamilyTreeEntry = null;
         var _loc2_:uint = param1.length;
         if(_loc2_ == 0)
         {
            return null;
         }
         var _loc3_:uint = _loc2_ - 1;
         while(_loc3_ > 0)
         {
            _loc5_ = param1[_loc3_];
            for each(_loc6_ in _loc5_)
            {
               if(_loc6_.ParentEntry == null && !_loc6_.IsFakeEntry)
               {
                  _loc7_ = new Vector.<FamilyTreeEntry>();
                  _loc8_ = int(_loc6_.Generation - 1);
                  while(_loc8_ >= 0)
                  {
                     _loc9_ = new FamilyTreeEntry(_loc8_,true);
                     if(_loc8_ == _loc6_.Generation - 1)
                     {
                        _loc6_.ParentEntry = _loc9_;
                        _loc9_.AddFakeEntryChildrenEntry(_loc6_,true);
                        _loc9_.LeftmostChildEntry = _loc6_;
                        _loc9_.RightmostChildEntry = _loc6_;
                     }
                     if(_loc7_.length > 0)
                     {
                        _loc10_ = _loc7_[0];
                        _loc10_.ParentEntry = _loc9_;
                        _loc9_.AddFakeEntryChildrenEntry(_loc10_,true);
                        _loc9_.LeftmostChildEntry = _loc10_;
                        _loc9_.RightmostChildEntry = _loc10_;
                     }
                     _loc7_.unshift(_loc9_);
                     _loc8_--;
                  }
                  for each(_loc9_ in _loc7_)
                  {
                     param1[_loc9_.Generation].push(_loc9_);
                  }
               }
            }
            _loc3_--;
         }
         var _loc4_:FamilyTreeEntry = null;
         if(param1[0].length > 1)
         {
            _loc11_ = new FamilyTreeEntry(-1,true);
            _loc11_.IsRoot = true;
            _loc12_ = null;
            for each(_loc6_ in param1[0])
            {
               if(_loc12_)
               {
                  _loc12_.RightSiblingEntry = _loc6_;
                  _loc6_.LeftSiblingEntry = _loc12_;
               }
               _loc11_.AddFakeEntryChildrenEntry(_loc6_);
               _loc6_.ParentEntry = _loc11_;
               _loc12_ = _loc6_;
            }
            _loc4_ = _loc11_;
         }
         else
         {
            _loc4_ = param1[0].length > 0 ? param1[0][0] : null;
         }
         if(_loc4_ != null)
         {
            _loc4_.IsRoot = true;
         }
         return _loc4_;
      }
      
      protected static function ExtractPositionOfNodesFromEntries(param1:Object, param2:Vector.<Vector.<FamilyTreeEntry>>) : Vector.<Vector.<FamilyTreeServiceNode>>
      {
         var _loc4_:Vector.<FamilyTreeEntry> = null;
         var _loc5_:Vector.<FamilyTreeServiceNode> = null;
         var _loc6_:FamilyTreeEntry = null;
         var _loc7_:Array = null;
         var _loc8_:Number = NaN;
         var _loc9_:String = null;
         var _loc10_:FamilyTreeServiceNode = null;
         var _loc3_:Vector.<Vector.<FamilyTreeServiceNode>> = new Vector.<Vector.<FamilyTreeServiceNode>>();
         for each(_loc4_ in param2)
         {
            _loc5_ = new Vector.<FamilyTreeServiceNode>();
            for each(_loc6_ in _loc4_)
            {
               if(!_loc6_.IsFakeEntry)
               {
                  _loc7_ = _loc6_.GetSimIds();
                  _loc8_ = 0;
                  for each(_loc9_ in _loc7_)
                  {
                     _loc10_ = GetNodeFromDict(param1,_loc9_,_loc6_.Depth);
                     if(_loc10_)
                     {
                        _loc10_.x = _loc6_.XPos + _loc8_;
                        _loc10_.y = _loc6_.Generation;
                        _loc8_ += X_OFFSET_BETWEEN_NODES_OF_ENTRY;
                        _loc5_.push(_loc10_);
                     }
                  }
               }
            }
            _loc3_.push(_loc5_);
         }
         return _loc3_;
      }
      
      protected static function ComputeEdgesFromEntries(param1:Object, param2:Vector.<Vector.<FamilyTreeEntry>>) : Vector.<FamilyTreeEdge>
      {
         var _loc5_:Vector.<FamilyTreeEntry> = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:FamilyTreeEntry = null;
         var _loc11_:int = 0;
         var _loc12_:FamilyTreeServiceNode = null;
         var _loc13_:FamilyTreeServiceNode = null;
         var _loc14_:FamilyTreeServiceNode = null;
         var _loc15_:FamilyTreeServiceNode = null;
         var _loc16_:FamilyTreeServiceNode = null;
         var _loc17_:String = null;
         var _loc18_:Vector.<FamilyTreeEdge> = null;
         var _loc19_:Object = null;
         var _loc20_:Array = null;
         var _loc21_:Array = null;
         var _loc22_:FamilyTreeServiceNode = null;
         var _loc23_:String = null;
         var _loc24_:Array = null;
         var _loc25_:String = null;
         var _loc26_:uint = 0;
         var _loc27_:uint = 0;
         var _loc28_:uint = 0;
         var _loc29_:Boolean = false;
         var _loc30_:String = null;
         var _loc31_:FamilyTreeServiceNode = null;
         var _loc32_:FamilyTreeEdge = null;
         var _loc3_:Vector.<FamilyTreeEdge> = new Vector.<FamilyTreeEdge>();
         var _loc4_:int = 0;
         while(_loc4_ < param2.length)
         {
            _loc5_ = param2[_loc4_];
            _loc6_ = 0;
            _loc7_ = GetAmountOfFilledChildrenGroupsInGeneration(_loc5_);
            _loc8_ = 1;
            _loc9_ = 0;
            while(_loc9_ < _loc5_.length)
            {
               _loc10_ = _loc5_[_loc9_];
               if(!_loc10_.IsFakeEntry)
               {
                  _loc11_ = _loc10_.Depth;
                  _loc12_ = GetNodeFromDict(param1,_loc10_.OuterLeftSim,_loc11_);
                  _loc13_ = GetNodeFromDict(param1,_loc10_.LeftSim,_loc11_);
                  _loc14_ = GetNodeFromDict(param1,_loc10_.RightSim,_loc11_);
                  _loc15_ = GetNodeFromDict(param1,_loc10_.OuterRightSim,_loc11_);
                  if(_loc10_.IsSingleSim())
                  {
                     _loc16_ = _loc13_;
                     if(_loc10_.HasChildrenIds())
                     {
                        _loc17_ = _loc16_.dynasty_id;
                        _loc18_ = CreateEdgesToChildren(_loc16_,null,_loc10_.GetAllChildrenSimIds(),_loc11_,param1,[_loc17_].filter(Functional.IsNotNull),_loc8_,_loc7_);
                        _loc3_ = _loc3_.concat(_loc18_);
                        if(_loc18_.length > 0)
                        {
                           _loc8_++;
                        }
                     }
                  }
                  else
                  {
                     _loc19_ = _loc10_.ChildrenGroupsOfIds;
                     _loc20_ = [];
                     if(_loc12_)
                     {
                        _loc20_.push([_loc12_]);
                        if(_loc13_)
                        {
                           _loc20_.push([_loc12_,_loc13_]);
                        }
                     }
                     if(_loc13_)
                     {
                        _loc20_.push([_loc13_]);
                        if(_loc14_)
                        {
                           _loc20_.push([_loc13_,_loc14_]);
                        }
                     }
                     if(_loc14_)
                     {
                        _loc20_.push([_loc14_]);
                        if(_loc15_)
                        {
                           _loc20_.push([_loc14_,_loc15_]);
                        }
                     }
                     if(_loc15_)
                     {
                        _loc20_.push([_loc15_]);
                     }
                     for each(_loc21_ in _loc20_)
                     {
                        _loc16_ = _loc21_[0];
                        _loc22_ = _loc21_.length > 1 ? _loc21_[1] : null;
                        _loc23_ = _loc10_.CombineIds(_loc16_.sim_id,_loc22_ ? _loc22_.sim_id : null);
                        _loc24_ = _loc23_ in _loc19_ ? _loc19_[_loc23_] : null;
                        _loc17_ = _loc16_.dynasty_id;
                        if(!_loc22_)
                        {
                           if(Boolean(_loc24_) && _loc24_.length > 0)
                           {
                              _loc18_ = CreateEdgesToChildren(_loc16_,null,_loc24_,_loc11_,param1,[_loc17_].filter(Functional.IsNotNull),_loc8_,_loc7_);
                              _loc3_ = _loc3_.concat(_loc18_);
                              if(_loc18_.length > 0)
                              {
                                 _loc8_++;
                              }
                           }
                        }
                        else
                        {
                           _loc25_ = _loc22_.dynasty_id;
                           _loc26_ = GetRelationTypeBetweenNodes(_loc16_,_loc22_);
                           if(_loc16_.sim_id == _loc10_.LeftSim && _loc22_.sim_id == _loc10_.RightSim && _loc10_.MainRelationType == FamilyTreeEntry.RELATION_NONE)
                           {
                              _loc26_ = FamilyTreeEntry.RELATION_NONE;
                           }
                           _loc27_ = _loc26_ == FamilyTreeEntry.RELATION_MARRIED ? FamilyTreeEdge.REL_SPOUSE : (_loc26_ == FamilyTreeEntry.RELATION_DIVORCED ? FamilyTreeEdge.REL_EX_SPOUSE : FamilyTreeEdge.REL_GENERIC);
                           _loc28_ = FamilyTreeEdge.STYLE_STANDARD;
                           if(Boolean(_loc17_) && Boolean(_loc25_) && _loc17_ == _loc25_)
                           {
                              _loc28_ = FamilyTreeEdge.STYLE_DYNASTY;
                           }
                           if(_loc26_ == FamilyTreeEntry.RELATION_DEFAULT)
                           {
                              if(Boolean(_loc24_) && _loc24_.length > 0)
                              {
                                 _loc29_ = false;
                                 for each(_loc30_ in _loc24_)
                                 {
                                    _loc31_ = GetNodeFromDict(param1,_loc30_,_loc11_ - 1);
                                    if(_loc31_)
                                    {
                                       if(!(IsEdgeSecret(_loc16_,_loc31_) || IsEdgeSecret(_loc22_,_loc31_)))
                                       {
                                          _loc29_ = false;
                                          break;
                                       }
                                       _loc29_ = true;
                                    }
                                 }
                                 if(_loc29_)
                                 {
                                    _loc28_ = FamilyTreeEdge.STYLE_SECRET;
                                 }
                              }
                           }
                           if(_loc26_ != FamilyTreeEntry.RELATION_NONE)
                           {
                              _loc32_ = new FamilyTreeEdge(_loc16_.x,_loc16_.y,_loc22_.x,_loc22_.y,_loc28_,_loc27_);
                              _loc3_.push(_loc32_);
                           }
                           if(Boolean(_loc24_) && _loc24_.length > 0)
                           {
                              _loc18_ = CreateEdgesToChildren(_loc16_,_loc22_,_loc24_,_loc11_,param1,[_loc17_,_loc25_].filter(Functional.IsNotNull),_loc8_,_loc7_);
                              _loc3_ = _loc3_.concat(_loc18_);
                              if(_loc18_.length > 0)
                              {
                                 _loc8_++;
                              }
                           }
                        }
                     }
                  }
                  _loc6_++;
               }
               _loc9_++;
            }
            _loc4_++;
         }
         return _loc3_.reverse();
      }
      
      protected static function CreateEdgesToChildren(param1:FamilyTreeServiceNode, param2:FamilyTreeServiceNode, param3:Array, param4:int, param5:Object, param6:Array, param7:int, param8:int) : Vector.<FamilyTreeEdge>
      {
         var _loc10_:Boolean = false;
         var _loc13_:String = null;
         var _loc14_:FamilyTreeServiceNode = null;
         var _loc15_:uint = 0;
         var _loc16_:uint = 0;
         var _loc17_:Boolean = false;
         var _loc18_:Boolean = false;
         var _loc19_:Boolean = false;
         var _loc20_:Boolean = false;
         var _loc21_:Boolean = false;
         var _loc22_:Boolean = false;
         var _loc23_:Boolean = false;
         var _loc24_:Boolean = false;
         var _loc25_:uint = 0;
         var _loc26_:uint = 0;
         var _loc27_:uint = 0;
         var _loc28_:uint = 0;
         var _loc29_:Number = NaN;
         var _loc30_:FamilyTreeEdge = null;
         var _loc31_:FamilyTreeEdge = null;
         var _loc32_:FamilyTreeEdge = null;
         var _loc9_:Vector.<FamilyTreeEdge> = new Vector.<FamilyTreeEdge>();
         if(!param1)
         {
            return _loc9_;
         }
         _loc10_ = Boolean(param1) && Boolean(param2);
         var _loc11_:Number = _loc10_ ? (param1.x + param2.x) / 2 : param1.x;
         var _loc12_:Number = param1.y;
         for each(_loc13_ in param3)
         {
            _loc14_ = GetNodeFromDict(param5,_loc13_,param4 - 1);
            if(_loc14_)
            {
               _loc15_ = FamilyTreeEdge.STYLE_STANDARD;
               _loc16_ = FamilyTreeEdge.REL_CHILD;
               _loc17_ = Boolean(_loc14_.dynasty_id) && param6.indexOf(_loc14_.dynasty_id) != -1;
               _loc18_ = !_loc10_ ? IsEdgeForged(param1,_loc14_) : IsEdgeForged(param1,_loc14_) && IsEdgeForged(param2,_loc14_);
               _loc19_ = !_loc10_ ? IsEdgeSecret(param1,_loc14_) : IsEdgeSecret(param1,_loc14_) || IsEdgeSecret(param2,_loc14_);
               if(_loc17_)
               {
                  _loc15_ = FamilyTreeEdge.STYLE_DYNASTY;
               }
               if(_loc18_)
               {
                  _loc15_ = FamilyTreeEdge.STYLE_FORGED;
                  _loc16_ = FamilyTreeEdge.REL_FORGED;
               }
               else if(_loc19_)
               {
                  _loc15_ = FamilyTreeEdge.STYLE_SECRET;
                  _loc16_ = FamilyTreeEdge.REL_CHILD;
               }
               _loc20_ = false;
               if(_loc10_)
               {
                  _loc21_ = IsEdgeForged(param1,_loc14_);
                  _loc22_ = IsEdgeForged(param2,_loc14_);
                  _loc23_ = IsEdgeSecret(param1,_loc14_);
                  _loc24_ = IsEdgeSecret(param2,_loc14_);
                  if(!_loc21_ != !_loc22_)
                  {
                     _loc25_ = _loc23_ ? FamilyTreeEdge.STYLE_SECRET : (_loc21_ ? FamilyTreeEdge.STYLE_FORGED : (_loc17_ ? FamilyTreeEdge.STYLE_DYNASTY : FamilyTreeEdge.STYLE_STANDARD));
                     _loc26_ = _loc24_ ? FamilyTreeEdge.STYLE_SECRET : (_loc22_ ? FamilyTreeEdge.STYLE_FORGED : (_loc17_ ? FamilyTreeEdge.STYLE_DYNASTY : FamilyTreeEdge.STYLE_STANDARD));
                     _loc27_ = _loc23_ ? FamilyTreeEdge.REL_CHILD : (_loc21_ ? FamilyTreeEdge.REL_FORGED : FamilyTreeEdge.REL_CHILD);
                     _loc28_ = _loc24_ ? FamilyTreeEdge.REL_CHILD : (_loc22_ ? FamilyTreeEdge.REL_FORGED : FamilyTreeEdge.REL_CHILD);
                     _loc29_ = _loc25_ == FamilyTreeEdge.STYLE_FORGED ? param7 : param7 + 0.5;
                     _loc30_ = new FamilyTreeEdge(param1.x,param1.y,_loc14_.x,_loc14_.y,_loc25_,_loc27_,_loc29_,param8);
                     _loc29_ = _loc26_ == FamilyTreeEdge.STYLE_FORGED ? param7 : param7 + 0.5;
                     _loc31_ = new FamilyTreeEdge(param2.x,param2.y,_loc14_.x,_loc14_.y,_loc26_,_loc28_,param7,param8);
                     _loc9_.push(_loc30_);
                     _loc9_.push(_loc31_);
                     _loc20_ = true;
                  }
               }
               if(!_loc20_)
               {
                  _loc32_ = new FamilyTreeEdge(_loc11_,_loc12_,_loc14_.x,_loc14_.y,_loc15_,_loc16_,param7,param8);
                  _loc9_.push(_loc32_);
               }
            }
         }
         return _loc9_;
      }
      
      protected static function IsEdgeForged(param1:FamilyTreeServiceNode, param2:FamilyTreeServiceNode) : Boolean
      {
         if(Boolean(param1) && Boolean(param2))
         {
            if(Boolean(param1.sims_connected_by_forgery) && param1.sims_connected_by_forgery.indexOf(param2.sim_id) != -1)
            {
               return true;
            }
            if(Boolean(param2.sims_connected_by_forgery) && param2.sims_connected_by_forgery.indexOf(param1.sim_id) != -1)
            {
               return true;
            }
         }
         return false;
      }
      
      protected static function IsEdgeSecret(param1:FamilyTreeServiceNode, param2:FamilyTreeServiceNode) : Boolean
      {
         if(Boolean(param1) && Boolean(param2))
         {
            if(Boolean(param1.known_secret_children) && param1.known_secret_children.indexOf(param2.sim_id) != -1)
            {
               return true;
            }
            if(Boolean(param1.known_secret_parents) && param1.known_secret_parents.indexOf(param2.sim_id) != -1)
            {
               return true;
            }
            if(Boolean(param2.known_secret_children) && param2.known_secret_children.indexOf(param1.sim_id) != -1)
            {
               return true;
            }
            if(Boolean(param2.known_secret_parents) && param2.known_secret_parents.indexOf(param1.sim_id) != -1)
            {
               return true;
            }
         }
         return false;
      }
      
      protected static function GetAmountOfFilledChildrenGroupsInGeneration(param1:Vector.<FamilyTreeEntry>) : int
      {
         var _loc3_:FamilyTreeEntry = null;
         var _loc2_:int = 0;
         for each(_loc3_ in param1)
         {
            _loc2_ += _loc3_.GetAmountOfChildrenGroupsFilled();
         }
         return _loc2_;
      }
      
      protected static function FirstPass(param1:FamilyTreeEntry, param2:Number, param3:Number) : void
      {
         var _loc5_:FamilyTreeEntry = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:FamilyTreeEntry = null;
         var _loc11_:Array = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:Number = NaN;
         var _loc15_:int = 0;
         var _loc16_:FamilyTreeEntry = null;
         var _loc17_:FamilyTreeEntry = null;
         var _loc18_:Number = NaN;
         var _loc19_:FamilyTreeEntry = null;
         var _loc20_:Array = null;
         var _loc21_:Array = null;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Boolean = false;
         var _loc25_:FamilyTreeEntry = null;
         var _loc4_:Array = param1.GetAllChildrenThatHasEntryAsParent();
         for each(_loc5_ in _loc4_)
         {
            FirstPass(_loc5_,param2,param3);
         }
         _loc6_ = 0;
         _loc7_ = 0;
         _loc8_ = 0;
         _loc9_ = 0;
         if(param1.FirstPlacementPassComplete)
         {
            return;
         }
         if(param1.IsRoot)
         {
            param1.XPos = param1.GetMidpointOfChildren() - int(param1.Width / 2);
            param1.Mod = _loc7_;
            param1.Shift = _loc8_;
            param1.FirstPlacementPassComplete = true;
         }
         else
         {
            if(param1.HasChildrenEntries())
            {
               _loc9_ = param1.GetMidpointOfChildren();
            }
            if(param1.LeftSiblingEntry != null)
            {
               _loc6_ = param1.LeftSiblingEntry.XPos + int(param1.LeftSiblingEntry.Width) + param2;
               if(param1.HasChildrenEntries())
               {
                  _loc7_ = _loc6_ - _loc9_;
               }
            }
            else if(param1.HasChildrenEntries())
            {
               _loc6_ = _loc9_ - int(param1.Width / 2);
            }
            param1.XPos = _loc6_;
            param1.Mod = _loc7_;
            param1.Shift = param1.Shift == undefined ? int(_loc8_) : param1.Shift;
            param1.FirstPlacementPassComplete = true;
            _loc10_ = param1.ParentEntry;
            if(!_loc10_)
            {
               return;
            }
            _loc11_ = _loc10_.GetAllChildrenThatHasEntryAsParent();
            _loc12_ = _loc11_.indexOf(param1);
            if(_loc12_ <= -1)
            {
               return;
            }
            _loc13_ = 0;
            while(_loc13_ < _loc12_)
            {
               _loc16_ = _loc11_[_loc13_];
               _loc8_ = Math.max(_loc8_,GetSubtreeShift(_loc16_,param1,_loc13_,_loc12_,param3));
               _loc13_++;
            }
            _loc14_ = 0;
            _loc15_ = 0;
            while(_loc15_ < _loc11_.length)
            {
               _loc17_ = _loc11_[_loc15_];
               if(_loc15_ > 0)
               {
                  _loc19_ = _loc11_[_loc15_ - 1];
                  _loc20_ = _loc19_.GetAllChildrenThatHasEntryAsParent();
                  _loc21_ = _loc17_.GetAllChildrenThatHasEntryAsParent();
                  _loc22_ = 0;
                  _loc23_ = _loc21_.length;
                  _loc24_ = false;
                  for each(_loc25_ in _loc21_)
                  {
                     if(_loc20_.indexOf(_loc25_) != -1)
                     {
                        if(++_loc22_ >= _loc23_)
                        {
                           _loc24_ = true;
                           break;
                        }
                     }
                  }
                  if(!_loc24_)
                  {
                     _loc14_++;
                  }
               }
               _loc18_ = _loc17_.Shift == undefined ? 0 : _loc17_.Shift;
               _loc18_ = _loc18_ + _loc8_ * (_loc14_ / _loc12_);
               _loc17_.Shift = _loc18_;
               _loc15_++;
            }
         }
      }
      
      protected static function SecondPass(param1:FamilyTreeEntry, param2:Number, param3:Number = 0, param4:Number = 0, param5:Number = 2147483647) : Object
      {
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:FamilyTreeEntry = null;
         var _loc11_:Object = null;
         var _loc6_:Number = param1.XPos + param1.Shift + param3 + param2;
         if(!param1.SecondPlacementPassComplete)
         {
            param1.XPos = _loc6_;
            param1.SecondPlacementPassComplete = true;
         }
         var _loc7_:Array = param1.GetAllChildrenThatHasEntryAsParent();
         if(_loc7_.length > 0)
         {
            _loc8_ = [];
            _loc9_ = [];
            for each(_loc10_ in _loc7_)
            {
               _loc11_ = SecondPass(_loc10_,param2,param3 + param1.Mod + param1.Shift,param4,param5);
               _loc8_.push(_loc11_.shiftAmount);
               _loc9_.push(_loc11_.lowestX);
            }
            param4 = Math.max.apply(null,_loc8_);
            param5 = Math.min.apply(null,_loc9_);
         }
         return {
            "shiftAmount":Math.max(param4,-_loc6_),
            "lowestX":Math.min(param5,_loc6_)
         };
      }
      
      protected static function ThirdPass(param1:FamilyTreeEntry, param2:Number) : void
      {
         var _loc3_:Array = null;
         var _loc4_:FamilyTreeEntry = null;
         if(param2 != undefined)
         {
            if(!param1.ThirdPlacementPassComplete)
            {
               param1.XPos += param2;
               param1.ThirdPlacementPassComplete = true;
            }
            _loc3_ = param1.GetAllChildrenThatHasEntryAsParent();
            for each(_loc4_ in _loc3_)
            {
               ThirdPass(_loc4_,param2);
            }
         }
      }
      
      protected static function GetSubtreeShift(param1:FamilyTreeEntry, param2:FamilyTreeEntry, param3:int, param4:int, param5:Number, param6:Number = 0, param7:Number = 0, param8:Number = 0, param9:Boolean = true) : Number
      {
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Array = null;
         var _loc15_:Array = null;
         var _loc10_:Number = 0;
         if(!param9)
         {
            _loc11_ = param8 * param3 / param4;
            _loc12_ = param1.XPos + (param1.Width - 1) + param1.Shift + param6 + _loc11_;
            _loc13_ = param2.XPos + param2.Shift + param7 + param8;
            _loc10_ = Math.max((_loc12_ + param5 - _loc13_) / (1 - param3 / param4),0);
            _loc14_ = [];
            while(Boolean(param1 && !param1.HasChildrenEntries()) && Boolean(param1.LeftSiblingEntry) && _loc14_.indexOf(param1.LeftSiblingEntry) == -1)
            {
               param1 = param1.LeftSiblingEntry;
               _loc14_.push(param1);
            }
            _loc15_ = [];
            while(Boolean(param2 && !param2.HasChildrenEntries()) && Boolean(param2.RightSiblingEntry) && _loc15_.indexOf(param2.RightSiblingEntry) == -1)
            {
               param2 = param2.RightSiblingEntry;
               _loc15_.push(param2);
            }
         }
         if(param1.HasChildrenEntries() && param2.HasChildrenEntries())
         {
            return GetSubtreeShift(param1.RightmostChildEntry,param2.LeftmostChildEntry,param3,param4,param5,param6 + param1.Mod + param1.Shift,param7 + param2.Mod + param2.Shift,param8 + _loc10_,false);
         }
         return param8 + _loc10_;
      }
   }
}

