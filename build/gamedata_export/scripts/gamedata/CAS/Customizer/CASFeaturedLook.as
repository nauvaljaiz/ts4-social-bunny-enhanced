package gamedata.CAS.Customizer
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class CASFeaturedLook extends OlympusObject
   {
      
      public var data_id:String;
      
      public var res_id:String;
      
      public var style_id:uint;
      
      public var background_image:String;
      
      public var brand:LocKey = new LocKey();
      
      public var title:LocKey = new LocKey();
      
      public var promotion:LocKey = new LocKey();
      
      public var description:LocKey = new LocKey();
      
      public var packId:int;
      
      public function CASFeaturedLook(param1:Object = null)
      {
         super(param1);
      }
   }
}

