# 📊 Visual Architecture & Operational Workflow Diagrams

This document contains the visual engineering diagrams for the **Shop-Floor Manufacturing Execution & Shift Reporting System**, rendered natively via Mermaid.js.

---

## 1. Legacy "As-Is" Process (Manual Paper & Unlinked Excel)
*Illustrates the legacy operational bottlenecks prior to digital transformation (40–60 minutes lost per shift handover and high risk of formula tampering).*

```mermaid
flowchart LR
    A([🟢 Shift Start]) --> B[📝 Manual logging on<br/>physical paper forms]
    B --> C[📂 Open local or shared<br/>Excel workbooks]
    C --> D[⌨️ Manual data re-typing:<br/>Production, Scrap, Downtime]
    D --> E[🧮 Manual calculation of<br/>mass balance, boxes & Yield]
    E --> F[📧 Email spreadsheet to<br/>shift leads & management]
    F --> G[⏳ Manual file consolidation<br/>& verification by leads]
    G --> H([🔴 Shift Handover Complete<br/>High risk of tampering & delays])

    style A fill:#2e5a27,stroke:#1b3817,color:#fff,stroke-width:2px
    style B fill:#f5cba7,stroke:#d35400,color:#333
    style C fill:#f5cba7,stroke:#d35400,color:#333
    style D fill:#f5cba7,stroke:#d35400,color:#333
    style E fill:#f5cba7,stroke:#d35400,color:#333
    style F fill:#f5cba7,stroke:#d35400,color:#333
    style G fill:#f5cba7,stroke:#d35400,color:#333
    style H fill:#7b241c,stroke:#4a120d,color:#fff,stroke-width:2px
```

---

## 2. "To-Be" End-to-End Proxy Architecture Diagram
*Illustrates the Zero-Trust Proxy Security Model where shop-floor tablets maintain strictly Read-Only permissions, delegating all elevated writes to high-concurrency Power Automate service account flows.*

```mermaid
flowchart LR
    User([👨‍🏭 Plant Supervisor / Tablet<br/>M365 SSO Authenticated])
    SPMaster[(📚 SharePoint Online<br/>7 Master & RBAC Lists<br/>Read-Only Lookups)]
    App[📱 Power Apps Canvas App<br/>16:9 Shop-Floor UI<br/>App.Formulas Cache]
    Flows[⚡ Power Automate Proxy Flows<br/>5 Tx Flows: 20 Parallel Threads<br/>3 OData Query Flows]
    SPTx[(🗄️ SharePoint Online<br/>5 Transactional Lists<br/>Elevated Service Account Writes)]
    Batch[⏱️ Scheduled Batch Flows<br/>Shift Closure Dispatchers<br/>06:30 / 14:30 / 22:30 UTC-4]
    Outlook([📧 Office 365 Outlook<br/>Responsive HTML Cards &<br/>24h Executive Summaries])

    User -->|Launches App| App
    SPMaster -.->|Direct Read-Only<br/>Session Cache| App
    App -->|Serialized JSON Payload<br/>+ Base64 Media| Flows
    Flows -->|Execution Status<br/>exito = True| App
    Flows -->|Elevated Write<br/>Run-Only Service Account| SPTx
    SPTx -->|OData Aggregation| Batch
    Flows -->|Real-Time Shift &<br/>Priority MTTO Alerts| Outlook
    Batch -->|Automated Shift-End<br/>Closure Tables| Outlook

    style User fill:#2e5a27,stroke:#1b3817,color:#fff,stroke-width:2px
    style SPMaster fill:#eaecee,stroke:#7f8c8d,color:#333,stroke-width:2px
    style App fill:#f5cba7,stroke:#e67e22,color:#333,stroke-width:2px
    style Flows fill:#a9cce3,stroke:#2980b9,color:#111,stroke-width:2px
    style SPTx fill:#eaecee,stroke:#7f8c8d,color:#333,stroke-width:2px
    style Batch fill:#d2b4de,stroke:#8e44ad,color:#111,stroke-width:2px
    style Outlook fill:#7b241c,stroke:#4a120d,color:#fff,stroke-width:2px
```

---

