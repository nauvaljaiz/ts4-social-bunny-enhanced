package gamedata.BuildBuy.Context
{
   import flash.geom.Vector3D;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class ContextData extends OlympusObject
   {
      
      public static const CONTEXT_FACET:int = 0;
      
      public static const CONTEXT_BLOCK:int = 1;
      
      public static const CONTEXT_ROOF:int = 2;
      
      public static const CONTEXT_STAIRS:int = 3;
      
      public static const CONTEXT_FLOOR:int = 4;
      
      public static const CONTEXT_BLOCK_TOP:int = 5;
      
      public static const CONTEXT_MULTI_BLOCK:int = 6;
      
      public static const CONTEXT_FOUNTAIN:int = 7;
      
      public static const CONTEXT_YARD:int = 8;
      
      public static const CONTEXT_POOL:int = 9;
      
      public static const CONTEXT_LOTMOVE:int = 10;
      
      public static const FACET_LOCATION_DEFAULT:int = 0;
      
      public static const FACET_LOCATION_ROUNDED_PIECE:int = 1;
      
      public static const FACET_LOCATION_TOP_FLOOR:int = 2;
      
      public static const FACET_LOCATION_ZERO_AREA:int = 3;
      
      public static const FTSS_FULLWALL:uint = 0;
      
      public static const FTSS_FENCE:uint = 1;
      
      public static const FTSS_HIDDEN:uint = 2;
      
      public static const FTSS_SPANDREL:uint = 3;
      
      public static const FTSS_HALFWALL:uint = 4;
      
      public static const MOVE_TYPE_MOVE:int = 0;
      
      public static const MOVE_TYPE_CLONE:int = 1;
      
      public static const UNIT_INVALID:int = 0;
      
      public static const UNIT_FUNCTIONALITY_AVAILABLE:int = 1 << 0;
      
      public static const UNIT_ADD_DISABLED_CAP:int = 1 << 1;
      
      public static const UNIT_ADD_DISABLED_SAVE_CAP:int = 1 << 2;
      
      public static const UNIT_ADD_DISABLED_INVALID_UNIT:int = 1 << 3;
      
      public static const UNIT_DISABLED_LAST_BLOCK:int = 1 << 4;
      
      public static const AREA_TYPE_NONE:int = -1;
      
      public static const AREA_TYPE_BUSINESS_RESIDENTIAL:int = 0;
      
      public static const AREA_TYPE_BUSINESS_PUBLIC:int = 1;
      
      public static const AREA_TYPE_BUSINESS_EMPLOYEES_ONLY:int = 2;
      
      public static const SMALL_BUSINESS_DYNAMIC_AREAS:Array = [AREA_TYPE_BUSINESS_RESIDENTIAL,AREA_TYPE_BUSINESS_PUBLIC,AREA_TYPE_BUSINESS_EMPLOYEES_ONLY];
      
      public static const RAIL_TYPE_NONE:int = 0;
      
      public static const RAIL_TYPE_LEFT:int = 1;
      
      public static const RAIL_TYPE_RIGHT:int = 2;
      
      public static const RAIL_TYPE_DOUBLE:int = 3;
      
      public var contextType:int;
      
      public var id:Object;
      
      public var worldPosition:Vector3D;
      
      public var plexId:uint;
      
      public var unitStatus:int = 0;
      
      public var dynamicAreaType:int = -1;
      
      public var railType:int = 0;
      
      public var stairLength:int = 0;
      
      public var railFirstStep:int = 0;
      
      public var railLastStep:int = 0;
      
      public var level:int;
      
      public var mannequinExcessCount:int;
      
      public var disableLowerText:LocKey;
      
      public var disableRaiseText:LocKey;
      
      public var facetType:uint;
      
      public var facetLocation:int;
      
      public var isVisible:Boolean;
      
      public function ContextData(param1:Object)
      {
         super(param1);
      }
      
      public static function IsBlockType(param1:int) : Boolean
      {
         return param1 == CONTEXT_BLOCK || param1 == CONTEXT_MULTI_BLOCK || param1 == CONTEXT_FOUNTAIN || param1 == CONTEXT_YARD || param1 == CONTEXT_POOL;
      }
      
      public static function CanBeShared(param1:int) : Boolean
      {
         return param1 == CONTEXT_BLOCK || param1 == CONTEXT_POOL;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         this.contextType = param1.contextType;
         this.id = param1.id;
         this.worldPosition = new Vector3D(param1.worldPosition.x,param1.worldPosition.y,param1.worldPosition.z,param1.worldPosition.w);
         this.level = param1["level"];
         this.mannequinExcessCount = param1["mannequinExcessCount"];
         this.disableLowerText = LocKey.GetValidatedLocKey(param1.disableLowerText);
         this.disableRaiseText = LocKey.GetValidatedLocKey(param1.disableRaiseText);
         this.facetType = param1["facetType"];
         this.facetLocation = param1["facetLocation"];
         this.isVisible = param1["isVisible"];
         if("unitStatus" in param1)
         {
            this.unitStatus = param1["unitStatus"];
            if(this.unitStatus != UNIT_INVALID)
            {
               this.plexId = param1["plexId"];
            }
         }
         if("dynamicAreaType" in param1)
         {
            this.dynamicAreaType = param1["dynamicAreaType"];
         }
         if(this.contextType == CONTEXT_STAIRS)
         {
            if("railType" in param1)
            {
               this.railType = param1["railType"];
            }
            if(this.railType != RAIL_TYPE_NONE)
            {
               this.railFirstStep = param1["railFirstStep"];
               this.railLastStep = param1["railLastStep"];
            }
            this.stairLength = param1["stairLength"];
         }
      }
   }
}

