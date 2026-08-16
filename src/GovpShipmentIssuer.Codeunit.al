codeunit 71102 "GOVP Shipment Issuer"
{
    Permissions = tabledata "Sales Shipment Header" = rm;

    procedure Issue(var Shipment: Record "Sales Shipment Header")
    var
        Setup: Record "GOVP Setup";
        Company: Record Company;
        Client: Codeunit "GOVP Exchange Client";
        Payload: JsonObject;
        Govp: JsonObject;
        GovpToken: JsonToken;
        ErrorText: Text;
    begin
        if not Setup.Get('') then
            Error('GOVP has not been configured for this company.');
        if not Setup.Enabled then
            Error('GOVP is disabled for this company.');
        if Shipment."GOVP Code" <> '' then begin
            Message('GOVP %1 is already linked to this shipment.', Shipment."GOVP Code");
            exit;
        end;

        Company.Get(CompanyName());
        BuildPayload(Shipment, Setup, Company."Display Name", Payload);
        Shipment."GOVP Status" := Shipment."GOVP Status"::Issuing;
        Shipment."GOVP Last Error" := '';
        Shipment.Modify(true);

        if not Client.Issue(Setup, Payload, StrSubstNo('business_central:shipment:%1', NormalizedSystemId(Shipment.SystemId)), Govp, ErrorText) then begin
            Shipment."GOVP Status" := Shipment."GOVP Status"::Error;
            Shipment."GOVP Last Error" := CopyStr(ErrorText, 1, MaxStrLen(Shipment."GOVP Last Error"));
            Shipment.Modify(true);
            Error('%1', ErrorText);
        end;

        if Govp.Get('code', GovpToken) then
            Shipment."GOVP Code" := CopyStr(GovpToken.AsValue().AsText(), 1, MaxStrLen(Shipment."GOVP Code"));
        if Govp.Get('verifyUrl', GovpToken) then
            Shipment."GOVP Verify URL" := CopyStr(GovpToken.AsValue().AsText(), 1, MaxStrLen(Shipment."GOVP Verify URL"));
        Shipment."GOVP Issued At" := CurrentDateTime();
        Shipment."GOVP Status" := Shipment."GOVP Status"::Active;
        Shipment.Modify(true);
    end;

    local procedure BuildPayload(Shipment: Record "Sales Shipment Header"; Setup: Record "GOVP Setup"; IssuerName: Text; var Payload: JsonObject)
    var
        CryptographyManagement: Codeunit "Cryptography Management";
        HashAlgorithmType: Option MD5,SHA1,SHA256,SHA384,SHA512;
        Issuer: JsonObject;
        Subject: JsonObject;
        Source: JsonObject;
        Evidence: JsonObject;
        EvidenceList: JsonArray;
    begin
        Issuer.Add('name', IssuerName);
        Subject.Add('type', 'shipment');
        Subject.Add('id', Shipment."No.");
        Subject.Add('name', StrSubstNo('Posted sales shipment %1', Shipment."No."));
        Evidence.Add('label', StrSubstNo('Business Central posted shipment %1', Shipment."No."));
        Evidence.Add('sha256', LowerCase(CryptographyManagement.GenerateHash(
            StrSubstNo('%1|%2|%3|%4|%5', Shipment."No.", Shipment."Posting Date", Shipment."Sell-to Customer No.", Shipment."Ship-to Code", NormalizedSystemId(Shipment.SystemId)),
            HashAlgorithmType::SHA256)));
        EvidenceList.Add(Evidence);
        Source.Add('platform', 'business_central');
        Source.Add('externalId', NormalizedSystemId(Shipment.SystemId));
        Payload.Add('issuer', Issuer);
        Payload.Add('subject', Subject);
        Payload.Add('requirement', Setup."Requirement Text");
        Payload.Add('evidence', EvidenceList);
        Payload.Add('validUntil', Format(CreateDateTime(CalcDate(StrSubstNo('<+%1D>', Setup."Validity Days"), Today()), 235959T), 0, 9));
        Payload.Add('source', Source);
    end;

    local procedure NormalizedSystemId(Value: Guid): Text
    begin
        exit(LowerCase(DelChr(Format(Value), '=', '{}')));
    end;
}
