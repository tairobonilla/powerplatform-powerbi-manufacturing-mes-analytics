// =========================================================================
// PATTERN: 4-Step Audited JSON Submission & State Retention
// PURPOSE: Avoids direct Patch() calls. Packages records locally, invokes 
//          elevated Power Automate proxy flow, and preserves UI inputs on error.
// =========================================================================

// STEP 1: Flush local temporary collection to prevent data bleed
Clear(colRecordsToReport);;

// STEP 2: Package validated form inputs with ISO-8601 date formatting
Collect(
    colRecordsToReport;
    {
        SupervisorMail: varUserProfile.mail;
        SupervisorName: varUserProfile.displayName;
        Fecha: Text(dpShiftDate.SelectedDate; "yyyy-mm-dd");
        Turno: ddShift.Selected.Value;
        Linea: ddLine.Selected.Value;
        Variedad: ddVariety.Selected.Value;
        Presentacion: ddPresentation.Selected.Value;
        Factor: "NAF";
        Masas: Value(txtDoughKg.Text);
        Cremas: Value(txtCreamKg.Text);
        CajasEmpacadas: Value(txtPackedBoxes.Text);
        KGProducidos: Value(txtProducedKg.Text);
        YIELD: Round(varCalculatedYield; 2);
        GE: Round(varCalculatedGE; 2);
        Comentarios: txtComments.Text
    }
);;

// STEP 3: Serialize collection to JSON and call Run-Only Proxy Flow
Set(
    varFlowResponse;
    'GuardarReporteProduccion-Proxy'.Run(
        JSON(colRecordsToReport; JSONFormat.IncludeBinaryData)
    )
);;

// STEP 4: Audited verification before clearing form (State Retention)
If(
    varFlowResponse.exito = "True";
    Notify("Shift report saved successfully."; NotificationType.Success);;
    ResetForm(frmProduction);;
    Clear(colRecordsToReport);
    // On network dropout or flow failure, bypass ResetForm() to prevent data loss
    Notify("Submission failed: " & varFlowResponse.error; NotificationType.Error)
);;
