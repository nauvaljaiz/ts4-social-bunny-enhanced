package gamedata.Gameplay.SituationCreation
{
   public class SituationJobOutfitData
   {
      
      public var mSimId:String;
      
      public var mImage:String;
      
      public var mOutfitCategory:int;
      
      public function SituationJobOutfitData(param1:String, param2:String = "0", param3:int = 0)
      {
         super();
         this.mSimId = param2;
         this.mImage = param1;
         this.mOutfitCategory = param3;
      }
   }
}

