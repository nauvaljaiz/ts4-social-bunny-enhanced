package gamedata.Tutorial
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class TutorialGroup extends OlympusObject
   {
      
      public var id:String;
      
      public var name:LocKey = new LocKey();
      
      public var intro:String;
      
      public var tag:String;
      
      public var ui_sort_order:int;
      
      public var children:Array = [Object];
      
      public var expanded:Boolean = false;
      
      public function TutorialGroup(param1:Object = null)
      {
         super(param1);
      }
      
      public static function Find(param1:Array, param2:String) : TutorialGroup
      {
         var _loc3_:Object = null;
         var _loc4_:TutorialGroup = null;
         var _loc5_:TutorialGroup = null;
         for each(_loc3_ in param1)
         {
            _loc4_ = _loc3_ as TutorialGroup;
            if(_loc4_)
            {
               if(_loc4_.id == param2)
               {
                  return _loc4_;
               }
               _loc5_ = Find(_loc4_.children,param2);
               if(_loc5_ != null)
               {
                  return _loc5_;
               }
            }
         }
         return null;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.children);
      }
      
      public function ContainsTutorial(param1:TutorialStaticData) : Boolean
      {
         var _loc2_:int = this.children.indexOf(param1);
         return _loc2_ >= 0;
      }
      
      public function OnTutorialSelected(param1:TutorialStaticData) : void
      {
         var _loc2_:Object = null;
         var _loc3_:TutorialGroup = null;
         if(param1 != null)
         {
            if(param1.tutorialId == this.intro)
            {
               this.expanded = true;
            }
            else
            {
               this.expanded = this.ContainsTutorial(param1);
            }
         }
         else
         {
            this.expanded = false;
         }
         for each(_loc2_ in this.children)
         {
            _loc3_ = _loc2_ as TutorialGroup;
            if(_loc3_)
            {
               _loc3_.OnTutorialSelected(param1);
               this.expanded = this.expanded || _loc3_.expanded;
            }
         }
      }
   }
}

