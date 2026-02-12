# OpenEFB (efb-212)

A free, open-source iPad VFR Electronic Flight Bag that combines moving-map navigation with flight recording and AI-powered post-flight debrief.

## Why

ForeFlight costs $120-360/yr. Every data source it uses — FAA airports, VFR sectional charts, NOAA weather — is **free and public domain**. Android pilots have Avare (free, open-source). iOS pilots have nothing. OpenEFB fills that gap.

## What Makes It Different

1. **Open-source + free** — all flight-critical features, forever
2. **Simplicity-first** — VFR-focused, not an IFR app with VFR bolted on
3. **Integrated flight recording** — GPS track + cockpit audio + radio transcription, built into the EFB
4. **AI-powered debrief** — post-flight analysis with radio phraseology scoring and key-moment identification

## Tech Stack

| Component | Technology |
|-----------|-----------|
| Platform | iPad, iOS 26.0 |
| Language | Swift 6.0+, SwiftUI |
| Architecture | MVVM + Combine |
| Map Engine | MapLibre Native iOS (open-source, no API fees) |
| Aviation Data | SwiftNASR (FAA NASR — 20K US airports) |
| Database | GRDB (aviation data, R-tree spatial indexes) + SwiftData (user data) |
| Weather | NOAA Aviation Weather API (free, no key) |
| Charts | FAA VFR Sectional GeoTIFFs → MBTiles |
| Recording | Sovereign Flight Recorder packages (7K+ LOC) |
| AI Debrief | Apple Foundation Models (on-device) + Claude API (opt-in premium) |

## Phase 1 Features (MVP)

- Moving map with VFR sectional chart overlays
- Full US airport database (~20,000 airports) with search
- Airport info sheets (runways, frequencies, weather)
- METAR/TAF weather with flight category color coding
- Weather map dots (VFR/MVFR/IFR/LIFR)
- GPS ownship tracking with instrument strip (GS, ALT, VSI, TRK)
- Basic flight planning (departure → destination with route line)
- Nearest airport emergency feature
- Aircraft and pilot profiles
- Chart download manager with offline support
- Complete offline-first operation

## Project Structure

```
efb-212/
├── App/                    # App entry point
├── Views/                  # SwiftUI views by feature
│   ├── Map/                # Moving map, instrument strip, airport info
│   ├── Planning/           # Flight plan creation
│   ├── Flights/            # Flight list, detail, debrief
│   ├── Logbook/            # Digital logbook
│   ├── Aircraft/           # Aircraft + pilot profiles
│   ├── Settings/           # App settings, chart downloads
│   └── Components/         # Reusable UI components
├── ViewModels/             # One ViewModel per major view
├── Services/               # Business logic, API clients, managers
├── Data/                   # Database layer (GRDB + SwiftData)
├── Core/                   # AppState, errors, extensions
└── Resources/              # Assets
```

## Build & Run

```bash
open efb-212.xcodeproj
# Select iPad simulator or device → Cmd+R
# Tests: Cmd+U
```

## Documentation

- **[PRD.md](PRD.md)** — Full product requirements document (~3,000 lines) with architecture, data models, sprint plan, and visual verification checklist
- **[CLAUDE.md](CLAUDE.md)** — Development conventions and agent team guidelines

## Data Sources

All free, all public domain:

| Source | Data | Update Cycle |
|--------|------|-------------|
| [FAA NASR](https://nfdc.faa.gov) | Airports, runways, frequencies, navaids, airspace | 28 days |
| [FAA Aeronav](https://aeronav.faa.gov) | VFR sectional chart GeoTIFFs | 56 days |
| [NOAA Aviation Weather](https://aviationweather.gov/data/api/) | METARs, TAFs, PIREPs, SIGMETs | Real-time |
| [FAA TFR](https://tfr.faa.gov) | Temporary flight restrictions | Real-time |

## Roadmap

| Phase | Focus | Timeline |
|-------|-------|----------|
| **Phase 1** | Core VFR EFB (map, airports, weather, planning) | 6 sprints (12 weeks) |
| **Phase 2** | Flight recording + AI debrief | +2-3 months |
| **Phase 3** | IFR procedures, ADS-B traffic, advanced features | Ongoing |

## License

[MPL-2.0](LICENSE) — File-level copyleft. Use it, fork it, improve it, contribute back.

## Contributing

This project is in early development. Contribution guidelines coming soon. In the meantime, open an issue or start a discussion.

## Disclaimer

OpenEFB is a supplemental reference tool. It is NOT intended as a primary means of navigation. Pilots are responsible for maintaining situational awareness through all available means including current paper charts, ATC communication, and visual references. This software has not been tested, approved, or certified by the FAA or any other aviation authority.
