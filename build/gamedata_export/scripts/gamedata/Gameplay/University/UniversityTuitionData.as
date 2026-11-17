package gamedata.Gameplay.University
{
   import olympus.core.OlympusObject;
   
   public class UniversityTuitionData extends OlympusObject
   {
      
      public var name:String;
      
      public var description:String;
      
      public var icon:String;
      
      public var cost:int;
      
      public function UniversityTuitionData(param1:Object = null, param2:String = "", param3:String = "", param4:String = null, param5:int = 0)
      {
         super(param1);
         this.name = param2;
         this.description = param3;
         this.icon = param4;
         this.cost = param5;
      }
   }
}