## 3. Shift Operational Lifecycle (4-Stage Shop-Floor Workflow)
*Outlines the step-by-step operational lifecycle executed during every 8-hour manufacturing shift.*

```mermaid
flowchart LR
    subgraph S1 [1. PRE-SHIFT / APP INIT]
        direction TB
        A1[• Supervisor logs in via<br/>corporate M365 SSO]
        A2[• Cross-checks Users_Plants<br/>RBAC Whitelist]
        A3[• Preloads Master Lists into<br/>memory & routes to Main Hub]
        A1 --> A2 --> A3
    end

    subgraph S2 [2. DURING-SHIFT OPERATIONS]
        direction TB
        B1[• Line Downtime: Logged across<br/>13 OEE categories in RPARA_Form]
        B2[• Material Scrap: Physical WIP &<br/>packaging waste in RPERD_Form]
        B3[• Process Control: Batch weights,<br/>silos, temp & rework in RPROC_Form]
        B1 --> B2 --> B3
    end

    subgraph S3 [3. SHIFT CLOSURE & HANDOVER]
        direction TB
        C1[• Production Output: Logged in<br/>RPROD_Form with Line 06<br/>auto-split: PT1, PT2-1, PT2-2, PT3]
        C2[• KPI Review: Master Plan vs.<br/>Actuals consulted in RINFO_Form]
        C3[• Audit Ticketing: Base64 photo<br/>evidence submitted in SPTCK_Form]
        C1 --> C2 --> C3
    end

    subgraph S4 [4. EXECUTIVE DISPATCH]
        direction TB
        D1[• Shift 1 Batch: 14:30 UTC-4<br/>HTML summary table dispatched]
        D2[• Shift 2 Batch: 22:30 UTC-4<br/>Evening KPIs & GE% dispatched]
        D3[• Shift 3 Batch: 06:30 UTC-4<br/>addDays -1 offset consolidates<br/>full 24-hour plant closure]
        D1 --> D2 --> D3
    end

    S1 ==> S2 ==> S3 ==> S4

    style S1 fill:#fdf2e9,stroke:#e67e22,stroke-width:2px,color:#333
    style S2 fill:#fdf2e9,stroke:#e67e22,stroke-width:2px,color:#333
    style S3 fill:#fdf2e9,stroke:#e67e22,stroke-width:2px,color:#333
    style S4 fill:#ebf5fb,stroke:#2980b9,stroke-width:2px,color:#333
```

---

## 4. Audited 4-Step Submission & Composite Split Sequence
*Technical sequence diagram detailing how the frontend handles Composite Line 06 splitting, Base64 conversion, and transactional state retention.*

```mermaid
sequenceDiagram
    autonumber
    actor Sup as 👨‍🏭 Plant Supervisor
    participant App as 📱 Power Apps (Client)
    participant Flow as ⚡ Power Automate Proxy
    participant SP as 🗄️ SharePoint Lists (Backend)
    participant Mail as 📧 O365 Outlook

    Sup->>App: Enters Shift Data & Clicks "Enviar Reporte"
    activate App
    App->>App: 1. Clear(colTemp)
    alt If Line 06 Selected (Composite Line)
        App->>App: 2a. Auto-Split Mass into 4 Records<br/>(10% PT1, 25% PT2-1, 25% PT2-2, 40% PT3)
    else Standard Line (L02, L04, L09, L10)
        App->>App: 2b. Package Single Record (Factor = NAF)
    end
    App->>Flow: 3. Invoke V2 Trigger with JSON(colTemp, IncludeBinaryData)
    activate Flow
    Flow->>Flow: Parse Polymorphic JSON Schema
    par 20 Concurrent Execution Threads (< 2 sec)
        Flow->>SP: Create Item(s) via Service Account (Run-Only)
    and Email Dispatch
        Flow->>Mail: Send Responsive HTML Summary Card
    end
    Flow-->>App: 4. Return Audited Status (exito = "True")
    deactivate Flow
    alt If exito = "True"
        App->>Sup: Display Green Banner & ResetForm()
    else Network Drop or Error
        App->>Sup: Display Error Banner & Retain Form Inputs on Screen
    end
    deactivate App
```
