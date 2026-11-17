package gamedata.Gameplay.shared.definitions
{
   import flash.utils.getDefinitionByName;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   
   public class ObjectColorStaticData extends OlympusObject
   {
      
      protected static var mStaticData:Vector.<ObjectColorStaticData>;
      
      public var palette_key:uint;
      
      public var colors:Array = [ObjectColorEntry];
      
      public var use_default:LocKey = new LocKey();
      
      public function ObjectColorStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      protected static function STATIC_DATA() : void
      {
         var _loc1_:Vector.<ObjectColorStaticData> = new Vector.<ObjectColorStaticData>();
         var _loc2_:Array = CommunicationManager.CallGameService("GetObjectColorStaticData") as Array;
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc1_.push(new ObjectColorStaticData(_loc2_[_loc4_]));
            _loc4_++;
         }
         mStaticData = _loc1_;
      }
      
      public static function GetStaticData() : Vector.<ObjectColorStaticData>
      {
         if(!mStaticData)
         {
            STATIC_DATA();
         }
         return mStaticData;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         this.use_default = FixupLocKey(this.use_default);
      }
   }
}

