package gamedata.restaurant
{
   import olympus.core.OlympusObject;
   
   public class CareerOutfit extends OlympusObject
   {
      
      public var outfit_index:uint;
      
      public var mannequin_id:String;
      
      public var last_index:int;
      
      public function CareerOutfit(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         this.outfit_index = param1.outfit_index;
         this.mannequin_id = param1.mannequinId;
         this.last_index = param1.lastIndex;
      }
   }
}

