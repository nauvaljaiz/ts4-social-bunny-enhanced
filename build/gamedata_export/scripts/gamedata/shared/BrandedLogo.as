package gamedata.shared
{
   import flash.display.MovieClip;
   import olympus.controls.GUIComponent;
   import olympus.controls.IconComponent;
   
   public class BrandedLogo extends GUIComponent
   {
      
      public var mcBrandBackgroundLight:MovieClip;
      
      public var mcBrandBackgroundDark:MovieClip;
      
      public var mcBrandImage:IconComponent;
      
      public var mcBrandImageTopLeft:IconComponent;
      
      protected const STYLE_TOP_WIDE_LABEL:String = "top_wide";
      
      protected const STYLE_TOP_LEFT_LABEL:String = "top_left";
      
      public function BrandedLogo()
      {
         super();
      }
      
      public function SetTag(param1:BrandedTagData) : void
      {
         if(param1)
         {
            switch(param1.style)
            {
               case BrandedTagData.BRANDED_STYLE_TOP_WIDE:
                  gotoAndStop(this.STYLE_TOP_WIDE_LABEL);
                  this.mcBrandImage.LoadImage(param1.icon.instance);
                  this.mcBrandBackgroundLight.visible = param1.background_type == BrandedTagData.BRANDED_BACKGROUND_LIGHT;
                  this.mcBrandBackgroundDark.visible = param1.background_type == BrandedTagData.BRANDED_BACKGROUND_DARK;
                  break;
               case BrandedTagData.BRANDED_STYLE_TOP_LEFT_ICON:
                  gotoAndStop(this.STYLE_TOP_LEFT_LABEL);
                  this.mcBrandImageTopLeft.LoadImage(param1.icon.instance);
            }
         }
      }
   }
}

