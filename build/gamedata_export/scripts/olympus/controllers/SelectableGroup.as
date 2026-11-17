package olympus.controllers
{
   import flash.events.EventDispatcher;
   import olympus.events.PushButtonEvent;
   import olympus.events.SelectableGroupEvent;
   import olympus.extensions.Selectability;
   import olympus.gui.buttons.Button;
   import olympus.interfaces.IExtendable;
   
   public class SelectableGroup extends EventDispatcher
   {
      
      protected var mElements:Array;
      
      protected var mPreventDeselectElements:Array;
      
      protected var mSelectedElements:Vector.<IExtendable>;
      
      protected var mbMultiSelect:Boolean = false;
      
      protected var mSelectionLimit:int = 1;
      
      public function SelectableGroup()
      {
         super();
         this.mElements = new Array();
         this.mPreventDeselectElements = new Array();
         this.mSelectedElements = new Vector.<IExtendable>();
      }
      
      public function get Length() : int
      {
         return this.mElements.length;
      }
      
      public function GetElementAt(param1:int) : IExtendable
      {
         return this.mElements[param1];
      }
      
      public function GetIndexOfElement(param1:IExtendable) : int
      {
         return this.mElements.indexOf(param1);
      }
      
      public function get SelectedElement() : IExtendable
      {
         return this.mSelectedElements.length > 0 ? this.mSelectedElements[0] : null;
      }
      
      public function get SelectedElements() : Vector.<IExtendable>
      {
         return this.mSelectedElements;
      }
      
      public function get SelectedIndex() : int
      {
         return this.mSelectedElements.length > 0 ? this.mElements.indexOf(this.SelectedElement) : -1;
      }
      
      public function set SelectedIndex(param1:int) : void
      {
         if(param1 < 0 || param1 >= this.mElements.length)
         {
            return;
         }
         this.SetSelectionAs(this.mElements[param1],true,false);
      }
      
      public function get MultiSelect() : Boolean
      {
         return this.mbMultiSelect;
      }
      
      public function get SelectionLimit() : int
      {
         return this.mSelectionLimit;
      }
      
      public function set SelectionLimit(param1:int) : void
      {
         this.mSelectionLimit = param1;
         this.mbMultiSelect = param1 != 1;
      }
      
      public function ClearSelection() : void
      {
         var _loc1_:Vector.<IExtendable> = null;
         var _loc2_:IExtendable = null;
         if(this.mSelectedElements.length > 0)
         {
            _loc1_ = this.mSelectedElements;
            for each(_loc2_ in _loc1_)
            {
               (_loc2_.GetExtension(Selectability) as Selectability).Selected = false;
            }
            this.mSelectedElements.length = 0;
         }
      }
      
      public function Add(param1:IExtendable, param2:Boolean = false) : void
      {
         this.Remove(param1);
         this.mElements.push(param1);
         if(param2)
         {
            this.mPreventDeselectElements.push(param1);
         }
         param1.GetExtension(Selectability);
         if(param1 is Button)
         {
            (param1 as Button).addEventListener(PushButtonEvent.CLICK,this.OnButtonClick,false,1,true);
         }
      }
      
      public function SetSelectionAs(param1:IExtendable, param2:Boolean = true, param3:Boolean = true) : void
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:SelectableGroupEvent = null;
         if(!param1)
         {
            return;
         }
         var _loc4_:Array = this.mElements;
         if(this.mbMultiSelect)
         {
            if(this.mSelectionLimit > 0 && this.mSelectedElements.length >= this.mSelectionLimit)
            {
               if(param2)
               {
                  return;
               }
            }
            _loc7_ = this.mElements.indexOf(param1);
            if(_loc7_ != -1)
            {
               (param1.GetExtension(Selectability) as Selectability).Selected = param2;
               _loc8_ = this.mSelectedElements.indexOf(param1);
               if(_loc8_ != -1 && !param2)
               {
                  this.mSelectedElements.splice(_loc8_,1);
               }
               else if(_loc8_ == -1 && param2)
               {
                  this.mSelectedElements.push(param1);
               }
               if(param3)
               {
                  _loc9_ = new SelectableGroupEvent(SelectableGroupEvent.SELECTION_CHANGED);
                  if(param2)
                  {
                     _loc9_.selectedIndex = _loc7_;
                     _loc9_.selectedComponent = param1;
                  }
                  else
                  {
                     _loc9_.deselectedIndex = _loc7_;
                     _loc9_.deselectedComponent = param1;
                  }
                  dispatchEvent(_loc9_);
               }
            }
            return;
         }
         var _loc5_:SelectableGroupEvent = new SelectableGroupEvent(SelectableGroupEvent.SELECTION_CHANGED);
         var _loc6_:IExtendable = this.SelectedElement;
         if(param1 == _loc6_)
         {
            if(param2)
            {
               return;
            }
            (param1.GetExtension(Selectability) as Selectability).Selected = false;
            this.mSelectedElements.length = 0;
            if(param3)
            {
               _loc5_.deselectedIndex = _loc4_.indexOf(param1);
               _loc5_.deselectedComponent = param1;
               dispatchEvent(_loc5_);
               return;
            }
            return;
         }
         if(param2)
         {
            if(_loc6_)
            {
               (_loc6_.GetExtension(Selectability) as Selectability).Selected = false;
               if(param3)
               {
                  _loc5_.deselectedIndex = _loc4_.indexOf(_loc6_);
                  _loc5_.deselectedComponent = _loc6_;
               }
            }
            (param1.GetExtension(Selectability) as Selectability).Selected = true;
            this.mSelectedElements[0] = param1;
            if(param3)
            {
               _loc5_.selectedIndex = _loc4_.indexOf(param1);
               _loc5_.selectedComponent = param1;
               dispatchEvent(_loc5_);
            }
            return;
         }
      }
      
      public function Remove(param1:IExtendable) : void
      {
         var _loc2_:int = this.mElements.indexOf(param1);
         if(_loc2_ == -1)
         {
            return;
         }
         this.mElements.splice(_loc2_,1);
         _loc2_ = this.mPreventDeselectElements.indexOf(param1);
         if(_loc2_ != -1)
         {
            this.mPreventDeselectElements.splice(_loc2_,1);
         }
         _loc2_ = this.mSelectedElements.indexOf(param1);
         if(_loc2_ != -1)
         {
            this.mSelectedElements.splice(_loc2_,1);
         }
         if(param1 is Button)
         {
            (param1 as Button).removeEventListener(PushButtonEvent.CLICK,this.OnButtonClick);
         }
      }
      
      public function RemoveAll() : void
      {
         var _loc1_:IExtendable = null;
         for each(_loc1_ in this.mElements)
         {
            if(_loc1_ is Button)
            {
               (_loc1_ as Button).removeEventListener(PushButtonEvent.CLICK,this.OnButtonClick);
            }
         }
         this.mElements.length = 0;
         this.mPreventDeselectElements.length = 0;
         this.mSelectedElements.length = 0;
      }
      
      public function PreventDeselectOfElement(param1:IExtendable) : void
      {
         var _loc2_:int = this.mElements.indexOf(param1);
         var _loc3_:int = this.mPreventDeselectElements.indexOf(param1);
         if(_loc2_ != -1 && _loc3_ == -1)
         {
            this.mPreventDeselectElements.push(param1);
         }
      }
      
      public function AllowDeselectOfElement(param1:IExtendable) : void
      {
         var _loc2_:int = this.mPreventDeselectElements.indexOf(param1);
         if(_loc2_ != -1)
         {
            this.mPreventDeselectElements.splice(_loc2_,1);
         }
      }
      
      protected function OnButtonClick(param1:PushButtonEvent) : void
      {
         var _loc2_:Button = param1.target as Button;
         var _loc3_:SelectableGroupEvent = new SelectableGroupEvent(SelectableGroupEvent.SELECTION_CLICKED);
         _loc3_.selectedIndex = this.mElements.indexOf(_loc2_);
         dispatchEvent(_loc3_);
         if(this.mSelectedElements.indexOf(_loc2_) != -1 && this.mPreventDeselectElements.indexOf(_loc2_) != -1)
         {
            return;
         }
         this.SetSelectionAs(_loc2_,!(_loc2_.GetExtension(Selectability) as Selectability).Selected);
      }
   }
}

