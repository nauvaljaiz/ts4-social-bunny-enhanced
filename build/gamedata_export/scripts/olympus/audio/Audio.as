package olympus.audio
{
   import olympus.io.CommunicationManager;
   
   public final class Audio
   {
      
      public static var mAudioPlayRequests:Array = new Array();
      
      public static const SHOW:String = "Show";
      
      public static const HIDE:String = "Hide";
      
      public static const CUSTOM:String = "Custom";
      
      public static const TWEEN_START:String = "TweenStart";
      
      public static const TWEEN_END:String = "TweenEnd";
      
      public static const TWEEN_FADE_IN:String = "FadeIn";
      
      public static const TWEEN_FADE_IN_SCALE_UP:String = "FadeInScaleUp";
      
      public static const TWEEN_FADE_OUT:String = "FadeOut";
      
      public static const TWEEN_FADE_OUT_SCALE_DOWN:String = "FadeOutScaleDown";
      
      public static const TWEEN_SCALE_DOWN:String = "ScaleDown";
      
      public static const TWEEN_SCALE_UP:String = "ScaleUp";
      
      public static const TWEEN_SLIDE_OUT:String = "SlideOut";
      
      public static const TWEEN_SLIDE_IN:String = "SlideIn";
      
      public static const INTERACTION_OPTION_CHANGE:String = "interactionOptionChange";
      
      public static const INTERACTION_CHANGE:String = "interactionChange";
      
      public static const INTERACTION_CANCELLED:String = "interactionCancelled";
      
      public static const INTERACTION_ADDED:String = "interactionAdded";
      
      public static const MOOD_CHANGE:String = "moodChange";
      
      public static const PANEL_POP_IN:String = "PanelPopIn";
      
      public static const PANEL_POP_OFF:String = "PanelPopOff";
      
      public static const PANEL_SLIDE_IN:String = "PanelSlideIn";
      
      public static const PANEL_SLIDE_OUT:String = "PanelSlideOut";
      
      public static const SLIDER_LIVE_CHANGE:String = "sliderLiveChange";
      
      public static const SLIDER_DRAG_START:String = "sliderDragStart";
      
      public static const SLIDER_DRAG_END:String = "sliderDragEnd";
      
      public static const DRAG_START:String = "DragStart";
      
      public static const DRAG_ENDED:String = "DragEnded";
      
      public static const DRAG_CANCELLED:String = "DragCancelled";
      
      public static const EXIT_GAME_DIAL_APPEARED:String = "ExitGameDialogAppeared";
      
      public static const EXIT_GAME_ACCEPTED:String = "ExitGameAccepted";
      
      public static const EXIT_GAME_CANCELED:String = "ExitGameCanceled";
      
      public static const GAMESPEED_SLOWDOWN:String = "SlowDown";
      
      public static const GAMESPEED_SPEEDUP:String = "SpeedUp";
      
      public static const START_PHONE_RING:String = "StartPhoneRing";
      
      public static const STOP_PHONE_RING:String = "StopPhoneRing";
      
      public static const START_PHONE_ALERT:String = "StartPhoneAlert";
      
      public static const VIDEO_CAPTURE_START:String = "VideoCaptureStart";
      
      public static const VIDEO_CAPTURE_STOP:String = "VideoCaptureStop";
      
      public static const CAS_DM_MOUSEDOWN:String = "DIRECTMANIP_MOUSEDOWN";
      
      public static const CAS_DM_MOUSERELEASE:String = "DIRECTMANIP_MOUSERELEASE";
      
      public static const CAS_DM_MOUSEBOUNDARY:String = "DIRECTMANIP_MOUSEBOUNDARY";
      
      public static const CAS_ZOOM_INTO_SIM_HEAD:String = "ZoomedIntoSimHead";
      
      public static const CAS_ZOOM_OUT_FROM_SIM_HEAD:String = "ZoomedOutFromSimHead";
      
      public static const WHIM_COMPLETE:String = "2044662077782731306";
      
      public static const EVENT_GOAL_COMPLETE:String = "17100945808991875345";
      
      public static const CHILDHOOD_INSPIRATION_ADDED:String = "17044343143802764391";
      
      public static const GE_NHD_SELECT:String = "SelectNeighborhood";
      
      public static const GE_NEW_GAME:String = "7863575508400009344";
      
      public static const GE_MOVE_IN_NEW:String = "13385783642745914432";
      
      public static const GE_MOVE_IN_EVICTION:String = "15999977831552392716";
      
      public static const GE_REINCARNATION_REAPPEAR:String = "12263964205395611570";
      
      public static const GAMESTATE_ENTER:String = "gameStateEnter";
      
      public static const GAMESTATE_LEAVE:String = "gameStateLeave";
      
      public static const GAMESTATE_SUBSTATE_TRANSITION:String = "transition";
      
      public static const GAMESTATE_SUBSTATE_TRANSITIONBATUU:String = "transitionBatuu";
      
      public static const GAMESTATE_SUBSTATE_PLAY:String = "play";
      
      public static const GAMESTATE_SUBSTATE_PLAYBATUU:String = "playBatuu";
      
      public static const GAMESTATE_SUBSTATE_BUILD:String = "build";
      
      public static const GAMESTATE_SUBSTATE_FRONTEND:String = "frontend";
      
      public static const GAMESTATE_SUBSTATE_REINCARNATION:String = "rebirth";
      
      public static const GAMESTATE_SUBSTATE_CONSTRUCTION:String = "construction";
      
      public static const GAMESTATE_SUBSTATE_BUILD_TO_NHD:String = "buildToNhd";
      
      public function Audio()
      {
         super();
      }
      
      public static function PlayAudio(param1:String) : void
      {
         mAudioPlayRequests.push(param1);
      }
      
      public static function PlayAudioImmediate(param1:String, param2:Boolean = false) : uint
      {
         return uint(CommunicationManager.CallGameService("PlayAudioImmediate",{
            "soundId":param1,
            "notifyWhenStopped":param2
         }));
      }
      
      public static function StopAudioImmediate(param1:uint) : void
      {
         CommunicationManager.CallGameService("StopAudioImmediate",{"voiceId":param1});
      }
   }
}

