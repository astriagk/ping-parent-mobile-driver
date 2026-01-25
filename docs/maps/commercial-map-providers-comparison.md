# Commercial Map Providers Comparison

## Overview

This document compares commercial map providers (MapTiler, Mapbox, HERE, TomTom, etc.) as alternatives to:
1. **Google Maps** (expensive at scale)
2. **Self-Hosting** (requires DevOps maintenance)
3. **Free Public APIs** (rate limited)

Commercial providers offer a middle ground: **managed infrastructure with predictable pricing**.

---

## Table of Contents

1. [Provider Comparison Summary](#provider-comparison-summary)
2. [MapTiler](#maptiler)
3. [Mapbox](#mapbox)
4. [HERE Maps](#here-maps)
5. [TomTom](#tomtom)
6. [Azure Maps](#azure-maps)
7. [Stadia Maps](#stadia-maps)
8. [Feature Comparison Matrix](#feature-comparison-matrix)
9. [Cost Comparison by Scale](#cost-comparison-by-scale)
10. [What You Don't Have to Manage](#what-you-dont-have-to-manage)
11. [Ping Parent Use Case Analysis](#ping-parent-use-case-analysis)
12. [Recommendations](#recommendations)

---

## Provider Comparison Summary

| Provider | Best For | Starting Price | Free Tier | Flutter Support |
|----------|----------|----------------|-----------|-----------------|
| **MapTiler** | Beautiful maps, global coverage | $25/month | 100K tiles/month | ✅ Excellent |
| **Mapbox** | Advanced features, navigation | $0 (pay as you go) | 50K loads/month | ✅ Excellent |
| **HERE** | Enterprise, logistics | $0 (pay as you go) | 250K transactions/month | ✅ Good |
| **TomTom** | Traffic, automotive | $0 (pay as you go) | 2,500 transactions/day | ✅ Good |
| **Azure Maps** | Microsoft ecosystem | $0 (pay as you go) | $200 credit | ⚠️ Limited |
| **Stadia Maps** | Budget-friendly tiles | $0 (pay as you go) | 200K tiles/month | ✅ Good |

---

## MapTiler

### Overview

MapTiler provides high-quality map tiles with beautiful styles. Based in Switzerland, known for privacy-friendly policies.

### Pricing Tiers

| Plan | Monthly Cost | Map Loads | Geocoding | Routing | Best For |
|------|-------------|-----------|-----------|---------|----------|
| **Free** | $0 | 100,000 | 1,000 | ❌ | Testing |
| **Flex** | Pay as you go | $0.20/1K | $0.50/1K | ❌ | Low volume |
| **Cloud S** | $25 | 500,000 | 10,000 | ❌ | Small apps |
| **Cloud M** | $95 | 2,000,000 | 50,000 | ❌ | Medium apps |
| **Cloud L** | $195 | 5,000,000 | 150,000 | ❌ | Large apps |
| **Cloud XL** | $475 | 15,000,000 | 500,000 | ❌ | Enterprise |

### What's Included

| Feature | Included | Notes |
|---------|----------|-------|
| Map Tiles (Vector & Raster) | ✅ | 15+ beautiful styles |
| Geocoding (Forward/Reverse) | ✅ | Global coverage |
| Routing | ❌ | Use OSRM/OpenRouteService |
| Route Optimization | ❌ | Not available |
| Offline Maps | ✅ | SDK support |
| Custom Styles | ✅ | MapTiler Cloud Studio |
| Flutter SDK | ✅ | `flutter_map` compatible |

### What You Still Need

| Service | Solution | Cost |
|---------|----------|------|
| Routing | OSRM (free public or self-host) | $0 - $50/month |
| Route Optimization | OSRM Trip API | $0 - $50/month |
| Real-time Tracking | Your backend (Firebase/Socket) | Existing |

### Ping Parent Cost Estimate (MapTiler)

| Scale | Map Loads/Month | Geocoding/Month | MapTiler Cost | + Routing (OSRM) | Total |
|-------|-----------------|-----------------|---------------|------------------|-------|
| 50 users | ~100K | ~2K | $0 (Free) | $0 | **$0** |
| 200 users | ~400K | ~5K | $25 (Cloud S) | $0 | **$25** |
| 500 users | ~1M | ~10K | $25 (Cloud S) | $0 | **$25** |
| 1,000 users | ~2M | ~20K | $95 (Cloud M) | $0 | **$95** |
| 2,000 users | ~4M | ~40K | $195 (Cloud L) | $50 | **$245** |

### Pros & Cons

| Pros | Cons |
|------|------|
| ✅ Beautiful map styles | ❌ No routing included |
| ✅ Generous free tier | ❌ Geocoding limits on lower tiers |
| ✅ Privacy-focused (EU) | ❌ Need separate routing solution |
| ✅ Easy Flutter integration | |
| ✅ Offline maps support | |

---

## Mapbox

### Overview

Mapbox is the most feature-rich alternative to Google Maps. Used by Uber, Instacart, and many major apps.

### Pricing Tiers

| Service | Free Tier | Cost After Free |
|---------|-----------|-----------------|
| **Map Loads (Web)** | 50,000/month | $5.00 per 1,000 |
| **Map Loads (Mobile)** | 25,000 MAU | $4.00 per 1,000 MAU |
| **Geocoding (Permanent)** | 100,000/month | $0.75 per 1,000 |
| **Geocoding (Temporary)** | 100,000/month | $0.50 per 1,000 |
| **Directions** | 100,000/month | $0.50 per 1,000 |
| **Matrix (Duration)** | 100,000 elements/month | $0.10 per 1,000 |
| **Optimization** | 100,000 waypoints/month | $0.10 per 1,000 |

*MAU = Monthly Active Users*

### What's Included

| Feature | Included | Notes |
|---------|----------|-------|
| Map Tiles | ✅ | Vector tiles, many styles |
| Geocoding | ✅ | Excellent quality |
| Routing/Directions | ✅ | Turn-by-turn navigation |
| Route Optimization | ✅ | Multi-stop TSP |
| Distance Matrix | ✅ | For driver assignment |
| Traffic Data | ✅ | Real-time traffic |
| Offline Maps | ✅ | SDK support |
| Navigation SDK | ✅ | Full navigation UI |
| Flutter SDK | ✅ | Official `mapbox_gl` |

### What You DON'T Need to Manage

| Removed Burden | Previously Required |
|----------------|---------------------|
| Tile Server | Self-host TileServer GL |
| Routing Engine | Self-host OSRM |
| Geocoding | Self-host Nominatim |
| Route Optimization | Self-host OSRM Trip |
| Data Updates | Weekly OSM imports |
| Server Maintenance | DevOps time |

### Ping Parent Cost Estimate (Mapbox)

| Scale | Map MAU | Directions | Matrix | Optimization | Total/Month |
|-------|---------|------------|--------|--------------|-------------|
| 50 users | 60 | ~2K | ~1K | ~500 | **$0** (free tier) |
| 200 users | 230 | ~6K | ~3K | ~1.5K | **$0** (free tier) |
| 500 users | 550 | ~15K | ~8K | ~4K | **$0** (free tier) |
| 1,000 users | 1,100 | ~30K | ~15K | ~8K | **$0** (free tier) |
| 2,000 users | 2,200 | ~60K | ~30K | ~15K | **$0** (free tier) |
| 5,000 users | 5,500 | ~150K | ~75K | ~40K | **$50-100** |

### Pros & Cons

| Pros | Cons |
|------|------|
| ✅ All-in-one solution | ❌ Per-MAU pricing can grow |
| ✅ Excellent documentation | ❌ Terms require attribution |
| ✅ Full navigation SDK | ❌ Data owned by Mapbox |
| ✅ Traffic data included | ❌ Lock-in to Mapbox ecosystem |
| ✅ Generous free tiers | |
| ✅ No server management | |

---

## HERE Maps

### Overview

HERE is owned by German automotive companies (BMW, Audi, Daimler). Enterprise-focused with strong logistics features.

### Pricing Tiers

| Plan | Monthly Cost | Transactions | Best For |
|------|-------------|--------------|----------|
| **Freemium** | $0 | 250,000/month | Startups |
| **Base** | $449 | 1,000,000/month | Growing apps |
| **Growth** | Custom | Unlimited | Enterprise |

### Transaction Definitions

| Service | 1 Transaction = |
|---------|-----------------|
| Map Tile | 15 tile requests |
| Geocoding | 1 request |
| Routing | 1 request |
| Matrix | 1 element |
| Traffic | 1 request |

### What's Included

| Feature | Included | Notes |
|---------|----------|-------|
| Map Tiles | ✅ | Vector & Raster |
| Geocoding | ✅ | High accuracy |
| Routing | ✅ | Car, truck, pedestrian |
| Route Optimization | ✅ | Fleet routing |
| Distance Matrix | ✅ | Large matrices |
| Traffic | ✅ | Real-time + historical |
| Fleet Telematics | ✅ | Driver behavior |
| EV Routing | ✅ | Electric vehicle routes |

### Ping Parent Cost Estimate (HERE)

| Scale | Transactions/Month | Plan | Cost |
|-------|-------------------|------|------|
| 50 users | ~50K | Freemium | **$0** |
| 200 users | ~150K | Freemium | **$0** |
| 500 users | ~300K | Base | **$449** |
| 1,000 users | ~600K | Base | **$449** |
| 2,000 users | ~1.2M | Growth | **Custom** |

### Pros & Cons

| Pros | Cons |
|------|------|
| ✅ Generous free tier (250K) | ❌ Jump to $449 is steep |
| ✅ Fleet management features | ❌ Enterprise-focused |
| ✅ Truck routing (weight limits) | ❌ Complex pricing |
| ✅ EV routing support | ❌ Less beautiful styles |
| ✅ Historical traffic | |

---

## TomTom

### Overview

TomTom is a navigation company with strong automotive roots. Known for accurate traffic data.

### Pricing Tiers

| Service | Free Tier | Cost After |
|---------|-----------|------------|
| **Map Display** | 2,500/day | $0.50 per 1,000 |
| **Routing** | 2,500/day | $0.50 per 1,000 |
| **Search (Geocoding)** | 2,500/day | $0.50 per 1,000 |
| **Traffic** | 2,500/day | $0.50 per 1,000 |
| **Matrix** | 2,500/day | $0.50 per 1,000 |

### What's Included

| Feature | Included | Notes |
|---------|----------|-------|
| Map Tiles | ✅ | Vector tiles |
| Geocoding | ✅ | POI search |
| Routing | ✅ | Multiple profiles |
| Route Optimization | ⚠️ | Limited API |
| Distance Matrix | ✅ | Up to 700 origins |
| Traffic | ✅ | Excellent accuracy |
| Speed Limits | ✅ | Road speeds |
| EV Routing | ✅ | Range calculation |

### Ping Parent Cost Estimate (TomTom)

| Scale | Daily Requests | Within Free? | Monthly Cost |
|-------|---------------|--------------|--------------|
| 50 users | ~300 | ✅ Yes | **$0** |
| 200 users | ~1,000 | ✅ Yes | **$0** |
| 500 users | ~2,500 | ✅ Borderline | **$0-50** |
| 1,000 users | ~5,000 | ❌ Over | **$100-150** |
| 2,000 users | ~10,000 | ❌ Over | **$250-350** |

### Pros & Cons

| Pros | Cons |
|------|------|
| ✅ Accurate traffic data | ❌ Daily limits (not monthly) |
| ✅ Speed limit data | ❌ Less generous free tier |
| ✅ EV routing | ❌ Fewer map styles |
| ✅ Flutter SDK available | ❌ Limited optimization API |

---

## Azure Maps

### Overview

Microsoft's mapping platform. Best for apps already in Azure ecosystem.

### Pricing (Pay As You Go)

| Service | Cost per 1,000 |
|---------|----------------|
| Map Renders (Raster) | $0.50 |
| Map Renders (Vector) | $1.00 |
| Geocoding | $0.50 |
| Routing | $0.50 |
| Traffic | $0.50 |

*$200 free Azure credit for new accounts*

### What's Included

| Feature | Included |
|---------|----------|
| Map Tiles | ✅ |
| Geocoding | ✅ |
| Routing | ✅ |
| Traffic | ✅ |
| Route Optimization | ⚠️ Limited |
| Flutter SDK | ⚠️ Community |

### Pros & Cons

| Pros | Cons |
|------|------|
| ✅ Azure integration | ❌ Limited Flutter support |
| ✅ Enterprise support | ❌ Not as feature-rich |
| ✅ Competitive pricing | ❌ Smaller community |

---

## Stadia Maps

### Overview

Budget-friendly tile provider built on OpenStreetMap. Good for cost-conscious apps.

### Pricing

| Service | Free Tier | Cost After |
|---------|-----------|------------|
| **Map Tiles** | 200,000/month | $0.04 per 1,000 |
| **Geocoding** | 10,000/month | $0.50 per 1,000 |
| **Routing** | ❌ | Not available |

### What's Included

| Feature | Included | Notes |
|---------|----------|-------|
| Map Tiles | ✅ | 6 styles, vector & raster |
| Geocoding | ✅ | Pelias-based |
| Routing | ❌ | Use OSRM |
| Static Maps | ✅ | For sharing |

### Ping Parent Cost Estimate (Stadia)

| Scale | Tiles/Month | Geocoding | Stadia Cost | + OSRM | Total |
|-------|-------------|-----------|-------------|--------|-------|
| 500 users | ~1M | ~10K | $32 + $0 | $0 | **$32** |
| 1,000 users | ~2M | ~20K | $72 + $5 | $0 | **$77** |
| 2,000 users | ~4M | ~40K | $152 + $15 | $50 | **$217** |

### Pros & Cons

| Pros | Cons |
|------|------|
| ✅ Very affordable | ❌ No routing |
| ✅ Good free tier | ❌ Limited geocoding |
| ✅ Fast CDN | ❌ Smaller company |
| ✅ Privacy-focused | |

---

## Feature Comparison Matrix

### Core Features

| Feature | MapTiler | Mapbox | HERE | TomTom | Azure | Stadia | Self-Host |
|---------|----------|--------|------|--------|-------|--------|-----------|
| Map Tiles | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Vector Tiles | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Geocoding | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Routing | ❌ | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ |
| Route Optimization | ❌ | ✅ | ✅ | ⚠️ | ⚠️ | ❌ | ✅ |
| Distance Matrix | ❌ | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ |
| Traffic Data | ❌ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Navigation SDK | ❌ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Offline Maps | ✅ | ✅ | ✅ | ✅ | ⚠️ | ⚠️ | ✅ |

### Flutter Support

| Provider | Package | Quality | Docs |
|----------|---------|---------|------|
| MapTiler | `flutter_map` | ✅ Excellent | ✅ Good |
| Mapbox | `mapbox_gl` / `mapbox_maps_flutter` | ✅ Excellent | ✅ Excellent |
| HERE | `here_sdk` | ✅ Good | ✅ Good |
| TomTom | `tomtom_maps` | ⚠️ Newer | ⚠️ Growing |
| Azure | Community packages | ⚠️ Limited | ⚠️ Limited |
| Stadia | `flutter_map` | ✅ Excellent | ✅ Good |

---

## Cost Comparison by Scale

### Monthly Cost at Different User Scales

| Users | Google Maps | Self-Host | MapTiler | Mapbox | HERE | TomTom | Stadia |
|-------|-------------|-----------|----------|--------|------|--------|--------|
| 50 | $0-50 | $0 | $0 | $0 | $0 | $0 | $0 |
| 200 | $50-150 | $0 | $25 | $0 | $0 | $0 | $0 |
| 500 | $150-300 | $0 | $25 | $0 | $0 | $0-50 | $32 |
| 1,000 | $450-700 | $0-50 | $95 | $0 | $449 | $100-150 | $77 |
| 2,000 | $1,100-1,500 | $50-100 | $245 | $0-50 | $449 | $250-350 | $217 |
| 5,000 | $3,000-4,000 | $150-200 | $475+ | $50-100 | Custom | $500-700 | $500+ |

### Cost Efficiency Ranking (at 1,000 users)

| Rank | Provider | Monthly Cost | Value Score |
|------|----------|--------------|-------------|
| 1 | **Mapbox** | $0 | ⭐⭐⭐⭐⭐ |
| 2 | **Self-Host** | $0-50 | ⭐⭐⭐⭐ |
| 3 | **Stadia + OSRM** | $77 | ⭐⭐⭐⭐ |
| 4 | **MapTiler + OSRM** | $95 | ⭐⭐⭐⭐ |
| 5 | **TomTom** | $100-150 | ⭐⭐⭐ |
| 6 | **HERE** | $449 | ⭐⭐ |
| 7 | **Google Maps** | $450-700 | ⭐ |

---

## What You Don't Have to Manage

### Self-Hosting Burdens Removed by Commercial Providers

| Task | Self-Host | MapTiler | Mapbox | HERE | TomTom |
|------|-----------|----------|--------|------|--------|
| Server provisioning | You | ✅ Managed | ✅ Managed | ✅ Managed | ✅ Managed |
| Tile server setup | You | ✅ Managed | ✅ Managed | ✅ Managed | ✅ Managed |
| OSRM deployment | You | ❌ Need OSRM | ✅ Managed | ✅ Managed | ✅ Managed |
| Nominatim setup | You | ✅ Managed | ✅ Managed | ✅ Managed | ✅ Managed |
| OSM data updates | Weekly | ✅ Auto | ✅ Auto | ✅ Auto | ✅ Auto |
| SSL certificates | You | ✅ Managed | ✅ Managed | ✅ Managed | ✅ Managed |
| CDN configuration | You | ✅ Included | ✅ Included | ✅ Included | ✅ Included |
| Monitoring/alerting | You | ✅ Managed | ✅ Managed | ✅ Managed | ✅ Managed |
| Scaling | You | ✅ Auto | ✅ Auto | ✅ Auto | ✅ Auto |
| Security patches | You | ✅ Managed | ✅ Managed | ✅ Managed | ✅ Managed |
| Backup/recovery | You | ✅ Managed | ✅ Managed | ✅ Managed | ✅ Managed |

### Time Savings

| Task | Self-Host Time | Commercial Provider |
|------|----------------|---------------------|
| Initial setup | 2-5 days | 1-2 hours |
| Weekly maintenance | 2-4 hours | 0 hours |
| Monthly updates | 4-8 hours | 0 hours |
| Troubleshooting | Variable | Support ticket |
| Scaling | Days | Automatic |

**Estimated DevOps Savings:** 10-20 hours/month = $500-1,500/month in labor costs

---

## Ping Parent Use Case Analysis

### Required Features for Ping Parent

| Feature | Priority | Google | MapTiler | Mapbox | HERE | TomTom | Self-Host |
|---------|----------|--------|----------|--------|------|--------|-----------|
| Map Display | High | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Driver Location | High | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Route Calculation | High | ✅ | ⚠️ | ✅ | ✅ | ✅ | ✅ |
| Multi-Stop Optimization | High | ⚠️ | ⚠️ | ✅ | ✅ | ⚠️ | ✅ |
| Reverse Geocoding | Medium | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Real-time Tracking | High | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Offline Support | Low | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Traffic Data | Low | ✅ | ❌ | ✅ | ✅ | ✅ | ❌ |

### Best Fit Analysis

| Provider | Fit Score | Reasoning |
|----------|-----------|-----------|
| **Mapbox** | ⭐⭐⭐⭐⭐ | All features, generous free tier, excellent Flutter SDK |
| **Self-Host + Free** | ⭐⭐⭐⭐ | $0 cost, but requires maintenance |
| **MapTiler + OSRM** | ⭐⭐⭐⭐ | Beautiful maps, need external routing |
| **HERE** | ⭐⭐⭐ | Overkill for school transport, expensive jump |
| **TomTom** | ⭐⭐⭐ | Good, but daily limits are restrictive |
| **Google Maps** | ⭐⭐ | Most expensive at scale |

---

## Recommendations

### For Ping Parent Specifically

#### Option A: Stay Free (Current) ✅ RECOMMENDED FOR NOW

```
Tiles: CartoDB/OSM (FREE)
Routing: OSRM Public (FREE)
Geocoding: Nominatim (FREE)
Cost: $0/month
```

**Best for:** 0-500 users
**Effort:** Low (already implemented)

---

#### Option B: Mapbox (When Scaling) ⭐ BEST VALUE

```
Tiles: Mapbox (FREE up to 25K MAU)
Routing: Mapbox Directions (FREE up to 100K/month)
Optimization: Mapbox Optimization (FREE up to 100K/month)
Cost: $0-100/month
```

**Best for:** 500-5,000+ users
**Effort:** Medium (SDK migration)

**Why Mapbox:**
- All-in-one solution (no OSRM needed)
- Generous free tier covers most use cases
- Navigation SDK for driver app
- Traffic data included
- Excellent Flutter support
- Zero DevOps maintenance

---

#### Option C: MapTiler + OSRM (Budget Alternative)

```
Tiles: MapTiler ($25-95/month)
Routing: OSRM Self-hosted ($30-50/month)
Cost: $55-145/month
```

**Best for:** 1,000-2,000 users wanting beautiful maps
**Effort:** Medium (partial self-hosting)

---

#### Option D: Full Self-Host (Maximum Control)

```
Tiles: Self-hosted TileServer ($30/month)
Routing: Self-hosted OSRM ($50/month)
Geocoding: Self-hosted Nominatim ($20/month)
Cost: $100-150/month + DevOps time
```

**Best for:** 2,000+ users with DevOps capacity
**Effort:** High (ongoing maintenance)

---

### Migration Path

```
Phase 1: Current (0-500 users)
├── Stay with FREE solution
├── Cost: $0
└── No changes needed

Phase 2: Growth (500-2,000 users)
├── Option A: Continue FREE + add caching
├── Option B: Migrate to Mapbox
├── Cost: $0-50/month
└── Evaluate based on free tier limits

Phase 3: Scale (2,000+ users)
├── Option A: Mapbox paid tier ($50-100)
├── Option B: Self-host ($100-150 + time)
└── Make decision based on team capacity
```

---

### Decision Matrix

| Factor | Weight | Free | Mapbox | MapTiler | Self-Host |
|--------|--------|------|--------|----------|-----------|
| Cost (500 users) | 25% | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Cost (2,000 users) | 25% | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| Ease of setup | 15% | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐ |
| Maintenance | 15% | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐ |
| Features | 10% | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| Flutter support | 10% | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Total Score** | 100% | **4.5** | **4.7** | **3.8** | **3.6** |

---

### Final Recommendation

| Stage | Recommendation | Monthly Cost |
|-------|----------------|--------------|
| Now (Pilot) | ✅ Stay with current FREE solution | $0 |
| 500+ users | Consider Mapbox migration | $0 (free tier) |
| 2,000+ users | Mapbox OR Self-host (team dependent) | $50-150 |

**Bottom Line:**

1. **Short-term:** Current free solution is perfect
2. **Medium-term:** Mapbox offers best value (free up to 2K users, then cheap)
3. **Long-term:** Decide between Mapbox ($50-100) or Self-host ($100-150 + time) based on your team's DevOps capacity

---

## Quick Reference: Signup Links

| Provider | Signup URL | Free Tier |
|----------|------------|-----------|
| MapTiler | https://cloud.maptiler.com/auth/widget | 100K tiles |
| Mapbox | https://account.mapbox.com/auth/signup | 25K MAU |
| HERE | https://developer.here.com/sign-up | 250K transactions |
| TomTom | https://developer.tomtom.com/user/register | 2,500/day |
| Stadia | https://client.stadiamaps.com/signup | 200K tiles |

---

**Document Version:** 1.0
**Last Updated:** January 2026
**Related Documents:**
- [Production Scaling & Cost Analysis](production-scaling-cost-analysis.md)
- [Self-Hosted Deployment Guide](self-hosted-deployment-guide.md)
