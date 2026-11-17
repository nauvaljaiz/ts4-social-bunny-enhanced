package gamedata.BuildBuy.shared
{
   import olympus.core.OlympusObject;
   
   public class UnitData extends OlympusObject
   {
      
      public var name:String;
      
      public var plexId:uint;
      
      public var colorIndex:uint;
      
      public var bedroomCount:uint;
      
      public var bathroomCount:uint;
      
      public var tileCount:uint;
      
      public var value:uint;
      
      public var tenantId:String;
      
      public var loaded:Boolean;
      
      public var sortOrder:uint;
      
      public function UnitData(param1:Object)
      {
         super(param1);
      }
      
      public function get occupied() : Boolean
      {
         return this.tenantId != "0";
      }
   }
}

