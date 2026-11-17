package gamedata.Gameplay.shared
{
   import olympus.core.OlympusObject;
   
   public class RankedStatisticRankChangedUpdate extends OlympusObject
   {
      
      public var simId:String;
      
      public var stat_id:String;
      
      public var previous_rank:uint;
      
      public var current_rank:uint;
      
      public function RankedStatisticRankChangedUpdate(param1:Object = null)
      {
         super(param1);
      }
   }
}

