package widgets.Dialog.data
{
   import gamedata.shared.ResourceKey;
   import olympus.dialog.IDialogAction;
   import olympus.dialog.IDialogData;
   import olympus.dialog.IDialogInput;
   import olympus.objects.IconInfo;
   
   public class LocalRequestData implements IDialogData
   {
      
      protected var mDialogType:int;
      
      protected var mInputs:Vector.<IDialogInput>;
      
      protected var mActions:Vector.<IDialogAction>;
      
      protected var mPrompt:String = "";
      
      protected var mCancellationAction:IDialogAction;
      
      protected var mTimeout:Number = 0;
      
      protected var mTitle:String = "";
      
      protected var mOptions:uint = 0;
      
      protected var mDialogId:String = null;
      
      protected var mIcon:String = "";
      
      protected var mIconSimId:String = null;
      
      protected var mDialogStyle:int = 0;
      
      protected var mDialogBackgroundStyle:int = 0;
      
      protected var mFooterType:int = 0;
      
      public function LocalRequestData()
      {
         super();
         this.mInputs = new Vector.<IDialogInput>();
         this.mActions = new Vector.<IDialogAction>();
      }
      
      public function set promptText(param1:String) : void
      {
         this.mPrompt = param1 || "";
      }
      
      public function get title() : String
      {
         return this.mTitle;
      }
      
      public function set title(param1:String) : void
      {
         this.mTitle = param1 || "";
      }
      
      public function get dialogType() : int
      {
         return this.mDialogType;
      }
      
      public function set dialogType(param1:int) : void
      {
         this.mDialogType = param1;
      }
      
      public function set dialogStyle(param1:int) : void
      {
         this.mDialogStyle = param1;
      }
      
      public function get dialogStyle() : int
      {
         return this.mDialogStyle;
      }
      
      public function get footerType() : int
      {
         return this.mFooterType;
      }
      
      public function set dialogBackgroundStyle(param1:int) : void
      {
         this.mDialogBackgroundStyle = param1;
      }
      
      public function get dialogBackgroundStyle() : int
      {
         return this.mDialogBackgroundStyle;
      }
      
      public function get inputs() : Vector.<IDialogInput>
      {
         return this.mInputs;
      }
      
      public function get actions() : Vector.<IDialogAction>
      {
         return this.mActions;
      }
      
      public function get promptText() : String
      {
         return this.mPrompt;
      }
      
      public function get cancellationAction() : IDialogAction
      {
         return this.mCancellationAction;
      }
      
      public function set cancellationAction(param1:IDialogAction) : void
      {
         this.mCancellationAction = param1;
      }
      
      public function get timeout() : Number
      {
         return this.mTimeout;
      }
      
      public function get options() : uint
      {
         return this.mOptions;
      }
      
      public function set options(param1:uint) : void
      {
         this.mOptions = param1;
      }
      
      public function get icon() : String
      {
         return this.mIcon;
      }
      
      public function set icon(param1:String) : void
      {
         this.mIcon = param1;
      }
      
      public function get iconInfos() : Vector.<IconInfo>
      {
         return null;
      }
      
      public function get additionalTexts() : Vector.<String>
      {
         return new Vector.<String>();
      }
      
      public function get targetSimId() : String
      {
         return null;
      }
      
      public function get ownerSimId() : String
      {
         return null;
      }
      
      public function get iconSimId() : String
      {
         return this.mIconSimId;
      }
      
      public function set iconSimId(param1:String) : void
      {
         this.mIconSimId = param1;
      }
      
      public function get dialog_id() : String
      {
         return this.mDialogId;
      }
      
      public function set dialog_id(param1:String) : void
      {
         this.mDialogId = param1;
      }
      
      public function get backgroundImage() : ResourceKey
      {
         return null;
      }
   }
}

