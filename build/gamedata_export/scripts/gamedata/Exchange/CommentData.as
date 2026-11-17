package gamedata.Exchange
{
   import olympus.core.OlympusObject;
   
   public class CommentData extends OlympusObject
   {
      
      public var uuid:String;
      
      public var author_id:String;
      
      public var author_persona:String;
      
      public var message:String;
      
      public var timestamp:String;
      
      public var mbAllowEdit:Boolean;
      
      public function CommentData(param1:Object = null)
      {
         super(param1);
      }
   }
}

