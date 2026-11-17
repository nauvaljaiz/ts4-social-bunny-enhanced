package olympus.core
{
   import olympus.constants.DialogTypes;
   import olympus.io.CommunicationManager;
   import olympus.localization.Keys;
   
   public class UIScaleManager
   {
      
      protected static var sInstance:UIScaleManager;
      
      protected static const UI_SCALE_MANAGER_NAME:String = "UIScaleManager";
      
      protected var mbShowingResetScaleDialog:Boolean = false;
      
      public function UIScaleManager()
      {
         super();
         sInstance = this;
         CommunicationManager.CallGameService("UpdateUIScale");
      }
      
      public static function getInstance() : UIScaleManager
      {
         return sInstance;
      }
      
      public static function AddListeners(param1:CommunicationManager) : void
      {
         param1.AddMessageListener("UIScaleWarning",HandleUIScaleWarning,UI_SCALE_MANAGER_NAME);
      }
      
      protected static function HandleUIScaleWarning(param1:Object) : void
      {
         var _loc2_:Boolean = Boolean(param1) && param1.hasOwnProperty("popup") && Boolean(param1["popup"]);
         var _loc3_:Boolean = Boolean(param1) && param1.hasOwnProperty("clearUseOSDPI") && Boolean(param1["clearUseOSDPI"]);
         sInstance.ShowResetUIScalingDialog(_loc2_,_loc3_);
      }
      
      protected function ShowResetUIScalingDialog(param1:Boolean, param2:Boolean) : void
      {
         if(this.mbShowingResetScaleDialog)
         {
            return;
         }
         this.mbShowingResetScaleDialog = true;
         if(param1)
         {
            this.CreateResetUIScalingPopupDialog();
         }
         else if(param2)
         {
            this.CreateResetUIClearOSDPIScalingDialog();
         }
         else
         {
            this.CreateResetUIScalingDialog(this.ResetUIScalingDialogToDefault,this.ResetUIScalingDialogCancel);
         }
      }
      
      public function CreateResetUIClearOSDPIScalingDialog() : void
      {
         CommunicationManager.SendUIMessage("ShowDialog",{
            "type":DialogTypes.TWO_BUTTON,
            "title":Keys.DIALOG_UISCALING_CLEAR_OSDPI_TITLE.toString(),
            "description":Keys.DIALOG_UISCALING_CLEAR_OSDPI_DESCRIPTION.toString(),
            "optionOneText":Keys.DIALOG_UISCALING_OPTION1.toString(),
            "optionOneCallback":this.ResetUIScalingDialogCancel,
            "optionTwoText":Keys.DIALOG_UISCALING_CLEAR_OSDPI_OPTION2.toString(),
            "optionTwoCallback":this.ResetUIScalingAndOSDialogToDefault,
            "closeText":Keys.GENERIC_CANCEL.toString(),
            "closeCallback":this.ResetUIScalingDialogCancel
         });
      }
      
      public function CreateResetUIScalingDialog(param1:Function = null, param2:Function = null) : void
      {
         CommunicationManager.SendUIMessage("ShowDialog",{
            "type":DialogTypes.TWO_BUTTON,
            "title":Keys.DIALOG_UISCALING_TITLE.toString(),
            "description":Keys.DIALOG_UISCALING_DESCRIPTION.toString(),
            "optionOneText":Keys.DIALOG_UISCALING_OPTION1.toString(),
            "optionOneCallback":(Boolean(param2) ? param2 : this.ResetUIScalingDialogCancel),
            "optionTwoText":Keys.DIALOG_UISCALING_OPTION2.toString(),
            "optionTwoCallback":(Boolean(param1) ? param1 : this.ResetUIScalingDialogToDefault),
            "closeText":Keys.GENERIC_CANCEL.toString(),
            "closeCallback":(Boolean(param2) ? param2 : this.ResetUIScalingDialogCancel)
         });
      }
      
      public function CreateResetUIScalingPopupDialog() : void
      {
         CommunicationManager.SendUIMessage("ShowDialog",{
            "type":DialogTypes.YES_NO,
            "title":Keys.DIALOG_UISCALING_TITLE.toString(),
            "description":Keys.DIALOG_UISCALING_DESCRIPTION1.toString(),
            "optionOneText":Keys.GENERIC_YES.toString(),
            "optionOneCallback":this.ResetUIScalingDialogToDefault,
            "optionTwoText":Keys.GENERIC_NO.toString(),
            "optionTwoCallback":this.ResetUIScalingDialogCancel,
            "closeText":Keys.GENERIC_NO.toString(),
            "closeCallback":this.ResetUIScalingDialogCancel
         });
      }
      
      protected function ResetUIScalingDialogToDefault() : void
      {
         var _loc1_:Number = (CommunicationManager.CallGameService("OptionsGetDefaultValue",{"name":"UiScale"}) as Number) / 100;
         CommunicationManager.CallGameService("SetUIScale",{
            "scale":1 / _loc1_,
            "save":true
         });
         this.mbShowingResetScaleDialog = false;
         CommunicationManager.SendUIMessage("UIScaleReset");
      }
      
      protected function ResetUIScalingAndOSDialogToDefault() : void
      {
         this.ResetUIScalingDialogToDefault();
         CommunicationManager.CallGameService("SetUseOSDPIScale",{
            "useOSDPI":false,
            "save":true
         });
      }
      
      protected function ResetUIScalingDialogCancel() : void
      {
         this.mbShowingResetScaleDialog = false;
      }
   }
}

