package olympus.utils
{
   import flash.system.Capabilities;
   import olympus.io.CommunicationManager;
   
   public class SystemUtils
   {
      
      protected static var sGraphicsAPI:String;
      
      protected static var sDistributionPlatform:int;
      
      public static const DISTRIBUTION_PLATFORM_ORIGIN:int = 0;
      
      public static const DISTRIBUTION_PLATFORM_STEAM:int = 1;
      
      public static const DISTRIBUTION_PLATFORM_PLAYSTATIONSTORE:int = 3;
      
      public static const DISTRIBUTION_PLATFORM_XBOXMARKETPLACE:int = 4;
      
      protected static var sbUsingController:Boolean = false;
      
      protected static var sbUsingMouseKeyboard:Boolean = false;
      
      protected static var sbSwapJPControls:Boolean = false;
      
      protected static var sbRazerEnabled:Boolean = false;
      
      protected static var sbPCRazerEnabled:Boolean = false;
      
      protected static var sUIScale:Number = -1;
      
      protected static var sUIMonitorDPIScale:Number = -1;
      
      protected static var sVirtualCursorScale:Number = -1;
      
      public function SystemUtils()
      {
         super();
      }
      
      public static function get IsMac() : Boolean
      {
         return Capabilities.os.indexOf("Mac") != -1;
      }
      
      public static function get IsWindows() : Boolean
      {
         return Capabilities.os.indexOf("Windows") != -1;
      }
      
      public static function get IsXB1() : Boolean
      {
         return Capabilities.os.indexOf("Durango") != -1;
      }
      
      public static function get IsPS4() : Boolean
      {
         return Capabilities.os.indexOf("Orbis") != -1;
      }
      
      public static function get IsConsole() : Boolean
      {
         return IsXB1 || IsPS4;
      }
      
      public static function get IsPC() : Boolean
      {
         return IsMac || IsWindows;
      }
      
      public static function set UsingController(param1:Boolean) : void
      {
         sbUsingController = param1;
      }
      
      public static function get UsingController() : Boolean
      {
         return sbUsingController;
      }
      
      public static function set RazerEnabledPC(param1:Boolean) : void
      {
         sbPCRazerEnabled = param1;
      }
      
      public static function get RazerEnabledPC() : Boolean
      {
         return sbPCRazerEnabled;
      }
      
      public static function set UsingMouseKeyboard(param1:Boolean) : void
      {
         sbUsingMouseKeyboard = param1;
      }
      
      public static function get UsingMouseKeyboard() : Boolean
      {
         return sbUsingMouseKeyboard;
      }
      
      public static function get UsingConsoleInputMode() : Boolean
      {
         return sbUsingController || sbUsingMouseKeyboard;
      }
      
      public static function set SwapJPControls(param1:Boolean) : void
      {
         sbSwapJPControls = param1;
      }
      
      public static function get SwapJPControls() : Boolean
      {
         return sbSwapJPControls;
      }
      
      public static function set UsingGraphicsAPI(param1:String) : void
      {
         sGraphicsAPI = param1;
      }
      
      public static function get UsingD3D9() : Boolean
      {
         return sGraphicsAPI == "D3D";
      }
      
      public static function get UsingD3D11() : Boolean
      {
         return sGraphicsAPI == "DX11";
      }
      
      public static function get UsingD3D() : Boolean
      {
         return UsingD3D9 || UsingD3D11;
      }
      
      public static function get UsingOGL() : Boolean
      {
         return sGraphicsAPI == "OGL";
      }
      
      public static function get UsingMETAL() : Boolean
      {
         return sGraphicsAPI == "METAL";
      }
      
      public static function get UsingGNM() : Boolean
      {
         return sGraphicsAPI == "GNM";
      }
      
      public static function set DistributionPlatform(param1:int) : void
      {
         sDistributionPlatform = param1;
      }
      
      public static function get DistributionPlatform() : int
      {
         return sDistributionPlatform;
      }
      
      public static function SetUIScale(param1:Number) : void
      {
         sUIScale = param1;
      }
      
      public static function get UIScale() : Number
      {
         if(sUIScale < 0)
         {
            CommunicationManager.CallGameService("UpdateUIScale");
         }
         if(sUIScale < 0)
         {
            return -1;
         }
         return sUIScale;
      }
      
      public static function set UIMonitorDPIScale(param1:Number) : void
      {
         sUIMonitorDPIScale = param1;
      }
      
      public static function get UIMonitorDPIScale() : Number
      {
         return sUIMonitorDPIScale;
      }
      
      public static function set VirtualCursorScale(param1:Number) : void
      {
         sVirtualCursorScale = param1;
      }
      
      public static function get VirtualCursorScale() : Number
      {
         return sVirtualCursorScale;
      }
   }
}

