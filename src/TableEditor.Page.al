page 55999 "Table Editor"
{
    Caption = 'Table Editor';
    PageType = Worksheet;
    SourceTable = "Table Editor";
    SourceTableTemporary = true;
    DelayedInsert = true;
    ShowFilter = false;
    LinksAllowed = false;
    UsageCategory = Tasks;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(Options)
            {
                Caption = 'Options';
                Visible = OptionsVisible;
                field(TableNo; TableNo)
                {
                    Caption = 'Table No.';
                    TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Table));

                    trigger OnValidate()
                    var
                        TableMetadata: Record "Table Metadata";
                    begin
                        Rec.Reset();
                        Rec.DeleteAll();
                        RecordRef.Close();
                        Offset := 0;
                        Filters := '';
                        NoOfRecords := 0;
                        Sorting := '';
                        SetIsTempRec(false);
                        if TableNo <> 0 then begin
                            RecordRef.Open(TableNo);
                            NoOfRecords := RecordRef.Count;
                            Sorting := RecordRef.GetView();
                            LoadColumns();
                            if TableMetadata.Get(TableNo) and (TableMetadata.TableType = TableMetadata.TableType::Temporary) then
                                SetIsTempRec(true);
                        end;
                    end;
                }
                field(Filters; Filters)
                {
                    Caption = 'Filters';
                    Editable = false;
                    MultiLine = true;

                    trigger OnDrillDown()
                    begin
                        if TableNo <> 0 then begin
                            SetFiltersOnRecordRef();
                            Filters := RecordRef.GetFilters().Replace(', ', '\');
                            NoOfRecords := RecordRef.Count;
                            CurrPage.Update();
                        end;
                    end;
                }
                field(Sorting; Sorting)
                {
                    Caption = 'Sorting';
                    Editable = false;
                    MultiLine = true;

                    trigger OnDrillDown()
                    var
                        Field: Record Field;
                        SortingOrder: Page "Sorting Order";
                    begin
                        if TableNo <> 0 then begin
                            SetFieldsFilter(Field);
                            SortingOrder.LookupMode(true);
                            SortingOrder.SetTableView(Field);
                            if SortingOrder.RunModal() = Action::LookupOK then begin
                                RecordRef.SetView(SortingOrder.GetSortingText());
                                Sorting := RecordRef.GetView();
                                Filters := ''; // Filter gehen bei neuer Sortierung verloren
                                NoOfRecords := RecordRef.Count;
                                CurrPage.Update();
                            end;
                        end;
                    end;
                }
                field("No. of Records"; NoOfRecords)
                {
                    Caption = 'No. of Records';
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        if TableNo <> 0 then
                            Hyperlink(GetUrl(ClientType::Web, CompanyName, ObjectType::Table, TableNo));
                    end;
                }
                field(ShowCaptions; ShowCaptions)
                {
                    Caption = 'Show Captions';

                    trigger OnValidate()
                    begin
                        LoadColumns();
                    end;
                }
                group(MoreOptions)
                {
                    ShowCaption = false;
                    Visible = MoreOptionsVisible;
                    field(InsertTrigger; RunInsertTrigger)
                    {
                        Caption = 'Insert Trigger';
                    }
                    field(ModifyTrigger; RunModifyTrigger)
                    {
                        Caption = 'Modify Trigger';
                    }
                    field(DeleteTrigger; RunDeleteTrigger)
                    {
                        Caption = 'Delete Trigger';
                    }
                    field(ValidateTrigger; RunValidateTrigger)
                    {
                        Caption = 'Validate Trigger';
                    }
                }
                field(CurrentField; ColumnCaptions[LastModifiedColumnID])
                {
                    Caption = 'Current Field';
                    Editable = false;
                }
                field(CurrentValue; CurrentValue)
                {
                    Caption = 'Current Value';
                    Editable = false;
                }
                field(CurrentRecID; Format(RecordRef.RecordId))
                {
                    Caption = 'Current Record-ID';
                    Editable = false;
                }
                field(IsTemporary; IsTemporaryText)
                {
                    Caption = 'Is Temporary';
                    ShowCaption = false;
                    Editable = false;
                }
            }
            repeater(General)
            {
                field(CodeField1; CodeFields[1])
                {
                    CaptionClass = '3,' + ColumnCaptions[1];
                    Visible = Code1Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(1);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(1);
                    end;
                }
                field(TextField1; TextFields[1])
                {
                    CaptionClass = '3,' + ColumnCaptions[1];
                    Visible = Text1Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(1);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(1);
                    end;
                }
                field(IntegerField1; IntegerFields[1])
                {
                    CaptionClass = '3,' + ColumnCaptions[1];
                    Visible = Integer1Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(1);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(1);
                    end;
                }
                field(DecimalField1; DecimalFields[1])
                {
                    CaptionClass = '3,' + ColumnCaptions[1];
                    Visible = Decimal1Visible;
                    DecimalPlaces = 0 : 25;

                    trigger OnValidate()
                    begin
                        ValidateField(1);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(1);
                    end;
                }
                field(BooleanField1; BooleanFields[1])
                {
                    CaptionClass = '3,' + ColumnCaptions[1];
                    Visible = Boolean1Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(1);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(1);
                    end;
                }
                field(DateField1; DateFields[1])
                {
                    CaptionClass = '3,' + ColumnCaptions[1];
                    Visible = Date1Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(1);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(1);
                    end;
                }
                field(DateTimeField1; DateTimeFields[1])
                {
                    CaptionClass = '3,' + ColumnCaptions[1];
                    Visible = DateTime1Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(1);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(1);
                    end;
                }
                field(TimeField1; TimeFields[1])
                {
                    CaptionClass = '3,' + ColumnCaptions[1];
                    Visible = Time1Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(1);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(1);
                    end;
                }
                field(CodeField2; CodeFields[2])
                {
                    CaptionClass = '3,' + ColumnCaptions[2];
                    Visible = Code2Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(2);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(2);
                    end;
                }
                field(TextField2; TextFields[2])
                {
                    CaptionClass = '3,' + ColumnCaptions[2];
                    Visible = Text2Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(2);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(2);
                    end;
                }
                field(IntegerField2; IntegerFields[2])
                {
                    CaptionClass = '3,' + ColumnCaptions[2];
                    Visible = Integer2Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(2);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(2);
                    end;
                }
                field(DecimalField2; DecimalFields[2])
                {
                    CaptionClass = '3,' + ColumnCaptions[2];
                    Visible = Decimal2Visible;
                    DecimalPlaces = 0 : 25;

                    trigger OnValidate()
                    begin
                        ValidateField(2);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(2);
                    end;
                }
                field(BooleanField2; BooleanFields[2])
                {
                    CaptionClass = '3,' + ColumnCaptions[2];
                    Visible = Boolean2Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(2);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(2);
                    end;
                }
                field(DateField2; DateFields[2])
                {
                    CaptionClass = '3,' + ColumnCaptions[2];
                    Visible = Date2Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(2);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(2);
                    end;
                }
                field(DateTimeField2; DateTimeFields[2])
                {
                    CaptionClass = '3,' + ColumnCaptions[2];
                    Visible = DateTime2Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(2);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(2);
                    end;
                }
                field(TimeField2; TimeFields[2])
                {
                    CaptionClass = '3,' + ColumnCaptions[2];
                    Visible = Time2Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(2);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(2);
                    end;
                }
                field(CodeField3; CodeFields[3])
                {
                    CaptionClass = '3,' + ColumnCaptions[3];
                    Visible = Code3Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(3);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(3);
                    end;
                }
                field(TextField3; TextFields[3])
                {
                    CaptionClass = '3,' + ColumnCaptions[3];
                    Visible = Text3Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(3);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(3);
                    end;
                }
                field(IntegerField3; IntegerFields[3])
                {
                    CaptionClass = '3,' + ColumnCaptions[3];
                    Visible = Integer3Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(3);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(3);
                    end;
                }
                field(DecimalField3; DecimalFields[3])
                {
                    CaptionClass = '3,' + ColumnCaptions[3];
                    Visible = Decimal3Visible;
                    DecimalPlaces = 0 : 25;

                    trigger OnValidate()
                    begin
                        ValidateField(3);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(3);
                    end;
                }
                field(BooleanField3; BooleanFields[3])
                {
                    CaptionClass = '3,' + ColumnCaptions[3];
                    Visible = Boolean3Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(3);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(3);
                    end;
                }
                field(DateField3; DateFields[3])
                {
                    CaptionClass = '3,' + ColumnCaptions[3];
                    Visible = Date3Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(3);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(3);
                    end;
                }
                field(DateTimeField3; DateTimeFields[3])
                {
                    CaptionClass = '3,' + ColumnCaptions[3];
                    Visible = DateTime3Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(3);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(3);
                    end;
                }
                field(TimeField3; TimeFields[3])
                {
                    CaptionClass = '3,' + ColumnCaptions[3];
                    Visible = Time3Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(3);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(3);
                    end;
                }
                field(CodeField4; CodeFields[4])
                {
                    CaptionClass = '3,' + ColumnCaptions[4];
                    Visible = Code4Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(4);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(4);
                    end;
                }
                field(TextField4; TextFields[4])
                {
                    CaptionClass = '3,' + ColumnCaptions[4];
                    Visible = Text4Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(4);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(4);
                    end;
                }
                field(IntegerField4; IntegerFields[4])
                {
                    CaptionClass = '3,' + ColumnCaptions[4];
                    Visible = Integer4Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(4);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(4);
                    end;
                }
                field(DecimalField4; DecimalFields[4])
                {
                    CaptionClass = '3,' + ColumnCaptions[4];
                    Visible = Decimal4Visible;
                    DecimalPlaces = 0 : 25;

                    trigger OnValidate()
                    begin
                        ValidateField(4);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(4);
                    end;
                }
                field(BooleanField4; BooleanFields[4])
                {
                    CaptionClass = '3,' + ColumnCaptions[4];
                    Visible = Boolean4Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(4);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(4);
                    end;
                }
                field(DateField4; DateFields[4])
                {
                    CaptionClass = '3,' + ColumnCaptions[4];
                    Visible = Date4Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(4);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(4);
                    end;
                }
                field(DateTimeField4; DateTimeFields[4])
                {
                    CaptionClass = '3,' + ColumnCaptions[4];
                    Visible = DateTime4Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(4);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(4);
                    end;
                }
                field(TimeField4; TimeFields[4])
                {
                    CaptionClass = '3,' + ColumnCaptions[4];
                    Visible = Time4Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(4);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(4);
                    end;
                }
                field(CodeField5; CodeFields[5])
                {
                    CaptionClass = '3,' + ColumnCaptions[5];
                    Visible = Code5Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(5);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(5);
                    end;
                }
                field(TextField5; TextFields[5])
                {
                    CaptionClass = '3,' + ColumnCaptions[5];
                    Visible = Text5Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(5);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(5);
                    end;
                }
                field(IntegerField5; IntegerFields[5])
                {
                    CaptionClass = '3,' + ColumnCaptions[5];
                    Visible = Integer5Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(5);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(5);
                    end;
                }
                field(DecimalField5; DecimalFields[5])
                {
                    CaptionClass = '3,' + ColumnCaptions[5];
                    Visible = Decimal5Visible;
                    DecimalPlaces = 0 : 25;

                    trigger OnValidate()
                    begin
                        ValidateField(5);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(5);
                    end;
                }
                field(BooleanField5; BooleanFields[5])
                {
                    CaptionClass = '3,' + ColumnCaptions[5];
                    Visible = Boolean5Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(5);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(5);
                    end;
                }
                field(DateField5; DateFields[5])
                {
                    CaptionClass = '3,' + ColumnCaptions[5];
                    Visible = Date5Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(5);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(5);
                    end;
                }
                field(DateTimeField5; DateTimeFields[5])
                {
                    CaptionClass = '3,' + ColumnCaptions[5];
                    Visible = DateTime5Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(5);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(5);
                    end;
                }
                field(TimeField5; TimeFields[5])
                {
                    CaptionClass = '3,' + ColumnCaptions[5];
                    Visible = Time5Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(5);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(5);
                    end;
                }
                field(CodeField6; CodeFields[6])
                {
                    CaptionClass = '3,' + ColumnCaptions[6];
                    Visible = Code6Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(6);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(6);
                    end;
                }
                field(TextField6; TextFields[6])
                {
                    CaptionClass = '3,' + ColumnCaptions[6];
                    Visible = Text6Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(6);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(6);
                    end;
                }
                field(IntegerField6; IntegerFields[6])
                {
                    CaptionClass = '3,' + ColumnCaptions[6];
                    Visible = Integer6Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(6);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(6);
                    end;
                }
                field(DecimalField6; DecimalFields[6])
                {
                    CaptionClass = '3,' + ColumnCaptions[6];
                    Visible = Decimal6Visible;
                    DecimalPlaces = 0 : 25;

                    trigger OnValidate()
                    begin
                        ValidateField(6);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(6);
                    end;
                }
                field(BooleanField6; BooleanFields[6])
                {
                    CaptionClass = '3,' + ColumnCaptions[6];
                    Visible = Boolean6Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(6);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(6);
                    end;
                }
                field(DateField6; DateFields[6])
                {
                    CaptionClass = '3,' + ColumnCaptions[6];
                    Visible = Date6Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(6);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(6);
                    end;
                }
                field(DateTimeField6; DateTimeFields[6])
                {
                    CaptionClass = '3,' + ColumnCaptions[6];
                    Visible = DateTime6Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(6);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(6);
                    end;
                }
                field(TimeField6; TimeFields[6])
                {
                    CaptionClass = '3,' + ColumnCaptions[6];
                    Visible = Time6Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(6);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(6);
                    end;
                }
                field(CodeField7; CodeFields[7])
                {
                    CaptionClass = '3,' + ColumnCaptions[7];
                    Visible = Code7Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(7);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(7);
                    end;
                }
                field(TextField7; TextFields[7])
                {
                    CaptionClass = '3,' + ColumnCaptions[7];
                    Visible = Text7Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(7);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(7);
                    end;
                }
                field(IntegerField7; IntegerFields[7])
                {
                    CaptionClass = '3,' + ColumnCaptions[7];
                    Visible = Integer7Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(7);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(7);
                    end;
                }
                field(DecimalField7; DecimalFields[7])
                {
                    CaptionClass = '3,' + ColumnCaptions[7];
                    Visible = Decimal7Visible;
                    DecimalPlaces = 0 : 25;

                    trigger OnValidate()
                    begin
                        ValidateField(7);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(7);
                    end;
                }
                field(BooleanField7; BooleanFields[7])
                {
                    CaptionClass = '3,' + ColumnCaptions[7];
                    Visible = Boolean7Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(7);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(7);
                    end;
                }
                field(DateField7; DateFields[7])
                {
                    CaptionClass = '3,' + ColumnCaptions[7];
                    Visible = Date7Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(7);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(7);
                    end;
                }
                field(DateTimeField7; DateTimeFields[7])
                {
                    CaptionClass = '3,' + ColumnCaptions[7];
                    Visible = DateTime7Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(7);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(7);
                    end;
                }
                field(TimeField7; TimeFields[7])
                {
                    CaptionClass = '3,' + ColumnCaptions[7];
                    Visible = Time7Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(7);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(7);
                    end;
                }
                field(CodeField8; CodeFields[8])
                {
                    CaptionClass = '3,' + ColumnCaptions[8];
                    Visible = Code8Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(8);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(8);
                    end;
                }
                field(TextField8; TextFields[8])
                {
                    CaptionClass = '3,' + ColumnCaptions[8];
                    Visible = Text8Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(8);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(8);
                    end;
                }
                field(IntegerField8; IntegerFields[8])
                {
                    CaptionClass = '3,' + ColumnCaptions[8];
                    Visible = Integer8Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(8);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(8);
                    end;
                }
                field(DecimalField8; DecimalFields[8])
                {
                    CaptionClass = '3,' + ColumnCaptions[8];
                    Visible = Decimal8Visible;
                    DecimalPlaces = 0 : 25;

                    trigger OnValidate()
                    begin
                        ValidateField(8);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(8);
                    end;
                }
                field(BooleanField8; BooleanFields[8])
                {
                    CaptionClass = '3,' + ColumnCaptions[8];
                    Visible = Boolean8Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(8);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(8);
                    end;
                }
                field(DateField8; DateFields[8])
                {
                    CaptionClass = '3,' + ColumnCaptions[8];
                    Visible = Date8Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(8);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(8);
                    end;
                }
                field(DateTimeField8; DateTimeFields[8])
                {
                    CaptionClass = '3,' + ColumnCaptions[8];
                    Visible = DateTime8Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(8);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(8);
                    end;
                }
                field(TimeField8; TimeFields[8])
                {
                    CaptionClass = '3,' + ColumnCaptions[8];
                    Visible = Time8Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(8);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(8);
                    end;
                }
                field(CodeField9; CodeFields[9])
                {
                    CaptionClass = '3,' + ColumnCaptions[9];
                    Visible = Code9Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(9);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(9);
                    end;
                }
                field(TextField9; TextFields[9])
                {
                    CaptionClass = '3,' + ColumnCaptions[9];
                    Visible = Text9Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(9);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(9);
                    end;
                }
                field(IntegerField9; IntegerFields[9])
                {
                    CaptionClass = '3,' + ColumnCaptions[9];
                    Visible = Integer9Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(9);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(9);
                    end;
                }
                field(DecimalField9; DecimalFields[9])
                {
                    CaptionClass = '3,' + ColumnCaptions[9];
                    Visible = Decimal9Visible;
                    DecimalPlaces = 0 : 25;

                    trigger OnValidate()
                    begin
                        ValidateField(9);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(9);
                    end;
                }
                field(BooleanField9; BooleanFields[9])
                {
                    CaptionClass = '3,' + ColumnCaptions[9];
                    Visible = Boolean9Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(9);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(9);
                    end;
                }
                field(DateField9; DateFields[9])
                {
                    CaptionClass = '3,' + ColumnCaptions[9];
                    Visible = Date9Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(9);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(9);
                    end;
                }
                field(DateTimeField9; DateTimeFields[9])
                {
                    CaptionClass = '3,' + ColumnCaptions[9];
                    Visible = DateTime9Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(9);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(9);
                    end;
                }
                field(TimeField9; TimeFields[9])
                {
                    CaptionClass = '3,' + ColumnCaptions[9];
                    Visible = Time9Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(9);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(9);
                    end;
                }
                field(CodeField10; CodeFields[10])
                {
                    CaptionClass = '3,' + ColumnCaptions[10];
                    Visible = Code10Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(10);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(10);
                    end;
                }
                field(TextField10; TextFields[10])
                {
                    CaptionClass = '3,' + ColumnCaptions[10];
                    Visible = Text10Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(10);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(10);
                    end;
                }
                field(IntegerField10; IntegerFields[10])
                {
                    CaptionClass = '3,' + ColumnCaptions[10];
                    Visible = Integer10Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(10);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(10);
                    end;
                }
                field(DecimalField10; DecimalFields[10])
                {
                    CaptionClass = '3,' + ColumnCaptions[10];
                    Visible = Decimal10Visible;
                    DecimalPlaces = 0 : 25;

                    trigger OnValidate()
                    begin
                        ValidateField(10);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(10);
                    end;
                }
                field(BooleanField10; BooleanFields[10])
                {
                    CaptionClass = '3,' + ColumnCaptions[10];
                    Visible = Boolean10Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(10);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(10);
                    end;
                }
                field(DateField10; DateFields[10])
                {
                    CaptionClass = '3,' + ColumnCaptions[10];
                    Visible = Date10Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(10);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(10);
                    end;
                }
                field(DateTimeField10; DateTimeFields[10])
                {
                    CaptionClass = '3,' + ColumnCaptions[10];
                    Visible = DateTime10Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(10);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(10);
                    end;
                }
                field(TimeField10; TimeFields[10])
                {
                    CaptionClass = '3,' + ColumnCaptions[10];
                    Visible = Time10Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(10);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(10);
                    end;
                }
                field(CodeField11; CodeFields[11])
                {
                    CaptionClass = '3,' + ColumnCaptions[11];
                    Visible = Code11Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(11);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(11);
                    end;
                }
                field(TextField11; TextFields[11])
                {
                    CaptionClass = '3,' + ColumnCaptions[11];
                    Visible = Text11Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(11);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(11);
                    end;
                }
                field(IntegerField11; IntegerFields[11])
                {
                    CaptionClass = '3,' + ColumnCaptions[11];
                    Visible = Integer11Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(11);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(11);
                    end;
                }
                field(DecimalField11; DecimalFields[11])
                {
                    CaptionClass = '3,' + ColumnCaptions[11];
                    Visible = Decimal11Visible;
                    DecimalPlaces = 0 : 25;

                    trigger OnValidate()
                    begin
                        ValidateField(11);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(11);
                    end;
                }
                field(BooleanField11; BooleanFields[11])
                {
                    CaptionClass = '3,' + ColumnCaptions[11];
                    Visible = Boolean11Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(11);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(11);
                    end;
                }
                field(DateField11; DateFields[11])
                {
                    CaptionClass = '3,' + ColumnCaptions[11];
                    Visible = Date11Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(11);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(11);
                    end;
                }
                field(DateTimeField11; DateTimeFields[11])
                {
                    CaptionClass = '3,' + ColumnCaptions[11];
                    Visible = DateTime11Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(11);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(11);
                    end;
                }
                field(TimeField11; TimeFields[11])
                {
                    CaptionClass = '3,' + ColumnCaptions[11];
                    Visible = Time11Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(11);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(11);
                    end;
                }
                field(CodeField12; CodeFields[12])
                {
                    CaptionClass = '3,' + ColumnCaptions[12];
                    Visible = Code12Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(12);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(12);
                    end;
                }
                field(TextField12; TextFields[12])
                {
                    CaptionClass = '3,' + ColumnCaptions[12];
                    Visible = Text12Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(12);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(12);
                    end;
                }
                field(IntegerField12; IntegerFields[12])
                {
                    CaptionClass = '3,' + ColumnCaptions[12];
                    Visible = Integer12Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(12);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(12);
                    end;
                }
                field(DecimalField12; DecimalFields[12])
                {
                    CaptionClass = '3,' + ColumnCaptions[12];
                    Visible = Decimal12Visible;
                    DecimalPlaces = 0 : 25;

                    trigger OnValidate()
                    begin
                        ValidateField(12);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(12);
                    end;
                }
                field(BooleanField12; BooleanFields[12])
                {
                    CaptionClass = '3,' + ColumnCaptions[12];
                    Visible = Boolean12Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(12);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(12);
                    end;
                }
                field(DateField12; DateFields[12])
                {
                    CaptionClass = '3,' + ColumnCaptions[12];
                    Visible = Date12Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(12);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(12);
                    end;
                }
                field(DateTimeField12; DateTimeFields[12])
                {
                    CaptionClass = '3,' + ColumnCaptions[12];
                    Visible = DateTime12Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(12);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(12);
                    end;
                }
                field(TimeField12; TimeFields[12])
                {
                    CaptionClass = '3,' + ColumnCaptions[12];
                    Visible = Time12Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(12);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(12);
                    end;
                }
                field(CodeField13; CodeFields[13])
                {
                    CaptionClass = '3,' + ColumnCaptions[13];
                    Visible = Code13Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(13);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(13);
                    end;
                }
                field(TextField13; TextFields[13])
                {
                    CaptionClass = '3,' + ColumnCaptions[13];
                    Visible = Text13Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(13);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(13);
                    end;
                }
                field(IntegerField13; IntegerFields[13])
                {
                    CaptionClass = '3,' + ColumnCaptions[13];
                    Visible = Integer13Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(13);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(13);
                    end;
                }
                field(DecimalField13; DecimalFields[13])
                {
                    CaptionClass = '3,' + ColumnCaptions[13];
                    Visible = Decimal13Visible;
                    DecimalPlaces = 0 : 25;

                    trigger OnValidate()
                    begin
                        ValidateField(13);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(13);
                    end;
                }
                field(BooleanField13; BooleanFields[13])
                {
                    CaptionClass = '3,' + ColumnCaptions[13];
                    Visible = Boolean13Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(13);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(13);
                    end;
                }
                field(DateField13; DateFields[13])
                {
                    CaptionClass = '3,' + ColumnCaptions[13];
                    Visible = Date13Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(13);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(13);
                    end;
                }
                field(DateTimeField13; DateTimeFields[13])
                {
                    CaptionClass = '3,' + ColumnCaptions[13];
                    Visible = DateTime13Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(13);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(13);
                    end;
                }
                field(TimeField13; TimeFields[13])
                {
                    CaptionClass = '3,' + ColumnCaptions[13];
                    Visible = Time13Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(13);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(13);
                    end;
                }
                field(CodeField14; CodeFields[14])
                {
                    CaptionClass = '3,' + ColumnCaptions[14];
                    Visible = Code14Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(14);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(14);
                    end;
                }
                field(TextField14; TextFields[14])
                {
                    CaptionClass = '3,' + ColumnCaptions[14];
                    Visible = Text14Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(14);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(14);
                    end;
                }
                field(IntegerField14; IntegerFields[14])
                {
                    CaptionClass = '3,' + ColumnCaptions[14];
                    Visible = Integer14Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(14);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(14);
                    end;
                }
                field(DecimalField14; DecimalFields[14])
                {
                    CaptionClass = '3,' + ColumnCaptions[14];
                    Visible = Decimal14Visible;
                    DecimalPlaces = 0 : 25;

                    trigger OnValidate()
                    begin
                        ValidateField(14);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(14);
                    end;
                }
                field(BooleanField14; BooleanFields[14])
                {
                    CaptionClass = '3,' + ColumnCaptions[14];
                    Visible = Boolean14Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(14);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(14);
                    end;
                }
                field(DateField14; DateFields[14])
                {
                    CaptionClass = '3,' + ColumnCaptions[14];
                    Visible = Date14Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(14);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(14);
                    end;
                }
                field(DateTimeField14; DateTimeFields[14])
                {
                    CaptionClass = '3,' + ColumnCaptions[14];
                    Visible = DateTime14Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(14);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(14);
                    end;
                }
                field(TimeField14; TimeFields[14])
                {
                    CaptionClass = '3,' + ColumnCaptions[14];
                    Visible = Time14Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(14);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(14);
                    end;
                }
                field(CodeField15; CodeFields[15])
                {
                    CaptionClass = '3,' + ColumnCaptions[15];
                    Visible = Code15Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(15);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(15);
                    end;
                }
                field(TextField15; TextFields[15])
                {
                    CaptionClass = '3,' + ColumnCaptions[15];
                    Visible = Text15Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(15);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(15);
                    end;
                }
                field(IntegerField15; IntegerFields[15])
                {
                    CaptionClass = '3,' + ColumnCaptions[15];
                    Visible = Integer15Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(15);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(15);
                    end;
                }
                field(DecimalField15; DecimalFields[15])
                {
                    CaptionClass = '3,' + ColumnCaptions[15];
                    Visible = Decimal15Visible;
                    DecimalPlaces = 0 : 25;

                    trigger OnValidate()
                    begin
                        ValidateField(15);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(15);
                    end;
                }
                field(BooleanField15; BooleanFields[15])
                {
                    CaptionClass = '3,' + ColumnCaptions[15];
                    Visible = Boolean15Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(15);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(15);
                    end;
                }
                field(DateField15; DateFields[15])
                {
                    CaptionClass = '3,' + ColumnCaptions[15];
                    Visible = Date15Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(15);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(15);
                    end;
                }
                field(DateTimeField15; DateTimeFields[15])
                {
                    CaptionClass = '3,' + ColumnCaptions[15];
                    Visible = DateTime15Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(15);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(15);
                    end;
                }
                field(TimeField15; TimeFields[15])
                {
                    CaptionClass = '3,' + ColumnCaptions[15];
                    Visible = Time15Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(15);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(15);
                    end;
                }
                field(CodeField16; CodeFields[16])
                {
                    CaptionClass = '3,' + ColumnCaptions[16];
                    Visible = Code15Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(16);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(16);
                    end;
                }
                field(TextField16; TextFields[16])
                {
                    CaptionClass = '3,' + ColumnCaptions[16];
                    Visible = Text16Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(16);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(16);
                    end;
                }
                field(IntegerField16; IntegerFields[16])
                {
                    CaptionClass = '3,' + ColumnCaptions[16];
                    Visible = Integer16Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(16);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(16);
                    end;
                }
                field(DecimalField16; DecimalFields[16])
                {
                    CaptionClass = '3,' + ColumnCaptions[16];
                    Visible = Decimal16Visible;
                    DecimalPlaces = 0 : 25;

                    trigger OnValidate()
                    begin
                        ValidateField(16);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(16);
                    end;
                }
                field(BooleanField16; BooleanFields[16])
                {
                    CaptionClass = '3,' + ColumnCaptions[16];
                    Visible = Boolean16Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(16);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(16);
                    end;
                }
                field(DateField16; DateFields[16])
                {
                    CaptionClass = '3,' + ColumnCaptions[16];
                    Visible = Date16Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(16);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(16);
                    end;
                }
                field(DateTimeField16; DateTimeFields[16])
                {
                    CaptionClass = '3,' + ColumnCaptions[16];
                    Visible = DateTime16Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(16);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(16);
                    end;
                }
                field(TimeField16; TimeFields[16])
                {
                    CaptionClass = '3,' + ColumnCaptions[16];
                    Visible = Time16Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(16);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(16);
                    end;
                }
                field(CodeField17; CodeFields[17])
                {
                    CaptionClass = '3,' + ColumnCaptions[17];
                    Visible = Code17Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(17);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(17);
                    end;
                }
                field(TextField17; TextFields[17])
                {
                    CaptionClass = '3,' + ColumnCaptions[17];
                    Visible = Text17Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(17);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(17);
                    end;
                }
                field(IntegerField17; IntegerFields[17])
                {
                    CaptionClass = '3,' + ColumnCaptions[17];
                    Visible = Integer17Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(17);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(17);
                    end;
                }
                field(DecimalField17; DecimalFields[17])
                {
                    CaptionClass = '3,' + ColumnCaptions[17];
                    Visible = Decimal17Visible;
                    DecimalPlaces = 0 : 25;

                    trigger OnValidate()
                    begin
                        ValidateField(17);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(17);
                    end;
                }
                field(BooleanField17; BooleanFields[17])
                {
                    CaptionClass = '3,' + ColumnCaptions[17];
                    Visible = Boolean17Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(17);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(17);
                    end;
                }
                field(DateField17; DateFields[17])
                {
                    CaptionClass = '3,' + ColumnCaptions[17];
                    Visible = Date17Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(17);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(17);
                    end;
                }
                field(DateTimeField17; DateTimeFields[17])
                {
                    CaptionClass = '3,' + ColumnCaptions[17];
                    Visible = DateTime17Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(17);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(17);
                    end;
                }
                field(TimeField17; TimeFields[17])
                {
                    CaptionClass = '3,' + ColumnCaptions[17];
                    Visible = Time17Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(17);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(17);
                    end;
                }
                field(CodeField18; CodeFields[18])
                {
                    CaptionClass = '3,' + ColumnCaptions[18];
                    Visible = Code18Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(18);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(18);
                    end;
                }
                field(TextField18; TextFields[18])
                {
                    CaptionClass = '3,' + ColumnCaptions[18];
                    Visible = Text18Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(18);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(18);
                    end;
                }
                field(IntegerField18; IntegerFields[18])
                {
                    CaptionClass = '3,' + ColumnCaptions[18];
                    Visible = Integer18Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(18);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(18);
                    end;
                }
                field(DecimalField18; DecimalFields[18])
                {
                    CaptionClass = '3,' + ColumnCaptions[18];
                    Visible = Decimal18Visible;
                    DecimalPlaces = 0 : 25;

                    trigger OnValidate()
                    begin
                        ValidateField(18);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(18);
                    end;
                }
                field(BooleanField18; BooleanFields[18])
                {
                    CaptionClass = '3,' + ColumnCaptions[18];
                    Visible = Boolean18Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(18);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(18);
                    end;
                }
                field(DateField18; DateFields[18])
                {
                    CaptionClass = '3,' + ColumnCaptions[18];
                    Visible = Date18Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(18);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(18);
                    end;
                }
                field(DateTimeField18; DateTimeFields[18])
                {
                    CaptionClass = '3,' + ColumnCaptions[18];
                    Visible = DateTime18Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(18);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(18);
                    end;
                }
                field(TimeField18; TimeFields[18])
                {
                    CaptionClass = '3,' + ColumnCaptions[18];
                    Visible = Time18Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(18);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(18);
                    end;
                }
                field(CodeField19; CodeFields[19])
                {
                    CaptionClass = '3,' + ColumnCaptions[19];
                    Visible = Code19Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(19);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(19);
                    end;
                }
                field(TextField19; TextFields[19])
                {
                    CaptionClass = '3,' + ColumnCaptions[19];
                    Visible = Text19Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(19);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(19);
                    end;
                }
                field(IntegerField19; IntegerFields[19])
                {
                    CaptionClass = '3,' + ColumnCaptions[19];
                    Visible = Integer19Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(19);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(19);
                    end;
                }
                field(DecimalField19; DecimalFields[19])
                {
                    CaptionClass = '3,' + ColumnCaptions[19];
                    Visible = Decimal19Visible;
                    DecimalPlaces = 0 : 25;

                    trigger OnValidate()
                    begin
                        ValidateField(19);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(19);
                    end;
                }
                field(BooleanField19; BooleanFields[19])
                {
                    CaptionClass = '3,' + ColumnCaptions[19];
                    Visible = Boolean19Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(19);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(19);
                    end;
                }
                field(DateField19; DateFields[19])
                {
                    CaptionClass = '3,' + ColumnCaptions[19];
                    Visible = Date19Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(19);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(19);
                    end;
                }
                field(DateTimeField19; DateTimeFields[19])
                {
                    CaptionClass = '3,' + ColumnCaptions[19];
                    Visible = DateTime19Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(19);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(19);
                    end;
                }
                field(TimeField19; TimeFields[19])
                {
                    CaptionClass = '3,' + ColumnCaptions[19];
                    Visible = Time19Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(19);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(19);
                    end;
                }
                field(CodeField20; CodeFields[20])
                {
                    CaptionClass = '3,' + ColumnCaptions[20];
                    Visible = Code20Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(20);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(20);
                    end;
                }
                field(TextField20; TextFields[20])
                {
                    CaptionClass = '3,' + ColumnCaptions[20];
                    Visible = Text20Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(20);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(20);
                    end;
                }
                field(IntegerField20; IntegerFields[20])
                {
                    CaptionClass = '3,' + ColumnCaptions[20];
                    Visible = Integer20Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(20);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(20);
                    end;
                }
                field(DecimalField20; DecimalFields[20])
                {
                    CaptionClass = '3,' + ColumnCaptions[20];
                    Visible = Decimal20Visible;
                    DecimalPlaces = 0 : 25;

                    trigger OnValidate()
                    begin
                        ValidateField(20);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(20);
                    end;
                }
                field(BooleanField20; BooleanFields[20])
                {
                    CaptionClass = '3,' + ColumnCaptions[20];
                    Visible = Boolean20Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(20);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(20);
                    end;
                }
                field(DateField20; DateFields[20])
                {
                    CaptionClass = '3,' + ColumnCaptions[20];
                    Visible = Date20Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(20);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(20);
                    end;
                }
                field(DateTimeField20; DateTimeFields[20])
                {
                    CaptionClass = '3,' + ColumnCaptions[20];
                    Visible = DateTime20Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(20);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(20);
                    end;
                }
                field(TimeField20; TimeFields[20])
                {
                    CaptionClass = '3,' + ColumnCaptions[20];
                    Visible = Time20Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(20);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(20);
                    end;
                }
                field(CodeField21; CodeFields[21])
                {
                    CaptionClass = '3,' + ColumnCaptions[21];
                    Visible = Code21Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(21);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(21);
                    end;
                }
                field(TextField21; TextFields[21])
                {
                    CaptionClass = '3,' + ColumnCaptions[21];
                    Visible = Text21Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(21);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(21);
                    end;
                }
                field(IntegerField21; IntegerFields[21])
                {
                    CaptionClass = '3,' + ColumnCaptions[21];
                    Visible = Integer21Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(21);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(21);
                    end;
                }
                field(DecimalField21; DecimalFields[21])
                {
                    CaptionClass = '3,' + ColumnCaptions[21];
                    Visible = Decimal21Visible;
                    DecimalPlaces = 0 : 25;

                    trigger OnValidate()
                    begin
                        ValidateField(21);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(21);
                    end;
                }
                field(BooleanField21; BooleanFields[21])
                {
                    CaptionClass = '3,' + ColumnCaptions[21];
                    Visible = Boolean21Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(21);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(21);
                    end;
                }
                field(DateField21; DateFields[21])
                {
                    CaptionClass = '3,' + ColumnCaptions[21];
                    Visible = Date21Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(21);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(21);
                    end;
                }
                field(DateTimeField21; DateTimeFields[21])
                {
                    CaptionClass = '3,' + ColumnCaptions[21];
                    Visible = DateTime21Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(21);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(21);
                    end;
                }
                field(TimeField21; TimeFields[21])
                {
                    CaptionClass = '3,' + ColumnCaptions[21];
                    Visible = Time21Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(21);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(21);
                    end;
                }
                field(CodeField22; CodeFields[22])
                {
                    CaptionClass = '3,' + ColumnCaptions[22];
                    Visible = Code22Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(22);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(22);
                    end;
                }
                field(TextField22; TextFields[22])
                {
                    CaptionClass = '3,' + ColumnCaptions[22];
                    Visible = Text22Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(22);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(22);
                    end;
                }
                field(IntegerField22; IntegerFields[22])
                {
                    CaptionClass = '3,' + ColumnCaptions[22];
                    Visible = Integer22Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(22);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(22);
                    end;
                }
                field(DecimalField22; DecimalFields[22])
                {
                    CaptionClass = '3,' + ColumnCaptions[22];
                    Visible = Decimal22Visible;
                    DecimalPlaces = 0 : 25;

                    trigger OnValidate()
                    begin
                        ValidateField(22);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(22);
                    end;
                }
                field(BooleanField22; BooleanFields[22])
                {
                    CaptionClass = '3,' + ColumnCaptions[22];
                    Visible = Boolean22Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(22);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(22);
                    end;
                }
                field(DateField22; DateFields[22])
                {
                    CaptionClass = '3,' + ColumnCaptions[22];
                    Visible = Date22Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(22);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(22);
                    end;
                }
                field(DateTimeField22; DateTimeFields[22])
                {
                    CaptionClass = '3,' + ColumnCaptions[22];
                    Visible = DateTime22Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(22);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(22);
                    end;
                }
                field(TimeField22; TimeFields[22])
                {
                    CaptionClass = '3,' + ColumnCaptions[22];
                    Visible = Time22Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(22);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(2);
                    end;
                }
                field(CodeField23; CodeFields[23])
                {
                    CaptionClass = '3,' + ColumnCaptions[23];
                    Visible = Code23Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(23);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(23);
                    end;
                }
                field(TextField23; TextFields[23])
                {
                    CaptionClass = '3,' + ColumnCaptions[23];
                    Visible = Text23Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(23);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(23);
                    end;
                }
                field(IntegerField23; IntegerFields[23])
                {
                    CaptionClass = '3,' + ColumnCaptions[23];
                    Visible = Integer23Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(23);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(23);
                    end;
                }
                field(DecimalField23; DecimalFields[23])
                {
                    CaptionClass = '3,' + ColumnCaptions[23];
                    Visible = Decimal23Visible;
                    DecimalPlaces = 0 : 25;

                    trigger OnValidate()
                    begin
                        ValidateField(23);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(23);
                    end;
                }
                field(BooleanField23; BooleanFields[23])
                {
                    CaptionClass = '3,' + ColumnCaptions[23];
                    Visible = Boolean23Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(23);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(23);
                    end;
                }
                field(DateField23; DateFields[23])
                {
                    CaptionClass = '3,' + ColumnCaptions[23];
                    Visible = Date23Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(23);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(23);
                    end;
                }
                field(DateTimeField23; DateTimeFields[23])
                {
                    CaptionClass = '3,' + ColumnCaptions[23];
                    Visible = DateTime23Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(23);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(23);
                    end;
                }
                field(TimeField23; TimeFields[23])
                {
                    CaptionClass = '3,' + ColumnCaptions[23];
                    Visible = Time23Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(23);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(23);
                    end;
                }
                field(CodeField24; CodeFields[24])
                {
                    CaptionClass = '3,' + ColumnCaptions[24];
                    Visible = Code24Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(24);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(24);
                    end;
                }
                field(TextField24; TextFields[24])
                {
                    CaptionClass = '3,' + ColumnCaptions[24];
                    Visible = Text24Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(24);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(24);
                    end;
                }
                field(IntegerField24; IntegerFields[24])
                {
                    CaptionClass = '3,' + ColumnCaptions[24];
                    Visible = Integer24Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(24);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(24);
                    end;
                }
                field(DecimalField24; DecimalFields[24])
                {
                    CaptionClass = '3,' + ColumnCaptions[24];
                    Visible = Decimal24Visible;
                    DecimalPlaces = 0 : 25;

                    trigger OnValidate()
                    begin
                        ValidateField(24);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(24);
                    end;
                }
                field(BooleanField24; BooleanFields[24])
                {
                    CaptionClass = '3,' + ColumnCaptions[24];
                    Visible = Boolean24Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(24);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(24);
                    end;
                }
                field(DateField24; DateFields[24])
                {
                    CaptionClass = '3,' + ColumnCaptions[24];
                    Visible = Date24Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(24);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(24);
                    end;
                }
                field(DateTimeField24; DateTimeFields[24])
                {
                    CaptionClass = '3,' + ColumnCaptions[24];
                    Visible = DateTime24Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(24);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(24);
                    end;
                }
                field(TimeField24; TimeFields[24])
                {
                    CaptionClass = '3,' + ColumnCaptions[24];
                    Visible = Time24Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(24);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(24);
                    end;
                }
                field(CodeField25; CodeFields[25])
                {
                    CaptionClass = '3,' + ColumnCaptions[25];
                    Visible = Code25Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(25);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(25);
                    end;
                }
                field(TextField25; TextFields[25])
                {
                    CaptionClass = '3,' + ColumnCaptions[25];
                    Visible = Text25Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(25);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(25);
                    end;
                }
                field(IntegerField25; IntegerFields[25])
                {
                    CaptionClass = '3,' + ColumnCaptions[25];
                    Visible = Integer25Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(25);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(25);
                    end;
                }
                field(DecimalField25; DecimalFields[25])
                {
                    CaptionClass = '3,' + ColumnCaptions[25];
                    Visible = Decimal25Visible;
                    DecimalPlaces = 0 : 25;

                    trigger OnValidate()
                    begin
                        ValidateField(25);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(25);
                    end;
                }
                field(BooleanField25; BooleanFields[25])
                {
                    CaptionClass = '3,' + ColumnCaptions[25];
                    Visible = Boolean25Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(25);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(25);
                    end;
                }
                field(DateField25; DateFields[25])
                {
                    CaptionClass = '3,' + ColumnCaptions[25];
                    Visible = Date25Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(25);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(25);
                    end;
                }
                field(DateTimeField25; DateTimeFields[25])
                {
                    CaptionClass = '3,' + ColumnCaptions[25];
                    Visible = DateTime25Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(25);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(25);
                    end;
                }
                field(TimeField25; TimeFields[25])
                {
                    CaptionClass = '3,' + ColumnCaptions[25];
                    Visible = Time25Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(25);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(25);
                    end;
                }
                field(CodeField26; CodeFields[26])
                {
                    CaptionClass = '3,' + ColumnCaptions[26];
                    Visible = Code26Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(26);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(26);
                    end;
                }
                field(TextField26; TextFields[26])
                {
                    CaptionClass = '3,' + ColumnCaptions[26];
                    Visible = Text26Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(26);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(26);
                    end;
                }
                field(IntegerField26; IntegerFields[26])
                {
                    CaptionClass = '3,' + ColumnCaptions[26];
                    Visible = Integer26Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(26);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(26);
                    end;
                }
                field(DecimalField26; DecimalFields[26])
                {
                    CaptionClass = '3,' + ColumnCaptions[26];
                    Visible = Decimal26Visible;
                    DecimalPlaces = 0 : 25;

                    trigger OnValidate()
                    begin
                        ValidateField(26);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(26);
                    end;
                }
                field(BooleanField26; BooleanFields[26])
                {
                    CaptionClass = '3,' + ColumnCaptions[26];
                    Visible = Boolean26Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(26);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(26);
                    end;
                }
                field(DateField26; DateFields[26])
                {
                    CaptionClass = '3,' + ColumnCaptions[26];
                    Visible = Date26Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(26);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(26);
                    end;
                }
                field(DateTimeField26; DateTimeFields[26])
                {
                    CaptionClass = '3,' + ColumnCaptions[26];
                    Visible = DateTime26Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(26);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(26);
                    end;
                }
                field(TimeField26; TimeFields[26])
                {
                    CaptionClass = '3,' + ColumnCaptions[26];
                    Visible = Time26Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(26);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(26);
                    end;
                }
                field(CodeField27; CodeFields[27])
                {
                    CaptionClass = '3,' + ColumnCaptions[27];
                    Visible = Code27Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(27);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(27);
                    end;
                }
                field(TextField27; TextFields[27])
                {
                    CaptionClass = '3,' + ColumnCaptions[27];
                    Visible = Text27Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(27);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(27);
                    end;
                }
                field(IntegerField27; IntegerFields[27])
                {
                    CaptionClass = '3,' + ColumnCaptions[27];
                    Visible = Integer27Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(27);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(27);
                    end;
                }
                field(DecimalField27; DecimalFields[27])
                {
                    CaptionClass = '3,' + ColumnCaptions[27];
                    Visible = Decimal27Visible;
                    DecimalPlaces = 0 : 25;

                    trigger OnValidate()
                    begin
                        ValidateField(27);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(27);
                    end;
                }
                field(BooleanField27; BooleanFields[27])
                {
                    CaptionClass = '3,' + ColumnCaptions[27];
                    Visible = Boolean27Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(27);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(27);
                    end;
                }
                field(DateField27; DateFields[27])
                {
                    CaptionClass = '3,' + ColumnCaptions[27];
                    Visible = Date27Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(27);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(27);
                    end;
                }
                field(DateTimeField27; DateTimeFields[27])
                {
                    CaptionClass = '3,' + ColumnCaptions[27];
                    Visible = DateTime27Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(27);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(27);
                    end;
                }
                field(TimeField27; TimeFields[27])
                {
                    CaptionClass = '3,' + ColumnCaptions[27];
                    Visible = Time27Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(27);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(27);
                    end;
                }
                field(CodeField28; CodeFields[28])
                {
                    CaptionClass = '3,' + ColumnCaptions[28];
                    Visible = Code28Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(28);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(28);
                    end;
                }
                field(TextField28; TextFields[28])
                {
                    CaptionClass = '3,' + ColumnCaptions[28];
                    Visible = Text28Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(28);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(28);
                    end;
                }
                field(IntegerField28; IntegerFields[28])
                {
                    CaptionClass = '3,' + ColumnCaptions[28];
                    Visible = Integer28Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(28);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(28);
                    end;
                }
                field(DecimalField28; DecimalFields[28])
                {
                    CaptionClass = '3,' + ColumnCaptions[28];
                    Visible = Decimal28Visible;
                    DecimalPlaces = 0 : 25;

                    trigger OnValidate()
                    begin
                        ValidateField(28);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(28);
                    end;
                }
                field(BooleanField28; BooleanFields[28])
                {
                    CaptionClass = '3,' + ColumnCaptions[28];
                    Visible = Boolean28Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(28);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(28);
                    end;
                }
                field(DateField28; DateFields[28])
                {
                    CaptionClass = '3,' + ColumnCaptions[28];
                    Visible = Date28Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(28);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(28);
                    end;
                }
                field(DateTimeField28; DateTimeFields[28])
                {
                    CaptionClass = '3,' + ColumnCaptions[28];
                    Visible = DateTime28Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(28);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(28);
                    end;
                }
                field(TimeField28; TimeFields[28])
                {
                    CaptionClass = '3,' + ColumnCaptions[28];
                    Visible = Time28Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(28);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(28);
                    end;
                }
                field(CodeField29; CodeFields[29])
                {
                    CaptionClass = '3,' + ColumnCaptions[29];
                    Visible = Code29Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(29);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(29);
                    end;
                }
                field(TextField29; TextFields[29])
                {
                    CaptionClass = '3,' + ColumnCaptions[29];
                    Visible = Text29Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(29);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(29);
                    end;
                }
                field(IntegerField29; IntegerFields[29])
                {
                    CaptionClass = '3,' + ColumnCaptions[29];
                    Visible = Integer29Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(29);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(29);
                    end;
                }
                field(DecimalField29; DecimalFields[29])
                {
                    CaptionClass = '3,' + ColumnCaptions[29];
                    Visible = Decimal29Visible;
                    DecimalPlaces = 0 : 25;

                    trigger OnValidate()
                    begin
                        ValidateField(29);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(29);
                    end;
                }
                field(BooleanField29; BooleanFields[29])
                {
                    CaptionClass = '3,' + ColumnCaptions[29];
                    Visible = Boolean29Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(29);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(29);
                    end;
                }
                field(DateField29; DateFields[29])
                {
                    CaptionClass = '3,' + ColumnCaptions[29];
                    Visible = Date29Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(29);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(29);
                    end;
                }
                field(DateTimeField29; DateTimeFields[29])
                {
                    CaptionClass = '3,' + ColumnCaptions[29];
                    Visible = DateTime29Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(29);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(29);
                    end;
                }
                field(TimeField29; TimeFields[29])
                {
                    CaptionClass = '3,' + ColumnCaptions[29];
                    Visible = Time29Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(29);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(29);
                    end;
                }
                field(CodeField30; CodeFields[30])
                {
                    CaptionClass = '3,' + ColumnCaptions[30];
                    Visible = Code30Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(30);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(30);
                    end;
                }
                field(TextField30; TextFields[30])
                {
                    CaptionClass = '3,' + ColumnCaptions[30];
                    Visible = Text30Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(30);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(30);
                    end;
                }
                field(IntegerField30; IntegerFields[30])
                {
                    CaptionClass = '3,' + ColumnCaptions[30];
                    Visible = Integer30Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(30);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(30);
                    end;
                }
                field(DecimalField30; DecimalFields[30])
                {
                    CaptionClass = '3,' + ColumnCaptions[30];
                    Visible = Decimal30Visible;
                    DecimalPlaces = 0 : 25;

                    trigger OnValidate()
                    begin
                        ValidateField(30);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(30);
                    end;
                }
                field(BooleanField30; BooleanFields[30])
                {
                    CaptionClass = '3,' + ColumnCaptions[30];
                    Visible = Boolean30Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(30);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(30);
                    end;
                }
                field(DateField30; DateFields[30])
                {
                    CaptionClass = '3,' + ColumnCaptions[30];
                    Visible = Date30Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(30);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(30);
                    end;
                }
                field(DateTimeField30; DateTimeFields[30])
                {
                    CaptionClass = '3,' + ColumnCaptions[30];
                    Visible = DateTime30Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(30);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(30);
                    end;
                }
                field(TimeField30; TimeFields[30])
                {
                    CaptionClass = '3,' + ColumnCaptions[30];
                    Visible = Time30Visible;

                    trigger OnValidate()
                    begin
                        ValidateField(30);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupField(30);
                    end;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(PreviousSet)
            {
                Caption = 'Previous Set';
                Image = PreviousSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Enabled = Offset > 0;

                trigger OnAction()
                begin
                    if Offset > 0 then begin
                        Offset -= 30;
                        if Offset < 0 then
                            Offset := 0;
                        LoadColumns();
                    end;
                end;
            }
            action(NextSet)
            {
                Caption = 'Next Set';
                Image = NextSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Enabled = Offset < NoOfFieldsMinusMaxColumns;

                trigger OnAction()
                begin
                    if Offset < NoOfFieldsMinusMaxColumns then begin
                        Offset += 30;
                        LoadColumns();
                    end;
                end;
            }
            action(EditMultipleLines)
            {
                Caption = 'Edit Multiple Lines';
                Image = EditLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    TempTableEditor: Record "Table Editor" temporary;
                    RecordRefToUpdate: RecordRef;
                    SourceFieldRef: FieldRef;
                    FieldRef: FieldRef;
                begin
                    if not RecordRef.Get(LastModifiedRecordId) then
                        Error(RecordNotFoundErr);
                    SourceFieldRef := RecordRef.FieldIndex(LastModifiedColumnID + Offset);
                    if ConfigValidateManagement.IsKeyField(RecordRef.Number, SourceFieldRef.Number) then
                        Error(EditMultipleLinesErr);

                    TempTableEditor.Copy(Rec, true);
                    CurrPage.SetSelectionFilter(TempTableEditor);

                    if TempTableEditor.Count < Rec.Count then begin
                        if TempTableEditor.FindSet() then
                            repeat
                                if RecordRefToUpdate.Get(TempTableEditor."Record-Id") then begin
                                    FieldRef := RecordRefToUpdate.FieldIndex(LastModifiedColumnID + Offset);
                                    FieldRef.Validate(SourceFieldRef.Value);
                                    RecordRefToUpdate.Modify(true);
                                end;
                            until TempTableEditor.Next() = 0;
                    end else begin
                        RecordRefToUpdate := RecordRef.Duplicate();
                        if RecordRefToUpdate.FindSet(true) then
                            repeat
                                FieldRef := RecordRefToUpdate.FieldIndex(LastModifiedColumnID + Offset);
                                FieldRef.Validate(SourceFieldRef.Value);
                                RecordRefToUpdate.Modify(true);
                            until RecordRefToUpdate.Next() = 0;
                    end;
                end;
            }
            action(ExportToExcelAction)
            {
                Caption = 'Export to Excel';
                Image = ExportToExcel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    ExportToExcel();
                end;
            }
            action(ToggleOptionsVisible)
            {
                Caption = 'Show/Hide Options';
                Image = ToggleBreakpoint;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    OptionsVisible := not OptionsVisible;
                end;
            }
            action(ToggleMoreOptionsVisible)
            {
                Caption = 'Show/Hide More Options';
                Image = ToggleBreakpoint;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    MoreOptionsVisible := not MoreOptionsVisible;
                end;
            }
            action(GoToField)
            {
                Caption = 'Go to Field';
                Image = GoTo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    Field: Record Field;
                    FieldRef: FieldRef;
                    i: Integer;
                begin
                    SetFieldsFilter(Field);
                    if Page.RunModal(Page::"Fields Lookup", Field) = Action::LookupOK then
                        for i := 1 to RecordRef.FieldCount do begin
                            FieldRef := RecordRef.FieldIndex(i);
                            if FieldRef.Number = Field."No." then begin
                                Offset := i - 1;
                                LoadColumns();
                                exit;
                            end;
                        end;
                end;
            }
        }
    }

    trigger OnInit()
    begin
        LastModifiedColumnID := 1;
        ShowCaptions := true;
        OptionsVisible := true;
        RunInsertTrigger := true;
        RunModifyTrigger := true;
        RunDeleteTrigger := true;
        RunValidateTrigger := true;
    end;

    trigger OnOpenPage()
    begin
        CheckPermission();
        if TableNo = 0 then begin
            TableNo := Database::"Payment Terms";
            RecordRef.Open(TableNo);
        end;
        NoOfRecords := RecordRef.Count;
        Sorting := RecordRef.GetView();
        Filters := RecordRef.GetFilters().Replace(', ', '\');
        SetIsTempRec(RecordRef.IsTemporary);
        LoadColumns();
    end;

    trigger OnFindRecord(Which: Text): Boolean
    var
        Found: Boolean;
    begin
        Found := RecordRef.Find(Which);
        if Found then
            InsertRec(RecordRef.RecordId);
        exit(Found);
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    var
        ResultSteps: Integer;
    begin
        ResultSteps := RecordRef.Next(Steps);
        if ResultSteps <> 0 then
            InsertRec(RecordRef.RecordId);
        exit(ResultSteps);
    end;

    trigger OnAfterGetRecord()
    begin
        if (Rec."Record-Id" <> RecordRef.RecordId) and (Rec."Record-Id".TableNo <> 0) then
            RecordRef.Get(Rec."Record-Id");
        UpdateFieldsData();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        RenameRequired := false;
        ModifyRequired := false;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        InitRecordRef();
        ClearFields();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        RecordRef.Insert(RunInsertTrigger);
        Rec."Record-Id" := RecordRef.RecordId;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if RenameRequired then begin
            RenameRecord();
            RenameRequired := false;
        end;
        if ModifyRequired then begin
            RecordRef.Modify(RunModifyTrigger);
            ModifyRequired := false;
        end;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        RecordRef.Delete(RunDeleteTrigger);
    end;

    var
        ConfigValidateManagement: Codeunit "Config. Validate Management";
        RecordRef: RecordRef;
        LastModifiedRecordID: RecordId;
        TableNo: Integer;
        ShowCaptions: Boolean;
        RunInsertTrigger: Boolean;
        RunModifyTrigger: Boolean;
        RunDeleteTrigger: Boolean;
        RunValidateTrigger: Boolean;
        Filters: Text;
        Sorting: Text;
        NoOfRecords: Integer;
        LastModifiedColumnID: Integer;
        CurrentValue: Text;
        RenameRequired: Boolean;
        ModifyRequired: Boolean;
        Offset: Integer;
        Columns: Integer;
        NoOfFieldsMinusMaxColumns: Integer;
        IsTemporaryText: Text;
        OptionsVisible: Boolean;
        MoreOptionsVisible: Boolean;
        CodeFields: array[30] of Code[2048];
        TextFields: array[30] of Text;
        IntegerFields: array[30] of BigInteger;
        DecimalFields: array[30] of Decimal;
        BooleanFields: array[30] of Boolean;
        DateFields: array[30] of Date;
        DateTimeFields: array[30] of DateTime;
        TimeFields: array[30] of Time;
        ColumnCaptions: array[30] of Text;
        Integer1Visible: Boolean;
        Integer2Visible: Boolean;
        Integer3Visible: Boolean;
        Integer4Visible: Boolean;
        Integer5Visible: Boolean;
        Integer6Visible: Boolean;
        Integer7Visible: Boolean;
        Integer8Visible: Boolean;
        Integer9Visible: Boolean;
        Integer10Visible: Boolean;
        Integer11Visible: Boolean;
        Integer12Visible: Boolean;
        Integer13Visible: Boolean;
        Integer14Visible: Boolean;
        Integer15Visible: Boolean;
        Integer16Visible: Boolean;
        Integer17Visible: Boolean;
        Integer18Visible: Boolean;
        Integer19Visible: Boolean;
        Integer20Visible: Boolean;
        Integer21Visible: Boolean;
        Integer22Visible: Boolean;
        Integer23Visible: Boolean;
        Integer24Visible: Boolean;
        Integer25Visible: Boolean;
        Integer26Visible: Boolean;
        Integer27Visible: Boolean;
        Integer28Visible: Boolean;
        Integer29Visible: Boolean;
        Integer30Visible: Boolean;
        Decimal1Visible: Boolean;
        Decimal2Visible: Boolean;
        Decimal3Visible: Boolean;
        Decimal4Visible: Boolean;
        Decimal5Visible: Boolean;
        Decimal6Visible: Boolean;
        Decimal7Visible: Boolean;
        Decimal8Visible: Boolean;
        Decimal9Visible: Boolean;
        Decimal10Visible: Boolean;
        Decimal11Visible: Boolean;
        Decimal12Visible: Boolean;
        Decimal13Visible: Boolean;
        Decimal14Visible: Boolean;
        Decimal15Visible: Boolean;
        Decimal16Visible: Boolean;
        Decimal17Visible: Boolean;
        Decimal18Visible: Boolean;
        Decimal19Visible: Boolean;
        Decimal20Visible: Boolean;
        Decimal21Visible: Boolean;
        Decimal22Visible: Boolean;
        Decimal23Visible: Boolean;
        Decimal24Visible: Boolean;
        Decimal25Visible: Boolean;
        Decimal26Visible: Boolean;
        Decimal27Visible: Boolean;
        Decimal28Visible: Boolean;
        Decimal29Visible: Boolean;
        Decimal30Visible: Boolean;
        Code1Visible: Boolean;
        Code2Visible: Boolean;
        Code3Visible: Boolean;
        Code4Visible: Boolean;
        Code5Visible: Boolean;
        Code6Visible: Boolean;
        Code7Visible: Boolean;
        Code8Visible: Boolean;
        Code9Visible: Boolean;
        Code10Visible: Boolean;
        Code11Visible: Boolean;
        Code12Visible: Boolean;
        Code13Visible: Boolean;
        Code14Visible: Boolean;
        Code15Visible: Boolean;
        Code16Visible: Boolean;
        Code17Visible: Boolean;
        Code18Visible: Boolean;
        Code19Visible: Boolean;
        Code20Visible: Boolean;
        Code21Visible: Boolean;
        Code22Visible: Boolean;
        Code23Visible: Boolean;
        Code24Visible: Boolean;
        Code25Visible: Boolean;
        Code26Visible: Boolean;
        Code27Visible: Boolean;
        Code28Visible: Boolean;
        Code29Visible: Boolean;
        Code30Visible: Boolean;
        Text1Visible: Boolean;
        Text2Visible: Boolean;
        Text3Visible: Boolean;
        Text4Visible: Boolean;
        Text5Visible: Boolean;
        Text6Visible: Boolean;
        Text7Visible: Boolean;
        Text8Visible: Boolean;
        Text9Visible: Boolean;
        Text10Visible: Boolean;
        Text11Visible: Boolean;
        Text12Visible: Boolean;
        Text13Visible: Boolean;
        Text14Visible: Boolean;
        Text15Visible: Boolean;
        Text16Visible: Boolean;
        Text17Visible: Boolean;
        Text18Visible: Boolean;
        Text19Visible: Boolean;
        Text20Visible: Boolean;
        Text21Visible: Boolean;
        Text22Visible: Boolean;
        Text23Visible: Boolean;
        Text24Visible: Boolean;
        Text25Visible: Boolean;
        Text26Visible: Boolean;
        Text27Visible: Boolean;
        Text28Visible: Boolean;
        Text29Visible: Boolean;
        Text30Visible: Boolean;
        Date1Visible: Boolean;
        Date2Visible: Boolean;
        Date3Visible: Boolean;
        Date4Visible: Boolean;
        Date5Visible: Boolean;
        Date6Visible: Boolean;
        Date7Visible: Boolean;
        Date8Visible: Boolean;
        Date9Visible: Boolean;
        Date10Visible: Boolean;
        Date11Visible: Boolean;
        Date12Visible: Boolean;
        Date13Visible: Boolean;
        Date14Visible: Boolean;
        Date15Visible: Boolean;
        Date16Visible: Boolean;
        Date17Visible: Boolean;
        Date18Visible: Boolean;
        Date19Visible: Boolean;
        Date20Visible: Boolean;
        Date21Visible: Boolean;
        Date22Visible: Boolean;
        Date23Visible: Boolean;
        Date24Visible: Boolean;
        Date25Visible: Boolean;
        Date26Visible: Boolean;
        Date27Visible: Boolean;
        Date28Visible: Boolean;
        Date29Visible: Boolean;
        Date30Visible: Boolean;
        DateTime1Visible: Boolean;
        DateTime2Visible: Boolean;
        DateTime3Visible: Boolean;
        DateTime4Visible: Boolean;
        DateTime5Visible: Boolean;
        DateTime6Visible: Boolean;
        DateTime7Visible: Boolean;
        DateTime8Visible: Boolean;
        DateTime9Visible: Boolean;
        DateTime10Visible: Boolean;
        DateTime11Visible: Boolean;
        DateTime12Visible: Boolean;
        DateTime13Visible: Boolean;
        DateTime14Visible: Boolean;
        DateTime15Visible: Boolean;
        DateTime16Visible: Boolean;
        DateTime17Visible: Boolean;
        DateTime18Visible: Boolean;
        DateTime19Visible: Boolean;
        DateTime20Visible: Boolean;
        DateTime21Visible: Boolean;
        DateTime22Visible: Boolean;
        DateTime23Visible: Boolean;
        DateTime24Visible: Boolean;
        DateTime25Visible: Boolean;
        DateTime26Visible: Boolean;
        DateTime27Visible: Boolean;
        DateTime28Visible: Boolean;
        DateTime29Visible: Boolean;
        DateTime30Visible: Boolean;
        Time1Visible: Boolean;
        Time2Visible: Boolean;
        Time3Visible: Boolean;
        Time4Visible: Boolean;
        Time5Visible: Boolean;
        Time6Visible: Boolean;
        Time7Visible: Boolean;
        Time8Visible: Boolean;
        Time9Visible: Boolean;
        Time10Visible: Boolean;
        Time11Visible: Boolean;
        Time12Visible: Boolean;
        Time13Visible: Boolean;
        Time14Visible: Boolean;
        Time15Visible: Boolean;
        Time16Visible: Boolean;
        Time17Visible: Boolean;
        Time18Visible: Boolean;
        Time19Visible: Boolean;
        Time20Visible: Boolean;
        Time21Visible: Boolean;
        Time22Visible: Boolean;
        Time23Visible: Boolean;
        Time24Visible: Boolean;
        Time25Visible: Boolean;
        Time26Visible: Boolean;
        Time27Visible: Boolean;
        Time28Visible: Boolean;
        Time29Visible: Boolean;
        Time30Visible: Boolean;
        Boolean1Visible: Boolean;
        Boolean2Visible: Boolean;
        Boolean3Visible: Boolean;
        Boolean4Visible: Boolean;
        Boolean5Visible: Boolean;
        Boolean6Visible: Boolean;
        Boolean7Visible: Boolean;
        Boolean8Visible: Boolean;
        Boolean9Visible: Boolean;
        Boolean10Visible: Boolean;
        Boolean11Visible: Boolean;
        Boolean12Visible: Boolean;
        Boolean13Visible: Boolean;
        Boolean14Visible: Boolean;
        Boolean15Visible: Boolean;
        Boolean16Visible: Boolean;
        Boolean17Visible: Boolean;
        Boolean18Visible: Boolean;
        Boolean19Visible: Boolean;
        Boolean20Visible: Boolean;
        Boolean21Visible: Boolean;
        Boolean22Visible: Boolean;
        Boolean23Visible: Boolean;
        Boolean24Visible: Boolean;
        Boolean25Visible: Boolean;
        Boolean26Visible: Boolean;
        Boolean27Visible: Boolean;
        Boolean28Visible: Boolean;
        Boolean29Visible: Boolean;
        Boolean30Visible: Boolean;
        EditMultipleLinesErr: Label 'Edit multiple lines is not allowed for primary key fields.';
        RecordNotFoundErr: Label 'Record not found. Please modify a record at first.';
        ConfirmRenameQst: Label 'Your change might update related records, which can take a while. Do you want to continue?';
        InvalidVariableErr: Label 'Invalid variable has been passed to the page.\Value:\%1', Comment = '%1=Value';
        TemporarySourceTableLbl: Label 'The source table of this page is temporary';
        AccessDeniedErr: Label 'Access denied.';

    local procedure SetFieldsVisibility(ColumnID: Integer; FieldType: FieldType)
    begin
        case FieldType of
            FieldType::Integer, FieldType::BigInteger:
                begin
                    Integer1Visible := (ColumnID = 1) or Integer1Visible;
                    Integer2Visible := (ColumnID = 2) or Integer2Visible;
                    Integer3Visible := (ColumnID = 3) or Integer3Visible;
                    Integer4Visible := (ColumnID = 4) or Integer4Visible;
                    Integer5Visible := (ColumnID = 5) or Integer5Visible;
                    Integer6Visible := (ColumnID = 6) or Integer6Visible;
                    Integer7Visible := (ColumnID = 7) or Integer7Visible;
                    Integer8Visible := (ColumnID = 8) or Integer8Visible;
                    Integer9Visible := (ColumnID = 9) or Integer9Visible;
                    Integer10Visible := (ColumnID = 10) or Integer10Visible;
                    Integer11Visible := (ColumnID = 11) or Integer11Visible;
                    Integer12Visible := (ColumnID = 12) or Integer12Visible;
                    Integer13Visible := (ColumnID = 13) or Integer13Visible;
                    Integer14Visible := (ColumnID = 14) or Integer14Visible;
                    Integer15Visible := (ColumnID = 15) or Integer15Visible;
                    Integer16Visible := (ColumnID = 16) or Integer16Visible;
                    Integer17Visible := (ColumnID = 17) or Integer17Visible;
                    Integer18Visible := (ColumnID = 18) or Integer18Visible;
                    Integer19Visible := (ColumnID = 19) or Integer19Visible;
                    Integer20Visible := (ColumnID = 20) or Integer20Visible;
                    Integer21Visible := (ColumnID = 21) or Integer21Visible;
                    Integer22Visible := (ColumnID = 22) or Integer22Visible;
                    Integer23Visible := (ColumnID = 23) or Integer23Visible;
                    Integer24Visible := (ColumnID = 24) or Integer24Visible;
                    Integer25Visible := (ColumnID = 25) or Integer25Visible;
                    Integer26Visible := (ColumnID = 26) or Integer26Visible;
                    Integer27Visible := (ColumnID = 27) or Integer27Visible;
                    Integer28Visible := (ColumnID = 28) or Integer28Visible;
                    Integer29Visible := (ColumnID = 29) or Integer29Visible;
                    Integer30Visible := (ColumnID = 30) or Integer30Visible;
                end;
            FieldType::Decimal:
                begin
                    Decimal1Visible := (ColumnID = 1) or Decimal1Visible;
                    Decimal2Visible := (ColumnID = 2) or Decimal2Visible;
                    Decimal3Visible := (ColumnID = 3) or Decimal3Visible;
                    Decimal4Visible := (ColumnID = 4) or Decimal4Visible;
                    Decimal5Visible := (ColumnID = 5) or Decimal5Visible;
                    Decimal6Visible := (ColumnID = 6) or Decimal6Visible;
                    Decimal7Visible := (ColumnID = 7) or Decimal7Visible;
                    Decimal8Visible := (ColumnID = 8) or Decimal8Visible;
                    Decimal9Visible := (ColumnID = 9) or Decimal9Visible;
                    Decimal10Visible := (ColumnID = 10) or Decimal10Visible;
                    Decimal11Visible := (ColumnID = 11) or Decimal11Visible;
                    Decimal12Visible := (ColumnID = 12) or Decimal12Visible;
                    Decimal13Visible := (ColumnID = 13) or Decimal13Visible;
                    Decimal14Visible := (ColumnID = 14) or Decimal14Visible;
                    Decimal15Visible := (ColumnID = 15) or Decimal15Visible;
                    Decimal16Visible := (ColumnID = 16) or Decimal16Visible;
                    Decimal17Visible := (ColumnID = 17) or Decimal17Visible;
                    Decimal18Visible := (ColumnID = 18) or Decimal18Visible;
                    Decimal19Visible := (ColumnID = 19) or Decimal19Visible;
                    Decimal20Visible := (ColumnID = 20) or Decimal20Visible;
                    Decimal21Visible := (ColumnID = 21) or Decimal21Visible;
                    Decimal22Visible := (ColumnID = 22) or Decimal22Visible;
                    Decimal23Visible := (ColumnID = 23) or Decimal23Visible;
                    Decimal24Visible := (ColumnID = 24) or Decimal24Visible;
                    Decimal25Visible := (ColumnID = 25) or Decimal25Visible;
                    Decimal26Visible := (ColumnID = 26) or Decimal26Visible;
                    Decimal27Visible := (ColumnID = 27) or Decimal27Visible;
                    Decimal28Visible := (ColumnID = 28) or Decimal28Visible;
                    Decimal29Visible := (ColumnID = 29) or Decimal29Visible;
                    Decimal30Visible := (ColumnID = 30) or Decimal30Visible;
                end;
            FieldType::Date:
                begin
                    Date1Visible := (ColumnID = 1) or Date1Visible;
                    Date2Visible := (ColumnID = 2) or Date2Visible;
                    Date3Visible := (ColumnID = 3) or Date3Visible;
                    Date4Visible := (ColumnID = 4) or Date4Visible;
                    Date5Visible := (ColumnID = 5) or Date5Visible;
                    Date6Visible := (ColumnID = 6) or Date6Visible;
                    Date7Visible := (ColumnID = 7) or Date7Visible;
                    Date8Visible := (ColumnID = 8) or Date8Visible;
                    Date9Visible := (ColumnID = 9) or Date9Visible;
                    Date10Visible := (ColumnID = 10) or Date10Visible;
                    Date11Visible := (ColumnID = 11) or Date11Visible;
                    Date12Visible := (ColumnID = 12) or Date12Visible;
                    Date13Visible := (ColumnID = 13) or Date13Visible;
                    Date14Visible := (ColumnID = 14) or Date14Visible;
                    Date15Visible := (ColumnID = 15) or Date15Visible;
                    Date16Visible := (ColumnID = 16) or Date16Visible;
                    Date17Visible := (ColumnID = 17) or Date17Visible;
                    Date18Visible := (ColumnID = 18) or Date18Visible;
                    Date19Visible := (ColumnID = 19) or Date19Visible;
                    Date20Visible := (ColumnID = 20) or Date20Visible;
                    Date21Visible := (ColumnID = 21) or Date21Visible;
                    Date22Visible := (ColumnID = 22) or Date22Visible;
                    Date23Visible := (ColumnID = 23) or Date23Visible;
                    Date24Visible := (ColumnID = 24) or Date24Visible;
                    Date25Visible := (ColumnID = 25) or Date25Visible;
                    Date26Visible := (ColumnID = 26) or Date26Visible;
                    Date27Visible := (ColumnID = 27) or Date27Visible;
                    Date28Visible := (ColumnID = 28) or Date28Visible;
                    Date29Visible := (ColumnID = 29) or Date29Visible;
                    Date30Visible := (ColumnID = 30) or Date30Visible;
                end;
            FieldType::DateTime:
                begin
                    DateTime1Visible := (ColumnID = 1) or DateTime1Visible;
                    DateTime2Visible := (ColumnID = 2) or DateTime2Visible;
                    DateTime3Visible := (ColumnID = 3) or DateTime3Visible;
                    DateTime4Visible := (ColumnID = 4) or DateTime4Visible;
                    DateTime5Visible := (ColumnID = 5) or DateTime5Visible;
                    DateTime6Visible := (ColumnID = 6) or DateTime6Visible;
                    DateTime7Visible := (ColumnID = 7) or DateTime7Visible;
                    DateTime8Visible := (ColumnID = 8) or DateTime8Visible;
                    DateTime9Visible := (ColumnID = 9) or DateTime9Visible;
                    DateTime10Visible := (ColumnID = 10) or DateTime10Visible;
                    DateTime11Visible := (ColumnID = 11) or DateTime11Visible;
                    DateTime12Visible := (ColumnID = 12) or DateTime12Visible;
                    DateTime13Visible := (ColumnID = 13) or DateTime13Visible;
                    DateTime14Visible := (ColumnID = 14) or DateTime14Visible;
                    DateTime15Visible := (ColumnID = 15) or DateTime15Visible;
                    DateTime16Visible := (ColumnID = 16) or DateTime16Visible;
                    DateTime17Visible := (ColumnID = 17) or DateTime17Visible;
                    DateTime18Visible := (ColumnID = 18) or DateTime18Visible;
                    DateTime19Visible := (ColumnID = 19) or DateTime19Visible;
                    DateTime20Visible := (ColumnID = 20) or DateTime20Visible;
                    DateTime21Visible := (ColumnID = 21) or DateTime21Visible;
                    DateTime22Visible := (ColumnID = 22) or DateTime22Visible;
                    DateTime23Visible := (ColumnID = 23) or DateTime23Visible;
                    DateTime24Visible := (ColumnID = 24) or DateTime24Visible;
                    DateTime25Visible := (ColumnID = 25) or DateTime25Visible;
                    DateTime26Visible := (ColumnID = 26) or DateTime26Visible;
                    DateTime27Visible := (ColumnID = 27) or DateTime27Visible;
                    DateTime28Visible := (ColumnID = 28) or DateTime28Visible;
                    DateTime29Visible := (ColumnID = 29) or DateTime29Visible;
                    DateTime30Visible := (ColumnID = 30) or DateTime30Visible;
                end;
            FieldType::Time:
                begin
                    Time1Visible := (ColumnID = 1) or Time1Visible;
                    Time2Visible := (ColumnID = 2) or Time2Visible;
                    Time3Visible := (ColumnID = 3) or Time3Visible;
                    Time4Visible := (ColumnID = 4) or Time4Visible;
                    Time5Visible := (ColumnID = 5) or Time5Visible;
                    Time6Visible := (ColumnID = 6) or Time6Visible;
                    Time7Visible := (ColumnID = 7) or Time7Visible;
                    Time8Visible := (ColumnID = 8) or Time8Visible;
                    Time9Visible := (ColumnID = 9) or Time9Visible;
                    Time10Visible := (ColumnID = 10) or Time10Visible;
                    Time11Visible := (ColumnID = 11) or Time11Visible;
                    Time12Visible := (ColumnID = 12) or Time12Visible;
                    Time13Visible := (ColumnID = 13) or Time13Visible;
                    Time14Visible := (ColumnID = 14) or Time14Visible;
                    Time15Visible := (ColumnID = 15) or Time15Visible;
                    Time16Visible := (ColumnID = 16) or Time16Visible;
                    Time17Visible := (ColumnID = 17) or Time17Visible;
                    Time18Visible := (ColumnID = 18) or Time18Visible;
                    Time19Visible := (ColumnID = 19) or Time19Visible;
                    Time20Visible := (ColumnID = 20) or Time20Visible;
                    Time21Visible := (ColumnID = 21) or Time21Visible;
                    Time22Visible := (ColumnID = 22) or Time22Visible;
                    Time23Visible := (ColumnID = 23) or Time23Visible;
                    Time24Visible := (ColumnID = 24) or Time24Visible;
                    Time25Visible := (ColumnID = 25) or Time25Visible;
                    Time26Visible := (ColumnID = 26) or Time26Visible;
                    Time27Visible := (ColumnID = 27) or Time27Visible;
                    Time28Visible := (ColumnID = 28) or Time28Visible;
                    Time29Visible := (ColumnID = 29) or Time29Visible;
                    Time30Visible := (ColumnID = 30) or Time30Visible;
                end;
            FieldType::Boolean:
                begin
                    Boolean1Visible := (ColumnID = 1) or Boolean1Visible;
                    Boolean2Visible := (ColumnID = 2) or Boolean2Visible;
                    Boolean3Visible := (ColumnID = 3) or Boolean3Visible;
                    Boolean4Visible := (ColumnID = 4) or Boolean4Visible;
                    Boolean5Visible := (ColumnID = 5) or Boolean5Visible;
                    Boolean6Visible := (ColumnID = 6) or Boolean6Visible;
                    Boolean7Visible := (ColumnID = 7) or Boolean7Visible;
                    Boolean8Visible := (ColumnID = 8) or Boolean8Visible;
                    Boolean9Visible := (ColumnID = 9) or Boolean9Visible;
                    Boolean10Visible := (ColumnID = 10) or Boolean10Visible;
                    Boolean11Visible := (ColumnID = 11) or Boolean11Visible;
                    Boolean12Visible := (ColumnID = 12) or Boolean12Visible;
                    Boolean13Visible := (ColumnID = 13) or Boolean13Visible;
                    Boolean14Visible := (ColumnID = 14) or Boolean14Visible;
                    Boolean15Visible := (ColumnID = 15) or Boolean15Visible;
                    Boolean16Visible := (ColumnID = 16) or Boolean16Visible;
                    Boolean17Visible := (ColumnID = 17) or Boolean17Visible;
                    Boolean18Visible := (ColumnID = 18) or Boolean18Visible;
                    Boolean19Visible := (ColumnID = 19) or Boolean19Visible;
                    Boolean20Visible := (ColumnID = 20) or Boolean20Visible;
                    Boolean21Visible := (ColumnID = 21) or Boolean21Visible;
                    Boolean22Visible := (ColumnID = 22) or Boolean22Visible;
                    Boolean23Visible := (ColumnID = 23) or Boolean23Visible;
                    Boolean24Visible := (ColumnID = 24) or Boolean24Visible;
                    Boolean25Visible := (ColumnID = 25) or Boolean25Visible;
                    Boolean26Visible := (ColumnID = 26) or Boolean26Visible;
                    Boolean27Visible := (ColumnID = 27) or Boolean27Visible;
                    Boolean28Visible := (ColumnID = 28) or Boolean28Visible;
                    Boolean29Visible := (ColumnID = 29) or Boolean29Visible;
                    Boolean30Visible := (ColumnID = 30) or Boolean30Visible;
                end;
            FieldType::Code:
                begin
                    Code1Visible := (ColumnID = 1) or Code1Visible;
                    Code2Visible := (ColumnID = 2) or Code2Visible;
                    Code3Visible := (ColumnID = 3) or Code3Visible;
                    Code4Visible := (ColumnID = 4) or Code4Visible;
                    Code5Visible := (ColumnID = 5) or Code5Visible;
                    Code6Visible := (ColumnID = 6) or Code6Visible;
                    Code7Visible := (ColumnID = 7) or Code7Visible;
                    Code8Visible := (ColumnID = 8) or Code8Visible;
                    Code9Visible := (ColumnID = 9) or Code9Visible;
                    Code10Visible := (ColumnID = 10) or Code10Visible;
                    Code11Visible := (ColumnID = 11) or Code11Visible;
                    Code12Visible := (ColumnID = 12) or Code12Visible;
                    Code13Visible := (ColumnID = 13) or Code13Visible;
                    Code14Visible := (ColumnID = 14) or Code14Visible;
                    Code15Visible := (ColumnID = 15) or Code15Visible;
                    Code16Visible := (ColumnID = 16) or Code16Visible;
                    Code17Visible := (ColumnID = 17) or Code17Visible;
                    Code18Visible := (ColumnID = 18) or Code18Visible;
                    Code19Visible := (ColumnID = 19) or Code19Visible;
                    Code20Visible := (ColumnID = 20) or Code20Visible;
                    Code21Visible := (ColumnID = 21) or Code21Visible;
                    Code22Visible := (ColumnID = 22) or Code22Visible;
                    Code23Visible := (ColumnID = 23) or Code23Visible;
                    Code24Visible := (ColumnID = 24) or Code24Visible;
                    Code25Visible := (ColumnID = 25) or Code25Visible;
                    Code26Visible := (ColumnID = 26) or Code26Visible;
                    Code27Visible := (ColumnID = 27) or Code27Visible;
                    Code28Visible := (ColumnID = 28) or Code28Visible;
                    Code29Visible := (ColumnID = 29) or Code29Visible;
                    Code30Visible := (ColumnID = 30) or Code30Visible;
                end;
            else
                Text1Visible := (ColumnID = 1) or Text1Visible;
                Text2Visible := (ColumnID = 2) or Text2Visible;
                Text3Visible := (ColumnID = 3) or Text3Visible;
                Text4Visible := (ColumnID = 4) or Text4Visible;
                Text5Visible := (ColumnID = 5) or Text5Visible;
                Text6Visible := (ColumnID = 6) or Text6Visible;
                Text7Visible := (ColumnID = 7) or Text7Visible;
                Text8Visible := (ColumnID = 8) or Text8Visible;
                Text9Visible := (ColumnID = 9) or Text9Visible;
                Text10Visible := (ColumnID = 10) or Text10Visible;
                Text11Visible := (ColumnID = 11) or Text11Visible;
                Text12Visible := (ColumnID = 12) or Text12Visible;
                Text13Visible := (ColumnID = 13) or Text13Visible;
                Text14Visible := (ColumnID = 14) or Text14Visible;
                Text15Visible := (ColumnID = 15) or Text15Visible;
                Text16Visible := (ColumnID = 16) or Text16Visible;
                Text17Visible := (ColumnID = 17) or Text17Visible;
                Text18Visible := (ColumnID = 18) or Text18Visible;
                Text19Visible := (ColumnID = 19) or Text19Visible;
                Text20Visible := (ColumnID = 20) or Text20Visible;
                Text21Visible := (ColumnID = 21) or Text21Visible;
                Text22Visible := (ColumnID = 22) or Text22Visible;
                Text23Visible := (ColumnID = 23) or Text23Visible;
                Text24Visible := (ColumnID = 24) or Text24Visible;
                Text25Visible := (ColumnID = 25) or Text25Visible;
                Text26Visible := (ColumnID = 26) or Text26Visible;
                Text27Visible := (ColumnID = 27) or Text27Visible;
                Text28Visible := (ColumnID = 28) or Text28Visible;
                Text29Visible := (ColumnID = 29) or Text29Visible;
                Text30Visible := (ColumnID = 30) or Text30Visible;
        end;
    end;

    local procedure ResetFieldsVisibility()
    begin
        Integer1Visible := false;
        Integer2Visible := false;
        Integer3Visible := false;
        Integer4Visible := false;
        Integer5Visible := false;
        Integer6Visible := false;
        Integer7Visible := false;
        Integer8Visible := false;
        Integer9Visible := false;
        Integer10Visible := false;
        Integer11Visible := false;
        Integer12Visible := false;
        Integer13Visible := false;
        Integer14Visible := false;
        Integer15Visible := false;
        Integer16Visible := false;
        Integer17Visible := false;
        Integer18Visible := false;
        Integer19Visible := false;
        Integer20Visible := false;
        Integer21Visible := false;
        Integer22Visible := false;
        Integer23Visible := false;
        Integer24Visible := false;
        Integer25Visible := false;
        Integer26Visible := false;
        Integer27Visible := false;
        Integer28Visible := false;
        Integer29Visible := false;
        Integer30Visible := false;
        Decimal1Visible := false;
        Decimal2Visible := false;
        Decimal3Visible := false;
        Decimal4Visible := false;
        Decimal5Visible := false;
        Decimal6Visible := false;
        Decimal7Visible := false;
        Decimal8Visible := false;
        Decimal9Visible := false;
        Decimal10Visible := false;
        Decimal11Visible := false;
        Decimal12Visible := false;
        Decimal13Visible := false;
        Decimal14Visible := false;
        Decimal15Visible := false;
        Decimal16Visible := false;
        Decimal17Visible := false;
        Decimal18Visible := false;
        Decimal19Visible := false;
        Decimal20Visible := false;
        Decimal21Visible := false;
        Decimal22Visible := false;
        Decimal23Visible := false;
        Decimal24Visible := false;
        Decimal25Visible := false;
        Decimal26Visible := false;
        Decimal27Visible := false;
        Decimal28Visible := false;
        Decimal29Visible := false;
        Decimal30Visible := false;
        Code1Visible := false;
        Code2Visible := false;
        Code3Visible := false;
        Code4Visible := false;
        Code5Visible := false;
        Code6Visible := false;
        Code7Visible := false;
        Code8Visible := false;
        Code9Visible := false;
        Code10Visible := false;
        Code11Visible := false;
        Code12Visible := false;
        Code13Visible := false;
        Code14Visible := false;
        Code15Visible := false;
        Code16Visible := false;
        Code17Visible := false;
        Code18Visible := false;
        Code19Visible := false;
        Code20Visible := false;
        Code21Visible := false;
        Code22Visible := false;
        Code23Visible := false;
        Code24Visible := false;
        Code25Visible := false;
        Code26Visible := false;
        Code27Visible := false;
        Code28Visible := false;
        Code29Visible := false;
        Code30Visible := false;
        Text1Visible := false;
        Text2Visible := false;
        Text3Visible := false;
        Text4Visible := false;
        Text5Visible := false;
        Text6Visible := false;
        Text7Visible := false;
        Text8Visible := false;
        Text9Visible := false;
        Text10Visible := false;
        Text11Visible := false;
        Text12Visible := false;
        Text13Visible := false;
        Text14Visible := false;
        Text15Visible := false;
        Text16Visible := false;
        Text17Visible := false;
        Text18Visible := false;
        Text19Visible := false;
        Text20Visible := false;
        Text21Visible := false;
        Text22Visible := false;
        Text23Visible := false;
        Text24Visible := false;
        Text25Visible := false;
        Text26Visible := false;
        Text27Visible := false;
        Text28Visible := false;
        Text29Visible := false;
        Text30Visible := false;
        Date1Visible := false;
        Date2Visible := false;
        Date3Visible := false;
        Date4Visible := false;
        Date5Visible := false;
        Date6Visible := false;
        Date7Visible := false;
        Date8Visible := false;
        Date9Visible := false;
        Date10Visible := false;
        Date11Visible := false;
        Date12Visible := false;
        Date13Visible := false;
        Date14Visible := false;
        Date15Visible := false;
        Date16Visible := false;
        Date17Visible := false;
        Date18Visible := false;
        Date19Visible := false;
        Date20Visible := false;
        Date21Visible := false;
        Date22Visible := false;
        Date23Visible := false;
        Date24Visible := false;
        Date25Visible := false;
        Date26Visible := false;
        Date27Visible := false;
        Date28Visible := false;
        Date29Visible := false;
        Date30Visible := false;
        DateTime1Visible := false;
        DateTime2Visible := false;
        DateTime3Visible := false;
        DateTime4Visible := false;
        DateTime5Visible := false;
        DateTime6Visible := false;
        DateTime7Visible := false;
        DateTime8Visible := false;
        DateTime9Visible := false;
        DateTime10Visible := false;
        DateTime11Visible := false;
        DateTime12Visible := false;
        DateTime13Visible := false;
        DateTime14Visible := false;
        DateTime15Visible := false;
        DateTime16Visible := false;
        DateTime17Visible := false;
        DateTime18Visible := false;
        DateTime19Visible := false;
        DateTime20Visible := false;
        DateTime21Visible := false;
        DateTime22Visible := false;
        DateTime23Visible := false;
        DateTime24Visible := false;
        DateTime25Visible := false;
        DateTime26Visible := false;
        DateTime27Visible := false;
        DateTime28Visible := false;
        DateTime29Visible := false;
        DateTime30Visible := false;
        Time1Visible := false;
        Time2Visible := false;
        Time3Visible := false;
        Time4Visible := false;
        Time5Visible := false;
        Time6Visible := false;
        Time7Visible := false;
        Time8Visible := false;
        Time9Visible := false;
        Time10Visible := false;
        Time11Visible := false;
        Time12Visible := false;
        Time13Visible := false;
        Time14Visible := false;
        Time15Visible := false;
        Time16Visible := false;
        Time17Visible := false;
        Time18Visible := false;
        Time19Visible := false;
        Time20Visible := false;
        Time21Visible := false;
        Time22Visible := false;
        Time23Visible := false;
        Time24Visible := false;
        Time25Visible := false;
        Time26Visible := false;
        Time27Visible := false;
        Time28Visible := false;
        Time29Visible := false;
        Time30Visible := false;
        Boolean1Visible := false;
        Boolean2Visible := false;
        Boolean3Visible := false;
        Boolean4Visible := false;
        Boolean5Visible := false;
        Boolean6Visible := false;
        Boolean7Visible := false;
        Boolean8Visible := false;
        Boolean9Visible := false;
        Boolean10Visible := false;
        Boolean11Visible := false;
        Boolean12Visible := false;
        Boolean13Visible := false;
        Boolean14Visible := false;
        Boolean15Visible := false;
        Boolean16Visible := false;
        Boolean17Visible := false;
        Boolean18Visible := false;
        Boolean19Visible := false;
        Boolean20Visible := false;
        Boolean21Visible := false;
        Boolean22Visible := false;
        Boolean23Visible := false;
        Boolean24Visible := false;
        Boolean25Visible := false;
        Boolean26Visible := false;
        Boolean27Visible := false;
        Boolean28Visible := false;
        Boolean29Visible := false;
        Boolean30Visible := false;
    end;

    local procedure ClearFields();
    begin
        Clear(CodeFields);
        Clear(TextFields);
        Clear(IntegerFields);
        Clear(DecimalFields);
        Clear(DateFields);
        Clear(DateTimeFields);
        Clear(TimeFields);
        Clear(BooleanFields);
    end;

    local procedure LookupField(ColumnID: Integer)
    var
        MediaViewer: Page "Media Viewer";
        FieldRef: FieldRef;
    begin
        FieldRef := RecordRef.FieldIndex(ColumnID + Offset);
        if FieldRef.Type = FieldType::Option then begin
            LookupOptions(ColumnID);
            exit;
        end;
        if FieldRef.Relation <> 0 then begin
            LookupTableRelation(ColumnID);
            exit;
        end;
        if FieldRef.Type = FieldType::RecordId then begin
            LookupRecordId(ColumnID);
            exit;
        end;
        if FieldRef.Type in [FieldType::Blob, FieldType::Media, FieldType::MediaSet] then begin
            MediaViewer.Set(FieldRef);
            MediaViewer.RunModal();
        end;
    end;

    local procedure LookupOptions(ColumnID: Integer)
    var
        TempOptionLookupBuffer: Record "Option Lookup Buffer" temporary;
        RecordRefLocal: RecordRef;
        FieldRef: FieldRef;
        CurrOption: Text[30];
        OptionIndex: Integer;
    begin
        RecordRefLocal := RecordRef.Duplicate();
        FieldRef := RecordRefLocal.FieldIndex(ColumnID + Offset);
        if FieldRef.Type = FieldType::Option then begin
            CurrOption := Format(FieldRef.Value);
            for OptionIndex := 1 to FieldRef.EnumValueCount() do begin
                FieldRef.Value(FieldRef.GetEnumValueOrdinal(OptionIndex));
                TempOptionLookupBuffer.Init();
                TempOptionLookupBuffer.ID := FieldRef.Value;
                TempOptionLookupBuffer."Option Caption" := Format(FieldRef.Value);
                TempOptionLookupBuffer.Insert();
            end;
            TempOptionLookupBuffer."Option Caption" := CurrOption;
            TempOptionLookupBuffer.SetCurrentKey(ID);
            if Page.RunModal(0, TempOptionLookupBuffer) = Action::LookupOK then begin
                TextFields[ColumnID] := TempOptionLookupBuffer."Option Caption";
                ValidateField(ColumnID);
            end;
        end;
    end;

    local procedure LookupTableRelation(ColumnID: Integer)
    var
        TableRelationsMetadata: Record "Table Relations Metadata";
        RelationRecordRef: RecordRef;
        FieldRef: FieldRef;
        RelationFieldRef: FieldRef;
        RecordRefVariant: Variant;
    begin
        FieldRef := RecordRef.FieldIndex(ColumnID + Offset);
        if FieldRef.Relation <> 0 then begin
            TableRelationsMetadata.SetRange("Table ID", RecordRef.Number);
            TableRelationsMetadata.SetRange("Field No.", FieldRef.Number);
            TableRelationsMetadata.SetRange("Related Table ID", FieldRef.Relation);
            TableRelationsMetadata.FindFirst();
            RelationRecordRef.Open(FieldRef.Relation);
            RelationFieldRef := RelationRecordRef.Field(TableRelationsMetadata."Related Field No.");
            RelationFieldRef.Value := FieldRef.Value;
            RecordRefVariant := RelationRecordRef;
            if Page.RunModal(0, RecordRefVariant) = Action::LookupOK then begin
                RelationRecordRef := RecordRefVariant;
                SetFieldData(ColumnID, RelationFieldRef);
                ValidateField(ColumnID);
            end;
        end;
    end;

    local procedure LookupRecordId(ColumnID: Integer)
    var
        TableEditor: Page "Table Editor";
        FieldRef: FieldRef;
        RecId: RecordId;
    begin
        FieldRef := RecordRef.FieldIndex(ColumnID + Offset);
        if FieldRef.Type = FieldType::RecordId then begin
            RecId := FieldRef.Value;
            if RecId.TableNo <> 0 then
                TableEditor.SetRecordForPage(RecId);
            TableEditor.LookupMode(true);
            if TableEditor.RunModal() = Action::LookupOK then begin
                FieldRef.Value := TableEditor.GetSelectedRecordId();
                SetFieldData(ColumnID, FieldRef);
                ValidateField(ColumnID);
            end;
        end;
    end;

    local procedure LoadColumns()
    var
        FieldRef: FieldRef;
        i: Integer;
    begin
        ResetFieldsVisibility();
        NoOfFieldsMinusMaxColumns := RecordRef.FieldCount - 30;
        Columns := 30;
        if NoOfFieldsMinusMaxColumns < Offset then
            Columns := RecordRef.FieldCount - Offset;

        for i := 1 to Columns do begin
            FieldRef := RecordRef.FieldIndex(i + Offset);
            SetFieldsVisibility(i, FieldRef.Type);
            if ShowCaptions then
                ColumnCaptions[i] := FieldRef.Caption
            else
                ColumnCaptions[i] := FieldRef.Name;
        end;
    end;

    local procedure UpdateFieldsData()
    var
        FieldRef: FieldRef;
        i: Integer;
    begin
        for i := 1 to Columns do begin
            FieldRef := RecordRef.FieldIndex(i + Offset);
            SetFieldData(i, FieldRef);
        end;
    end;

    local procedure SetFieldData(ColumnID: Integer; FieldRef: FieldRef)
    begin
        if FieldRef.Class = FieldClass::FlowField then
            FieldRef.CalcField();
        case FieldRef.Type of
            FieldType::Integer, FieldType::BigInteger:
                IntegerFields[ColumnID] := FieldRef.Value;
            FieldType::Decimal:
                DecimalFields[ColumnID] := FieldRef.Value;
            FieldType::Code:
                CodeFields[ColumnID] := FieldRef.Value;
            FieldType::Text:
                TextFields[ColumnID] := FieldRef.Value;
            FieldType::Date:
                DateFields[ColumnID] := FieldRef.Value;
            FieldType::DateTime:
                DateTimeFields[ColumnID] := FieldRef.Value;
            FieldType::Time:
                TimeFields[ColumnID] := FieldRef.Value;
            FieldType::Boolean:
                BooleanFields[ColumnID] := FieldRef.Value;
            else
                TextFields[ColumnID] := Format(FieldRef.Value);
        end;
    end;

    local procedure InitRecordRef()
    var
        EmptyRecordRef: RecordRef;
        i: Integer;
    begin
        EmptyRecordRef.Open(RecordRef.Number);
        for i := 1 to RecordRef.KeyIndex(1).FieldCount do
            RecordRef.KeyIndex(1).FieldIndex(i).Value := EmptyRecordRef.KeyIndex(1).FieldIndex(i).Value;
        RecordRef.Init();
    end;

    local procedure InsertRec(RecID: RecordId)
    begin
        Rec.Init();
        Rec."Record-Id" := RecID;
        if Rec.Insert() then;
    end;

    local procedure ValidateField(ColumnID: Integer)
    var
        FieldRef: FieldRef;
    begin
        FieldRef := RecordRef.FieldIndex(ColumnID + Offset);
        if RunValidateTrigger then
            ValidateFieldValue(FieldRef, ColumnID)
        else
            AssignFieldValue(FieldRef, ColumnID);
        if ConfigValidateManagement.IsKeyField(RecordRef.Number, FieldRef.Number) then
            RenameRequired := true
        else
            ModifyRequired := true;
        Rec."Modified-Id" := CreateGuid();
        CurrentValue := Format(FieldRef.Value);
        LastModifiedColumnID := ColumnID;
        LastModifiedRecordId := Rec."Record-Id";
        UpdateFieldsData();
    end;

    local procedure ValidateFieldValue(var FieldRef: FieldRef; ColumnID: Integer)
    begin
        case FieldRef.Type of
            FieldType::Integer, FieldType::BigInteger:
                FieldRef.Validate(IntegerFields[ColumnID]);
            FieldType::Decimal:
                FieldRef.Validate(DecimalFields[ColumnID]);
            FieldType::Code:
                FieldRef.Validate(CodeFields[ColumnID]);
            FieldType::Text:
                FieldRef.Validate(TextFields[ColumnID]);
            FieldType::Date:
                FieldRef.Validate(DateFields[ColumnID]);
            FieldType::DateTime:
                FieldRef.Validate(DateTimeFields[ColumnID]);
            FieldType::Time:
                FieldRef.Validate(TimeFields[ColumnID]);
            FieldType::Boolean:
                FieldRef.Validate(BooleanFields[ColumnID]);
            else
                ConfigValidateManagement.EvaluateValueWithValidate(FieldRef, TextFields[ColumnID], false);
        end;
    end;

    local procedure AssignFieldValue(var FieldRef: FieldRef; ColumnID: Integer)
    begin
        case FieldRef.Type of
            FieldType::Integer, FieldType::BigInteger:
                FieldRef.Value := IntegerFields[ColumnID];
            FieldType::Decimal:
                FieldRef.Value := DecimalFields[ColumnID];
            FieldType::Code:
                FieldRef.Value := CodeFields[ColumnID];
            FieldType::Text:
                FieldRef.Value := TextFields[ColumnID];
            FieldType::Date:
                FieldRef.Value := DateFields[ColumnID];
            FieldType::DateTime:
                FieldRef.Value := DateTimeFields[ColumnID];
            FieldType::Time:
                FieldRef.Value := TimeFields[ColumnID];
            FieldType::Boolean:
                FieldRef.Value := BooleanFields[ColumnID];
            else
                ConfigValidateManagement.EvaluateValue(FieldRef, TextFields[ColumnID], false);
        end;
    end;

    local procedure SetFiltersOnRecordRef()
    var
        FilterPage: FilterPageBuilder;
        FilterView: Text;
    begin
        FilterPage.AddTable(RecordRef.Caption(), RecordRef.Number());
        FilterPage.SetView(RecordRef.Caption(), RecordRef.GetView());
        FilterPage.PageCaption(RecordRef.Caption() + ' Filter');
        FilterPage.RunModal();
        FilterView := FilterPage.GetView(RecordRef.Caption(), false);
        RecordRef.SetView(FilterView);
    end;

    local procedure SetFieldsFilter(var Field: Record Field)
    begin
        Field.SetRange(TableNo, TableNo);
        Field.SetFilter("No.", '<2000000000');
        Field.SetRange(Enabled, true);
        Field.SetFilter(ObsoleteState, '<>%1', Field.ObsoleteState::Removed);
    end;

    local procedure RenameRecord()
    var
        xRecordRef: RecordRef;
        Index: Integer;
        KeyValue: array[16] of Variant;
    begin
        xRecordRef.Get(Rec."Record-Id");
        for Index := 1 to RecordRef.KeyIndex(1).FieldCount do begin
            KeyValue[Index] := RecordRef.KeyIndex(1).FieldIndex(Index).Value;
            RecordRef.KeyIndex(1).FieldIndex(Index).Value := xRecordRef.KeyIndex(1).FieldIndex(Index).Value;
        end;

        if not Confirm(ConfirmRenameQst, true) then
            exit;

        case Index of
            1:
                RecordRef.Rename(KeyValue[1]);
            2:
                RecordRef.Rename(KeyValue[1], KeyValue[2]);
            3:
                RecordRef.Rename(KeyValue[1], KeyValue[2], KeyValue[3]);
            4:
                RecordRef.Rename(KeyValue[1], KeyValue[2], KeyValue[3], KeyValue[4]);
            5:
                RecordRef.Rename(KeyValue[1], KeyValue[2], KeyValue[3], KeyValue[4], KeyValue[5]);
            6:
                RecordRef.Rename(KeyValue[1], KeyValue[2], KeyValue[3], KeyValue[4], KeyValue[5], KeyValue[6]);
            7:
                RecordRef.Rename(KeyValue[1], KeyValue[2], KeyValue[3], KeyValue[4], KeyValue[5], KeyValue[6], KeyValue[7]);
            8:
                RecordRef.Rename(KeyValue[1], KeyValue[2], KeyValue[3], KeyValue[4], KeyValue[5], KeyValue[6], KeyValue[7], KeyValue[8]);
            9:
                RecordRef.Rename(KeyValue[1], KeyValue[2], KeyValue[3], KeyValue[4], KeyValue[5], KeyValue[6], KeyValue[7], KeyValue[8], KeyValue[9]);
            10:
                RecordRef.Rename(KeyValue[1], KeyValue[2], KeyValue[3], KeyValue[4], KeyValue[5], KeyValue[6], KeyValue[7], KeyValue[8], KeyValue[9], KeyValue[10]);
            11:
                RecordRef.Rename(KeyValue[1], KeyValue[2], KeyValue[3], KeyValue[4], KeyValue[5], KeyValue[6], KeyValue[7], KeyValue[8], KeyValue[9], KeyValue[10], KeyValue[11]);
            12:
                RecordRef.Rename(KeyValue[1], KeyValue[2], KeyValue[3], KeyValue[4], KeyValue[5], KeyValue[6], KeyValue[7], KeyValue[8], KeyValue[9], KeyValue[10], KeyValue[11], KeyValue[12]);
            13:
                RecordRef.Rename(KeyValue[1], KeyValue[2], KeyValue[3], KeyValue[4], KeyValue[5], KeyValue[6], KeyValue[7], KeyValue[8], KeyValue[9], KeyValue[10], KeyValue[11], KeyValue[12], KeyValue[13]);
            14:
                RecordRef.Rename(KeyValue[1], KeyValue[2], KeyValue[3], KeyValue[4], KeyValue[5], KeyValue[6], KeyValue[7], KeyValue[8], KeyValue[9], KeyValue[10], KeyValue[11], KeyValue[12], KeyValue[13], KeyValue[14]);
            15:
                RecordRef.Rename(KeyValue[1], KeyValue[2], KeyValue[3], KeyValue[4], KeyValue[5], KeyValue[6], KeyValue[7], KeyValue[8], KeyValue[9], KeyValue[10], KeyValue[11], KeyValue[12], KeyValue[13], KeyValue[14], KeyValue[15]);
            16:
                RecordRef.Rename(KeyValue[1], KeyValue[2], KeyValue[3], KeyValue[4], KeyValue[5], KeyValue[6], KeyValue[7], KeyValue[8], KeyValue[9], KeyValue[10], KeyValue[11], KeyValue[12], KeyValue[13], KeyValue[14], KeyValue[15], KeyValue[16]);
        end;
        Rec.Rename(RecordRef.RecordId);
    end;

    local procedure ExportToExcel()
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        RecordRefLocal: RecordRef;
        FieldRef: FieldRef;
        i: Integer;
    begin
        RecordRefLocal := RecordRef.Duplicate();
        for i := 1 to RecordRefLocal.FieldCount() do begin
            FieldRef := RecordRefLocal.FieldIndex(i);
            TempExcelBuffer.AddColumn(FieldRef.Caption, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        end;
        if RecordRefLocal.FindSet() then
            repeat
                TempExcelBuffer.NewRow();
                for i := 1 to RecordRefLocal.FieldCount() do begin
                    FieldRef := RecordRefLocal.FieldIndex(i);
                    if FieldRef.Class = FieldClass::FlowField then
                        FieldRef.CalcField();
                    case FieldRef.Type of
                        FieldType::Integer, FieldType::BigInteger, FieldType::Decimal:
                            TempExcelBuffer."Cell Type" := TempExcelBuffer."Cell Type"::Number;
                        FieldType::Date:
                            TempExcelBuffer."Cell Type" := TempExcelBuffer."Cell Type"::Date;
                        FieldType::Time:
                            TempExcelBuffer."Cell Type" := TempExcelBuffer."Cell Type"::Time;
                        else
                            TempExcelBuffer."Cell Type" := TempExcelBuffer."Cell Type"::Text;
                    end;
                    TempExcelBuffer.AddColumn(CopyStr(Format(FieldRef.Value), 1, MaxStrLen(TempExcelBuffer."Cell Value as Text")), false, '', false, false, false, '', TempExcelBuffer."Cell Type");
                end;
            until RecordRefLocal.Next() = 0;
        TempExcelBuffer.CreateNewBook(CopyStr(RecordRef.Caption, 1, 250));
        TempExcelBuffer.WriteSheet('', CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename(RecordRef.Caption);
        TempExcelBuffer.OpenExcel();
    end;

    procedure SetRecordForPage(NewRecord: Variant)
    var
        DataTypeManagement: Codeunit "Data Type Management";
    begin
        if not DataTypeManagement.GetRecordRef(NewRecord, RecordRef) then
            Error(InvalidVariableErr, Format(NewRecord));
        TableNo := RecordRef.Number;
    end;

    procedure GetSelectedRecordId(): RecordId
    begin
        exit(RecordRef.RecordId);
    end;

    local procedure SetIsTempRec(IsTempRec: Boolean)
    begin
        IsTemporaryText := '';
        if IsTempRec then
            IsTemporaryText := TemporarySourceTableLbl;
    end;

    local procedure CheckPermission()
    var
        UserPermissions: Codeunit "User Permissions";
    begin
        if not UserPermissions.IsSuper(UserSecurityId()) then
            Error(AccessDeniedErr);
    end;
}
