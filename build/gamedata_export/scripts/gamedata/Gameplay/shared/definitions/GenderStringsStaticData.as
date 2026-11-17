package gamedata.Gameplay.shared.definitions
{
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   
   public class GenderStringsStaticData extends OlympusObject
   {
      
      protected static var sGenderStringsData:GenderStringsStaticData;
      
      public var gender_strings:Array = [GenderStringsMapData];
      
      public function GenderStringsStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetStaticData() : GenderStringsStaticData
      {
         if(sGenderStringsData == null)
         {
            sGenderStringsData = new GenderStringsStaticData(CommunicationManager.CallGameService("GetGenderStrings"));
         }
         return sGenderStringsData;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.gender_strings);
      }
      
      public function TryGetGenderStringKeysBySpecies(param1:uint) : SpeciesStringsData
      {
         var _loc2_:GenderStringsMapData = null;
         for each(_loc2_ in this.gender_strings)
         {
            if(_loc2_.species == param1)
            {
               return _loc2_.species_strings;
            }
         }
         return null;
      }
   }
}

