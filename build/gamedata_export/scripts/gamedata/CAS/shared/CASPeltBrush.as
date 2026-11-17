package gamedata.CAS.shared
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class CASPeltBrush extends OlympusObject
   {
      
      public var data_id:String;
      
      public var texture_id:String;
      
      public var isModded:Boolean;
      
      public var brushType:int;
      
      public var title:LocKey = new LocKey();
      
      public var lockedTooltip:LocKey = new LocKey();
      
      public var packId:int;
      
      public function CASPeltBrush(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!this.title.IsValid())
         {
            this.title = null;
         }
         if(!this.lockedTooltip.IsValid())
         {
            this.lockedTooltip = null;
         }
      }
   }
}

