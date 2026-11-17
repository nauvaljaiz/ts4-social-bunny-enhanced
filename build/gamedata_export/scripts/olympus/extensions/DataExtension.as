package olympus.extensions
{
   import olympus.interfaces.IExtendable;
   import olympus.interfaces.IExtension;
   
   public class DataExtension implements IExtension
   {
      
      protected var mData:Object;
      
      public function DataExtension()
      {
         super();
      }
      
      public static function Get(param1:IExtendable, param2:Boolean = true) : DataExtension
      {
         return param1.GetExtension(DataExtension,param2) as DataExtension;
      }
      
      public static function GetData(param1:IExtendable) : Object
      {
         var _loc2_:DataExtension = null;
         if(param1)
         {
            _loc2_ = param1.GetExtension(DataExtension,false) as DataExtension;
            if(_loc2_)
            {
               return _loc2_.Data;
            }
         }
         return null;
      }
      
      public function get Data() : Object
      {
         return this.mData;
      }
      
      public function set Data(param1:Object) : void
      {
         this.mData = param1;
      }
      
      public function Extend(param1:IExtendable) : void
      {
      }
   }
}

