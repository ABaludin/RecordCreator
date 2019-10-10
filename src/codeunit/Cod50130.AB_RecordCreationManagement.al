codeunit 50130 "AB_Record Creation Management"
{
    local procedure GetSetup()
    begin
        Setup.Get();
        Setup.TestField("API URL");
        Setup.TestField(Username);
        Setup.TestField("Web Access Key");
    end;

    local procedure AuthorizationToken(): Text
    var
        Base64Convert: Codeunit "Base64 Convert";
    begin
        exit(Base64Convert.ToBase64(Setup.Username + ':' + Setup."Web Access Key"));
    end;

    procedure TestConnection()
    var
        Client: HttpClient;
        ResponseMessage: HttpResponseMessage;
        ResponseText: Text;
    begin
        GetSetup();

        Client.DefaultRequestHeaders().Add('Authorization', 'Basic ' + AuthorizationToken());
        Client.DefaultRequestHeaders().Add('Accept', 'application/json');
        if not Client.Get(Setup."API URL", ResponseMessage) then
            Error(Text001_Err);
        ResponseMessage.Content().ReadAs(ResponseText);

        if not ResponseMessage.IsSuccessStatusCode() then
            error(Text002_Err, ResponseMessage.HttpStatusCode(), ResponseText);

        Message(Text003_Msg);
    end;

    procedure CreateRecord(CompanyID: Guid; RecordType: Enum AB_RecordTypes; Description: Text)
    begin
        GetSetup();
        case RecordType of
            recordType::Item:
                CreateItem(CompanyID, Description);
            RecordType::Customer:
                CreateCustomer(CompanyID, Description);
        end;
    end;

    local procedure CreateItem(CompanyID: Text; Description: Text)
    var
        Client: HttpClient;
        Content: HttpContent;
        Headers: HttpHeaders;
        ResponseMessage: HttpResponseMessage;
        ResponseText: Text;
        URL: Text;
        ResponseObject: JsonObject;
        ResponseToken: JsonToken;
    begin
        Client.DefaultRequestHeaders().Add('Authorization', 'Basic ' + AuthorizationToken());
        Client.DefaultRequestHeaders().Add('Accept', 'application/json');

        CompanyID := DelChr(CompanyID, '=', '{}');
        URL := Setup."API URL" + '(' + CompanyID + ')/items';

        Content.WriteFrom(CreateItemObject(Description));
        Content.GetHeaders(Headers);
        Headers.Remove('Content-Type');
        Headers.Add('Content-Type', 'application/json');

        if not Client.Post(URL, Content, ResponseMessage) then
            Error(Text001_Err);
        ResponseMessage.Content().ReadAs(ResponseText);

        if not ResponseMessage.IsSuccessStatusCode() then
            error(Text002_Err, ResponseMessage.HttpStatusCode(), ResponseText);

        ResponseObject.ReadFrom(ResponseText);
        ResponseObject.Get('number', ResponseToken);
        Message(Text004_Msg, ResponseToken.AsValue().AsText(), Description);
    end;

    local procedure CreateItemObject(Description: Text) ItemRequest: Text
    var
        ItemObject: JsonObject;
        UoMObject: JsonObject;
    begin
        ItemRequest := '';
        ItemObject.Add('displayName', Description);

        UoMObject.Add('code', 'PCS');
        UoMObject.Add('displayName', 'Piece');

        ItemObject.Add('baseUnitOfMeasure', UoMObject);
        ItemObject.WriteTo(ItemRequest);
    end;

    local procedure CreateCustomer(CompanyID: Text; Description: Text)
    var
        Client: HttpClient;
        Content: HttpContent;
        Headers: HttpHeaders;
        ResponseMessage: HttpResponseMessage;
        ResponseText: Text;
        URL: Text;
        ResponseObject: JsonObject;
        ResponseToken: JsonToken;
    begin
        Client.DefaultRequestHeaders().Add('Authorization', 'Basic ' + AuthorizationToken());
        Client.DefaultRequestHeaders().Add('Accept', 'application/json');

        CompanyID := DelChr(CompanyID, '=', '{}');
        URL := Setup."API URL" + '(' + CompanyID + ')/customers';

        Content.WriteFrom(CreateCustomerObject(Description));
        Content.GetHeaders(Headers);
        Headers.Remove('Content-Type');
        Headers.Add('Content-Type', 'application/json');

        if not Client.Post(URL, Content, ResponseMessage) then
            Error(Text001_Err);
        ResponseMessage.Content().ReadAs(ResponseText);

        if not ResponseMessage.IsSuccessStatusCode() then
            error(Text002_Err, ResponseMessage.HttpStatusCode(), ResponseText);

        ResponseObject.ReadFrom(ResponseText);
        ResponseObject.Get('number', ResponseToken);
        Message(Text005_Msg, ResponseToken.AsValue().AsText(), Description);
    end;

    local procedure CreateCustomerObject(Description: Text) ItemRequest: Text
    var
        CustomerObject: JsonObject;
        AddressObject: JsonObject;
    begin
        ItemRequest := '';
        CustomerObject.Add('displayName', Description);
        CustomerObject.Add('type', 'Company');

        AddressObject.Add('street', 'Bruno-Kreisky-Platz');
        AddressObject.Add('city', 'Vienna');
        AddressObject.Add('countryLetterCode', 'AT');

        CustomerObject.Add('address', AddressObject);
        CustomerObject.WriteTo(ItemRequest);
    end;

    var
        Setup: Record "AB_RecordCreator Setup";
        Text001_Err: Label 'Service inaccessible';
        Text002_Err: Label 'The web service returned an error message:\ Status code: %1\ Description: %2';
        Text003_Msg: Label 'Connection OK!';
        Text004_Msg: label 'Item created: %1 %2';
        Text005_Msg: label 'Customer created: %1 %2';
}