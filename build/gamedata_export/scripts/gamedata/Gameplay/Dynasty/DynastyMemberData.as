package gamedata.Gameplay.Dynasty
{
   import olympus.core.OlympusObject;
   
   public class DynastyMemberData extends OlympusObject
   {
      
      public var member_id:String;
      
      public var member_rank:int;
      
      public var is_black_sheep:Boolean;
      
      public var member_pose:int;
      
      public var is_poor_performer:Boolean;
      
      public var trait_values:Array = [DynastyValueDetailData];
      
      public var career_values:Array = [DynastyValueDetailData];
      
      public var is_new_member:Boolean = false;
      
      public var scandal_time:uint = 0;
      
      public function DynastyMemberData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.trait_values);
         FixupArray(this.career_values);
      }
   }
}

