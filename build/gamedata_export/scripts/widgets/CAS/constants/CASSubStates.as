package widgets.CAS.constants
{
   public class CASSubStates
   {
      
      public static const NONE:uint = 0;
      
      public static const GENETICS:uint = 357028305;
      
      public static const PETPAINTING:uint = 1645498544;
      
      public static const STORIES:uint = 3975868911;
      
      public static const EXPEDITEDSIM_START:uint = 1077222471;
      
      public static const EXPEDITEDSIM_REPEAT:uint = 2668005016;
      
      public function CASSubStates()
      {
         super();
      }
      
      public static function AnyExpeditedSimState(param1:uint) : Boolean
      {
         return param1 == EXPEDITEDSIM_START || param1 == EXPEDITEDSIM_REPEAT;
      }
   }
}

