package gamedata.shared
{
   public final class CreatureTypes
   {
      
      public static const TYPE_NONE:uint = 0;
      
      public static const TYPE_RABBIT:uint = int(2689485353);
      
      public static const TYPE_HEN:uint = int(915067390);
      
      public static const TYPE_CHICK:uint = int(4176957319);
      
      public static const TYPE_ROOSTER:uint = int(3987889111);
      
      public static const TYPE_COW:uint = int(1083682102);
      
      public static const TYPE_LLAMA:uint = int(2978855956);
      
      public static const TYPE_GOAT:uint = int(567967128);
      
      public static const TYPE_SHEEP:uint = int(2935967122);
      
      public function CreatureTypes()
      {
         super();
      }
      
      public static function IsLivestock(param1:uint) : Boolean
      {
         if(param1 == TYPE_CHICK || param1 == TYPE_COW || param1 == TYPE_HEN || param1 == TYPE_LLAMA || param1 == TYPE_ROOSTER || param1 == TYPE_GOAT || param1 == TYPE_SHEEP)
         {
            return true;
         }
         return false;
      }
   }
}

