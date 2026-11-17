package widgets.LiveEvent.data
{
   import olympus.core.OlympusObject;
   import olympus.utils.DateUtils;
   
   public class LiveEventQuestModifierData extends OlympusObject
   {
      
      public var bIsActive:Boolean;
      
      public var endDate:Date = DateUtils.DateDST();
      
      public var modifierType:Number;
      
      public var startDate:Date = DateUtils.DateDST();
      
      public function LiveEventQuestModifierData(param1:Object = null)
      {
         super(param1);
      }
   }
}

