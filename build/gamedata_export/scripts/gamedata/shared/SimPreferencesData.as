package gamedata.shared
{
   import gamedata.Gameplay.shared.SimTraitsInfo;
   import gamedata.Gameplay.shared.definitions.PreferenceGroup;
   import gamedata.Gameplay.shared.definitions.SimPreferencesStaticData;
   import gamedata.Gameplay.shared.definitions.TraitsStaticData;
   
   public class SimPreferencesData
   {
      
      internal var traitLikes:Vector.<TraitsStaticData>;
      
      internal var traitDislikes:Vector.<TraitsStaticData>;
      
      internal var allPreferenceTraits:Vector.<TraitsStaticData>;
      
      internal var groupsById:Object;
      
      public function SimPreferencesData(param1:Vector.<TraitsStaticData>, param2:Vector.<TraitsStaticData>)
      {
         var _loc3_:TraitsStaticData = null;
         var _loc4_:TraitsStaticData = null;
         var _loc5_:SimPreferencesStaticData = null;
         var _loc6_:TraitsStaticData = null;
         var _loc7_:PreferenceGroup = null;
         super();
         this.traitLikes = param1;
         this.traitDislikes = param2;
         this.allPreferenceTraits = new Vector.<TraitsStaticData>();
         for each(_loc3_ in this.traitLikes)
         {
            this.allPreferenceTraits.push(_loc3_);
         }
         for each(_loc4_ in this.traitDislikes)
         {
            this.allPreferenceTraits.push(_loc4_);
         }
         this.groupsById = new Object();
         _loc5_ = SimPreferencesStaticData.GetStaticData();
         if(_loc5_ != null)
         {
            for each(_loc6_ in this.allPreferenceTraits)
            {
               _loc7_ = _loc5_.TryGetGroupByTraitId(_loc6_.id);
               if(_loc7_ != null)
               {
                  this.groupsById[_loc7_.group_id] = _loc7_;
               }
            }
         }
      }
      
      public static function FromAllTraitIds(param1:Array) : SimPreferencesData
      {
         var _loc4_:String = null;
         var _loc5_:TraitsStaticData = null;
         var _loc2_:Vector.<TraitsStaticData> = new Vector.<TraitsStaticData>();
         var _loc3_:Vector.<TraitsStaticData> = new Vector.<TraitsStaticData>();
         for each(_loc4_ in param1)
         {
            _loc5_ = TraitsStaticData.GetStaticData(_loc4_);
            if(_loc5_)
            {
               if(_loc5_.type == SimTraitsInfo.TRAIT_LIKE)
               {
                  _loc2_.push(_loc5_);
               }
               else if(_loc5_.type == SimTraitsInfo.TRAIT_DISLIKE)
               {
                  _loc3_.push(_loc5_);
               }
            }
         }
         return new SimPreferencesData(_loc2_,_loc3_);
      }
      
      public static function FromLikeDislikeTraitIds(param1:Array, param2:Array) : SimPreferencesData
      {
         var _loc5_:String = null;
         var _loc6_:TraitsStaticData = null;
         var _loc3_:Vector.<TraitsStaticData> = new Vector.<TraitsStaticData>();
         var _loc4_:Vector.<TraitsStaticData> = new Vector.<TraitsStaticData>();
         for each(_loc5_ in param1)
         {
            _loc6_ = TraitsStaticData.GetStaticData(_loc5_);
            if(_loc6_)
            {
               _loc3_.push(_loc6_);
            }
         }
         for each(_loc5_ in param2)
         {
            _loc6_ = TraitsStaticData.GetStaticData(_loc5_);
            if(_loc6_)
            {
               _loc4_.push(_loc6_);
            }
         }
         return new SimPreferencesData(_loc3_,_loc4_);
      }
      
      public function get AllPreferenceTraits() : Vector.<TraitsStaticData>
      {
         return this.allPreferenceTraits;
      }
      
      public function get TraitLikes() : Vector.<TraitsStaticData>
      {
         return this.traitLikes;
      }
      
      public function get TraitDislikes() : Vector.<TraitsStaticData>
      {
         return this.traitDislikes;
      }
      
      public function get HasPreferences() : Boolean
      {
         return this.HasLikes || this.HasDislikes;
      }
      
      public function get HasLikes() : Boolean
      {
         return this.traitLikes.length > 0;
      }
      
      public function get HasDislikes() : Boolean
      {
         return this.traitDislikes.length > 0;
      }
      
      public function get Groups() : Vector.<PreferenceGroup>
      {
         var _loc2_:PreferenceGroup = null;
         var _loc1_:Vector.<PreferenceGroup> = new Vector.<PreferenceGroup>();
         for each(_loc2_ in this.groupsById)
         {
            _loc1_.push(_loc2_);
         }
         return _loc1_;
      }
      
      protected function FilterByGroupId(param1:Vector.<TraitsStaticData>, param2:int) : Vector.<TraitsStaticData>
      {
         var _loc5_:TraitsStaticData = null;
         var _loc6_:PreferenceGroup = null;
         var _loc3_:Vector.<TraitsStaticData> = new Vector.<TraitsStaticData>();
         var _loc4_:SimPreferencesStaticData = SimPreferencesStaticData.GetStaticData();
         if(_loc4_ == null)
         {
            return _loc3_;
         }
         for each(_loc5_ in param1)
         {
            _loc6_ = _loc4_.TryGetGroupByTraitId(_loc5_.id);
            if(_loc6_ != null && _loc6_.group_id == param2)
            {
               _loc3_.push(_loc5_);
            }
         }
         return _loc3_;
      }
      
      public function LikesForGroup(param1:int) : Vector.<TraitsStaticData>
      {
         return this.FilterByGroupId(this.traitLikes,param1);
      }
      
      public function DislikesForGroup(param1:int) : Vector.<TraitsStaticData>
      {
         return this.FilterByGroupId(this.traitDislikes,param1);
      }
   }
}

