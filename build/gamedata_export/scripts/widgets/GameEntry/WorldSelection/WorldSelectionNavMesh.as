package widgets.GameEntry.WorldSelection
{
   import olympus.gamepad.NavMesh;
   import olympus.math.Geometry;
   
   public class WorldSelectionNavMesh extends NavMesh
   {
      
      protected static var instance:WorldSelectionNavMesh;
      
      public function WorldSelectionNavMesh()
      {
         super();
         CreateNodes(new <String>["GameTray","GameEntryWorldSelection","GameEntryDock","Notifications","GameEntryNhdBGOasisSprings","GameEntryNhdBGWillowCreek","GameEntryNhdGP01Camping","GameEntryNhdBGPerfTest","GameEntryNhdBGTestWorld","GameEntryNhdEP01Retail","GameEntryNhdBGEngagement","GameEntryNhdGP02TestWorld","GameEntryNhdEP02NorthEurope","GameEntryNhdEP03CityLife","GameEntryNhdGP04Vampire","GameEntryNhdEP04PetWorld","GameEntryNhdGP06Jungle","GameEntryNhdEP06FameWorld","GameEntryNhdGP07StrangeTown","GameEntryNhdEP07IslandLiving","GameEntryNhdGP08MagicWorld","GameEntryNhdEP08University","GameEntryNhdEP09EcoLiving","GameEntryNhdGP09Pangolin","GameEntryNhdEP10Summit","GameEntryNhdEP11Cottage","GameEntryNhdGP11Weddings","GameEntryNhdGP12WolfTown","GameEntryNhdEP12HighSchool","GameEntryNhdEP13BayArea","GameEntryNhdEP14Ranch","GameEntryNhdEP15MultiUnitLiving","GameEntryNhdEP16Rendezvous","GameEntryNhdEP17Opera","GameEntryNhdEP18Obsession","GameEntryNhdEP19Grove","GameEntryNhdEP20Getaway","GameEntryNhdEP21Gold"]);
         GetNode("GameTray").AddVerticalPairing(GetNode("GameEntryNhdBGOasisSprings"));
         GetNode("GameTray").AddVerticalPairing(GetNode("GameEntryNhdBGWillowCreek"));
         GetNode("GameTray").AddVerticalPairing(GetNode("GameEntryNhdGP01Camping"));
         GetNode("GameTray").AddVerticalPairing(GetNode("GameEntryNhdBGPerfTest"));
         GetNode("GameTray").AddVerticalPairing(GetNode("GameEntryNhdBGTestWorld"));
         GetNode("GameTray").AddVerticalPairing(GetNode("GameEntryNhdEP01Retail"));
         GetNode("GameTray").AddVerticalPairing(GetNode("GameEntryNhdBGEngagement"));
         GetNode("GameTray").AddVerticalPairing(GetNode("GameEntryNhdGP02TestWorld"));
         GetNode("GameTray").AddVerticalPairing(GetNode("GameEntryNhdEP02NorthEurope"));
         GetNode("GameTray").AddVerticalPairing(GetNode("GameEntryNhdEP03CityLife"));
         GetNode("GameTray").AddVerticalPairing(GetNode("GameEntryNhdGP04Vampire"));
         GetNode("GameTray").AddVerticalPairing(GetNode("GameEntryNhdEP04PetWorld"));
         GetNode("GameTray").AddVerticalPairing(GetNode("GameEntryNhdGP06Jungle"));
         GetNode("GameTray").AddVerticalPairing(GetNode("GameEntryNhdEP06FameWorld"));
         GetNode("GameTray").AddVerticalPairing(GetNode("GameEntryNhdGP07StrangeTown"));
         GetNode("GameTray").AddVerticalPairing(GetNode("GameEntryNhdEP07IslandLiving"));
         GetNode("GameTray").AddVerticalPairing(GetNode("GameEntryNhdGP08MagicWorld"));
         GetNode("GameTray").AddVerticalPairing(GetNode("GameEntryNhdEP08University"));
         GetNode("GameTray").AddVerticalPairing(GetNode("GameEntryNhdEP09EcoLiving"));
         GetNode("GameTray").AddVerticalPairing(GetNode("GameEntryNhdGP09Pangolin"));
         GetNode("GameTray").AddVerticalPairing(GetNode("GameEntryNhdEP10Summit"));
         GetNode("GameTray").AddVerticalPairing(GetNode("GameEntryNhdEP11Cottage"));
         GetNode("GameTray").AddVerticalPairing(GetNode("GameEntryNhdGP11Weddings"));
         GetNode("GameTray").AddVerticalPairing(GetNode("GameEntryNhdGP12WolfTown"));
         GetNode("GameTray").AddVerticalPairing(GetNode("GameEntryNhdEP12HighSchool"));
         GetNode("GameTray").AddVerticalPairing(GetNode("GameEntryNhdEP13BayArea"));
         GetNode("GameTray").AddVerticalPairing(GetNode("GameEntryNhdEP14Ranch"));
         GetNode("GameTray").AddVerticalPairing(GetNode("GameEntryNhdEP15MultiUnitLiving"));
         GetNode("GameTray").AddVerticalPairing(GetNode("GameEntryNhdEP16Rendezvous"));
         GetNode("GameTray").AddVerticalPairing(GetNode("GameEntryNhdEP17Opera"));
         GetNode("GameTray").AddVerticalPairing(GetNode("GameEntryNhdEP18Obsession"));
         GetNode("GameTray").AddVerticalPairing(GetNode("GameEntryNhdEP19Grove"));
         GetNode("GameTray").AddVerticalPairing(GetNode("GameEntryNhdEP20Getaway"));
         GetNode("GameTray").AddVerticalPairing(GetNode("GameEntryNhdEP21Gold"));
         GetNode("GameTray").AddAnglePairing(GetNode("Notifications"),Geometry.ToRadians(115));
         GetNode("GameEntryWorldSelection").AddHorizontalPairing(GetNode("GameTray"));
         GetNode("GameEntryWorldSelection").AddAnglePairing(GetNode("Notifications"),Geometry.ToRadians(-15));
         GetNode("GameEntryWorldSelection").AddVerticalPairing(GetNode("GameEntryNhdBGOasisSprings"));
         GetNode("GameEntryWorldSelection").AddVerticalPairing(GetNode("GameEntryNhdBGWillowCreek"));
         GetNode("GameEntryWorldSelection").AddVerticalPairing(GetNode("GameEntryNhdGP01Camping"));
         GetNode("GameEntryWorldSelection").AddVerticalPairing(GetNode("GameEntryNhdBGPerfTest"));
         GetNode("GameEntryWorldSelection").AddVerticalPairing(GetNode("GameEntryNhdBGTestWorld"));
         GetNode("GameEntryWorldSelection").AddVerticalPairing(GetNode("GameEntryNhdEP01Retail"));
         GetNode("GameEntryWorldSelection").AddVerticalPairing(GetNode("GameEntryNhdBGEngagement"));
         GetNode("GameEntryWorldSelection").AddVerticalPairing(GetNode("GameEntryNhdGP02TestWorld"));
         GetNode("GameEntryWorldSelection").AddVerticalPairing(GetNode("GameEntryNhdEP02NorthEurope"));
         GetNode("GameEntryWorldSelection").AddVerticalPairing(GetNode("GameEntryNhdEP03CityLife"));
         GetNode("GameEntryWorldSelection").AddVerticalPairing(GetNode("GameEntryNhdGP04Vampire"));
         GetNode("GameEntryWorldSelection").AddVerticalPairing(GetNode("GameEntryNhdEP04PetWorld"));
         GetNode("GameEntryWorldSelection").AddVerticalPairing(GetNode("GameEntryNhdGP06Jungle"));
         GetNode("GameEntryWorldSelection").AddVerticalPairing(GetNode("GameEntryNhdEP06FameWorld"));
         GetNode("GameEntryWorldSelection").AddVerticalPairing(GetNode("GameEntryNhdGP07StrangeTown"));
         GetNode("GameEntryWorldSelection").AddVerticalPairing(GetNode("GameEntryNhdEP07IslandLiving"));
         GetNode("GameEntryWorldSelection").AddVerticalPairing(GetNode("GameEntryNhdGP08MagicWorld"));
         GetNode("GameEntryWorldSelection").AddVerticalPairing(GetNode("GameEntryNhdEP08University"));
         GetNode("GameEntryWorldSelection").AddVerticalPairing(GetNode("GameEntryNhdEP09EcoLiving"));
         GetNode("GameEntryWorldSelection").AddVerticalPairing(GetNode("GameEntryNhdGP09Pangolin"));
         GetNode("GameEntryWorldSelection").AddVerticalPairing(GetNode("GameEntryNhdEP10Summit"));
         GetNode("GameEntryWorldSelection").AddVerticalPairing(GetNode("GameEntryNhdEP11Cottage"));
         GetNode("GameEntryWorldSelection").AddVerticalPairing(GetNode("GameEntryNhdGP11Weddings"));
         GetNode("GameEntryWorldSelection").AddVerticalPairing(GetNode("GameEntryNhdGP12WolfTown"));
         GetNode("GameEntryWorldSelection").AddVerticalPairing(GetNode("GameEntryNhdEP12HighSchool"));
         GetNode("GameEntryWorldSelection").AddVerticalPairing(GetNode("GameEntryNhdEP13BayArea"));
         GetNode("GameEntryWorldSelection").AddVerticalPairing(GetNode("GameEntryNhdEP14Ranch"));
         GetNode("GameEntryWorldSelection").AddVerticalPairing(GetNode("GameEntryNhdEP15MultiUnitLiving"));
         GetNode("GameEntryWorldSelection").AddVerticalPairing(GetNode("GameEntryNhdEP16Rendezvous"));
         GetNode("GameEntryWorldSelection").AddVerticalPairing(GetNode("GameEntryNhdEP17Opera"));
         GetNode("GameEntryWorldSelection").AddVerticalPairing(GetNode("GameEntryNhdEP18Obsession"));
         GetNode("GameEntryWorldSelection").AddVerticalPairing(GetNode("GameEntryNhdEP19Grove"));
         GetNode("GameEntryWorldSelection").AddVerticalPairing(GetNode("GameEntryNhdEP20Getaway"));
         GetNode("GameEntryWorldSelection").AddVerticalPairing(GetNode("GameEntryNhdEP21Gold"));
         GetNode("GameEntryNhdBGOasisSprings").AddVerticalPairing(GetNode("GameEntryDock"));
         GetNode("GameEntryNhdBGWillowCreek").AddVerticalPairing(GetNode("GameEntryDock"));
         GetNode("GameEntryNhdGP01Camping").AddVerticalPairing(GetNode("GameEntryDock"));
         GetNode("GameEntryNhdBGPerfTest").AddVerticalPairing(GetNode("GameEntryDock"));
         GetNode("GameEntryNhdBGTestWorld").AddVerticalPairing(GetNode("GameEntryDock"));
         GetNode("GameEntryNhdEP01Retail").AddVerticalPairing(GetNode("GameEntryDock"));
         GetNode("GameEntryNhdBGEngagement").AddVerticalPairing(GetNode("GameEntryDock"));
         GetNode("GameEntryNhdGP02TestWorld").AddVerticalPairing(GetNode("GameEntryDock"));
         GetNode("GameEntryNhdEP02NorthEurope").AddVerticalPairing(GetNode("GameEntryDock"));
         GetNode("GameEntryNhdEP03CityLife").AddVerticalPairing(GetNode("GameEntryDock"));
         GetNode("GameEntryNhdGP04Vampire").AddVerticalPairing(GetNode("GameEntryDock"));
         GetNode("GameEntryNhdEP04PetWorld").AddVerticalPairing(GetNode("GameEntryDock"));
         GetNode("GameEntryNhdGP06Jungle").AddVerticalPairing(GetNode("GameEntryDock"));
         GetNode("GameEntryNhdEP06FameWorld").AddVerticalPairing(GetNode("GameEntryDock"));
         GetNode("GameEntryNhdGP07StrangeTown").AddVerticalPairing(GetNode("GameEntryDock"));
         GetNode("GameEntryNhdEP07IslandLiving").AddVerticalPairing(GetNode("GameEntryDock"));
         GetNode("GameEntryNhdGP08MagicWorld").AddVerticalPairing(GetNode("GameEntryDock"));
         GetNode("GameEntryNhdEP08University").AddVerticalPairing(GetNode("GameEntryDock"));
         GetNode("GameEntryNhdEP09EcoLiving").AddVerticalPairing(GetNode("GameEntryDock"));
         GetNode("GameEntryNhdGP09Pangolin").AddVerticalPairing(GetNode("GameEntryDock"));
         GetNode("GameEntryNhdEP10Summit").AddVerticalPairing(GetNode("GameEntryDock"));
         GetNode("GameEntryNhdEP11Cottage").AddVerticalPairing(GetNode("GameEntryDock"));
         GetNode("GameEntryNhdGP11Weddings").AddVerticalPairing(GetNode("GameEntryDock"));
         GetNode("GameEntryNhdGP12WolfTown").AddVerticalPairing(GetNode("GameEntryDock"));
         GetNode("GameEntryNhdEP12HighSchool").AddVerticalPairing(GetNode("GameEntryDock"));
         GetNode("GameEntryNhdEP13BayArea").AddVerticalPairing(GetNode("GameEntryDock"));
         GetNode("GameEntryNhdEP14Ranch").AddVerticalPairing(GetNode("GameEntryDock"));
         GetNode("GameEntryNhdEP15MultiUnitLiving").AddVerticalPairing(GetNode("GameEntryDock"));
         GetNode("GameEntryNhdEP16Rendezvous").AddVerticalPairing(GetNode("GameEntryDock"));
         GetNode("GameEntryNhdEP17Opera").AddVerticalPairing(GetNode("GameEntryDock"));
         GetNode("GameEntryNhdEP18Obsession").AddVerticalPairing(GetNode("GameEntryDock"));
         GetNode("GameEntryNhdEP19Grove").AddVerticalPairing(GetNode("GameEntryDock"));
         GetNode("GameEntryNhdEP20Getaway").AddVerticalPairing(GetNode("GameEntryDock"));
         GetNode("GameEntryNhdEP21Gold").AddVerticalPairing(GetNode("GameEntryDock"));
         GetNode("GameEntryDock").AddAnglePairing(GetNode("Notifications"),Geometry.ToRadians(-45));
      }
      
      public static function get Instance() : WorldSelectionNavMesh
      {
         if(instance == null)
         {
            instance = new WorldSelectionNavMesh();
         }
         return instance;
      }
   }
}

