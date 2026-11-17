package widgets.UIContainer.controls
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import olympus.controls.GUIComponent;
   import olympus.controls.MenuItemRenderer;
   import olympus.controls.objects.MenuItem;
   import olympus.extensions.AudioExtension;
   import olympus.io.CommunicationManager;
   import scaleform.clik.controls.ScrollingList;
   import scaleform.clik.data.DataProvider;
   import scaleform.clik.events.ListEvent;
   import widgets.UIContainer.events.ContextMenuEvent;
   
   public class ContextMenu extends GUIComponent
   {
      
      protected static var sInstance:ContextMenu;
      
      protected static const ITEM_NAME:String = "displayName";
      
      protected static const ITEM_ID:String = "id";
      
      protected static const ITEM_ENABLED:String = "enabled";
      
      protected static const MAX_ITEMS_VISIBLE:int = 25;
      
      protected static const CONTEXT_MENU_WIDTH:Number = 160;
      
      public var mcMenu:ScrollingList;
      
      protected var mCallbackService:String;
      
      protected var mMenuClass:Class;
      
      protected var mAudioExtension:AudioExtension;
      
      public function ContextMenu()
      {
         if(sInstance == null)
         {
            super();
            sInstance = this;
            visible = false;
         }
         this.mAudioExtension = GetExtension(AudioExtension) as AudioExtension;
         this.mAudioExtension.CategoryName = "Menu";
         this.mAudioExtension.ElementName = "ContextMenu";
      }
      
      public static function getInstance() : ContextMenu
      {
         return sInstance;
      }
      
      public function Initialize(param1:Sprite, param2:CommunicationManager) : void
      {
         param1.addChild(this);
         this.mMenuClass = (this.mcMenu as Object).constructor;
         param2.RegisterServiceHandler("CreateContextMenu",this.CreateContextMenu,"ContextMenu");
         param2.RegisterServiceHandler("HideContextMenu",this.HideContextMenu,"ContextMenu");
      }
      
      public function CreateContextMenu(param1:Object) : Boolean
      {
         var _loc2_:Array = null;
         var _loc3_:ScrollingList = null;
         var _loc4_:DataProvider = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:MenuItem = null;
         if(param1["items"] is Array)
         {
            _loc2_ = param1["items"];
            this.mCallbackService = param1["callbackService"];
            if(Boolean(_loc2_ && _loc2_.length > 0) && Boolean(_loc2_[0][ITEM_NAME] is String) && _loc2_[0][ITEM_ID] is int)
            {
               if(!this.mcMenu)
               {
                  this.mcMenu = new this.mMenuClass();
                  addChild(this.mcMenu);
               }
               _loc3_ = this.mcMenu;
               _loc3_.itemRendererName = "UIContainer.ContextMenuItemRenderer";
               _loc3_.scrollBar = "UIContainer.ContextScrollBar";
               _loc3_.focusable = true;
               _loc3_.width = CONTEXT_MENU_WIDTH;
               _loc3_.addEventListener(ListEvent.ITEM_CLICK,this.OnSelectMenuItem,false,0,true);
               _loc4_ = new DataProvider();
               _loc5_ = 0;
               _loc6_ = int(_loc2_.length);
               while(_loc5_ < _loc6_)
               {
                  _loc7_ = _loc2_[_loc5_];
                  _loc8_ = new MenuItem(_loc7_[ITEM_NAME],_loc7_);
                  if(_loc7_[ITEM_ENABLED] != null)
                  {
                     _loc8_.enabled = _loc7_[ITEM_ENABLED];
                  }
                  _loc4_.push(_loc8_);
                  _loc5_++;
               }
               _loc3_.dataProvider = _loc4_;
               _loc3_.rowCount = Math.min(_loc4_.length,MAX_ITEMS_VISIBLE);
               _loc3_.selectedIndex = -1;
               if(param1["xPos"] is int && param1["yPos"] is int)
               {
                  x = param1["xPos"];
                  y = param1["yPos"];
               }
               else
               {
                  x = stage.stageWidth / 2;
                  y = stage.stageHeight / 2;
               }
               this.mAudioExtension.DispatchShow();
               visible = true;
               _loc3_.validateNow();
               this.RefreshLayout();
               return true;
            }
         }
         return false;
      }
      
      public function HideContextMenu(param1:Object) : Boolean
      {
         if(visible)
         {
            this.Hide();
         }
         return true;
      }
      
      public function StageResized(param1:Number, param2:Number) : void
      {
         this.HideContextMenu(null);
      }
      
      protected function RefreshLayout() : void
      {
         if(visible)
         {
            stage.focus = this.mcMenu;
            stage.addEventListener(MouseEvent.CLICK,this.OnStageClick,true,0,true);
            if(x + width > stage.stageWidth)
            {
               x = stage.stageWidth - width;
            }
            if(y + height > stage.stageHeight)
            {
               y = stage.stageHeight - height;
            }
         }
      }
      
      protected function OnSelectMenuItem(param1:ListEvent) : void
      {
         var _loc2_:MenuItem = (param1.itemRenderer as MenuItemRenderer).data as MenuItem;
         if(this.mCallbackService)
         {
            CommunicationManager.CallGameService(this.mCallbackService,_loc2_.data,true);
         }
         var _loc3_:ContextMenuEvent = new ContextMenuEvent(ContextMenuEvent.SELECTION,false,true,_loc2_.data);
         dispatchEvent(_loc3_);
         this.Hide();
      }
      
      protected function OnStageClick(param1:MouseEvent) : void
      {
         if(Boolean(this.mcMenu) && this.mcMenu.contains(param1.target as DisplayObject))
         {
            return;
         }
         this.Hide();
      }
      
      protected function Hide() : void
      {
         var _loc1_:ContextMenuEvent = null;
         if(this.mcMenu)
         {
            stage.removeEventListener(MouseEvent.CLICK,this.OnStageClick);
            removeChild(this.mcMenu);
            this.mcMenu.removeEventListener(ListEvent.ITEM_CLICK,this.OnSelectMenuItem);
            this.mcMenu = null;
            visible = false;
            _loc1_ = new ContextMenuEvent(ContextMenuEvent.SELECTION,false,true,null);
            dispatchEvent(_loc1_);
            this.mAudioExtension.DispatchHide();
         }
      }
      
      public function LocalTest() : void
      {
         var _loc1_:Object = {
            "items":[{
               "displayName":"item1",
               "id":1
            },{
               "displayName":"item2 has a really really long name",
               "id":2
            },{
               "displayName":"item3",
               "id":3
            },{
               "displayName":"item4",
               "id":4
            },{
               "displayName":"item5",
               "id":5
            },{
               "displayName":"item6",
               "id":6
            },{
               "displayName":"item7",
               "id":7
            },{
               "displayName":"item8",
               "id":8
            },{
               "displayName":"item9",
               "id":9
            },{
               "displayName":"item10",
               "id":10
            },{
               "displayName":"item11",
               "id":11
            },{
               "displayName":"item12 has areally really long name",
               "id":12
            },{
               "displayName":"item13",
               "id":13
            },{
               "displayName":"item14",
               "id":14
            },{
               "displayName":"item15",
               "id":15
            },{
               "displayName":"item16",
               "id":16
            },{
               "displayName":"item17",
               "id":17
            },{
               "displayName":"item18",
               "id":18
            },{
               "displayName":"item19",
               "id":19
            },{
               "displayName":"item20",
               "id":20
            },{
               "displayName":"item21",
               "id":21
            },{
               "displayName":"item22",
               "id":22
            },{
               "displayName":"item23",
               "id":23
            },{
               "displayName":"item24",
               "id":24
            },{
               "displayName":"item25",
               "id":25
            },{
               "displayName":"item26",
               "id":26
            },{
               "displayName":"item27",
               "id":27
            },{
               "displayName":"item28",
               "id":28
            },{
               "displayName":"item29",
               "id":29
            },{
               "displayName":"item30",
               "id":30
            },{
               "displayName":"item31",
               "id":31
            }],
            "callbackService":"blah"
         };
         CommunicationManager.CallUIService("CreateContextMenu",_loc1_);
      }
   }
}

