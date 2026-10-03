/// Domain enums shared across layers (UI imports without Drift dependency).
enum NodeType { mainTab, subTab, section, project }

enum NodeTemplate { client, personal, subscription, quickNote, custom }

enum NodeStatus { active, archived }

enum LinkCategory { repository, dashboard, website, store, other }

enum BillingCycle { monthly, yearly, lifetime, custom }

enum SubStatus { active, cancelled, expired }

enum ImportStrategy { replace, merge }

enum TrialStatus { active, expired }

enum PurchaseState { unknown, purchased, notPurchased, pending }
