package gamedata.CAS.shared
{
   import olympus.controls.objects.MenuItem;
   import olympus.localization.Keys;
   import widgets.CAS.constants.CASBodyType;
   
   public class CASCatalogFilter
   {
      
      public static const ID_UNLOCKS:String = "unlocks";
      
      public static const ID_MTX:String = "mtx";
      
      public static const ID_MODS:String = "mods";
      
      public static const ID_LOCKED:String = "locked";
      
      public static const CONTENT_FILTER_UNLOCKS:MenuItem = new MenuItem(Keys.FILTER_PANEL_UNLOCKS.toString(),ID_UNLOCKS);
      
      public static const CONTENT_FILTER_MTX:MenuItem = new MenuItem(Keys.FILTER_PANEL_MTX.toString(),ID_MTX);
      
      public static const CONTENT_FILTER_MODS:MenuItem = new MenuItem(Keys.FILTER_PANEL_MODS.toString(),ID_MODS);
      
      public static const CONTENT_FILTER_LOCKED:MenuItem = new MenuItem(Keys.FILTER_PANEL_LOCKED.toString(),ID_LOCKED);
      
      public var menuState:int;
      
      public var tags:Array = new Array();
      
      public var excludeTags:Array = new Array();
      
      public var filterByGameplayUnlocks:Boolean;
      
      public var filterPurchasedProducts:Boolean;
      
      public var filterModdedContent:Boolean;
      
      public var filterLocked:Boolean;
      
      public var packIds:Array = new Array();
      
      public var body_type:int = CASBodyType.NONE;
      
      public var layer:int = -1;
      
      public function CASCatalogFilter()
      {
         super();
      }
      
      public function ToLooksArgs() : Object
      {
         return {
            "tags":this.tags,
            "packIds":this.packIds
         };
      }
   }
}

