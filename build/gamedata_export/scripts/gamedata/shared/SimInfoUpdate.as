package gamedata.shared
{
   import olympus.core.OlympusObject;
   
   public class SimInfoUpdate extends OlympusObject
   {
      
      public var simId:String;
      
      public var firstName:String;
      
      public var lastName:String;
      
      public var isAlive:Boolean;
      
      public function SimInfoUpdate(param1:Object = null)
      {
         super(param1);
      }
   }
}

