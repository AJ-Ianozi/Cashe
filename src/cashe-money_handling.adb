with Ada.Characters.Conversions;
with Ada.Strings.Wide_Wide_Fixed;
package body Cashe.Money_Handling is

   function Same_Currency
      (This : Money; Item : Money)
   return Boolean is
      use Currency_Handling;
   begin
      return This.Cur = Item.Cur;
   end Same_Currency;
   function Is_Custom_Currency (This : Money) return Boolean is
      use Currency_Handling;
   begin
      return This.Cur.Which_Currency_Type = Type_Custom_Currency;
   end Is_Custom_Currency;
   function Get_Currency
      (This : Money) return Currency_Handling.Currency_Data is
         (This.Cur);
   function Currency_Name (This : Money) return Wide_Wide_String is
      use Currency_Handling;
      use Ada.Characters.Conversions;
   begin
      case This.Cur.Which_Currency_Type is
         when Type_Custom_Currency =>
            return This.Cur.Custom_Code.Name;
         when Type_ISO_Currency =>
            return To_Wide_Wide_String (This.Cur.ISO_Code.Name);
      end case;
   end Currency_Name;
   function Currency_Code (This : Money) return Wide_Wide_String is
      use Currency_Handling;
      use Ada.Characters.Conversions;
   begin
      case This.Cur.Which_Currency_Type is
         when Type_Custom_Currency =>
            return This.Cur.Custom_Code.Code;
         when Type_ISO_Currency =>
            return To_Wide_Wide_String (This.Cur.ISO_Code.Code);
      end case;
   end Currency_Code;
   function Currency_Symbol (This : Money) return Wide_Wide_String is
      use Currency_Handling;
   begin
      case This.Cur.Which_Currency_Type is
         when Type_Custom_Currency => return This.Cur.Custom_Code.Symbol;
         when Type_ISO_Currency    => return This.Cur.ISO_Code.Symbol;
      end case;
   end Currency_Symbol;
   function Currency_Unit (This : Money) return Natural is
      use Currency_Handling;
   begin
      case This.Cur.Which_Currency_Type is
         when Type_Custom_Currency => return This.Cur.Custom_Code.Unit;
         when Type_ISO_Currency    => return This.Cur.ISO_Code.Unit;
      end case;
   end Currency_Unit;
   function Is_Zero (This : Money) return Boolean is (This.Amount = 0.0);
   function Is_Positive (This : Money) return Boolean is (This.Amount > 0.0);
   function Is_Negative (This : Money) return Boolean is (This.Amount < 0.0);
   function Round
      (This : Money;
       By : Natural;
       Method : Round_Method := Half_Even)
   return Money
      is ( (Amount => Round (This.Amount, By, Method),
            Cur => This.Cur));
   function Round (This : Money; Method : Round_Method := Half_Even)
      return Money is
         (This.Round (By => This.Currency_Unit, Method => Method));
   function Full_Precision (This : Money) return Decimal is (This.Amount);
   function As_Major (This : Money) return Decimal is (This.Round.Amount);
   function As_Minor (This : Money) return Decimal_Minor
   is
      use Currency_Handling;
      Multiplier : constant Long_Long_Float := 10.0 **
         (case This.Cur.Which_Currency_Type is
            when Type_Custom_Currency => This.Cur.Custom_Code.Unit,
            when Type_ISO_Currency    => This.Cur.ISO_Code.Unit);
   begin
      return Decimal_Minor
               (Decimal'Round
                  (Long_Long_Float (This.Round.Amount) * Multiplier));
   end As_Minor;

   --  Operator overloading
function "+"   (Left, Right : Money) return Money is
   (if Left.Same_Currency (Right) then
      (Amount => Left.Amount + Right.Amount, Cur => Left.Cur)
      else raise Currency_Mismatch);
function "+"   (Left : Money; Right : Decimal) return Money is
   ((Amount => Left.Amount + Right, Cur => Left.Cur));
function "+"   (Left : Money; Right : Decimal_Minor) return Money is
   (Left + Decimal (Right));

function "-"   (Left : Money) return Money is
   ((Amount => -(Left.Amount), Cur => Left.Cur));
function "-"   (Left, Right : Money) return Money is
   (if Left.Same_Currency (Right) then
      (Amount => Left.Amount - Right.Amount, Cur => Left.Cur)
      else raise Currency_Mismatch);
function "-"   (Left : Money; Right : Decimal) return Money is
   ((Amount => Left.Amount - Right, Cur => Left.Cur));
function "-"   (Left : Money; Right : Decimal_Minor) return Money is
   (Left - Decimal (Right));

