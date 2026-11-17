package gamedata.BuildBuy.shared
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class ColorFilter extends OlympusObject
   {
      
      public var lockey:LocKey = new LocKey();
      
      public var color:uint;
      
      public var tagkey:uint;
      
      public function ColorFilter(param1:Object)
      {
         super(param1);
      }
   }
}

