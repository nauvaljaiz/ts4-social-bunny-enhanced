package gamedata.Gameplay.shared
{
   import gamedata.Gameplay.shared.definitions.CategoryStaticData;
   import olympus.core.OlympusObject;
   
   public class CategoryInfo extends OlympusObject
   {
      
      protected var mbPrimary:Boolean;
      
      protected var mbHasTrait:Boolean;
      
      protected var staticInfo:CategoryStaticData;
      
      public function CategoryInfo(param1:CategoryStaticData)
      {
         super();
         this.staticInfo = param1;
      }
      
      public function get uid() : uint
      {
         return this.staticInfo.uid;
      }
      
      public function get name() : String
      {
         return this.staticInfo.name.toString();
      }
      
      public function get icon() : String
      {
         return this.staticInfo.icon ? this.staticInfo.icon.instance : null;
      }
      
      public function set IsPrimary(param1:Boolean) : void
      {
         this.mbPrimary = param1;
      }
      
      public function get IsPrimary() : Boolean
      {
         return this.mbPrimary;
      }
      
      public function set HasTraits(param1:Boolean) : void
      {
         this.mbHasTrait = param1;
      }
      
      public function get HasTraits() : Boolean
      {
         return this.mbHasTrait;
      }
   }
}

