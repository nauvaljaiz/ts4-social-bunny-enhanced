package olympus.core
{
   import olympus.io.CommunicationManager;
   
   public class ThemeManager
   {
      
      protected static var sInstance:ThemeManager;
      
      protected var mCurrentTheme:String = "default";
      
      public function ThemeManager()
      {
         super();
         sInstance = this;
      }
      
      public static function get CurrentThemeName() : String
      {
         return sInstance.mCurrentTheme;
      }
      
      public function Initialize(param1:UIManager) : void
      {
         CommunicationManager.AddMessageListener("SetTheme",this.HandleSetTheme,param1);
      }
      
      protected function HandleSetTheme(param1:Object) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:String = param1.themeName;
         if(_loc2_ != null)
         {
            this.mCurrentTheme = _loc2_;
         }
      }
   }
}

