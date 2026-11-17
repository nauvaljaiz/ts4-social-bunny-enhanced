package widgets.BuildBuy.gamepad
{
   import olympus.gamepad.NavDirection;
   import olympus.gamepad.NavMesh;
   
   public class BuildBuyNavMesh extends NavMesh
   {
      
      protected static var instance:BuildBuyNavMesh;
      
      public function BuildBuyNavMesh()
      {
         super();
         CreateNodes(new <String>["BuildBuyVenueConfiguration","BuildBuyInspector","GameTray","BuildBuyNavigation","Notifications"]);
         GetNode("BuildBuyVenueConfiguration").AddHorizontalPairing(GetNode("BuildBuyInspector"));
         GetNode("BuildBuyVenueConfiguration").AddVerticalPairing(GetNode("BuildBuyNavigation"));
         GetNode("BuildBuyInspector").AddHorizontalPairing(GetNode("GameTray"));
         GetNode("BuildBuyInspector").AddConnection(GetNode("BuildBuyNavigation"),NavDirection.DOWN);
         GetNode("GameTray").AddConnection(GetNode("BuildBuyNavigation"),NavDirection.DOWN);
         GetNode("GameTray").AddDynamicPairing(GetNode("Notifications"));
         GetNode("Notifications").AddDynamicPairing(GetNode("BuildBuyNavigation"));
         GetNode("BuildBuyNavigation").AddConnection(GetNode("GameTray"),NavDirection.RIGHT);
         GetNode("BuildBuyNavigation").AddDynamicConnection(GetNode("GameTray"));
         GetNode("BuildBuyNavigation").AddDynamicConnection(GetNode("BuildBuyInspector"));
      }
      
      public static function get Instance() : BuildBuyNavMesh
      {
         if(instance == null)
         {
            instance = new BuildBuyNavMesh();
         }
         return instance;
      }
   }
}

