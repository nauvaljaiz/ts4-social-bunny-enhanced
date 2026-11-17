package gamedata.Gameplay.shared
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class SocialMediaReaction extends OlympusObject
   {
      
      public static const NARRATIVE_FRIENDLY:int = 0;
      
      public static const NARRATIVE_FLIRTY:int = 1;
      
      public static const NARRATIVE_MEAN:int = 2;
      
      public static const NARRATIVE_PROUD:int = 3;
      
      public static const NARRATIVE_EMBARRASSED:int = 4;
      
      public static const NARRATIVE_EXCITED:int = 5;
      
      public static const NARRATIVE_HAPPY:int = 6;
      
      public static const NARRATIVE_SAD:int = 7;
      
      public static const NARRATIVE_STRESSED:int = 8;
      
      public static const NARRATIVE_FUNNY:int = 9;
      
      public static const POLARITY_POSITIVE:int = 0;
      
      public static const POLARITY_NEGATIVE:int = 1;
      
      public var name:LocKey = new LocKey();
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var narrative:int;
      
      public var polarity:int;
      
      public function SocialMediaReaction(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!("icon" in param1))
         {
            this.icon = null;
         }
         this.name = FixupLocKey(this.name);
      }
   }
}

