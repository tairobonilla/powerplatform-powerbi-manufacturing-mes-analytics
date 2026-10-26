// =========================================================================
// PATTERN: Composite Line 06 Automatic Volume Splitting
// PURPOSE: Automatically splits a single common-dough shift entry into 4 
//          proportional packaging line records (10%, 25%, 25%, 40%) prior to dispatch.
// =========================================================================

Clear(colRecordsToReport);;

If(
    ddLine.Selected.Value = "Linea 06";
    // --- COMPOSITE LINE 06: 4-WAY PROPORTIONAL SPLIT ---
    Collect(
        colRecordsToReport;
        // 1. Sub-Line PT1 (10% Allocation)
        {
            Fecha: Text(dpShiftDate.SelectedDate; "yyyy-mm-dd");
            Turno: ddShift.Selected.Value;
            Linea: "Linea 06";
            Factor: "PT1";
            Variedad: ddVariety_PT1.Selected.Value;
            Presentacion: ddPres_PT1.Selected.Value;
            Masas: Round(Value(txtTotalDoughKg.Text) * 0.10; 2);
            KGaProducir: Round(Value(txtTotalTargetKg.Text) * 0.10; 2);
            CajasEmpacadas: Value(txtBoxes_PT1.Text)
        };
        // 2. Sub-Line PT2-1 (25% Allocation)
        {
            Fecha: Text(dpShiftDate.SelectedDate; "yyyy-mm-dd");
            Turno: ddShift.Selected.Value;
            Linea: "Linea 06";
            Factor: "PT2-1";
            Variedad: ddVariety_PT2_1.Selected.Value;
            Presentacion: ddPres_PT2_1.Selected.Value;
            Masas: Round(Value(txtTotalDoughKg.Text) * 0.25; 2);
            KGaProducir: Round(Value(txtTotalTargetKg.Text) * 0.25; 2);
            CajasEmpacadas: Value(txtBoxes_PT2_1.Text)
        };
        // 3. Sub-Line PT2-2 (25% Allocation)
        {
            Fecha: Text(dpShiftDate.SelectedDate; "yyyy-mm-dd");
            Turno: ddShift.Selected.Value;
            Linea: "Linea 06";
            Factor: "PT2-2";
            Variedad: ddVariety_PT2_2.Selected.Value;
            Presentacion: ddPres_PT2_2.Selected.Value;
            Masas: Round(Value(txtTotalDoughKg.Text) * 0.25; 2);
            KGaProducir: Round(Value(txtTotalTargetKg.Text) * 0.25; 2);
            CajasEmpacadas: Value(txtBoxes_PT2_2.Text)
        };
        // 4. Sub-Line PT3 (40% Allocation)
        {
            Fecha: Text(dpShiftDate.SelectedDate; "yyyy-mm-dd");
            Turno: ddShift.Selected.Value;
            Linea: "Linea 06";
            Factor: "PT3";
            Variedad: ddVariety_PT3.Selected.Value;
            Presentacion: ddPres_PT3.Selected.Value;
            Masas: Round(Value(txtTotalDoughKg.Text) * 0.40; 2);
            KGaProducir: Round(Value(txtTotalTargetKg.Text) * 0.40; 2);
            CajasEmpacadas: Value(txtBoxes_PT3.Text)
        }
    );
    // --- STANDARD SINGLE-FACTOR LINES (L02, L04, L09, L10) ---
    Collect(
        colRecordsToReport;
        {
            Fecha: Text(dpShiftDate.SelectedDate; "yyyy-mm-dd");
            Turno: ddShift.Selected.Value;
            Linea: ddLine.Selected.Value;
            Factor: "NAF";
            Variedad: ddVariety.Selected.Value;
            Presentacion: ddPresentation.Selected.Value;
            Masas: Value(txtTotalDoughKg.Text);
            KGaProducir: Value(txtTotalTargetKg.Text);
            CajasEmpacadas: Value(txtBoxes.Text)
        }
    )
);;
