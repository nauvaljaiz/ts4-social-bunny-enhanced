package gamedata.CAS.Stories
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class CASStoriesDialogData extends OlympusObject
   {
      
      public static const DIALOG_STYLE_EXPEDITED:String = "music_festival";
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var text:LocKey = new LocKey();
      
      public var buttons:Array = [CASStoriesDialogButtonData];
      
      public var skip:Boolean;
      
      public var progress:Number;
      
      public var maxProgress:Number = 0;
      
      public var style:String;
      
      public function CASStoriesDialogData(param1:Object = null)
      {
         super(param1);
         FixupArray(this.buttons);
      }
   }
}

