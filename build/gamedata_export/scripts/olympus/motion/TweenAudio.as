package olympus.motion
{
   import flash.utils.getQualifiedClassName;
   import olympus.audio.Audio;
   import olympus.extensions.AudioExtension;
   import olympus.interfaces.IExtendable;
   import olympus.io.EventManager;
   
   public class TweenAudio
   {
      
      public var styleName:String = "Custom";
      
      public var targetName:String;
      
      public function TweenAudio()
      {
         super();
      }
      
      public function DispatchStart(param1:Object) : void
      {
         if(this.styleName == "Custom" && !this.targetName)
         {
            return;
         }
         this.ResolveTargetName(param1);
         EventManager.DispatchAnimationEvent(Audio.TWEEN_START,this.styleName,this.targetName);
      }
      
      public function DispatchEnd(param1:Object) : void
      {
         if(this.styleName == "Custom" && !this.targetName)
         {
            return;
         }
         this.ResolveTargetName(param1);
         EventManager.DispatchAnimationEvent(Audio.TWEEN_END,this.styleName,this.targetName);
      }
      
      protected function ResolveTargetName(param1:Object) : void
      {
         var _loc2_:IExtendable = null;
         var _loc3_:AudioExtension = null;
         if(!this.targetName)
         {
            _loc2_ = param1 as IExtendable;
            _loc3_ = (_loc2_ && _loc2_.GetExtension(AudioExtension,false)) as AudioExtension;
            if(_loc3_)
            {
               this.targetName = _loc3_.ElementName;
            }
            else
            {
               this.targetName = getQualifiedClassName(param1).split("::",2).pop();
            }
         }
      }
   }
}

