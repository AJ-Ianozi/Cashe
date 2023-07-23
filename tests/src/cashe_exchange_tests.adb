with Ada.Assertions; use Ada.Assertions;
with Cashe; use Cashe;
with ISO.Currencies; use ISO.Currencies;
with Cashe.Money_Handling; use Cashe.Money_Handling;
with Cashe.Currency_Handling; use Cashe.Currency_Handling;
with Cashe.Exchange; use Cashe.Exchange;
package body Cashe_Exchange_Tests is
   procedure Run_Tests is
      --  Create some currencies to test
      Bitcoin : constant Custom_Currency :=
         Create (Code => "BTC", Minor_Unit => 8,
            Name => "Bitcoin", Symbol => "฿");
      USD : constant Currency := (Key => C_USD);
      JPY : constant Currency := (Key => C_JPY);
      EUR : constant Currency := (Key => C_EUR);
      --  based on the Jul. 9, 2023 exchange rate 
      --  from openexchangerates.org.
      BTC_to_USD : constant Decimal := 30196.620159;
      USD_to_BTC : constant Decimal := 0.0000331163;

      USD_to_JPY : constant Decimal := 142.17488666;
      JPY_to_USD : constant Decimal := 0.007033591;

      USD_to_EUR : constant Decimal := 0.911922;
      EUR_to_USD : constant Decimal := 1.0965850149;

      --  Create an exchange.
      USD_Ex  : Currency_Exchange;
      EUR_Ex  : Currency_Exchange;
      BTC_Ex  : Currency_Exchange;
      No_Base : Currency_Exchange;

   begin

      --  Set the base
      Assert (not USD_Ex.Base_Is_Set);
      USD_Ex.Set_Base ("USD");
      EUR_Ex.Set_Base (From_Code ("EUR"));
      BTC_Ex.Set_Base (Bitcoin);
      Assert (USD_Ex.Base_Is_Set);
      Assert (EUR_Ex.Base_Is_Set);
      Assert (BTC_Ex.Base_Is_Set);
      --  Set some exchange rates.
      --  Bitcoin-USD
      BTC_Ex.Set_Rate  ("USD", BTC_to_USD);
      BTC_Ex.Set_Rate  ("USD", Bitcoin, USD_to_BTC);
      No_Base.Set_Rate ("USD", Bitcoin, USD_to_BTC);
      --  USD-JPY
      USD_Ex.Set_Rate  (From_Code ("JPY"), USD_to_JPY);
      USD_Ex.Set_Rate  ("JPY", USD, JPY_to_USD);
      No_Base.Set_Rate (From_Code ("JPY"), "USD", JPY_to_USD);
      --  EUR-USD
      EUR_Ex.Set_Rate  ("USD", EUR_to_USD);
      EUR_Ex.Set_Rate  ("USD", EUR, USD_to_EUR);
      No_Base.Set_Rate ("USD", From_Code ("EUR"), USD_to_EUR);
      --  Test btc-usd
      Assert (BTC_Ex.Rate ("USD") = BTC_to_USD);
      Assert (No_Base.Rate ("USD", Bitcoin) = USD_to_BTC);
      Assert
         (BTC_Ex.Convert (From_Major (123.45, USD), Bitcoin)
            =
          From_Major (0.0040882059, Bitcoin));
      Assert
         (BTC_Ex.Convert (From_Major (123.45678912, Bitcoin), USD)
            =
          From_Major (3727977.7671, USD));
      Assert
         (BTC_Ex.Convert (From_Major (123.45, USD), Bitcoin)
            =
          No_Base.Convert (From_Major (123.45, USD), Bitcoin));
      --  Test jpy-usd
      Assert (USD_Ex.Rate (From_Code ("JPY")) = USD_to_JPY);
      Assert (No_Base.Rate (From_Code ("JPY"), "USD") = JPY_to_USD);
      Assert
         (USD_Ex.Convert (From_Major (123.45, USD), JPY)
            =
          From_Major (17551, JPY));
      Assert
         (USD_Ex.Convert (From_Major (12345, JPY), USD)
            =
         From_Major (86.829680614, USD));
      Assert
         (USD_Ex.Convert (From_Major (12345, JPY), USD)
            =
          No_Base.Convert (From_Major (12345, JPY), USD));
      --  Test eur-usd
      Assert (EUR_Ex.Rate ("USD") = EUR_to_USD);
      Assert (No_Base.Rate ("USD", "EUR") = USD_to_EUR);
      Assert
         (EUR_Ex.Convert (From_Major (123.45, USD), EUR)
            =
          From_Major (112.5767709, EUR));
      Assert
         (EUR_Ex.Convert (From_Major (123.45, EUR), USD)
            =
         From_Major (135.3734201, USD));
      Assert
         (EUR_Ex.Convert (From_Major (123.45, EUR), USD)
            =
          No_Base.Convert (From_Major (123.45, EUR), USD));
   end Run_Tests;
end Cashe_Exchange_Tests;