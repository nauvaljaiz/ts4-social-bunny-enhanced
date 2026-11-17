package gamedata.Gameplay.shared.definitions
{
   import olympus.core.OlympusObject;
   
   public class AvailableDaysStaticData extends OlympusObject
   {
      
      public var sunday:Boolean;
      
      public var monday:Boolean;
      
      public var tuesday:Boolean;
      
      public var wednesday:Boolean;
      
      public var thursday:Boolean;
      
      public var friday:Boolean;
      
      public var saturday:Boolean;
      
      public function AvailableDaysStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public function IsDayAvailable(param1:int) : Boolean
      {
         switch(param1)
         {
            case 0:
               return this.sunday;
            case 1:
               return this.monday;
            case 2:
               return this.tuesday;
            case 3:
               return this.wednesday;
            case 4:
               return this.thursday;
            case 5:
               return this.friday;
            case 6:
               return this.saturday;
            default:
               return false;
         }
      }
   }
}

