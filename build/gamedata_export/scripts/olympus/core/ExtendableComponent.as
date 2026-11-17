package olympus.core
{
   import flash.display.MovieClip;
   import olympus.interfaces.IExtendable;
   import olympus.interfaces.IExtension;
   
   public class ExtendableComponent extends MovieClip implements IExtendable
   {
      
      protected var mExtensions:Object = new Object();
      
      public function ExtendableComponent()
      {
         super();
      }
      
      public function AddExtension(param1:Class) : IExtension
      {
         var _loc2_:Object = new param1();
         if(!(_loc2_ is IExtension))
         {
            throw new Error("Trying to use a class that is not an Extension!");
         }
         var _loc3_:IExtension = _loc2_ as IExtension;
         _loc3_.Extend(this);
         var _loc4_:Class = param1["SlotType"] as Class;
         if(!_loc4_)
         {
            _loc4_ = param1;
         }
         this.mExtensions[_loc4_] = _loc3_;
         return _loc3_;
      }
      
      public function GetExtension(param1:Class, param2:Boolean = true) : IExtension
      {
         var _loc3_:Class = param1["SlotType"] as Class;
         if(!_loc3_)
         {
            _loc3_ = param1;
         }
         var _loc4_:IExtension = this.mExtensions[_loc3_];
         if(!_loc4_ && param2)
         {
            _loc4_ = this.AddExtension(param1);
         }
         return _loc4_;
      }
      
      public function RemoveExtension(param1:Class) : Boolean
      {
         var _loc2_:Class = param1["SlotType"] as Class;
         if(!_loc2_)
         {
            _loc2_ = param1;
         }
         if(this.mExtensions[_loc2_])
         {
            this.mExtensions[_loc2_] = null;
            delete this.mExtensions[_loc2_];
            return true;
         }
         return false;
      }
   }
}

