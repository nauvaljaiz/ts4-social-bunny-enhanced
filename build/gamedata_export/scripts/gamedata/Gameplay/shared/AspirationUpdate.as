package gamedata.Gameplay.shared
{
   import olympus.core.OlympusObject;
   
   public class AspirationUpdate extends OlympusObject
   {
      
      public var aspirations_completed:Array;
      
      public var unlocked_hidden_aspiration_tracks:Array;
      
      public var objectives_completed:Array;
      
      public var objectives_reset:Array;
      
      public var sim_id:String;
      
      public function AspirationUpdate(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         this.sim_id = param1.sim_id;
         this.aspirations_completed = new Array();
         if("aspirations_completed" in param1)
         {
            ConstructArrayFromArray(this.aspirations_completed,param1.aspirations_completed,String);
         }
         this.unlocked_hidden_aspiration_tracks = new Array();
         if("unlocked_hidden_aspiration_tracks" in param1)
         {
            ConstructArrayFromArray(this.unlocked_hidden_aspiration_tracks,param1.unlocked_hidden_aspiration_tracks,String);
         }
         this.objectives_completed = new Array();
         if("objectives_completed" in param1)
         {
            ConstructArrayFromArray(this.objectives_completed,param1.objectives_completed,String);
         }
         this.objectives_reset = new Array();
         if("objectives_reset" in param1)
         {
            ConstructArrayFromArray(this.objectives_reset,param1.objectives_reset,String);
         }
      }
      
      public function MergeAspirationUpdates(param1:AspirationUpdate) : void
      {
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc2_:Array = param1.aspirations_completed;
         if(_loc2_.length != 0)
         {
            this.aspirations_completed = this.aspirations_completed.concat(_loc2_);
         }
         _loc2_ = param1.unlocked_hidden_aspiration_tracks;
         if(_loc2_.length != 0)
         {
            this.unlocked_hidden_aspiration_tracks = this.unlocked_hidden_aspiration_tracks.concat(_loc2_);
         }
         var _loc3_:Array = param1.objectives_completed;
         if(_loc3_.length != 0)
         {
            this.objectives_completed = this.objectives_completed.concat(_loc3_);
         }
         var _loc4_:Array = param1.objectives_reset;
         if(_loc4_.length != 0)
         {
            for each(_loc5_ in _loc4_)
            {
               _loc6_ = this.objectives_completed.indexOf(_loc5_);
               if(_loc6_ != -1)
               {
                  this.objectives_completed.splice(_loc6_,1);
               }
            }
         }
      }
   }
}

