package gamedata.Gameplay.shared
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class OutfitItemInfo extends OlympusObject
   {
      
      public var title:LocKey = new LocKey();
      
      public var price:int;
      
      public var data_id:String;
      
      public var description:LocKey = new LocKey();
      
      public var buff_id:String;
      
      public var image:String;
      
      public function OutfitItemInfo(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         var _loc2_:String = "thumbs/cas/c_" + this.data_id;
         _loc2_ += "_m";
         this.image = _loc2_;
      }
   }
}

