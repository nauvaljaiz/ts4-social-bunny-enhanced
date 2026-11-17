package olympus.events
{
   import flash.events.Event;
   
   public class AssetLoaderEvent extends Event
   {
      
      public static const BEGIN:String = "assetLoadBegin";
      
      public static const COMPLETE:String = "assetLoadComplete";
      
      public static const FAIL:String = "assetLoadFail";
      
      public static const CANCELLED:String = "assetLoadCancelled";
      
      public function AssetLoaderEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      override public function clone() : Event
      {
         return new AssetLoaderEvent(type,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("AssetLoaderEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}

