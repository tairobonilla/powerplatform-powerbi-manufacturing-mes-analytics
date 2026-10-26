# 🔍 Server-Side OData Query & Overnight Shift Offset Logic

To bypass SharePoint's 5,000-item view threshold and avoid non-delegable client-side aggregations in Power Apps, all analytical views invoke specialized Power Automate query flows.

## 1. Indexed OData Filter Queries
SharePoint lists maintain compound indexes on `Fecha` (Text `yyyy-MM-dd`), `Turno`, and `Linea`.

### Shift Summary Query (`Query-RESUMEN` & `Query-CONSUMOS`)
```text
Fecha eq '@{triggerBody()['text']}' and Turno eq '@{triggerBody()['text_1']}'
```

### Weekly Master Production Plan Query (`Query-PLAN`)
```text
Semana eq '@{triggerBody()['text']}'
```

---

## 2. Overnight Shift (Turno 3) Date Offset Expression
Because **Shift 3 (`Turno 3`)** starts late at night and closes at `06:30 AM` the following calendar day, the scheduled executive dispatcher (`ResumenTurno3`) applies a `-1 day` UTC offset to query the operational date that just finished:

```powerautomate
formatDateTime(addDays(convertTimeZone(utcNow(), 'UTC', 'Venezuela Standard Time'), -1), 'yyyy-MM-dd')
```

---

## 3. High-Concurrency Loop Configuration
All transactional `Apply to each` actions in Power Automate are configured with:
* **Concurrency Control:** `On`
* **Degree of Parallelism:** `20`
* **Error Trapping:** Wrapped inside `Scope (Try)` and `Scope (Catch - Configure Run After: has failed, has timed out)`.
