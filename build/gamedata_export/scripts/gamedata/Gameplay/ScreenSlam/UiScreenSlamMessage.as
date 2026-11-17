package gamedata.Gameplay.ScreenSlam
{
   import gamedata.shared.ResourceKey;
   import gamedata.shared.UiDialogNotification;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class UiScreenSlamMessage extends OlympusObject
   {
      
      public static const TYPE_LEGACY:uint = 0;
      
      public static const TYPE_CUSTOM:uint = 1;
      
      public static const TYPE_TRAVEL_BILLBOARD:uint = uint.MAX_VALUE - 1;
      
      public static const SIZE_SMALL:uint = 0;
      
      public static const SIZE_MEDIUM:uint = 1;
      
      public static const SIZE_LARGE:uint = 2;
      
      public static const SIZE_EXTRA_LARGE:uint = 3;
      
      public static const SIZE_STRINGS:Array = ["Small","Medium","Large","ExtraLarge"];
      
      public var type:uint;
      
      public var name:LocKey;
      
      public var title:LocKey;
      
      public var icon:ResourceKey;
      
      public var icon1:ResourceKey;
      
      public var icon2:ResourceKey;
      
      public var size:uint;
      
      public var sim_id:String;
      
      public var ui_key:String;
      
      public var audio_sting:ResourceKey;
      
      public var header:String;
      
      public var subtitle:String;
      
      public var notification:UiDialogNotification;
      
      public var body:String;
      
      public function UiScreenSlamMessage(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         this.type = param1.type;
         if("name" in param1)
         {
            this.name = new LocKey(param1.name);
         }
         if("title" in param1)
         {
            this.title = new LocKey(param1.title);
         }
         if("icon" in param1)
         {
            this.icon = new ResourceKey(param1.icon);
         }
         if("icon1" in param1)
         {
            this.icon1 = new ResourceKey(param1.icon1);
         }
         if("icon2" in param1)
         {
            this.icon2 = new ResourceKey(param1.icon2);
         }
         this.size = param1["size"];
         this.sim_id = param1["sim_id"];
         this.ui_key = param1["ui_key"];
         if("audio_sting" in param1)
         {
            this.audio_sting = new ResourceKey(param1.audio_sting);
         }
      }
   }
}

