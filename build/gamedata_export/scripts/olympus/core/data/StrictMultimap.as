package olympus.core.data
{
   public class StrictMultimap extends Multimap
   {
      
      protected var mType:Class;
      
      public function StrictMultimap(param1:Class)
      {
         super();
         this.mType = param1;
      }
      
      override public function Insert(param1:String, param2:Object) : void
      {
         if(param2 is this.mType)
         {
            super.Insert(param1,param2);
            return;
         }
         throw TypeError("Given value does not match bound type!");
      }
      
      override public function Remove(param1:String, param2:Object) : void
      {
         if(param2 is this.mType)
         {
            super.Remove(param1,param2);
            return;
         }
         throw TypeError("Given value does not match bound type!");
      }
   }
}

