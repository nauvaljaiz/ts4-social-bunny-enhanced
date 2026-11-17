package gamedata.GameEntry.Transfer
{
   import olympus.core.OlympusObject;
   
   public class TransferNeighborhoodData extends OlympusObject
   {
      
      public var nhdName:String;
      
      public var householdList:Array;
      
      public var mbExpanded:Boolean = false;
      
      public function TransferNeighborhoodData(param1:Object = null)
      {
         super(param1);
      }
   }
}

