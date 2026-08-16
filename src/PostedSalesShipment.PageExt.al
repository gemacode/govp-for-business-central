pageextension 71100 "GOVP Posted Shipment" extends "Posted Sales Shipment"
{
    layout
    {
        addlast(General)
        {
            field("GOVP Status"; Rec."GOVP Status") { ApplicationArea = All; Editable = false; }
            field("GOVP Code"; Rec."GOVP Code") { ApplicationArea = All; Editable = false; }
            field("GOVP Verify URL"; Rec."GOVP Verify URL") { ApplicationArea = All; Editable = false; }
            field("GOVP Last Error"; Rec."GOVP Last Error") { ApplicationArea = All; Editable = false; }
        }
    }

    actions
    {
        addlast(Processing)
        {
            action(IssueGOVP)
            {
                ApplicationArea = All;
                Caption = 'Issue GOVP';
                Image = Certificate;
                trigger OnAction()
                var
                    Issuer: Codeunit "GOVP Shipment Issuer";
                begin
                    Issuer.Issue(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(OpenGOVP)
            {
                ApplicationArea = All;
                Caption = 'Verify GOVP';
                Image = View;
                Enabled = Rec."GOVP Verify URL" <> '';
                trigger OnAction()
                begin
                    Hyperlink(Rec."GOVP Verify URL");
                end;
            }
        }
    }
}
