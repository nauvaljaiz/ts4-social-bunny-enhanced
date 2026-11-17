package olympus.objects
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class SimIdentity extends OlympusObject
   {
      
      public var firstName:String;
      
      public var lastName:String;
      
      public var isActive:Boolean;
      
      public var simId:String;
      
      public var fullNameKey:uint;
      
      public var fullName:LocKey;
      
      public var gender:int;
      
      public function SimIdentity(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(this.fullNameKey != 0)
         {
            this.fullName = LocKey.FromHash(this.fullNameKey);
         }
      }
   }
}

