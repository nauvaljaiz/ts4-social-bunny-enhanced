package gamedata.shared
{
   import olympus.core.OlympusObject;
   
   public class DefinitionGeoPair extends OlympusObject
   {
      
      public var definition_id:String;
      
      public var geo_state_hash:uint;
      
      public var material_hash:uint;
      
      public function DefinitionGeoPair(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         this.definition_id = param1.definition_id;
         this.geo_state_hash = param1["geo_state_hash"];
         this.material_hash = param1["material_hash"];
      }
      
      public function get GeoState() : String
      {
         return this.geo_state_hash == 0 ? "" : this.geo_state_hash.toString();
      }
      
      public function get MaterialState() : String
      {
         return this.material_hash == 0 ? "" : this.material_hash.toString();
      }
   }
}

