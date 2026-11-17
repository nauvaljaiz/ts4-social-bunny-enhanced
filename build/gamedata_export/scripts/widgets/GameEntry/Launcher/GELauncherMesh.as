package widgets.GameEntry.Launcher
{
   import olympus.gamepad.NavMesh;
   import olympus.math.Geometry;
   
   public class GELauncherMesh extends NavMesh
   {
      
      protected static var instance:GELauncherMesh;
      
      public function GELauncherMesh()
      {
         super();
         CreateNodes(new <String>["GameEntryLauncher","Notifications"]);
         GetNode("GameEntryLauncher").AddAnglePairing(GetNode("Notifications"),Geometry.ToRadians(-45));
      }
      
      public static function get Instance() : GELauncherMesh
      {
         if(instance == null)
         {
            instance = new GELauncherMesh();
         }
         return instance;
      }
   }
}

