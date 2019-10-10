page 50132 "AB_RecordCreator Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "AB_RecordCreator Setup";
    Caption = 'Record Creator Setup';


    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("API URL"; "API URL")
                {
                    ApplicationArea = All;
                }
                field(Username; Username)
                {
                    ApplicationArea = All;
                }
                field("Web Access Key"; "Web Access Key")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(TestConnection)
            {
                ApplicationArea = All;
                Image = Interaction;
                Caption = 'Test Connection';

                trigger OnAction()
                var
                    RecordCreatorMgt: Codeunit "AB_Record Creation Management";
                begin
                    RecordCreatorMgt.TestConnection();
                end;
            }
        }
    }
}