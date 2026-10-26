// =========================================================================
// PATTERN: Dynamic Base64 Binary Extraction for Read-Only SharePoint Users
// PURPOSE: Converts camera/gallery images in Power Apps into clean Base64 
//          strings (stripping data:image/...;base64, headers) for Power Automate.
// =========================================================================

// 1. Convert image control binary to full JSON Data URI string
Set(
    varRawJsonImage;
    JSON(imgAttachmentControl.Image; JSONFormat.IncludeBinaryData)
);;

// 2. Strip surrounding quotes and MIME prefix to isolate clean Base64 payload
Set(
    varCleanBase64;
    Mid(
        varRawJsonImage;
        Find(","; varRawJsonImage) + 1;
        Len(varRawJsonImage) - Find(","; varRawJsonImage) - 1
    )
);;

// 3. Package into support ticket collection for Power Automate base64ToBinary()
Collect(
    colTicketAttachments;
    {
        FileName: "Evidence_" & Text(Now(); "yyyymmdd_hhmmss") & ".jpg";
        ContentBytes: varCleanBase64
    }
);;
