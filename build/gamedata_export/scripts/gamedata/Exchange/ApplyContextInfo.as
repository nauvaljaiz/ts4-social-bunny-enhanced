package gamedata.Exchange
{
   import olympus.core.OlympusObject;
   
   public final class ApplyContextInfo extends OlympusObject
   {
      
      public static const OVERRIDE_MODE_NONE:uint = 0;
      
      public static const OVERRIDE_MODE_PLAY_NEIGHBOR_LOT:uint = 1;
      
      public var overrideMode:uint = 0;
      
      public var householdNumSims:int = 0;
      
      public var lotId:String;
      
      public var lotIds:Array = [String];
      
      public var lotFunds:uint = 0;
      
      public function ApplyContextInfo(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.lotIds);
      }
      
      public function IsOccupied() : Boolean
      {
         if(Boolean(this.lotId) && Boolean(this.lotId.length > 0) && this.lotId != "0")
         {
            return this.householdNumSims > 0;
         }
         return true;
      }
   }
}

