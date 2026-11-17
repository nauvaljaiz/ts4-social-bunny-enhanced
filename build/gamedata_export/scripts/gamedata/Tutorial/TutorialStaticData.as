package gamedata.Tutorial
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class TutorialStaticData extends OlympusObject
   {
      
      public var categoryId:String;
      
      public var tutorialId:String;
      
      public var name:LocKey = new LocKey();
      
      public var slides:Array = [TutorialSlideData];
      
      public var ui_sort_order:int;
      
      public var tags:Array = [String];
      
      public var packId:int;
      
      public function TutorialStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.slides);
         FixupArray(this.tags);
      }
   }
}

