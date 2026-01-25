# Self-Hosted Map Infrastructure Deployment Guide

## Overview

This guide explains how to deploy your own map infrastructure when your app outgrows free public API limits. Self-hosting gives you unlimited requests, better performance, and full control over your mapping stack.

---

## What You'll Be Self-Hosting

| Component | Purpose | Public Service | Self-Hosted Alternative |
|-----------|---------|----------------|------------------------|
| **Tile Server** | Renders map images | CartoDB, OSM | OpenMapTiles + TileServer GL |
| **Routing Engine** | Calculates routes | OSRM Demo Server | OSRM Backend |
| **Geocoding** | Address ↔ Coordinates | Nominatim.org | Nominatim |
| **Tile Cache** | Speeds up tile delivery | N/A | Nginx/Varnish Cache |

---

## Part 1: Tile Server (Map Images)

### What Is a Tile Server?

A tile server generates the visual map images you see. Maps are divided into "tiles" - small square images (typically 256x256 or 512x512 pixels) at different zoom levels.

**How it works:**
```
User zooms to level 15 in San Francisco
    ↓
App requests tile: /tiles/15/5242/12661.png
    ↓
Tile server finds or generates that exact tile
    ↓
Returns PNG image to display
```

### Components Needed

1. **Map Data (OpenStreetMap)**
   - Download `.osm.pbf` files (compressed map data)
   - Available at: Geofabrik.de, Planet.openstreetmap.org
   - File sizes: City = 50-200 MB, Country = 1-10 GB, Planet = 70+ GB

2. **Tile Generation Tool (OpenMapTiles)**
   - Converts OSM data into vector tiles (`.mbtiles` format)
   - One-time processing: Takes hours to days depending on region size

3. **Tile Server Software (TileServer GL)**
   - Serves tiles via HTTP
   - Supports both vector tiles and raster PNG rendering
   - Handles styling (colors, fonts, road widths)

### Server Requirements

| Region Coverage | RAM | CPU | Storage | Monthly Cost (Cloud) |
|-----------------|-----|-----|---------|---------------------|
| Single City | 4 GB | 2 cores | 20 GB SSD | $20-40 |
| Single Country | 8 GB | 4 cores | 100 GB SSD | $40-80 |
| Continent | 16 GB | 8 cores | 500 GB SSD | $100-200 |
| Global | 32+ GB | 16+ cores | 2 TB SSD | $300-500 |

### Deployment Overview

```
Step 1: Provision Server
    ↓
Step 2: Download OSM Data for Your Region
    ↓
Step 3: Install OpenMapTiles + Dependencies
    ↓
Step 4: Process OSM → Vector Tiles (takes time)
    ↓
Step 5: Install TileServer GL
    ↓
Step 6: Configure Map Styles
    ↓
Step 7: Set Up Reverse Proxy (Nginx)
    ↓
Step 8: Add SSL Certificate
    ↓
Step 9: Configure CDN for Caching
```

### Architecture Diagram

```
                                    ┌─────────────────────┐
                                    │    CDN (CloudFlare) │
                                    │    Caches tiles     │
                                    └──────────┬──────────┘
                                               │
                                    ┌──────────▼──────────┐
                                    │   Load Balancer     │
                                    │   (Nginx/HAProxy)   │
                                    └──────────┬──────────┘
                                               │
                    ┌──────────────────────────┼──────────────────────────┐
                    │                          │                          │
         ┌──────────▼──────────┐    ┌──────────▼──────────┐    ┌──────────▼──────────┐
         │   TileServer GL     │    │   TileServer GL     │    │   TileServer GL     │
         │   Instance 1        │    │   Instance 2        │    │   Instance 3        │
         └──────────┬──────────┘    └──────────┬──────────┘    └──────────┬──────────┘
                    │                          │                          │
                    └──────────────────────────┼──────────────────────────┘
                                               │
                                    ┌──────────▼──────────┐
                                    │   Shared Storage    │
                                    │   (.mbtiles files)  │
                                    └─────────────────────┘
```

### Key Decisions

