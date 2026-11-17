package gamedata.Gameplay.Dynasty
{
   import olympus.core.OlympusObject;
   import olympus.objects.IconInfo;
   
   public class DynastyAlliesRivalsData extends OlympusObject
   {
      
      public var dynasty_id:String;
      
      public var name:String;
      
      public var icon:IconInfo = new IconInfo();
      
      public var icon_background:IconInfo = new IconInfo();
      
      public var prestige_level:Number;
      
      public var number_members:Number;
      
      public function DynastyAlliesRivalsData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
      }
   }
}

