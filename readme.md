# Cashe: A Money library for Ada

**NOTE: This is still in prerelease and may have some changes before its final version!**

This is a library that treats Money like a first class citizen, taking advantage of Ada's fixed point capabilities to store monetary values as a decimal with up to 20 places of precision, and then utilizes [Banker's Rounding](https://www.sqlservercentral.com/articles/bankers-rounding-what-is-it-good-for) to display or measure the values on-demand based on the Currency's minor unit.  Don't worry, if you want the full precision, there's ways to do that too.

```Ada
with Cashe;                   use Cashe;
with ISO.Currencies;          use ISO.Currencies;
with Ada.Text_IO;             use Ada.Text_IO;
with Cashe.Money_Handling;    use Cashe.Money_Handling;
with Cashe.Currency_Handling; use Cashe.Currency_Handling;
procedure Example is
   Radio   : constant Custom_Currency :=
      Create (Code => "RAD", Minor_Unit => 0,
              Name => "Rad Currency", Symbol => "☢");
   Cardano : constant Custom_Currency :=
      Create (Code => "ADA", Minor_Unit => 15,
              Name => "Cardano", Symbol => "₳");
   USD : constant ISO.Currencies.Currency := ISO.Currencies.From_Code ("USD");

   US_Dollars  : Money := From_Major ("-123.45", USD);
   Ada_Dollars : Money := From_Major (173.398847322218938, Cardano);
   Rad_Dollars : Money := From_Major (1750, Radio);

begin
   Put_Line (US_Dollars'Image);  --  "$-123.45"
   Put_Line (Ada_Dollars'Image); --  "₳ 173.398847322218938"
   Put_Line (Rad_Dollars'Image); --  "☢ 1750"
end Example;
```

Cashe is already fully featured, supporting:

- `Decimal`, `Decimal_Major`, and `Decimal_Minor` datatypes utilizing supported ranges
- ISO 4217 (Currency Codes) thanks to [Ada ISO](https://github.com/ada-iso/ada_iso/)
- Custom Currencies (see below)
- A currency exchange (with support for an online exchange planned)
- Fully overloaded functions for `+`, `-`, `/`, `*`, `<`, `>`, `>=`, `<=`, `=`, `mod`, and `abs`
- Various overloaded combinations for all functions

## Installation

*Alire support coming soon!*

Currently you can download the `ads` and `adb` files under `/src` and include them in your project.

## Usage

You can also read the [full API documentation](https://aj-ianozi.github.io/Cashe/toc_index.html) which has been generated with [ROBODoc](https://github.com/gumpu/ROBODoc).

### Primitive datatypes

There are several datatypes available in the `Cashe` package, used internally and accessible.

```Ada
type Decimal is delta 1.0E-20 digits 38;
```

The `Decimal` data type is a fixed point decimal ranging from `-999_999_999_999_999_999.99999999999999999999` to `999_999_999_999_999_999.99999999999999999999`.  You can use it in any place where a fixed point number is needed, and you can convert it with accurate precision from a floating point by doing:

```Ada
with Cashe; use Cashe;
--   Long_Long_Float is recommended but this supports Float and Long_Float too
My_Float : constant Long_Long_Float :=                               14.1190004014938372284932918;
Dec_Full : constant Decimal         := To_Decimal (My_Float);    --  14.11900040149383722880
Dec3     : constant Decimal         := To_Decimal (My_Float, 3); --  14.11900000000000000000
Dec2     : constant Decimal         := To_Decimal (My_Float, 2); --  14.12000000000000000000
```

The `Decimal_Major` and `Decimal_Minor` datatypes are simply subtypes of `Long_Long_Integer` and `Long_Long_Long_Integer` respectively to restrict values being handled and major and minor units.

```Ada
   --  integer number, ranging from:
   --  -999_999_999_999_999_999 to
   --   999_999_999_999_999_999
   --  Used for setting major units without precision.
   subtype Decimal_Major is Long_Long_Integer
      range -(1E+18 - 1) .. +(1E+18 - 1);
   --  128-bit integer number, ranging from:
   --  -99_999_999_999_999_999_999_999_999_999_999_999_999 to
   --   99_999_999_999_999_999_999_999_999_999_999_999_999
   --  Used for setting / accessing minor units
   subtype Decimal_Minor is Long_Long_Long_Integer
      range -(1E+38 - 1) .. +(1E+38 - 1);
```

### Currency

You can utilize not only Ada ISO currencies, but you can also utilize custom currencies in package `Cashe.Currency_Handling`, defining symbols, codes, and minor units (precision) using `Create`.  Everything is stored as a wide_wide_string for friendly compatibility with VSS.

```Ada
with ISO.Currencies;
with Cashe;                   use Cashe;
with Cashe.Currency_Handling; use Cashe.Currency_Handling;
      --  Create some custom currencies.
      King_Currency : constant Custom_Currency :=
         Create (Code => "AJ", Minor_Unit => 2,
              Name => "AJ Currency", Symbol => "👑");
      Bitcoin : constant Custom_Currency :=
         Create (Code => "BTC", Minor_Unit => 8,
              Name => "Bitcoin", Symbol => "฿");
      Ethereum : constant Custom_Currency :=
         Create (Code => "ETH", Minor_Unit => 18,
              Name => "Ether", Symbol => "Ξ");
      Cardano : constant Custom_Currency :=
         Create (Code => "ADA", Minor_Unit => 15,
               Name => "Cardano", Symbol => "₳");
      RadCur   : constant Custom_Currency :=
         Create (Code => "RAD", Minor_Unit => 0,
              Name => "Rad Currency", Symbol => "☢");
      USD : constant ISO.Currencies.Currency :=
                        ISO.Currencies.From_Code ("USD");
```

### Money

Money is an immutable datatype found in the package `Cashe.Money_Handling` that can be created and stored (or just created on the spot) using various combinations of `From_Major` and `From_Minor`:

```Ada
A_Float  : Long_Long_Float := 14.1190004014938372284932918;
Test_US0 : Money := From_Major ("-2000.005", "USD");
Test_US1 : Money := From_Major (875.00, "USD");
Test_US2 : Money := From_Minor (87500, "USD");
Test_US3 : Money := From_Major (0.0, "USD");
Test_YEN : Money := From_Major ("12345", "JPY");
Test_EU1 : Money := From_Major (2489.00, "EUR");
Test_EU2 : Money := From_Minor (248500, "EUR");
Test_AUD : Money := From_Major (-50, "AUD");
Test_OMR : Money := From_Minor (9383314, "OMR");
Test_BTC : Money := From_Minor (5000000000, Bitcoin);
Test_Wei : Money := From_Minor (1000000000000000000, Ethereum);
Test_We2 : Money := Test_Wei.Round;
Test_RAD : Money := From_Major (1234, Radio);
Test_ADA : Money := From_Major (45678.123456789098765, Cardano);
--  Be aware that there's no From_Major for floats. You choose your precision!
Test_US4 : Money := From_Major (To_Decimal (A_Float, 2), "USD");
```

There's several functions that you can utilize to get data about the money after it's been created, such as:

```Ada
   function Same_Currency (This : Money; Item : Money) return Boolean;
   function Is_Custom_Currency (This : Money) return Boolean;
   function Get_Currency (This : Money) return Currency_Handling.Currency_Data;
   function Currency_Name (This : Money) return Wide_Wide_String;
   function Currency_Code (This : Money) return Wide_Wide_String;
   function Currency_Symbol (This : Money) return Wide_Wide_String;
   function Currency_Unit (This : Money) return Natural;
   function Is_Zero (This : Money) return Boolean;
   function Is_Positive (This : Money) return Boolean;
   function Is_Negative (This : Money) return Boolean;
   function Round (This : Money; By : Natural; Method : Round_Method := Half_Even) return Money;
   function Full_Precision (This : Money) return Decimal;
   function As_Major (This : Money) return Decimal;
   function As_Minor (This : Money) return Decimal_Minor;
```

As shown previously, you can print the money in its standard precision using the `'Image`:

```Ada
Put_Line (Test_US0'Image);  --  "$-2000.00"
```

If the symbol is not available, it will default to a universal currency symbol.

You can compare money using all of the standard comparison operators, which also support Money to Money, Money to Decimal, or Money to Integer, so checking if a value is greater than or equal to $10.00 is as easy as `if My_Money >= 10 then`.

When comparing Money, the operators will round via Banker's Rounding to the exact unit type the money is defined on, so you must call `.Full_Precision` to retrieve the complete precision.

```Ada
      --  Test fuzzy equality
      declare
         USD : Money := From_Major (7.22, "USD");
         USD2 : Money := From_Minor (777, "USD");
      begin
         USD := USD + 0.55;
         Assert (USD = 7.77);
         USD := USD - 0.0001;
         Assert (USD = 7.77);
         Assert (USD = USD2);
         USD := USD - 0.004;
         Assert (USD = 7.77);
         USD := USD - 0.001;
         Assert (USD = 7.76);
         USD := USD * 77.555321;
         Assert (USD = 602.21);
         Assert (USD.Full_Precision = 602.2093120329);
      end;
```

### Currency Exchange

*Coming soon: Online exchange support!*

The `Currency_Exchange` type found in package `Cashe.Exchange` is a table where you can set and later retrieve exchange rates.  For example, assuming the exchange rate between USD and EUR was 0.5:

```Ada
declare
   My_Exchange : Currency_Exchange;
begin
   My_Exchange.Set_Rate ("USD", "GBP", 0.5);
end;
```

You can now convert between USD and GBP by doing:

```Ada
--  Creates £ 50.00 from $100.00 USD.
New_Money : Money := My_Exchange.Convert (From_Minor (100_00, "USD"), "GBP");
```

By default, the exchange rate will allow calculating the reverse of the exchange rate; however, if you provide an explicit rate, that will override it:

```Ada
--  Prints "$ 200.00", extraploating from the previous assignment
Put_Line (My_Exchange.Convert (From_Minor (100_00, "GBP"), "USD")'Image);
My_Exchange.Set_Rate ("GBP", "USD", 0.77);
--  Prints "$ 77.00"
Put_Line (My_Exchange.Convert (From_Minor (100_00, "GBP"), "USD")'Image);
--  This does not overrwrite the explicitaly set "other way around"
--  This still prints "£ 50.00":
Put_Line (My_Exchange.Convert (From_Minor (100_00, "USD"), "GBP")'Image);
```

You can also set a "base currency" for your currency exchange if you're always going to be falling back to a base unit.

```Ada
declare
   US_Exchange : Currency_Exchange;
begin
   US_Exchange.Set_Base ("USD");
   US_Exchange.Set_Rate ("GBP", 0.5);
   US_Exchange.Set_Rate (Bitcoin, 0.0000331163);
end;
```

You also have functions like `In_Exchange` to verify if some set of currencies are in the exchange, `Rate` to retrieve the actual exchange rate and `Base_Is_Set` to find out if you have set a base on that exchange.

I'll work writing the full documentation for the API next, but I hope that gives you an example of what this has to offer!

## Contribute

Feel free to open an issue if you find any bugs or comment if you have any comments or enhancements.  I tried to catch everything with my unit tests, but I may have missed something.