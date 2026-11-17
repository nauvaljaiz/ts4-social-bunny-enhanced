package widgets.shared.controls.FamilyTree
{
   import flash.display.MovieClip;
   import olympus.controls.GUIComponent;
   import olympus.extensions.TooltipExtension;
   import olympus.localization.KeysGP;
   
   public class FamilyTreeEdgeIcon extends GUIComponent
   {
      
      public static const MARRIED:int = 1;
      
      public static const DIVORCED:int = 2;
      
      public static const FORGED:int = 3;
      
      public var mcMarriedIcon:MovieClip;
      
      public var mcDivorcedIcon:MovieClip;
      
      public var mcForgedIcon:MovieClip;
      
      public function FamilyTreeEdgeIcon()
      {
         super();
      }
      
      public function Draw(param1:int) : void
      {
         this.width = this.height = FamilyTreeTunables.EDGE_ICON_SIZE;
         this.mcMarriedIcon.visible = this.mcDivorcedIcon.visible = this.mcForgedIcon.visible = false;
         var _loc2_:TooltipExtension = GetExtension(TooltipExtension) as TooltipExtension;
         switch(param1)
         {
            case MARRIED:
               this.mcMarriedIcon.visible = true;
               _loc2_.Text = KeysGP.FAMILY_TREE_MARRIED_LABEL;
               break;
            case DIVORCED:
               this.mcDivorcedIcon.visible = true;
               _loc2_.Text = KeysGP.FAMILY_TREE_DIVORCED_LABEL;
               break;
            case FORGED:
               this.mcForgedIcon.visible = true;
               _loc2_.Text = KeysGP.FAMILY_TREE_FORGED_CONNECTION;
         }
      }
   }
}

