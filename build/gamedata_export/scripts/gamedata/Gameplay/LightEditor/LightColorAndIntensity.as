package gamedata.Gameplay.LightEditor
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class LightColorAndIntensity extends OlympusObject
   {
      
      public var red:uint;
      
      public var green:uint;
      
      public var blue:uint;
      
      public var intensity:Number = 0;
      
      public var target_id:String;
      
      public var response_id:uint;
      
      public var palette:uint = 0;
      
      public var style:uint = 0;
      
      public var checkbox_state:Boolean;
      
      public var grid_label:LocKey = new LocKey();
      
      public var slider_label:LocKey = new LocKey();
      
      public function LightColorAndIntensity(param1:Object = null)
      {
         super(param1);
      }
      
      public function get Color() : uint
      {
         return 0xFF000000 | this.red << 16 & 0xFF0000 | this.green << 8 & 0xFF00 | this.blue << 0 & 0xFF;
      }
   }
}

