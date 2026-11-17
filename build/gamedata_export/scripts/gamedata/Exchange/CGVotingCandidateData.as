package gamedata.Exchange
{
   import olympus.core.OlympusObject;
   
   public class CGVotingCandidateData extends OlympusObject
   {
      
      public var remote_id:String = "";
      
      public var views_count:uint;
      
      public var wins_count:uint;
      
      public var platform:uint;
      
      public var category:uint;
      
      public var expires_epoch_sec:Number;
      
      public var mExchangeData:ExchangeData;
      
      public function CGVotingCandidateData(param1:Object = null)
      {
         super(param1);
      }
   }
}

