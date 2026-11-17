package gamedata.Gameplay.shared
{
   import flash.utils.Dictionary;
   import olympus.core.OlympusObject;
   
   public class VirtualCareer extends OlympusObject
   {
      
      public var sim_id:String;
      
      public var career_panel_type:String;
      
      public var show_when_no_careers:Boolean;
      
      public var extra_data:Object = null;
      
      public function VirtualCareer(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         var _loc2_:Object = null;
         super.ParseObject(param1);
         if("extra_data" in param1)
         {
            this.extra_data = new Dictionary();
            for each(_loc2_ in param1.extra_data)
            {
               this.extra_data[_loc2_.key] = _loc2_.value;
            }
         }
      }
   }
}

