package body Cashe.Currency_Handling is
   procedure Set_Code (This : in out Custom_Currency; Item : Wide_Wide_String)
   is
      use Ada.Strings.Wide_Wide_Unbounded;
   begin
      This.Custom_Code := To_Unbounded_Wide_Wide_String (Item);
   end Set_Code;
   procedure Set_Name (This : in out Custom_Currency; Item : Wide_Wide_String)
   is
      use Ada.Strings.Wide_Wide_Unbounded;
   begin
      This.Custom_Name := To_Unbounded_Wide_Wide_String (Item);
   end Set_Name;
   procedure Set_Symbol
      (This : in out Custom_Currency; Item : Wide_Wide_String)
   is
      use Ada.Strings.Wide_Wide_Unbounded;
   begin
      This.Custom_Symbol := To_Unbounded_Wide_Wide_String (Item);
   end Set_Symbol;
   procedure Set_Unit (This : in out Custom_Currency; Item : Natural) is
   begin
      This.Custom_Minor_Unit := Item;
   end Set_Unit;
   function Code (This : Custom_Currency) return Wide_Wide_String is
      use Ada.Strings.Wide_Wide_Unbounded;
   begin
      return To_Wide_Wide_String (This.Custom_Code);
   end Code;
   function Name (This : Custom_Currency) return Wide_Wide_String is
      use Ada.Strings.Wide_Wide_Unbounded;
   begin
      return To_Wide_Wide_String (This.Custom_Name);
   end Name;
   function Symbol (This : Custom_Currency) return Wide_Wide_String is
      use Ada.Strings.Wide_Wide_Unbounded;
   begin
      return To_Wide_Wide_String (This.Custom_Symbol);
   end Symbol;
   function Unit (This : Custom_Currency) return Natural is
      (This.Custom_Minor_Unit);

   function Create
      (Code        : Wide_Wide_String;
       Minor_Unit : Natural := 0;
       Name        : Wide_Wide_String := "";
       Symbol      : Wide_Wide_String := "")
   return Custom_Currency is
      use Ada.Strings.Wide_Wide_Unbounded;
   begin
      return (Custom_Code       => To_Unbounded_Wide_Wide_String (Code),
              Custom_Symbol     => To_Unbounded_Wide_Wide_String (Symbol),
              Custom_Name       => To_Unbounded_Wide_Wide_String (Name),
              Custom_Minor_Unit => Minor_Unit);
   end Create;

end Cashe.Currency_Handling;