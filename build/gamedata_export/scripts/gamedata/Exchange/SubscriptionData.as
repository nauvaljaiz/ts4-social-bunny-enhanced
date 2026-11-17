package gamedata.Exchange
{
   import olympus.core.OlympusObject;
   
   public class SubscriptionData extends OlympusObject
   {
      
      public var id:String;
      
      public var persona:String;
      
      public var followers:int;
      
      public var bFollowing:Boolean;
      
      public var bFollowingMe:Boolean;
      
      public var blocked:Boolean;
      
      public var platformPlayerName:String;
      
      public function SubscriptionData(param1:Object = null)
      {
         super(param1);
      }
   }
}

