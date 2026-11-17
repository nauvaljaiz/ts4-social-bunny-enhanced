package olympus.events
{
   import flash.events.Event;
   
   public class DataFeedEvent extends Event
   {
      
      public static const UPDATE:String = "feedUpdate";
      
      public static const ADD:String = "feedAdd";
      
      public static const ADD_TO_FRONT:String = "feedAddToFront";
      
      public static const REMOVE:String = "feedRemove";
      
      public static const REMOVE_ALL:String = "feedRemoveAll";
      
      public static const SORT_FILTER:String = "feedSortFilter";
      
      public var mIndicesArray:Array;
      
      public var mDataArray:Array;
      
      public var mUserDataArray:Array;
      
      public var mbResetPosition:Boolean;
      
      public function DataFeedEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
         this.mIndicesArray = new Array();
         this.mDataArray = new Array();
         this.mUserDataArray = new Array();
         this.mbResetPosition = true;
      }
   }
}

