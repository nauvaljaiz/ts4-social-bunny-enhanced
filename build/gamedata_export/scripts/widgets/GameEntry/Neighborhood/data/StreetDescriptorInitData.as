package widgets.GameEntry.Neighborhood.data
{
   public class StreetDescriptorInitData
   {
      
      public static const STYLE_NORMAL:String = "normal";
      
      public static const STYLE_FESTIVAL:String = "festival";
      
      public var mIcon:String;
      
      public var mName:String;
      
      public var mDescription:String;
      
      public var mBackColor:uint;
      
      public var mFontNameColor:uint;
      
      public var mFontDescColor:uint;
      
      public var mImage:String;
      
      public var mStyle:String;
      
      public function StreetDescriptorInitData(param1:String, param2:String, param3:String, param4:uint, param5:uint, param6:uint, param7:String = "0", param8:String = "normal")
      {
         super();
         this.mIcon = param1;
         this.mName = param2;
         this.mDescription = param3;
         this.mBackColor = param4;
         this.mFontNameColor = param5;
         this.mFontDescColor = param6;
         this.mImage = param7;
         this.mStyle = param8;
      }
   }
}

