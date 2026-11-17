package gamedata.Gameplay.shared
{
   import flash.geom.Vector3D;
   import gamedata.shared.ManagerObjectId;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.objects.IconInfo;
   import olympus.objects.RelationshipTrackInfo;
   
   public class BalloonInfo extends OlympusObject
   {
      
      public static const THOUGHT_TYPE:int = 0;
      
      public static const SPEECH_TYPE:int = 1;
      
      public static const DISTRESS_TYPE:int = 2;
      
      public static const SENTIMENT_TYPE:int = 3;
      
      public static const SENTIMENT_INFANT_TYPE:int = 4;
      
      public static const MOTIVE_FAILURE_PRIORITY:int = 0;
      
      public static const SPEECH_PRIORITY:int = 1;
      
      public static const THOUGHT_PRIORITY:int = 2;
      
      public static const SENTIMENT_PRIORITY:int = 3;
      
      public static const SENTIMENT_INFANT_PRIORITY:int = 4;
      
      public var sim_id:String;
      
      public var icon:ResourceKey;
      
      public var icon_info:IconInfo;
      
      public var icon_sim_id:String;
      
      public var overlay:ResourceKey;
      
      public var type:int;
      
      public var priority:int;
      
      public var duration:Number = 0;
      
      public var icon_object:ManagerObjectId;
      
      public var category_icon:IconInfo;
      
      public var view_offset_override:Vector3D;
      
      public var rel_track:RelationshipTrackInfo;
      
      public function BalloonInfo(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         this.sim_id = param1.sim_id;
         if("icon" in param1)
         {
            this.icon = new ResourceKey(param1.icon);
         }
         this.icon_sim_id = param1.icon_sim_id;
         if("overlay" in param1)
         {
            this.overlay = new ResourceKey(param1.overlay);
         }
         this.type = param1.type;
         this.priority = param1.priority;
         this.duration = param1.duration;
         if("icon_object" in param1)
         {
            this.icon_object = new ManagerObjectId(param1.icon_object);
         }
         if("category_icon" in param1)
         {
            this.category_icon = new IconInfo(param1.category_icon);
         }
         if("view_offset_override" in param1)
         {
            this.view_offset_override = new Vector3D(param1.view_offset_override.x,param1.view_offset_override.y,param1.view_offset_override.z);
         }
         if("rel_track" in param1)
         {
            this.rel_track = new RelationshipTrackInfo(param1.rel_track);
         }
         if("icon_info" in param1)
         {
            this.icon_info = new IconInfo(param1.icon_info);
         }
      }
   }
}

