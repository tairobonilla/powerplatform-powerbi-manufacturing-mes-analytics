# 🏭 Shop-Floor Manufacturing Execution & Shift Reporting System (Power Platform)

![Platform](https://img.shields.io/badge/Platform-Microsoft_Power_Platform-742774?style=for-the-badge&logo=powerapps)
![Power Automate](https://img.shields.io/badge/Middleware-Power_Automate-0066FF?style=for-the-badge&logo=powerautomate)
![SharePoint](https://img.shields.io/badge/Backend-SharePoint_Online-0078D4?style=for-the-badge&logo=microsoftsharepoint)
![License](https://img.shields.io/badge/Licensing-Standard_M365_Seeded-success?style=for-the-badge)

> **Disclaimer:** *This repository documents an anonymized architectural blueprint and design patterns developed for a high-volume food manufacturing facility. All proprietary business names, internal URLs, tenant GUIDs, and specific product SKUs have been abstracted for confidentiality.*

---

## 📌 Executive Summary
In traditional manufacturing environments, capturing shop-floor operational metrics (Production Outputs, Material Scrap/Losses, Line Downtime, and Recipe Process Parameters) on paper logs and disparate Excel spreadsheets leads to data tampering, version conflicts, and delayed KPI visibility (40–60 minutes lost per shift handover).

This solution provides a **digitized, immutable, and real-time Shift Reporting System** built entirely within standard **Microsoft 365 seeded licensing** (zero premium Dataverse licensing costs), serving ~50 concurrent plant supervisors, process engineers, and operations managers.

---

## 🏗️ Architectural Highlights & Design Patterns

### 1. Decoupled "Proxy" Security Architecture (Zero-Trust Client)
Because SharePoint Online does not natively support record-level write-only security without giving users direct list edit access via browser URLs, a **Service Account Proxy Pattern** was implemented:
* **Read-Only Client:** Shop-floor supervisors belong to an Active Directory group with strictly **Read-Only** permissions on the SharePoint site.
* **Elevated Middleware:** Power Apps never uses direct `Patch()` or `SubmitForm()` commands. Instead, data is validated locally, serialized into a JSON payload, and sent to **Power Automate V2 Instant Flows** running under a dedicated Service Account (`Run-Only` elevated credentials).

```mermaid
graph LR
    A[👨‍🏭 Plant Supervisor<br/>Power Apps Tablet] -->|1. Read-Only Lookups<br/>App.Formulas Cache| B[(SharePoint Online<br/>Master Lists)]
    A -->|2. Serialized JSON Payload<br/>+ Base64 Media| C{Power Automate<br/>V2 Proxy Flows}
    C -->|3. Elevated Write<br/>20 Parallel Threads| D[(SharePoint Online<br/>5 Transaction Lists)]
    C -->|4. Responsive HTML Card| E[📧 Office 365 Outlook<br/>Area Leads & MTTO]
    C -->|5. Audited Status<br/>exito = True| A
