# Production Scaling & Cost Analysis

## Ping Parent - Maps Infrastructure Comparison

This document provides a detailed cost analysis comparing Google Maps vs. the Free OpenStreetMap-based solution for the Ping Parent school transport application.

---

## Table of Contents

1. [Use Case Summary](#use-case-summary)
2. [Current Implementation Status](#current-implementation-status)
3. [Services Comparison](#services-comparison)
4. [Google Maps Pricing Breakdown](#google-maps-pricing-breakdown)
5. [Free Solution (Current Implementation)](#free-solution-current-implementation)
6. [Cost Projections by User Scale](#cost-projections-by-user-scale)
7. [Daily Usage Scenarios](#daily-usage-scenarios)
8. [Rate Limits & Scaling Thresholds](#rate-limits--scaling-thresholds)
9. [When to Self-Host](#when-to-self-host)
10. [Action Plan by Growth Stage](#action-plan-by-growth-stage)
11. [Recommendations](#recommendations)

---

## Use Case Summary

### Primary Use Cases

| Role | Use Case | Map Actions |
|------|----------|-------------|
| **Driver (Morning)** | Pickup from multiple homes → Drop at school | Load map, Get optimized route, Real-time tracking |
| **Driver (Afternoon)** | Pickup from school → Drop to multiple homes | Load map, Get optimized route, Real-time tracking |
| **Parent** | View driver location in real-time | Load map, View live updates (every 5-10 seconds) |

### Typical Daily Journey

```
MORNING ROUTE (Driver):
├── Load map (1x)
├── Get optimized route for 5-10 pickups (1x)
├── Real-time location updates (50-100x per trip)
└── Total: ~60-110 API calls per trip

AFTERNOON ROUTE (Driver):
├── Load map (1x)
├── Get optimized route for 5-10 drops (1x)
├── Real-time location updates (50-100x per trip)
└── Total: ~60-110 API calls per trip

PARENT MONITORING (per child):
├── Load map (2x per day - morning & afternoon)
├── Real-time location updates (50-100x per session)
├── Estimated: 10-15 minute viewing session
└── Total: ~100-200 API calls per day
```

---

## Current Implementation Status

### What's Currently Implemented

| Service | Package/API | Status | Cost |
|---------|-------------|--------|------|
| Map Display | `flutter_map` + OpenStreetMap/CartoDB | ✅ Active | FREE |
| GPS Location | `geolocator` | ✅ Active | FREE |
| Reverse Geocoding | `geocoding` (Nominatim) | ✅ Active | FREE |
| Route Calculation | OSRM (router.project-osrm.org) | ✅ Active | FREE |
| Route Optimization | OSRM Trip API | ✅ Active | FREE |
| Distance Matrix | OSRM Table API | ✅ Active | FREE |
| Real-time Tracking | Geolocator Stream + Flutter Map | ✅ Active | FREE |

### What's Disabled/Removed

| Service | Package | Status |
|---------|---------|--------|
| Google Maps | `google_maps_flutter` | ❌ Commented out in imports |
| Google Directions API | - | ❌ Not used |
| Google Places API | - | ❌ Not used |

---

## Services Comparison

### Map Tiles

| Provider | Free Tier | Cost After | Quality | Offline |
|----------|-----------|------------|---------|---------|
| **Google Maps** | 28,000 loads/month | $7 per 1,000 | Excellent | No |
| **OpenStreetMap** | Unlimited | FREE | Good | Yes |
| **CartoDB** | Unlimited | FREE | Excellent | Yes |
| **Stadia Maps** | 200,000/month | $0.04 per 1,000 | Excellent | Yes |

### Routing

| Provider | Free Tier | Cost After | Multi-stop | Quality |
|----------|-----------|------------|------------|---------|
| **Google Directions** | 40,000/month | $5 per 1,000 | Limited | Excellent |
| **OSRM (Public)** | ~2,000/day | FREE (self-host) | Yes (TSP) | Very Good |
| **OpenRouteService** | 2,000/day | FREE tier | Yes | Very Good |

### Geocoding (Address Lookup)

| Provider | Free Tier | Cost After |
|----------|-----------|------------|
| **Google Geocoding** | 40,000/month | $5 per 1,000 |
| **Nominatim** | 1/second | FREE |
| **geocoding package** | Unlimited | FREE (uses device) |

---

## Google Maps Pricing Breakdown

### Per-API-Call Costs (as of 2024-2025)

| API | Cost per 1,000 calls | Monthly Free Tier |
|-----|---------------------|-------------------|
| Maps JavaScript/Static | $7.00 | 28,000 |
| Directions | $5.00 | - |
| Distance Matrix (per element) | $5.00 | - |
| Places Autocomplete | $2.83 | - |
| Geocoding | $5.00 | 40,000 |

### Google $200 Monthly Credit

Google provides $200/month free credit, which covers approximately:
- **28,500 map loads** OR
- **40,000 route requests** OR
- **40,000 geocoding requests**

**Note:** Once you exceed these limits, costs add up quickly.

---

## Free Solution (Current Implementation)

### Current Tech Stack Costs

| Component | Provider | Monthly Cost | API Key Required |
|-----------|----------|--------------|------------------|
| Map Tiles | CartoDB Positron | $0 | No |
| Routing | OSRM Public | $0 | No |
| Optimization | OSRM Trip | $0 | No |
| Geocoding | Nominatim/geocoding | $0 | No |
| GPS Location | Device Native | $0 | No |

### **Total Monthly Cost: $0**

---

## Cost Projections by User Scale

### Assumptions

- Average 2 trips/day (morning + afternoon)
- 5-10 children per route
- Parents view tracking 2x/day for 10-15 minutes each
- 22 school days/month

### Google Maps Cost Projection

| Scale | Users | Daily Map Loads | Monthly Loads | Monthly Routing | Est. Monthly Cost |
|-------|-------|-----------------|---------------|-----------------|-------------------|
| Pilot | 50 parents, 10 drivers | 220 | 4,840 | 880 | **$0** (within free tier) |
| Small | 200 parents, 30 drivers | 860 | 18,920 | 2,640 | **$0** (within free tier) |
| Medium | 500 parents, 50 drivers | 2,100 | 46,200 | 4,400 | **$150-300** |
| Large | 1,000 parents, 100 drivers | 4,200 | 92,400 | 8,800 | **$450-700** |
| Scale | 2,000 parents, 200 drivers | 8,400 | 184,800 | 17,600 | **$1,100-1,500** |
| Enterprise | 5,000 parents, 500 drivers | 21,000 | 462,000 | 44,000 | **$3,000-4,000** |

### Free Solution (OpenStreetMap + OSRM) Cost Projection

| Scale | Users | Daily API Calls | Monthly Cost | Notes |
|-------|-------|-----------------|--------------|-------|
| Pilot | 50 parents, 10 drivers | ~500 | **$0** | Well within limits |
| Small | 200 parents, 30 drivers | ~2,000 | **$0** | Within daily limits |
| Medium | 500 parents, 50 drivers | ~5,000 | **$0** | May need request throttling |
| Large | 1,000 parents, 100 drivers | ~10,000 | **$0** | Consider self-hosting OSRM |
| Scale | 2,000 parents, 200 drivers | ~20,000 | **$50-100** | Self-host OSRM required |
| Enterprise | 5,000 parents, 500 drivers | ~50,000 | **$100-200** | Self-host all services |

---

## Daily Usage Scenarios

### Scenario 1: Small School (50 Parents, 10 Drivers)

**Morning Routine:**
```
10 Drivers × 1 route calculation = 10 routing calls
10 Drivers × 60 location updates = 600 real-time updates
50 Parents × 50 map updates = 2,500 tile loads
─────────────────────────────────────────────
Total: ~3,110 API calls/morning
```

**Afternoon Routine:** Similar = ~3,110 API calls

**Daily Total:** ~6,220 API calls

| Solution | Daily Cost | Monthly Cost (22 days) |
|----------|------------|------------------------|
| Google Maps | $0.50 | $11 |
| Free Solution | $0 | $0 |

---

### Scenario 2: Medium School Network (500 Parents, 50 Drivers)

**Morning Routine:**
```
50 Drivers × 1 route calculation = 50 routing calls
50 Drivers × 60 location updates = 3,000 real-time updates
500 Parents × 50 map updates = 25,000 tile loads
─────────────────────────────────────────────
Total: ~28,050 API calls/morning
```

**Daily Total:** ~56,100 API calls

| Solution | Daily Cost | Monthly Cost (22 days) |
|----------|------------|------------------------|
| Google Maps | $8-12 | $176-264 |
| Free Solution | $0 | $0 |

---

### Scenario 3: Large Network (2,000 Parents, 200 Drivers)

**Daily Total:** ~224,400 API calls

| Solution | Daily Cost | Monthly Cost (22 days) |
|----------|------------|------------------------|
| Google Maps | $40-60 | $880-1,320 |
| Free Solution | $0* | $50-100** |

*Free for routing/geocoding
**May need self-hosted OSRM server ($50-100/month VPS)

---

## Rate Limits & Scaling Thresholds

### Free Tier Limits

| Service | Limit | What Happens When Exceeded |
|---------|-------|---------------------------|
| **OSRM Public** | ~2,000/day (soft) | Requests may be throttled |
| **Nominatim** | 1 request/second | Hard limit, queue requests |
| **CartoDB Tiles** | Unlimited | No limit |
| **OpenStreetMap Tiles** | Fair use policy | May be blocked if abusive |

### Scaling Thresholds

| Stage | Daily Requests | Action Required |
|-------|---------------|-----------------|
| 0-2,000 | ✅ Safe Zone | No action needed |
| 2,000-5,000 | ⚠️ Caution | Implement request caching |
| 5,000-10,000 | ⚠️ Warning | Consider self-hosting OSRM |
| 10,000+ | 🔴 Critical | Must self-host OSRM/Nominatim |

---

## When to Self-Host

### Self-Hosting Decision Matrix

| Users | Daily Requests | Recommendation | Monthly Cost |
|-------|---------------|----------------|--------------|
| <500 | <5,000 | Use public servers | $0 |
| 500-1,000 | 5,000-10,000 | Prepare for self-hosting | $0 |
| 1,000-2,000 | 10,000-20,000 | Self-host OSRM | $50-100 |
| 2,000+ | 20,000+ | Self-host OSRM + tile cache | $100-200 |

### Self-Hosting Options

#### OSRM Server (Routing)

**Basic VPS Setup:**
```
Provider: DigitalOcean/AWS/Azure
Specs: 4GB RAM, 2 vCPU, 80GB SSD
Cost: $20-40/month
Capacity: 50,000+ requests/day
```

**Docker Deployment:**
```bash
docker run -t -v "${PWD}:/data" ghcr.io/project-osrm/osrm-backend osrm-extract -p /opt/car.lua /data/india-latest.osm.pbf
docker run -t -v "${PWD}:/data" ghcr.io/project-osrm/osrm-backend osrm-partition /data/india-latest.osrm
docker run -t -v "${PWD}:/data" ghcr.io/project-osrm/osrm-backend osrm-customize /data/india-latest.osrm
docker run -t -i -p 5000:5000 -v "${PWD}:/data" ghcr.io/project-osrm/osrm-backend osrm-routed --algorithm mld /data/india-latest.osrm
```

#### Tile Cache Server

**Basic Setup:**
```
Provider: DigitalOcean/AWS/Azure
Specs: 2GB RAM, 1 vCPU, 50GB SSD
Software: TileStache or OpenMapTiles
Cost: $10-20/month
Benefit: Faster tile loading, reduced external dependency
```

---

## Action Plan by Growth Stage

### Stage 1: Pilot (0-100 Users)

**Actions:**
- ✅ Use current free implementation
- ✅ Monitor API usage patterns
- ✅ Set up analytics for tracking

**Monthly Cost:** $0

---

### Stage 2: Growth (100-500 Users)

**Actions:**
- ✅ Implement request caching (Redis/local)
- ✅ Batch geocoding requests
- ✅ Optimize real-time update frequency (10s → 15s)

**Code Changes:**
```dart
// Implement tile caching
// Add: flutter_map_cache: ^1.5.1

// Reduce update frequency for distant vehicles
if (distanceToUser > 2000) {
  updateInterval = Duration(seconds: 30);
} else {
  updateInterval = Duration(seconds: 10);
}
```

**Monthly Cost:** $0

---

### Stage 3: Scale (500-2,000 Users)

**Actions:**
- Deploy self-hosted OSRM server
- Implement tile caching proxy
- Use WebSocket for real-time updates (reduce polling)

**Infrastructure:**
```
- OSRM Server: $30/month (DigitalOcean Droplet)
- Tile Cache: $10/month (optional)
- Total: $40-50/month
```

**Monthly Cost:** $40-50

---

### Stage 4: Enterprise (2,000+ Users)

**Actions:**
- Full self-hosted stack
- Load balancing for OSRM
- CDN for tile delivery
- Database for route caching

**Infrastructure:**
```
- OSRM Cluster: $80-100/month
- Tile Server: $30/month
- CDN: $20/month
- Total: $130-150/month
```

**Monthly Cost:** $130-150

---

## Cost Comparison Summary

### Monthly Cost by Scale

| Users | Google Maps | Free Solution | Savings |
|-------|-------------|---------------|---------|
| 50 | $0-50 | $0 | $0-50 |
| 200 | $50-150 | $0 | $50-150 |
| 500 | $150-300 | $0 | $150-300 |
| 1,000 | $450-700 | $0-50 | $400-700 |
| 2,000 | $1,100-1,500 | $50-100 | $1,000-1,450 |
| 5,000 | $3,000-4,000 | $150-200 | $2,800-3,850 |

### Annual Savings Projection

| Users | Google Maps/Year | Free Solution/Year | Annual Savings |
|-------|------------------|-------------------|----------------|
| 500 | $1,800-3,600 | $0 | **$1,800-3,600** |
| 1,000 | $5,400-8,400 | $0-600 | **$4,800-8,400** |
| 2,000 | $13,200-18,000 | $600-1,200 | **$12,000-17,400** |
| 5,000 | $36,000-48,000 | $1,800-2,400 | **$33,600-46,200** |

---

## Recommendations

### Immediate Actions (Do Now)

1. ✅ **Continue using current free implementation** - Already saving money
2. ✅ **Add analytics tracking** for API call monitoring
3. ✅ **Implement request caching** for frequently accessed routes

### Short-term (100-500 Users)

1. **Optimize polling frequency** - Reduce from 5s to 10-15s for distant vehicles
2. **Add tile caching** - Use `flutter_map_cache` package
3. **Batch geocoding requests** - Queue and process together

### Medium-term (500-2,000 Users)

1. **Deploy OSRM server** - $30-50/month VPS
2. **Set up tile caching proxy** - Reduce external dependencies
3. **Implement WebSocket** for real-time updates

### Long-term (2,000+ Users)

1. **Full infrastructure setup** - Self-hosted everything
2. **Geographic load balancing** - Multiple OSRM instances
3. **CDN integration** - Faster tile delivery

---

## API Configuration Reference

### Current Configuration Files

| File | Purpose |
|------|---------|
| `lib/common/openfreemap_config.dart` | Tile URLs, OSRM endpoints |
| `lib/common/map_config.dart` | Legacy map configuration |

### Key Endpoints (Currently Free)

```dart
// Tile Servers (FREE)
'https://a.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png'
'https://tile.openstreetmap.org/{z}/{x}/{y}.png'

// Routing (FREE)
'https://router.project-osrm.org/route/v1/driving/{coordinates}'
'https://router.project-osrm.org/trip/v1/driving/{coordinates}'
'https://router.project-osrm.org/table/v1/driving/{coordinates}'

// Geocoding (FREE)
'https://nominatim.openstreetmap.org/reverse'
```

### Future Self-Hosted Endpoints

```dart
// When self-hosting, change to:
'https://your-osrm-server.com/route/v1/driving/{coordinates}'
'https://your-tile-server.com/tiles/{z}/{x}/{y}.png'
```

---

## Conclusion

The current **free implementation is production-ready** for up to 500+ users with zero monthly costs. As you scale beyond 2,000 users, consider investing $50-150/month in self-hosted infrastructure, which is still **95% cheaper than Google Maps**.

### Key Takeaways

| Metric | Google Maps | Free Solution |
|--------|-------------|---------------|
| Setup Complexity | Low | Medium |
| Monthly Cost (500 users) | $150-300 | $0 |
| Monthly Cost (2,000 users) | $1,100-1,500 | $50-100 |
| Scaling Flexibility | Limited by cost | Limited by infrastructure |
| Offline Support | No | Yes |
| Data Privacy | Google servers | Self-controlled |

**Recommendation:** Stay with the free solution and invest savings in self-hosted infrastructure only when user growth demands it.

---

**Document Version:** 1.0
**Last Updated:** January 2026
**Applies To:** Ping Parent Mobile App (User/Parent & Driver)