| Decision | Option A | Option B | Recommendation |
|----------|----------|----------|----------------|
| **Tile Format** | Vector (smaller, flexible) | Raster PNG (compatible) | Start with Raster for simplicity |
| **Region** | Country only | Global | Start with country, expand later |
| **Hosting** | Self-managed VPS | Managed Kubernetes | VPS for <10K users, K8s for scale |
| **Updates** | Weekly | Monthly | Monthly is sufficient for most apps |

---

## Part 2: Routing Engine (OSRM)

### What Is OSRM?

Open Source Routing Machine (OSRM) calculates driving/walking/cycling routes. It's the same technology behind many navigation apps.

**What it does:**
```
Input: Start coordinates, End coordinates
    ↓
OSRM processes road network graph
    ↓
Output: Route geometry, distance, duration, turn-by-turn
```

### How OSRM Works Internally

1. **Pre-processing Phase (One-time)**
   - Reads OSM road data
   - Builds optimized graph structure
   - Creates lookup tables for fast routing
   - Time: 30 min (city) to 24+ hours (planet)

2. **Runtime Phase (Per request)**
   - Receives coordinate query
   - Runs Dijkstra/Contraction Hierarchies algorithm
   - Returns route in milliseconds

### OSRM Services

| Endpoint | Purpose | Use Case |
|----------|---------|----------|
| `/route` | Point-to-point routing | Driver navigation |
| `/table` | Distance matrix | Find nearest driver |
| `/trip` | Traveling salesman optimization | Multi-stop route planning |
| `/match` | GPS trace matching | Snap GPS points to roads |
| `/nearest` | Find nearest road | Validate pickup locations |

### Server Requirements

| Region Coverage | RAM | CPU | Storage | Processing Time |
|-----------------|-----|-----|---------|-----------------|
| City/Metro | 4 GB | 2 cores | 10 GB | 10-30 minutes |
| Country | 16 GB | 4 cores | 50 GB | 2-4 hours |
| Continent | 64 GB | 8 cores | 200 GB | 8-16 hours |
| Global | 128+ GB | 16+ cores | 500 GB | 24-48 hours |

### OSRM Profiles

OSRM supports different routing profiles:

| Profile | Optimized For | Speed | Restrictions |
|---------|---------------|-------|--------------|
| `car` | Automobiles | Fastest roads | One-ways, turn restrictions |
| `foot` | Pedestrians | Walkable paths | Avoids highways |
| `bicycle` | Cyclists | Bike-friendly | Avoids stairs, prefers lanes |

For Ping Parent (school transport), use **car profile**.

### Deployment Overview

```
Step 1: Provision Server (needs lots of RAM)
    ↓
Step 2: Download OSM Data (.osm.pbf)
    ↓
Step 3: Install OSRM Backend
    ↓
Step 4: Extract OSM Data (osrm-extract)
    ↓
Step 5: Partition Graph (osrm-partition)
    ↓
Step 6: Customize Weights (osrm-customize)
    ↓
Step 7: Start OSRM Server (osrm-routed)
    ↓
Step 8: Configure Load Balancer
    ↓
Step 9: Set Up Health Checks
```

### Architecture Diagram

```
                         ┌──────────────────────────┐
                         │      API Gateway         │
                         │   (Rate limiting, Auth)  │
                         └────────────┬─────────────┘
                                      │
                         ┌────────────▼─────────────┐
                         │     Load Balancer        │
                         └────────────┬─────────────┘
                                      │
              ┌───────────────────────┼───────────────────────┐
              │                       │                       │
   ┌──────────▼──────────┐ ┌──────────▼──────────┐ ┌──────────▼──────────┐
   │   OSRM Instance 1   │ │   OSRM Instance 2   │ │   OSRM Instance 3   │
   │   (car profile)     │ │   (car profile)     │ │   (car profile)     │
   │   RAM: 16GB         │ │   RAM: 16GB         │ │   RAM: 16GB         │
   └──────────┬──────────┘ └──────────┬──────────┘ └──────────┬──────────┘
              │                       │                       │
              └───────────────────────┼───────────────────────┘
                                      │
                         ┌────────────▼─────────────┐
                         │   Shared NFS Storage     │
                         │   (OSRM data files)      │
                         └──────────────────────────┘
```

