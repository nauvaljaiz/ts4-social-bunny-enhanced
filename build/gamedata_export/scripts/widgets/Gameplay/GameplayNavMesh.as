package widgets.Gameplay
{
   import olympus.gamepad.NavDirection;
   import olympus.gamepad.NavMesh;
   
   public class GameplayNavMesh extends NavMesh
   {
      
      protected static var instance:GameplayNavMesh;
      
      public function GameplayNavMesh()
      {
         super();
         CreateNodes(new <String>["InteractionQueue","SimInfoTray","SimHub","SimSelector","GameTray","RelInspector","SituationDisplay","Notifications"]);
         GetNode("InteractionQueue").AddConnection(GetNode("SituationDisplay"),NavDirection.UP);
         GetNode("SimHub").AddConnection(GetNode("InteractionQueue"),NavDirection.LEFT);
         GetNode("RelInspector").AddHorizontalPairing(GetNode("GameTray"));
         GetNode("SituationDisplay").AddHorizontalPairing(GetNode("RelInspector"));
         GetNode("SituationDisplay").AddHorizontalPairing(GetNode("GameTray"));
         GetNode("SituationDisplay").AddVerticalPairing(GetNode("SimHub"));
         GetNode("SimSelector").AddConnection(GetNode("SimHub"),NavDirection.UP);
         GetNode("GameTray").AddConnection(GetNode("SimHub"),NavDirection.LEFT);
         GetNode("GameTray").AddDynamicPairing(GetNode("Notifications"));
         GetNode("Notifications").AddDynamicPairing(GetNode("SimInfoTray"));
         GetNode("SimHub").AddDynamicPairing(GetNode("GameTray"));
         GetNode("SimInfoTray").AddDynamicConnection(GetNode("GameTray"));
         GetNode("GameTray").AddConnection(GetNode("SimInfoTray"),NavDirection.DOWN);
         GetNode("SimInfoTray").AddDynamicConnection(GetNode("SimSelector"));
         GetNode("SimSelector").AddConnection(GetNode("SimInfoTray"),NavDirection.RIGHT);
         GetNode("SimSelector").AddConnection(GetNode("SimInfoTray"),NavDirection.LEFT);
         GetNode("InteractionQueue").AddDynamicConnection(GetNode("SimHub"));
         GetNode("InteractionQueue").AddDynamicConnection(GetNode("SimInfoTray"));
         GetNode("SimInfoTray").AddDynamicConnection(GetNode("InteractionQueue"));
         GetNode("SimHub").AddConnection(GetNode("SimInfoTray"),NavDirection.DOWN);
         GetNode("SimInfoTray").AddDynamicConnection(GetNode("SimHub"));
         GetNode("SimInfoTray").AddDynamicConnection(GetNode("RelInspector"));
         GetNode("RelInspector").AddConnection(GetNode("SimInfoTray"),NavDirection.DOWN);
         GetNode("SimHub").AddDynamicPairing(GetNode("RelInspector"));
         GetNode("GameTray").AddDynamicConnection(GetNode("SimSelector"));
      }
      
      public static function get Instance() : GameplayNavMesh
      {
         if(instance == null)
         {
            instance = new GameplayNavMesh();
         }
         return instance;
      }
   }
}

