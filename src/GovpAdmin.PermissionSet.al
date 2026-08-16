permissionset 71100 "GOVP Admin"
{
    Assignable = true;
    Caption = 'GOVP administrator';

    Permissions =
        tabledata "GOVP Setup" = RIMD,
        table "GOVP Setup" = X,
        page "GOVP Setup" = X,
        codeunit "GOVP Token Store" = X,
        codeunit "GOVP Exchange Client" = X,
        codeunit "GOVP Shipment Issuer" = X;
}
