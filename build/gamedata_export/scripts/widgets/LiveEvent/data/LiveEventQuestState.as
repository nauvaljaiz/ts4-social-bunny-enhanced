package widgets.LiveEvent.data
{
   import olympus.core.OlympusObject;
   
   public class LiveEventQuestState extends OlympusObject
   {
      
      public var questId:String;
      
      public var questState:int;
      
      public var questValue:int = 0;
      
      public var activeQuestModifier:Number = 0;
      
      public function LiveEventQuestState(param1:Object = null)
      {
         super(param1);
      }
      
      public function SetModifierType(param1:Array) : void
      {
         var _loc2_:LiveEventQuestModifierData = null;
         for each(_loc2_ in param1)
         {
            if(_loc2_.bIsActive)
            {
               this.activeQuestModifier = _loc2_.modifierType;
               return;
            }
         }
      }
   }
}

