table 55999 "Table Editor"
{
    Caption = 'Table Editor';
    TableType = Temporary;
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Record-Id"; RecordId)
        {
            Caption = 'Record-Id';
            DataClassification = SystemMetadata;
        }
        field(2; "Modified-Id"; Guid)
        {
            Caption = 'Modified-Id';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(PK; "Record-Id")
        {
            Clustered = true;
        }
    }
}
