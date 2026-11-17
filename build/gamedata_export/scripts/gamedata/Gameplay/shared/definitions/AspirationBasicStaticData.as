package gamedata.Gameplay.shared.definitions
{
   import flash.utils.getDefinitionByName;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   
   public class AspirationBasicStaticData extends OlympusObject
   {
      
      public var uid:String;
      
      public var objectiveUids:Array = [String];
      
      public var numObjectives:uint;
      
      public function AspirationBasicStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function INIT_STATIC_DATA(param1:String, param2:Class) : Array
      {
         var _loc3_:Array = CommunicationManager.CallGameService(param1,null,true) as Array;
         if(!_loc3_)
         {
            return null;
         }
         var _loc4_:Array = new Array();
         var _loc5_:int = int(_loc3_.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc4_.push(new param2(_loc3_[_loc6_]));
            _loc6_++;
         }
         return _loc4_;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.objectiveUids);
         this.numObjectives = this.objectiveUids.length;
      }
   }
}

