package widgets.BuildBuy.VenueConfiguration.controls
{
   import olympus.controls.GUIComponent;
   import olympus.gamepad.EnterParams;
   import olympus.input.IInputAdapter;
   import olympus.input.IInputFocusable;
   
   public class VenueSettingsPanelBase extends GUIComponent implements IInputAdapter
   {
      
      public function VenueSettingsPanelBase()
      {
         super();
      }
      
      public function RefreshPanel() : void
      {
      }
      
      public function Enter(param1:EnterParams = null) : IInputFocusable
      {
         return null;
      }
      
      public function Exit() : void
      {
      }
      
      public function OnInputEventCall(param1:String, param2:Function) : IInputAdapter
      {
         return null;
      }
   }
}

