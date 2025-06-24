page 55997 "Sorting Order"
{
    ApplicationArea = All;
    Caption = 'Sorting Order';
    PageType = List;
    Editable = false;
    SourceTable = "Field";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            field(Sorting; GetSortingText())
            {
                ApplicationArea = All;
                MultiLine = true;
                Caption = 'Sorting';
            }
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                }
                field(FieldName; Rec.FieldName)
                {
                }
                field("Field Caption"; Rec."Field Caption")
                {
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RemoveField)
            {
                ApplicationArea = All;
                Caption = 'Remove Field';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    SortingFields.Remove(Rec."Field Caption");
                end;
            }
            action(Ascending)
            {
                ApplicationArea = All;
                Caption = 'Ascending';
                Image = SortAscending;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    SortingFields.Set(Rec."Field Caption", 'Ascending');
                end;
            }
            action(Descending)
            {
                ApplicationArea = All;
                Caption = 'Descending';
                Image = SortDescending;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    SortingFields.Set(Rec."Field Caption", 'Descending');
                end;
            }
        }
    }

    var
        SortingFields: Dictionary of [Text, Text];

    procedure GetSortingText(): Text
    var
        FieldsString: TextBuilder;
        OrderString: TextBuilder;
        Field: Text;
        Separator: Text;
    begin
        foreach Field in SortingFields.Keys() do begin
            if Field.Contains(',') then
                FieldsString.Append(Separator + '"' + Field + '"')
            else
                FieldsString.Append(Separator + Field);
            OrderString.Append(Separator + SortingFields.Get(Field));
            Separator := ',';
        end;
        if FieldsString.Length() > 0 then
            exit('SORTING(' + FieldsString.ToText() + ') ORDER(' + OrderString.ToText() + ')');
        exit('');
    end;
}
