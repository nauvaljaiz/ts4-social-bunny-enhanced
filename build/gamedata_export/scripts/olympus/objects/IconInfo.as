package olympus.objects
{
   import gamedata.shared.DefinitionGeoPair;
   import gamedata.shared.ManagerObjectId;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class IconInfo extends OlympusObject
   {
      
      public static const CANVAS_STATE_PAINTING_CROSSSTITCH:int = 0;
      
      public static const CANVAS_STATE_PUZZLE:int = 1;
      
      public var name:LocKey;
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var desc:LocKey;
      
      public var location_desc:LocKey;
      
      public var icon_object:ManagerObjectId;
      
      public var icon_object_def:DefinitionGeoPair;
      
      public var texture_id:String;
      
      public var object_instance_id:String;
      
      public var texture_effect:String;
      
      public var control_id:int;
      
      public var tooltip:LocKey;
      
      public var canvas_state_type:int;
      
      public var multicolor:Array;
      
      public var main_objective:LocKey;
      
      public var parent_id:String;
      
      public var icon_background:ResourceKey;
      
      public function IconInfo(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         var _loc2_:* = undefined;
         if(!param1)
         {
            return;
         }
         this.icon.ParseObject(param1.icon);
         if("name" in param1)
         {
            this.name = new LocKey(param1.name);
         }
         if("desc" in param1)
         {
            this.desc = new LocKey(param1.desc);
         }
         if("location_desc" in param1)
         {
            this.location_desc = new LocKey(param1.location_desc);
         }
         if("main_objective" in param1)
         {
            this.main_objective = new LocKey(param1.main_objective);
         }
         if("icon_object" in param1)
         {
            this.icon_object = ManagerObjectId.GetValidatedManagerObjectId(param1.icon_object);
         }
         if("icon_object_def" in param1)
         {
            this.icon_object_def = new DefinitionGeoPair(param1.icon_object_def);
         }
         this.texture_id = param1["texture_id"];
         this.object_instance_id = param1["object_instance_id"];
         this.texture_effect = param1["texture_effect"];
         this.control_id = param1["control_id"];
         if("tooltip" in param1)
         {
            this.tooltip = new LocKey(param1.tooltip);
         }
         if("canvas_state_type" in param1)
         {
            this.canvas_state_type = param1.canvas_state_type;
         }
         if("multicolor" in param1 && param1.multicolor != null && param1.multicolor.length > 0)
         {
            this.multicolor = new Array();
            for each(_loc2_ in param1.multicolor)
            {
               this.multicolor.push(_loc2_);
            }
         }
         if("parent_id" in param1)
         {
            this.parent_id = param1["parent_id"];
         }
         if("icon_background" in param1)
         {
            this.icon_background = new ResourceKey();
            this.icon_background.ParseObject(param1.icon_background);
         }
      }
      
      public function GetDesc(param1:Object = null) : String
      {
         if(Boolean(this.desc) && this.desc.IsValid())
         {
            if(param1)
            {
               return this.desc.toString(param1);
            }
            return this.desc.toString();
         }
         return "";
      }
      
      public function GetLocationDesc(param1:Object = null) : String
      {
         if(Boolean(this.location_desc) && this.location_desc.IsValid())
         {
            if(param1)
            {
               return this.location_desc.toString(param1);
            }
            return this.location_desc.toString();
         }
         return "";
      }
      
      public function GetMainObjective(param1:Object = null) : String
      {
         if(Boolean(this.main_objective) && this.main_objective.IsValid())
         {
            if(param1)
            {
               return this.main_objective.toString(param1);
            }
            return this.main_objective.toString();
         }
         return "";
      }
      
      public function GetName(param1:Object = null) : String
      {
         if(Boolean(this.name) && this.name.IsValid())
         {
            if(param1)
            {
               return this.name.toString(param1);
            }
            return this.name.toString();
         }
         return "";
      }
   }
}

