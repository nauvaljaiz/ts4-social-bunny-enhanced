package olympus.constants
{
   public class PageDataRequestStates
   {
      
      public static const DATA_REQUEST_STATUS_PENDING:int = 0;
      
      public static const DATA_REQUEST_STATUS_IN_PROGRESS:int = 1;
      
      public static const DATA_REQUEST_STATUS_COMPLETE:int = 2;
      
      public static const DATA_REQUEST_STATUS_RETRY:int = 3;
      
      public static const DATA_REQUEST_STATUS_NOT_INITIALIZED:* = 4;
      
      public function PageDataRequestStates()
      {
         super();
      }
   }
}