function "*" (Left, Right : Money) return Money is
   (if Left.Same_Currency (Right) then
      (Amount => Left.Amount * Right.Amount, Cur => Left.Cur)
      else raise Currency_Mismatch);
function "*" (Left : Money; Right : Decimal) return Money is
   ((Amount => Left.Amount * Right, Cur => Left.Cur));
function "*" (Left : Money; Right : Decimal_Minor) return Money is
   (Left * Decimal (Right));

   function "/"   (Left, Right : Money) return Money is
      (if Left.Same_Currency (Right) then
         (if (not Right.Is_Zero) then
            (Amount => Left.Amount / Right.Amount, Cur => Left.Cur)
         else raise Division_By_Zero)
       else raise Currency_Mismatch);
   function "/"   (Left : Money; Right : Decimal) return Money is
      ((Amount => Left.Amount / Right, Cur => Left.Cur));
   function "/"   (Left : Money; Right : Decimal_Minor) return Money is
      (Left / Decimal (Right));

   function "abs" (Left : Money) return Money is
      ((Amount => abs Left.Amount, Cur => Left.Cur));

   --  Logical stuff.
   function "<"  (Left, Right : Money) return Boolean is
      (if Left.Same_Currency (Right) then
         (Left.Amount < Right.Amount) or else
            raise Currency_Mismatch);
   function ">"  (Left, Right : Money) return Boolean is
      (if Left.Same_Currency (Right) then
         (Left.Amount > Right.Amount) or else
            raise Currency_Mismatch);
   function "<=" (Left, Right : Money) return Boolean is
      (if Left.Same_Currency (Right) then
         (Left.Amount <= Right.Amount) or else
            raise Currency_Mismatch);
   function ">=" (Left, Right : Money) return Boolean is
      (if Left.Same_Currency (Right) then
         (Left.Amount >= Right.Amount) or else
            raise Currency_Mismatch);
   overriding function "="  (Left : Money; Right : Money) return Boolean is
   begin
      return Left.Same_Currency (Right) and then
         Left.Round.Amount = Right.Round.Amount;
   end "=";

   function "<"  (Left : Money; Right : Decimal) return Boolean is
      (Left.Amount < Right);
   function ">"  (Left : Money; Right : Decimal) return Boolean is
      (Left.Amount > Right);
   function "<=" (Left : Money; Right : Decimal) return Boolean is
      (Left.Amount <= Right);
   function ">=" (Left : Money; Right : Decimal) return Boolean is
      (Left.Amount >= Right);
   function "="  (Left : Money; Right : Decimal) return Boolean is
      (Left.Round.Amount = Right);

   function "<"  (Left : Money; Right : Decimal_Major) return Boolean is
      (Left.Amount < Decimal (Right));
   function ">"  (Left : Money; Right : Decimal_Major) return Boolean is
      (Left.Amount > Decimal (Right));
   function "<=" (Left : Money; Right : Decimal_Major) return Boolean is
      (Left.Amount <= Decimal (Right));
   function ">=" (Left : Money; Right : Decimal_Major) return Boolean is
      (Left.Amount >= Decimal (Right));
   function "="  (Left : Money; Right : Decimal_Major) return Boolean is
      (Left.Round.Amount = Decimal (Right));
   --  Creation functions
   --  Major Decimals
   function From_Major
            (Amount        : Decimal;
             Currency_Used : Currency_Handling.Currency_Data)
   return Money is
      (((Amount => Amount,
         Cur    => Currency_Used)));
   function From_Major
            (Amount        : Decimal;
             Currency_Used : Currency_Handling.Custom_Currency)
   return Money is
      use Currency_Handling;
      CC : constant Currency_Data := (Type_Custom_Currency, Currency_Used);
   begin
      return From_Major (Amount, CC);
   end From_Major;
   function From_Major
            (Amount        : Decimal;
             Currency_Used : ISO.Currencies.Currency)
   return Money is
      use Currency_Handling;
      CC : constant Currency_Data := (Type_ISO_Currency, Currency_Used);
   begin
      return From_Major (Amount, CC);
   end From_Major;
   function From_Major
            (Amount        : Decimal;
             Currency_Used : ISO.Currencies.Alphabetic_Code)
   return Money is
      (From_Major (Amount, ISO.Currencies.From_Code (Currency_Used)));
   --  Major Long_Long_Ints
   function From_Major
            (Amount          : Decimal_Major;
             Currency_Used : Currency_Handling.Currency_Data)
   return Money is (From_Major (Decimal (Amount), Currency_Used));
   function From_Major
            (Amount          : Decimal_Major;
             Currency_Used : Currency_Handling.Custom_Currency)
   return Money is (From_Major (Decimal (Amount), Currency_Used));
   function From_Major
            (Amount        : Decimal_Major;
             Currency_Used : ISO.Currencies.Currency)
   return Money is (From_Major (Decimal (Amount), Currency_Used));
   function From_Major
            (Amount          : Decimal_Major;
             Currency_Used : ISO.Currencies.Alphabetic_Code)
   return Money is (From_Major (Decimal (Amount), Currency_Used));
   --  Major - Strings
   function From_Major
            (Amount          : String;
             Currency_Used : Currency_Handling.Currency_Data)
   return Money is (From_Major (Decimal'Value (Amount), Currency_Used));
   function From_Major
            (Amount          : String;
             Currency_Used : Currency_Handling.Custom_Currency)
   return Money is (From_Major (Decimal'Value (Amount), Currency_Used));
   function From_Major
            (Amount          : String;
             Currency_Used : ISO.Currencies.Currency)
   return Money is (From_Major (Decimal'Value (Amount), Currency_Used));
   function From_Major
            (Amount          : String;
             Currency_Used : ISO.Currencies.Alphabetic_Code)
   return Money is (From_Major (Decimal'Value (Amount), Currency_Used));
   --  Minor - Decimals
   function From_Minor
            (Amount        : Decimal_Minor;
             Currency_Used : Currency_Handling.Currency_Data)
   return Money
   is
      use Currency_Handling;
      Unit        : constant Natural :=
                     (case Currency_Used.Which_Currency_Type is
                        when Type_Custom_Currency =>
                           Currency_Used.Custom_Code.Unit,
                        when Type_ISO_Currency =>
                           Currency_Used.ISO_Code.Unit);
      Amount_Width : constant Natural := Integer_Width (Amount);
      True_Amount : constant Decimal :=
         (if Amount_Width  - Max_Integer_Len <= Unit then
            To_Decimal (Amount, Unit)
         else raise Minor_Unit_Too_Large);
   begin
      return From_Major (True_Amount, Currency_Used);
   end From_Minor;
   function From_Minor
            (Amount        : Decimal_Minor;
             Currency_Used : Currency_Handling.Custom_Currency)
   return Money
   is
      use Currency_Handling;
      CC : constant Currency_Data := (Type_Custom_Currency, Currency_Used);
   begin
      return From_Minor (Amount, CC);
   end From_Minor;
   function From_Minor
            (Amount        : Decimal_Minor;
             Currency_Used : ISO.Currencies.Currency)
   return Money
   is
      use Currency_Handling;
      CC : constant Currency_Data :=  (Type_ISO_Currency, Currency_Used);
   begin
      return From_Minor (Amount, CC);
   end From_Minor;
   function From_Minor
            (Amount        : Decimal_Minor;
             Currency_Used : ISO.Currencies.Alphabetic_Code)
   return Money is
      (From_Minor (Amount, ISO.Currencies.From_Code (Currency_Used)));
   --  Minor - String
   function From_Minor
            (Amount        : String;
             Currency_Used : Currency_Handling.Currency_Data)
   return Money is (From_Minor (Decimal_Minor'Value (Amount), Currency_Used));
   function From_Minor
            (Amount        : String;
             Currency_Used : Currency_Handling.Custom_Currency)
   return Money is (From_Minor (Decimal_Minor'Value (Amount), Currency_Used));
   function From_Minor
            (Amount        : String;
             Currency_Used : ISO.Currencies.Currency)
   return Money is (From_Minor (Decimal_Minor'Value (Amount), Currency_Used));
   function From_Minor
            (Amount        : String;
             Currency_Used : ISO.Currencies.Alphabetic_Code)
   return Money is (From_Minor (Decimal_Minor'Value (Amount), Currency_Used));

   procedure Print_Money
      (Buffer : in out Ada.Strings.Text_Buffers.Root_Buffer_Type'Class;
       Value  : Money)
   is
      use ISO.Currencies;
      use Currency_Handling;
      use Ada.Strings.Wide_Wide_Fixed;
      Unit : constant Natural :=
         (case Value.Cur.Which_Currency_Type is
            when Type_Custom_Currency => Value.Cur.Custom_Code.Unit,
            when Type_ISO_Currency    => Value.Cur.ISO_Code.Unit);
      Amt   : constant Wide_Wide_String :=
               Value.Round.Amount'Wide_Wide_Image;
      Point : constant Natural := Index (Amt, ".");
   begin
      Buffer.Wide_Wide_Put
         (Value.Currency_Symbol & Amt (Amt'First .. Point - 1));
      if Unit > 0 then
         Buffer.Wide_Wide_Put (Amt (Point .. Point + Unit));
      end if;
   end Print_Money;

end Cashe.Money_Handling;