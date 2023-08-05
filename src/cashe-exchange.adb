pragma Ada_2022;
with Ada.Strings.Wide_Wide_Hash;
package body Cashe.Exchange is

   --  TODO: looks promising: https://github.com/fawazahmed0/currency-api and
   --                         https://openexchangerates.org/
   --  It will likely be moved into its own library like Cashe.Online_Exchange
   --  For creating exchange rates.
   --  Easiest just to do this.
   function Create
      (From : Currency_Handling.Currency_Data;
       To   : ISO.Currencies.Currency;
       Rate : Decimal)
   return Exchange_Rate is
      ((From => From,
        To   => (Currency_Handling.Type_ISO_Currency, To),
        ExRate => Rate));
   function Create
      (From : Currency_Handling.Currency_Data;
       To   : ISO.Currencies.Alphabetic_Code;
       Rate : Decimal)
   return Exchange_Rate is
      ((From => From,
        To   => (Currency_Handling.Type_ISO_Currency,
                 ISO.Currencies.From_Code (To)),
        ExRate => Rate));
   function Create
      (From : Currency_Handling.Currency_Data;
       To   : Currency_Handling.Custom_Currency;
       Rate : Decimal)
   return Exchange_Rate is
      ((From => From,
        To   => (Currency_Handling.Type_Custom_Currency, To),
        ExRate => Rate));
   function Create
      (From : ISO.Currencies.Currency;
       To   : ISO.Currencies.Currency;
       Rate : Decimal)
   return Exchange_Rate is
      ((From => (Currency_Handling.Type_ISO_Currency, From),
        To   => (Currency_Handling.Type_ISO_Currency, To),
        ExRate => Rate));
   function Create
      (From : ISO.Currencies.Currency;
       To   : Currency_Handling.Custom_Currency;
       Rate : Decimal)
   return Exchange_Rate is
      ((From => (Currency_Handling.Type_ISO_Currency, From),
        To   => (Currency_Handling.Type_Custom_Currency, To),
        ExRate => Rate));
   function Create
      (From : ISO.Currencies.Currency;
       To   : ISO.Currencies.Alphabetic_Code;
       Rate : Decimal)
   return Exchange_Rate is
      ((From => (Currency_Handling.Type_ISO_Currency, From),
        To   => (Currency_Handling.Type_ISO_Currency,
                  ISO.Currencies.From_Code (To)),
        ExRate => Rate));
   function Create
      (From : ISO.Currencies.Alphabetic_Code;
       To   : ISO.Currencies.Alphabetic_Code;
       Rate : Decimal)
   return Exchange_Rate is
      ((From => (Currency_Handling.Type_ISO_Currency,
                 ISO.Currencies.From_Code (From)),
        To   => (Currency_Handling.Type_ISO_Currency,
                  ISO.Currencies.From_Code (To)),
        ExRate => Rate));
   function Create
      (From : ISO.Currencies.Alphabetic_Code;
       To   : ISO.Currencies.Currency;
       Rate : Decimal)
   return Exchange_Rate is
      ((From => (Currency_Handling.Type_ISO_Currency,
                 ISO.Currencies.From_Code (From)),
        To   => (Currency_Handling.Type_ISO_Currency, To),
        ExRate => Rate));
   function Create
      (From : ISO.Currencies.Alphabetic_Code;
       To   : Currency_Handling.Custom_Currency;
       Rate : Decimal)
   return Exchange_Rate is
      ((From => (Currency_Handling.Type_ISO_Currency,
                 ISO.Currencies.From_Code (From)),
        To   => (Currency_Handling.Type_Custom_Currency, To),
        ExRate => Rate));
   function Create
      (From : Currency_Handling.Custom_Currency;
       To   : Currency_Handling.Custom_Currency;
       Rate : Decimal)
   return Exchange_Rate is
      ((From => (Currency_Handling.Type_Custom_Currency, From),
        To   => (Currency_Handling.Type_Custom_Currency, To),
        ExRate => Rate));
   function Create
      (From : Currency_Handling.Custom_Currency;
       To   : ISO.Currencies.Currency;
       Rate : Decimal)
   return Exchange_Rate is
      ((From => (Currency_Handling.Type_Custom_Currency, From),
        To   => (Currency_Handling.Type_ISO_Currency, To),
        ExRate => Rate));
   function Create
      (From : Currency_Handling.Custom_Currency;
       To   : ISO.Currencies.Alphabetic_Code;
       Rate : Decimal)
   return Exchange_Rate is
      ((From => (Currency_Handling.Type_Custom_Currency, From),
        To   => (Currency_Handling.Type_ISO_Currency,
                  ISO.Currencies.From_Code (To)),
        ExRate => Rate));

   --  Intemediate conversion function
   --  Internal conversion function on exchange rate.
   function Internal_Convert
      (This : Exchange_Rate;
       From : Money_Handling.Money)
   return Money_Handling.Money is
      use Money_Handling;
      use Currency_Handling;
   begin
      --  If from is the same currency we need, return the inverse.
      --    This shouldn't really happen, but it MIGHT.
      if From.Get_Currency = This.From then
         return From_Major (From.As_Major * This.ExRate, This.To);
      elsif From.Get_Currency = This.To then
         return From_Major
            (From.As_Major *  Decimal (1.0 / This.ExRate), This.From);
      else
         return From_Major (0.0, This.To);
      end if;
   end Internal_Convert;

   --  Internal function
   procedure Internal_Set_Base
      (This : in out Currency_Exchange;
       Base : Currency_Handling.Currency_Data) is
   begin
      This.Base := Base;
      This.Base_Set := True;
   end Internal_Set_Base;

   procedure Set_Base
      (This : in out Currency_Exchange;
       Base : ISO.Currencies.Currency)
   is
      use Currency_Handling;
      Setter : constant Currency_Data := (Type_ISO_Currency, Base);
   begin
      Internal_Set_Base (This, Setter);
   end Set_Base;
   procedure Set_Base
      (This : in out Currency_Exchange;
       Base : ISO.Currencies.Alphabetic_Code) is
      use Currency_Handling;
      use ISO.Currencies;
      Setter : constant Currency_Data := (Type_ISO_Currency, From_Code (Base));
   begin
      Internal_Set_Base (This, Setter);
   end Set_Base;
   procedure Set_Base
      (This : in out Currency_Exchange;
       Base : Currency_Handling.Custom_Currency)
   is
      use Currency_Handling;
      Setter : constant Currency_Data := (Type_Custom_Currency, Base);
   begin
      Internal_Set_Base (This, Setter);
   end Set_Base;
   function Base_Is_Set (This : Currency_Exchange) return Boolean is
      (This.Base_Set);
   --  Internal version
   procedure Internal_Set_Rate
      (This : in out Currency_Exchange;
       Item : Exchange_Rate)
   is
      Inverse : constant Exchange_Rate :=
         (From   => Item.To,
          To     => Item.From,
          ExRate => Decimal (1.0 / (if Item.ExRate /= 0.0 then
                                    Item.ExRate else 1.0)));
   begin
      --  Insert the current item
      if This.Exchange.Contains (Item.From) then
         This.Exchange (Item.From).Include (Item.To, Item);
      else
         declare
            Initial_Map : To_Map.Map;
         begin
            Initial_Map.Include (Item.To, Item);
            This.Exchange.Include (Item.From, Initial_Map);
         end;
      end if;
      --  Insert the inverse if a record does not already exist
      if This.Exchange.Contains (Inverse.From) then
         if not This.Exchange (Inverse.From).Contains (Inverse.To) then
            This.Exchange (Inverse.From).Include (Inverse.To, Inverse);
         end if;
      else
         declare
            Initial_Map : To_Map.Map;
         begin
            Initial_Map.Include (Inverse.To, Inverse);
            This.Exchange.Include (Inverse.From, Initial_Map);
         end;
      end if;
   end Internal_Set_Rate;

   procedure Set_Rate
      (This : in out Currency_Exchange;
       From : ISO.Currencies.Currency;
       To   : Currency_Handling.Custom_Currency;
       Rate : Decimal)
   is
      Setter : constant Exchange_Rate := Create (From, To, Rate);
   begin
      Internal_Set_Rate (This, Setter);
   end Set_Rate;
   procedure Set_Rate
      (This : in out Currency_Exchange;
       From : ISO.Currencies.Currency;
       To   : ISO.Currencies.Currency;
       Rate : Decimal)
   is
      Setter : constant Exchange_Rate := Create (From, To, Rate);
   begin
      Internal_Set_Rate (This, Setter);
   end Set_Rate;
   procedure Set_Rate
      (This : in out Currency_Exchange;
       From : ISO.Currencies.Currency;
       To   : ISO.Currencies.Alphabetic_Code;
       Rate : Decimal)
   is
      Setter : constant Exchange_Rate := Create (From, To, Rate);
   begin
      Internal_Set_Rate (This, Setter);
   end Set_Rate;
   procedure Set_Rate
      (This : in out Currency_Exchange;
       From : ISO.Currencies.Alphabetic_Code;
       To   : ISO.Currencies.Alphabetic_Code;
       Rate : Decimal)
   is
      Setter : constant Exchange_Rate := Create (From, To, Rate);
   begin
      Internal_Set_Rate (This, Setter);
   end Set_Rate;
   procedure Set_Rate
      (This : in out Currency_Exchange;
       From : ISO.Currencies.Alphabetic_Code;
       To   : ISO.Currencies.Currency;
       Rate : Decimal)
   is
      Setter : constant Exchange_Rate := Create (From, To, Rate);
   begin
      Internal_Set_Rate (This, Setter);
   end Set_Rate;
   procedure Set_Rate
      (This : in out Currency_Exchange;
       From : ISO.Currencies.Alphabetic_Code;
       To   : Currency_Handling.Custom_Currency;
       Rate : Decimal)
   is
      Setter : constant Exchange_Rate := Create (From, To, Rate);
   begin
      Internal_Set_Rate (This, Setter);
   end Set_Rate;
   procedure Set_Rate
      (This : in out Currency_Exchange;
       From : Currency_Handling.Custom_Currency;
       To   : Currency_Handling.Custom_Currency;
       Rate : Decimal)
   is
      Setter : constant Exchange_Rate := Create (From, To, Rate);
   begin
      Internal_Set_Rate (This, Setter);
   end Set_Rate;
   procedure Set_Rate
      (This : in out Currency_Exchange;
       From : Currency_Handling.Custom_Currency;
       To   : ISO.Currencies.Currency;
       Rate : Decimal)
   is
      Setter : constant Exchange_Rate := Create (From, To, Rate);
   begin
      Internal_Set_Rate (This, Setter);
   end Set_Rate;
   procedure Set_Rate
      (This : in out Currency_Exchange;
       From : Currency_Handling.Custom_Currency;
       To   : ISO.Currencies.Alphabetic_Code;
       Rate : Decimal)
   is
      Setter : constant Exchange_Rate := Create (From, To, Rate);
   begin
      Internal_Set_Rate (This, Setter);
   end Set_Rate;

   --  These can be used if the base is enabled.
   procedure Set_Rate
      (This : in out Currency_Exchange;
         To   : Currency_Handling.Custom_Currency;
         Rate : Decimal)
   is
      use Currency_Handling;
   begin
      case This.Base.Which_Currency_Type is
         when Type_Custom_Currency =>
            Internal_Set_Rate (This, Create (This.Base.Custom_Code, To, Rate));
         when Type_ISO_Currency =>
            Internal_Set_Rate (This, Create (This.Base.ISO_Code, To, Rate));
      end case;
   end Set_Rate;
   procedure Set_Rate
      (This : in out Currency_Exchange;
       To   : ISO.Currencies.Currency;
       Rate : Decimal)
   is
      use Currency_Handling;
   begin
      case This.Base.Which_Currency_Type is
         when Type_Custom_Currency =>
            Internal_Set_Rate (This, Create (This.Base.Custom_Code, To, Rate));
         when Type_ISO_Currency =>
            Internal_Set_Rate (This, Create (This.Base.ISO_Code, To, Rate));
      end case;
   end Set_Rate;
   procedure Set_Rate
      (This : in out Currency_Exchange;
       To   : ISO.Currencies.Alphabetic_Code;
       Rate : Decimal)
   is
      use Currency_Handling;
   begin
      case This.Base.Which_Currency_Type is
         when Type_Custom_Currency =>
            Internal_Set_Rate (This, Create (This.Base.Custom_Code, To, Rate));
         when Type_ISO_Currency =>
            Internal_Set_Rate (This, Create (This.Base.ISO_Code, To, Rate));
      end case;
   end Set_Rate;

   function Internal_Search_Rate
      (This : Currency_Exchange;
       Search : Exchange_Rate)
   return Exchange_Rate is begin
      if This.Exchange.Contains (Search.From) and then
            This.Exchange (Search.From).Contains (Search.To)
      then
         --  Return the found exchange rate.
         return This.Exchange (Search.From).Element (Search.To);
      else
         --  Return an empty exchange rate.
         return (Search.From, Search.To, 0.0);
      end if;
   end Internal_Search_Rate;

   function Rate
      (This : Currency_Exchange;
       From : ISO.Currencies.Currency;
       To   : ISO.Currencies.Currency)
   return Decimal is
      Search : constant Exchange_Rate := Create (From, To, 0.0);
   begin
      return Internal_Search_Rate (This, Search).ExRate;
   end Rate;
   function Rate
      (This : Currency_Exchange;
       From : ISO.Currencies.Currency;
       To   : Currency_Handling.Custom_Currency)
   return Decimal is
      Search : constant Exchange_Rate := Create (From, To, 0.0);
   begin
      return Internal_Search_Rate (This, Search).ExRate;
   end Rate;
   function Rate
      (This : Currency_Exchange;
       From : ISO.Currencies.Currency;
       To   : ISO.Currencies.Alphabetic_Code)
   return Decimal is
      Search : constant Exchange_Rate := Create (From, To, 0.0);
   begin
      return Internal_Search_Rate (This, Search).ExRate;
   end Rate;
   function Rate
      (This : Currency_Exchange;
       From : ISO.Currencies.Alphabetic_Code;
       To   : ISO.Currencies.Alphabetic_Code)
   return Decimal is
      Search : constant Exchange_Rate := Create (From, To, 0.0);
   begin
      return Internal_Search_Rate (This, Search).ExRate;
   end Rate;
   function Rate
      (This : Currency_Exchange;
       From : ISO.Currencies.Alphabetic_Code;
       To   : ISO.Currencies.Currency)
   return Decimal is
      Search : constant Exchange_Rate := Create (From, To, 0.0);
   begin
      return Internal_Search_Rate (This, Search).ExRate;
   end Rate;
   function Rate
      (This : Currency_Exchange;
       From : ISO.Currencies.Alphabetic_Code;
       To   : Currency_Handling.Custom_Currency)
   return Decimal is
      Search : constant Exchange_Rate := Create (From, To, 0.0);
   begin
      return Internal_Search_Rate (This, Search).ExRate;
   end Rate;
   function Rate
      (This : Currency_Exchange;
       From : Currency_Handling.Custom_Currency;
       To   : Currency_Handling.Custom_Currency)
   return Decimal is
      Search : constant Exchange_Rate := Create (From, To, 0.0);
   begin
      return Internal_Search_Rate (This, Search).ExRate;
   end Rate;
   function Rate
      (This : Currency_Exchange;
       From : Currency_Handling.Custom_Currency;
       To   : ISO.Currencies.Currency)
   return Decimal is
      Search : constant Exchange_Rate := Create (From, To, 0.0);
   begin
      return Internal_Search_Rate (This, Search).ExRate;
   end Rate;
   function Rate
      (This : Currency_Exchange;
       From : Currency_Handling.Custom_Currency;
       To   : ISO.Currencies.Alphabetic_Code)
   return Decimal is
      Search : constant Exchange_Rate := Create (From, To, 0.0);
   begin
      return Internal_Search_Rate (This, Search).ExRate;
   end Rate;
   function Rate
      (This : Currency_Exchange;
       To   : Currency_Handling.Custom_Currency)
   return Decimal is
      Search : constant Exchange_Rate := Create (This.Base, To, 0.0);
   begin
      return Internal_Search_Rate (This, Search).ExRate;
   end Rate;
   function Rate
      (This : Currency_Exchange;
       To   : ISO.Currencies.Currency)
   return Decimal is
      Search : constant Exchange_Rate := Create (This.Base, To, 0.0);
   begin
      return Internal_Search_Rate (This, Search).ExRate;
   end Rate;
   function Rate
      (This : Currency_Exchange;
       To   : ISO.Currencies.Alphabetic_Code)
   return Decimal is
      Search : constant Exchange_Rate := Create (This.Base, To, 0.0);
   begin
      return Internal_Search_Rate (This, Search).ExRate;
   end Rate;

   --  Validate if a conversion is in the exchange
   function Contains
      (This : Currency_Exchange;
       From : ISO.Currencies.Currency;
       To   : ISO.Currencies.Currency)
   return Boolean is (This.Rate (From, To) > 0.0);
   function Contains
      (This : Currency_Exchange;
       From : ISO.Currencies.Currency;
       To   : Currency_Handling.Custom_Currency)
   return Boolean is (This.Rate (From, To) > 0.0);
   function Contains
      (This : Currency_Exchange;
       From : ISO.Currencies.Currency;
       To   : ISO.Currencies.Alphabetic_Code)
   return Boolean is (This.Rate (From, To) > 0.0);
   function Contains
      (This : Currency_Exchange;
       From : ISO.Currencies.Alphabetic_Code;
       To   : ISO.Currencies.Alphabetic_Code)
   return Boolean is (This.Rate (From, To) > 0.0);
   function Contains
      (This : Currency_Exchange;
       From : ISO.Currencies.Alphabetic_Code;
       To   : ISO.Currencies.Currency)
   return Boolean is (This.Rate (From, To) > 0.0);
   function Contains
      (This : Currency_Exchange;
       From : ISO.Currencies.Alphabetic_Code;
       To   : Currency_Handling.Custom_Currency)
   return Boolean is (This.Rate (From, To) > 0.0);
   function Contains
      (This : Currency_Exchange;
       From : Currency_Handling.Custom_Currency;
       To   : Currency_Handling.Custom_Currency)
   return Boolean is (This.Rate (From, To) > 0.0);
   function Contains
      (This : Currency_Exchange;
       From : Currency_Handling.Custom_Currency;
       To   : ISO.Currencies.Currency)
   return Boolean is (This.Rate (From, To) > 0.0);
   function Contains
      (This : Currency_Exchange;
       From : Currency_Handling.Custom_Currency;
       To   : ISO.Currencies.Alphabetic_Code)
   return Boolean is (This.Rate (From, To) > 0.0);

   function Convert
      (This : Currency_Exchange;
       From : Money_Handling.Money;
       To   : ISO.Currencies.Currency)
   return Money_Handling.Money
   is
      use Currency_Handling;
      ExRate : constant Exchange_Rate :=
               (case From.Get_Currency.Which_Currency_Type is
                when Type_Custom_Currency =>
                  Internal_Search_Rate
                     (This, Create (From.Get_Currency.Custom_Code,
                                    To, 0.0)),

                when Type_ISO_Currency =>
                  Internal_Search_Rate
                     (This, Create (From.Get_Currency.ISO_Code,
                                    To, 0.0)));

   begin
      return Internal_Convert (ExRate, From);
   end Convert;
   function Convert
      (This : Currency_Exchange;
       From : Money_Handling.Money;
       To   : ISO.Currencies.Alphabetic_Code)
   return Money_Handling.Money
   is
      use Currency_Handling;
      ExRate : constant Exchange_Rate :=
               (case From.Get_Currency.Which_Currency_Type is
                when Type_Custom_Currency =>
                  Internal_Search_Rate
                     (This, Create (From.Get_Currency.Custom_Code,
                                    To, 0.0)),

                when Type_ISO_Currency =>
                  Internal_Search_Rate
                     (This, Create (From.Get_Currency.ISO_Code,
                                    To, 0.0)));

   begin
      return Internal_Convert (ExRate, From);
   end Convert;
   function Convert
      (This : Currency_Exchange;
       From : Money_Handling.Money;
       To   : Currency_Handling.Custom_Currency)
   return Money_Handling.Money
   is
      use Currency_Handling;
      ExRate : constant Exchange_Rate :=
               (case From.Get_Currency.Which_Currency_Type is
                when Type_Custom_Currency =>
                  Internal_Search_Rate
                     (This, Create (From.Get_Currency.Custom_Code,
                                    To, 0.0)),

                when Type_ISO_Currency =>
                  Internal_Search_Rate
                     (This, Create (From.Get_Currency.ISO_Code,
                                    To, 0.0)));

   begin
      return Internal_Convert (ExRate, From);
   end Convert;

   function Exchange_Hashed (Item : Currency_Handling.Currency_Data)
      return Ada.Containers.Hash_Type
   is
      use Currency_Handling;
      use Ada.Containers;
      use ISO.Currencies;
   begin
      case Item.Which_Currency_Type is
         when Type_ISO_Currency =>
            return Hash_Type (Currency_Key'Pos (Item.ISO_Code.Key));
         when Type_Custom_Currency =>
               return Ada.Strings.Wide_Wide_Hash
                        (Item.Custom_Code.Code &
                         Item.Custom_Code.Name &
                         Item.Custom_Code.Symbol &
                         Item.Custom_Code.Unit'Wide_Wide_Image);
      end case;
   end Exchange_Hashed;

end Cashe.Exchange;