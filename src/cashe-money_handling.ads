pragma Ada_2022;
pragma Assertion_Policy (Check);
with ISO.Currencies;
with Ada.Strings.Text_Buffers;
with Cashe.Currency_Handling;
--  ****h* Cashe/Money_Handling
--  SOURCE
package Cashe.Money_Handling is
--  DESCRIPTION
--    This package provides methods of defining custom currency and storing
--    currencies.
--  ****

   --  ****e* Money_Handling/Money_Handling.Currency_Mismatch
   --  SOURCE
   Currency_Mismatch    : exception;
   --  DESCRIPTION
   --    Raised if operations on two monies have different currencies.
   --  ****

   --  ****e* Money_Handling/Money_Handling.Division_By_Zero
   --  SOURCE
   Division_By_Zero     : exception;
   --  DESCRIPTION
   --    Raised on division-by-zero
   --  ****

   --  The "Money" object.
   --  ****c* Money_Handling/Money_Handling.Money
   --  SOURCE
   type Money is tagged private with Put_Image => Print_Money;
   --  DESCRIPTION
   --    An immutable datatype that can be created and stored
   --    (or just created on the spot) using various combinations of
   --    From_Major and From_Minor.
   --  USAGE
   --   A_Float  : Long_Long_Float := 14.1190004014938372284932918;
   --   Test_US0 : Money := From_Major ("-2000.005", "USD");
   --   Test_US1 : Money := From_Major (875.00, "USD");
   --   Test_US2 : Money := From_Minor (87500, "USD");
   --   Test_US3 : Money := From_Major (0.0, "USD");
   --   Test_YEN : Money := From_Major ("12345", "JPY");
   --   Test_EU1 : Money := From_Major (2489.00, "EUR");
   --   Test_EU2 : Money := From_Minor (248500, "EUR");
   --   Test_AUD : Money := From_Major (-50, "AUD");
   --   Test_OMR : Money := From_Minor (9383314, "OMR");
   --   Test_BTC : Money := From_Minor (5000000000, Bitcoin);
   --   Test_Wei : Money := From_Minor (1000000000000000000, Ethereum);
   --   Test_We2 : Money := Test_Wei.Round;
   --   Test_RAD : Money := From_Major (1234, Radio);
   --   Test_ADA : Money := From_Major (45678.123456789098765, Cardano);
   --  METHODS
   --  * Money_Handling.Money/Same_Currency
   --  * Money_Handling.Money/Is_Custom_Currency
   --  * Money_Handling.Money/Get_Currency
   --  * Money_Handling.Money/Currency_Name
   --  * Money_Handling.Money/Currency_Symbol
   --  * Money_Handling.Money/Currency_Unit
   --  * Money_Handling.Money/Is_Zero
   --  * Money_Handling.Money/Is_Positive
   --  * Money_Handling.Money/Is_Negative
   --  * Money_Handling.Money/Round
   --  * Money_Handling.Money/Full_Precision
   --  * Money_Handling.Money/As_Major
   --  * Money_Handling.Money/As_Minor
   --  SEE ALSO
   --  * Money_Handling/Money_Handling.From_Major
   --  * Money_Handling/Money_Handling.From_Minor
   --  ****

   --  ****m* Money_Handling.Money/Same_Currency
   --  SOURCE
   function Same_Currency
      (This : Money;
       --  The current money
       Item : Money
       --  The Money to test against the current money.
      )
   return Boolean with Inline;
   --  FUNCTION
   --    Determine if the money contains the same currency as another money.
   --  PARAMETERS
   --    Item - The Money to test against the current money.
   --  RETURN VALUE
   --    Boolean - True if currency of both monies are identical.  False if
   --              they are different.
   --  EXAMPLE
   --    if My_USD.Same_Currency (My_USD2) then
   --       Put_Line ("Same Currency.");
   --    end if;
   --  ****

   --  ****m* Money_Handling.Money/Is_Custom_Currency
   --  SOURCE
   function Is_Custom_Currency (This : Money) return Boolean with Inline;
   --  FUNCTION
   --    Determine if the money contains the same currency as another money.
   --  RETURN VALUE
   --    Boolean - True if currency is custom or not, as opposed to an ISO's.
   --  EXAMPLE
   --    if My_Money.Custom_Currency then
   --       Put_Line ("Using a custom currency.");
   --    end if;
   --  ****

   --  ****m* Money_Handling.Money/Get_Currency
   --  SOURCE
   function Get_Currency
      (This : Money) return Currency_Handling.Currency_Data with Inline;
   --  FUNCTION
   --    Retrieve the actual currency belonging to the money.
   --    Results are stored in a special "holder" called Currency_Data.
   --    Unless you specifically need the currency, you are better off using
   --    methods such as:
   --    * Money_Handling.Money/Currency_Name
   --    * Money_Handling.Money/Currency_Symbol
   --    * Money_Handling.Money/Currency_Unit
   --  RETURN VALUE
   --    Currency_Handling/Currency_Handling.Currency_Data - Money's currency
   --  EXAMPLE
   --    declare
   --       Result : Currency_Data := My_Money.Get_Currency;
   --    begin
   --       case Result.Which_Currency_Type is
   --          when Type_Custom_Currency =>
   --             Put_Line ("Custom Currency is " & Result.Custom_Code.Name);
   --          when Type_ISO_Currency =>
   --             Put_Line ("ISO Currency is " & Result.ISO_Code.Name);
   --             Put_Line ("And Numeric is " & Result.ISO_Code.Numeric);
   --       end case;
   --    end;
   --  SEE ALSO
   --    Currency_Handling/Currency_Handling.Currency_Data
   --  ****

   --  ****m* Money_Handling.Money/Currency_Name
   --  SOURCE
   function Currency_Name (This : Money) return Wide_Wide_String;
   --  FUNCTION
   --    Retrieves the name of the Money's currency.
   --  RETURN VALUE
   --    Wide_Wide_String - name of money's currency.
   --  EXAMPLE
   --    Put_Line ("Currency is " & My_Money.Currency_Name);
   --  ****

   --  ****m* Money_Handling.Money/Currency_Code
   --  SOURCE
   function Currency_Code (This : Money) return Wide_Wide_String;
   --  FUNCTION
   --    Retrieves the code of the Money's currency.
   --  RETURN VALUE
   --    Wide_Wide_String - code of money's currency.
   --  EXAMPLE
   --    Put_Line ("Currency is " & My_Money.Currency_Code);
   --  ****

   --  ****m* Money_Handling.Money/Currency_Symbol
   --  SOURCE
   function Currency_Symbol (This : Money) return Wide_Wide_String;
   --  FUNCTION
   --    Retrieves the symbol of the Money's currency.
   --  RETURN VALUE
   --    Wide_Wide_String - symbol of money's currency.
   --  EXAMPLE
   --    Put_Line ("Currency is " & My_Money.Currency_Symbol);
   --  ****

   --  ****m* Money_Handling.Money/Currency_Unit
   --  SOURCE
   function Currency_Unit (This : Money) return Natural;
   --  FUNCTION
   --    Retrieves the minor unit of the Money's currency.
   --  RETURN VALUE
   --    Natural - minor unit of money's currency.
   --  EXAMPLE
   --    Put_Line ("This currency has:");
   --    if My_Money.Minor_Unit > 0 then
   --       Put_Line (My_Money.Minor_Unit'Image & " decimal places");
   --    else
   --       Put_Line ("No decimal places");
   --    end if;
   --  ****

   --  ****m* Money_Handling.Money/Is_Zero
   --  SOURCE
   function Is_Zero (This : Money) return Boolean with Inline;
   --  FUNCTION
   --    Determines if the money contains a zero value.
   --  RETURN VALUE
   --    Boolean:
   --       * True if value of money is 0.
   --       * False if value is not 0.
   --  EXAMPLE
   --    if My_Money.Is_Zero then
   --       Put_Line ("I'm broke!");
   --    end if;
   --  ****

   --  ****m* Money_Handling.Money/Is_Positive
   --  SOURCE
   function Is_Positive (This : Money) return Boolean with Inline;
   --  FUNCTION
   --    Determines if the money is greater than 0.
   --  RETURN VALUE
   --    Boolean:
   --       * True if value of money is greater than 0.
   --       * False if value is not greater than 0.
   --  EXAMPLE
   --    if My_Money.Is_Positive then
   --       Put_Line ("I have money!");
   --    end if;
   --  ****

   --  ****m* Money_Handling.Money/Is_Negative
   --  SOURCE
   function Is_Negative (This : Money) return Boolean with Inline;
   --  FUNCTION
   --    Determines if the money is less than 0
   --  RETURN VALUE
   --    Boolean:
   --       * True if value of money is less than 0
   --       * False if value is not less than 0
   --  EXAMPLE
   --    if My_Money.Is_Negative then
   --       Put_Line ("I'm in debt!");
   --    end if;
   --  ****

   --  ****m* Money_Handling.Money/Round
   --  SOURCE
   function Round
      (This : Money;
       --  The current money to round
       By : Natural;
       --  The precision which to round to.
       Method : Round_Method := Half_Even
       --  The method of rounding.  Default is Half_Even aka Banker's Rounding.
      )
   return Money with pre => By <= Max_Precision;
   function Round
      (This : Money;
       --  The current money to round
       Method : Round_Method := Half_Even
       --  The method of rounding.  Default is Half_Even aka Banker's Rounding.
      )
   return Money;
   --  FUNCTION
   --    Round the value of a money object to a given precision
   --  PARAMETERS
   --    By     - The precision which to round to.  Leave parameter out and
   --             it will round to the minor unit of the money's currency.
   --    Method - The method which to round.  The default is Half_Even aka
   --             Banker's Rounding.  Half_Up is the kind of rounding you learn
   --             in Math class.
   --  RETURN VALUE
   --    Money_Handling/Money_Handling.Money - Money with a rounded value.
   --  EXAMPLE
   --    declare
   --       Test_Money : Money := From_Major (-2000.005, "USD");
   --    begin
   --       Assert (Test_Money.Round (2) = From_Major (-2000.00, "USD"));
   --       Assert (Test_Money.Round (2, Half_Up) =
   --               From_Major (-2000.01, "USD"));
   --       --  Do not specify precision and it will default to minor unit
   --       Assert (Test_Money.Round = From_Major (-2000.00, "USD"));
   --    end;
   --  SEE ALSO
   --    Cashe/Cashe.Round_Method
   --  ****

   --  ****m* Money_Handling.Money/Full_Precision
   --  SOURCE
   function Full_Precision (This : Money) return Decimal with Inline;
   --  FUNCTION
   --    When printing or comparing money, it is always rounded to the money's
   --    minor unit.  This function returns the full precision decimal of the
   --    current money's value.
   --  RETURN VALUE
   --    Cashe/Cashe.Decimal - Full precision of money's value.
   --  EXAMPLE
   --    declare
   --       USD : Money := From_Major (7.22, "USD") * 77.555321;
   --    begin
   --       Assert (USD.Full_Precision = 559.94941762);
   --    end;
   --  SEE ALSO
   --    Cashe/Cashe.Decimal
   --  ****

   --  ****m* Money_Handling.Money/As_Major
   --  SOURCE
   function As_Major (This : Money) return Decimal;
   --  FUNCTION
   --    Returns the item in major format, rounded with banker's rounding.
   --    If full precision is needed, use Money_Handling.Money/Full_Precision
   --  RETURN VALUE
   --    Cashe/Cashe.Decimal - Money's value, rounded to minor unit.
   --  EXAMPLE
   --    USD : Money   := From_Major (2000.005, "USD");
   --    MU  : Decimal := USD.As_Major; -- contains 2000.00
   --  SEE ALSO
   --    Cashe/Cashe.Decimal
   --    Money_Handling.Money/Round
   --    Money_Handling.Money/Full_Precision
   --  ****

   --  Returns the item in minor format, rounded with banker's rounding.
   --  If money holds values "2000.005, return "200000"
   --  ****m* Money_Handling.Money/As_Minor
   --  SOURCE
   function As_Minor (This : Money) return Decimal_Minor;
   --  FUNCTION
   --    Returns the item's minor unit, rounded with banker's rounding.
   --    If full precision is needed, use Money_Handling.Money/Full_Precision
   --  RETURN VALUE
   --    Cashe/Cashe.Decimal_Minor - Money's value, rounded to minor unit.
   --  EXAMPLE
   --    USD : Money         := From_Major (2000.005, "USD");
   --    MU  : Decimal_Minor := USD.As_Minor; -- contains 200000
   --  SEE ALSO
   --    Cashe/Cashe.Decimal_Minor
   --    Money_Handling.Money/Round
   --    Money_Handling.Money/Full_Precision
   --  ****

   --  Operator overloading
   --  ****f* Money_Handling/Money_Handling.Addition
   --  SOURCE
   function "+"   (Left, Right : Money) return Money
      with Pre => Left.Same_Currency (Right) or else
            raise Currency_Mismatch;
   function "+"   (Left : Money; Right : Decimal) return Money;
   function "+"   (Left : Money; Right : Decimal_Minor) return Money;
   --  FUNCTION
   --    Allows addition between money types.
   --  ERRORS
   --    * Money_Handling/Money_Handling.Currency_Mismatch
   --  RETURN VALUE
   --    Money_Handling/Money_Handling.Money - Sum of the addition.
   --  EXAMPLE
   --    declare
   --      USD1 : Money := From_Major (7.22, "USD") + From_Major (0.98, "USD");
   --      USD2 : Money := USD1 + 10;
   --      USD3 : Money := USD2 + 12.34;
   --    begin
   --      Put_Line (USD1'Image); --  $ 15.20
   --      Put_Line (USD2'Image); --  $ 25.20
   --      Put_Line (USD3'Image); --  $ 37.54
   --    end;
   --  ****

   --  ****f* Money_Handling/Money_Handling.Subtraction
   --  SOURCE
   function "-"   (Left : Money) return Money;
   function "-"   (Left, Right : Money) return Money
      with Pre => Left.Same_Currency (Right) or else
            raise Currency_Mismatch;
   function "-"   (Left : Money; Right : Decimal) return Money;
   function "-"   (Left : Money; Right : Decimal_Minor) return Money;
   --  FUNCTION
   --    Allows subtraction between money types.
   --  ERRORS
   --    * Money_Handling/Money_Handling.Currency_Mismatch
   --  RETURN VALUE
   --    Money_Handling/Money_Handling.Money - Remainder of the subtraction.
   --  EXAMPLE
   --    declare
   --       USD1 : Money := From_Major (107, "USD") - From_Major (0.98, "USD");
   --       USD2 : Money := USD1 - 10;
   --       USD3 : Money := USD2 - 12.34;
   --    begin
   --       Put_Line (USD1'Image); --  $ 106.02
   --       Put_Line (USD2'Image); --  $ 96.02
   --       Put_Line (USD3'Image); --  $ 83.68
   --    end;
   --  ****

   --  ****f* Money_Handling/Money_Handling.Multiplication
   --  SOURCE
   function "*"   (Left, Right : Money) return Money
      with Pre => Left.Same_Currency (Right) or else
            raise Currency_Mismatch;
   function "*"   (Left : Money; Right : Decimal) return Money;
   function "*"   (Left : Money; Right : Decimal_Minor) return Money;
   --  FUNCTION
   --    Allows multiplication between money types.
   --  ERRORS
   --    * Money_Handling/Money_Handling.Currency_Mismatch
   --  RETURN VALUE
   --    Money_Handling/Money_Handling.Money - Product of the multiplication.
   --  EXAMPLE
   --    declare
   --      USD1 : Money := From_Major (7.20, "USD") * From_Major (1.90, "USD");
   --      USD2 : Money := USD1 * 10;
   --      USD3 : Money := USD2 * 12.34;
   --    begin
   --      Put_Line (USD1'Image); --  $ 13.68
   --      Put_Line (USD2'Image); --  $ 136.8
   --      Put_Line (USD3'Image); --  $ 1688.11
   --    end;
   --  ****

   --  ****f* Money_Handling/Money_Handling.Division
   --  SOURCE
   function "/"   (Left, Right : Money) return Money
      with Pre => (Left.Same_Currency (Right) or else raise Currency_Mismatch)
                   and then ((not Right.Is_Zero) or
                   else raise Division_By_Zero);
   function "/"   (Left : Money; Right : Decimal) return Money
      with Pre => Right /= 0.0 or else raise Division_By_Zero;
   function "/"   (Left : Money; Right : Decimal_Minor) return Money
      with Pre => Right /= 0 or else raise Division_By_Zero;
   --  FUNCTION
   --    Allows division between money types.
   --  ERRORS
   --    * Money_Handling/Money_Handling.Currency_Mismatch
   --    * Money_Handling/Money_Handling.Division_By_Zero
   --  RETURN VALUE
   --    Money_Handling/Money_Handling.Money - Quotient of the division.
   --  EXAMPLE
   --    declare
   --      USD1 : Money := From_Major (120, "USD") / From_Major (15.00, "USD");
   --      USD2 : Money := USD1 / 10;
   --      USD3 : Money := USD2 / 0.25;
   --    begin
   --      Put_Line (USD1'Image); --  $ 8.00
   --      Put_Line (USD2'Image); --  $ 0.80
   --      Put_Line (USD3'Image); --  $ 3.20
   --    end;
   --  ****

   --  ****f* Money_Handling/Money_Handling.abs
   --  SOURCE
   function "abs" (Left : Money) return Money;
   --  FUNCTION
   --    Calculate the absolute value of some money.
   --  RETURN VALUE
   --    Money_Handling/Money_Handling.Money - Absolute value of the money.
   --  EXAMPLE
   --    declare
   --       USD1 : Money := From_Major (-120, "USD");
   --       USD2 : money := abs USD1;
   --    begin
   --       Put_Line (USD1'Image); --  $-120.00
   --       Put_Line (USD2'Image); --  $ 120.00
   --    end;
   --  ****

   --  Logical stuff.
   --  ****f* Money_Handling/Money_Handling.Less_Than
   --  SOURCE
   function "<"  (Left, Right : Money) return Boolean
      with Pre => Left.Same_Currency (Right) or else
            raise Currency_Mismatch;
   function "<"  (Left : Money; Right : Decimal) return Boolean;
   function "<"  (Left : Money; Right : Decimal_Major) return Boolean;
   --  FUNCTION
   --    Determine if a given money is less than another value.
   --  ERRORS
   --    * Money_Handling/Money_Handling.Currency_Mismatch
   --  RETURN VALUE
   --    Boolean: Money < X
   --  EXAMPLE
   --    declare
   --       My_Money : Money := From_Major (875.00, "USD");
   --    begin
   --       if My_Money < From_Major (1000.00, "USD") then
   --          Put_Line ("Money is less than $1000.");
   --       elsif My_Money < 900.00 then
   --          Put_Line ("Money is less than $900");
   --       elsif My_Money < 500 then
   --          Put_Line ("Money is less than $500");
   --       end if;
   --    end;
   --  ****

   --  ****f* Money_Handling/Money_Handling.Greater_Than
   --  SOURCE
   function ">"  (Left, Right : Money) return Boolean
      with Pre => Left.Same_Currency (Right) or else
            raise Currency_Mismatch;
   function ">"  (Left : Money; Right : Decimal) return Boolean;
   function ">"  (Left : Money; Right : Decimal_Major) return Boolean;
   --  FUNCTION
   --    Determine if a given money is greater than another value.
   --  ERRORS
   --    * Money_Handling/Money_Handling.Currency_Mismatch
   --  RETURN VALUE
   --    Boolean: Money > X
   --  EXAMPLE
   --    declare
   --       My_Money : Money := From_Major (875.00, "USD");
   --    begin
   --       if My_Money > From_Major (1000.00, "USD") then
   --          Put_Line ("Money is greater than $1000.");
   --       elsif My_Money > 900.00 then
   --          Put_Line ("Money is greater than $900");
   --       elsif My_Money > 500 then
   --          Put_Line ("Money is greater than $500");
   --       end if;
   --    end;
   --  ****

   --  ****f* Money_Handling/Money_Handling.Less_Than_Equal_To
   --  SOURCE
   function "<=" (Left, Right : Money) return Boolean
      with Pre => Left.Same_Currency (Right) or else
            raise Currency_Mismatch;
   function "<=" (Left : Money; Right : Decimal) return Boolean;
   function "<=" (Left : Money; Right : Decimal_Major) return Boolean;
   --  FUNCTION
   --    Determine if a given money is less than or equal to another value.
   --  ERRORS
   --    * Money_Handling/Money_Handling.Currency_Mismatch
   --  RETURN VALUE
   --    Boolean: Money <= X
   --  EXAMPLE
   --    declare
   --       My_Money : Money := From_Major (875.00, "USD");
   --    begin
   --       if My_Money <= From_Major (1000.00, "USD") then
   --          Put_Line ("Money is less than or equal to $1000.");
   --       elsif My_Money <= 900.00 then
   --          Put_Line ("Money is less than or equal to $900");
   --       elsif My_Money <= 500 then
   --          Put_Line ("Money is less than or equal to $500");
   --       end if;
   --    end;
   --  ****

   --  ****f* Money_Handling/Money_Handling.Greater_Than_Equal_To
   --  SOURCE
   function ">=" (Left, Right : Money) return Boolean
      with Pre => Left.Same_Currency (Right) or else
            raise Currency_Mismatch;
   overriding function "="  (Left : Money; Right : Money) return Boolean;
   function ">=" (Left : Money; Right : Decimal) return Boolean;
   function ">=" (Left : Money; Right : Decimal_Major) return Boolean;
   --  FUNCTION
   --    Determine if a given money is greater than or equal to another value.
   --  ERRORS
   --    * Money_Handling/Money_Handling.Currency_Mismatch
   --  RETURN VALUE
   --    Boolean: Money >= X
   --  EXAMPLE
   --    declare
   --       My_Money : Money := From_Major (875.00, "USD");
   --    begin
   --       if My_Money >= From_Major (1000.00, "USD") then
   --          Put_Line ("Money is greater than or equal to $1000.");
   --       elsif My_Money >= 900.00 then
   --          Put_Line ("Money is greater than or equal to $900");
   --       elsif My_Money >= 500 then
   --          Put_Line ("Money is greater than or equal to $500");
   --       end if;
   --    end;
   --  ****

   --  ****f* Money_Handling/Money_Handling.Equal_To
   --  SOURCE
   function "="  (Left : Money; Right : Decimal) return Boolean;
   function "="  (Left : Money; Right : Decimal_Major) return Boolean;
   --  FUNCTION
   --    Determine if a given money is equal to another value.
   --  RETURN VALUE
   --    Boolean: Money = X
   --  EXAMPLE
   --    declare
   --       My_Money : Money := From_Major (875.00, "USD");
   --    begin
   --       if My_Money = From_Major (1000.00, "USD") then
   --          Put_Line ("Money is equal to $1000.");
   --       elsif My_Money >= 900.00 then
   --          Put_Line ("Money is equal to $900");
   --       elsif My_Money = 500 then
   --          Put_Line ("Money is equal to $500");
   --       end if;
   --    end;
   --  ****

   --  Creation functions
   --  ****f* Money_Handling/Money_Handling.From_Major
   --  SOURCE
   function From_Major
            (Amount        : Decimal;
             --  Amount in decimal form to set the Money
             Currency_Used : Currency_Handling.Currency_Data
             --  The currency to use
            )
   return Money;
   function From_Major
            (Amount        : Decimal;
             --  Amount in decimal form to set the Money
             Currency_Used : Currency_Handling.Custom_Currency
             --  the currency to use
            )
   return Money;
   function From_Major
            (Amount        : Decimal;
             --  Amount in decimal form to set the Money
             Currency_Used : ISO.Currencies.Currency
             --  The currency to use
            )
   return Money;
   function From_Major
            (Amount        : Decimal;
             --  Amount in decimal form to set the Money
             Currency_Used : ISO.Currencies.Alphabetic_Code
             --  The currency to use
            )
   return Money;
   function From_Major
            (Amount        : Decimal_Major;
             --  Amount in whole number form to set the Money
             Currency_Used : Currency_Handling.Currency_Data
             --  The currency to use
            )
   return Money;
   function From_Major
            (Amount        : Decimal_Major;
             --  Amount in whole number form to set the Money
             Currency_Used : Currency_Handling.Custom_Currency
             --  The currency to use
            )
   return Money;
   function From_Major
            (Amount        : Decimal_Major;
             --  Amount in whole number form to set the Money
             Currency_Used : ISO.Currencies.Currency
             --  The currency to use
            )
   return Money;
   function From_Major
            (Amount          : Decimal_Major;
             --  Amount in whole number form to set the Money
             Currency_Used : ISO.Currencies.Alphabetic_Code
             --  The currency to use
            )
   return Money;
   function From_Major
            (Amount        : String;
             --  Amount in as a numerical string to set the money
             Currency_Used : Currency_Handling.Currency_Data
             --  The currency to use
            )
   return Money;
   function From_Major
            (Amount          : String;
             --  Amount as a numerical string to set the money
             Currency_Used : Currency_Handling.Custom_Currency
             --  The currency to use
            )
   return Money;
   function From_Major
            (Amount          : String;
             --  Amount as a numerical string to set the money
             Currency_Used : ISO.Currencies.Currency
             --  The currency to use
            )
   return Money;
   function From_Major
            (Amount          : String;
             --  Amount as a numerical string to set the money
             Currency_Used : ISO.Currencies.Alphabetic_Code
             --  The currency to use
            )
   return Money;
   --  FUNCTION
   --    Create a new money object from a provided major unit.  Either as a
   --    decimal, integer, or string.
   --  ERRORS
   --    * Constraint error if the string is not a decimal or integer.
   --  PARAMETERS
   --    Amount - The amount to set. For $10 use: 10.00, 10, "10", "10.00"
   --    Currency_Used - The currency this money will use. Either custom or ISO
   --  RETURN VALUE
   --    Money_Handling/Money_Handling.Money - The resulting money.
   --  NOTES
   --    Be aware that there's no From_Major for floats. Convert to Decimal!
   --  EXAMPLE
   --    --  Create from ISO currencies
   --    US0 : Money := From_Major ("-2000.005", "USD");
   --    US1 : Money := From_Major (875.00, "USD");
   --    US3 : Money := From_Major (0.0, ISO.Currencies.From_Code ("USD"));
   --    YEN : Money := From_Major ("12345", "JPY");
   --    EU  : Money := From_Major (2489.00, "EUR");
   --    AUD : Money := From_Major (-50, "AUD");
   --    --  Create from custom currencies
   --    Cardano : constant Custom_Currency :=
   --     Cashe.Currency_Handling.Create
   --        (Code => "ADA", Minor_Unit => 15,
   --        Name => "Cardano", Symbol => "₳");
   --    Radio : constant Custom_Currency :=
   --     Cashe.Currency_Handling.Create
   --        (Code => "RAD", Minor_Unit => 0,
   --        Name => "Rad Currency", Symbol => "☢");
   --    RAD : Money := From_Major (1234, Radio);
   --    AD1 : Money := From_Major (45678.123456789098765, Cardano);
   --    --  Must convert floats using To_Decimal with your own precision.
   --    A_Float : Long_Long_Float := 14.1190004014938372284932918;
   --    US4 : Money := From_Major (To_Decimal (A_Float, 2), "USD");
   --  ****

   --  Creation functions
   --  ****f* Money_Handling/Money_Handling.From_Minor
   --  SOURCE
   function From_Minor
            (Amount        : Decimal_Minor;
             Currency_Used : Currency_Handling.Currency_Data)
   return Money;
   function From_Minor
            (Amount        : Decimal_Minor;
             Currency_Used : Currency_Handling.Custom_Currency)
   return Money;
   function From_Minor
            (Amount        : Decimal_Minor;
             Currency_Used : ISO.Currencies.Currency)
   return Money;
   function From_Minor
            (Amount        : Decimal_Minor;
             Currency_Used : ISO.Currencies.Alphabetic_Code)
   return Money;
   function From_Minor
            (Amount        : String;
             Currency_Used : Currency_Handling.Currency_Data)
   return Money;
   function From_Minor
            (Amount        : String;
             Currency_Used : Currency_Handling.Custom_Currency)
   return Money;
   function From_Minor
            (Amount        : String;
             Currency_Used : ISO.Currencies.Currency)
   return Money;
   function From_Minor
            (Amount        : String;
             Currency_Used : ISO.Currencies.Alphabetic_Code)
   return Money;
   --  FUNCTION
   --    Create a new money object from a provided minor unit.  Either as an
   --    integer, or string.
   --  ERRORS
   --    * Constraint error if the string is not a decimal or integer.
   --    * Cashe/Cashe.Minor_Unit_Too_Large
   --  PARAMETERS
   --    Amount - The amount to set in minor units. For $10 use: 1000, "1000"
   --    Currency_Used - The currency this money will use. Either custom or ISO
   --  RETURN VALUE
   --    Money_Handling/Money_Handling.Money - The resulting money.
   --  EXAMPLE
   --    --  Create from ISO currencies
   --    Test_US2 : Money := From_Minor (87500, "USD");
   --    Test_EU2 : Money := From_Minor (248500, "EUR");
   --    Test_OMR : Money := From_Minor (9383314, "OMR");
   --    --  Create from Custom Currencies
   --    Bitcoin : constant Custom_Currency :=
   --     Cashe.Currency_Handling.Create
   --       (Code => "BTC", Minor_Unit => 8,
   --        Name => "Bitcoin", Symbol => "฿");
   --    Ethereum : constant Custom_Currency :=
   --     Cashe.Currency_Handling.Create
   --       (Code => "ETH", Minor_Unit => 18,
   --        Name => "Ether", Symbol => "Ξ");
   --    Test_BTC : Money := From_Minor (5000000000, Bitcoin);
   --    Test_Wei : Money := From_Minor (1000000000000000000, Ethereum);
   --  ****

   --  ****f* Money_Handling/Money_Handling.Print_Money
   --  SOURCE
   procedure Print_Money
      (Buffer : in out Ada.Strings.Text_Buffers.Root_Buffer_Type'Class;
       Value  : Money);
   --  FUNCTION
   --    Print the current money in format "¤[-]#.##".
   --  USAGE
   --    --  Call this via 'Image attribute, e.g.
   --    Printed : String := My_Money'Image;
   --  EXAMPLE
   --    declare
   --       -- Create a custom currency
   --       King_Currency : constant Custom_Currency :=
   --          Cashe.Currency_Handling.Create
   --             (Code => "KNG", Minor_Unit => 2,
   --              Name => "King Currency", Symbol => "K");
   --       KNG : Money := From_Major (9001.99, King_Currency);
   --       USD : Money := From_Major (875.00, "USD");
   --       AUD : Money := From_Major (-50, "AUD");
   --    begin
   --       Put_Line (KNG'Image); --  "K 9001.99"
   --       Put_Line (USD'Image); --  "$ 875.00"
   --       Put_Line (AUD'Image); --  "$-50.00"
   --    end;
   --  TODO
   --    Allowing setting format e.g. "My_Money.Format('en_US')"
   --  ****

private
   --  Just declaring this gives you an empty currency.
   type Money is tagged record
      Amount : Decimal := 0.0;
      Cur    : Currency_Handling.Currency_Data :=
                  (Currency_Handling.Type_ISO_Currency,
                   (Key => ISO.Currencies.C_ZZZ));
   end record;

end Cashe.Money_Handling;
