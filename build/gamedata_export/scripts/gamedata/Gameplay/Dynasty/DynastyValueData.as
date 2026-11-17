package gamedata.Gameplay.Dynasty
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   import olympus.objects.IconInfo;
   
   public class DynastyValueData extends OlympusObject
   {
      
      public var value_id:uint;
      
      public var value_name:LocKey = new LocKey();
      
      public var value_type:int;
      
      public var value_icon:IconInfo = new IconInfo();
      
      public var value_tooltip:LocKey = new LocKey();
      
      protected var mCellViewIndex:int;
      
      public function DynastyValueData(param1:Object = null)
      {
         super(param1);
         if(param1)
         {
            this.value_id = param1.value_id;
            this.value_name = LocKey.FromHash(param1.value_name.hash);
            this.value_icon.ParseObject(param1.value_icon);
            this.value_tooltip = LocKey.FromHash(param1.value_tooltip.hash,param1.value_tooltip.tokens);
         }
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
      }
      
      public function get CellViewIndex() : int
      {
         return this.mCellViewIndex;
      }
      
      public function set CellViewIndex(param1:int) : void
      {
         this.mCellViewIndex = param1;
      }
   }
}

