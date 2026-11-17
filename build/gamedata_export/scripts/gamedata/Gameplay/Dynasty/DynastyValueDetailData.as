package gamedata.Gameplay.Dynasty
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class DynastyValueDetailData extends OlympusObject
   {
      
      public var id:String;
      
      public var dynasty_value:LocKey = new LocKey();
      
      public var is_aligned:Boolean;
      
      public function DynastyValueDetailData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
      }
   }
}

