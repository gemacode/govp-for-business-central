page 71100 "GOVP Setup"
{
    PageType = Card;
    SourceTable = "GOVP Setup";
    Caption = 'GOVP Setup';
    UsageCategory = Administration;
    ApplicationArea = All;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(Exchange)
            {
                field(Enabled; Rec.Enabled) { ApplicationArea = All; }
                field("Exchange URL"; Rec."Exchange URL") { ApplicationArea = All; }
                field("Validity Days"; Rec."Validity Days") { ApplicationArea = All; }
                field("Requirement Text"; Rec."Requirement Text") { ApplicationArea = All; MultiLine = true; }
                field(ConnectorToken; ConnectorToken)
                {
                    ApplicationArea = All;
                    Caption = 'Connector token';
                    ExtendedDatatype = Masked;
                    ToolTip = 'Stored per company in Business Central isolated storage.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(SaveToken)
            {
                ApplicationArea = All;
                Caption = 'Save connector token';
                Image = Save;
                trigger OnAction()
                var
                    TokenStore: Codeunit "GOVP Token Store";
                begin
                    TokenStore.SetToken(ConnectorToken);
                    ConnectorToken := '';
                    Message('The connector token was stored for this company.');
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get('') then begin
            Rec.Init();
            Rec."Primary Key" := '';
            Rec."Exchange URL" := 'https://partners.gemacode.org/api/exchange';
            Rec.Insert();
        end;
    end;

    var ConnectorToken: Text[250];
}
