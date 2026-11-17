package gamedata.CAS.SimSelector
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class AddSimMenuItemData extends OlympusObject
   {
      
      public static const ACTION_NONE:int = 0;
      
      public static const ACTION_CATEGORY:int = 1;
      
      public static const ACTION_ADD_SIM:int = 2;
      
      public static const ACTION_GENETICS:int = 3;
      
      public static const ACTION_GALLERY:int = 4;
      
      public static const ACTION_LIBRARY:int = 5;
      
      public static const ACTION_STORY:int = 6;
      
      public var icon:String = "0";
      
      public var icon_selected:String = "0";
      
      public var tooltip:LocKey = new LocKey();
      
      public var audio_name:String;
      
      public var tutorial_control_enum:String;
      
      public var flair_name:String;
      
      public var sub_items:Array = [AddSimMenuItemData];
      
      public var action:int;
      
      public var occult_type:int;
      
      public var species:int;
      
      public var limit_genetics_species:Array = [int];
      
      public var uiSortIndex:uint;
      
      public var parent_index:uint;
      
      public function AddSimMenuItemData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.sub_items);
         FixupArray(this.limit_genetics_species);
      }
   }
}

