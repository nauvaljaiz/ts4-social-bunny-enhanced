package gamedata.Gameplay.Pickers
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   import olympus.objects.IconInfo;
   
   public class SimPickerCustomFilter extends OlympusObject
   {
      
      public var filter_value:int;
      
      public var icon_info:IconInfo = new IconInfo();
      
      public var tooltip:LocKey = new LocKey();
      
      public function SimPickerCustomFilter(param1:Object = null)
      {
         super(param1);
         if("icon_info" in param1)
         {
            this.icon_info = new IconInfo(param1.icon_info);
         }
      }
   }
}

