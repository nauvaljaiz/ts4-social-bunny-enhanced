package gamedata.MTX
{
   import olympus.core.OlympusObject;
   import olympus.localization.Keys;
   import olympus.localization.LocKey;
   
   public class UserEntitlement extends OlympusObject
   {
      
      public static const MASK_TRIAL_ENTITLEMENT:int = 16;
      
      public static const TRIAL_STATE_NONE:int = 0;
      
      public static const TRIAL_STATE_CONVERTED:int = 1;
      
      public static const TRIAL_STATE_TRIAL_ACTIVE:int = 16;
      
      public static const TRIAL_STATE_TRIAL_EXPIRED:int = 17;
      
      public var entitlement_id:String;
      
      public var version:uint;
      
      public var product_id:String;
      
      public var last_modified_date:String;
      
      public var product_sku:String;
      
      public var is_new:Boolean;
      
      public var product_name:LocKey = new LocKey();
      
      public var thumbnail:String;
      
      public var celebration_type:int;
      
      public var packId:int = -1;
      
      public var install_state:int = -1;
      
      public var trial_state:int = 0;
      
      public var trials_supported:Boolean = false;
      
      public var is_epi_item:* = false;
      
      public function UserEntitlement(param1:Object = null)
      {
         super(param1);
         this.product_name = Keys.CreateCatalogNameLocKey(this.product_name);
      }
   }
}

