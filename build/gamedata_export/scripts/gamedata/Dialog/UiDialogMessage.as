package gamedata.Dialog
{
   import flash.display.MovieClip;
   import gamedata.Gameplay.Pickers.UiDialogMultiPicker;
   import gamedata.Gameplay.Pickers.UiDialogPicker;
   import gamedata.shared.ResourceKey;
   import olympus.constants.DialogTypes;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   import olympus.objects.IconInfo;
   
   public class UiDialogMessage extends OlympusObject
   {
      
      public static const TYPE_DEFAULT:int = 1;
      
      public static const TYPE_OBJECT_PICKER:int = 2;
      
      public static const TYPE_NOTIFICATION:int = 3;
      
      public static const TYPE_OK_CANCEL_ICONS:int = 4;
      
      public static const TYPE_INFO_SETTING:int = 5;
      
      public static const TYPE_ICONS_LABELS:int = 6;
      
      public static const TYPE_OBJECT_MULTI_PICKER:int = 7;
      
      public static const TYPE_INFO_IN_COLUMNS:int = 8;
      
      public static const TYPE_CUSTOMIZE_OBJECT_MULTI_PICKER:int = 9;
      
      public static const TYPE_REVEAL_SEQUENCE:int = 10;
      
      public static const TYPE_JEWELRY_CRAFTING:int = 11;
      
      public static const TYPE_DEATH_OPTIONS:int = 12;
      
      public static const TYPE_FAMILY_RECIPE_CREATION:int = 13;
      
      public static const TYPE_MOVIE_CLIP_DIALOG:int = int.MAX_VALUE - 1;
      
      public var text:LocKey;
      
      public var dialog_type:uint;
      
      public var dialog_id:String;
      
      public var choices:Array;
      
      public var timeout_duration:Number;
      
      public var owner_id:String;
      
      public var target_id:String;
      
      public var text_input:Array;
      
      public var title:LocKey;
      
      public var subtitle:LocKey;
      
      public var dialog_options:uint;
      
      public var icon_info:IconInfo;
      
      public var secondary_icon_info:IconInfo;
      
      public var timestamp:String;
      
      public var lot_title:LocKey;
      
      public var venue_icon:IconInfo;
      
      public var icon_infos:Array;
      
      public var dialog_style:int;
      
      public var override_sim_icon_id:String;
      
      public var dialog_bg_style:int;
      
      public var additional_texts:Array;
      
      public var is_special_dialog:Boolean;
      
      public var background_audio_event:String;
      
      public var background_image:ResourceKey;
      
      public var footer_type:int;
      
      public var mask_alert_icon_info:IconInfo;
      
      public var mask_alert_sim_name:LocKey;
      
      public var mask_header_icon_info:IconInfo;
      
      public var validation_command:String = null;
      
      public var show_dialog_message_override:* = null;
      
      public var checkboxLabel:LocKey;
      
      public var settingName:String;
      
      public var bAccountSetting:Boolean;
      
      public var checkboxDefaultValue:Boolean;
      
      public var picker_data:UiDialogPicker;
      
      public var multi_picker_data:UiDialogMultiPicker;
      
      public var info_in_columns_data:UiDialogInfoInColumns;
      
      public var movieclip:MovieClip;
      
      public function UiDialogMessage(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         this.dialog_id = "dialog_id" in param1 ? param1.dialog_id : "0";
         this.text = new LocKey(param1.text);
         this.dialog_type = param1.dialog_type;
         this.choices = new Array();
         if("choices" in param1)
         {
            ConstructArrayFromArray(this.choices,param1.choices,UiDialogChoiceMessage);
         }
         this.timeout_duration = "timeout_duration" in param1 ? Number(param1.timeout_duration) : -1;
         this.owner_id = param1["owner_id"];
         this.target_id = param1["target_id"];
         this.text_input = new Array();
         if("text_input" in param1)
         {
            ConstructArrayFromArray(this.text_input,param1.text_input,UiDialogTextInputMessage);
         }
         if("title" in param1 && Boolean(param1.title))
         {
            this.title = new LocKey(param1.title);
         }
         if("subtitle" in param1 && Boolean(param1.subtitle))
         {
            this.subtitle = new LocKey(param1.subtitle);
         }
         this.dialog_options = param1["dialog_options"];
         if("icon_info" in param1 && Boolean(param1.icon_info))
         {
            this.icon_info = new IconInfo(param1.icon_info);
         }
         if("secondary_icon_info" in param1 && Boolean(param1.secondary_icon_info))
         {
            this.secondary_icon_info = new IconInfo(param1.secondary_icon_info);
         }
         this.timestamp = param1["timestamp"];
         this.override_sim_icon_id = param1["override_sim_icon_id"];
         if("lot_title" in param1 && Boolean(param1.lot_title))
         {
            this.lot_title = new LocKey(param1.lot_title);
         }
         if("venue_icon" in param1 && Boolean(param1.venue_icon))
         {
            this.venue_icon = new IconInfo(param1.venue_icon);
         }
         this.icon_infos = new Array();
         if("icon_infos" in param1)
         {
            ConstructArrayFromArray(this.icon_infos,param1.icon_infos,IconInfo);
         }
         this.dialog_style = "dialog_style" in param1 ? int(param1.dialog_style) : DialogTypes.STYLE_DEFAULT;
         this.dialog_bg_style = "dialog_bg_style" in param1 ? int(param1.dialog_bg_style) : DialogTypes.BG_STYLE_DEFAULT;
         this.additional_texts = new Array();
         if("additional_texts" in param1)
         {
            ConstructArrayFromArray(this.additional_texts,param1.additional_texts,LocKey);
         }
         if("checkboxLabel" in param1)
         {
            this.checkboxLabel = new LocKey(param1.checkboxLabel);
         }
         this.settingName = param1["settingName"];
         this.bAccountSetting = param1["bAccountSetting"];
         this.checkboxDefaultValue = param1["checkboxDefaultValue"];
         this.is_special_dialog = param1["is_special_dialog"];
         this.background_audio_event = param1["background_audio_event"];
         if("mask_alert_icon" in param1)
         {
            this.mask_alert_icon_info = new IconInfo(param1.mask_alert_icon);
         }
         if("mask_alert_sim_name" in param1)
         {
            this.mask_alert_sim_name = new LocKey(param1.mask_alert_sim_name);
         }
         if("mask_header_icon" in param1)
         {
            this.mask_header_icon_info = new IconInfo(param1.mask_header_icon);
         }
         if("background_image" in param1)
         {
            this.background_image = new ResourceKey(param1.background_image);
         }
         this.footer_type = param1["footer_type"];
         switch(this.dialog_type)
         {
            case TYPE_OBJECT_PICKER:
               this.picker_data = new UiDialogPicker(param1.picker_data);
               break;
            case TYPE_OBJECT_MULTI_PICKER:
            case TYPE_CUSTOMIZE_OBJECT_MULTI_PICKER:
            case TYPE_FAMILY_RECIPE_CREATION:
            case TYPE_JEWELRY_CRAFTING:
               this.multi_picker_data = new UiDialogMultiPicker(param1.multi_picker_data);
               break;
            case TYPE_INFO_IN_COLUMNS:
               this.info_in_columns_data = new UiDialogInfoInColumns(param1.info_in_columns_data);
         }
         if("validation_command" in param1)
         {
            this.validation_command = param1["validation_command"];
         }
         if("show_dialog_message_override" in param1)
         {
            this.show_dialog_message_override = param1["show_dialog_message_override"];
         }
      }
   }
}