### Multi-Tenancy Considerations

If you have multiple regions/cities:

```
                    ┌─────────────────────────────────┐
                    │           API Router            │
                    │   Routes by coordinates/region  │
                    └───────────────┬─────────────────┘
                                    │
         ┌──────────────────────────┼──────────────────────────┐
         │                          │                          │
┌────────▼────────┐      ┌──────────▼──────────┐      ┌────────▼────────┐
│  OSRM Cluster   │      │   OSRM Cluster      │      │  OSRM Cluster   │
│  North Region   │      │   South Region      │      │  West Region    │
└─────────────────┘      └─────────────────────┘      └─────────────────┘
```

---

## Part 3: Geocoding (Nominatim)

### What Is Nominatim?

Nominatim converts between addresses and coordinates:
- **Forward Geocoding**: "123 Main St, City" → (lat: 37.7749, lng: -122.4194)
- **Reverse Geocoding**: (37.7749, -122.4194) → "123 Main St, City"

### When to Self-Host

| Scenario | Recommendation |
|----------|----------------|
| <1000 requests/day | Use public Nominatim |
| 1000-5000 requests/day | Consider self-hosting |
| >5000 requests/day | Definitely self-host |
| Need <100ms latency | Self-host in same region |

### Server Requirements

| Region | RAM | Storage | Import Time |
|--------|-----|---------|-------------|
| City | 8 GB | 50 GB | 2-4 hours |
| Country | 32 GB | 200 GB | 12-24 hours |
| Continent | 64 GB | 500 GB | 2-3 days |
| Planet | 128 GB | 1.5 TB | 5-7 days |

### Nominatim Components

```
┌─────────────────────────────────────────────────────────┐
│                    Nominatim Stack                       │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐  │
│  │  Web API    │    │  Search     │    │  Reverse    │  │
│  │  (Python)   │    │  Engine     │    │  Lookup     │  │
│  └──────┬──────┘    └──────┬──────┘    └──────┬──────┘  │
│         │                  │                  │          │
│         └──────────────────┼──────────────────┘          │
│                            │                             │
│                  ┌─────────▼─────────┐                   │
│                  │    PostgreSQL     │                   │
│                  │    + PostGIS      │                   │
│                  │  (Spatial Index)  │                   │
│                  └───────────────────┘                   │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Part 4: Complete Infrastructure Architecture

### Full Self-Hosted Stack

```
                                         INTERNET
                                             │
                                    ┌────────▼────────┐
                                    │   CloudFlare    │
                                    │   (DDoS/CDN)    │
                                    └────────┬────────┘
                                             │
                                    ┌────────▼────────┐
                                    │  Load Balancer  │
                                    │   (HAProxy)     │
                                    └────────┬────────┘
                                             │
            ┌────────────────────────────────┼────────────────────────────────┐
            │                                │                                │
   ┌────────▼────────┐              ┌────────▼────────┐              ┌────────▼────────┐
   │   Tile Server   │              │     OSRM        │              │   Nominatim     │
   │   Cluster       │              │     Cluster     │              │   Cluster       │
   │                 │              │                 │              │                 │
   │ tiles.your.com  │              │ route.your.com  │              │ geo.your.com    │
   └────────┬────────┘              └────────┬────────┘              └────────┬────────┘
            │                                │                                │
            └────────────────────────────────┼────────────────────────────────┘
                                             │
                                    ┌────────▼────────┐
                                    │  Shared Storage │
                                    │   (NFS/S3)      │
                                    └────────┬────────┘
                                             │
                                    ┌────────▼────────┐
                                    │   Data Update   │
                                    │   Pipeline      │
                                    │  (Weekly/Monthly)│
                                    └─────────────────┘
