package gamedata.ObjectBoundElements
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.utils.ImageUtils;
   
   public class DisplayHeadline extends OlympusObject
   {
      
      public var sim_id:String;
      
      public var headline_type:String;
      
      public var value:Number;
      
      public var icon_modifier:ResourceKey = new ResourceKey();
      
      public function DisplayHeadline(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(this.icon_modifier.instance == ImageUtils.INVALID_IMAGE)
         {
            this.icon_modifier = null;
         }
      }
   }
}

