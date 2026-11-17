package gamedata.Dialog
{
   import olympus.core.OlympusObject;
   
   public class UiExchangeArgs extends OlympusObject
   {
      
      public var creator_id:String;
      
      public var creator_name:String;
      
      public var item_data:Object;
      
      public var feed_id:String;
      
      public var feed_type:uint;
      
      public var quantity:int;
      
      public var timestamp:String;
      
      public var is_maxis_curated:Boolean;
      
      public function UiExchangeArgs(param1:Object = null)
      {
         super(param1);
      }
   }
}

