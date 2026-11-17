package gamedata.Gameplay.SecretsScandals
{
   import gamedata.shared.GameClockTime;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   import olympus.math.TimeSpan;
   import olympus.objects.IconInfo;
   
   public class SecretScandalDataSimpleData extends OlympusObject
   {
      
      public var secret_id:String;
      
      public var name:LocKey = new LocKey();
      
      public var description:LocKey = new LocKey();
      
      public var icon:IconInfo = new IconInfo();
      
      public var status_id:uint;
      
      public var expiration_date:Number;
      
      public function SecretScandalDataSimpleData(param1:Object = null)
      {
         super(param1);
      }
      
      public function GetRemainingTimeInMinutes() : *
      {
         var _loc1_:Number = Number(GameClockTime.GetCurrentTicks());
         var _loc2_:Number = Math.max(this.expiration_date - _loc1_,0);
         var _loc3_:Number = Number(GameClockTime.TicksToSeconds(_loc2_.toString()));
         var _loc4_:TimeSpan = new TimeSpan(0,_loc3_);
         return _loc4_.ConvertToMinutes();
      }
   }
}

