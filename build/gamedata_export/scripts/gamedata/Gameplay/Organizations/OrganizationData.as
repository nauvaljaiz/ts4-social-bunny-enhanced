package gamedata.Gameplay.Organizations
{
   import flash.utils.getDefinitionByName;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   import olympus.math.TimeSpan;
   
   public class OrganizationData extends OlympusObject
   {
      
      protected static var sOrganizationMap:Object = new Object();
      
      public var org_id:String;
      
      public var name:LocKey = new LocKey();
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var description:LocKey = new LocKey();
      
      public var ranked_stat:String;
      
      public var hidden:Boolean;
      
      public var events:Array = [OrganizationEventInfo];
      
      public var no_events_are_scheduled_string:LocKey = new LocKey();
      
      public var is_enrolled:Boolean;
      
      public var objective_ids:Array = [String];
      
      public var mascot_label:String;
      
      public function OrganizationData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetStaticData(param1:String) : OrganizationData
      {
         var _loc2_:OrganizationData = sOrganizationMap[param1];
         if(_loc2_)
         {
            return _loc2_;
         }
         var _loc3_:Array = CommunicationManager.CallGameService("GetUniversityOrganizationTuningForIds",{"organization_ids":[param1]}) as Array;
         if(_loc3_[0])
         {
            _loc2_ = new OrganizationData(_loc3_[0]);
            sOrganizationMap[param1] = _loc2_;
            return _loc2_;
         }
         return null;
      }
      
      public static function SortOrgsByTime(param1:OrganizationData, param2:OrganizationData) : Number
      {
         if(!param2 || !param2.NextEvent())
         {
            return -1;
         }
         if(!param1 || !param1.NextEvent())
         {
            return 1;
         }
         return SortEventByTime(param1.NextEvent(),param2.NextEvent());
      }
      
      public static function SortEventByTime(param1:OrganizationEventInfo, param2:OrganizationEventInfo) : Number
      {
         var _loc3_:Object = param1.schedule.GetNextScheduledTimes();
         var _loc4_:Object = param2.schedule.GetNextScheduledTimes();
         var _loc5_:uint = (_loc3_["startTime"] as TimeSpan).ConvertToMinutes();
         var _loc6_:uint = (_loc4_["startTime"] as TimeSpan).ConvertToMinutes();
         return _loc5_ - _loc6_;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.events);
         FixupArray(this.objective_ids);
         if(this.events.length > 1)
         {
            this.events.sort(SortEventByTime);
         }
      }
      
      public function NextEvent() : OrganizationEventInfo
      {
         if(this.events.length == 0)
         {
            return null;
         }
         return this.events[0];
      }
      
      public function GetUniversityFrameLabel() : Object
      {
         if(this.hidden)
         {
            return "hidden";
         }
         if(this.mascot_label)
         {
            return this.mascot_label;
         }
         return 1;
      }
   }
}

