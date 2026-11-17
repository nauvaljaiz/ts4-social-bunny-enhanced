package widgets.BuildBuy.VenueConfiguration.controls
{
   public interface IHasVenueRequirementsData
   {
      
      function get TagKey() : String;
      
      function GetRequirementsData(param1:Object) : VenueRequirementsData;
   }
}

