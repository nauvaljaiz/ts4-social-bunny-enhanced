package olympus.dialog
{
   import olympus.objects.IconInfo;
   
   public interface IDialogAction
   {
      
      function Execute(param1:IDialogData) : void;
      
      function get label() : String;
      
      function get isEnabled() : Boolean;
      
      function get tooltipText() : String;
      
      function get audio() : String;
      
      function get subLabel() : String;
      
      function get iconInfo() : IconInfo;
   }
}

