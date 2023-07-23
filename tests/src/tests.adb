with Cashe_Currency_Tests;
with Cashe_Money_Tests;
with Cashe_Exchange_Tests;
procedure Tests is
begin
   Cashe_Currency_Tests.Run_Tests;
   Cashe_Money_Tests.Run_Tests;
   Cashe_Exchange_Tests.Run_Tests;
end Tests;