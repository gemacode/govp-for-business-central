tableextension 71100 "GOVP Sales Shipment" extends "Sales Shipment Header"
{
    fields
    {
        field(71100; "GOVP Status"; Enum "GOVP Status") { Caption = 'GOVP status'; DataClassification = CustomerContent; }
        field(71101; "GOVP Code"; Text[100]) { Caption = 'GOVP code'; DataClassification = CustomerContent; }
        field(71102; "GOVP Verify URL"; Text[250]) { Caption = 'GOVP verification URL'; DataClassification = CustomerContent; ExtendedDatatype = URL; }
        field(71103; "GOVP Issued At"; DateTime) { Caption = 'GOVP issued at'; DataClassification = CustomerContent; }
        field(71104; "GOVP Last Error"; Text[250]) { Caption = 'GOVP last error'; DataClassification = CustomerContent; }
    }
}
