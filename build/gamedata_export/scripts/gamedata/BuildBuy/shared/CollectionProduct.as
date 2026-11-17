package gamedata.BuildBuy.shared
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class CollectionProduct extends OlympusObject
   {
      
      public var resourceKey:ResourceKey;
      
      public var name:LocKey;
      
      public var desc:LocKey;
      
      public var customName:String;
      
      public var customDesc:String;
      
      public var packId:int;
      
      public function CollectionProduct(param1:Object)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         this.resourceKey = new ResourceKey(param1.resourceKey);
         this.name = new LocKey(param1.name);
         this.desc = new LocKey(param1.desc);
         this.packId = param1.packId;
         this.customName = param1["customName"];
         this.customDesc = param1["customDesc"];
      }
      
      public function get Name() : String
      {
         var _loc1_:Object = null;
         if(this.customName)
         {
            return this.customName;
         }
         if(Boolean(this.name.tokens) && Boolean(this.name.tokens.length))
         {
            _loc1_ = this.name.tokens[0];
            if(_loc1_.catalog_name_key)
            {
               return this.name.toString();
            }
         }
         return "";
      }
      
      public function get Description() : String
      {
         var _loc1_:Object = null;
         if(this.customDesc)
         {
            return this.customDesc;
         }
         if(Boolean(this.desc.tokens) && Boolean(this.desc.tokens.length))
         {
            _loc1_ = this.desc.tokens[0];
            if(_loc1_.catalog_description_key)
            {
               return this.desc.toString();
            }
         }
         return "";
      }
   }
}

