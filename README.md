# NanoConnect -- SME & Nano Influencer Matching Platform

## 📄 Project Overview

**Concept:** _"Tinder for UMKM & Nano Influencers"_

NanoConnect is a platform designed to match **SMEs/UMKM** with **local
nano influencers** based on budget, niche, location, and target
audience.

The goal is to simplify collaboration between small businesses and
influencers by providing an intelligent matching system and an easy
booking workflow.

---

## 🎯 Business Requirements

### Core Features

- **Matching Algorithm**
  Budget-based, niche-specific, location-aware matching between SMEs
  and influencers.

- **Target Users**
  SMEs/UMKM and local nano influencers.

- **Low Latency**
  Real-time data processing using edge computing infrastructure.

---

# 🛠 Tech Stack & Infrastructure

## Frontend

- **Framework:** React.js + Vite
- **Deployment:** Tencent EdgeOne Pages
- **Development:** VS Code, EdgeOne CLI, IDE Plugin

---

## Tools

- **Code Editor:** VS Code
- **AI Assist:** Copilot
- **LLM Models:** GPT / Claude
- **Other:** EdgeOne CLI

---

## Backend & Storage

- **Database:** Supabase
- **Edge Storage:** KV Storage (Cache)
- **Serverless:** Node Functions for business logic
- **AI Integration:** OpenAI for smart matching

---

## Authentication

- **Auth Service:** Supabase Auth
- **Method:** Third-party login integration

---

## Deployments

EdgeOne Pages

---

# 🏗 Application Architecture

## Pages & Components

    ├── Homepage
    ├── About
    ├── Influencer Listing
    ├── Influencer Detail
    ├── Order / Booking System
    ├── AI Recommendations
    ├── Terms & Conditions
    └── Authentication Pages

---

## Data Models

**Influencer Profile** - Niche - Rates - Location - Portfolio

**SME Profile** - Budget - Target audience - Campaign requirements

**Matching Score** - AI-calculated compatibility rating between SME and
influencer

---

# 🤖 AI Matching System

NanoConnect uses AI to calculate compatibility between SMEs and
influencers based on:

- Budget compatibility
- Audience alignment
- Influencer niche
- Geographic proximity
- Campaign requirements

The system generates a **Matching Score** to recommend the most suitable
influencers.

---

# 🚀 Future Improvements

- Influencer analytics dashboard
- Campaign performance tracking
- Messaging system between SME and influencer
- Smart contract payments
- Advanced AI campaign recommendations

---

# 📌 Summary

NanoConnect aims to become a **smart marketplace connecting SMEs with
nano influencers**, making influencer marketing **more accessible,
data-driven, and efficient** for small businesses.
