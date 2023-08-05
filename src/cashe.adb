package body Cashe is

   --  Helper functions
   function Integer_Width (Item : Long_Long_Long_Integer) return Natural
   is (Item'Image'Length - 1);
   function Shift_Decimal
      (Item : Decimal; By : Natural; Direction : Shift_Direction)
   return Decimal is
      Result : Decimal := Item;
      Multiplier : constant Decimal :=
         (case Direction is when Shift_Left => 10.0, when Shift_Right => 0.1);
   begin
      for I in 1 .. By loop
         Result := Result * Multiplier;
      end loop;
      return Result;
   end Shift_Decimal;
   function Shift_Float
      (Item : Long_Long_Float; By : Natural; Direction : Shift_Direction)
   return Long_Long_Float is
      Result : Long_Long_Float := Item;
      Multiplier : constant Long_Long_Float :=
         (case Direction is when Shift_Left => 10.0, when Shift_Right => 0.1);
   begin
      for I in 1 .. By loop
         Result := Result * Multiplier;
      end loop;
      return Result;
   end Shift_Float;
   function Pow
      (Base : Decimal; Exponent : Integer) return Decimal
   is
      True_Base : constant Decimal :=
                  (if Exponent >= 0 then Base else 1.0 / Base);
      Result : Decimal := (if Exponent = 0 then 1.0 else True_Base);
   begin
      for I in 2 .. abs Exponent loop
         Result := Result * True_Base;
      end loop;
      return Result;
   end Pow;
   function Low (Number : Long_Long_Long_Integer; N : Natural)
   return Long_Long_Long_Integer is
      Modder : constant Long_Long_Long_Integer := 10 ** N;
   begin
      return Number mod Modder;
   end Low;
   function High (Number : Long_Long_Long_Integer; N : Natural)
   return Long_Long_Long_Integer is
      Divisor : constant Long_Long_Long_Integer := 10 ** N;
      Result : Long_Long_Long_Integer := Number;
   begin
      while Result / Divisor > 0 loop
         Result := Result / 10;
      end loop;
      return Result;
   end High;
   function To_Decimal
      (Value : Decimal_Minor; Precision : Natural := 20)
   return Decimal
   is
      Width : constant Natural := Integer_Width (Value);
   begin
      if Width <= Max_Integer_Len then
         return Shift_Decimal (Decimal (Value), Precision, Shift_Right);
      elsif Precision <= Max_Precision then
         declare
            Dec_Low : constant Decimal_Minor :=
                  Low (Value, Precision);
            Dec_High : constant Decimal :=
               Decimal (High (Value, Width - Precision));
         begin
            if Precision < Max_Integer_Len then
               return Dec_High +
                        Shift_Decimal
                           (Decimal (Dec_Low), Precision, Shift_Right);
            else
               --  I need to do this because there's only 18 decimal places
               --  on the left, and 20 on the right. If we get >128bit fixed
               --  decimals this won't be an issue.
               declare
                  Low_High_Len : constant Natural :=
                     Precision - Max_Integer_Len;
                  Dec_Low_Low : constant Decimal :=
                     Shift_Decimal
                        (Decimal (Low (Dec_Low, Max_Integer_Len)),
                          Max_Integer_Len + Low_High_Len, Shift_Right);
                  Dec_Low_High : constant Decimal :=
                     Shift_Decimal
                        (Decimal (High (Dec_Low, Low_High_Len)),
                         Low_High_Len, Shift_Right);
               begin
                  return Dec_High + Dec_Low_High + Dec_Low_Low;
               end;
            end if;
         end;
      else
         raise Minor_Unit_Too_Large;
      end if;
   end To_Decimal;

   function To_Decimal
      (Item : Long_Long_Float; Precision : Natural := 20)
   return Decimal is
   begin
      --  I'm sure there's a better way of doing this
      --  But this gives me precision up to 20.
      case Precision is
         when 0 =>
            declare
               type Delta1 is delta 1.0E-1 digits 38;
               Tmp : constant Decimal_Major :=
                        Decimal_Major (Delta1'Round (Item));
            begin
               return Decimal (Tmp);
            end;
         when 1 =>
            declare
               type Delta1 is delta 1.0E-1 digits 38;
               Tmp : constant Delta1 := Delta1'Round (Item);
            begin
               return Decimal (Tmp);
            end;
         when 2 =>
            declare
               type Delta2 is delta 1.0E-2 digits 38;
               Tmp : constant Delta2 := Delta2'Round (Item);
            begin
               return Decimal (Tmp);
            end;
         when 3 =>
            declare
               type Delta3 is delta 1.0E-3 digits 38;
               Tmp : constant Delta3 := Delta3'Round (Item);
            begin
               return Decimal (Tmp);
            end;
         when 4 =>
            declare
               type Delta4 is delta 1.0E-4 digits 38;
               Tmp : constant Delta4 := Delta4'Round (Item);
            begin
               return Decimal (Tmp);
            end;
         when 5 =>
            declare
               type Delta5 is delta 1.0E-5 digits 38;
               Tmp : constant Delta5 := Delta5'Round (Item);
            begin
               return Decimal (Tmp);
            end;
         when 6 =>
            declare
               type Delta6 is delta 1.0E-6 digits 38;
               Tmp : constant Delta6 := Delta6'Round (Item);
            begin
               return Decimal (Tmp);
            end;
         when 7 =>
            declare
               type Delta7 is delta 1.0E-7 digits 38;
               Tmp : constant Delta7 := Delta7'Round (Item);
            begin
               return Decimal (Tmp);
            end;
         when 8 =>
            declare
               type Delta8 is delta 1.0E-8 digits 38;
               Tmp : constant Delta8 := Delta8'Round (Item);
            begin
               return Decimal (Tmp);
            end;
         when 9 =>
            declare
               type Delta9 is delta 1.0E-9 digits 38;
               Tmp : constant Delta9 := Delta9'Round (Item);
            begin
               return Decimal (Tmp);
            end;
         when 10 =>
            declare
               type Delta10 is delta 1.0E-10 digits 38;
               Tmp : constant Delta10 := Delta10'Round (Item);
            begin
               return Decimal (Tmp);
            end;
         when 11 =>
            declare
               type Delta11 is delta 1.0E-11 digits 38;
               Tmp : constant Delta11 := Delta11'Round (Item);
            begin
               return Decimal (Tmp);
            end;
         when 12 =>
            declare
               type Delta12 is delta 1.0E-12 digits 38;
               Tmp : constant Delta12 := Delta12'Round (Item);
            begin
               return Decimal (Tmp);
            end;
         when 13 =>
            declare
               type Delta13 is delta 1.0E-13 digits 38;
               Tmp : constant Delta13 := Delta13'Round (Item);
            begin
               return Decimal (Tmp);
            end;
         when 14 =>
            declare
               type Delta14 is delta 1.0E-14 digits 38;
               Tmp : constant Delta14 := Delta14'Round (Item);
            begin
               return Decimal (Tmp);
            end;
         when 15 =>
            declare
               type Delta15 is delta 1.0E-15 digits 38;
               Tmp : constant Delta15 := Delta15'Round (Item);
            begin
               return Decimal (Tmp);
            end;
         when 16 =>
            declare
               type Delta16 is delta 1.0E-16 digits 38;
               Tmp : constant Delta16 := Delta16'Round (Item);
            begin
               return Decimal (Tmp);
            end;
         when 17 =>
            declare
               type Delta17 is delta 1.0E-17 digits 38;
               Tmp : constant Delta17 := Delta17'Round (Item);
            begin
               return Decimal (Tmp);
            end;
         when 18 =>
            declare
               type Delta18 is delta 1.0E-18 digits 38;
               Tmp : constant Delta18 := Delta18'Round (Item);
            begin
               return Decimal (Tmp);
            end;
         when 19 =>
            declare
               type Delta19 is delta 1.0E-19 digits 38;
               Tmp : constant Delta19 := Delta19'Round (Item);
            begin
               return Decimal (Tmp);
            end;
         when others =>
            declare
               Tmp : constant Decimal := Decimal'Round (Item);
            begin
               return Tmp;
            end;
      end case;
   end To_Decimal;

   function To_Decimal
      (Item : Long_Float; Precision : Natural := 20)
   return Decimal is
      (To_Decimal (Long_Long_Float (Item), Precision));
   function To_Decimal
      (Item : Float; Precision : Natural := 20)
   return Decimal is
      (To_Decimal (Long_Long_Float (Item), Precision));

   function Round
      (Item : Decimal;
       By : Natural;
       Method : Round_Method := Half_Even)
   return Decimal
   is
      Init    : constant Long_Long_Float :=
                  (Shift_Float
                     (Long_Long_Float (Item), By, Shift_Left));
      Rounded : constant Long_Long_Float :=
                  (case Method is
                     when Half_Up =>
                        Long_Long_Float'Rounding (Init),
                     when Half_Even =>
                        Long_Long_Float'Unbiased_Rounding (Init));
   begin

      if By >= 20 then
         return Item;
      else
         return To_Decimal (Shift_Float (Rounded, By, Shift_Right), By);
      end if;

   end Round;

end Cashe;