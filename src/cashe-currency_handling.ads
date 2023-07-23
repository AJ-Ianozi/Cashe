pragma Assertion_Policy (Check);
with ISO.Currencies;
with Ada.Strings.Wide_Wide_Unbounded;
--  ****h* Cashe/Currency_Handling
--  SOURCE
package Cashe.Currency_Handling is
--  DESCRIPTION
--    This package provides methods of defining custom currency and storing
--    currencies.
--  ****

   --  ****c* Currency_Handling/Currency_Handling.Custom_Currency
   --  SOURCE
   type Custom_Currency is tagged private;
   --  DESCRIPTION
   --    Allows for defining and storing a custom currency.  Member functions
   --    can be used to retrieve information such as its code, minor units,
   --    and symbols.  Can be initialized with the Create function.
   --  USAGE
   --    with Cashe.Currency_Handling; use Cashe.Currency_Handling;
   --    King : Custom_Currency := Create (Code => "KNG",
   --                                      Minor_Unit => 2,
   --                                      Name => "King Currency",
   --                                      Symbol => "K");
   --  METHODS
   --  * Currency_Handling.Custom_Currency/Set_Code
   --  * Currency_Handling.Custom_Currency/Set_Name
   --  * Currency_Handling.Custom_Currency/Set_Symbol
   --  * Currency_Handling.Custom_Currency/Set_Unit
   --  * Currency_Handling.Custom_Currency/Code
   --  * Currency_Handling.Custom_Currency/Name
   --  * Currency_Handling.Custom_Currency/Symbol
   --  * Currency_Handling.Custom_Currency/Unit
   --  ****

   --  ****m* Currency_Handling.Custom_Currency/Set_Code
   --  SOURCE
   procedure Set_Code
      (This : in out Custom_Currency;
       --  The custom currency
       Item : Wide_Wide_String
       --  New code for the custom currency
      );
   --  FUNCTION
   --    [Re]define the code associated with the currency.
   --  PARAMETERS
   --    Item - New code for the custom currency as wide_wide_string
   --  EXAMPLE
   --    with Cashe.Currency_Handling; use Cashe.Currency_Handling;
   --    declare
   --       My_Cur : Custom_Currency;
   --    begin
   --       My_Cur.Set_Code ("CUR");
   --    end;
   --  ****

   --  ****m* Currency_Handling.Custom_Currency/Set_Name
   --  SOURCE
   procedure Set_Name
      (This : in out Custom_Currency;
       --   The custom currency.
       Item : Wide_Wide_String
       --  New name
      );
   --  FUNCTION
   --    [Re]define the name of the custom currency.
   --  PARAMETERS
   --    Item - New name as wide_wide_string
   --  EXAMPLE
   --    with Cashe.Currency_Handling; use Cashe.Currency_Handling;
   --    declare
   --       My_Cur : Custom_Currency;
   --    begin
   --       My_Cur.Set_Name ("Custom Currency");
   --    end;
   --  ****

   --  ****m* Currency_Handling.Custom_Currency/Set_Symbol
   --  SOURCE
   procedure Set_Symbol
      (This : in out Custom_Currency;
       --   The custom currency.
       Item : Wide_Wide_String
       --  New symbol
      );
   --  FUNCTION
   --    [Re]define the symbol of the custom currency.
   --  PARAMETERS
   --    Item - New symbol as wide_wide_string
   --  EXAMPLE
   --    with Cashe.Currency_Handling; use Cashe.Currency_Handling;
   --    declare
   --       My_Cur : Custom_Currency;
   --    begin
   --       My_Cur.Set_Symbol ("$");
   --    end;
   --  ****

   --  ****m* Currency_Handling.Custom_Currency/Set_Unit
   --  SOURCE
   procedure Set_Unit
      (This : in out Custom_Currency;
       --  The custom currency.
       Item : Natural
       --  New minor
      );
   --  FUNCTION
   --    [Re]define the minor unit of the custom currency.
   --  PARAMETERS
   --    Item - New symbol unit as Natural
   --  EXAMPLE
   --    with Cashe.Currency_Handling; use Cashe.Currency_Handling;
   --    declare
   --       My_Cur : Custom_Currency;
   --    begin
   --       My_Cur.Set_Unit (2);
   --    end;
   --  ****

   --  ****m* Currency_Handling.Custom_Currency/Code
   --  SOURCE
   function  Code   (This : Custom_Currency) return Wide_Wide_String;
   --  FUNCTION
   --    Retrieves the code of the custom currency.
   --  RETURN VALUE
   --    Wide_Wide_String - Code belonging to currency.
   --  EXAMPLE
   --    Ada.Text_Wide_Wide_IO.Put_Line (My_Currency.Code);
   --  ****

   --  ****m* Currency_Handling.Custom_Currency/Name
   --  SOURCE
   function  Name   (This : Custom_Currency) return Wide_Wide_String;
   --  FUNCTION
   --    Retrieves the name of the custom currency.
   --  RETURN VALUE
   --    Wide_Wide_String - name belonging to currency.
   --  EXAMPLE
   --    Ada.Text_Wide_Wide_IO.Put_Line (My_Currency.Name);
   --  ****

   --  ****m* Currency_Handling.Custom_Currency/Symbol
   --  SOURCE
   function  Symbol (This : Custom_Currency) return Wide_Wide_String;
   --  FUNCTION
   --    Retrieves the symbol of the custom currency.
   --  RETURN VALUE
   --    Wide_Wide_String - symbol belonging to currency.
   --  EXAMPLE
   --    Ada.Text_Wide_Wide_IO.Put_Line (My_Currency.Symbol);
   --  ****

   --  ****m* Currency_Handling.Custom_Currency/Unit
   --  SOURCE
   function  Unit   (This : Custom_Currency) return Natural;
   --  FUNCTION
   --    Retrieves the code of the custom currency.
   --  RETURN VALUE
   --    Natural - Minor Unit belonging to currency.
   --  EXAMPLE
   --    My_Unit : Natural := My_Currency.Unit;
   --  ****

   --  ****f* Currency_Handling/Currency_Handling.Create
   --  SOURCE
   function Create
      (Code        : Wide_Wide_String;
       --  Currency's code
       Minor_Unit  : Natural := 0;
       --  Currency's minor unit. Optional.
       Name        : Wide_Wide_String := "";
       --  Currency's name. Optional.
       Symbol      : Wide_Wide_String := ""
       --  Currency's symbol. Optional.
      )
   return Custom_Currency with pre => Minor_Unit <= Max_Precision;
   --  FUNCTION
   --    Create a custom currency according to parameters. Minor unit may not
   --    be greater than maximum precision supported by library.
   --  PARAMETERS
   --    Code - A code as a string, such as "EUR" or "USD".
   --    Minor_Unit - Currency's minor unit. Optional.
   --    Name - Currency's name. Optional.
   --    Symbol - Currency's symbol. Optional.
   --  RETURN VALUE
   --    Currency_Handling/Currency_Handling.Custom_Currency
   --  EXAMPLE
   --    King : Custom_Currency := Create (Code => "KNG",
   --                                      Minor_Unit => 2,
   --                                      Name => "King Currency",
   --                                      Symbol => "K");
   --  ****

   --  ****t* Currency_Handling/Currency_Handling.Currency_Type
   --  SOURCE
   type Currency_Type is (Type_Custom_Currency, Type_ISO_Currency);
   --  DESCRIPTION
   --    For Currency_Data variant record.
   --  SEE ALSO
   --    Currency_Handling/Currency_Handling.Currency_Data
   --  ****

   --  ****s* Currency_Handling/Currency_Handling.Currency_Data
   --  SOURCE
   type Currency_Data
      (Which_Currency_Type : Currency_Type := Type_ISO_Currency)
   is record
      case Which_Currency_Type is
         when Type_Custom_Currency =>
            --  The custom currency that will be stored in money/exchange.
            Custom_Code : Custom_Currency;
         when Type_ISO_Currency =>
            --  The ISO currency that will be stored in the money/exchange.
            ISO_Code : ISO.Currencies.Currency;
      end case;
   end record;
   --  DESCRIPTION
   --     A "holder" for both custom or non-custom currency, if needed.
   --     Which kind of currency can be verified by accessing the object's
   --     "Which_Currency_Data" later on.
   --  PARAMETERS
   --    Which_Currency_Type: Which kind of currency?
   --  EXAMPLE
   --    declare
   --       My_Holder : Currency_Data :=
   --          (Which_Currency_Type => Type_ISO_Currency,
   --           ISO_Code            => ISO.Currencies.From_Code ("USD"));
   --    begin
   --       case My_Holder.Which_Currency_Type is
   --          when Type_Custom_Currency =>
   --             Put_Line ("Currency is " & My_Holder.Custom_Code.Name);
   --          when Type_ISO_Currency =>
   --             Put_Line ("Currency is " & My_Holder.ISO_Code.Name);
   --             Put_Line ("And Numeric is " & My_Holder.ISO_Code.Numeric);
   --       end case;
   --    end;
   --  SEE ALSO
   --    Currency_Handling/Currency_Handling.Currency_Type
   --  ****

private

   type Custom_Currency is tagged record
      Custom_Code   :
         Ada.Strings.Wide_Wide_Unbounded.Unbounded_Wide_Wide_String;
      Custom_Symbol :
         Ada.Strings.Wide_Wide_Unbounded.Unbounded_Wide_Wide_String;
      Custom_Name   :
         Ada.Strings.Wide_Wide_Unbounded.Unbounded_Wide_Wide_String;
      Custom_Minor_Unit : Natural := 0;
   end record;

end Cashe.Currency_Handling;
