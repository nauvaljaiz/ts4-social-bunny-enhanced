package gamedata.Gameplay.SituationCreation
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   import olympus.objects.IconInfo;
   
   public class SituationJobData extends OlympusObject
   {
      
      public var job_resource_id:String;
      
      public var icon_info:IconInfo = new IconInfo();
      
      public var border_image:ResourceKey = new ResourceKey();
      
      public var is_hireable:Boolean;
      
      public var is_guest:Boolean;
      
      public var min_required:uint;
      
      public var max_allowed:uint;
      
      public var hire_cost:uint;
      
      public var help_tooltip:LocKey = new LocKey();
      
      public var hireCount:int;
      
      public var totalCost:uint;
      
      public var isAffordable:Boolean;
      
      public var simIds:Array = new Array();
      
      public var isLocked:Boolean;
      
      public var situationCategory:uint;
      
      public var hostSimID:String;
      
      public function SituationJobData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!this.help_tooltip.IsValid())
         {
            this.help_tooltip = null;
         }
      }
      
      public function get AvailableSimCount() : int
      {
         return this.max_allowed - this.hireCount;
      }
      
      public function get AvailableHireCount() : int
      {
         return this.max_allowed - this.SimCount;
      }
      
      public function get SimCount() : int
      {
         return this.simIds.length;
      }
      
      public function get InviteCount() : int
      {
         return this.SimCount + this.hireCount;
      }
      
      public function get AreRequiredRolesFilled() : Boolean
      {
         return this.InviteCount >= this.min_required;
      }
      
      public function get HasHiredAllRoles() : Boolean
      {
         return this.hireCount == this.max_allowed;
      }
      
      public function get PickingLimit() : int
      {
         return Math.min(this.InviteCount,this.AvailableSimCount);
      }
      
      public function ToJobArguments() : Array
      {
         var _loc2_:int = 0;
         var _loc1_:Array = new Array();
         var _loc3_:int = int(this.simIds.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_.push(this.job_resource_id);
            _loc1_.push(this.simIds[_loc2_]);
            _loc1_.push("INVITED");
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.hireCount)
         {
            _loc1_.push(this.job_resource_id);
            _loc1_.push(0);
            _loc1_.push("HIRED");
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function IsSimHired(param1:String) : Boolean
      {
         return this.simIds.indexOf(param1) > -1;
      }
      
      public function RemoveSimFromJob(param1:String) : void
      {
         this.simIds.splice(this.simIds.indexOf(param1),1);
      }
   }
}

