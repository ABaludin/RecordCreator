page 50030 "AB_DataCreator"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Data Creator';

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("Company Name"; CompanyName)
                {
                    ApplicationArea = All;
                    TableRelation = Company.Name;
                }
                field("Record Type"; RecordType)
                {
                    ApplicationArea = All;

                }
                field("Record Description"; RecordDescription)
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
            action(CreateRecord)
            {
                ApplicationArea = All;
                Caption = 'CreateRecord';
                Image = Create;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Company: Record Company;
                    CreationMgt: Codeunit "AB_Record Creation Management";
                begin
                    Company.Get(CompanyName);
                    CreationMgt.CreateRecord(Company.Id, RecordType, RecordDescription);
                end;
            }
        }
    }

    var
        RecordType: Enum AB_RecordTypes;
        RecordDescription: Text;
        CompanyName: Text;
}