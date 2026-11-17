package gamedata.Gameplay.SituationDisplay
{
   import olympus.core.OlympusObject;
   import olympus.objects.IconInfo;
   
   public class SituationIconUpdate extends OlympusObject
   {
      
      public var situation_id:String;
      
      public var icon_info:IconInfo = new IconInfo();
      
      public function SituationIconUpdate(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!("icon_info" in param1) || !param1.icon_info)
         {
            this.icon_info = null;
         }
      }
   }
}

