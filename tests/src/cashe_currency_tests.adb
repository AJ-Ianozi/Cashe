with Ada.Assertions; use Ada.Assertions;
with Cashe; use Cashe;
with Cashe.Currency_Handling; use Cashe.Currency_Handling;
package body Cashe_Currency_Tests is

   procedure Run_Tests is

      --  Create some currency for simple testing.
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

   begin
      --  Create a currency of every precision.
      for I in 0 .. Cashe.Max_Precision loop
         declare
            One : constant Custom_Currency :=
               Create (I'Wide_Wide_Image, I,
                        "Currency " & I'Wide_Wide_Image, I'Wide_Wide_Image);
            Two : Custom_Currency;
         begin
            Two.Set_Code   (One.Code);
            Two.Set_Name   (One.Name);
            Two.Set_Symbol (One.Symbol);
            Two.Set_Unit   (One.Unit);
            Assert (Two.Code = I'Wide_Wide_Image);
            Assert (Two.Name = "Currency " & I'Wide_Wide_Image);
            Assert (Two.Symbol = I'Wide_Wide_Image);
            Assert (Two.Unit = I);
         end;
      end loop;

   end Run_Tests;
end Cashe_Currency_Tests;