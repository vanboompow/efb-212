# Product Requirements Document: Open-Source iPad VFR EFB

**Project:** OpenEFB (working title)
**Author:** Ryan Stern
**Date:** February 12, 2026
**Version:** 2.0
**Status:** Draft
**Deployment Target:** iPad, iOS 26.0
**Database:** Dual — GRDB (aviation data) + SwiftData (user data)

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [Market Analysis](#2-market-analysis)
3. [Target User Persona](#3-target-user-persona)
4. [Product Vision & Differentiators](#4-product-vision--differentiators)
5. [Feature Requirements](#5-feature-requirements)
6. [Information Architecture](#6-information-architecture)
7. [Data Model](#7-data-model)
8. [Technical Architecture](#8-technical-architecture)
   - 8.5 [Implementation Architecture](#85-implementation-architecture)
9. [Offline-First Strategy](#9-offline-first-strategy)
10. [Code Reuse Plan](#10-code-reuse-plan)
11. [Monetization](#11-monetization)
12. [Regulatory Compliance](#12-regulatory-compliance)
13. [Technical Risks & Mitigations](#13-technical-risks--mitigations)
14. [Open Source Strategy](#14-open-source-strategy)
15. [Success Metrics](#15-success-metrics)
16. [Key Decisions](#16-key-decisions)
17. [Critical Sources](#17-critical-sources)
18. [Development Sprints (Phase 1)](#18-development-sprints-phase-1)
19. [Visual Verification Checklist](#19-visual-verification-checklist)

---

## 1. Executive Summary

### Mission

Build the first free, open-source, iPad-native VFR Electronic Flight Bag that combines moving-map navigation with flight recording and AI-powered post-flight debrief — making safer, smarter flying accessible to every pilot regardless of budget.

### Vision

ForeFlight is the de facto EFB for iOS pilots, but its $120-360/yr pricing and feature bloat leave recreational VFR pilots overpaying for capabilities they never use. Every critical data source powering these EFBs — FAA airport data, VFR sectional charts, NOAA weather — is **free and public domain**. Android pilots have Avare (free, open-source) but iOS pilots have zero free alternatives. OpenEFB fills that gap.

### Target User

Amateur VFR GA pilot, flies 50-150 hours/year, price-sensitive, uses iPad Mini in the cockpit. Needs a reliable moving map with weather, airport info, and flight planning — not IFR procedures, Jeppesen charts, or synthetic vision.

### Market Opportunity

- ~463,000 active US pilots (FAA 2024), ~210,000 hold private certificates
- 67% of GA flight hours are VFR
- $31.9B global general aviation market (2024)
- ForeFlight raised prices 20% in March 2025, generating significant pilot community backlash on forums (AOPA, Reddit r/flying, PoA)
- Zero free iOS EFB alternatives exist — Android has Avare, iOS has nothing
- 7,000+ lines of proven aviation Swift code already built in the Sovereign Flight Recorder project, ready to extract and reuse

### Unique Advantage

OpenEFB is not just another EFB clone. It uniquely combines four capabilities no single competitor offers:

1. **Open-source + free** — Avare's model, brought to iOS
2. **Simplicity-first UX** — VFR-focused, not an IFR app with VFR features bolted on
3. **Integrated flight recording** — GPS track + cockpit audio + radio transcription, built into the EFB itself
4. **AI-powered debrief** — Post-flight analysis with radio phraseology scoring, clearance extraction, and key-moment identification

---

## 2. Market Analysis

### ForeFlight Pricing (as of 2025)

| Tier | Price/yr | Key Features |
|------|----------|-------------|
| Basic Plus | $120 | VFR/IFR maps, basic weather, basic planning |
| Pro Plus | $240 | Synthetic vision, performance, logbook |
| Performance Plus | $360 | Jeppesen charts, advanced planning |

**Key complaint themes** (aggregated from AOPA forums, Reddit r/flying, Pilots of America):
- "I only use the VFR map and weather — why am I paying $120/yr?"
- "20% price increase with no meaningful new features"
- "Boeing acquisition makes me uncomfortable with my flight data"
- "Too complex — I'm a weekend VFR pilot, not an airline captain"

### Competitor Landscape

| Product | Price | Platform | Open Source | VFR Focus | Recording | AI Debrief |
|---------|-------|----------|-------------|-----------|-----------|------------|
| **ForeFlight** | $120-360/yr | iOS | No | No (IFR-primary) | GPS only | No |
| **Garmin Pilot** | $75-150/yr | iOS/Android | No | No | GPS only | No |
| **FltPlan Go** | Free | iOS/Android | No | Mixed | No | No |
| **FlyQ EFB** | $100-200/yr | iOS | No | Yes (VFR focus) | No | No |
| **WingX Pro** | $100/yr | iOS | No | Mixed | No | No |
| **Avare** | Free | Android only | Yes (GPL) | Yes | No | No |
| **OpenEFB** | **Free** | **iPad** | **Yes** | **Yes** | **Full stack** | **Yes** |

**Gap:** No iOS app is simultaneously free, open-source, VFR-focused, and includes flight recording with AI debrief. FltPlan Go is free but closed-source, ad-supported, and lacks recording. Avare proves the open-source free EFB model works but is Android-only.

### GA Market Size

- **US active pilots:** ~463,000 (FAA 2024 data)
- **Private pilot certificates:** ~210,000
- **Sport pilot certificates:** ~7,700 (growing segment)
- **Student pilots:** ~265,000
- **GA fleet:** ~204,000 registered aircraft
- **VFR share:** ~67% of GA flight hours
- **Global GA market:** $31.9B (2024), growing ~5% CAGR
- **EFB adoption:** Estimated 70%+ of active GA pilots use an EFB app

---

## 3. Target User Persona

### "Weekend Warrior" — Primary Persona

**Demographics:**
- Age: 30-55
- Private or Sport pilot certificate
- Flies 50-150 hours/year
- 1-2 aircraft (owned or club/rental)
- Budget-conscious — aviation is expensive enough without software subscriptions
- iPad Mini (cellular model) mounted in cockpit

**Flying Profile:**
- VFR-only or VFR-primary with occasional IFR training
- Local flights, $100 hamburger runs, weekend cross-countries
- Bay Area / California typical but nationwide
- Single-engine piston (Cessna 172, Piper Cherokee, Grumman Tiger, etc.)

**Current Pain Points:**
- Paying $120+/yr for ForeFlight when they use 30-40% of features
- No way to record and review flights without separate hardware (GoPro + Stratux)
- Radio phraseology anxiety — want to improve but no structured feedback
- Logbook is a mess — paper, ForeFlight, MyFlightbook, etc.
- ForeFlight's UI feels overwhelming for simple VFR flying

**What They Want:**
- Simple moving map with their position on VFR sectional charts
- Quick weather check (METAR/TAF) for their route
- Airport info (frequencies, runways, weather) at a glance
- "Nearest airport" button for emergencies
- A way to replay and learn from their flights
- All of this for free, or at most a few dollars/month

### Secondary Persona: Student Pilot

- Enrolled in PPL training
- Flies 3-5x/week during active training
- Highly motivated to improve radio skills
- Wants flight recording to review with CFI
- Extremely price-sensitive (already spending $10K+ on training)

### Tertiary Persona: CFI (Instructor)

- Wants to review student flights
- Interested in AI debrief as a teaching tool
- Needs to track student currency and progress
- Would adopt if students are already using it

---

## 4. Product Vision & Differentiators

### Core Philosophy

> "Everything you need in the cockpit, nothing you don't. Free forever for safety-critical features."

### Four Differentiators

#### 1. Open-Source + Free
The Avare model, brought to iOS. All flight-critical features are free. The codebase is open — pilots can inspect it, contribute to it, and trust it. No vendor lock-in. No Boeing owning your flight data. Community-driven development means features pilots actually want.

#### 2. Simplicity-First UX
ForeFlight, Garmin Pilot, and WingX are IFR apps that also support VFR. OpenEFB is a VFR app first. The default view is a full-screen moving map with VFR sectional overlay. No approach plates. No SID/STAR selectors. No FMS-style interfaces. A pilot should be able to install the app and be flying with it in under 2 minutes.

#### 3. Integrated Flight Recording
No other EFB combines navigation with full-stack flight recording. OpenEFB records GPS track, cockpit audio, and radio transcripts — all time-synchronized with your position on the map. The recording infrastructure already exists as 7,000+ lines of proven Swift code in the Sovereign Flight Recorder project, including:
- Adaptive GPS sampling (1s airborne, 5s ground) with airborne detection hysteresis
- Cockpit-optimized audio engine (6+ hour recording, noise-resistant)
- Real-time speech-to-text with aviation vocabulary post-processing
- Flight phase detection (preflight/taxi/takeoff/cruise/approach/landing)

#### 4. AI-Powered Debrief
After every flight, OpenEFB generates a structured debrief:
- Narrative summary of the flight
- Extracted ATC clearances with readback accuracy scoring
- Radio phraseology score (brevity, standard phraseology, response latency)
- Key moments (takeoff, landing, go-around, frequency changes, exceedances)
- Suggested logbook entry with times, route, and remarks
- All of this is available on-device (Apple Foundation Models). Cloud AI (Claude API) available opt-in for premium users.

---

## 5. Feature Requirements

### Phase 1: Core MVP — "Just Fly"

**Goal:** A functional VFR EFB that can replace ForeFlight for a basic VFR cross-country flight. Ship in 3-4 months.

| Feature | Description | Priority |
|---------|-------------|----------|
| **Moving Map** | Full-screen map with ownship GPS position, heading indicator, and speed/altitude display | P0 |
| **VFR Sectional Overlay** | FAA VFR sectional charts rendered as raster tile overlays on the map, with opacity control | P0 |
| **Airport Database** | All ~20,000 US airports from FAA NASR data via SwiftNASR: identifier, name, location, elevation, runways, frequencies | P0 |
| **Airport Info Sheet** | Tap airport on map or search to see: runways (length/width/surface), frequencies (CTAF/tower/ground/ATIS), field elevation, weather, remarks | P0 |
| **METAR/TAF Weather** | Current conditions and forecast for any airport, with flight category color coding (VFR/MVFR/IFR/LIFR) | P0 |
| **Weather Map Dots** | Color-coded dots on map showing flight category at each reporting station | P0 |
| **Basic Flight Planning** | Create a direct-to flight plan: departure, destination, route on map with distance/time/fuel estimate | P0 |
| **GPS Ownship Tracking** | Continuous GPS position with ground speed, altitude, vertical speed, and track displayed | P0 |
| **Instrument Strip** | Bottom bar showing: GS (kts), ALT (ft MSL), VSI (fpm), TRK (degrees), distance to next waypoint | P0 |
| **Nearest Airport** | One-tap emergency feature: sorted list of nearest airports with distance, bearing, runways, and direct-to navigation | P0 |
| **Aircraft Profile** | Store aircraft N-number, type, fuel capacity, fuel burn rate, cruise speed | P1 |
| **Pilot Profile** | Store name, certificate number, medical class/expiry, flight review date | P1 |
| **Map Modes** | Toggle between: VFR sectional, street map, satellite, terrain | P1 |
| **Chart Layer Controls** | Toggle airspace boundaries, TFRs, obstacles, airports, navaids on/off | P1 |
| **Search** | Search airports by identifier, name, or city; search navaids | P1 |

### Phase 2: Differentiators — "Record & Learn"

**Goal:** Add flight recording and AI debrief — the features no other EFB has. Ship 2-3 months after Phase 1.

| Feature | Description | Priority |
|---------|-------------|----------|
| **Flight Recording** | One-tap recording: GPS track + cockpit audio + transcription, running simultaneously with EFB navigation | P0 |
| **Auto-Start Recording** | Automatically begin recording when ground speed exceeds 15 kts (configurable threshold) | P1 |
| **Audio Engine** | Cockpit-optimized recording with configurable quality profiles (8-22kHz, 14-43 MB/hr, 6-12 hr battery) | P0 |
| **Live Transcription** | Real-time speech-to-text with aviation vocabulary processing (N-numbers, altitudes, headings, frequencies, runways, transponder codes) | P0 |
| **Flight Phase Detection** | Automatic detection of flight phases (preflight, taxi, takeoff, departure, cruise, approach, landing, postflight) via GPS speed/altitude hysteresis | P0 |
| **AI Post-Flight Debrief** | Generate narrative summary, extract clearances, score radio phraseology (brevity 0-100, phraseology 0-100, readback accuracy 0-100, response latency), identify key moments | P0 |
| **On-Device AI** | Debrief processing via Apple Foundation Models — no internet required | P0 |
| **Cloud AI (Opt-in)** | Enhanced debrief via Claude API for premium users — better narrative, deeper analysis | P1 |
| **Flight Logbook** | Digital logbook with entries auto-populated from recording data: date, departure, arrival, route, total time, day/night landings, night time, remarks | P0 |
| **ForeFlight CSV Import/Export** | Import existing ForeFlight logbook via CSV; export in ForeFlight-compatible format | P1 |
| **Currency Tracking** | Track pilot currency: medical expiry, flight review, night landings (61.57), and show warnings | P1 |
| **Track Replay** | Play back flight track on map with synchronized audio and transcript timeline | P1 |
| **TFR Alerting** | Display active TFRs on map with proximity alerts | P0 |
| **Airspace Alerting** | Visual and audio alerts when approaching Class B/C/D airspace | P1 |
| **Community PIREPs** | Submit and view pilot reports (turbulence, icing, visibility) | P2 |

### Phase 3: Growth — "Full Platform"

**Goal:** Expand capabilities toward IFR, training, and advanced features. Ongoing after Phase 2.

| Feature | Description | Priority |
|---------|-------------|----------|
| **IFR Procedures** | Approach plates, SIDs/STARs, IFR en-route charts from FAA d-TPP and CIFP | P1 |
| **ADS-B Traffic Display** | Show traffic from Stratux, Sentry Mini, and other ADS-B receivers via GDL 90 protocol | P1 |
| **ADS-B Weather** | FIS-B weather (NEXRAD, METARs, TAFs, TFRs, PIREPs) from ADS-B receivers | P2 |
| **Weight & Balance** | Aircraft-specific W&B calculator with CG envelope visualization | P1 |
| **Performance Planning** | Takeoff/landing distance, density altitude, climb/cruise/fuel performance | P2 |
| **Multi-Leg Routing** | Multi-waypoint flight plans with per-leg fuel/time calculations | P1 |
| **CFI/Student Mode** | Instructor can review student flights, annotate debrief, track progress | P2 |
| **Radio Coach** | AI-powered radio phraseology training with practice scenarios | P2 |
| **Collaborative Plans** | Share flight plans with other OpenEFB users | P2 |
| **Navaid Info** | VOR, VORTAC, NDB details with radial/distance calculations | P1 |
| **NEXRAD Radar Overlay** | Animated precipitation radar on map | P1 |
| **Winds Aloft** | Forecast winds at altitude for fuel/time planning | P2 |

---

## 6. Information Architecture

### iPad Landscape Layout (Primary)

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ [≡] [Search] [VFR ▾] [Layers ▾] [Plan] [●REC]         [Settings] [Timer] │ ← Toolbar
├───────────┬──────────────────────────────────────────────────┬──────────────┤
│           │                                                  │              │
│  Airport  │                                                  │   Recording  │
│  Search   │                                                  │   Controls   │
│           │                                                  │              │
│  ─────    │               MAP (PRIMARY VIEW)                 │   [ARM]      │
│  Weather  │                                                  │   00:00:00   │
│  Brief    │          VFR Sectional + Ownship                 │   Phase:     │
│           │          Route Line + Waypoints                  │   Cruise     │
│  ─────    │          Weather Dots                            │              │
│  Flight   │          Airspace Boundaries                     │   Audio: ●   │
│  Plan     │          TFRs                                    │   GPS:   ●   │
│           │                                                  │   Trans: ●   │
│  ─────    │                                                  │              │
│  Nearest  │                                                  │   [STOP]     │
│  Airports │                                                  │              │
│           │                                                  │              │
├───────────┴──────────────────────────────────────────────────┴──────────────┤
│  GS: 105kts │ ALT: 4,500' │ VSI: +200fpm │ TRK: 270° │ DTG: 42nm │ ETE: 24m│ ← Instrument Strip
└──────────────────────────────────────────────────────────────────────────────┘
```

### View Hierarchy

```
TabBar (bottom, minimal)
├── Map (default, 90% of use)
│   ├── Left Sidebar (collapsible, ≡ toggle)
│   │   ├── Search Panel
│   │   ├── Weather Brief Panel
│   │   ├── Flight Plan Panel
│   │   └── Nearest Airports Panel
│   ├── Map Canvas (full-screen primary)
│   │   ├── VFR Sectional Tile Layer
│   │   ├── Airspace Boundary Layer
│   │   ├── TFR Layer
│   │   ├── Weather Dot Layer
│   │   ├── Route Line Layer
│   │   └── Ownship Icon
│   ├── Right Sidebar (collapsible, recording)
│   │   ├── ARM / Recording Toggle
│   │   ├── Timer / Phase Display
│   │   └── Service Status Indicators
│   └── Bottom Instrument Strip (always visible)
│       └── GS | ALT | VSI | TRK | DTG | ETE
├── Flights (post-flight)
│   ├── Flight List (sortable by date, departure, duration)
│   ├── Flight Detail
│   │   ├── Debrief Summary Tab
│   │   ├── Track Replay Tab (map + timeline)
│   │   ├── Transcript Tab (synchronized with track)
│   │   ├── Radio Score Tab
│   │   └── Logbook Entry Tab
│   └── Logbook View (traditional logbook format)
├── Aircraft & Pilot
│   ├── Aircraft Profiles (N-number, type, performance)
│   ├── Pilot Profile (certificates, medical, currency)
│   └── Compliance Dashboard (airworthiness + currency checks)
└── Settings
    ├── Chart Downloads (region picker, storage management)
    ├── Recording Preferences (quality profile, auto-start)
    ├── AI Configuration (on-device vs. cloud, API key)
    ├── Units & Display (nautical/statute, time format)
    └── About / Legal / Open Source Licenses
```

### Interaction Patterns

- **Default state:** Full-screen map, both sidebars collapsed, instrument strip visible
- **Pre-flight:** Open left sidebar for weather brief and flight plan creation
- **In-flight:** Map only + instrument strip. Optional right sidebar for recording controls
- **Tap airport on map:** Popover with airport info sheet (frequencies, runways, weather)
- **Long-press on map:** Drop a waypoint, measure distance/bearing from ownship
- **Pinch/zoom:** Map zoom with sectional chart detail levels appearing at appropriate zoom
- **Two-finger rotate:** Map heading mode (track-up vs. north-up)

---

## 7. Data Model

### Entity Relationship Overview

```
PilotProfile ──1:N── Flight
AircraftProfile ──1:N── Flight
Flight ──1:N── TrackPoint
Flight ──1:N── TranscriptSegment
Flight ──1:N── FlightPhase
Flight ──1:1── DebriefSummary
Flight ──1:1── FlightMetadata
DebriefSummary ──1:N── Clearance
DebriefSummary ──1:1── RadioScore
DebriefSummary ──1:N── KeyMoment
DebriefSummary ──1:1── LogEntry
FlightPlan ──1:N── Waypoint
Airport ──1:N── Runway
Airport ──1:N── Frequency
Airport ──0:N── WeatherCache
ChartRegion ──1:N── ChartTile (file system)
Airspace ──geometry── (polygon/circle)
```

### Core Entities

#### Airport (from FAA NASR via SwiftNASR)

```swift
struct Airport: Identifiable, Codable {
    var id: String { icao }          // ICAO identifier (e.g., "KPAO")
    let icao: String
    let faaID: String?               // FAA LID if different (e.g., "PAO")
    let name: String                 // "Palo Alto"
    let latitude: Double
    let longitude: Double
    let elevation: Double            // feet MSL
    let type: AirportType            // .airport, .heliport, .seaplane, .ultralight
    let ownership: OwnershipType     // .public, .private, .military
    let ctafFrequency: Double?       // MHz
    let unicomFrequency: Double?
    let artccID: String?             // Controlling ARTCC
    let fssID: String?               // Flight service station
    let magneticVariation: Double?   // degrees (W negative)
    let patternAltitude: Int?        // feet AGL
    let fuelTypes: [String]          // ["100LL", "JetA"]
    let hasBeaconLight: Bool
    let runways: [Runway]
    let frequencies: [Frequency]
}
```

**Count:** ~20,000 US airports from NASR 28-day cycle.

**Existing code reference:** `AirportDatabase.swift` has a working `Airport` model with `nearest(to:)` and `airports(within:of:)` spatial queries. Current implementation uses hardcoded Bay Area + major US airports (~130). Phase 1 replaces this with full NASR data via SwiftNASR.

#### Runway

```swift
struct Runway: Identifiable, Codable {
    let id: String                   // e.g., "13/31"
    let length: Int                  // feet
    let width: Int                   // feet
    let surface: SurfaceType         // .asphalt, .concrete, .turf, .gravel, .water
    let lighting: LightingType       // .none, .partTime, .fullTime
    let baseEndID: String            // "13"
    let reciprocalEndID: String      // "31"
    let baseEndLatitude: Double
    let baseEndLongitude: Double
    let reciprocalEndLatitude: Double
    let reciprocalEndLongitude: Double
    let baseEndElevation: Double?    // feet MSL (TDZE)
    let reciprocalEndElevation: Double?
}
```

#### Frequency

```swift
struct Frequency: Identifiable, Codable {
    let id: UUID
    let type: FrequencyType          // .ctaf, .tower, .ground, .clearance, .approach, .departure, .atis, .awos, .unicom, .multicom
    let frequency: Double            // MHz (e.g., 118.6)
    let name: String                 // "Palo Alto Tower"
}
```

#### Navaid

```swift
struct Navaid: Identifiable, Codable {
    let id: String                   // e.g., "SJC"
    let name: String                 // "San Jose"
    let type: NavaidType             // .vor, .vortac, .vorDme, .ndb, .ndbDme
    let latitude: Double
    let longitude: Double
    let frequency: Double            // MHz (VOR) or kHz (NDB)
    let magneticVariation: Double?
    let elevation: Double?           // feet MSL
}
```

#### Airspace

```swift
struct Airspace: Identifiable, Codable {
    let id: UUID
    let classification: AirspaceClass  // .bravo, .charlie, .delta, .echo, .golf, .prohibited, .restricted, .moa, .alert, .warning, .tfr
    let name: String                   // "SFO Class B"
    let floor: Int                     // feet MSL (0 = surface)
    let ceiling: Int                   // feet MSL
    let geometry: AirspaceGeometry     // polygon coordinates or center+radius
}
```

#### Flight (existing — from SFR `Flight.swift`)

```swift
// Already implemented in SFR with 7,000+ LOC
struct Flight: Identifiable, Codable {
    let id: UUID
    var date: Date
    var departure: String              // ICAO code
    var arrival: String                // ICAO code
    var route: String
    var duration: TimeInterval
    var audioFileURL: URL?
    var trackLog: [TrackPoint]         // 1s airborne / 5s ground sampling
    var transcriptSegments: [TranscriptSegment]
    var debriefSummary: DebriefSummary?
    var flightPhases: [FlightPhase]    // Auto-detected phases
    var retentionPolicy: RetentionPolicy
    var metadata: FlightMetadata       // Aircraft ID, pilot, device, app version
}
```

**Existing code reference:** `Flight.swift` — complete implementation with all nested types.

#### TrackPoint (existing — from SFR `Flight.swift`)

```swift
struct TrackPoint: Identifiable, Codable {
    let id: UUID
    var timestamp: Date
    var latitude: Double
    var longitude: Double
    var altitudeGPS: Double            // feet MSL
    var altitudeBarometric: Double     // feet MSL (from CMAltimeter)
    var groundSpeed: Double            // knots
    var verticalSpeed: Double          // feet per minute
    var course: Double                 // degrees true
    var accelerometerX: Double?        // G-force
    var accelerometerY: Double?
    var accelerometerZ: Double?
}
```

**Existing code reference:** `TrackLogRecorder.swift` — full GPS engine producing these records.

#### AircraftProfile (existing — from SFR `ComplianceModels.swift`)

```swift
struct AircraftProfile: Codable {
    var nNumber: String
    var status: AircraftComplianceStatus  // .airworthy, .grounded, .inMaintenance
    var currentTach: Double
    var currentHobbs: Double
    var next100HrTach: Double?
    var annualDue: Date?
    var transponderDue: Date?
    var pitotStaticDue: Date?
    var eltDue: Date?
    var insuranceExpiry: Date?
    var hasIFRCert: Bool
    // Extended for EFB:
    var aircraftType: String?          // "AA-5B Tiger"
    var fuelCapacityGallons: Double?
    var fuelBurnGPH: Double?
    var cruiseSpeedKts: Double?
    var vSpeeds: VSpeeds?              // Vr, Vx, Vy, Va, Vne, Vfe, Vs0, Vs1
}
```

#### PilotProfile (existing — from SFR `ComplianceModels.swift`)

```swift
struct PilotProfile: Codable {
    var pilotCertificateNumber: String?
    var medicalClass: MedicalClass?      // .first, .second, .third, .basicMed
    var medicalExpiry: Date?
    var flightReviewDate: Date?
    var insuranceNamedPilot: Bool
    var recentNightLandings: [NightLandingRecord]
    // Extended for EFB:
    var name: String?
    var certificateType: CertificateType?  // .student, .sport, .recreational, .private, .commercial, .atp
    var ratings: [String]?               // ["SEL", "MEL", "Instrument"]
    var totalHours: Double?
}
```

#### FlightPlan (new)

```swift
struct FlightPlan: Identifiable, Codable {
    let id: UUID
    var name: String?
    var departure: String              // ICAO
    var destination: String            // ICAO
    var waypoints: [Waypoint]
    var cruiseAltitude: Int            // feet MSL
    var cruiseSpeed: Double            // knots TAS
    var fuelBurnRate: Double?          // GPH
    var totalDistance: Double           // nautical miles (computed)
    var estimatedTime: TimeInterval    // seconds (computed)
    var estimatedFuel: Double?         // gallons (computed)
    var createdAt: Date
    var notes: String?
}

struct Waypoint: Identifiable, Codable {
    let id: UUID
    var identifier: String             // ICAO, navaid ID, or lat/lon
    var name: String
    var latitude: Double
    var longitude: Double
    var altitude: Int?                 // feet MSL (optional per-waypoint)
    var type: WaypointType             // .airport, .navaid, .fix, .userWaypoint, .latLon
}
```

#### WeatherCache (new)

```swift
struct WeatherCache: Identifiable, Codable {
    let id: UUID
    var stationID: String              // ICAO (e.g., "KPAO")
    var metar: String?                 // Raw METAR text
    var taf: String?                   // Raw TAF text
    var flightCategory: FlightCategory // .vfr, .mvfr, .ifr, .lifr
    var temperature: Double?           // Celsius
    var dewpoint: Double?              // Celsius
    var wind: WindInfo?                // direction, speed, gusts
    var visibility: Double?            // statute miles
    var ceiling: Int?                  // feet AGL
    var fetchedAt: Date                // When data was retrieved
    var observationTime: Date?         // When observation was taken
}
```

#### ChartRegion (new)

```swift
struct ChartRegion: Identifiable, Codable {
    let id: String                     // e.g., "San_Francisco"
    let name: String                   // "San Francisco"
    let effectiveDate: Date
    let expirationDate: Date
    let boundingBox: BoundingBox       // lat/lon extent
    let fileSizeMB: Double             // mbtiles file size
    var isDownloaded: Bool
    var localPath: URL?                // Path to .mbtiles file on disk
}
```

### Storage Budget

| Data Type | Estimated Size | Storage Location |
|-----------|---------------|-----------------|
| Airport database (NASR) | ~50 MB | SQLite |
| Navaids + Airspace | ~20 MB | SQLite |
| Single VFR sectional region (mbtiles) | 50-200 MB | File system |
| Full US VFR sectional coverage | ~3-6 GB | File system |
| Weather cache | < 5 MB | SQLite (in-memory cache + disk) |
| Flight recording (1 hr, high quality) | ~50 MB (43 audio + 5 track + 2 transcript) | Encrypted file system |
| 100 flight records (metadata only) | ~10 MB | SQLite |

**Total budget:** 500 MB (single region, minimal flights) to 6 GB (full US charts, extensive flight library).

---

## 8. Technical Architecture

### Platform & Requirements

| Requirement | Specification |
|------------|---------------|
| **Device** | iPad (all models with GPS — cellular models required for built-in GPS) |
| **iOS Version** | iOS 26.0 |
| **Language** | Swift 6.0+ |
| **UI Framework** | SwiftUI |
| **Architecture** | MVVM + Combine (consistent with SFR codebase) |
| **Min Storage** | 500 MB free (single chart region) |
| **Recommended Storage** | 4 GB free (multi-region + flight library) |
| **GPS** | Built-in (cellular iPad) or external (Bad Elf, Stratux) |

### Technology Stack

```
┌─────────────────────────────────────────────┐
│              OpenEFB App (SwiftUI)          │
├─────────────────────────────────────────────┤
│  Views          │  ViewModels (MVVM)        │
│  Map Canvas     │  MapViewModel             │
│  Airport Info   │  AirportViewModel         │
│  Weather Brief  │  WeatherViewModel         │
│  Flight Plan    │  FlightPlanViewModel      │
│  Recording      │  RecordingViewModel       │
│  Debrief        │  DebriefViewModel         │
│  Logbook        │  LogbookViewModel         │
│  Settings       │  SettingsViewModel        │
├─────────────────────────────────────────────┤
│              Services Layer                  │
├──────────┬──────────┬──────────┬────────────┤
│ MapEngine│ Aviation │ Weather  │ Recording  │
│ MapLibre │ SwiftNASR│ NOAA API │ SFR Audio  │
│ Tiles    │ Airport  │ METAR/TAF│ SFR GPS    │
│ Layers   │ Navaid   │ TFR      │ SFR Trans  │
│ Ownship  │ Airspace │ Cache    │ SFR AI     │
├──────────┴──────────┴──────────┴────────────┤
│              Data Layer                      │
├──────────┬──────────┬───────────────────────┤
│ SQLite   │ File     │ Keychain / Secure     │
│ (GRDB)   │ System   │ Enclave               │
│ Airports │ mbtiles  │ API Keys              │
│ Flights  │ Audio    │ Encryption Keys       │
│ Weather  │ Charts   │                       │
└──────────┴──────────┴───────────────────────┘
```

### Key Technology Choices

#### Map Engine: MapLibre Native iOS

**Choice:** MapLibre GL Native for iOS (open-source fork of Mapbox GL Native)

**Why MapLibre:**
- Open-source (BSD license), no API key or usage fees
- Native iOS SDK with excellent SwiftUI interop
- Supports raster tile overlays (critical for VFR sectional charts)
- Supports MBTiles offline tile sources
- Hardware-accelerated rendering (Metal on iOS)
- Smooth pan/zoom/rotate with 60fps
- Supports custom layers for airspace, route lines, weather dots
- Active community and regular releases
- Same rendering engine as Mapbox (proven at scale) without the pricing

**Integration approach:**
- Base layer: MapLibre vector tiles (OpenStreetMap) or satellite imagery
- Overlay layer: FAA VFR sectional chart raster tiles (mbtiles format)
- Custom layers: airspace polygons, route lines, weather station dots, ownship icon
- Offline: mbtiles files stored locally, no network required in flight

#### Aviation Data: SwiftNASR

**Choice:** SwiftNASR package (Swift FAA NASR data parser)

**Why SwiftNASR:**
- Native Swift package, direct SPM integration
- Parses the official FAA NASR (National Airspace System Resources) data
- Covers all ~20,000 US airports, runways, frequencies, navaids
- 28-day AIRAC update cycle (matches FAA publication schedule)
- Open-source, actively maintained
- Handles the notoriously complex NASR fixed-width data format

**Data flow:**
1. Download NASR 28-day cycle data from FAA (~200 MB compressed)
2. Parse via SwiftNASR into Swift structs
3. Store parsed data in local SQLite database
4. App queries SQLite for airport/navaid/airspace lookups
5. Background check for new NASR cycle every launch

#### VFR Chart Tiles: FAA GeoTIFFs → MBTiles

**Choice:** FAA VFR sectional GeoTIFF charts converted to MBTiles via GDAL toolchain

**Why this approach:**
- FAA publishes VFR sectional charts as free GeoTIFF images (56-day cycle)
- GeoTIFFs are georeferenced raster images — exactly what we need for map overlays
- GDAL (Geospatial Data Abstraction Library) can convert GeoTIFF → mbtiles (raster tile format)
- MBTiles is a SQLite database of map tiles — supported natively by MapLibre
- Existing open-source tool: `aviationCharts` project handles the full pipeline

**Chart tile pipeline:**
```
FAA VFR Sectional GeoTIFF (free, 56-day cycle)
    ↓ Download from FAA aeronav products
GDAL Processing (gdal_translate + gdalwarp + gdal2tiles)
    ↓ Reproject to Web Mercator, slice into tiles
MBTiles (SQLite container of /z/x/y PNG tiles)
    ↓ Host on CDN for user download
MapLibre Raster Source (offline-capable)
```

**Tile hosting:** Pre-process chart tiles server-side, host on CDN (Cloudflare R2 or similar). Users download region-specific mbtiles files. Updates every 56 days with new FAA chart cycle.

#### Weather: NOAA Aviation Weather API

**Choice:** NOAA Aviation Weather Center API (aviationweather.gov/data/api/)

**Why NOAA:**
- Free, no API key required
- Official FAA/NWS weather source (same data ForeFlight uses)
- Rate limit: 100 requests/minute (generous for single-user app)
- Returns METARs, TAFs, PIREPs, SIGMETs, AIRMETs, TFRs
- JSON and XML response formats
- Covers all US and international ICAO stations

**Endpoints used:**
- `/api/data/metar` — Current observations
- `/api/data/taf` — Terminal forecasts
- `/api/data/pirep` — Pilot reports
- `/api/data/airsigmet` — AIRMETs and SIGMETs
- TFR data: FAA TFR API (tfr.faa.gov)

**Caching strategy:**
- METARs: Cache 15 minutes (observation updates hourly, specials as needed)
- TAFs: Cache 1 hour (updates every 6 hours)
- PIREPs: Cache 30 minutes
- TFRs: Cache 1 hour
- All cached data displays "age" badge showing time since observation

#### Database: Dual — GRDB (Aviation) + SwiftData (User Data)

**Choice:** Dual database architecture — GRDB.swift for aviation data, SwiftData for user data

**Why dual approach:**

**GRDB for aviation data (airports, navaids, airspace, weather cache):**
- Lightweight, no framework overhead — just SQL
- Excellent spatial query support (R-tree indexes for airport/airspace proximity)
- Full control over schema and migrations
- WAL mode for concurrent reads during flight recording
- Proven performance with 20K+ airport records and spatial lookups
- Works seamlessly offline
- GRDB's record protocols map cleanly to existing Codable structs
- FTS5 full-text search on airport names and identifiers

**SwiftData for user data (profiles, flights, settings):**
- Already scaffolded in the Xcode project template (iOS 26.0)
- Excellent for CRUD operations on user-created data
- CloudKit-ready for premium cloud sync feature
- Native SwiftUI integration with `@Query` and `@Model`
- Mature and stable on iOS 26.0
- Appropriate for lower-volume user data (profiles, flight records, preferences)

**Schema highlights (GRDB):**
- R-tree spatial index on airport lat/lon for nearest-airport queries (O(log n) instead of full scan)
- FTS5 full-text search on airport names and identifiers
- Three logical databases: `aviationDB` (static NASR data, R-tree), `flightDB` (WAL mode, recordings), `weatherCache` (ephemeral, 15-min TTL)

#### GPS: CLLocationManager (existing)

**Existing code reference:** `TrackLogRecorder.swift` — complete implementation with:
- `CLLocationManager` configured for `.airborne` activity type
- `kCLLocationAccuracyBest` for maximum GPS precision
- `allowsBackgroundLocationUpdates = true` for recording while screen is off
- `pausesLocationUpdatesAutomatically = false` to prevent iOS from killing GPS
- Adaptive sampling: 1-second when airborne, 5-second on ground
- Airborne detection with hysteresis (3 consecutive samples > 30kts and > 200ft AGL)
- CMAltimeter integration for barometric altitude
- CMMotionManager for accelerometer data
- Vertical speed calculation from successive GPS altitude readings
- Distance calculation in nautical miles
- Nearest airport detection (periodic, rate-limited)

**For EFB, additionally needed:**
- Ownship position publishing to map view at display refresh rate
- Heading/track publishing for map orientation
- External GPS support (Bad Elf, Stratux) via CoreBluetooth or ExternalAccessory

#### Audio & Transcription (existing)

**Existing code reference:** SFR services provide:
- `CockpitAudioEngine` — 6+ hour cockpit recording, three quality profiles (8-22kHz, 14-43 MB/hr)
- `CockpitTranscriptionEngine` — Real-time speech-to-text via Apple Speech framework
- `AviationVocabularyProcessor` — Post-processing for aviation terms: N-numbers ("November four five four three alpha" → "N4543A"), altitudes ("three thousand" → "3,000'"), headings ("heading two seven zero" → "heading 270"), frequencies ("one two four point eight" → "124.8"), runways ("runway three one left" → "Runway 31L"), transponder codes ("squawk one two zero zero" → "Squawk 1200"), ATIS information, approach types, waypoints
- `FlightPhaseDetector` — Automatic phase detection from GPS data
- `FlightDebriefEngine` — AI debrief generation (on-device + Claude API)

#### Service Orchestration (existing)

**Existing code reference:** `FlightManager.swift` — central coordinator with:
- State machine: `idle → armed → recording → stopping → idle`
- Orchestrates audio, GPS, transcription, and phase detection
- Auto-start trigger (configurable speed threshold, default 15 kts)
- Battery monitoring
- Automatic departure/arrival airport inference from track data
- Flight data finalization (duration, track log, transcript segments, phases)
- Encrypted persistence via `FlightDataStore`

### SPM Package Architecture

```
OpenEFB/
├── Package.swift
├── Packages/
│   ├── EFBCore/           # Shared types, extensions, utilities
│   ├── EFBMap/            # MapLibre integration, tile management, layers
│   ├── EFBAviationData/   # SwiftNASR integration, airport/navaid/airspace DB
│   ├── EFBWeather/        # NOAA API client, weather models, caching
│   ├── EFBPlanning/       # Flight planning, routing, fuel/time calculations
│   ├── EFBRecording/      # → imports SFR packages (audio, GPS, transcription)
│   ├── EFBDebrief/        # → imports SFR AI debrief, adds EFB-specific analysis
│   ├── EFBLogbook/        # Flight logbook, currency tracking, CSV import/export
│   └── EFBSecurity/       # Encryption, keychain, consent management
├── OpenEFBApp/            # Main app target (SwiftUI views, view models)
└── Tests/
    ├── EFBCoreTests/
    ├── EFBMapTests/
    ├── EFBAviationDataTests/
    ├── EFBWeatherTests/
    ├── EFBPlanningTests/
    ├── EFBRecordingTests/
    ├── EFBDebriefTests/
    └── EFBLogbookTests/
```

### 8.5 Implementation Architecture

This section provides implementation-level architecture details, including directory structure, code patterns, and Swift snippets that agent teams can use as starting points when building the app.

#### 8.5.1 App Target Directory Structure

```
efb-212/
├── App/
│   └── efb_212App.swift
├── Views/
│   ├── Map/
│   │   ├── MapView.swift                 # MapLibre UIViewRepresentable wrapper
│   │   ├── InstrumentStripView.swift     # Bottom bar: GS, ALT, VSI, TRK, DTG, ETE
│   │   ├── AirportInfoSheet.swift        # Airport detail popover (freqs, runways, wx)
│   │   └── LayerControlsView.swift       # Toggle airspace, TFRs, weather dots, navaids
│   ├── Planning/
│   │   └── FlightPlanView.swift          # Departure → destination, route, fuel/time
│   ├── Flights/
│   │   ├── FlightListView.swift          # Sortable flight history
│   │   ├── FlightDetailView.swift        # Single flight with tabs
│   │   ├── DebriefView.swift             # AI-generated debrief display
│   │   └── TrackReplayView.swift         # Map playback with timeline
│   ├── Logbook/
│   │   └── LogbookView.swift             # Traditional logbook format
│   ├── Aircraft/
│   │   ├── AircraftProfileView.swift     # N-number, type, performance data
│   │   └── PilotProfileView.swift        # Certificates, medical, currency
│   ├── Settings/
│   │   ├── SettingsView.swift            # App configuration
│   │   └── ChartDownloadView.swift       # Region picker, storage management
│   └── Components/
│       ├── WeatherBadge.swift            # METAR staleness indicator
│       ├── FlightCategoryDot.swift       # VFR/MVFR/IFR/LIFR colored dot
│       └── SearchBar.swift               # Airport/navaid search
├── ViewModels/
│   ├── MapViewModel.swift                # Map state, layer visibility, ownship tracking
│   ├── WeatherViewModel.swift            # Weather fetch, cache, display state
│   ├── FlightPlanViewModel.swift         # Route editing, distance/time/fuel calc
│   ├── RecordingViewModel.swift          # Recording controls, status, timer
│   ├── LogbookViewModel.swift            # Logbook entries, currency checks
│   └── SettingsViewModel.swift           # App preferences, chart management
├── Services/
│   ├── MapService.swift                  # MapLibre wrapper, layer managers
│   ├── WeatherService.swift              # NOAA API client, caching
│   ├── ChartManager.swift                # Chart download, validation, cache
│   ├── PowerManager.swift                # Battery monitoring, adaptive degradation
│   ├── EFBRecordingCoordinator.swift     # Bridge SFR FlightManager ↔ EFB services
│   └── SecurityManager.swift             # Keychain, Secure Enclave, consent
├── Data/
│   ├── AviationDatabase.swift            # GRDB: airports, navaids, airspace (R-tree)
│   ├── DatabaseManager.swift             # Protocol + coordinator for dual-DB
│   └── Models/                           # SwiftData @Model classes
│       ├── AircraftProfile.swift         # @Model: aircraft data (replaces Item.swift)
│       ├── PilotProfile.swift            # @Model: pilot data
│       └── FlightRecord.swift            # @Model: flight metadata for logbook
├── Core/
│   ├── AppState.swift                    # @MainActor root state coordinator
│   ├── EFBError.swift                    # Centralized error types
│   ├── DeviceCapabilities.swift          # Device detection (GPS, cellular, screen)
│   └── Extensions/
│       ├── CLLocation+Aviation.swift     # Nautical mile conversions, bearing calc
│       └── Date+Aviation.swift           # Zulu time formatting
└── Resources/
    └── Assets.xcassets/
```

> **Note:** `Item.swift` (Xcode template boilerplate) should be removed once `AircraftProfile.swift` and other models are in place.

#### 8.5.2 State Management

`AppState` serves as the global state coordinator, owned by the app's root view and passed via the environment.

```swift
import SwiftUI
import Combine

@MainActor
final class AppState: ObservableObject {
    // MARK: - Navigation
    @Published var selectedTab: AppTab = .map
    @Published var isPresentingAirportInfo: Bool = false
    @Published var selectedAirportID: String?

    // MARK: - Map State
    @Published var mapCenter: CLLocationCoordinate2D = .init(latitude: 37.46, longitude: -122.12)
    @Published var mapZoom: Double = 10.0
    @Published var mapMode: MapMode = .northUp        // .northUp, .trackUp
    @Published var visibleLayers: Set<MapLayer> = [.sectional, .airports, .ownship]

    // MARK: - Location
    @Published var ownshipPosition: CLLocation?
    @Published var groundSpeed: Double = 0             // knots
    @Published var altitude: Double = 0                // feet MSL
    @Published var verticalSpeed: Double = 0           // feet per minute
    @Published var track: Double = 0                   // degrees true

    // MARK: - Recording (Phase 2)
    @Published var isRecording: Bool = false
    @Published var recordingDuration: TimeInterval = 0
    @Published var currentFlightPhase: String = "Idle"

    // MARK: - Flight Plan
    @Published var activeFlightPlan: FlightPlan?
    @Published var distanceToNext: Double?             // nautical miles
    @Published var estimatedTimeEnroute: TimeInterval?

    // MARK: - System
    @Published var batteryLevel: Double = 1.0
    @Published var powerState: PowerState = .normal
    @Published var gpsAvailable: Bool = false
    @Published var networkAvailable: Bool = false

    // MARK: - Services (injected)
    let locationManager: LocationManagerProtocol
    let databaseManager: DatabaseManagerProtocol
    let weatherService: WeatherServiceProtocol

    init(
        locationManager: LocationManagerProtocol = LocationManager.shared,
        databaseManager: DatabaseManagerProtocol = DatabaseManager(),
        weatherService: WeatherServiceProtocol = WeatherService()
    ) {
        self.locationManager = locationManager
        self.databaseManager = databaseManager
        self.weatherService = weatherService
    }
}

enum AppTab: String, CaseIterable {
    case map, flights, logbook, aircraft, settings
}

enum MapMode: String {
    case northUp, trackUp
}

enum MapLayer: String, CaseIterable {
    case sectional, airports, airspace, tfrs, weatherDots, navaids, route, ownship
}
```

#### 8.5.3 Dual Database Architecture

The database layer uses a protocol-based coordinator managing three logical databases.

```swift
// MARK: - Database Manager Protocol

protocol DatabaseManagerProtocol: Sendable {
    // Aviation data (GRDB)
    func airport(byICAO icao: String) async throws -> Airport?
    func airports(near coordinate: CLLocationCoordinate2D, radiusNM: Double) async throws -> [Airport]
    func searchAirports(query: String, limit: Int) async throws -> [Airport]
    func airspaces(containing coordinate: CLLocationCoordinate2D, altitude: Double) async throws -> [Airspace]
    func nearestAirports(to coordinate: CLLocationCoordinate2D, count: Int) async throws -> [Airport]

    // Weather cache (ephemeral GRDB)
    func cachedWeather(for stationID: String) async throws -> WeatherCache?
    func cacheWeather(_ weather: WeatherCache) async throws
    func staleWeatherStations(olderThan interval: TimeInterval) async throws -> [String]
    func clearWeatherCache() async throws

    // User data (SwiftData) — accessed through ModelContext, but protocol abstracts it
    func importNASRData(from url: URL, progress: @escaping (Double) -> Void) async throws
}

// MARK: - Aviation Database (GRDB)

import GRDB

final class AviationDatabase: Sendable {
    private let dbPool: DatabasePool

    /// Three logical databases:
    /// - aviationDB: Static NASR data with R-tree spatial indexes (read-heavy)
    /// - flightDB: WAL mode for concurrent recording writes + UI reads
    /// - weatherCache: Ephemeral, 15-minute TTL, in-memory with disk backup

    init(path: String) throws {
        var config = Configuration()
        config.prepareDatabase { db in
            // Enable WAL mode for concurrent access
            try db.execute(sql: "PRAGMA journal_mode = WAL")
            // Enable R-tree extension for spatial queries
            try db.execute(sql: "PRAGMA compile_options")
        }
        self.dbPool = try DatabasePool(path: path, configuration: config)
    }

    func nearestAirports(to coordinate: CLLocationCoordinate2D, count: Int = 5) async throws -> [Airport] {
        try await dbPool.read { db in
            // R-tree spatial query for nearest airports
            let sql = """
                SELECT a.* FROM airports a
                INNER JOIN airports_rtree r ON a.rowid = r.id
                WHERE r.minLat <= ? AND r.maxLat >= ?
                  AND r.minLon <= ? AND r.maxLon >= ?
                ORDER BY (
                    (a.latitude - ?) * (a.latitude - ?) +
                    (a.longitude - ?) * (a.longitude - ?) *
                    COS(a.latitude * 0.0174533) * COS(a.latitude * 0.0174533)
                ) ASC
                LIMIT ?
                """
            let delta = 1.0 // ~60nm bounding box
            return try Airport.fetchAll(db, sql: sql, arguments: [
                coordinate.latitude + delta, coordinate.latitude - delta,
                coordinate.longitude + delta, coordinate.longitude - delta,
                coordinate.latitude, coordinate.latitude,
                coordinate.longitude, coordinate.longitude,
                count
            ])
        }
    }
}

// MARK: - SwiftData Models (User Data)

import SwiftData

@Model
final class AircraftProfileModel {
    var nNumber: String
    var aircraftType: String?
    var fuelCapacityGallons: Double?
    var fuelBurnGPH: Double?
    var cruiseSpeedKts: Double?
    var annualDue: Date?
    var transponderDue: Date?
    var createdAt: Date

    init(nNumber: String) {
        self.nNumber = nNumber
        self.createdAt = Date()
    }
}

@Model
final class PilotProfileModel {
    var name: String?
    var certificateNumber: String?
    var certificateType: String?
    var medicalClass: String?
    var medicalExpiry: Date?
    var flightReviewDate: Date?
    var totalHours: Double?

    init() {}
}

@Model
final class FlightRecordModel {
    var flightID: UUID
    var date: Date
    var departure: String
    var arrival: String
    var route: String?
    var duration: TimeInterval
    var totalDistance: Double?   // nautical miles
    var remarks: String?

    init(flightID: UUID, date: Date, departure: String, arrival: String, duration: TimeInterval) {
        self.flightID = flightID
        self.date = date
        self.departure = departure
        self.arrival = arrival
        self.duration = duration
    }
}
```

#### 8.5.4 MapLibre Integration

`MapService` wraps `MLNMapView` and manages chart layers, airspace visualization, and ownship tracking.

```swift
import MapLibre

final class MapService: NSObject, ObservableObject {
    private var mapView: MLNMapView?

    // Layer managers
    private let chartLayerManager = ChartLayerManager()
    private let airspaceLayerManager = AirspaceLayerManager()
    private let ownshipRenderer = OwnshipRenderer()
    private let weatherDotRenderer = WeatherDotRenderer()
    private let routeRenderer = RouteRenderer()

    /// Configure the map view with base style and initial layers
    func configure(mapView: MLNMapView) {
        self.mapView = mapView
        mapView.delegate = self

        // Base map style (OpenStreetMap vector tiles via MapTiler or similar free source)
        mapView.styleURL = URL(string: "https://demotiles.maplibre.org/style.json")

        // Enable user location (ownship)
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow

        // Set initial viewport (user's last location or default)
        mapView.setCenter(CLLocationCoordinate2D(latitude: 37.46, longitude: -122.12),
                          zoomLevel: 10, animated: false)
    }

    /// Add VFR sectional chart overlay from local MBTiles file
    func addSectionalOverlay(mbtilesPath: URL) {
        guard let mapView else { return }
        let source = MLNRasterTileSource(
            identifier: "vfr-sectional",
            tileURLTemplates: ["mbtiles://\(mbtilesPath.path)/{z}/{x}/{y}.png"],
            options: [
                .minimumZoomLevel: 6,
                .maximumZoomLevel: 12,
                .tileSize: 256
            ]
        )
        let layer = MLNRasterStyleLayer(identifier: "vfr-sectional-layer", source: source)
        layer.rasterOpacity = NSExpression(forConstantValue: 0.85)
        mapView.style?.addSource(source)
        mapView.style?.addLayer(layer)
    }

    /// Update visible layers based on zoom level
    func updateVisibleLayers(for zoomLevel: Double) {
        guard let style = mapView?.style else { return }

        // Sectional chart: visible at zoom 6-12
        style.layer(withIdentifier: "vfr-sectional-layer")?.isVisible = (6...12).contains(Int(zoomLevel))

        // Airports: labels at zoom 8+, icons at zoom 6+
        style.layer(withIdentifier: "airport-labels")?.isVisible = zoomLevel >= 8
        style.layer(withIdentifier: "airport-icons")?.isVisible = zoomLevel >= 6

        // Airspace boundaries: visible at zoom 7+
        style.layer(withIdentifier: "airspace-boundaries")?.isVisible = zoomLevel >= 7

        // Weather dots: visible at zoom 5-10
        style.layer(withIdentifier: "weather-dots")?.isVisible = (5...10).contains(Int(zoomLevel))

        // Navaids: visible at zoom 8+
        style.layer(withIdentifier: "navaid-icons")?.isVisible = zoomLevel >= 8
    }
}

extension MapService: MLNMapViewDelegate {
    func mapView(_ mapView: MLNMapView, regionDidChangeAnimated animated: Bool) {
        updateVisibleLayers(for: mapView.zoomLevel)
    }

    func mapView(_ mapView: MLNMapView, didSelect annotation: MLNAnnotation) {
        // Handle airport tap → show info sheet
    }
}
```

#### 8.5.5 Recording Integration

`EFBRecordingCoordinator` bridges SFR's `FlightManager` with EFB-specific services (map tracking, database writes).

```swift
import Combine
import SFRCore

@MainActor
final class EFBRecordingCoordinator: ObservableObject {
    // Published state for UI
    @Published var isRecording: Bool = false
    @Published var currentFlight: Flight?
    @Published var recordingDuration: TimeInterval = 0
    @Published var currentPhase: FlightPhaseType = .preflight

    // Bridge between SFR and EFB
    private let flightManager: FlightManager      // SFR's recording orchestrator
    private let mapService: MapService             // EFB's map engine
    private let databaseManager: DatabaseManagerProtocol
    private var cancellables = Set<AnyCancellable>()
    private var durationTimer: Timer?

    init(flightManager: FlightManager, mapService: MapService, databaseManager: DatabaseManagerProtocol) {
        self.flightManager = flightManager
        self.mapService = mapService
        self.databaseManager = databaseManager
        bindFlightManagerState()
    }

    /// Bind SFR FlightManager state to EFB UI state
    private func bindFlightManagerState() {
        flightManager.$recordingState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.isRecording = (state == .recording)
            }
            .store(in: &cancellables)

        flightManager.$currentFlight
            .receive(on: DispatchQueue.main)
            .assign(to: &$currentFlight)

        flightManager.$currentPhase
            .receive(on: DispatchQueue.main)
            .assign(to: &$currentPhase)
    }

    func armRecording() async throws {
        try await flightManager.arm()
    }

    func startRecording() async throws {
        try await flightManager.startRecording()
        startDurationTimer()
    }

    func stopRecording() async throws {
        stopDurationTimer()
        try await flightManager.stopRecording()
        // Persist flight record to SwiftData
        if let flight = currentFlight {
            // Save to logbook via database manager
        }
    }

    private func startDurationTimer() {
        durationTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.recordingDuration += 1.0
            }
        }
    }

    private func stopDurationTimer() {
        durationTimer?.invalidate()
        durationTimer = nil
    }
}
```

#### 8.5.6 Power Management

`PowerManager` monitors battery state and adaptively degrades services to extend flight time.

```swift
import UIKit
import Combine

@MainActor
final class PowerManager: ObservableObject {
    @Published var batteryLevel: Double = 1.0      // 0.0 - 1.0
    @Published var batteryState: UIDevice.BatteryState = .unknown
    @Published var powerState: PowerState = .normal

    private var cancellables = Set<AnyCancellable>()

    enum PowerState: String, CaseIterable {
        case normal              // Full functionality
        case batteryConscious    // < 20% — reduce non-essential services
        case emergency           // < 10% — minimum viable operation

        var gpsUpdateInterval: TimeInterval {
            switch self {
            case .normal: return 1.0              // 1 Hz
            case .batteryConscious: return 3.0    // 0.33 Hz
            case .emergency: return 5.0           // 0.2 Hz
            }
        }

        var mapTargetFPS: Int {
            switch self {
            case .normal: return 60
            case .batteryConscious: return 30
            case .emergency: return 15
            }
        }

        var transcriptionEnabled: Bool {
            switch self {
            case .normal, .batteryConscious: return true
            case .emergency: return false
            }
        }

        var weatherRefreshInterval: TimeInterval {
            switch self {
            case .normal: return 900              // 15 minutes
            case .batteryConscious: return 1800   // 30 minutes
            case .emergency: return .infinity     // No refresh
            }
        }
    }

    init() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        startMonitoring()
    }

    private func startMonitoring() {
        // Poll battery every 30 seconds
        Timer.publish(every: 30, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateBatteryState()
            }
            .store(in: &cancellables)

        updateBatteryState()
    }

    private func updateBatteryState() {
        batteryLevel = Double(UIDevice.current.batteryLevel)
        batteryState = UIDevice.current.batteryState

        // Determine power state based on battery level
        if batteryLevel < 0.10 && batteryState != .charging {
            powerState = .emergency
        } else if batteryLevel < 0.20 && batteryState != .charging {
            powerState = .batteryConscious
        } else {
            powerState = .normal
        }
    }
}
```

#### 8.5.7 Chart Management

`ChartManager` handles the full lifecycle of VFR chart tiles: download, integrity validation, local cache, and cycle expiration.

```swift
actor ChartManager {
    private let fileManager = FileManager.default
    private let chartsDirectory: URL
    private var downloadTasks: [String: URLSessionDownloadTask] = [:]

    @Published var downloadProgress: [String: Double] = [:]  // regionID → 0.0-1.0
    @Published var downloadedRegions: [ChartRegion] = []

    init() {
        let appSupport = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        self.chartsDirectory = appSupport.appendingPathComponent("Charts", isDirectory: true)
        try? fileManager.createDirectory(at: chartsDirectory, withIntermediateDirectories: true)
    }

    /// Download a chart region's MBTiles file
    func download(region: ChartRegion, from url: URL) async throws -> URL {
        let destinationURL = chartsDirectory.appendingPathComponent("\(region.id).mbtiles")

        // Resumable download
        let (tempURL, response) = try await URLSession.shared.download(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw EFBError.chartDownloadFailed(region.id)
        }

        // Validate integrity (check it's a valid SQLite/MBTiles file)
        guard try await validateMBTiles(at: tempURL) else {
            throw EFBError.chartCorrupted(region.id)
        }

        // Move to final location (atomic)
        if fileManager.fileExists(atPath: destinationURL.path) {
            try fileManager.removeItem(at: destinationURL)
        }
        try fileManager.moveItem(at: tempURL, to: destinationURL)

        return destinationURL
    }

    /// Validate MBTiles file integrity
    private func validateMBTiles(at url: URL) async throws -> Bool {
        // Check SQLite header magic bytes
        let handle = try FileHandle(forReadingFrom: url)
        let header = handle.readData(ofLength: 16)
        handle.closeFile()
        return header.starts(with: "SQLite format 3".data(using: .utf8)!)
    }

    /// Check for expired chart regions
    func expiredRegions() -> [ChartRegion] {
        downloadedRegions.filter { $0.expirationDate < Date() }
    }

    /// Remove a chart region's files
    func removeRegion(_ regionID: String) throws {
        let path = chartsDirectory.appendingPathComponent("\(regionID).mbtiles")
        if fileManager.fileExists(atPath: path.path) {
            try fileManager.removeItem(at: path)
        }
        downloadedRegions.removeAll { $0.id == regionID }
    }

    /// Total storage used by charts
    func storageUsed() throws -> UInt64 {
        let contents = try fileManager.contentsOfDirectory(at: chartsDirectory,
                                                           includingPropertiesForKeys: [.fileSizeKey])
        return try contents.reduce(0) { total, url in
            let values = try url.resourceValues(forKeys: [.fileSizeKey])
            return total + UInt64(values.fileSize ?? 0)
        }
    }
}
```

#### 8.5.8 Error Handling

Centralized error types with user-facing messages and unique identifiers for logging.

```swift
import Foundation

enum EFBError: LocalizedError, Identifiable {
    case gpsUnavailable
    case chartExpired(Date)
    case chartDownloadFailed(String)
    case chartCorrupted(String)
    case weatherStale(TimeInterval)
    case weatherFetchFailed(underlying: Error)
    case recordingFailed(underlying: Error)
    case databaseCorrupted
    case databaseMigrationFailed(underlying: Error)
    case nasrImportFailed(underlying: Error)
    case networkUnavailable
    case airportNotFound(String)

    var id: String {
        switch self {
        case .gpsUnavailable: return "gps_unavailable"
        case .chartExpired: return "chart_expired"
        case .chartDownloadFailed(let id): return "chart_download_\(id)"
        case .chartCorrupted(let id): return "chart_corrupted_\(id)"
        case .weatherStale: return "weather_stale"
        case .weatherFetchFailed: return "weather_fetch"
        case .recordingFailed: return "recording_failed"
        case .databaseCorrupted: return "db_corrupted"
        case .databaseMigrationFailed: return "db_migration"
        case .nasrImportFailed: return "nasr_import"
        case .networkUnavailable: return "network_unavailable"
        case .airportNotFound(let id): return "airport_not_found_\(id)"
        }
    }

    var errorDescription: String? {
        switch self {
        case .gpsUnavailable:
            return "GPS is unavailable. Ensure Location Services are enabled and this iPad has GPS hardware (cellular models only)."
        case .chartExpired(let date):
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return "VFR chart expired on \(formatter.string(from: date)). Download the current chart cycle for accurate navigation."
        case .chartDownloadFailed(let regionID):
            return "Failed to download chart region '\(regionID)'. Check your internet connection and try again."
        case .chartCorrupted(let regionID):
            return "Chart file for '\(regionID)' is corrupted. Delete and re-download."
        case .weatherStale(let age):
            let minutes = Int(age / 60)
            return "Weather data is \(minutes) minutes old and may not reflect current conditions."
        case .weatherFetchFailed:
            return "Unable to fetch weather data. Using cached data if available."
        case .recordingFailed:
            return "Flight recording encountered an error. GPS tracking continues."
        case .databaseCorrupted:
            return "Aviation database is corrupted. Re-import NASR data from Settings."
        case .databaseMigrationFailed:
            return "Database upgrade failed. Please reinstall the app or contact support."
        case .nasrImportFailed:
            return "Failed to import FAA airport data. Check storage space and try again."
        case .networkUnavailable:
            return "No internet connection. Offline features remain available."
        case .airportNotFound(let id):
            return "Airport '\(id)' not found in the database."
        }
    }

    /// Severity level for UI treatment
    var severity: ErrorSeverity {
        switch self {
        case .gpsUnavailable, .databaseCorrupted, .recordingFailed:
            return .critical
        case .chartExpired, .weatherStale, .chartCorrupted:
            return .warning
        case .networkUnavailable, .airportNotFound, .weatherFetchFailed:
            return .info
        case .chartDownloadFailed, .databaseMigrationFailed, .nasrImportFailed:
            return .error
        }
    }
}

enum ErrorSeverity {
    case critical   // Red banner, persistent until resolved
    case error      // Red toast, auto-dismiss after 5s
    case warning    // Yellow toast, auto-dismiss after 3s
    case info       // Blue toast, auto-dismiss after 2s
}
```

#### 8.5.9 Testing Architecture

Protocol-based mocks enable comprehensive unit testing without real GPS, databases, or network.

```swift
// MARK: - Protocols for Testability

protocol LocationManagerProtocol: AnyObject {
    var location: CLLocation? { get }
    var heading: CLHeading? { get }
    var locationPublisher: AnyPublisher<CLLocation, Never> { get }
    func requestAuthorization()
    func startUpdating()
    func stopUpdating()
}

protocol NetworkManagerProtocol: Sendable {
    func fetch<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T
    func download(from url: URL, to destination: URL) async throws
    var isConnected: Bool { get }
}

protocol AudioManagerProtocol: AnyObject {
    func startRecording(quality: AudioQualityProfile) throws
    func stopRecording() throws -> URL
    var isRecording: Bool { get }
}

// MARK: - Mock Implementations

final class MockLocationManager: LocationManagerProtocol {
    var location: CLLocation?
    var heading: CLHeading?
    private let locationSubject = PassthroughSubject<CLLocation, Never>()
    var locationPublisher: AnyPublisher<CLLocation, Never> { locationSubject.eraseToAnyPublisher() }

    func requestAuthorization() {}
    func startUpdating() {}
    func stopUpdating() {}

    /// Inject a test location
    func simulateLocation(_ location: CLLocation) {
        self.location = location
        locationSubject.send(location)
    }

    /// Simulate a GPS track (e.g., KPAO to KSQL)
    func simulateTrack(_ points: [CLLocation], interval: TimeInterval = 1.0) {
        for (index, point) in points.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + interval * Double(index)) {
                self.simulateLocation(point)
            }
        }
    }
}

final class MockDatabaseManager: DatabaseManagerProtocol {
    var airports: [Airport] = []
    var weatherCache: [String: WeatherCache] = [:]

    func airport(byICAO icao: String) async throws -> Airport? {
        airports.first { $0.icao == icao }
    }

    func airports(near coordinate: CLLocationCoordinate2D, radiusNM: Double) async throws -> [Airport] {
        airports // Return all for testing
    }

    func searchAirports(query: String, limit: Int) async throws -> [Airport] {
        airports.filter { $0.icao.contains(query.uppercased()) || $0.name.localizedCaseInsensitiveContains(query) }
    }

    // ... remaining protocol methods with simple test implementations
}

// MARK: - Test Structure

/*
efb-212Tests/
├── ViewModelTests/
│   ├── MapViewModelTests.swift
│   ├── WeatherViewModelTests.swift
│   └── FlightPlanViewModelTests.swift
├── ServiceTests/
│   ├── WeatherServiceTests.swift
│   ├── ChartManagerTests.swift
│   ├── PowerManagerTests.swift
│   └── SecurityManagerTests.swift
├── DataTests/
│   ├── AviationDatabaseTests.swift
│   ├── DatabaseManagerTests.swift
│   └── ModelTests.swift
├── IntegrationTests/
│   ├── RecordingCoordinatorTests.swift
│   └── FlightFlowTests.swift
└── Mocks/
    ├── MockLocationManager.swift
    ├── MockDatabaseManager.swift
    ├── MockNetworkManager.swift
    └── MockAudioManager.swift
*/
```

#### 8.5.10 iPad & Accessibility

`DeviceCapabilities` detects hardware features at launch. The app adapts layout to size classes and supports VoiceOver and Dynamic Type.

```swift
import UIKit

struct DeviceCapabilities {
    let hasGPS: Bool
    let hasCellular: Bool
    let screenSize: CGSize
    let deviceModel: String
    let processorGeneration: String
    let totalMemoryGB: Double

    static func detect() -> DeviceCapabilities {
        let device = UIDevice.current
        let screen = UIScreen.main.bounds.size
        let processInfo = ProcessInfo.processInfo

        // WiFi-only iPads don't have GPS — detect via heading availability
        let hasGPS = CLLocationManager.headingAvailable()

        // Cellular detection via CoreTelephony
        let hasCellular = hasGPS // Cellular models have GPS; WiFi-only don't

        return DeviceCapabilities(
            hasGPS: hasGPS,
            hasCellular: hasCellular,
            screenSize: screen,
            deviceModel: device.model,
            processorGeneration: processInfo.processorDescription,
            totalMemoryGB: Double(processInfo.physicalMemory) / 1_073_741_824
        )
    }
}

// MARK: - Size Class Adaptation

/*
Layout strategy:
- Regular width + Regular height (iPad landscape): Full three-column layout
  - Left sidebar (airport search, weather, flight plan)
  - Center map (primary)
  - Right sidebar (recording controls)
  - Bottom instrument strip

- Regular width + Compact height (iPad portrait): Two-column layout
  - Collapsible sidebar overlays map
  - Recording controls in toolbar
  - Bottom instrument strip

- Compact (iPhone, if ever supported): Single column
  - Full-screen map
  - Sheet-based panels
  - Tab bar navigation
*/

// MARK: - Accessibility

/*
VoiceOver support:
- Map: Announce ownship position, heading, speed on focus
- Airport dots: "Airport KPAO, Palo Alto, 2 miles northwest"
- Weather dots: "KPAO weather: VFR, ceiling 5,000, visibility 10 miles"
- Instrument strip: Each value is a separate accessible element
- Recording status: "Recording active, 45 minutes, cruise phase"

Dynamic Type:
- All text uses `.preferredFont(forTextStyle:)` or SwiftUI `.font(.body)`
- Instrument strip numbers use `.monospacedDigit` for stable layout
- Minimum touch target: 44x44 points for all interactive elements
- High contrast mode: alternative colors for flight category dots
*/
```

#### 8.5.11 Security Architecture

`SecurityManager` handles Keychain storage and Secure Enclave key generation for flight recording encryption.

```swift
import Security
import CryptoKit

actor SecurityManager {
    private let keychainService = "com.openefb.app"
    private let encryptionKeyTag = "com.openefb.flight-encryption"

    // MARK: - Keychain Operations

    func store(key: String, value: Data) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: key,
            kSecValueData as String: value,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        ]

        // Delete existing item if present
        SecItemDelete(query as CFDictionary)

        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw EFBError.recordingFailed(underlying: NSError(domain: "Keychain", code: Int(status)))
        }
    }

    func retrieve(key: String) throws -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess else {
            if status == errSecItemNotFound { return nil }
            throw EFBError.recordingFailed(underlying: NSError(domain: "Keychain", code: Int(status)))
        }

        return result as? Data
    }

    // MARK: - Secure Enclave Key Generation

    /// Generate or retrieve an encryption key using Secure Enclave
    func getOrCreateEncryptionKey() throws -> SecKey {
        // Try to retrieve existing key
        let retrieveQuery: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: encryptionKeyTag.data(using: .utf8)!,
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecReturnRef as String: true
        ]

        var keyRef: AnyObject?
        var status = SecItemCopyMatching(retrieveQuery as CFDictionary, &keyRef)

        if status == errSecSuccess, let key = keyRef {
            return key as! SecKey
        }

        // Generate new key in Secure Enclave
        let accessControl = SecAccessControlCreateWithFlags(
            nil,
            kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly,
            .privateKeyUsage,
            nil
        )!

        let attributes: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrKeySizeInBits as String: 256,
            kSecAttrTokenID as String: kSecAttrTokenIDSecureEnclave,
            kSecPrivateKeyAttrs as String: [
                kSecAttrIsPermanent as String: true,
                kSecAttrApplicationTag as String: encryptionKeyTag.data(using: .utf8)!,
                kSecAttrAccessControl as String: accessControl
            ]
        ]

        var error: Unmanaged<CFError>?
        guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
            throw EFBError.recordingFailed(underlying: error!.takeRetainedValue())
        }

        return privateKey
    }

    // MARK: - Consent Tracking

    struct ConsentRecord: Codable {
        let type: ConsentType
        let granted: Bool
        let timestamp: Date
        let appVersion: String
    }

    enum ConsentType: String, Codable {
        case locationTracking
        case audioRecording
        case speechRecognition
        case cloudSync
        case analytics
    }

    func recordConsent(_ type: ConsentType, granted: Bool) throws {
        let record = ConsentRecord(
            type: type,
            granted: granted,
            timestamp: Date(),
            appVersion: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
        )
        let data = try JSONEncoder().encode(record)
        try store(key: "consent_\(type.rawValue)", value: data)
    }
}
```

#### 8.5.12 Cross-Cutting Concerns

**Dependency Injection via Protocols**

All services are injected via protocols, enabling test mocks and alternative implementations.

```swift
// App entry point with DI
@main
struct efb_212App: App {
    @StateObject private var appState: AppState

    init() {
        // Production dependencies
        let locationManager = LocationManager.shared
        let databaseManager = DatabaseManager()
        let weatherService = WeatherService()

        _appState = StateObject(wrappedValue: AppState(
            locationManager: locationManager,
            databaseManager: databaseManager,
            weatherService: weatherService
        ))
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
        .modelContainer(for: [
            AircraftProfileModel.self,
            PilotProfileModel.self,
            FlightRecordModel.self
        ])
    }
}
```

**Background Processing**

```swift
import BackgroundTasks

extension efb_212App {
    func registerBackgroundTasks() {
        // Chart update check (runs daily when on WiFi + power)
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: "com.openefb.chart-update",
            using: nil
        ) { task in
            self.handleChartUpdate(task: task as! BGProcessingTask)
        }

        // Weather pre-fetch (runs every 30 min)
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: "com.openefb.weather-refresh",
            using: nil
        ) { task in
            self.handleWeatherRefresh(task: task as! BGAppRefreshTask)
        }
    }

    func scheduleChartUpdateCheck() {
        let request = BGProcessingTaskRequest(identifier: "com.openefb.chart-update")
        request.requiresNetworkConnectivity = true
        request.requiresExternalPower = true  // Don't drain battery for background chart downloads
        try? BGTaskScheduler.shared.submit(request)
    }

    func scheduleWeatherRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.openefb.weather-refresh")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 30 * 60) // 30 minutes
        try? BGTaskScheduler.shared.submit(request)
    }
}
```

**Memory Management**

```swift
/*
Memory management strategy for map-heavy aviation app:

1. Lazy tile loading:
   - MapLibre handles tile caching internally (default 50MB cache)
   - Only load tiles for visible viewport + 1 tile buffer
   - Unload tiles when scrolled out of view

2. Aggressive cache cleanup:
   - Weather cache: evict entries older than 2 hours
   - Airport query cache: LRU with 100-entry limit
   - Image cache: 50MB limit, LRU eviction

3. Weak references:
   - ViewModels hold weak refs to services (services outlive VMs)
   - Map annotations use weak delegate references
   - Combine subscriptions properly cancelled in deinit

4. Memory warnings:
   - On `.didReceiveMemoryWarning`: clear weather cache, trim map tile cache
   - Release non-visible view controller resources
   - Log memory pressure events for debugging
*/
```

**Network Layer**

```swift
/// Resilient network client with retry, resumable downloads, and offline queue
actor NetworkManager: NetworkManagerProtocol {
    private let session: URLSession
    private let maxRetries = 3
    private let retryDelay: TimeInterval = 2.0
    var isConnected: Bool { NWPathMonitor().currentPath.status == .satisfied }

    init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 300
        config.waitsForConnectivity = true          // Auto-retry when connectivity returns
        config.allowsCellularAccess = true
        self.session = URLSession(configuration: config)
    }

    func fetch<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T {
        var lastError: Error?

        for attempt in 0..<maxRetries {
            do {
                let (data, response) = try await session.data(from: url)
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw EFBError.networkUnavailable
                }
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                lastError = error
                if attempt < maxRetries - 1 {
                    try await Task.sleep(for: .seconds(retryDelay * Double(attempt + 1)))
                }
            }
        }

        throw lastError ?? EFBError.networkUnavailable
    }

    func download(from url: URL, to destination: URL) async throws {
        let (tempURL, response) = try await session.download(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw EFBError.networkUnavailable
        }
        try FileManager.default.moveItem(at: tempURL, to: destination)
    }
}
```

---

## 9. Offline-First Strategy

### Design Principle

> Everything a pilot needs in flight works without internet. Pre-flight preparation downloads what's needed. Stale data is clearly marked, never silently hidden.

### What Works Offline

| Feature | Offline Status | Notes |
|---------|---------------|-------|
| Moving map + ownship | Full | GPS + cached tiles |
| VFR sectional charts | Full | Pre-downloaded mbtiles |
| Airport database | Full | Local SQLite from NASR |
| Airport info (runways, freqs) | Full | Local SQLite |
| Nearest airport | Full | Local spatial query |
| Flight planning (distance/time) | Full | Local calculation |
| Flight recording (GPS + audio) | Full | Local file storage |
| Transcription | Full | Apple on-device speech |
| AI debrief (on-device) | Full | Apple Foundation Models |
| METAR/TAF weather | Cached | Shows last fetch + age badge |
| TFRs | Cached | Shows last fetch + age badge |
| PIREPs | Cached | Shows last fetch + age badge |
| AI debrief (cloud) | Offline unavailable | Falls back to on-device |
| Chart updates | Offline unavailable | Queued for next connection |
| NASR data updates | Offline unavailable | Queued for next connection |

### Data Currency & Staleness

**AIRAC cycle management:**
- VFR sectional charts: 56-day cycle. App checks for new cycle on launch when connected
- NASR airport data: 28-day cycle. Same update check pattern
- Charts remain usable past expiration with a prominent "EXPIRED" banner and date
- NASR data remains usable past expiration with a warning

**Weather staleness indicators:**
- METAR age badge: Green (< 30 min), Yellow (30-60 min), Red (> 60 min), Gray (> 2 hr — "STALE")
- TAF age badge: Green (< 2 hr), Yellow (2-6 hr), Red (> 6 hr)
- TFR: Shows "Last updated: [time]"

### Download Management

**Pre-flight download checklist (automatic on WiFi):**
1. Check for new NASR cycle → download if available (~200 MB compressed, ~50 MB parsed)
2. Check for new VFR chart cycle → prompt user for download (50-200 MB per region)
3. Fetch weather for planned route → cache locally
4. Fetch active TFRs → cache locally

**Storage management UI:**
- Per-region chart download with size indicator
- "Download for flight" — auto-download charts covering planned route
- Clear old chart cycles (keep current + one prior)
- Flight recording storage usage and cleanup

### Background Refresh

- iOS Background App Refresh for weather pre-fetch
- Background download tasks for chart/NASR updates (BGProcessingTask)
- Push notification when new chart cycle is available (optional)

---

## 10. Code Reuse Plan

### SFR Codebase Inventory

The Sovereign Flight Recorder project (`~/sovereign-flight-recorder/`) contains 35 Swift files, ~300KB, 7,000+ lines of production-quality code. The following modules are directly reusable:

| SFR Module | Files | LOC (est.) | Reuse in OpenEFB |
|-----------|-------|------------|-------------------|
| **Models** | `Flight.swift`, `Enums.swift` | ~500 | Core data models: Flight, TrackPoint, TranscriptSegment, DebriefSummary, RadioScore, LogEntry, KeyMoment, FlightPhase, FlightMetadata + all enums |
| **GPS** | `TrackLogRecorder.swift`, `AirportDatabase.swift`, `FlightPhaseDetector.swift` | ~500 | GPS engine, airborne detection, spatial airport queries, phase detection |
| **Audio** | `CockpitAudioEngine.swift`, `AudioFileManager.swift` | ~400 | Cockpit-optimized audio recording with quality profiles |
| **Transcription** | `CockpitTranscriptionEngine.swift`, `AviationVocabularyProcessor.swift` | ~600 | Real-time speech-to-text + aviation vocabulary post-processing |
| **AI/Debrief** | `FlightDebriefEngine.swift`, `ClearanceExtractor.swift` | ~500 | On-device + cloud AI debrief generation |
| **Compliance** | `ComplianceModels.swift`, `ComplianceEngine.swift` | ~400 | PilotProfile, AircraftProfile, currency/airworthiness checks |
| **Security** | `EncryptedFlightStore.swift`, `ConsentManager.swift` | ~300 | AES-256 encryption, Secure Enclave keys, consent tracking |
| **Export** | `FlightExporter.swift` | ~300 | GPX, KML, CSV, ForeFlight CSV export |
| **Orchestration** | `FlightManager.swift` | ~225 | Flight recording lifecycle state machine |

### Extraction Strategy

**Approach:** Extract SFR code into independent SPM packages. OpenEFB imports these packages as dependencies. SFR app also imports them, becoming a thin wrapper.

**New SPM package structure for extracted SFR code:**

```
SFRPackages/
├── Package.swift
├── Sources/
│   ├── SFRCore/           # Flight, TrackPoint, TranscriptSegment, enums, extensions
│   ├── SFRAudio/          # CockpitAudioEngine, AudioFileManager, AudioQualityProfile
│   ├── SFRGPS/            # TrackLogRecorder, FlightPhaseDetector, airborne detection
│   ├── SFRTranscription/  # CockpitTranscriptionEngine, AviationVocabularyProcessor
│   ├── SFRDebrief/        # FlightDebriefEngine, ClearanceExtractor
│   ├── SFRCompliance/     # ComplianceModels, ComplianceEngine, currency checks
│   ├── SFRSecurity/       # EncryptedFlightStore, ConsentManager
│   └── SFRExport/         # FlightExporter (GPX, KML, CSV, ForeFlight)
└── Tests/
    ├── SFRCoreTests/
    ├── SFRAudioTests/
    ├── SFRGPSTests/
    ├── SFRTranscriptionTests/
    └── SFRExportTests/
```

**Dependency graph:**

```
SFRCore ← (no dependencies)
SFRAudio ← SFRCore
SFRGPS ← SFRCore
SFRTranscription ← SFRCore
SFRDebrief ← SFRCore, SFRTranscription
SFRCompliance ← SFRCore
SFRSecurity ← SFRCore
SFRExport ← SFRCore
```

**OpenEFB imports:**

```swift
// OpenEFB Package.swift dependencies
.package(path: "../SFRPackages"),

// Target dependencies
.product(name: "SFRCore", package: "SFRPackages"),
.product(name: "SFRAudio", package: "SFRPackages"),
.product(name: "SFRGPS", package: "SFRPackages"),
.product(name: "SFRTranscription", package: "SFRPackages"),
.product(name: "SFRDebrief", package: "SFRPackages"),
.product(name: "SFRCompliance", package: "SFRPackages"),
.product(name: "SFRSecurity", package: "SFRPackages"),
.product(name: "SFRExport", package: "SFRPackages"),
```

### Modifications Required

| Module | What Changes | Why |
|--------|-------------|-----|
| `AirportDatabase` | Replace hardcoded 130 airports with SwiftNASR-powered SQLite lookups | Need all 20K US airports |
| `TrackLogRecorder` | Add ownship position publishing at display refresh rate | EFB needs continuous map updates, not just recording-rate samples |
| `FlightManager` | Add EFB-specific state (map tracking without recording) | Pilot may want GPS ownship without starting a recording session |
| `ComplianceModels` | Extend `AircraftProfile` with performance data (V-speeds, fuel, W&B) | EFB needs flight planning performance data |
| `PilotProfile` | Extend with certificate type, ratings, total hours | EFB logbook needs fuller pilot profile |
| All modules | Add `public` access modifiers where missing | SPM packages require explicit public API |

---

## 11. Monetization

### Philosophy

> Safety features are never paywalled. The free tier is a fully functional VFR EFB with local flight recording. Premium exists for cloud convenience and advanced AI — features that cost us money to operate.

### Free Tier (Forever Free)

Everything in Phase 1 + local recording:

- Moving map with VFR sectional overlays
- Full US airport database (20K airports)
- METAR/TAF weather with flight category dots
- VFR flight planning (direct routing)
- GPS ownship tracking + instrument strip
- Nearest airport emergency feature
- Aircraft and pilot profiles
- Flight recording (GPS + audio + transcription)
- On-device AI debrief (Apple Foundation Models)
- Flight logbook with ForeFlight CSV import/export
- Currency tracking
- Track replay on map
- TFR/airspace alerting
- GPX/KML/CSV export
- All chart downloads
- Unlimited flights stored locally

### Premium Cloud Tier — $4.99/mo or $39.99/yr

Features that require server-side infrastructure:

| Feature | Description | Why Premium |
|---------|-------------|------------|
| **Cloud AI Debrief** | Enhanced post-flight analysis via Claude API — deeper narrative, pattern recognition across flights, personalized recommendations | API costs per debrief |
| **Cloud Flight Sync** | Sync flight records, logbook, and recordings across devices | Server storage + bandwidth |
| **Flight Archive** | Long-term cloud backup of all flight data | Storage costs |
| **Radio Coach** | AI-powered radio phraseology practice with scenario generation | API costs per session |
| **Collaborative Plans** | Share flight plans with other OpenEFB users | Server infrastructure |
| **Advanced Analytics** | Flight trend analysis (landings improving? fuel efficiency trends? common routes?) across entire history | Compute costs |
| **Priority Chart CDN** | Faster chart tile downloads, priority during new cycle release | CDN bandwidth |

### Pricing Rationale

| Comparison | Price | Notes |
|-----------|-------|-------|
| ForeFlight Basic Plus | $120/yr | Our free tier covers 80% of this |
| ForeFlight Pro Plus | $240/yr | Our $40/yr premium covers comparable AI/analytics |
| Avare (Android) | Free | No premium tier, donation-supported |
| FltPlan Go | Free | Ad-supported, no recording/AI |
| **OpenEFB Free** | **$0** | **Fully functional VFR EFB + recording** |
| **OpenEFB Premium** | **$40/yr** | **Cloud AI + sync + analytics** |

**Target conversion:** 5-10% of active users to premium (comparable to Spotify free-to-paid conversion). At 10,000 active users and 7% conversion, that's 700 premium users x $40/yr = $28,000/yr — enough to cover Claude API costs, CDN hosting, and cloud infrastructure.

### What Is Never Paywalled

The following safety-critical features are always free:
- Moving map with ownship position
- VFR chart overlays
- Weather (METAR/TAF)
- Nearest airport
- TFR alerting
- Airspace proximity warnings
- On-device AI debrief
- All offline capabilities

---

## 12. Regulatory Compliance

### EFB Classification

**Classification:** Class 1 EFB (Portable)

Per FAA Advisory Circular AC 91-78 (Use of Class 1 or Class 2 Electronic Flight Bag) and AC 120-76D:

| Requirement | OpenEFB Status |
|------------|---------------|
| **Type:** Portable, not installed in aircraft | Yes — iPad on kneeboard or yoke mount |
| **Power:** Self-contained (device battery) | Yes — no aircraft power required |
| **Mounting:** Portable mounting (not aircraft-installed) | Yes — RAM mount or kneeboard |
| **FAA approval required?** | **No** — Class 1 portable EFBs do not require TSO, STC, or FAA approval |
| **Can be used as primary reference?** | No — Part 91 allows EFB use, but paper charts should be available as backup |

### Part 91 EFB Guidance (AC 91-78)

- Part 91 operators may use any EFB (Class 1, 2, or 3) without FAA authorization
- EFB must contain current data (charts, databases) — our AIRAC cycle management ensures this
- Pilot is responsible for ensuring data is current and backup is available
- No requirement for redundancy (second EFB) under Part 91, but recommended

### Required Disclaimers

The following disclaimers must appear in the app and App Store listing:

1. **Primary Navigation Disclaimer:**
   > "OpenEFB is provided as a supplemental reference tool. It is NOT intended to be used as a primary means of navigation. Pilots are responsible for maintaining situational awareness through all available means including current paper charts, ATC communication, and visual references."

2. **Data Currency Disclaimer:**
   > "Aviation data (charts, airports, frequencies, airspace) is sourced from the FAA and is subject to change. Always verify information against official FAA publications. Expired data is clearly marked but should not be relied upon for navigation."

3. **Weather Disclaimer:**
   > "Weather information is provided for planning purposes only and may not reflect current conditions. Always obtain an official weather briefing from 1800wxbrief.com or FSS before flight."

4. **GPS Disclaimer:**
   > "iPad GPS accuracy varies by model and conditions. WiFi-only iPads do not have GPS hardware. Cellular iPad GPS is not TSO-certified. Do not rely on iPad GPS as a sole means of position awareness."

5. **Not an FAA-Approved Product:**
   > "OpenEFB has not been tested, approved, or certified by the FAA or any other aviation authority. Use at your own risk."

### WiFi-Only iPad GPS Limitation

**Critical user education:**
- WiFi-only iPads have NO GPS hardware — they use WiFi positioning only (accuracy: ~100m, no altitude, no speed)
- Cellular iPads have GPS/GNSS hardware (accuracy: ~3-5m, altitude, speed)
- The app must detect iPad model at first launch and warn WiFi-only users
- External GPS receivers (Bad Elf, Stratux) can provide GPS to WiFi iPads

**Implementation:**
```swift
// Detect GPS capability
let hasGPS = CLLocationManager.locationServicesEnabled() &&
             CLLocationManager.headingAvailable()
// WiFi-only iPads report headingAvailable = false
```

### Recording Privacy Compliance

For cockpit audio recording features:
- **One-party consent:** Legal in most US states for the pilot recording their own cockpit
- **Two-party consent states:** App displays consent notice if passengers are aboard
- **ATC recording:** Legal — ATC frequencies are public, recording them is permitted
- **Retention policies:** User controls how long recordings are kept (7 days / 90 days / forever / manual)
- **Encryption:** All recordings encrypted at rest (AES-256, Secure Enclave keys)

---

## 13. Technical Risks & Mitigations

### Risk 1: Chart Tile Pipeline Complexity

**Risk:** Converting FAA VFR sectional GeoTIFFs to MBTiles is a multi-step GDAL pipeline that must run server-side every 56 days. If the pipeline breaks, users get no chart updates.

**Impact:** High — no charts = no usable EFB

**Mitigation:**
- Build the tile pipeline as a separate, well-tested CI/CD job (GitHub Actions)
- Use the existing `aviationCharts` open-source project as a starting point
- Maintain two chart cycles on CDN (current + previous) so a pipeline failure doesn't leave users without charts
- Implement pipeline health monitoring with alerts
- Document the pipeline thoroughly so community contributors can maintain it
- Fallback: users can manually download GeoTIFFs and convert locally (power user option)

### Risk 2: MapLibre Performance on Older iPads

**Risk:** Rendering VFR sectional raster tiles over a vector basemap with multiple overlay layers (airspace, weather, route, ownship) may be slow on older iPads (A10 and earlier).

**Impact:** Medium — poor map performance makes the app unusable in flight

**Mitigation:**
- Profile on oldest supported iPad (iPad 6th gen / A10) early in development
- Use MapLibre's tile cache and level-of-detail to limit rendered complexity
- Implement progressive layer loading: only airspace and ownship at low zoom, full detail at high zoom
- Set minimum device requirement to A12 Bionic if A10 proves too slow (iPad Mini 5th gen and later)
- Raster tile quality setting: allow reduced resolution tiles for weaker hardware

### Risk 3: Battery Drain

**Risk:** Running GPS (continuous), map rendering (60fps), audio recording, and speech recognition simultaneously could drain iPad battery in 2-3 hours — less than a typical cross-country flight.

**Impact:** High — dead iPad mid-flight is a safety concern

**Mitigation:**
- SFR's `TrackLogRecorder` already implements adaptive sampling (1s airborne, 5s ground) to reduce GPS power
- SFR's audio profiles include an "endurance" mode (8kHz, 12 hr battery)
- Map rendering: reduce frame rate to 30fps during cruise (no rapid panning)
- Transcription: process in batches rather than continuous streaming
- Display battery-conscious mode when < 20%: reduce GPS rate, pause transcription, dim map
- Prominently show battery level in UI at all times
- Recommend external power (USB-C) for flights > 2 hours
- Profile and optimize: target 4+ hours of full-stack operation on iPad Mini 6

### Risk 4: SwiftNASR Data Completeness

**Risk:** SwiftNASR may not parse all FAA NASR data fields we need, or may have bugs in parsing certain airport records.

**Impact:** Medium — missing frequencies, incorrect runway data, or missing airports

**Mitigation:**
- Evaluate SwiftNASR against a known set of airports (Bay Area test set from `AirportDatabase.swift`)
- Contribute fixes upstream to SwiftNASR for any parsing gaps
- Implement a "report data issue" feature for pilots to flag incorrect data
- Maintain a corrections overlay database for known NASR parsing issues
- Fallback: direct FAA API queries for individual airports if local data is suspect

### Risk 5: SPM Package Extraction Dependencies

**Risk:** Extracting SFR code into SPM packages may surface hidden dependencies between modules, especially around UIKit/SwiftUI imports in service-layer code.

**Impact:** Medium — delays development timeline if extraction is harder than expected

**Mitigation:**
- SFR code already uses `public` access modifiers on most types (designed for library use)
- SFR's `FlightManager.swift` has the only UIKit dependency (`UIDevice` for battery/model) — easy to abstract
- Start extraction with `SFRCore` (models only, no framework dependencies) and validate clean compilation
- Extract one package at a time, running full test suite after each
- Known issue: SFR currently has a flat target structure — use the extraction to properly separate concerns

### Risk 6: App Store Review

**Risk:** Apple may reject the app for various reasons: background GPS usage justification, audio recording privacy concerns, competition with Apple Maps, or the "navigational aid" classification.

**Impact:** Medium — delays launch, may require app modifications

**Mitigation:**
- Background GPS usage: justified by flight recording (same as ForeFlight, Garmin Pilot, etc.)
- Audio recording: implement clear consent flow, privacy nutrition labels, and demonstrate compliance
- Include all required NSLocationAlwaysUsageDescription, NSMicrophoneUsageDescription, NSSpeechRecognitionUsageDescription keys with clear explanations
- Submit with detailed app review notes explaining the aviation use case
- ForeFlight, Garmin Pilot, FlyQ all exist in the App Store — precedent is established
- Open-source status may actually help with review transparency

### Risk 7: Offline Chart Storage Size

**Risk:** Full US VFR sectional coverage could be 3-6 GB, which is significant on 64 GB iPads.

**Impact:** Low-Medium — user frustration, not a functional issue

**Mitigation:**
- Region-based downloads (not full-US-or-nothing)
- Smart download: suggest charts based on pilot's home airport and recent flights
- Aggressive tile compression (WebP instead of PNG for newer iOS)
- Multiple resolution options: standard (1x) vs. high-res (2x)
- Storage usage dashboard with one-tap cleanup of old chart cycles
- "Download for this flight" — only download tiles along planned route

---

## 14. Open Source Strategy

### License

**Choice:** Mozilla Public License 2.0 (MPL-2.0)

**Why MPL-2.0:**
- Copyleft at the file level (not project level like GPL)
- Companies can include our code in proprietary apps if they contribute back changes to our files
- Compatible with App Store distribution (unlike AGPL)
- Used by Mozilla Firefox, LibreOffice — proven at scale
- Balances openness with commercial viability
- Prevents someone from forking, adding a paywall, and competing without contributing back

**Alternative considered:** MIT — too permissive; someone could fork and sell it without contributing anything back. For an aviation safety tool, we want to ensure improvements flow back to the community.

### Repository Structure

```
github.com/openefb/
├── openefb-ios/           # Main iPad app (MPL-2.0)
├── sfr-packages/          # Extracted SFR SPM packages (MPL-2.0)
├── chart-tile-pipeline/   # GDAL-based chart conversion toolchain (MPL-2.0)
├── openefb-api/           # Premium cloud API (private repo)
└── openefb-docs/          # Documentation, contributor guide (CC-BY-4.0)
```

### Community Contribution Model

**Contribution types:**
1. **Code contributions** — Bug fixes, features, optimizations via pull requests
2. **Data validation** — Pilots reporting incorrect airport/frequency/runway data
3. **Beta testing** — TestFlight beta group for pre-release testing
4. **Documentation** — Usage guides, pilot tutorials, API docs
5. **Translations** — Internationalization for non-US pilots
6. **Chart tile hosting** — Community mirrors for chart tile CDN

**Contribution workflow:**
1. Issues for bug reports and feature requests
2. Discussions for architecture decisions and RFC-style proposals
3. Pull requests with required code review
4. CI/CD: SwiftLint, unit tests, UI tests on PR
5. Release cadence: aligned with FAA 28/56-day chart cycles

**Governance:**
- Benevolent Dictator model initially (project creator = final say)
- Core contributor team for merge authority after 10+ accepted PRs
- Public roadmap with community voting on feature priorities
- Monthly community call (Discord or similar)

### Data Pipeline Transparency

All data pipelines are open-source:
- FAA NASR download + parsing scripts
- VFR chart GeoTIFF → MBTiles conversion pipeline
- NOAA weather API client
- TFR fetch and parsing

Pilots can verify exactly what data the app is using and how it's processed. This is a significant trust advantage over closed-source competitors.

---

## 15. Success Metrics

### Phase 1 (MVP Launch — Month 4)

| Metric | Target | Measurement |
|--------|--------|-------------|
| App Store launch | Approved and live | Binary |
| TestFlight beta testers | 200+ | TestFlight analytics |
| App Store downloads (first 30 days) | 1,000+ | App Store Connect |
| Crash-free rate | > 99% | Xcode Organizer |
| App Store rating | 4.0+ stars | App Store Connect |
| GitHub stars | 500+ | GitHub |
| Active contributors | 5+ | GitHub PRs |

### Phase 2 (Differentiators — Month 7)

| Metric | Target | Measurement |
|--------|--------|-------------|
| Monthly active users | 5,000+ | Analytics |
| Flights recorded | 1,000+ total | App analytics |
| AI debriefs generated | 500+ total | Analytics |
| Premium conversion rate | 3-5% | Subscription analytics |
| Premium subscribers | 150-250 | Subscription analytics |
| GitHub contributors | 15+ | GitHub |
| r/flying mentions | 10+ positive threads | Reddit monitoring |

### Phase 3 (Growth — Month 12)

| Metric | Target | Measurement |
|--------|--------|-------------|
| Monthly active users | 15,000+ | Analytics |
| Premium subscribers | 700+ | Subscription analytics |
| Premium ARR | $28,000+ | Revenue |
| Monthly active flights recorded | 2,000+ | Analytics |
| Community pilot reports | 100+/month | App analytics |
| GitHub stars | 3,000+ | GitHub |
| App Store rating | 4.5+ stars | App Store Connect |
| AOPA/aviation press coverage | 2+ articles | Media monitoring |

### Long-Term (Year 2+)

| Metric | Target | Notes |
|--------|--------|-------|
| Monthly active users | 50,000+ | ~10% of US GA EFB market |
| Premium subscribers | 3,500+ | 7% conversion |
| Premium ARR | $140,000+ | Sustainable |
| Open-source contributors | 50+ | Healthy community |
| International expansion | 3+ countries | ICAO data support |

### Pilot Satisfaction KPIs

- Net Promoter Score (NPS): > 40
- "Would you recommend to a fellow pilot?" > 80% yes
- "Has this app improved your flying?" > 60% yes
- "Have you cancelled or reduced your ForeFlight subscription?" — track but don't optimize for this (we're complementary, not hostile)

---

## 16. Key Decisions

| # | Decision | Choice | Alternatives Considered | Rationale |
|---|----------|--------|------------------------|-----------|
| 1 | Flight rules scope | VFR-only MVP | VFR+IFR from day one | 67% of GA hours are VFR. Ships 3-4 months faster. IFR adds massive complexity (procedures, charts, regulatory). Phase 3 adds IFR. |
| 2 | Monetization | Free + open-source, optional premium cloud | Freemium (paywall core features), Ads, Donations only | Mission is accessibility. Avare proves donation model works on Android but doesn't scale. Premium cloud covers real costs (AI API, hosting) without paywalling safety features. |
| 3 | Codebase strategy | New project, import SFR as SPM packages | Fork SFR and extend, Rewrite from scratch | Clean EFB architecture from day one. Reuses 7K+ LOC of proven aviation code. SFR also benefits from package extraction. Avoids cluttering SFR with EFB-specific code. |
| 4 | Differentiators | All four: UX + recording + AI + community | EFB only (no recording), Recording only (no EFB) | Unique combination no competitor offers. Recording + AI debrief is the "wedge" feature. EFB alone is a crowded market. |
| 5 | Map engine | MapLibre Native iOS | Apple MapKit, Google Maps SDK, Mapbox GL | MapLibre is open-source (no API fees), supports raster tile overlays (critical for VFR charts), supports offline mbtiles, and has active community. MapKit lacks raster overlay support. Mapbox charges per-use fees. |
| 6 | Database | Dual: GRDB (aviation) + SwiftData (user) | GRDB-only, SwiftData-only, Core Data, Realm | GRDB for aviation data: R-tree spatial indexes for 20K airport proximity queries, WAL mode, FTS5 search. SwiftData for user data: already scaffolded, CloudKit-ready for premium sync, native SwiftUI integration. Best of both worlds. |
| 7 | Aviation data source | SwiftNASR + FAA direct + NOAA API | Jeppesen ($$), AeroAPI ($), ForeFlight API (proprietary) | All free, all public domain. Same data ForeFlight uses. No vendor lock-in. No API costs. Community can validate. |
| 8 | iPad GPS | Cellular model required (documented clearly) | Support WiFi-only (GPS emulation), External GPS required | WiFi-only iPads have no GPS hardware — this is a hardware limitation, not a software choice. App detects and warns. External GPS (Bad Elf, Stratux) supported as alternative. |
| 9 | License | MPL-2.0 | MIT, GPL-3.0, AGPL-3.0 | File-level copyleft ensures improvements come back without GPL's project-level viral requirement. App Store compatible. Prevents closed-source forks that don't contribute back. |
| 10 | Audio recording integration | Built into EFB (not separate app) | Separate SFR app + EFB app | Pilots won't run two apps. Integrated experience is the differentiator. SFR continues to exist for pilots who want recording-only without EFB. |
| 11 | AI provider | Apple Foundation Models (default) + Claude API (premium) | OpenAI API, Local LLM (llama.cpp), No AI | Apple on-device = free, private, offline. Claude API for premium = high quality, Anthropic alignment with safety. Local LLM too large for iPad. |
| 12 | Chart tile format | MBTiles (SQLite-based) | PMTiles, Raw tile directory, Vector tiles | MBTiles is the standard for offline raster tiles. MapLibre has native MBTiles support. SQLite-based = single file per chart region, easy to download/manage. Vector tiles can't represent raster sectional charts. |

---

## 17. Critical Sources

### FAA Data Sources (All Free, Public Domain)

| Source | URL/Access | Update Cycle | Data |
|--------|-----------|-------------|------|
| **NASR (National Airspace System Resources)** | nfdc.faa.gov | 28 days | Airports, runways, frequencies, navaids, airspace |
| **CIFP (Coded Instrument Flight Procedures)** | aeronav.faa.gov | 28 days | IFR procedures (Phase 3) |
| **d-TPP (Digital Terminal Procedures)** | aeronav.faa.gov | 28 days | Approach plates (Phase 3) |
| **VFR Sectional Charts** | aeronav.faa.gov | 56 days | GeoTIFF raster chart images |
| **VFR Terminal Area Charts** | aeronav.faa.gov | 56 days | GeoTIFF raster chart images |
| **TFR Data** | tfr.faa.gov | Real-time | Temporary flight restrictions |

### Weather Data Sources (All Free, No API Key)

| Source | Endpoint | Rate Limit | Data |
|--------|----------|-----------|------|
| **NOAA Aviation Weather API** | aviationweather.gov/data/api/ | 100 req/min | METARs, TAFs, PIREPs, SIGMETs, AIRMETs |

### Open Source Dependencies

| Package | License | Purpose |
|---------|---------|---------|
| **MapLibre Native iOS** | BSD-2-Clause | Map rendering engine with raster tile overlay support |
| **SwiftNASR** | MIT | FAA NASR data parsing (airports, navaids, airspace) |
| **aviationCharts** | MIT | VFR chart GeoTIFF → MBTiles conversion pipeline |
| **GRDB.swift** | MIT | SQLite database with R-tree spatial indexes |
| **GeoReferencePlates** | MIT | Georeferencing aviation chart plates |

### Existing Codebase (SFR Project)

| File | Path | Key Content |
|------|------|-------------|
| **Flight.swift** | `~/sovereign-flight-recorder/SovereignFlightRecorder/Models/Flight.swift` | Flight, TrackPoint, TranscriptSegment, DebriefSummary, RadioScore, LogEntry, KeyMoment, FlightPhase, FlightMetadata |
| **Enums.swift** | `~/sovereign-flight-recorder/SovereignFlightRecorder/Models/Enums.swift` | RetentionPolicy, Speaker, SegmentClassification, FlightPhaseType, AudioQualityProfile, ClearanceType, KeyMomentType, RecordingState, DebriefSource |
| **TrackLogRecorder.swift** | `~/sovereign-flight-recorder/SovereignFlightRecorder/Services/GPS/TrackLogRecorder.swift` | GPS engine: CLLocationManager, adaptive 1s/5s sampling, airborne hysteresis, CMAltimeter baro altitude, CMMotionManager accelerometer, vertical speed calc, distance calc, nearest airport, GPX/KML/CSV export |
| **AirportDatabase.swift** | `~/sovereign-flight-recorder/SovereignFlightRecorder/Services/GPS/AirportDatabase.swift` | Airport model, nearest airport spatial query, airports-within-radius, hardcoded Bay Area + major US set (~130 airports) |
| **ComplianceModels.swift** | `~/sovereign-flight-recorder/SovereignFlightRecorder/Services/Compliance/ComplianceModels.swift` | PilotProfile (medical, BFR, night currency), AircraftProfile (N-number, tach, annual, transponder, ELT, insurance), ComplianceReport, BookingEligibilityResult |
| **AviationVocabularyProcessor.swift** | `~/sovereign-flight-recorder/SovereignFlightRecorder/Services/Transcription/AviationVocabularyProcessor.swift` | Post-processing pipeline: N-numbers, altitudes, flight levels, headings, frequencies, runways, transponder codes, speeds, ATIS, approach types, waypoints, standard phraseology (MAYDAY, PAN PAN, Roger, Wilco, etc.) |
| **FlightManager.swift** | `~/sovereign-flight-recorder/SovereignFlightRecorder/Services/FlightManager.swift` | Service orchestrator: state machine (idle→armed→recording→stopping→idle), coordinates audio + GPS + transcription + phase detection, auto-start trigger, battery monitoring, airport inference, flight data finalization |
| **Package.swift** | `~/sovereign-flight-recorder/Package.swift` | SPM structure: iOS 17+, Swift 5.9, single flat target (to be refactored into multi-package) |

### Regulatory References

| Document | Number | Relevance |
|----------|--------|-----------|
| **Use of Class 1/2 EFB** | AC 91-78 | Part 91 EFB authorization — Class 1 portable EFBs need no FAA approval |
| **Authorization for Use of EFBs** | AC 120-76D | Part 121/135 EFB requirements (reference for best practices) |
| **General Operating Rules** | 14 CFR Part 91 | Operating rules for general aviation — EFB use, VFR requirements |
| **Pilot Currency** | 14 CFR 61.57 | Recent experience requirements (night currency, instrument currency) |
| **Medical Standards** | 14 CFR Part 67 | Medical certificate classes and durations |
| **BasicMed** | 14 CFR 68 | BasicMed alternative to traditional medical |

---

## 18. Development Sprints (Phase 1)

Phase 1 is broken into 6 two-week sprints. Each sprint has specific file deliverables, acceptance criteria, and visual verification steps. Sprints should be executed in order — each builds on the previous.

### Sprint 1: Foundation (Weeks 1-2)

**Focus:** Project structure, core state management, database schema, SwiftData models, basic tab navigation shell.

**Files to Create:**

| File | Description |
|------|-------------|
| `Core/AppState.swift` | `@MainActor ObservableObject` global state coordinator (see §8.5.2) |
| `Core/EFBError.swift` | Centralized error enum (see §8.5.8) |
| `Core/DeviceCapabilities.swift` | Device detection struct (see §8.5.10) |
| `Core/Extensions/CLLocation+Aviation.swift` | Nautical mile conversions, bearing calculations |
| `Core/Extensions/Date+Aviation.swift` | Zulu time formatting, METAR time parsing |
| `Data/DatabaseManager.swift` | `DatabaseManagerProtocol` + coordinator (see §8.5.3) |
| `Data/AviationDatabase.swift` | GRDB setup with R-tree schema, airport table, FTS5 index |
| `Data/Models/AircraftProfile.swift` | SwiftData `@Model` replacing `Item.swift` |
| `Data/Models/PilotProfile.swift` | SwiftData `@Model` |
| `Data/Models/FlightRecord.swift` | SwiftData `@Model` |
| `Views/ContentView.swift` | Replace boilerplate → `TabView` with 5 tabs (Map, Flights, Logbook, Aircraft, Settings) |
| `Services/PowerManager.swift` | Battery monitoring + power state enum (see §8.5.6) |

**Dependencies to Add (Package.swift / Xcode SPM):**

| Package | URL | Version |
|---------|-----|---------|
| GRDB.swift | `https://github.com/groue/GRDB.swift` | Latest stable |

**Acceptance Criteria:**
- [ ] App launches on iPad simulator without crashes
- [ ] Tab bar shows 5 tabs: Map, Flights, Logbook, Aircraft, Settings
- [ ] Tapping each tab navigates to a placeholder view with the tab name
- [ ] `DeviceCapabilities.detect()` correctly identifies simulator vs. device
- [ ] GRDB database creates successfully with airports table and R-tree index
- [ ] SwiftData `ModelContainer` initializes with all three `@Model` types
- [ ] `PowerManager` reports battery level (simulated on simulator)
- [ ] `EFBError` cases produce correct `localizedDescription` strings
- [ ] `Item.swift` is deleted from the project
- [ ] Unit tests pass for `AviationDatabase` schema creation
- [ ] Unit tests pass for `EFBError` descriptions and severity levels

**Visual Verification:**
- App launches → 5-tab bar visible at bottom → each tab shows its name
- No console errors or warnings on launch
- Settings tab shows device capabilities (GPS: yes/no, model name)

---

### Sprint 2: Map Engine (Weeks 3-4)

**Focus:** MapLibre integration, base map rendering, VFR sectional tile overlay for a single test region, ownship GPS dot, north-up/track-up toggle, instrument strip.

**Files to Create:**

| File | Description |
|------|-------------|
| `Services/MapService.swift` | MapLibre wrapper with layer managers (see §8.5.4) |
| `Views/Map/MapView.swift` | `UIViewRepresentable` wrapping `MLNMapView` |
| `Views/Map/InstrumentStripView.swift` | Bottom bar: GS, ALT, VSI, TRK, DTG, ETE |
| `Views/Map/LayerControlsView.swift` | Toggle layers on/off (sheet or popover) |
| `ViewModels/MapViewModel.swift` | Map state, layer visibility, ownship tracking |

**Dependencies to Add:**

| Package | URL | Version |
|---------|-----|---------|
| MapLibre Native iOS | `https://github.com/maplibre/maplibre-gl-native-distribution` | Latest stable |

**Acceptance Criteria:**
- [ ] Map renders with base map tiles (OpenStreetMap or similar)
- [ ] VFR sectional tiles render as overlay at zoom levels 6-12 (test with SF sectional MBTiles)
- [ ] Blue ownship dot appears at current GPS location (on device) or simulated location
- [ ] Ownship dot updates position in real time as GPS updates arrive
- [ ] North-up mode: map always oriented north; track-up mode: map rotates to match heading
- [ ] Toggle between north-up and track-up via toolbar button
- [ ] Two-finger rotate gesture works on the map
- [ ] Pinch zoom works smoothly (60fps target)
- [ ] Instrument strip at bottom shows: GS, ALT, VSI, TRK (live from GPS)
- [ ] Layer controls allow toggling sectional overlay on/off
- [ ] Map performance: <16ms frame time at zoom level 10 on iPad Air

**Visual Verification:**
- Map tab shows full-screen map with sectional chart overlay visible
- Blue dot (ownship) visible on map tracking simulated or real position
- Bottom instrument strip shows numeric values: "GS: 0 kts | ALT: 50' | VSI: 0 fpm | TRK: 0°"
- Pinch to zoom in/out → sectional chart detail changes, base map visible when zoomed out past level 6
- Two-finger rotate → map rotates, compass indicator updates
- Toggle track-up → map orients to heading; toggle north-up → map snaps to north

---

### Sprint 3: Aviation Data (Weeks 5-6)

**Focus:** SwiftNASR integration, full airport database import (GRDB + R-tree), airport search (FTS5), airport info sheet (tap on map), frequency/runway display.

**Files to Create:**

| File | Description |
|------|-------------|
| `Views/Map/AirportInfoSheet.swift` | Airport detail popover: runways, frequencies, weather, remarks |
| `Views/Components/SearchBar.swift` | Airport/navaid search input |
| `Views/Components/FlightCategoryDot.swift` | VFR/MVFR/IFR/LIFR colored dot component |

**Dependencies to Add:**

| Package | URL | Version |
|---------|-----|---------|
| SwiftNASR | SPM (find latest) | Latest stable |

**Acceptance Criteria:**
- [ ] NASR data downloaded and parsed via SwiftNASR (or bundled test dataset)
- [ ] ~20,000 US airports stored in GRDB with R-tree spatial index
- [ ] Airport search: typing "KPAO" returns Palo Alto Airport as first result
- [ ] Airport search: typing "Palo Alto" returns KPAO via FTS5 full-text search
- [ ] Tap airport dot on map → info sheet appears with correct data
- [ ] Info sheet shows: identifier, name, elevation, runways (length/width/surface), frequencies (CTAF, tower, ATIS, etc.)
- [ ] Airport dots appear on map at zoom level 6+, labels at zoom 8+
- [ ] `nearestAirports(to:count:)` returns correct results sorted by distance
- [ ] R-tree spatial query performs in <50ms for 5-airport lookup
- [ ] FTS5 search performs in <100ms for partial text match

**Visual Verification:**
- Zoom in to Bay Area → airport dots visible (KPAO, KSQL, KNUQ, KSJC, KSFO, KOAK)
- Tap search bar, type "KPAO" → "Palo Alto Airport" appears in results
- Tap KPAO on map → info sheet shows:
  - Name: Palo Alto Airport of Santa Clara County
  - Identifier: KPAO
  - Elevation: 4' MSL
  - Runway 13/31: 2,443' x 70', Asphalt
  - CTAF: 118.6 MHz
  - ATIS: 124.1 MHz (if available)
- Type "San Carlos" in search → KSQL appears in results

---

### Sprint 4: Weather + Flight Planning (Weeks 7-8)

**Focus:** NOAA API client, METAR/TAF fetch + cache, weather map dots (flight category colors), flight plan creation (departure → destination), route line on map, instrument strip with DTG/ETE.

**Files to Create:**

| File | Description |
|------|-------------|
| `Services/WeatherService.swift` | NOAA Aviation Weather API client + caching |
| `ViewModels/WeatherViewModel.swift` | Weather fetch orchestration, staleness tracking |
| `ViewModels/FlightPlanViewModel.swift` | Route editing, distance/time/fuel calculation |
| `Views/Planning/FlightPlanView.swift` | Flight plan creation UI (departure, destination, route) |
| `Views/Components/WeatherBadge.swift` | METAR age/staleness indicator badge |

**Acceptance Criteria:**
- [ ] METAR fetch: `WeatherService.fetchMETAR("KPAO")` returns current observation
- [ ] TAF fetch: `WeatherService.fetchTAF("KPAO")` returns current forecast
- [ ] Weather data cached in ephemeral GRDB database with 15-minute TTL
- [ ] Stale weather displays age badge: Green (<30min), Yellow (30-60min), Red (>60min)
- [ ] Weather dots on map: colored by flight category (Green=VFR, Blue=MVFR, Red=IFR, Magenta=LIFR)
- [ ] Weather dots visible at zoom levels 5-10
- [ ] Flight plan creation: select departure (KPAO) and destination (KSQL)
- [ ] Route line renders on map from departure to destination
- [ ] Distance calculated correctly in nautical miles (KPAO→KSQL ≈ 5 NM)
- [ ] ETE calculated from distance and aircraft cruise speed
- [ ] Instrument strip now shows DTG (distance to go) and ETE (estimated time enroute)
- [ ] Network errors gracefully handled — cached data shown with "offline" indicator

**Visual Verification:**
- Map shows colored dots at weather reporting stations (Bay Area: KPAO, KSQL, KSJC, KSFO, KOAK)
- Dots are correct colors: green for VFR days, appropriate colors for actual conditions
- Tap weather dot → shows METAR text with age badge
- Create flight plan KPAO → KSQL → magenta route line appears on map
- Instrument strip shows "DTG: 5 nm | ETE: 3 min" (at ~100 kts cruise)
- Disconnect network → weather dots still show with yellow/red age badges
- Weather badge shows "15 min ago" or similar staleness indicator

---

### Sprint 5: Nearest + Profiles + Charts (Weeks 9-10)

**Focus:** Nearest airport emergency feature, aircraft profile CRUD, pilot profile CRUD, chart download manager (single test region), Settings view.

**Files to Create:**

| File | Description |
|------|-------------|
| `Views/Aircraft/AircraftProfileView.swift` | Aircraft profile create/edit (N-number, type, fuel, speeds) |
| `Views/Aircraft/PilotProfileView.swift` | Pilot profile create/edit (certs, medical, currency) |
| `Views/Settings/SettingsView.swift` | App settings with chart management section |
| `Views/Settings/ChartDownloadView.swift` | Region picker, download progress, storage usage |
| `ViewModels/SettingsViewModel.swift` | Chart management, app preferences |
| `Services/ChartManager.swift` | Chart download, validation, cache, expiration (see §8.5.7) |
| `Services/SecurityManager.swift` | Keychain storage, consent tracking (see §8.5.11) |

**Acceptance Criteria:**
- [ ] Nearest airport: one-tap shows 5+ airports sorted by distance from current position
- [ ] Nearest list shows: identifier, name, distance (NM), bearing (degrees), longest runway
- [ ] Tap nearest airport → navigates to airport info sheet
- [ ] "Direct To" from nearest → creates flight plan to selected airport
- [ ] Aircraft profile: create, edit, and persist across app launches (SwiftData)
- [ ] Aircraft profile stores: N-number, type, fuel capacity, burn rate, cruise speed, V-speeds
- [ ] Pilot profile: create, edit, and persist across app launches (SwiftData)
- [ ] Pilot profile stores: name, cert number, cert type, medical class/expiry, BFR date
- [ ] Chart download manager: download a single test region MBTiles file
- [ ] Download shows progress bar (0-100%)
- [ ] Downloaded chart validated (SQLite integrity check)
- [ ] Storage usage displayed in Settings (total chart storage in MB)
- [ ] Chart expiration date displayed; expired charts show warning banner

**Visual Verification:**
- Tap "Nearest" button → sorted list appears: "KPAO 0.2nm 045°", "KSQL 5.1nm 135°", etc.
- Aircraft tab → tap "+" → enter N4543A, AA-5B Tiger, 51 gal, 9.5 GPH, 140 kts → save → persists
- Pilot tab → enter pilot details → save → relaunch app → data still there
- Settings → Charts → see region list with download buttons
- Download SF sectional → progress bar fills → "Downloaded" badge appears
- Storage shows "152 MB used for charts"

---

### Sprint 6: Integration + Polish (Weeks 11-12)

**Focus:** Full flight flow (plan → fly → land), layer controls, TFR display, offline validation, performance profiling, error handling, accessibility pass.

**Files to Create:**

| File | Description |
|------|-------------|
| `Views/Flights/FlightListView.swift` | Flight history list |
| `Views/Flights/FlightDetailView.swift` | Single flight detail with tabs |
| `Views/Logbook/LogbookView.swift` | Traditional logbook format |
| `ViewModels/LogbookViewModel.swift` | Logbook entries, currency calculations |
| `Services/EFBRecordingCoordinator.swift` | Bridge SFR ↔ EFB (Phase 2 prep, stub for now) |

**Integration Test: Complete VFR Cross-Country**

Execute the full pilot workflow:
1. Launch app → Map tab with ownship position
2. Create flight plan: KPAO → KSQL
3. Check weather for both airports (METAR/TAF)
4. Review route on map (magenta line, distance, ETE)
5. Check nearest airports along route
6. Fly the route (GPS simulation): ownship moves along route
7. Instrument strip updates in real time (GS, ALT, VSI, TRK, DTG, ETE)
8. Weather dots visible on map during flight
9. Land at KSQL → flight record saved to logbook
10. Verify flight appears in Flights tab and Logbook tab

**Acceptance Criteria:**
- [ ] Complete VFR cross-country flow works end-to-end (KPAO → KSQL)
- [ ] All map layers can be toggled independently via layer controls
- [ ] TFR polygons display on map (if any active TFRs in test area)
- [ ] Offline mode: airplane mode → map still renders (cached tiles), airports still searchable
- [ ] Offline mode: weather shows stale badges but doesn't crash
- [ ] No memory leaks during 30-minute simulated flight (Instruments profiling)
- [ ] Map frame rate: >30fps during active flight tracking
- [ ] App cold launch time: <3 seconds on iPad Air
- [ ] All EFBError cases display appropriate banners/toasts
- [ ] VoiceOver: map announces position, instrument strip values are accessible
- [ ] Dynamic Type: instrument strip readable at accessibility text sizes
- [ ] Flight record persists in SwiftData with correct departure, arrival, duration
- [ ] Logbook view shows flight in traditional format (date, from, to, duration)

**Visual Verification:**
- Full cross-country: plan KPAO → KSQL, see weather at both airports, fly route with ownship tracking
- Layer controls: toggle airspace on/off → Class C boundaries appear/disappear
- Layer controls: toggle weather dots on/off → dots appear/disappear
- Airplane mode → map still works, weather dots show red "STALE" badges
- Instrument strip: numbers update smoothly during simulated flight
- Flights tab: shows completed flight with correct details
- Logbook tab: traditional log entry format with times and route
- Turn on VoiceOver → can navigate all major UI elements
- Increase Dynamic Type to largest → instrument strip and info sheets still readable

---

## 19. Visual Verification Checklist

This checklist defines what "done" looks like for each major UI component. Use these criteria to verify correct implementation during each sprint and for final Phase 1 acceptance testing.

### Map Components

| Component | Verification Criteria |
|-----------|----------------------|
| **VFR Sectional Tiles** | Tiles render at zoom levels 6-12. No white gaps between tiles. Correct geographic alignment (airports on chart match airport dots). Tiles are crisp, not blurry. Opacity ~85% over base map. |
| **Base Map** | Visible when zoomed out past level 6 (sectional not rendered). Shows terrain/streets for orientation. Smooth transition between base and sectional. |
| **Ownship Dot** | Blue dot at current GPS position. Updates within 1 second of position change. Dot stays centered when in track-up mode. Heading indicator arrow visible. |
| **North-Up Mode** | Map oriented with north at top. Ownship dot moves across map. Map does not rotate. Compass shows "N" at top. |
| **Track-Up Mode** | Map rotates so heading is always up. Ownship dot stays centered. Compass rotates to show actual north direction. Smooth rotation animation. |
| **Airport Dots** | Visible at zoom 6+. Labeled at zoom 8+. Towered airports (blue) distinguishable from non-towered (magenta). Tap target is 44x44pt minimum. |
| **Airspace Boundaries** | Class B (blue), C (magenta), D (dashed blue) boundaries visible at zoom 7+. Labels show name and floor/ceiling. Semi-transparent fill. |
| **Route Line** | Magenta line from departure to destination. Line width: 3pt. Great circle path (slight curve on long routes). Waypoint dots at endpoints. |

### Weather Components

| Component | Verification Criteria |
|-----------|----------------------|
| **Flight Category Dots** | Green = VFR (ceiling >3000' AND visibility >5sm). Blue = MVFR (ceiling 1000-3000' OR visibility 3-5sm). Red = IFR (ceiling 500-1000' OR visibility 1-3sm). Magenta = LIFR (ceiling <500' OR visibility <1sm). |
| **Weather Age Badge** | Green badge: <30 minutes old. Yellow badge: 30-60 minutes old. Red badge: >60 minutes old. Gray badge + "STALE": >2 hours old. Badge shows actual age in minutes. |
| **METAR Display** | Raw METAR text shown. Decoded values: wind, visibility, ceiling, temperature, dewpoint, altimeter. Flight category color matches dot. Observation time in Zulu. |
| **TAF Display** | Raw TAF text shown. Valid period clearly indicated. Change groups (BECMG, TEMPO, FM) formatted readably. |

### Airport Info

| Component | Verification Criteria |
|-----------|----------------------|
| **KPAO Info Sheet** | Shows: Palo Alto Airport of Santa Clara County. ICAO: KPAO. Elevation: 4' MSL. Pattern altitude: 800' AGL (if available). |
| **KPAO Runways** | Runway 13/31: 2,443' x 70', Asphalt. Left traffic for Rwy 31, right traffic for Rwy 13 (if available). |
| **KPAO Frequencies** | CTAF: 118.6. ATIS: 124.1 (if available). Ground: (if available). Shows frequency type labels. |
| **General Airport Sheet** | Loads within 500ms of tap. Scrollable if content exceeds screen. Dismiss via swipe-down or X button. Links to weather for that airport. |

### Instrument Strip

| Component | Verification Criteria |
|-----------|----------------------|
| **Ground Speed** | Displayed in knots. Updates within 1 second. "GS: 105 kts" format. Accurate within 2 kts of GPS-derived speed. |
| **Altitude** | Displayed in feet MSL. "ALT: 4,500'" format. Accurate within 50ft of GPS altitude. |
| **Vertical Speed** | Displayed in feet per minute. "VSI: +200 fpm" format. Responds within 2 seconds of altitude change. Positive values use "+" prefix. |
| **Track** | Displayed in degrees true. "TRK: 270°" format. Updates within 1 second. Full 0-359° range. |
| **Distance To Go** | Displayed in nautical miles. "DTG: 42 nm" format. Decreases as ownship approaches destination. Shows "—" when no active flight plan. |
| **ETE** | Displayed in minutes (or hours:minutes for >60 min). "ETE: 24 min" format. Recalculated based on current GS. Shows "—" when no active flight plan. |

### Nearest Airports

| Component | Verification Criteria |
|-----------|----------------------|
| **Nearest List** | Shows 5+ airports sorted by distance from ownship. Each entry: identifier, name, distance (NM), bearing (°), longest runway length. Updates when ownship moves >1 NM. |
| **One-Tap Access** | Single tap on "Nearest" button (or toolbar button) opens list immediately. No delay >500ms. |
| **Direct-To** | Tap "Direct To" on any nearest airport → creates flight plan → route line appears on map. |

### Flight Plan

| Component | Verification Criteria |
|-----------|----------------------|
| **Route Creation** | Select departure + destination → route line renders on map. Distance shown in nautical miles. ETE shown in minutes based on aircraft cruise speed. |
| **Route Line** | Magenta line from departure to destination. Correct geographic path (verified against known distances). |
| **Fuel Estimate** | Shown if aircraft profile has fuel burn rate. "Est. Fuel: 4.5 gal" format. Based on distance and burn rate. |

### Profiles

| Component | Verification Criteria |
|-----------|----------------------|
| **Aircraft Profile** | All fields editable: N-number, type, fuel capacity, burn rate, cruise speed. Data persists across app launches. Multiple aircraft supported. |
| **Pilot Profile** | All fields editable: name, cert number, cert type, medical class/expiry, BFR date. Data persists across app launches. Medical expiry shows warning when <60 days out. |

### Chart Downloads

| Component | Verification Criteria |
|-----------|----------------------|
| **Region List** | Shows available VFR sectional regions with file sizes. Downloaded regions show green checkmark. Expired regions show yellow warning. |
| **Download Progress** | Progress bar shows 0-100% during download. Download can be cancelled. Failed downloads show error with retry button. |
| **Storage Display** | Shows total chart storage used (e.g., "152 MB"). Per-region storage breakdown available. "Delete" button removes region and frees storage. |

### Recording (Phase 2 — Stub Verification)

| Component | Verification Criteria |
|-----------|----------------------|
| **ARM Button** | Visible in right sidebar (or toolbar). Tappable but shows "Coming in Phase 2" message. |
| **Recording Coordinator** | `EFBRecordingCoordinator` stub initializes without error. Published properties (`isRecording`, `recordingDuration`) default to false/0. |

---

*This document is a living PRD. It will evolve as development progresses, community feedback is received, and the aviation data landscape changes. All technical claims have been verified against existing SFR code and public FAA/NOAA documentation.*