```

### Subdomain Structure

| Subdomain | Purpose | Backend |
|-----------|---------|---------|
| `tiles.pingparent.com` | Map tile images | TileServer GL |
| `route.pingparent.com` | Routing API | OSRM |
| `geo.pingparent.com` | Geocoding API | Nominatim |
| `maps-admin.pingparent.com` | Admin dashboard | Custom |

---

## Part 5: Deployment Options

### Option 1: Single VPS (Starter)

**Best for:** <5,000 daily users, single region

```
┌────────────────────────────────────┐
│         Single VPS (32GB RAM)      │
│                                    │
│  ┌──────────┐  ┌──────────┐       │
│  │ Tiles    │  │  OSRM    │       │
│  │ (Docker) │  │ (Docker) │       │
│  └──────────┘  └──────────┘       │
│                                    │
│  ┌──────────┐  ┌──────────┐       │
│  │ Nginx    │  │ Nominatim│       │
│  │ (Proxy)  │  │ (Docker) │       │
│  └──────────┘  └──────────┘       │
│                                    │
└────────────────────────────────────┘
```

**Estimated Cost:** $80-150/month

**Pros:**
- Simple to manage
- Low cost
- Quick setup

**Cons:**
- Single point of failure
- Limited scalability
- All services compete for resources

---

### Option 2: Multi-Server Setup (Growth)

**Best for:** 5,000-50,000 daily users

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│ Tile Server │    │ OSRM Server │    │ Nominatim   │
│ 16GB RAM    │    │ 32GB RAM    │    │ 16GB RAM    │
│ 4 CPU       │    │ 8 CPU       │    │ 4 CPU       │
└──────┬──────┘    └──────┬──────┘    └──────┬──────┘
       │                  │                  │
       └──────────────────┼──────────────────┘
                          │
                 ┌────────▼────────┐
                 │  Load Balancer  │
                 │     + CDN       │
                 └─────────────────┘
```

**Estimated Cost:** $200-400/month

---

### Option 3: Kubernetes Cluster (Scale)

**Best for:** >50,000 daily users, high availability

```
┌─────────────────────────────────────────────────────────┐
│                   Kubernetes Cluster                     │
│                                                          │
│  ┌─────────────────┐  ┌─────────────────┐              │
│  │ Tile Pods (3x)  │  │ OSRM Pods (3x)  │              │
│  │ Auto-scaling    │  │ Auto-scaling    │              │
│  └─────────────────┘  └─────────────────┘              │
│                                                          │
│  ┌─────────────────┐  ┌─────────────────┐              │
│  │ Nominatim (2x)  │  │ Redis Cache     │              │
│  │                 │  │                 │              │
│  └─────────────────┘  └─────────────────┘              │
│                                                          │
│  ┌─────────────────────────────────────────────────────┐│
│  │            Persistent Volume Claims                  ││
│  │   (Map data, OSRM graphs, PostgreSQL data)          ││
│  └─────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────┘
```

**Estimated Cost:** $500-1500/month

---

## Part 6: Data Update Pipeline

### Why Updates Matter

- New roads get built
- Addresses change
- Speed limits update
- Businesses open/close

### Update Frequency Recommendations

| Service | Recommended Frequency | Reason |
|---------|----------------------|--------|
| Tiles | Weekly to Monthly | Visual changes rare |
| OSRM | Weekly | New roads, closures |
| Nominatim | Weekly | Address updates |

### Automated Update Pipeline

```
┌─────────────────────────────────────────────────────────┐
│                  Weekly Update Pipeline                  │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  ┌──────────────┐    ┌──────────────┐                   │
│  │ 1. Download  │───▶│ 2. Validate  │                   │
│  │ OSM Extract  │    │    Data      │                   │
│  └──────────────┘    └──────┬───────┘                   │
│                             │                            │
│                      ┌──────▼───────┐                   │
│                      │ 3. Process   │                   │
│                      │ (OSRM/Tiles) │                   │
│                      └──────┬───────┘                   │
│                             │                            │
│  ┌──────────────┐    ┌──────▼───────┐                   │
│  │ 5. Switch    │◀───│ 4. Deploy to │                   │
│  │    Traffic   │    │ Staging Test │                   │
│  └──────────────┘    └──────────────┘                   │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

### Blue-Green Deployment

To avoid downtime during updates:

```
                    ┌────────────────┐
                    │ Load Balancer  │
                    └───────┬────────┘
                            │
              ┌─────────────┴─────────────┐
              │                           │
     ┌────────▼────────┐        ┌─────────▼───────┐
     │   BLUE (Active) │        │  GREEN (Standby)│
     │   Current Data  │        │  New Data       │
     └─────────────────┘        └─────────────────┘
              │                           │
              │      After Testing        │
              └───────────────────────────┘
                    Switch Traffic
