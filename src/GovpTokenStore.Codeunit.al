codeunit 71100 "GOVP Token Store"
{
    Access = Internal;

    procedure SetToken(Token: Text)
    begin
        IsolatedStorage.Set(TokenKeyLbl, Token, DataScope::Company);
    end;

    procedure GetToken(var Token: Text): Boolean
    begin
        exit(IsolatedStorage.Get(TokenKeyLbl, DataScope::Company, Token));
    end;

    procedure DeleteToken()
    begin
        if IsolatedStorage.Contains(TokenKeyLbl, DataScope::Company) then
            IsolatedStorage.Delete(TokenKeyLbl, DataScope::Company);
    end;

    var
        TokenKeyLbl: Label 'govp.exchange.connector-token', Locked = true;
}
