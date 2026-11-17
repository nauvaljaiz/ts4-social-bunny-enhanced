package gamedata.Gameplay.PieMenu
{
   import flash.geom.Point;
   
   public class PieMenuButtonData
   {
      
      protected static var mbHasSocialFrontPage:Boolean;
      
      public var nubPosition:Point;
      
      public var data:Object;
      
      public var index:int;
      
      public var count:int;
      
      public var globalPosition:Point;
      
      public var simFirstName:String;
      
      public var mbIsDebugMode:Boolean;
      
      public function PieMenuButtonData()
      {
         super();
      }
      
      public static function set HasSocialFrontPage(param1:Boolean) : void
      {
         mbHasSocialFrontPage = param1;
      }
      
      public static function get HasSocialFrontPage() : Boolean
      {
         return mbHasSocialFrontPage;
      }
      
      public function Initialize(param1:Point, param2:Object, param3:int, param4:int) : void
      {
         this.nubPosition = param1;
         this.data = param2;
         this.index = param3;
         this.count = param4;
      }
   }
}

