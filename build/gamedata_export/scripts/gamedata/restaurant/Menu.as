package gamedata.restaurant
{
   import olympus.core.OlympusObject;
   
   public class Menu extends OlympusObject
   {
      
      public var courses:Array = [Course];
      
      public function Menu(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.courses);
         this.courses = Course.SortCourses(this.courses);
      }
   }
}

