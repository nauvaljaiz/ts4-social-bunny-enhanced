package olympus.core
{
   import flash.display.DisplayObject;
   import flash.utils.getQualifiedClassName;
   import olympus.core.tooltip.Tooltip;
   import olympus.interfaces.ITooltip;
   
   public class TooltipManager
   {
      
      protected static var sInstance:TooltipManager;
      
      protected var mTooltips:Object;
      
      protected var mTooltipsLayer:Layer;
      
      protected var mDefaultTooltip:ITooltip;
      
      protected var mbDisabled:Boolean;
      
      public function TooltipManager(param1:Layer, param2:ITooltip)
      {
         super();
         this.mTooltips = new Object();
         this.mTooltipsLayer = param1;
         this.mDefaultTooltip = param2;
         sInstance = this;
      }
      
      public static function getInstance() : TooltipManager
      {
         return sInstance;
      }
      
      public function Disable(param1:Boolean = true) : void
      {
         this.mbDisabled = param1;
         if(param1)
         {
            this.HideTooltips(true);
         }
      }
      
      public function Clear() : void
      {
         var _loc1_:String = null;
         this.HideTooltips(true);
         for(_loc1_ in this.mTooltips)
         {
            delete this.mTooltips[_loc1_];
         }
         this.mTooltipsLayer.Clear();
      }
      
      public function GetTooltip(param1:Class) : ITooltip
      {
         var _loc3_:String = null;
         var _loc2_:ITooltip = null;
         if(!param1 || param1 == Tooltip)
         {
            _loc2_ = this.mDefaultTooltip;
         }
         else
         {
            _loc3_ = getQualifiedClassName(param1);
            _loc2_ = this.mTooltips[_loc3_];
            if(_loc2_ == null)
            {
               _loc2_ = new param1() as ITooltip;
               if(_loc2_ != null)
               {
                  this.mTooltips[_loc3_] = _loc2_;
               }
               else
               {
                  _loc2_ = this.mDefaultTooltip;
               }
            }
         }
         return _loc2_;
      }
      
      public function ShowTooltip(param1:ITooltip, param2:int) : void
      {
         if(this.mbDisabled)
         {
            return;
         }
         if(param1 != null)
         {
            param1.Show(param2);
         }
      }
      
      public function HideTooltip(param1:ITooltip, param2:Boolean = false, param3:int = 500) : void
      {
         if(param1 != null)
         {
            param1.Hide(param2,param3);
         }
      }
      
      public function HideTooltips(param1:Boolean = false) : void
      {
         var _loc2_:ITooltip = null;
         this.HideTooltip(this.mDefaultTooltip,param1);
         for each(_loc2_ in this.mTooltips)
         {
            if(_loc2_ != null)
            {
               this.HideTooltip(_loc2_,param1);
            }
         }
      }
      
      public function AddTooltip(param1:DisplayObject) : void
      {
         if(this.mbDisabled)
         {
            return;
         }
         if(!this.mTooltipsLayer.contains(param1))
         {
            this.mTooltipsLayer.addChild(param1);
         }
      }
      
      public function IsTooltipShown(param1:DisplayObject) : Boolean
      {
         return this.mTooltipsLayer.contains(param1);
      }
      
      public function RemoveTooltip(param1:DisplayObject) : void
      {
         if(this.mTooltipsLayer.contains(param1))
         {
            this.mTooltipsLayer.removeChild(param1);
         }
      }
   }
}

