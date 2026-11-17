package gamedata.CAS.shared
{
   public class CreateSimOps
   {
      
      protected static const SIMOP_CREATE_FROM_SCRATCH:int = 0;
      
      protected static const SIMOP_UPDATE_GENETICS:int = 1;
      
      protected static const SIMOP_DEFAULT_TO_ALT_FORM:int = 2;
      
      protected static const SIMOP_CREATE_AS_CAS_STORY:int = 3;
      
      public static const SIMOPFLAG_CREATE_FROM_SCRATCH:int = 1 << SIMOP_CREATE_FROM_SCRATCH;
      
      public static const SIMOPFLAG_UPDATE_GENETICS:int = 1 << SIMOP_UPDATE_GENETICS;
      
      public static const SIMOPFLAG_DEFAULT_TO_ALT_FORM:int = 1 << SIMOP_DEFAULT_TO_ALT_FORM;
      
      public static const SIMOPFLAG_CREATE_AS_CAS_STORY:int = 1 << SIMOP_CREATE_AS_CAS_STORY;
      
      public static const SIMOPFLAG_GENETICS_NEW:int = SIMOPFLAG_CREATE_FROM_SCRATCH | SIMOPFLAG_UPDATE_GENETICS;
      
      public static const SIMOPFLAG_DEFAULT_TO_ALT_FORM_NEW:int = SIMOPFLAG_CREATE_FROM_SCRATCH | SIMOPFLAG_DEFAULT_TO_ALT_FORM;
      
      public static const SIMOPFLAG_CAS_STORIES:int = SIMOPFLAG_CREATE_FROM_SCRATCH | SIMOPFLAG_CREATE_AS_CAS_STORY;
      
      public function CreateSimOps()
      {
         super();
      }
   }
}

