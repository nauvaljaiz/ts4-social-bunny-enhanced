package gamedata.BuildBuy.shared
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class ProductGameplayInfo extends OlympusObject
   {
      
      public var name:LocKey = new LocKey();
      
      public var value:int;
      
      public function ProductGameplayInfo(param1:Object = null)
      {
         super(param1);
      }
   }
}