```

---

## Part 7: Monitoring & Alerting

### Key Metrics to Monitor

| Metric | Warning Threshold | Critical Threshold |
|--------|-------------------|-------------------|
| Tile response time | >500ms | >1000ms |
| Route calculation time | >200ms | >500ms |
| Geocode response time | >300ms | >800ms |
| Error rate | >1% | >5% |
| CPU usage | >70% | >90% |
| Memory usage | >80% | >95% |
| Disk usage | >70% | >85% |

### Recommended Tools

| Tool | Purpose |
|------|---------|
| Prometheus | Metrics collection |
| Grafana | Dashboards & visualization |
| AlertManager | Alert notifications |
| Loki | Log aggregation |
| Uptime Robot | External availability |

### Dashboard Layout

```
┌─────────────────────────────────────────────────────────┐
│                    Map Services Dashboard                │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐      │
│  │ Tile Server │  │    OSRM     │  │  Nominatim  │      │
│  │  Status: ✓  │  │  Status: ✓  │  │  Status: ✓  │      │
│  │  Latency:   │  │  Latency:   │  │  Latency:   │      │
│  │   45ms avg  │  │   78ms avg  │  │   120ms avg │      │
│  └─────────────┘  └─────────────┘  └─────────────┘      │
│                                                          │
│  ┌─────────────────────────────────────────────────┐    │
│  │           Requests per Second (Graph)            │    │
│  │   ▁▂▃▄▅▆▇█▇▆▅▄▃▂▁▂▃▄▅▆▇█▇▆▅▄▃▂▁                 │    │
│  └─────────────────────────────────────────────────┘    │
│                                                          │
│  ┌─────────────────────────────────────────────────┐    │
│  │              Error Rate (Graph)                  │    │
│  │   ▁▁▁▁▁▁▂▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁                 │    │
│  └─────────────────────────────────────────────────┘    │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Part 8: Security Considerations

### API Security

| Measure | Implementation |
|---------|----------------|
| Rate Limiting | Nginx limit_req or API Gateway |
| API Keys | Required for all requests |
| IP Allowlisting | For admin endpoints |
| DDoS Protection | CloudFlare or similar |

### Network Security

```
                    INTERNET
                        │
               ┌────────▼────────┐
               │   CloudFlare    │
               │ (DDoS + WAF)    │
               └────────┬────────┘
                        │
               ┌────────▼────────┐
               │   Firewall      │
               │ (Only 443/80)   │
               └────────┬────────┘
                        │
               ┌────────▼────────┐
               │   VPC/Private   │
               │   Network       │
               │                 │
               │ ┌─────┐ ┌─────┐ │
               │ │Tiles│ │OSRM │ │
               │ └─────┘ └─────┘ │
               └─────────────────┘
```

### Access Control

| Role | Tile Access | Route Access | Admin Access |
|------|-------------|--------------|--------------|
| Mobile App | ✓ | ✓ | ✗ |
| Web Dashboard | ✓ | ✓ | ✗ |
| Operations | ✓ | ✓ | ✓ |
| DevOps | ✓ | ✓ | ✓ |

---

## Part 9: Cost Estimation

### Infrastructure Costs (Monthly)

| Scale | Compute | Storage | Bandwidth | Total |
|-------|---------|---------|-----------|-------|
| Starter (5K users) | $80 | $20 | $10 | ~$110 |
| Growth (25K users) | $250 | $50 | $50 | ~$350 |
| Scale (100K users) | $800 | $150 | $200 | ~$1,150 |
| Enterprise (500K+) | $2,500+ | $400+ | $500+ | ~$3,500+ |

### Hidden Costs to Consider

