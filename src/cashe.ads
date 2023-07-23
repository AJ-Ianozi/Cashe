pragma Ada_2022;
--  ****h* Cashe/Cashe
--  SOURCE
package Cashe is
--  DESCRIPTION
--    This package provides datatypes and functions utilized by other packages.
--  ****

   --  ****t* Cashe/Cashe.Decimal
   --  SOURCE
   type Decimal is delta 1.0E-20 digits 38;
   --  DESCRIPTION
   --    128-bit decimal number, ranging from:
   --    -999_999_999_999_999_999.99999999999999999999 to
   --    999_999_999_999_999_999.99999999999999999999
   --    Used for storing the currency.
   --  EXAMPLE
   --    My_Dec : Decimal := 1.12345678909876543210;
   --  ****

   --  ****d* Cashe/Cashe.Max_Precision
   --  SOURCE
   Max_Precision   : constant := 20;
   --  DESCRIPTION
   --    The maximum precision that this decimal type has.
   --  ****

   --  ****t* Cashe/Cashe.Decimal_Major
   --  SOURCE
   subtype Decimal_Major is Long_Long_Integer
      range -(1E+18 - 1) .. +(1E+18 - 1);
   --  DESCRIPTION
   --    Integer number, ranging from:
   --    -999_999_999_999_999_999 to 999_999_999_999_999_999
   --    Used for setting major units without precision.
   --  DERIVED FROM
   --    Long_Long_Integer
   --  ****

   --  ****d* Cashe/Cashe.Max_Integer_Len
   --  SOURCE
   Max_Integer_Len : constant := 18;
   --  DESCRIPTION
   --    The maximum number of decimal numbers that a major unit can be.
   --  ****

   --  ****t* Cashe/Cashe.Decimal_Minor
   --  SOURCE
   subtype Decimal_Minor is Long_Long_Long_Integer
      range -(1E+38 - 1) .. +(1E+38 - 1);
   --  DESCRIPTION
   --    128-bit integer number, ranging from:
   --    -99_999_999_999_999_999_999_999_999_999_999_999_999 to
   --    99_999_999_999_999_999_999_999_999_999_999_999_999
   --    Used for setting / accessing minor units
   --  DERIVED FROM
   --    Long_Long_Long_Integer
   --  ****

   --  ****e* Cashe/Cashe.Minor_Unit_Too_Large
   --  SOURCE
   Minor_Unit_Too_Large : exception;
   --  DESCRIPTION
   --    Raised if the minor unit will not "fit" into the major unit.
   --  ****

   --  ****t* Cashe/Cashe.Round_Method
   --  SOURCE
   type Round_Method is (
      Half_Even,
      --  Default rounding method, also known as "Banker's Rounding"
      Half_Up
      --  Standard-behavior rounding, the kind taught in highschool.
      );
   --  DESCRIPTION
   --    Rounding methods.
   --  ****

   --  ****f* Cashe/Cashe.To_Decimal
   --  SOURCE
   function To_Decimal
      (Item : Float;
       --  Floating point to be converted to a decimal.
       Precision : Natural := 20
       --  Precision to round to. Default is 20.
      ) return Decimal;
   function To_Decimal
      (Item : Long_Float;
       --  Floating point to be converted to a decimal.
       Precision : Natural := 20
       --  Precision to round to. Default is 20.
      ) return Decimal;
   function To_Decimal
      (Item : Long_Long_Float;
       --  Floating point to be converted to a decimal.
       Precision : Natural := 20
       --  Precision to round to. Default is 20.
       ) return Decimal;
   function To_Decimal
      (Value : Decimal_Minor;
       --  The whole number which to convert into a decimal
       Precision : Natural := 20
       --  The maount of decimal places out
      )
   return Decimal with
      pre => Precision <= Max_Precision;
   --  FUNCTION
   --    Convert a floating point number or minor unit to a Decimal based on
   --    precision.  Highly recommended to use this function with 
   --    Long_Long_Float for highest precision.
   --  PARAMETERS
   --    Item - Floating point to be converted.
   --    Precision - Precision to round to. Default is 20.
   --  RETURN VALUE
   --    Cashe.Decimal - Decimal value of float to Precision.
   --  ERRORS
   --    * Cashe/Cashe.Minor_Unit_Too_Large in case of converting Minor Unit
   --  EXAMPLE
   --    with Cashe; use Cashe;
   --    D : Decimal_Minor   :=                1411900
   --    F : Long_Long_Float :=                14.1190004014938372284932918;
   --    A : Decimal := To_Decimal (F);    --  14.11900040149383722880
   --    B : Decimal := To_Decimal (F, 3); --  14.11900000000000000000
   --    C : Decimal := To_Decimal (F, 2); --  14.12000000000000000000
   --    E : Decimal := To_Decimal (D, 5); --  14.11900
   --  ****

   --  ****f* Cashe/Cashe.Round
   --  SOURCE
   function Round
      (Item : Decimal;
       --  The decimal to round
       By : Natural;
       --  The precision which to round to.
       Method : Round_Method := Half_Even
       --  The method of rounding.  Default is Half_Even aka Banker's Rounding.
      )
   return Decimal with pre => By <= Max_Precision;
   --  FUNCTION
   --    Round the value of a money object to a given precision
   --  PARAMETERS
   --    Item - Decimal to be rounded
   --    By - Precision to round to.
   --  RETURN VALUE
   --    Cashe.Decimal - Decimal value rounded to Precision.
   --  EXAMPLE
   --    T : Decimal := -2000.005;
   --    A : Decimal := Round (T, 2);          --  -2000.00
   --    B : Decimal := Round (T, 2, Half_Up); --  -2000.01
   --  ****

private
   --  Helper function for decimal math.
   function Pow (Base : Decimal; Exponent : Integer) return Decimal;
   type Shift_Direction is (Shift_Left, Shift_Right);
   function Shift_Decimal
      (Item : Decimal; By : Natural; Direction : Shift_Direction)
   return Decimal;
   function Shift_Float
      (Item : Long_Long_Float; By : Natural; Direction : Shift_Direction)
   return Long_Long_Float;
   --  Calculates the length of the integer. So 123 returns 3.
   function Integer_Width (Item : Long_Long_Long_Integer) return Natural;
   --  Calculates the low and high of an integer
   function Low (Number : Long_Long_Long_Integer; N : Natural)
   return Long_Long_Long_Integer;
   function High (Number : Long_Long_Long_Integer; N : Natural)
   return Long_Long_Long_Integer;
end Cashe;
