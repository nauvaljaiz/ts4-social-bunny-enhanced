package gamedata.Gameplay.SimInfoHUD
{
   import gamedata.Gameplay.shared.definitions.TraitsStaticData;
   import olympus.core.OlympusObject;
   
   public class LifeSkillTrait extends OlympusObject
   {
      
      public var trait_id:String;
      
      public var lower_bound:Number;
      
      public var upper_bound:Number;
      
      public var traitData:TraitsStaticData;
      
      public function LifeSkillTrait(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         this.traitData = TraitsStaticData.GetStaticData(this.trait_id);
      }
   }
}

