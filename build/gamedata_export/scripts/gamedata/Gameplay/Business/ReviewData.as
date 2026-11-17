package gamedata.Gameplay.Business
{
   import olympus.core.OlympusObject;
   
   public class ReviewData extends OlympusObject
   {
      
      public var zone_id:String;
      
      public var score:Number;
      
      public var review_count:int;
      
      public var icons:Array = [ReviewIconData];
      
      public var score_delta:Number;
      
      public function ReviewData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.icons);
      }
   }
}

