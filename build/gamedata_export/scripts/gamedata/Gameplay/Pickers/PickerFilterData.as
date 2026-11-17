package gamedata.Gameplay.Pickers
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   import olympus.objects.IconInfo;
   
   public class PickerFilterData extends OlympusObject
   {
      
      public var tag_type:uint;
      
      public var icon_info:IconInfo = new IconInfo();
      
      public var description:LocKey = new LocKey();
      
      public function PickerFilterData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!this.description.IsValid())
         {
            this.description = null;
         }
      }
   }
}

