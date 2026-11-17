package gamedata.Gameplay.SimCamera
{
   import olympus.core.OlympusObject;
   
   public class PhotographyStateData extends OlympusObject
   {
      
      public static const CAMERA_QUALITY_CHEAP:uint = 0;
      
      public static const CAMERA_QUALITY_STANDARD:uint = 1;
      
      public static const CAMERA_QUALITY_EXPENSIVE:uint = 2;
      
      public static const CAMERA_QUALITY_SUPER_EXPENSIVE:uint = 3;
      
      public static const CAMERA_MODE_FREEFORM:uint = 0;
      
      public static const CAMERA_MODE_SIM:uint = 1;
      
      public static const CAMERA_MODE_SELFIE:uint = 2;
      
      public static const CAMERA_MODE_MULTI_SELFIE:uint = 3;
      
      public static const CAMERA_MODE_PHOTO_STUDIO:uint = 4;
      
      public static const CAMERA_MODE_PAINT_BY_REFERENCE:uint = 5;
      
      public static const CAMERA_MODE_TRIPOD:uint = 6;
      
      public static const CAMERA_MODE_DECORATOR:uint = 7;
      
      public static const CAMERA_MODE_CROSSSTITCH_BY_REFERENCE:uint = 8;
      
      public static const CAMERA_MODE_PUZZLE_BY_REFERENCE:uint = 9;
      
      public static const ZOOM_CAPABILITY_NONE:uint = 0;
      
      public static const ZOOM_CAPABILITY_SHORT:uint = 1;
      
      public static const ZOOM_CAPABILITY_LONG:uint = 2;
      
      public static const CAMERA_PHOTO_SIZE_SMALL:* = 0;
      
      public static const CAMERA_PHOTO_SIZE_MEDIUM:* = 1;
      
      public static const CAMERA_PHOTO_SIZE_LARGE:* = 2;
      
      public static const CAMERA_PHOTO_SIZE_EXTRA_LARGE:* = 3;
      
      public static const PHOTO_ORIENTATION_LANDSCAPE:* = 0;
      
      public static const PHOTO_ORIENTATION_PORTRAIT:* = 1;
      
      public var camera_mode:uint;
      
      public var zoom_capability:uint;
      
      public var camera_quality:uint;
      
      public var filters_disabled:Boolean;
      
      public var single_shot_mode:Boolean;
      
      public var max_photos:uint;
      
      public var aspect_ratio_x:uint;
      
      public var aspect_ratio_y:uint;
      
      public var mood_categories:Array = [SimCameraMoodCategoryData];
      
      public var orientation:uint;
      
      public var allow_change_orientation:Boolean = true;
      
      public var allow_change_size:Boolean = true;
      
      public function PhotographyStateData(param1:Object = null)
      {
         super(param1);
         FixupArray(this.mood_categories);
      }
      
      public function get AspectRatio() : Number
      {
         return this.aspect_ratio_y / this.aspect_ratio_x;
      }
      
      public function get ShowMoodCategories() : Boolean
      {
         return this.mood_categories != null && (this.camera_mode == CAMERA_MODE_SIM || this.camera_mode == CAMERA_MODE_TRIPOD || this.camera_mode == CAMERA_MODE_SELFIE || this.camera_mode == CAMERA_MODE_MULTI_SELFIE);
      }
      
      public function IsByReferenceMode() : Boolean
      {
         return this.camera_mode == CAMERA_MODE_PAINT_BY_REFERENCE || this.camera_mode == CAMERA_MODE_CROSSSTITCH_BY_REFERENCE || this.camera_mode == CAMERA_MODE_PUZZLE_BY_REFERENCE;
      }
   }
}

