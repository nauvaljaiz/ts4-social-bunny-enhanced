package gamedata.Gameplay.RelInspector
{
   import olympus.core.OlympusObject;
   
   public class ObjectRelationshipUpdate extends OlympusObject
   {
      
      public static const TYPE_START:uint = 0;
      
      public static const TYPE_UPDATE:uint = 1;
      
      public static const TYPE_STOP:uint = 2;
      
      public var type:uint;
      
      public var target_id:String;
      
      public var value:Number;
      
      public function ObjectRelationshipUpdate(param1:Object = null)
      {
         super(param1);
      }
   }
}

