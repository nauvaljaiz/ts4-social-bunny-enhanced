package widgets.shared.data.TimerTextConfig
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class TimerTextState extends OlympusObject
   {
      
      public var locKey:LocKey;
      
      public var showLeadingText:Boolean;
      
      public var label:String;
      
      public function TimerTextState(param1:Object = null)
      {
         super(param1);
      }
   }
}

