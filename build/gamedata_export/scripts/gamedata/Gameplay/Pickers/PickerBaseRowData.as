package gamedata.Gameplay.Pickers
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   import olympus.objects.IconInfo;
   
   public class PickerBaseRowData extends OlympusObject
   {
      
      public var option_id:uint;
      
      public var is_enable:Boolean;
      
      public var is_enable_fresh:Boolean;
      
      public var is_enable_prepped:Boolean;
      
      public var is_enable_both_fresh_prepped:Boolean;
      
      public var is_selected:Boolean;
      
      public var name:LocKey;
      
      public var icon:ResourceKey;
      
      public var description:LocKey;
      
      public var description_only_prepped:LocKey;
      
      public var description_both_fresh_prepped:LocKey;
      
      public var icon_info:IconInfo;
      
      public var tooltip:LocKey;
      
      public var tooltip_only_prepped:LocKey;
      
      public var tooltip_both_fresh_prepped:LocKey;
      
      public var tag_list:Array;
      
      public var second_tag_list:Array;
      
      public var disabledTooltip:String;
      
      public function PickerBaseRowData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         this.option_id = param1.option_id;
         this.is_enable = param1.is_enable;
         this.is_enable_fresh = param1.is_enable_fresh;
         this.is_enable_prepped = param1.is_enable_prepped;
         this.is_enable_both_fresh_prepped = param1.is_enable_both_fresh_prepped;
         this.is_selected = param1.is_selected;
         this.tag_list = new Array();
         if(param1.tag_list != null)
         {
            ConstructArrayFromArray(this.tag_list,param1.tag_list,uint);
         }
         this.second_tag_list = new Array();
         if(param1.second_tag_list != null)
         {
            ConstructArrayFromArray(this.second_tag_list,param1.second_tag_list,uint);
         }
         if("name" in param1 && Boolean(param1.name))
         {
            this.name = new LocKey(param1.name);
         }
         if("icon" in param1 && Boolean(param1.icon))
         {
            this.icon = new ResourceKey(param1.icon);
         }
         if("description" in param1 && Boolean(param1.description))
         {
            this.description = new LocKey(param1.description);
         }
         if("description_only_prepped" in param1 && Boolean(param1.description_only_prepped))
         {
            this.description_only_prepped = new LocKey(param1.description_only_prepped);
         }
         if("description_both_fresh_prepped" in param1 && Boolean(param1.description_both_fresh_prepped))
         {
            this.description_both_fresh_prepped = new LocKey(param1.description_both_fresh_prepped);
         }
         if("icon_info" in param1)
         {
            this.icon_info = new IconInfo(param1.icon_info);
         }
         if("tooltip" in param1)
         {
            if(param1.tooltip is LocKey)
            {
               this.tooltip = param1.tooltip;
            }
            else
            {
               this.tooltip = LocKey.GetValidatedLocKey(param1.tooltip);
            }
         }
         if("tooltip_only_prepped" in param1)
         {
            this.tooltip_only_prepped = LocKey.GetValidatedLocKey(param1.tooltip_only_prepped);
         }
         if("tooltip_both_fresh_prepped" in param1)
         {
            this.tooltip_both_fresh_prepped = LocKey.GetValidatedLocKey(param1.tooltip_both_fresh_prepped);
         }
      }
      
      public function get Name() : String
      {
         if(this.name)
         {
            return this.name.toString();
         }
         return null;
      }
   }
}

