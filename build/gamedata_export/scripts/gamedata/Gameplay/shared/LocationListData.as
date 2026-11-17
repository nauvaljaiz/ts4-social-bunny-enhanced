package gamedata.Gameplay.shared
{
   import olympus.core.OlympusObject;
   
   public class LocationListData extends OlympusObject
   {
      
      public var worldName:String;
      
      public var lots:Array = [LotInfoItem];
      
      public var selectedLotIndex:int;
      
      public var index:int;
      
      public var mFilteredLots:Array;
      
      protected var mPriorityLots:int = 0;
      
      public function LocationListData(param1:String, param2:int = -1, param3:int = -1, param4:Object = null)
      {
         super(param4);
         this.worldName = param1;
         param2 = param2;
         this.selectedLotIndex = param3;
         this.lots = new Array();
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.lots);
      }
      
      public function AddLot(param1:LotInfoItem) : void
      {
         if(param1.custom_schedule_activity_names.length > 0)
         {
            this.lots.splice(this.mPriorityLots++,0,param1);
         }
         else
         {
            this.lots.push(param1);
         }
      }
   }
}

