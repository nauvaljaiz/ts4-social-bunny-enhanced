package olympus.extensions
{
   import flash.display.DisplayObject;
   import olympus.errors.Assert;
   import olympus.interfaces.IExtendable;
   import olympus.interfaces.IExtension;
   import olympus.io.CommunicationManager;
   import olympus.utils.SystemUtils;
   
   public class InputModeVisibilityExtension implements IExtension
   {
      
      protected var mTarget:DisplayObject;
      
      protected var mbShowForMouseKeyboard:Boolean;
      
      protected var mbShowForController:Boolean;
      
      protected var mbRequestedVisible:Boolean = true;
      
      protected var mbHideForDialog:Boolean = false;
      
      protected var mIsModalVisible:Boolean = false;
      
      protected var mbHideForPieMenu:Boolean = false;
      
      protected var mIsPieMenuVisible:Boolean = false;
      
      protected var mIsShowControlsOverlayOption:Boolean = false;
      
      protected var mbHideForShowControlsOverlayOption:* = false;
      
      public function InputModeVisibilityExtension()
      {
         super();
      }
      
      public static function ShowForController(param1:IExtendable) : void
      {
         var _loc2_:InputModeVisibilityExtension = Get(param1);
         _loc2_.mbShowForController = true;
         _loc2_.RefreshVisibility();
      }
      
      public static function ShowForMouseKeyboard(param1:IExtendable) : void
      {
         var _loc2_:InputModeVisibilityExtension = Get(param1);
         _loc2_.mbShowForMouseKeyboard = true;
         _loc2_.RefreshVisibility();
      }
      
      public static function HideForShowControlsOverlayOption(param1:IExtendable) : void
      {
         var _loc2_:InputModeVisibilityExtension = Get(param1);
         _loc2_.mbHideForShowControlsOverlayOption = true;
         _loc2_.mIsShowControlsOverlayOption = CommunicationManager.CallGameService("OptionsGetValue",{"name":"ShowControlsOverlay"});
         CommunicationExtension.Get(param1).SetMessageListener("OptionChangedShowControlsOverlay",_loc2_.HandleOptionChangedShowControlsOverlay);
         _loc2_.RefreshVisibility();
      }
      
      public static function SetVisible(param1:IExtendable, param2:Boolean) : void
      {
         var _loc3_:InputModeVisibilityExtension = Get(param1);
         _loc3_.mbRequestedVisible = param2;
         _loc3_.RefreshVisibility();
      }
      
      public static function IsVisible(param1:IExtendable) : Boolean
      {
         var _loc2_:InputModeVisibilityExtension = Get(param1,false);
         return Boolean(_loc2_) && _loc2_.mbRequestedVisible;
      }
      
      public static function HideForDialog(param1:IExtendable, param2:Boolean) : void
      {
         var _loc3_:InputModeVisibilityExtension = Get(param1);
         _loc3_.mbHideForDialog = param2;
         _loc3_.RefreshVisibility();
         if(param2)
         {
            CommunicationExtension.Get(param1).SetMessageListener("SetModalVisible",_loc3_.HandleSetModalVisible);
         }
         else
         {
            CommunicationExtension.Get(param1).ClearMessageListener("SetModalVisible");
         }
      }
      
      public static function HideForPieMenu(param1:IExtendable, param2:Boolean) : void
      {
         var _loc3_:InputModeVisibilityExtension = Get(param1);
         _loc3_.mbHideForPieMenu = param2;
         _loc3_.RefreshVisibility();
         if(param2)
         {
            CommunicationExtension.Get(param1).SetMessageListener("ShowPieMenu",_loc3_.HandleShowPieMenu);
            CommunicationExtension.Get(param1).SetMessageListener("HidePieMenu",_loc3_.HandleHidePieMenu);
         }
         else
         {
            CommunicationExtension.Get(param1).ClearMessageListener("ShowPieMenu");
            CommunicationExtension.Get(param1).ClearMessageListener("HidePieMenu");
         }
      }
      
      public static function Get(param1:IExtendable, param2:Boolean = true) : InputModeVisibilityExtension
      {
         return param1.GetExtension(InputModeVisibilityExtension,param2) as InputModeVisibilityExtension;
      }
      
      protected function HandleShowPieMenu() : void
      {
         this.mIsPieMenuVisible = true;
         this.RefreshVisibility();
      }
      
      protected function HandleHidePieMenu() : void
      {
         this.mIsPieMenuVisible = false;
         this.RefreshVisibility();
      }
      
      protected function HandleSetModalVisible(param1:Boolean) : void
      {
         if(this.mIsModalVisible != param1)
         {
            this.mIsModalVisible = param1;
            this.RefreshVisibility();
         }
      }
      
      protected function HandleOptionChangedShowControlsOverlay(param1:Boolean) : void
      {
         this.mIsShowControlsOverlayOption = param1;
         this.RefreshVisibility();
      }
      
      public function Extend(param1:IExtendable) : void
      {
         this.mTarget = param1 as DisplayObject;
         if(!this.mTarget)
         {
            Assert.Throw("InputModeVisibilityExtension must be provided a DisplayObject to extend");
            return;
         }
         this.mbRequestedVisible = this.mTarget.visible;
         this.RefreshVisibility();
         if(SystemUtils.UsingConsoleInputMode)
         {
            CommunicationExtension.Get(param1).SetMessageListener("UsingControllerToggled",this.RefreshVisibility);
         }
      }
      
      public function RefreshVisibility() : void
      {
         var _loc1_:Boolean = SystemUtils.UsingController ? this.mbShowForController : this.mbShowForMouseKeyboard;
         if(this.mbHideForDialog)
         {
            _loc1_ &&= !this.mIsModalVisible;
         }
         if(this.mbHideForPieMenu)
         {
            _loc1_ &&= !this.mIsPieMenuVisible;
         }
         if(this.mbHideForShowControlsOverlayOption)
         {
            _loc1_ &&= this.mIsShowControlsOverlayOption;
         }
         this.mTarget.visible = _loc1_ && this.mbRequestedVisible;
      }
   }
}

