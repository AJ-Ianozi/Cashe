pragma Ada_2022;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Assertions; use Ada.Assertions;
with Cashe; use Cashe;
with ISO.Currencies; use ISO.Currencies;
with Cashe.Money_Handling; use Cashe.Money_Handling;
with Cashe.Currency_Handling; use Cashe.Currency_Handling;
with Ada.Containers.Vectors;
with Ada.Characters.Conversions; use Ada.Characters.Conversions;
package body Cashe_Money_Tests is
   --  Create a list of money.
   package Money_List is new
     Ada.Containers.Vectors
       (Index_Type   => Natural,
        Element_Type => Money);
      use Money_List;
   procedure Run_Tests is

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



      --  Create some money.
      Test_KN1 :  Money := From_Major (9001.99, King_Currency);
      Test_KN2 : constant Money := From_Minor (900999, King_Currency);
      Test_US0 : constant Money := From_Major ("-2000.005", "USD");
      Test_US1 : constant Money := From_Major (875.00, "USD");
      Test_US2 : constant Money := From_Minor (87500, "USD");
      Test_US3 : constant Money := From_Major (0.0, USD);
      Test_US4 : constant Money := From_Minor (0, USD);
      Test_YEN : constant Money := From_Major ("12345", "JPY");
      Test_EU1 : constant Money := From_Major (2489.00, "EUR");
      Test_EU2 : constant Money := From_Minor (248500, "EUR");
      Test_AUD : constant Money := From_Major (-50, "AUD");
      Test_OMR : constant Money := From_Minor (9383314, "OMR");
      Test_BTC : constant Money := From_Minor (5000000000, Bitcoin);
      Test_Wei : constant Money := From_Minor (1000000000000000000, Ethereum);
      Test_We2 : constant Money := Test_Wei.Round;
      Test_RAD : constant Money := From_Major (1234, RadCur);
      Test_ADA : constant Money := From_Major (45678.123456789098765, Cardano);

      Every_ISO : constant ISO.Currencies.All_Currencies :=
                     ISO.Currencies.Init_Currencies;

      -- Test Items
      Item_Dec : constant Decimal           := 123456789.0;
      Item_Int : constant Decimal_Major := 123456789;
      Item_Big : constant Decimal_Minor := 123456789;
      Item_Str : constant String            := "123456789.0";
      Item_IStr : constant String := "123456789";

   begin
      --  Verify overloaded operations.
      Assert (Test_US1 = Test_US2);
      Assert (Test_US1 <= Test_US2);
      Assert (Test_US1 >= Test_US2);
      Assert (Test_US3 = Test_US4);
      Assert (Test_US0 < Test_US1);
      Assert (Test_US0 < Test_US1);
      Assert (Test_US0 < From_Major ("-2000.00", USD));
      Assert (Test_US0 <= Test_US1);
      Assert (Test_US1 > Test_US0);
      Assert (Test_US1 >= Test_US0);

      Assert (Test_US1 = 875);
      Assert (not (Test_US1 > 900));
      Assert (Test_US1 >= 875);
      Assert (Test_US0 < 900);
      Assert (Test_US4 <= 0);

      Assert (Test_YEN = From_Major (12345, "JPY"));
      Assert (Test_YEN = From_Minor (12345, "JPY"));

      Assert (Test_US1 = 875.00);
      Assert (not (Test_US1 > 900.00));
      Assert (Test_US1 >= 875.00);
      Assert (Test_US0 < 900.00);
      Assert (Test_US4 <= 0.0);

      Assert (abs Test_AUD = 50);
      Assert (abs Test_US4.As_Minor = 0);

      Assert ((Test_US1 + Test_US2) = 1750);
      Assert ((Test_US1 + 875) = 1750);
      Assert ((Test_US1 + 875.00) = 1750);

      Assert ((Test_US1 + Test_US2) = 1750.00);
      Assert ((Test_US1 + 875) = 1750.00);
      Assert ((Test_US1 + 875.00) = 1750.00);
      Assert ((From_Major (875.00, "USD") + 0.001) = 875.00);

      Assert ((Test_KN2 - Test_KN1) = 8);

      Assert ((Test_KN2 - 9001.99) = 8);
      Assert ((Test_KN2 - 9001) = 8.99);

      --  Test values
      Assert (Test_KN1'Image = "👑 9001.99");
      Assert (Test_US1'Image = "$ 875.00");
      Assert (Test_AUD'Image = "$-50.00");

      Assert (Test_US0.Full_Precision = -2000.005);
      Assert (Test_US1.As_Major = 875.00);
      Assert (Test_US1.As_Minor = 87500);
      Assert (Test_KN1.As_Minor = 900199);
      Assert (Test_KN2.As_Major = 9009.99);

      --  Test Postiive and 
      Assert (Test_US1.Same_Currency (Test_US2));
      Assert (Test_KN2.Same_Currency (Test_KN1));
      Assert (not Test_US1.Same_Currency (Test_KN1));
      Assert (not Test_US1.Same_Currency (Test_YEN));
      --  Custom currency
      Assert (not Test_US1.Is_Custom_Currency);
      Assert (Test_KN1.Is_Custom_Currency);
      --  Get currency data.
      declare
         My_Currency_Data1 : constant Currency_Data :=
                              Test_US1.Get_Currency;
         My_Currency_Data2 : constant Currency_Data :=
                              Test_KN1.Get_Currency;
      begin 
         Assert
            (My_Currency_Data1.ISO_Code = USD);
         Assert (My_Currency_Data2.Custom_Code = King_Currency);
      end;
      --  Assert name and code.

      --  Rounding
      Assert (Test_US0.Round (2) = From_Major (-2000.00, USD));
      Assert (Test_US0.Round (2, Half_Up) = From_Major (-2000.01, USD));
      Assert (Test_US0.As_Major = -2000.00);
      Assert (Test_US0.As_Minor = -200000);

      --  Testing max minor unit values
      declare
         C   : constant Custom_Currency := Create ("IDK", 20);
         CD  : constant Currency_Data := (Type_Custom_Currency, C);
         C_1 : constant Money := From_Minor (Decimal_Minor'Last, C);
         C_2 : constant Money := From_Minor (Decimal_Minor'Last'Image, CD);
      begin
         Assert (C_1 = C_2);
         Assert (C_1.Full_Precision = 999999999999999999.99999999999999999999);
      end;

      --  Test fuzzy equality
      declare
         Mut : Money := From_Major  (7.22, "USD");
         Mut2 : Money := From_Minor (777, "USD");
      begin
         Mut := Mut + 0.55;
         Assert (Mut = 7.77);
         Mut := Mut - 0.0001;
         Assert (Mut = 7.77);
         Mut := Mut - 0.004;
         Assert (Mut = 7.77);
         Assert (Mut = Mut2);
         Mut := Mut - 0.001;
         Assert (Mut = 7.76);
         Mut := Mut * 77.555321;
         Assert (Mut = 602.21);
         Assert (Mut.Full_Precision = 602.2093120329);
      end;
      --  Create ISO currency of every currence.
      for C of Every_ISO loop
      declare
         CD : constant Currency_Data := (Type_ISO_Currency, C);
         Major_List : Money_List.Vector;
         Minor_List : Money_List.Vector;
         
         Ref : constant Money := From_Major (Item_Dec, C);
      begin
         --  Quick tests
         declare
            C_0 : constant Money := From_Major (0.0, C);
            C_1 : constant Money := From_Major (Decimal_Major'Last, C);
            C_2 : constant Money := From_Minor (1234567890, C);
            C_3 : constant Money := From_Major (1234567890, C.Code);
            C_4 : constant Money := From_Minor ("1234567890", C.Code);
            C_5 : constant Money := From_Major (1234567890, CD);
            C_6 : constant Money := From_Minor ("1234567890", CD);
         begin
            Assert (C_0.Is_Zero);
         end;

         --  From_Major - decimal
         Major_List.Append (From_Major (Item_Dec, C));
         Major_List.Append (From_Major (Item_Dec, CD));
         Major_List.Append (From_Major (Item_Dec, C.Code));
         --  From_Major - Decimal_Minor
         Major_List.Append (From_Major (Item_Int, C));
         Major_List.Append (From_Major (Item_Int, CD));
         Major_List.Append (From_Major (Item_Int, C.Code));
         --  From_Major - string
         Major_List.Append (From_Major (Item_Str, C));
         Major_List.Append (From_Major (Item_Str, CD));
         Major_List.Append (From_Major (Item_Str, C.Code));
         --  From_Minor - Decimal_Minor
         Minor_List.Append (From_Minor (Item_Big, C));
         Minor_List.Append (From_Minor (Item_Big, CD));
         Minor_List.Append (From_Minor (Item_Big, C.Code));
         --  From_Minor - string
         Minor_List.Append (From_Minor (Item_IStr, C));
         Minor_List.Append (From_Minor (Item_IStr, CD));
         Minor_List.Append (From_Minor (Item_IStr, C.Code));

         Assert (for all M of Major_List => M.Is_Positive);
         Assert (for all M of Major_List => not M.Is_Negative);
         Assert (for all M of Major_List => not M.Is_Custom_Currency);
         Assert (for all M of Major_List => not M.Is_Zero);
         Assert (for all M of Major_List => M.Same_Currency (Ref));
         Assert (for all M of Major_List =>
                  M.Currency_Name = To_Wide_Wide_String (C.Name));
         Assert (for all M of Major_List =>
                  M.Currency_Code = To_Wide_Wide_String (C.Code));
         Assert (for all M of Major_List => M.Currency_Symbol = C.Symbol);
         Assert (for all M of Major_List => M.Currency_Unit = C.Unit);

         Assert (for all M of Minor_List => M.Is_Positive);
         Assert (for all M of Minor_List => not M.Is_Negative);
         Assert (for all M of Minor_List => not M.Is_Custom_Currency);
         Assert (for all M of Minor_List => not M.Is_Zero);
         Assert (for all M of Minor_List => M.Same_Currency (Ref));
         Assert (for all M of Minor_List =>
                  M.Currency_Name = To_Wide_Wide_String (C.Name));
         Assert (for all M of Minor_List =>
                  M.Currency_Code = To_Wide_Wide_String (C.Code));
         Assert (for all M of Minor_List => M.Currency_Symbol = C.Symbol);
         Assert (for all M of Minor_List => M.Currency_Unit = C.Unit);

      end;
      end loop;
      --  Create custom currency and money of every precision.
      for I in 0 .. Cashe.Max_Precision loop
         declare
            --  Custom currency of this minor unit.
            C : constant Custom_Currency :=
               Create (I'Wide_Wide_Image, I,
                       "Currency " & I'Wide_Wide_Image, "$");
            CD : constant Currency_Data := (Type_Custom_Currency, C);
            Major_List : Money_List.Vector;
            Minor_List : Money_List.Vector;

            Ref : constant Money := From_Major (Item_Dec, C);
         begin
            --  Quick tests
            declare
               Last_Long : constant Decimal_Major := Decimal_Major'Last;
               C_0 : constant Money := From_Major (0.0, C);
               C_1 : constant Money := From_Major (Last_Long, C);
               C_2 : constant Money := From_Minor (1234567890, C);
               C_5 : constant Money := From_Major (Last_Long, CD);
               C_6 : constant Money := From_Minor ("1234567890", CD);
            begin
               Assert (C_0.Is_Zero);
            end;

            --  From_Major - decimal
            Major_List.Append (From_Major (Item_Dec, C));
            Major_List.Append (From_Major (Item_Dec, CD));
            --  From_Major - Decimal_Minor
            Major_List.Append (From_Major (Item_Int, C));
            Major_List.Append (From_Major (Item_Int, CD));
            --  From_Major - string
            Major_List.Append (From_Major (Item_Str, C));
            Major_List.Append (From_Major (Item_Str, CD));
            --  From_Minor - Decimal_Minor
            Minor_List.Append (From_Minor (Item_Big, C));
            Minor_List.Append (From_Minor (Item_Big, CD));
            --  From_Minor - string
            Minor_List.Append (From_Minor (Item_IStr, C));
            Minor_List.Append (From_Minor (Item_IStr, CD));

            Assert (for all M of Major_List => M.Is_Positive);
            Assert (for all M of Major_List => not M.Is_Negative);
            Assert (for all M of Major_List => M.Is_Custom_Currency);
            Assert (for all M of Major_List => not M.Is_Zero);
            Assert (for all M of Major_List => M.Same_Currency (Ref));
            Assert (for all M of Major_List => M.Currency_Name = C.Name);
            Assert (for all M of Major_List => M.Currency_Code = C.Code);
            Assert (for all M of Major_List => M.Currency_Symbol = C.Symbol);
            Assert (for all M of Major_List => M.Currency_Unit = C.Unit);

            Assert (for all M of Minor_List => M.Is_Positive);
            Assert (for all M of Minor_List => not M.Is_Negative);
            Assert (for all M of Minor_List => M.Is_Custom_Currency);
            Assert (for all M of Minor_List => not M.Is_Zero);
            Assert (for all M of Minor_List => M.Same_Currency (Ref));
            Assert (for all M of Minor_List => M.Currency_Name = C.Name);
            Assert (for all M of Minor_List => M.Currency_Code = C.Code);
            Assert (for all M of Minor_List => M.Currency_Symbol = C.Symbol);
            Assert (for all M of Minor_List => M.Currency_Unit = C.Unit);
         end;
      end loop;

   end Run_Tests;
end Cashe_Money_Tests;