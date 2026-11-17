package olympus.gui.grids
{
   import olympus.controls.GUIComponent;
   import olympus.core.widget.Margin;
   import olympus.data.SelectableArrayDataFeed;
   import olympus.events.GridEvent;
   import olympus.interfaces.IDataFeed;
   import olympus.interfaces.IGridLayout;
   import olympus.layout.GridLayout;
   import olympus.views.GridView;
   
   public class SelectionGrid extends GUIComponent
   {
      
      public var mcGridView:GridView;
      
      public var mGridLayout:IGridLayout;
      
      protected var mDataFeed:SelectableArrayDataFeed;
      
      protected var mbMultiSelect:Boolean;
      
      protected var mbPreventDeselect:Boolean;
      
      protected var mValidationFn:Function;
      
      public function SelectionGrid()
      {
         super();
      }
      
      override protected function ConfigUI() : void
      {
         super.ConfigUI();
      }
      
      public function InitializeSelectionGrid(param1:SelectableArrayDataFeed, param2:Class, param3:Boolean = false, param4:Margin = null, param5:IGridLayout = null, param6:Boolean = false, param7:Boolean = false, param8:Boolean = false, param9:GridView = null, param10:String = null, param11:Function = null) : void
      {
         var _loc13_:GridView = null;
         if(!param1)
         {
            throw new Error("Datafeed cannot be null while initializing selection grid.");
         }
         if(param9 != null)
         {
            this.mcGridView = param9;
         }
         else if(!this.mcGridView)
         {
            _loc13_ = new GridView();
            addChild(_loc13_);
            this.mcGridView = _loc13_;
         }
         if(!param4)
         {
            param4 = new Margin(0);
         }
         if(!param5)
         {
            param5 = new GridLayout(false,param3,5);
         }
         this.mbMultiSelect = param6;
         this.mGridLayout = param5;
         this.mbPreventDeselect = param7;
         this.mValidationFn = param11;
         var _loc12_:IGridLayout = this.mGridLayout;
         _loc12_.SetGridView(this.mcGridView);
         _loc12_.SetCellView(param2,param4,param8);
         if(param10 != null)
         {
            this.SetSelectionGridListener(param10);
         }
         this.SetDataFeed(param1);
      }
      
      public function SetGridListener(param1:String, param2:Function) : void
      {
         this.mGridLayout.RegisterCellEventListener(param1);
         this.mcGridView.addEventListener(GridEvent.CELL_EVENT.concat(param1),param2);
      }
      
      public function SetSelectionGridListener(param1:String) : void
      {
         this.mGridLayout.RegisterCellEventListener(param1);
         this.mcGridView.addEventListener(GridEvent.CELL_EVENT.concat(param1),this.OnSelectionUpdate);
      }
      
      public function SetCellViewAudioElementName(param1:String) : void
      {
         this.mGridLayout.SetCellViewAudioElementName(param1);
      }
      
      public function SetSelection(param1:int, param2:Boolean = true, param3:Boolean = true) : Boolean
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Boolean = false;
         var _loc9_:GridEvent = null;
         if(this.mbPreventDeselect && !this.mbMultiSelect && !param2)
         {
            return false;
         }
         var _loc4_:SelectableArrayDataFeed = this.mDataFeed;
         var _loc5_:Boolean = _loc4_.CheckGoodIndex(param1);
         if(!_loc5_)
         {
            return false;
         }
         if(param2)
         {
            if(!this.mbMultiSelect)
            {
               _loc6_ = _loc4_.length;
               _loc7_ = 0;
               while(_loc7_ < _loc6_)
               {
                  _loc8_ = _loc4_.GetSelectionState(_loc7_);
                  if(_loc8_)
                  {
                     _loc4_.SetSelectionState(_loc7_,false);
                     break;
                  }
                  _loc7_++;
               }
            }
         }
         _loc4_.SetSelectionState(param1,param2);
         if(param3)
         {
            _loc9_ = new GridEvent(GridEvent.SELECTION_UPDATE);
            _loc9_.mData = _loc4_.RequestItemAt(param1);
            dispatchEvent(_loc9_);
         }
         return true;
      }
      
      public function GetSelectedIndices() : Array
      {
         if(!this.mDataFeed)
         {
            return new Array();
         }
         return this.mDataFeed.GetSelectedIndices();
      }
      
      public function SelectionUpdateFromDialog(param1:Object) : void
      {
         this.OnSelectionUpdate(param1.event);
      }
      
      public function OnSelectionUpdate(param1:GridEvent) : void
      {
         var _loc9_:Boolean = false;
         if(Boolean(this.mValidationFn) && !this.mValidationFn(this.SelectionUpdateFromDialog,{"event":param1}))
         {
            return;
         }
         var _loc2_:GridEvent = new GridEvent(GridEvent.SELECTION_UPDATE);
         var _loc3_:Object = param1.mData;
         var _loc4_:SelectableArrayDataFeed = this.mDataFeed;
         var _loc5_:int = _loc4_.IndexOf(_loc3_);
         var _loc6_:int = _loc4_.length;
         if(_loc3_ == null || _loc5_ < 0)
         {
            return;
         }
         var _loc7_:Boolean = _loc4_.GetSelectionState(_loc5_);
         var _loc8_:int = 0;
         if(this.mbMultiSelect)
         {
            _loc4_.SetSelectionState(_loc5_,!_loc7_);
            _loc2_.mData = _loc4_.RequestItemAt(_loc5_);
            dispatchEvent(_loc2_);
         }
         else if(_loc7_ && !this.mbPreventDeselect)
         {
            _loc4_.SetSelectionState(_loc5_,false);
            _loc2_.mData = _loc4_.RequestItemAt(_loc5_);
            dispatchEvent(_loc2_);
         }
         else if(!_loc7_)
         {
            _loc8_ = 0;
            while(_loc8_ < _loc6_)
            {
               _loc9_ = _loc4_.GetSelectionState(_loc8_);
               if(_loc9_)
               {
                  _loc4_.SetSelectionState(_loc8_,false);
                  break;
               }
               _loc8_++;
            }
            _loc4_.SetSelectionState(_loc5_,true);
            _loc2_.mData = _loc4_.RequestItemAt(_loc5_);
            _loc2_.mCellEvent = param1.mCellEvent;
            dispatchEvent(_loc2_);
         }
      }
      
      public function SetDataFeed(param1:SelectableArrayDataFeed) : void
      {
         var _loc2_:GridLayout = this.mGridLayout as GridLayout;
         _loc2_.SetDataFeed(param1 as IDataFeed);
         this.mDataFeed = param1;
      }
   }
}

