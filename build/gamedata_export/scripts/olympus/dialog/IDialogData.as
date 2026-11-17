package olympus.dialog
{
   import gamedata.shared.ResourceKey;
   import olympus.objects.IconInfo;
   
   public interface IDialogData
   {
      
      function get dialogType() : int;
      
      function set dialogType(param1:int) : void;
      
      function get dialogStyle() : int;
      
      function get footerType() : int;
      
      function get dialogBackgroundStyle() : int;
      
      function get inputs() : Vector.<IDialogInput>;
      
      function get actions() : Vector.<IDialogAction>;
      
      function get promptText() : String;
      
      function get cancellationAction() : IDialogAction;
      
      function get timeout() : Number;
      
      function get title() : String;
      
      function get options() : uint;
      
      function get icon() : String;
      
      function get targetSimId() : String;
      
      function get ownerSimId() : String;
      
      function get iconSimId() : String;
      
      function get iconInfos() : Vector.<IconInfo>;
      
      function get additionalTexts() : Vector.<String>;
      
      function get dialog_id() : String;
      
      function set dialog_id(param1:String) : void;
      
      function get backgroundImage() : ResourceKey;
   }
}

