package olympus.dialog
{
   public interface IDialogInput
   {
      
      function get inputType() : int;
      
      function get name() : String;
      
      function get value() : *;
      
      function get fieldTitle() : String;
      
      function get inline() : Boolean;
      
      function set value(param1:*) : void;
   }
}

