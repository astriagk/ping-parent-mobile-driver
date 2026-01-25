# Free Maps Implementation Guide

## Overview

Replace Google Maps with free, open-source alternatives to eliminate monthly API costs.

---

## Cost Comparison

| Usage Level      | Google Maps     | OpenRouteService + OSM      |
| ---------------- | --------------- | --------------------------- |
| 100 users/day    | $50-150/month   | **$0**                      |
| 500 users/day    | $250-500/month  | **$0**                      |
| 1,000 users/day  | $500-1000/month | **$0**                      |
| 2,000+ users/day | $1000+/month    | **$0** (may need self-host) |

### Per User Journey Cost

| Action                  | Google Maps | Free Alternative |
| ----------------------- | ----------- | ---------------- |
| Load map                | $0.007      | $0               |
| Get route               | $0.005      | $0               |
| Optimize multi-stop     | N/A         | $0               |
| Real-time updates (10x) | $0.05       | $0               |
| **Total per journey**   | **~$0.062** | **$0**           |

---

## Recommended Stack

| Requirement             | Solution            | Package/API                       |
| ----------------------- | ------------------- | --------------------------------- |
| Map Display             | OpenStreetMap Tiles | `flutter_map`                     |
| User Location           | GPS                 | `geolocator` (keep existing)      |
| Address Lookup          | Nominatim           | `geocoding` (keep existing)       |
| Route Calculation       | OpenRouteService    | `open_route_service`              |
| Multi-Stop Optimization | OpenRouteService    | `open_route_service`              |
| Real-Time Tracking      | GPS Stream + Socket | `geolocator` + Firebase/Socket.io |

---

## Free API Limits (OpenRouteService)

| API                       | Daily Limit | Per Minute |
| ------------------------- | ----------- | ---------- |
| Directions (routing)      | 2,000       | 40         |
| Matrix (distances)        | 500         | 40         |
| Optimization (multi-stop) | 500         | 40         |
| Isochrones                | 500         | 20         |

**This supports ~500 daily trips with multi-stop routing!**

---

## Package Changes

### Remove

```yaml
google_maps_flutter: ^2.10.0 # REMOVE
```

### Add

```yaml
flutter_map: ^6.1.0 # Map display
latlong2: ^0.9.1 # Coordinates
open_route_service: ^1.2.2 # Routing & optimization
flutter_map_cache: ^1.5.1 # Offline caching (optional)
```

### Keep (already installed)

```yaml
geolocator: ^13.0.2 # GPS location
geocoding: ^3.0.0 # Address lookup
location: ^8.0.0 # Location services
```

---

## Setup Steps

### 1. Get OpenRouteService API Key (FREE)

1. Go to https://openrouteservice.org/dev/#/signup
2. Create free account
3. Request a Token from Dashboard
4. Save API key

### 2. Remove Google Maps Config

**Android** (`android/app/src/main/AndroidManifest.xml`):

```xml
<!-- DELETE THIS -->
<meta-data android:name="com.google.android.geo.API_KEY"
    android:value="Your Google Map API key"/>
```

### 3. Create Config File

Create `lib/config/map_config.dart` with your ORS API key.

---

## Feature Mapping

### Your Requirements → Implementation

| #   | Requirement                      | Implementation                                        |
| --- | -------------------------------- | ----------------------------------------------------- |
| 1   | Get user location, save lat/long | `geolocator` → getCurrentPosition()                   |
| 2   | Calculate distance & show route  | `open_route_service` → directions API                 |
| 3   | Multi-pickup → single drop       | `open_route_service` → optimization API               |
| 4   | Single pickup → multi-drop       | `open_route_service` → optimization API               |
| 5   | Real-time tracking for parents   | `geolocator` stream + `flutter_map` + Socket/Firebase |

---

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    PING PARENT APP                      │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐ │
│  │ flutter_map │    │ geolocator  │    │  Firebase/  │ │
│  │   (FREE)    │    │   (FREE)    │    │  Socket.io  │ │
│  └──────┬──────┘    └──────┬──────┘    └──────┬──────┘ │
│         │                  │                  │         │
│         ▼                  ▼                  ▼         │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐ │
│  │ OpenStreet  │    │   Open      │    │  Real-time  │ │
│  │ Map Tiles   │    │   Route     │    │  Location   │ │
│  │   (FREE)    │    │  Service    │    │  Updates    │ │
│  └─────────────┘    │   (FREE)    │    │   (FREE)    │ │
│                     └─────────────┘    └─────────────┘ │
└─────────────────────────────────────────────────────────┘
```

---

## Key Services to Create

| Service                    | Purpose                      | File                                           |
| -------------------------- | ---------------------------- | ---------------------------------------------- |
| `LocationService`          | Get GPS, reverse geocoding   | `lib/services/location_service.dart`           |
| `RoutingService`           | Calculate routes, distances  | `lib/services/routing_service.dart`            |
| `RouteOptimizationService` | Multi-stop optimization      | `lib/services/route_optimization_service.dart` |
| `TrackingProvider`         | Real-time location streaming | `lib/provider/tracking_provider.dart`          |

---

## Key Widgets to Create

| Widget                 | Purpose                   | File                                               |
| ---------------------- | ------------------------- | -------------------------------------------------- |
| `FreeMapWidget`        | Reusable map component    | `lib/widgets/maps/free_map_widget.dart`            |
| `ParentTrackingScreen` | Real-time driver tracking | `lib/screens/tracking/parent_tracking_screen.dart` |

---

## Migration Checklist

### Phase 1: Setup

- [ ] Add new packages to `pubspec.yaml`
- [ ] Remove `google_maps_flutter`
- [ ] Get OpenRouteService API key
- [ ] Create `map_config.dart`
- [ ] Remove Google Maps API key from manifests

### Phase 2: Implementation

- [ ] Create `FreeMapWidget`
- [ ] Create `LocationService`
- [ ] Create `RoutingService`
- [ ] Create `RouteOptimizationService`
- [ ] Create `TrackingProvider`

### Phase 3: Migration

- [ ] Update `add_location_screen` to use new map
- [ ] Update `AddLocationProvider`
- [ ] Implement multi-stop routing
- [ ] Implement parent tracking screen

### Phase 4: Testing

- [ ] Test on Android
- [ ] Test on iOS
- [ ] Test route calculation
- [ ] Test real-time tracking
- [ ] Performance testing

---

## Resources

| Resource                   | URL                                         |
| -------------------------- | ------------------------------------------- |
| flutter_map Docs           | https://docs.fleaflet.dev/                  |
| OpenRouteService API       | https://openrouteservice.org/dev/#/api-docs |
| OpenRouteService Signup    | https://openrouteservice.org/dev/#/signup   |
| Geolocator Package         | https://pub.dev/packages/geolocator         |
| open_route_service Package | https://pub.dev/packages/open_route_service |

---

## Summary

**Total Monthly Savings: $50 - $1000+** depending on usage.

All required features (location, routing, multi-stop, real-time tracking) are achievable with **$0 monthly cost** using the open-source stack.

---

**Document Version:** 1.0
**Last Updated:** January 2026