| Item | One-Time | Monthly |
|------|----------|---------|
| Initial Setup (DevOps time) | $2,000-5,000 | - |
| SSL Certificates | Free (Let's Encrypt) | $0 |
| Domain Names | $15/year | ~$1 |
| Monitoring Tools | - | $0-50 |
| Backup Storage | - | $10-50 |
| DevOps Maintenance | - | 5-10 hrs/month |

### Break-Even Analysis

| Scale | Google Maps Cost | Self-Hosted Cost | Monthly Savings |
|-------|------------------|------------------|-----------------|
| 5K users/day | $500-800 | $150 | $350-650 |
| 25K users/day | $2,500-4,000 | $400 | $2,100-3,600 |
| 100K users/day | $10,000-16,000 | $1,200 | $8,800-14,800 |

**Conclusion:** Self-hosting becomes cost-effective at ~3,000+ daily users.

---

## Part 10: Migration Checklist

### Pre-Migration

- [ ] Audit current map usage (tiles, routes, geocoding)
- [ ] Choose deployment option (single VPS vs multi-server vs K8s)
- [ ] Select cloud provider and region
- [ ] Plan data coverage (city, country, continent)
- [ ] Set up monitoring infrastructure
- [ ] Create rollback plan

### During Migration

- [ ] Deploy infrastructure in staging
- [ ] Load test against production traffic
- [ ] Validate routing accuracy
- [ ] Check tile rendering quality
- [ ] Test geocoding accuracy
- [ ] Performance benchmark comparison

### Post-Migration

- [ ] Gradual traffic shift (10% → 50% → 100%)
- [ ] Monitor error rates closely
- [ ] Set up alerting
- [ ] Document runbooks
- [ ] Schedule regular data updates
- [ ] Plan capacity for growth

---

## Part 11: Vendor/Tool Comparison

### Tile Servers

| Tool | Ease of Setup | Performance | Memory Usage |
|------|---------------|-------------|--------------|
| TileServer GL | Easy | Good | Medium |
| Martin | Medium | Excellent | Low |
| Tegola | Medium | Good | Low |
| OpenMapTiles | Medium | Good | Medium |

### Routing Engines

| Tool | Ease of Setup | Speed | Features |
|------|---------------|-------|----------|
| OSRM | Medium | Fastest | Basic routing |
| Valhalla | Hard | Fast | Turn-by-turn, isochrones |
| GraphHopper | Easy | Fast | Flexible profiles |

### Geocoding

| Tool | Ease of Setup | Accuracy | Memory |
|------|---------------|----------|--------|
| Nominatim | Hard | Good | High |
| Pelias | Medium | Good | Medium |
| Photon | Easy | Good | Low |

---

## Part 12: Support & Resources

### Official Documentation

| Service | Documentation URL |
|---------|-------------------|
| OSRM | github.com/Project-OSRM/osrm-backend/wiki |
| TileServer GL | tileserver.readthedocs.io |
| Nominatim | nominatim.org/release-docs/latest |
| OpenMapTiles | openmaptiles.org/docs |

### Community Support

| Platform | Best For |
|----------|----------|
| OSM Mailing Lists | General questions |
| OSRM GitHub Issues | Bug reports, features |
| GIS Stack Exchange | Technical questions |
| OSM Forum | Community discussions |

### Professional Support

If you need help with deployment:
- OpenMapTiles (commercial support available)
- GraphHopper (commercial routing solutions)
- Custom consultants (GIS/DevOps specialists)

---

## Summary

Self-hosting map infrastructure requires upfront investment but provides:
- **Cost savings** at scale (>3,000 daily users)
- **Performance control** (host in your region)
- **Unlimited requests** (no API rate limits)
- **Data privacy** (no third-party tracking)
- **Customization** (your own map styles)

**Recommended approach:**
1. Start with free public APIs (current setup)
2. Monitor usage and costs
3. At 2,000+ daily active users, begin planning self-hosted infrastructure
4. Deploy staging environment first
5. Gradually migrate traffic
6. Maintain both systems during transition

---

**Document Version:** 1.0
**Last Updated:** January 2026
