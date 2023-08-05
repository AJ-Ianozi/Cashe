pragma Ada_2022;
pragma Assertion_Policy (Check);
with ISO.Currencies;
with Cashe.Currency_Handling;
with Cashe.Money_Handling;
with Ada.Containers.Hashed_Maps;
--  ****h* Cashe/Exchange
--  SOURCE
package Cashe.Exchange is
--  DESCRIPTION
--    This package provides the ability to utilize a currency exchange.
--  ****

   --  ****c* Exchange/Exchange.Currency_Exchange
   --  SOURCE
   type Currency_Exchange is tagged private;
   --  DESCRIPTION
   --    An exchange containing various currencies and their conversions.
   --  USAGE
   --    declare
   --       My_Exchange : Currency_Exchange;
   --    begin
   --       My_Exchange.Set_Rate ("USD", "GBP", 0.5);
   --       --  Print £ 50.00 from a provided $ 100.00
   --       Put_Line
   --          (My_Exchange.Convert
   --             (From => From_Minor (100_00, "GBP"),
   --              To   => "USD")'Image
   --          );
   --    end;
   --  METHODS
   --  * Exchange.Currency_Exchange/Set_Base
   --  * Exchange.Currency_Exchange/Base_Is_Set
   --  * Exchange.Currency_Exchange/Set_Rate
   --  * Exchange.Currency_Exchange/Convert
   --  * Exchange.Currency_Exchange/Contains
   --  * Exchange.Currency_Exchange/Rate
   --  ****

   --  ****m* Exchange.Currency_Exchange/Set_Base
   --  SOURCE
   procedure Set_Base
      (This : in out Currency_Exchange;
       --  The currency exchange to set the base for
       Base : ISO.Currencies.Currency
       --  The base currency to set the exchange to
      );
   procedure Set_Base
      (This : in out Currency_Exchange;
       --  The currency exchange to set the base for
       Base : ISO.Currencies.Alphabetic_Code
       --  The base currency to set the exchange to
      );
   procedure Set_Base
      (This : in out Currency_Exchange;
       --  The currency exchange to set the base for
       Base : Currency_Handling.Custom_Currency
       --  The base currency to set the exchange to
      );
   --  FUNCTION
   --    Set the default base for the currency exchange.  Once this is called,
   --    "from" will no longer have to be passed when setting the rate.
   --  PARAMETERS
   --    Base - The currency to set the exchange to. Either custom or ISO
   --  EXAMPLE
   --    declare
   --       US_Exchange : Currency_Exchange;
   --    begin
   --       US_Exchange.Set_Base ("USD");
   --       --  Set USD:GBP to 1:0.5
   --       US_Exchange.Set_Rate ("GBP", 0.5);
   --       --  Set USD:BTC to 1:0.0000331163
   --       US_Exchange.Set_Rate (Bitcoin, 0.0000331163);
   --    end;
   --  SEE ALSO
   --    * Exchange.Currency_Exchange/Base_Is_Set
   --    * Exchange.Currency_Exchange/Set_Rate
   --  ****

   --  ****m* Exchange.Currency_Exchange/Base_Is_Set
   --  SOURCE
   function Base_Is_Set (This : Currency_Exchange) return Boolean;
   --  FUNCTION
   --    Quries if a base is set or not.
   --  RETURN VALUE
   --    Boolean:
   --      * True if a base has been set
   --      * False if a base has not been set
   --  EXAMPLE
   --    if not US_Exchange.Base_Is_Set then
   --       US_Exchange.Set_Base ("USD");
   --    end if;
   --  ****

   --  ****m* Exchange.Currency_Exchange/Set_Rate
   --  SOURCE
   procedure Set_Rate
      (This : in out Currency_Exchange;
       --  The currency exchange to set the rate in
       From : ISO.Currencies.Currency;
       --  The currency to convert from
       To   : ISO.Currencies.Currency;
       --  The currency to convert to
       Rate : Decimal
       --  The exchange rate, in decimal format.
      );
   procedure Set_Rate
      (This : in out Currency_Exchange;
       --  The currency exchange to set the rate in
       From : ISO.Currencies.Currency;
       --  The currency to convert from
       To   : ISO.Currencies.Alphabetic_Code;
       --  The currency to convert to
       Rate : Decimal
       --  The exchange rate, in decimal format.
      );
   procedure Set_Rate
      (This : in out Currency_Exchange;
       --  The currency exchange to set the rate in
       From : ISO.Currencies.Currency;
       --  The currency to convert from
       To   : Currency_Handling.Custom_Currency;
       --  The currency to convert to
       Rate : Decimal
       --  The exchange rate, in decimal format.
      );
   procedure Set_Rate
      (This : in out Currency_Exchange;
       --  The currency exchange to set the rate in
       From : ISO.Currencies.Alphabetic_Code;
       --  The currency to convert from
       To   : ISO.Currencies.Alphabetic_Code;
       --  The currency to convert to
       Rate : Decimal
       --  The exchange rate, in decimal format.
      );
   procedure Set_Rate
      (This : in out Currency_Exchange;
       --  The currency exchange to set the rate in
       From : ISO.Currencies.Alphabetic_Code;
       --  The currency to convert from
       To   : ISO.Currencies.Currency;
       --  The currency to convert to
       Rate : Decimal
       --  The exchange rate, in decimal format.
      );
   procedure Set_Rate
      (This : in out Currency_Exchange;
       --  The currency exchange to set the rate in
       From : ISO.Currencies.Alphabetic_Code;
       --  The currency to convert from
       To   : Currency_Handling.Custom_Currency;
       --  The currency to convert to
       Rate : Decimal
       --  The exchange rate, in decimal format.
      );
   procedure Set_Rate
      (This : in out Currency_Exchange;
       --  The currency exchange to set the rate in
       From : Currency_Handling.Custom_Currency;
       --  The currency to convert from
       To   : Currency_Handling.Custom_Currency;
       --  The currency to convert to
       Rate : Decimal
       --  The exchange rate, in decimal format.
      );
   procedure Set_Rate
      (This : in out Currency_Exchange;
       --  The currency exchange to set the rate in
       From : Currency_Handling.Custom_Currency;
       --  The currency to convert from
       To   : ISO.Currencies.Currency;
       --  The currency to convert to
       Rate : Decimal
       --  The exchange rate, in decimal format.
      );
   procedure Set_Rate
      (This : in out Currency_Exchange;
       --  The currency exchange to set the rate in
       From : Currency_Handling.Custom_Currency;
       --  The currency to convert from
       To   : ISO.Currencies.Alphabetic_Code;
       --  The currency to convert to
       Rate : Decimal
       --  The exchange rate, in decimal format.
      );
   --  These can be used if the base is enabled.
   procedure Set_Rate
      (This : in out Currency_Exchange;
       --  The currency exchange to set the rate in
       To   : Currency_Handling.Custom_Currency;
       --  The currency to convert to
       Rate : Decimal
       --  The exchange rate, in decimal format.
      ) with pre => This.Base_Is_Set;
   procedure Set_Rate
      (This : in out Currency_Exchange;
       --  The currency exchange to set the rate in
       To   : ISO.Currencies.Currency;
       --  The currency to convert to
       Rate : Decimal
       --  The exchange rate, in decimal format.
      ) with pre => This.Base_Is_Set;
   procedure Set_Rate
      (This : in out Currency_Exchange;
       --  The currency exchange to set the rate in
       To   : ISO.Currencies.Alphabetic_Code;
       --  The currency to convert to
       Rate : Decimal
       --  The exchange rate, in decimal format.
      ) with pre => This.Base_Is_Set;
   --  FUNCTION
   --    Add or update a new exchange rate into the current exchange.
   --  PARAMETERS
   --    From - The currency exchange to set the rate in
   --    To   - The currency to convert to
   --    Rate - The exchange rate, in decimal format.
   --  NOTES
   --    As a courtesy, the inverse of the exchange rate is also added to the
   --    exchange so both USD:GBP and GBP:USD will be accessible.  I recommend
   --    adding the inverse explicitly if it's different than 1.0 / Rate.
   --  EXAMPLE
   --    declare
   --       --  Create some currencies to test
   --       Bitcoin : Custom_Currency :=
   --          Create (Code => "BTC", Minor_Unit => 8,
   --                  Name => "Bitcoin", Symbol => "฿");
   --       --  based on the Jul. 9, 2023 exchange rate
   --       --  from openexchangerates.org.
   --       BTC_to_USD : constant Decimal := 30196.620159;
   --       USD_to_BTC : constant Decimal := 0.0000331163;
   --       USD_to_JPY : constant Decimal := 142.17488666;
   --       JPY_to_USD : constant Decimal := 0.007033591;
   --       --   Create the exchanges
   --       Test_Ex : Currency_Exchange;
   --       BTC_Ex  : Currency_Exchange;
   --    begin
   --       --  If you use USD -> GBP as 0.40 then it will automatically create
   --       --  GBP -> USD as 2.50
   --       Test_Ex.Set_Rate ("USD", "GBP", 0.40);
   --       --  You can also use the inverse.
   --       Test_Ex.Set_Rate ("USD", "JPY", USD_to_BTC);
   --       Test_Ex.Set_Rate ("JPY", "USD", USD_to_JPY);
   --       --  You can also set the base.
   --       BTC_Ex.Set_Base (Bitcoin);
   --       BTC_Ex.Set_Rate  ("USD", BTC_to_USD);
   --       --  You can still set other values if the base is set.
   --       BTC_Ex.Set_Rate  ("USD", Bitcoin, USD_to_BTC);
   --  SEE ALSO
   --    * Exchange.Currency_Exchange/Set_Base
   --    * Exchange.Currency_Exchange/Base_Is_Set
   --  ****

   --  ****m* Exchange.Currency_Exchange/Convert
   --  SOURCE
   function Convert
      (This : Currency_Exchange;
       From : Money_Handling.Money;
       --  The money with the currency to convert from
       To   : ISO.Currencies.Currency
       --  The currency to convert to
      )
   return Money_Handling.Money;
   function Convert
      (This : Currency_Exchange;
       From : Money_Handling.Money;
       --  The money with the currency to convert from
       To   : ISO.Currencies.Alphabetic_Code
       --  The currency to convert to
      )
   return Money_Handling.Money;
   function Convert
      (This : Currency_Exchange;
       From : Money_Handling.Money;
       --  The money with the currency to convert from
       To   : Currency_Handling.Custom_Currency
       --  The currency to convert to
      )
   return Money_Handling.Money;
   --  FUNCTION
   --    Converts money of one currency to another
   --  PARAMETERS
   --    From - The money with the currency to convert from
   --    To   - The currency to convert to
   --  RETURN VALUE
   --    A new money object with the new currency and value when converted or
   --    a money value of 0 if not found in the exchange.
   --  EXAMPLE
   --    declare
   --       My_Exchange : Currency_Exchange;
   --    begin
   --       My_Exchange.Set_Rate ("USD", "GBP", 0.5);
   --       --  Print £ 50.00 from a provided $ 100.00
   --       if My_Exchange.Contains ("USD", "GBP) then
   --          Put_Line
   --             (My_Exchange.Convert
   --                (From => From_Minor (100_00, "GBP"),
   --                 To   => "USD")'Image
   --             );
   --       else
   --          Put_Line ("Not in exchange");
   --       end if;
   --    end;
   --  SEE ALSO
   --    * Exchange.Currency_Exchange/Set_Rate
  --     * Exchange.Currency_Exchange/Contains
   --  ****

   --  ****m* Exchange.Currency_Exchange/Contains
   --  SOURCE
   function Contains
      (This : Currency_Exchange;
       From : ISO.Currencies.Currency;
       --  The currency to convert from
       To   : ISO.Currencies.Currency
       --  The currency to convert to
      )
   return Boolean;
   function Contains
      (This : Currency_Exchange;
       From : ISO.Currencies.Currency;
       --  The currency to convert from
       To   : Currency_Handling.Custom_Currency
       --  The currency to convert to
      )
   return Boolean;
   function Contains
      (This : Currency_Exchange;
       From : ISO.Currencies.Currency;
       --  The currency to convert from
       To   : ISO.Currencies.Alphabetic_Code
       --  The currency to convert to
      )
   return Boolean;
   function Contains
      (This : Currency_Exchange;
       From : ISO.Currencies.Alphabetic_Code;
       --  The currency to convert from
       To   : ISO.Currencies.Alphabetic_Code
       --  The currency to convert to
      )
   return Boolean;
   function Contains
      (This : Currency_Exchange;
       From : ISO.Currencies.Alphabetic_Code;
       --  The currency to convert from
       To   : ISO.Currencies.Currency
       --  The currency to convert to
      )
   return Boolean;
   function Contains
      (This : Currency_Exchange;
       From : ISO.Currencies.Alphabetic_Code;
       --  The currency to convert from
       To   : Currency_Handling.Custom_Currency
       --  The currency to convert to
      )
   return Boolean;
   function Contains
      (This : Currency_Exchange;
       From : Currency_Handling.Custom_Currency;
       --  The currency to convert from
       To   : Currency_Handling.Custom_Currency
       --  The currency to convert to
      )
   return Boolean;
   function Contains
      (This : Currency_Exchange;
       From : Currency_Handling.Custom_Currency;
       --  The currency to convert from
       To   : ISO.Currencies.Currency
       --  The currency to convert to
      )
   return Boolean;
   function Contains
      (This : Currency_Exchange;
       From : Currency_Handling.Custom_Currency;
       --  The currency to convert from
       To   : ISO.Currencies.Alphabetic_Code
       --  The currency to convert to
      )
   return Boolean;
   --  FUNCTION
   --    Validate if a conversion is in the exchange.
   --  PARAMETERS
   --    From - The currency to convert from
   --    To   - The currency to convert to
   --  RETURN VALUE
   --    Boolean:
   --       * True if there is a match of From -> To
   --       * False if From -> To not exist in the Exchange
   --  EXAMPLE
   --    if My_Exchange.Contains ("USD", "GBP) then
   --       Put_Line
   --          (My_Exchange.Convert
   --             (From => From_Minor (100_00, "GBP"),
   --              To   => "USD")'Image
   --          );
   --    else
   --       Put_Line ("Not in exchange");
   --    end if;
   --  SEE ALSO
   --    * Exchange.Currency_Exchange/Set_Rate
   --    * Exchange.Currency_Exchange/Convert
   --  ****

   --  Get the rate for a specific currency
   --  ****m* Exchange.Currency_Exchange/Rate
   --  SOURCE
   function Rate
      (This : Currency_Exchange;
       From : ISO.Currencies.Currency;
       --  The currency to convert from
       To   : ISO.Currencies.Currency)
       --  The currency to convert to
   return Decimal;
   function Rate
      (This : Currency_Exchange;
       From : ISO.Currencies.Currency;
       --  The currency to convert from
       To   : Currency_Handling.Custom_Currency
       --  The currency to convert to
      )
   return Decimal;
   function Rate
      (This : Currency_Exchange;
       From : ISO.Currencies.Currency;
       --  The currency to convert from
       To   : ISO.Currencies.Alphabetic_Code
       --  The currency to convert to
      )
   return Decimal;
   function Rate
      (This : Currency_Exchange;
       From : ISO.Currencies.Alphabetic_Code;
       --  The currency to convert from
       To   : ISO.Currencies.Alphabetic_Code
       --  The currency to convert to
      )
   return Decimal;
   function Rate
      (This : Currency_Exchange;
       From : ISO.Currencies.Alphabetic_Code;
       --  The currency to convert from
       To   : ISO.Currencies.Currency
       --  The currency to convert to
      )
   return Decimal;
   function Rate
      (This : Currency_Exchange;
       From : ISO.Currencies.Alphabetic_Code;
       --  The currency to convert from
       To   : Currency_Handling.Custom_Currency
       --  The currency to convert to
      )
   return Decimal;
   function Rate
      (This : Currency_Exchange;
       From : Currency_Handling.Custom_Currency;
       --  The currency to convert from
       To   : Currency_Handling.Custom_Currency
       --  The currency to convert to
      )
   return Decimal;
   function Rate
      (This : Currency_Exchange;
       From : Currency_Handling.Custom_Currency;
       --  The currency to convert from
       To   : ISO.Currencies.Currency
       --  The currency to convert to
      )
   return Decimal;
   function Rate
      (This : Currency_Exchange;
       From : Currency_Handling.Custom_Currency;
       --  The currency to convert from
       To   : ISO.Currencies.Alphabetic_Code
       --  The currency to convert to
      )
   return Decimal;
   --  These can be used if base rate is enabled
   function Rate
      (This : Currency_Exchange;
       To   : Currency_Handling.Custom_Currency
       --  The currency to convert to
      )
   return Decimal with pre => This.Base_Is_Set;
   function Rate
      (This : Currency_Exchange;
       To   : ISO.Currencies.Currency
       --  The currency to convert to
      )
   return Decimal with pre => This.Base_Is_Set;
   function Rate
      (This : Currency_Exchange;
       To   : ISO.Currencies.Alphabetic_Code
       --  The currency to convert to
      )
   return Decimal with pre => This.Base_Is_Set;
   --  FUNCTION
   --    Converts money of one currency to another
   --  PARAMETERS
   --    From - The currency to convert from
   --    To   - The currency to convert to
   --  RETURN VALUE
   --    The exchangce rate corresponding to From:To in Decimal form
   --  EXAMPLE
   --    declare
   --       My_Exchange : Currency_Exchange;
   --    begin
   --       My_Exchange.Set_Rate ("USD", "GBP", 0.5);
   --       --  Print the GBP exchange rate
   --       Put_Line ("Rate is " & My_Exchange.Rate ("USD", "GBP")'Image);
   --    end;
   --  SEE ALSO
   --    * Exchange.Currency_Exchange/Set_Rate
   --    * Exchange.Currency_Exchange/Contains
   --  ****

private
   --  This checks if the exchange is enabled or not.
   Exchange_Is_Enabled : Boolean := False;
   type Exchange_Rate is record
      From   : Currency_Handling.Currency_Data;
      To     : Currency_Handling.Currency_Data;
      ExRate : Decimal := 0.0;
   end record;

   function Exchange_Hashed (Item : Currency_Handling.Currency_Data)
      return Ada.Containers.Hash_Type;

   package To_Map is new Ada.Containers.Hashed_Maps
     (Key_Type        => Currency_Handling.Currency_Data,
      Element_Type    => Exchange_Rate,
      Hash            => Exchange_Hashed,
      Equivalent_Keys => Currency_Handling."=");
   --  To prevent any recursion
   function "=" (Left, Right : To_Map.Map) return Boolean is
      (To_Map."=" (Left, Right));

   package From_Map is new Ada.Containers.Hashed_Maps
     (Key_Type        => Currency_Handling.Currency_Data,
      Element_Type    => To_Map.Map,
      Hash            => Exchange_Hashed,
      Equivalent_Keys => Currency_Handling."=");

   type Currency_Exchange is tagged record
      Exchange : From_Map.Map;
      Base_Set : Boolean := False;
      Base     : Currency_Handling.Currency_Data :=
                  (Currency_Handling.Type_ISO_Currency,
                  (Key => ISO.Currencies.C_ZZZ));
   end record;
   --  The true implimentations.
   procedure Internal_Set_Base
      (This : in out Currency_Exchange;
       Base : Currency_Handling.Currency_Data);
   procedure Internal_Set_Rate
      (This : in out Currency_Exchange;
       Item : Exchange_Rate);
   function Internal_Search_Rate
      (This : Currency_Exchange;
       Search : Exchange_Rate)
   return Exchange_Rate;
   function Internal_Convert
      (This : Exchange_Rate;
       From : Money_Handling.Money)
   return Money_Handling.Money;

   --  Intermediate create functions
   function Create
      (From : Currency_Handling.Currency_Data;
       To   : ISO.Currencies.Currency;
       Rate : Decimal)
   return Exchange_Rate;
   function Create
      (From : Currency_Handling.Currency_Data;
       To   : ISO.Currencies.Alphabetic_Code;
       Rate : Decimal)
   return Exchange_Rate;
   function Create
      (From : Currency_Handling.Currency_Data;
       To   : Currency_Handling.Custom_Currency;
       Rate : Decimal)
   return Exchange_Rate;
   function Create
      (From : ISO.Currencies.Currency;
       To   : ISO.Currencies.Currency;
       Rate : Decimal)
   return Exchange_Rate;
   function Create
      (From : ISO.Currencies.Currency;
       To   : Currency_Handling.Custom_Currency;
       Rate : Decimal)
   return Exchange_Rate;
   function Create
      (From : ISO.Currencies.Currency;
       To   : ISO.Currencies.Alphabetic_Code;
       Rate : Decimal)
   return Exchange_Rate;
   function Create
      (From : ISO.Currencies.Alphabetic_Code;
       To   : ISO.Currencies.Alphabetic_Code;
       Rate : Decimal)
   return Exchange_Rate;
   function Create
      (From : ISO.Currencies.Alphabetic_Code;
       To   : ISO.Currencies.Currency;
       Rate : Decimal)
   return Exchange_Rate;
   function Create
      (From : ISO.Currencies.Alphabetic_Code;
       To   : Currency_Handling.Custom_Currency;
       Rate : Decimal)
   return Exchange_Rate;
   function Create
      (From : Currency_Handling.Custom_Currency;
       To   : Currency_Handling.Custom_Currency;
       Rate : Decimal)
   return Exchange_Rate;
   function Create
      (From : Currency_Handling.Custom_Currency;
       To   : ISO.Currencies.Currency;
       Rate : Decimal)
   return Exchange_Rate;
   function Create
      (From : Currency_Handling.Custom_Currency;
       To   : ISO.Currencies.Alphabetic_Code;
       Rate : Decimal)
   return Exchange_Rate;

end Cashe.Exchange;
