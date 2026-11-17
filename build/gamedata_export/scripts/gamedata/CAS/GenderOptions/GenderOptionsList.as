package gamedata.CAS.GenderOptions
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class GenderOptionsList extends OlympusObject
   {
      
      public var title:LocKey = new LocKey();
      
      public var options:Array = [GenderOptionData];
      
      public function GenderOptionsList(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.options);
      }
   }
}

