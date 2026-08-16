table 71100 "GOVP Setup"
{
    Caption = 'GOVP Setup';
    DataClassification = OrganizationIdentifiableInformation;

    fields
    {
        field(1; "Primary Key"; Code[10]) { Caption = 'Primary Key'; }
        field(10; Enabled; Boolean) { Caption = 'Enabled'; }
        field(20; "Exchange URL"; Text[250]) { Caption = 'Exchange URL'; }
        field(30; "Validity Days"; Integer)
        {
            Caption = 'Validity days';
            InitValue = 365;
            MinValue = 1;
        }
        field(40; "Requirement Text"; Text[250])
        {
            Caption = 'Requirement';
            InitValue = 'Evidence for the posted sales shipment';
        }
    }

    keys { key(PK; "Primary Key") { Clustered = true; } }
}
