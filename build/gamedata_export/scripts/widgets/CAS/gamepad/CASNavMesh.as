package widgets.CAS.gamepad
{
   import olympus.gamepad.NavMesh;
   
   public class CASNavMesh extends NavMesh
   {
      
      protected static var instance:CASNavMesh;
      
      public function CASNavMesh()
      {
         super();
         CreateNodes(new <String>["CASNameField","CASAgeGenderPane","CASMolecule","CASSimSelector","CASNavigation","GameTray","CASPlanOutfit","CASCustomizer","CASFeaturedLooks","CASPetPaintingPoses","Notifications","CASFashionNameGender","CASFashionShoppingCart"]);
         GetNode("CASNameField").AddVerticalPairing(GetNode("CASAgeGenderPane"));
         GetNode("CASAgeGenderPane").AddVerticalPairing(GetNode("CASMolecule"));
         GetNode("CASNameField").AddVerticalPairing(GetNode("CASSimSelector"));
         GetNode("CASSimSelector").AddHorizontalPairing(GetNode("CASNavigation"));
         GetNode("GameTray").AddVerticalPairing(GetNode("CASNavigation"));
         GetNode("GameTray").AddDynamicPairing(GetNode("Notifications"));
         GetNode("Notifications").AddDynamicPairing(GetNode("CASNavigation"));
         GetNode("CASNameField").AddHorizontalPairing(GetNode("CASPetPaintingPoses"));
         GetNode("CASPetPaintingPoses").AddHorizontalPairing(GetNode("GameTray"));
         GetNode("CASNameField").AddHorizontalPairing(GetNode("GameTray"));
         GetNode("CASSimSelector").AddDynamicPairing(GetNode("GameTray"));
         GetNode("CASNameField").AddDynamicPairing(GetNode("CASNavigation"));
         GetNode("CASNavigation").AddDynamicPairing(GetNode("CASPetPaintingPoses"));
         GetNode("CASSimSelector").AddDynamicPairing(GetNode("CASPetPaintingPoses"));
         GetNode("CASPlanOutfit").AddVerticalPairing(GetNode("CASCustomizer"));
         GetNode("CASPlanOutfit").AddVerticalPairing(GetNode("CASFeaturedLooks"));
         GetNode("CASFashionShoppingCart").AddDynamicPairing(GetNode("CASFashionNameGender"));
      }
      
      public static function get Instance() : CASNavMesh
      {
         if(instance == null)
         {
            instance = new CASNavMesh();
         }
         return instance;
      }
   }
}

