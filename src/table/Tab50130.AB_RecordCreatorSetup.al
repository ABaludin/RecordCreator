table 50130 "AB_RecordCreator Setup"
{
    DataClassification = CustomerContent;
    Caption = 'Record Creator Setup';

    fields
    {
        field(1; "Entry No."; Code[10])
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(2; "API URL"; Text[250])
        {
            Caption = 'API URL';
            DataClassification = CustomerContent;
        }
        field(3; "Username"; Text[100])
        {
            Caption = 'Username';
            DataClassification = CustomerContent;
        }
        field(4; "Web Access Key"; Text[100])
        {
            Caption = 'Web Access Key';
            DataClassification = CustomerContent;
            ExtendedDatatype = Masked;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

}