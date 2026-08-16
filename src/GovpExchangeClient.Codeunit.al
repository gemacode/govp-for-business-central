codeunit 71101 "GOVP Exchange Client"
{
    Access = Internal;

    procedure Issue(Setup: Record "GOVP Setup"; Payload: JsonObject; IdempotencyKey: Text; var Govp: JsonObject; var ErrorText: Text): Boolean
    var
        TokenStore: Codeunit "GOVP Token Store";
        Client: HttpClient;
        Content: HttpContent;
        ContentHeaders: HttpHeaders;
        RequestHeaders: HttpHeaders;
        Response: HttpResponseMessage;
        Token: Text;
        RequestBody: Text;
        ResponseBody: Text;
        ResponseJson: JsonObject;
        GovpToken: JsonToken;
    begin
        if not Setup."Exchange URL".StartsWith('https://') then begin
            ErrorText := 'GOVP Exchange URL must use HTTPS.';
            exit(false);
        end;
        if not TokenStore.GetToken(Token) then begin
            ErrorText := 'The GOVP connector token has not been configured.';
            exit(false);
        end;

        Payload.WriteTo(RequestBody);
        Content.WriteFrom(RequestBody);
        Content.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json');
        RequestHeaders := Client.DefaultRequestHeaders();
        RequestHeaders.Add('Accept', 'application/json');
        RequestHeaders.Add('Authorization', StrSubstNo('Bearer %1', Token));
        RequestHeaders.Add('Idempotency-Key', IdempotencyKey);

        if not Client.Post(Setup."Exchange URL" + '/connectors/issue', Content, Response) then begin
            ErrorText := 'GOVP Exchange could not be reached.';
            exit(false);
        end;
        Response.Content().ReadAs(ResponseBody);
        if not Response.IsSuccessStatusCode() then begin
            ErrorText := CopyStr(StrSubstNo('GOVP Exchange returned HTTP %1: %2', Response.HttpStatusCode(), ResponseBody), 1, 250);
            exit(false);
        end;
        if not ResponseJson.ReadFrom(ResponseBody) then begin
            ErrorText := 'GOVP Exchange returned invalid JSON.';
            exit(false);
        end;
        if not ResponseJson.Get('govp', GovpToken) then begin
            ErrorText := 'GOVP Exchange response did not include a GOVP.';
            exit(false);
        end;
        Govp := GovpToken.AsObject();
        exit(true);
    end;
}
