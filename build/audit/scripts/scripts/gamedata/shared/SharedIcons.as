package gamedata.shared
{
   import olympus.io.CommunicationManager;
   
   public class SharedIcons
   {
      
      protected static var sPackIcons:Array;
      
      public static const SIZE_32:String = "icon32";
      
      public static const SIZE_64:String = "icon64";
      
      public static const SIZE_128:String = "icon128";
      
      public static const ICON_WARNING:String = "0x2fbc69321e0759e7";
      
      public function SharedIcons()
      {
         super();
      }
      
      public static function GetPackIcon(param1:int, param2:String) : String
      {
         if(!sPackIcons)
         {
            LoadPackIcons();
         }
         if(Boolean(sPackIcons) && Boolean(sPackIcons[param1]))
         {
            return sPackIcons[param1][param2];
         }
         return null;
      }
      
      protected static function LoadPackIcons() : void
      {
         var _loc2_:Object = null;
         var _loc1_:Array = CommunicationManager.CallGameService("GetPackIcons") as Array;
         if(_loc1_)
         {
            sPackIcons = new Array();
            for each(_loc2_ in _loc1_)
            {
               sPackIcons[_loc2_.packId] = _loc2_;
            }
         }
      }
   }
}

