package olympus.utils
{
   import flash.utils.getDefinitionByName;
   
   public class LibraryUtils
   {
      
      public static const GENERIC_DIVIDER:String = "GenericDivider";
      
      public static const GENERIC_CHECKBOX:String = "GenericCheckBox";
      
      public static const GENERIC_SCROLL_BAR:String = "GenericScrollBar";
      
      public static const GUI_IMAGE:String = "library.Components.GUIImage";
      
      public static const GUI_GENERIC_TEXTBUTTON:String = "GUIGenericTextButton";
      
      public static const GUI_SCROLL_BAR:String = "olympus.controls.SmoothSlider";
      
      public static const GUI_MENU_ITEM_VIEW:String = "GUIMenuItemCellView";
      
      public static const GUI_MENU_ITEM_VIEW_FLAT:String = "GUIMenuItemCellView_Flat";
      
      public static const GUI_MENU_ITEM_ICON_VIEW:String = "GUIMenuItemIconCellView";
      
      public static const GUI_MENU_ITEM_ICON_VIEW_LARGE:String = "GUIMenuItemIconCellView_Large";
      
      public static const GUI_EXPANDING_MENU_ITEM_VIEW:String = "GUIExpandingMenuItemView";
      
      public static const GUI_EXPANDING_HEADER_MENU_ITEM_VIEW:String = "GUIExpandingHeaderMenuItemView";
      
      public static const GUI_CHECKBOX_BUTTON:String = "GUICheckboxButton";
      
      public static const GUI_CHECKBOX_BACKGROUND_BUTTON:String = "GUICheckboxBackgroundButton";
      
      public static const GUI_CHECKBOX_ICON_BUTTON:String = "GUICheckboxIconButton";
      
      public static const GUI_RADIO_BUTTON:String = "GUIRadioButton";
      
      public static const GUI_RADIO_ICON_BUTTON:String = "GUIRadioIconButton";
      
      public static const GUI_GENERIC_TEXTBUTTON_MINI:String = "GUIGenericTextButtonMini";
      
      public static const GUI_PIP_BUTTON:String = "GUIPipButton";
      
      public static const GUI_COLLAPSIBLE_CATEGORY_VIEW:String = "GUICollapsibleCategoryCellView";
      
      public static const GUI_POP_UP_LIST_ITEM_VIEW:String = "GUIPopUpListItemView";
      
      public static const GUI_CUSTOMIZABLE_BUTTON:String = "GUICustomizableButton";
      
      public static const GUI_BUNDLE_ICON:String = "GUIBundleIcon";
      
      public static const LOADING_INDICATOR:String = "olympus.controls.LoadingIndicator";
      
      public static const NOTIFICATION_VIEW:String = "library.Components.NotificationView";
      
      public static const NOTIFICATION_SPEECH_BUBBLE:String = "library.Components.SpeechBubbleBackground";
      
      public static const NOTIFICATION_SPEECH_BUBBLE_LARGE:String = "library.Components.SpeechBubbleLargeBackground";
      
      public static const CAREER_JOB_TITLE_CELL_VIEW:String = "library.Components.JobTitleCellView";
      
      public static const CAREER_JOB_INFO_CELL_VIEW:String = "library.Components.JobInfoCellView";
      
      public static const CAREER_JOB_TIME_CELL_VIEW:String = "library.Components.JobTimeCellView";
      
      public static const TEXT_VIEW_IMAGE_BUTTON:String = "library.Components.TextViewImageButton";
      
      public static const VARIATION_GRID:String = "library.Components.VariationGrid";
      
      public static const VARIATION_STACK_CELL_VIEW:String = "library.Components.VariationStackCellView";
      
      public static const VARIATION_THUMBNAIL_CELL_VIEW:String = "library.Components.VariationThumbnailCellView";
      
      public static const FILTER_GROUP:String = "library.Components.FilterGroup";
      
      public static const FAMILY_TREE_SIM_ICON_BUTTON:String = "library.FamilyTree.SimIconButton";
      
      public static const FOOD_CELL_VIEW:String = "library.Components.FoodCellView";
      
      public static const COLOR_SWATCH_SLIDER:String = "library.Components.ColorSwatchSlider";
      
      protected static var sDefinitions:Object = new Object();
      
      public function LibraryUtils()
      {
         super();
      }
      
      public static function GetLibraryClass(param1:String) : Class
      {
         if(param1 in sDefinitions)
         {
            return sDefinitions[param1] as Class;
         }
         var _loc2_:Object = getDefinitionByName(param1);
         if(_loc2_)
         {
            sDefinitions[param1] = _loc2_;
            return _loc2_ as Class;
         }
         return null;
      }
      
      public static function GetClass(param1:String) : Class
      {
         try
         {
            return getDefinitionByName(param1) as Class;
         }
         catch(error:*)
         {
         }
         return null;
      }
   }
}

