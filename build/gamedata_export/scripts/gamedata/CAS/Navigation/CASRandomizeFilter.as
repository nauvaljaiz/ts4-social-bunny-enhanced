package gamedata.CAS.Navigation
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class CASRandomizeFilter extends OlympusObject
   {
      
      public var name:LocKey = new LocKey();
      
      public var flags:uint = 0;
      
      public var required_flags:uint = 0;
      
      public var uiSortOrder:uint;
      
      public function CASRandomizeFilter(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
      }
   }
}

