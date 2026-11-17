package gamedata.Exchange
{
   import gamedata.Gameplay.shared.definitions.AspirationTrackStaticData;
   import gamedata.Gameplay.shared.definitions.TraitsStaticData;
   import gamedata.shared.RankedStatisticSimData;
   import gamedata.shared.SimPreferencesData;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   import olympus.resources.IImageContainer;
   import olympus.utils.ImageUtils;
   import widgets.shared.constants.ExchangeDetailStates;
   
   public class ExchangeSimData extends OlympusObject
   {
      
      public var id:String;
      
      public var first_name:String;
      
      public var last_name:String;
      
      public var gender:int;
      
      public var age:int;
      
      public var aspirationId:String;
      
      public var trait_tracker:Object;
      
      public var sim_relationships:Array;
      
      public var allOccultTypes:int;
      
      public var species:uint;
      
      public var breedName:String;
      
      public var breedNameKey:LocKey;
      
      public var fame:RankedStatisticSimData;
      
      public var aspiration:AspirationTrackStaticData;
      
      public var traits:Vector.<TraitsStaticData>;
      
      public var simPreferencesData:SimPreferencesData;
      
      public var deathTrait:uint;
      
      public var isGhost:Boolean;
      
      public var relTooltipText:String;
      
      public var index:int;
      
      public var thumbnailContext:String;
      
      public var itemRemoteId:String;
      
      public function ExchangeSimData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         this.id = param1.id;
         this.first_name = param1.first_name;
         this.last_name = param1.last_name;
         this.gender = param1.gender;
         this.age = param1.age;
         this.aspirationId = param1.aspirationId;
         this.trait_tracker = param1.trait_tracker;
         this.sim_relationships = param1.sim_relationships;
         this.allOccultTypes = param1.allOccultTypes;
         this.species = param1.species;
         this.breedName = param1.breedName;
         this.deathTrait = param1.deathTrait;
         this.isGhost = this.deathTrait != 0;
         if("breedNameKey" in param1 && Boolean(param1.breedNameKey))
         {
            this.breedNameKey = new LocKey(param1.breedNameKey);
         }
         if("fame" in param1)
         {
            this.fame = new RankedStatisticSimData(param1["fame"]);
         }
         var _loc2_:Array = "like_trait_tracker" in param1 ? param1.like_trait_tracker.trait_ids as Array : new Array();
         var _loc3_:Array = "dislike_trait_tracker" in param1 ? param1.dislike_trait_tracker.trait_ids as Array : new Array();
         this.simPreferencesData = SimPreferencesData.FromLikeDislikeTraitIds(_loc2_,_loc3_);
         this.ParseSpecializedFields();
      }
      
      public function LoadThumbnail(param1:IImageContainer, param2:String = null, param3:int = -1, param4:String = null) : Boolean
      {
         if(!param1)
         {
            return false;
         }
         var _loc5_:int = param3 != -1 ? param3 : this.index;
         var _loc6_:String = param4 || this.id;
         switch(this.thumbnailContext)
         {
            case ExchangeDetailStates.GALLERY:
               return ImageUtils.LoadGalleryThumbnail(param1,this.itemRemoteId,"h",param2,_loc5_);
            case ExchangeDetailStates.MY_SAVES:
               return ImageUtils.LoadSimThumbnail(param1,_loc6_,ImageUtils.SIM_THUMBNAIL_TYPE_GALLERY,null,_loc5_);
            case ExchangeDetailStates.CAS_SHARE_PLAY:
            case ExchangeDetailStates.SAVE_SUMMARY:
         }
         return ImageUtils.LoadSimThumbnail(param1,_loc6_,ImageUtils.SIM_THUMBNAIL_TYPE_GALLERY);
      }
      
      protected function ParseSpecializedFields() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.aspirationId)
         {
            this.aspiration = AspirationTrackStaticData.GetTrackData(this.aspirationId);
         }
         if(Boolean(this.trait_tracker) && Boolean(this.trait_tracker.trait_ids))
         {
            _loc1_ = this.trait_tracker.trait_ids as Array;
            this.traits = new Vector.<TraitsStaticData>(_loc1_.length,true);
            _loc2_ = 0;
            _loc3_ = int(_loc1_.length);
            while(_loc2_ < _loc3_)
            {
               this.traits[_loc2_] = TraitsStaticData.GetStaticData(_loc1_[_loc2_]);
               _loc2_++;
            }
         }
         else
         {
            this.traits = new Vector.<TraitsStaticData>();
         }
         if(!this.breedNameKey.IsValid())
         {
            this.breedNameKey = null;
         }
      }
   }
}

