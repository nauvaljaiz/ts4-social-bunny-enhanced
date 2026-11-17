package gamedata.CollectionDisplay
{
   import olympus.core.OlympusObject;
   import olympus.localization.KeysGP;
   import olympus.objects.IconInfo;
   
   public class CollectibleItemUpdate extends OlympusObject
   {
      
      public static const TYPE_ADD:int = 0;
      
      public static const TYPE_REMOVE:int = 1;
      
      public static const TYPE_DISCOVERY:int = 2;
      
      public var type:int;
      
      public var collection_id:String;
      
      public var household_id:String;
      
      public var object_id:String;
      
      public var object_def_id:String;
      
      public var quality:uint = 0;
      
      public var icon_info:IconInfo = new IconInfo();
      
      public var order_discovered:int;
      
      public function CollectibleItemUpdate(param1:Object = null)
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
      
      public function get QualityString() : String
      {
         if(this.quality == 0)
         {
            return null;
         }
         switch(this.quality)
         {
            case 1:
               return KeysGP.HOVERTIP_ONE_STAR.toString();
            case 2:
               return KeysGP.HOVERTIP_TWO_STAR.toString();
            case 3:
         }
         return KeysGP.HOVERTIP_THREE_STAR.toString();
      }
   }
}

