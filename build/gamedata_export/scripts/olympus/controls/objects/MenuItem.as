package olympus.controls.objects
{
   import olympus.utils.ArrayUtils;
   
   public final class MenuItem
   {
      
      public var label:String;
      
      public var data:Object;
      
      public var icon:String = null;
      
      public var selectedIcon:String = null;
      
      public var tooltipText:String;
      
      public var tooltipObject:Object;
      
      public var enabled:Boolean = true;
      
      public var audioElement:String = null;
      
      public function MenuItem(param1:String, param2:Object, param3:Boolean = true, param4:Object = null, param5:Object = null, param6:String = null)
      {
         super();
         this.label = param1;
         this.data = param2;
         this.enabled = param3;
         this.audioElement = param6;
         if(param4 is String)
         {
            this.icon = param4 as String;
         }
         else if(param4 is Array)
         {
            this.icon = param4[0];
            this.selectedIcon = param4[1];
         }
         if(param5 is String)
         {
            this.tooltipText = param5 as String;
         }
         else
         {
            this.tooltipObject = param5;
         }
      }
      
      public static function CloneArray(param1:Array) : Array
      {
         var _loc3_:MenuItem = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in param1)
         {
            _loc2_.push(_loc3_.Clone());
         }
         return _loc2_;
      }
      
      public static function SortByLabel(param1:MenuItem, param2:MenuItem) : int
      {
         return param1.label.localeCompare(param2.label);
      }
      
      public static function SortByIncrementingLabel(param1:MenuItem, param2:MenuItem) : int
      {
         return ArrayUtils.SortByIncrementingText(param1.label,param2.label);
      }
      
      public static function GetItemIndexByMenuItemFieldName(param1:Array, param2:String, param3:Object) : int
      {
         var _loc6_:MenuItem = null;
         var _loc4_:int = 0;
         var _loc5_:int = int(param1.length);
         while(_loc4_ < _loc5_)
         {
            _loc6_ = param1[_loc4_] as MenuItem;
            if(Boolean((_loc6_) && _loc6_.data) && Boolean(_loc6_.data.hasOwnProperty(param2)) && _loc6_.data[param2] == param3)
            {
               return _loc4_;
            }
            _loc4_++;
         }
         return -1;
      }
      
      public function Clone() : MenuItem
      {
         return new MenuItem(this.label,this.data,this.enabled,this.icon,this.tooltipText || this.tooltipObject);
      }
   }
}

