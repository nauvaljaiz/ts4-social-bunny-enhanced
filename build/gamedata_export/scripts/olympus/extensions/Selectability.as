package olympus.extensions
{
   import olympus.interfaces.IExtendable;
   import olympus.interfaces.IExtension;
   import olympus.interfaces.IStatesUser;
   
   public class Selectability implements IExtension
   {
      
      protected var mbSelected:Boolean;
      
      protected var mExtendedTarget:IExtendable;
      
      public function Selectability()
      {
         super();
      }
      
      public function Extend(param1:IExtendable) : void
      {
         this.mExtendedTarget = param1;
      }
      
      public function get Selected() : Boolean
      {
         return this.mbSelected;
      }
      
      public function set Selected(param1:Boolean) : void
      {
         if(this.mbSelected == param1)
         {
            return;
         }
         this.mbSelected = param1;
         var _loc2_:IStatesUser = this.mExtendedTarget as IStatesUser;
         if(_loc2_)
         {
            if(param1)
            {
               _loc2_.EnableStatePrefix("selected");
            }
            else
            {
               _loc2_.DisableStatePrefix("selected");
            }
         }
      }
   }
}

