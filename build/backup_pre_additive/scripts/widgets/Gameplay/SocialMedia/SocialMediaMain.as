package widgets.Gameplay.SocialMedia
{
   import gamedata.Gameplay.SocialMedia.SocialMediaDialog;
   import gamedata.Gameplay.shared.GameplayStateData;
   import gamedata.shared.GameClockTime;
   import olympus.core.Time;
   import olympus.core.widget.WidgetBase;
   import olympus.events.GenericEvent;
   import olympus.gamepad.EnterParams;
   import olympus.gamepad.NavManager;
   import olympus.input.IInputFocusable;
   import olympus.io.CommunicationManager;
   import olympus.utils.SystemUtils;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol260")]
   public class SocialMediaMain extends WidgetBase
   {
      
      public var mcSocialMediaPanel:SocialMediaPanel;
      
      public function SocialMediaMain()
      {
         super();
      }
      
      public static function GetMinutesSincePostTime(param1:uint) : uint
      {
         var _loc2_:uint = uint(Time.ConvertToSimTime(param1));
         var _loc3_:GameClockTime = GameClockTime.GetFullGameClockTime();
         var _loc4_:uint = uint(_loc3_.ToSeconds()) * 1000;
         return (_loc4_ - _loc2_) / 1000 / 60;
      }
      
      override public function Initialize() : void
      {
         super.Initialize();
         this.mcSocialMediaPanel.addEventListener(GenericEvent.CLOSE,this.OnPanelClose,false,0,true);
         CommunicationManager.AddMessageListener("UpdateSocialMedia",this.HandleUpdateSocialMedia,this,SocialMediaDialog);
      }
      
      override public function Show(param1:Object = null) : void
      {
         super.Show(param1);
         this.mcSocialMediaPanel.OnMainShow(param1);
         if(SystemUtils.UsingConsoleInputMode)
         {
            NavManager.Instance.FocusWidgetForward(WidgetName);
         }
      }
      
      override public function Hide(param1:Object = null) : void
      {
         super.Hide(param1);
         this.mcSocialMediaPanel.OnMainHide(param1);
      }
      
      override public function HandleRequestHide(param1:Object) : Object
      {
         if(this.mcSocialMediaPanel)
         {
            this.mcSocialMediaPanel.CloseReactionPopUps();
         }
         return super.HandleRequestHide(param1);
      }
      
      protected function OnPanelClose(param1:GenericEvent) : void
      {
         CommunicationManager.SendUIMessage("Hide" + WidgetName,null);
         if(SystemUtils.UsingConsoleInputMode)
         {
            NavManager.Instance.FocusBack();
         }
      }
      
      protected function HandleUpdateSocialMedia(param1:SocialMediaDialog) : void
      {
         if(!param1 || param1.sim_id != GameplayStateData.ActiveSimId)
         {
            return;
         }
         this.mcSocialMediaPanel.UpdateData(param1);
      }
      
      override public function Enter(param1:EnterParams = null) : IInputFocusable
      {
         return this.mcSocialMediaPanel.Enter(param1);
      }
      
      override public function Exit() : void
      {
         this.mcSocialMediaPanel.Exit();
      }
   }
}

