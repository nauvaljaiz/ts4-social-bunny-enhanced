package gamedata.Dialog
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   import olympus.objects.IconInfo;
   
   public class DynamicSignActivityInfo extends OlympusObject
   {
      
      public var name:LocKey = new LocKey();
      
      public var description:LocKey = new LocKey();
      
      public var icon:IconInfo = new IconInfo();
      
      public function DynamicSignActivityInfo(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!("name" in param1))
         {
            this.name = null;
         }
         if(!("description" in param1))
         {
            this.description = null;
         }
      }
   }
}

