page 55998 "Media Viewer"
{
    ApplicationArea = All;
    Caption = 'Media Viewer';
    PageType = CardPart;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
#pragma warning disable AW0009
            field(BlobField; TempCompanyInformation.Picture)
#pragma warning restore AW0009
            {
                Editable = false;
                ShowCaption = false;
                Visible = IsBLOB;
            }
            field(Encoding; Encoding)
            {
                Caption = 'Encoding';
                Visible = IsBLOB;

                trigger OnValidate()
                begin
                    if not TryReadTextFromBLOB() then
                        Error(GetLastErrorText);
                end;
            }
            field(BLOBText; BLOBText.ToText())
            {
                Editable = false;
                ShowCaption = false;
                MultiLine = true;
                Visible = IsBLOB;
            }
            field(MediaField; TempConfigMediaBuffer.Media)
            {
                Editable = false;
                ShowCaption = false;
                Visible = IsMedia;
            }
            field(MediaSetField; TempConfigMediaBuffer."Media Set")
            {
                Editable = false;
                ShowCaption = false;
                Visible = IsMediaSet;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(DownloadText)
            {
                Caption = 'Download Text';
                Image = Download;
                Enabled = IsBLOB;
                Visible = IsBLOB;
                InFooterBar = true;

                trigger OnAction()
                var
                    FileManagement: Codeunit "File Management";
                    Instream: InStream;
                begin
                    TempCompanyInformation.Picture.CreateInStream(Instream, GetTextEncoding());
                    FileManagement.DownloadFromStreamHandler(Instream, '', '', '', 'Blob.txt');
                end;
            }
        }
    }

    trigger OnInit()
    begin
        Encoding := Encoding::"UTF-8";
    end;

    var
        TempCompanyInformation: Record "Company Information" temporary;
        TempConfigMediaBuffer: Record "Config. Media Buffer" temporary;
        Encoding: Enum Encoding;
        BLOBText: TextBuilder;
        IsMedia: Boolean;
        IsMediaSet: Boolean;
        IsBLOB: Boolean;

    procedure Set(FieldRef: FieldRef)
    begin
        case FieldRef.Type of
            FieldType::Media:
                begin
                    TempConfigMediaBuffer.Media := FieldRef.Value;
                    IsMedia := true;
                end;
            FieldType::MediaSet:
                begin
                    TempConfigMediaBuffer."Media Set" := FieldRef.Value;
                    IsMediaSet := true;
                end;
            FieldType::Blob:
                begin
                    TempCompanyInformation.Picture := FieldRef.Value;
                    if not TempCompanyInformation.Picture.HasValue then begin
                        FieldRef.CalcField();
                        TempCompanyInformation.Picture := FieldRef.Value;
                    end;
                    if not TryReadTextFromBLOB() then
                        BLOBText.Clear();
                    IsBLOB := true;
                end;
        end;
    end;

    [TryFunction]
    local procedure TryReadTextFromBLOB()
    var
        InStream: InStream;
        Line: Text;
    begin
        BLOBText.Clear();
        TempCompanyInformation.Picture.CreateInStream(InStream, GetTextEncoding());
        while not InStream.EOS do begin
            InStream.ReadText(Line);
            BLOBText.AppendLine(Line);
        end;
    end;

    local procedure GetTextEncoding(): TextEncoding
    begin
        case Encoding of
            Encoding::"MS-DOS":
                exit(TextEncoding::MSDos);
            Encoding::"UTF-8":
                exit(TextEncoding::UTF8);
            Encoding::"UTF-16":
                exit(TextEncoding::UTF16);
            Encoding::WINDOWS:
                exit(TextEncoding::Windows);
        end;
    end;
}
