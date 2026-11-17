package gamedata.Exchange
{
   import olympus.core.OlympusObject;
   import olympus.localization.Keys;
   import olympus.localization.KeysEXCH;
   
   public class StatsTickerData extends OlympusObject
   {
      
      public static const TYPE_PLAYERS_ONLINE:int = 0;
      
      public static const TYPE_TOTAL_UPLOADS:int = 1;
      
      public static const TYPE_TOTAL_HOUSES:int = 2;
      
      public static const TYPE_TOTAL_HOUSEHOLDS:int = 3;
      
      public static const TYPE_TOTAL_VENUES:int = 4;
      
      public static const TYPE_TOTAL_ROOMS:int = 5;
      
      public static const TYPE_MY_HOUSEHOLDS:int = 6;
      
      public static const TYPE_MY_HOUSES:int = 7;
      
      public static const TYPE_MY_VENUES:int = 8;
      
      public static const TYPE_MY_ROOMS:int = 9;
      
      public static const TYPE_TOTAL_PARTS:int = 10;
      
      public static const TYPE_MY_PARTS:int = 11;
      
      protected static const STAT_ICON_PLAYERS:String = "0xfbda8ae82874b7e3";
      
      protected static const STAT_ICON_HOUSES:String = "0xf7f15df3ca4dfb20";
      
      protected static const STAT_ICON_HOUSEHOLDS:String = "0x19c87d0952f9f591";
      
      protected static const STAT_ICON_ROOMS:String = "0x6eeadeaf1ebcc441";
      
      protected static const STAT_ICON_VENUES:String = "0x2c76fd2f69745b77";
      
      protected static const STAT_ICON_GENERIC:String = "0x4a5a0ce06888cc06";
      
      protected static const STAT_ICON_PARTS:String = "0x6eeadeaf1ebcc441";
      
      public var type:int;
      
      public var value:int;
      
      public var iconId:String;
      
      public var valueText:String;
      
      public var descriptionText:String;
      
      public function StatsTickerData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         this.iconId = this.GetStatIcon();
         this.valueText = this.GetStatValue();
         this.descriptionText = this.GetStatDescription();
      }
      
      protected function GetStatIcon() : String
      {
         switch(this.type)
         {
            case TYPE_PLAYERS_ONLINE:
               return STAT_ICON_PLAYERS;
            case TYPE_TOTAL_HOUSES:
            case TYPE_MY_HOUSES:
               return STAT_ICON_HOUSES;
            case TYPE_TOTAL_HOUSEHOLDS:
            case TYPE_MY_HOUSEHOLDS:
               return STAT_ICON_HOUSEHOLDS;
            case TYPE_TOTAL_ROOMS:
            case TYPE_MY_ROOMS:
               return STAT_ICON_ROOMS;
            case TYPE_TOTAL_VENUES:
            case TYPE_MY_VENUES:
               return STAT_ICON_VENUES;
            case TYPE_TOTAL_PARTS:
            case TYPE_MY_PARTS:
               return STAT_ICON_PARTS;
            case TYPE_TOTAL_UPLOADS:
         }
         return STAT_ICON_GENERIC;
      }
      
      protected function GetStatValue() : String
      {
         return Keys.GENERIC_NUMBER.toString(this.value);
      }
      
      protected function GetStatDescription() : String
      {
         switch(this.type)
         {
            case TYPE_PLAYERS_ONLINE:
               return KeysEXCH.STATS_TICKER_PLAYERS_ONLINE.toString(this.value);
            case TYPE_TOTAL_UPLOADS:
               return KeysEXCH.STATS_TICKER_TOTAL_UPLOADS.toString(this.value);
            case TYPE_TOTAL_HOUSES:
               return KeysEXCH.STATS_TICKER_ONLINE_TOTAL_BP.toString(this.value);
            case TYPE_TOTAL_HOUSEHOLDS:
               return KeysEXCH.STATS_TICKER_ONLINE_TOTAL_HH.toString(this.value);
            case TYPE_TOTAL_VENUES:
               return KeysEXCH.STATS_TICKER_ONLINE_TOTAL_VENUE.toString(this.value);
            case TYPE_TOTAL_PARTS:
               return KeysEXCH.STATS_TICKER_ONLINE_TOTAL_PARTS.toString(this.value);
            case TYPE_TOTAL_ROOMS:
               return KeysEXCH.STATS_TICKER_ONLINE_TOTAL_RM.toString(this.value);
            case TYPE_MY_HOUSEHOLDS:
               return KeysEXCH.STATS_TICKER_OFFLINE_TOTAL_HH.toString(this.value);
            case TYPE_MY_HOUSES:
               return KeysEXCH.STATS_TICKER_OFFLINE_TOTAL_BP.toString(this.value);
            case TYPE_MY_VENUES:
               return KeysEXCH.STATS_TICKER_OFFLINE_TOTAL_VENUE.toString(this.value);
            case TYPE_MY_ROOMS:
               return KeysEXCH.STATS_TICKER_OFFLINE_TOTAL_RM.toString(this.value);
            case TYPE_MY_PARTS:
               return KeysEXCH.STATS_TICKER_OFFLINE_TOTAL_PARTS.toString(this.value);
            default:
               return "";
         }
      }
   }
}

