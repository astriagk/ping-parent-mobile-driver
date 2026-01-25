# Map Tile Services Reference Guide

## For School Bus Tracking App Development

> **Last Updated**: January 2026  
> **Context**: Flutter app with real-time tracking, multi-pickup/drop routing

---

## Table of Contents

1. [Quick Reference](#quick-reference)
2. [Understanding Map Tiles](#understanding-map-tiles)
3. [Open Source vs Commercial](#open-source-vs-commercial)
4. [Paid Services Pricing](#paid-services-pricing)
5. [OpenStreetMap Ecosystem](#openstreetmap-ecosystem)
6. [Usage Calculation for School Bus App](#usage-calculation)
7. [Implementation Guide](#implementation-guide)
8. [Recommendations](#recommendations)

---

## Quick Reference

### Best Options for School Bus Tracking App

| Service            | Cost            | Monthly Limit       | Best For                      |
| ------------------ | --------------- | ------------------- | ----------------------------- |
| **OpenFreeMap** ⭐ | $0              | Unlimited           | Small-medium schools, MVP     |
| MapTiler Flex      | $25             | 500K requests       | Professional apps, SLA needed |
| Google Maps        | ~$2,600         | 10K free, then paid | Enterprise only               |
| HERE Maps          | $0 (250K free)  | 250K transactions   | Alternative to Google         |
| TomTom             | $0 (2.5K daily) | 2,500/day free      | Logistics apps                |

**⭐ Recommended: OpenFreeMap** - Free, unlimited, perfect for your use case.

---

## Understanding Map Tiles

### What is a Map Tile?

A map tile is a **256×256 pixel image** that represents a small portion of a map at a specific zoom level.

```
Full Map View = Multiple Tiles
┌────┬────┬────┐
│ T1 │ T2 │ T3 │  Each tile = 256×256 px
├────┼────┼────┤  One screen = 12-16 tiles
│ T4 │ T5 │ T6 │
├────┼────┼────┤
│ T7 │ T8 │ T9 │
└────┴────┴────┘
```

### Sessions vs Requests

#### API Session

- **Definition**: One map initialization (map loads once)
- **Includes**: Unlimited pan, zoom, rotate within that session
- **Example**: User opens app → 1 session, interacts for 10 minutes → still 1 session
- **Used by**: MapTiler SDK, Google Maps SDK

#### API Request

- **Definition**: Each individual tile download
- **Example**: One map view = 12-16 tile requests
- **Triggers**: Initial load, zoom, pan, real-time updates
- **Used by**: flutter_map, Leaflet, OpenLayers with tile URLs

---

## Open Source vs Commercial

### The Ecosystem Explained

```
┌─────────────────────────────────────────────┐
│   OpenStreetMap (OSM)                       │
│   • Raw geographic data (free)              │
│   • Community-maintained                    │
│   • Like Wikipedia for maps                 │
└─────────────┬───────────────────────────────┘
              │
    ┌─────────┴──────────┐
    │                    │
    ▼                    ▼
┌───────────┐      ┌─────────────┐
│ Free      │      │ Commercial  │
│ Services  │      │ Services    │
└─────┬─────┘      └──────┬──────┘
      │                   │
      ▼                   ▼
• OpenFreeMap        • MapTiler
• OSM Tiles          • Google Maps
                     • Mapbox
                     • HERE
```

### Key Differences

| Aspect          | Open Source (OSM)      | Commercial Services     |
| --------------- | ---------------------- | ----------------------- |
| **Data Source** | Community contributors | OSM + proprietary data  |
| **Cost**        | Free (data)            | Paid (service)          |
| **Quality**     | Good, varies by region | Consistent, enhanced    |
| **Updates**     | Community-driven       | Scheduled, validated    |
| **Support**     | Community forums       | Professional support    |
| **SLA**         | None                   | Available on paid plans |

---

## Paid Services Pricing

### 1. Mapbox

**Overview**: Popular with Fortune 500 companies (Facebook, Snapchat, etc.)

**Pricing**:

```
Free Tier:
├─ 50,000 map loads/month
├─ 100,000 geocoding requests/month
└─ 50,000 Mobile Active Users

Paid Tier:
├─ Map Loads: $5 per 1,000
├─ Geocoding (temp): $0.75 per 1,000
├─ Navigation SDK: Per trip or per user
└─ Static Maps: $1 per 1,000
```

**Best For**: Apps needing custom styling, navigation features

---

### 2. Google Maps Platform

**Overview**: Dominant player, recent pricing changes (March 2025)

**Old Model** (Before March 2025):

- $200 monthly credit
- Simple per-request billing

**New Model** (After March 2025):

```
Free Tier by Category:
├─ Essentials: 10,000 requests/month per SKU
├─ Pro: 30,000-100,000 requests/month
└─ Enterprise: Custom

Pricing:
├─ Dynamic Maps: ~$7 per 1,000 loads
├─ Static Maps: $2 per 1,000 requests
├─ Geocoding: $5 per 1,000 (up to 100K)
└─ Street View: $14 per 1,000
```

**Price Increase**: 1400% increase from previous model!

**Subscription Plans** (Alternative):

- Starter: $65/month
- Essentials: $200/month
- Pro: $1,000/month

**Best For**: Enterprise apps with Google ecosystem integration

---

### 3. HERE Maps

**Overview**: Strong European coverage, generous free tier

**Pricing**:

```
Freemium:
└─ 250,000 transactions/month FREE

Pro Plan:
├─ $449/month
└─ 1 million transactions included

Pay-as-you-go:
├─ Map Tiles: $0.075 per 1,000 (first 30K free)
├─ Geocoding: $0.75 per 1,000 (first 30K free)
├─ Routing: $0.75 per 1,000 (first 30K free)
├─ Search/Traffic: $2.50 per 1,000 (first 5K free)
└─ Matrix Routing: $5 per 1,000 (first 2.5K free)
```

**Volume Discounts**: 20% off at higher tiers

**Best For**: Apps needing generous free tier, Google Maps alternative

---

### 4. TomTom Maps

**Overview**: Navigation and logistics focused

**Pricing**:

```
Freemium:
├─ 50,000 tile requests/day
└─ 2,500 non-tile requests/day

Pay-as-you-go (EUR):
├─ Map Tiles: €0.08 per 1,000
├─ Geocoding: €0.50 per 1,000
├─ Routing: €0.75 per 1,000
├─ Search API: €2.50 per 1,000
└─ Matrix Routing: €2.50-6.00 per 1,000

Credit System:
└─ 50K credits = $25 (valid 1 year)
```

**Best For**: Fleet management, logistics routing

---

### 5. MapTiler

**Overview**: OSM-based commercial service, developer-friendly

**Pricing**:

```
Free Plan:
├─ 5,000 sessions/month
├─ 100,000 requests/month
├─ 100MB storage
└─ No overage allowed (service stops)

Flex Plan ($25/month):
├─ 25,000 sessions included
├─ 500,000 requests included
├─ 10GB storage
├─ Extra sessions: $2 per 1,000
├─ Extra requests: $0.10 per 1,000
└─ Commercial use allowed

Unlimited Plan ($295/month):
├─ 300,000 sessions included
├─ 5 million requests included
├─ 100GB storage
├─ 99.9% SLA
├─ Team accounts
├─ Extra sessions: $1.50 per 1,000
└─ Extra requests: $0.08 per 1,000

Custom Plan:
├─ Volume discounts
├─ Soft limits (no auto-billing)
└─ Quote-based pricing
```

**Best For**: Small to medium apps, developers wanting OSM quality with support

---

### Pricing Comparison Table

| Provider    | Free Tier     | Cost per 1K | Notes              |
| ----------- | ------------- | ----------- | ------------------ |
| OpenFreeMap | Unlimited     | $0          | Truly unlimited    |
| MapTiler    | 100K requests | $0.10       | Affordable         |
| HERE        | 250K requests | $0.75+      | Generous free tier |
| TomTom      | 2.5K daily    | €0.50+      | Daily reset        |
| Mapbox      | 50K loads     | $5          | Popular with devs  |
| Google Maps | 10K requests  | $5-7        | Expensive          |

---

## OpenStreetMap Ecosystem

### What is OpenStreetMap?

**OpenStreetMap** is NOT a map service - it's a **geographic database**.

```
Think of it like:
├─ Wikipedia → OpenStreetMap
├─ Linux → Geographic data
└─ Community-maintained knowledge base
```

**What OSM Provides**:

- ✅ Raw geographic data (roads, buildings, POIs)
- ✅ Free to download (entire planet or regions)
- ✅ Open Database License (ODbL)
- ✅ Updated by volunteers globally

**What OSM Does NOT Provide**:

- ❌ Ready-to-use map tiles
- ❌ Tile hosting service
- ❌ API for your app
- ❌ Rendered map images

### OSM Data → Map Tiles Process

```
1. Download OSM Data (100GB+ for planet)
   ↓
2. Import to Database (PostgreSQL + PostGIS)
   ↓
3. Set up Tile Renderer (Mapnik, Tegola, etc.)
   ↓
4. Generate Tiles (takes days)
   ↓
5. Host Tiles on Server
   ↓
6. Serve to Your App
```

**Complexity**: High  
**Time**: Days to weeks  
**Cost**: Server costs + maintenance

---

### Services Built on OSM

#### 1. OSM's Own Tile Server

```
URL: https://tile.openstreetmap.org/{z}/{x}/{y}.png
```

**Details**:

- Run by OpenStreetMap Foundation
- Free to use
- ⚠️ **Usage Policy Restrictions**:
  - Max 1 request per second
  - Not for heavy commercial use
  - Intended for OSM community/editing
  - Must display attribution

**Use Case**: Hobby projects, testing, OSM editing

---

#### 2. OpenFreeMap ⭐

```
URL: https://tiles.openfreemap.org/styles/liberty/{z}/{x}/{y}.png
```

**Details**:

- Created by Zsolt Ero (ex-MapHub founder)
- Launched 2024
- Uses OSM data
- Donation-supported
- **Truly Unlimited** - no restrictions
- No API key required
- Weekly data updates

**Architecture**:

```
Unique Approach:
├─ No tile server (just nginx)
├─ Btrfs filesystem with 300M hardlinked files
├─ Dedicated servers (no cloud)
└─ Generated with Planetiler (5 hours vs 5 weeks)
```

**Available Styles**:

- Liberty (default)
- Bright
- Positron
- Dark Matter

**Use Case**: Perfect for commercial apps, startups, production use

---

#### 3. Commercial OSM Services

All these use OSM data + enhancements:

- **MapTiler**: OSM + quality validation + custom data
- **Mapbox**: OSM + proprietary data + satellite imagery
- **HERE**: Mix of OSM + TomTom + own data
- **TomTom**: Own data + some OSM

---

### OpenFreeMap vs OSM Tiles

| Feature        | OSM Tiles           | OpenFreeMap        |
| -------------- | ------------------- | ------------------ |
| **Purpose**    | OSM community use   | Commercial apps    |
| **Limits**     | Usage policy limits | Unlimited          |
| **Cost**       | Free                | Free               |
| **API Key**    | Not needed          | Not needed         |
| **Rate Limit** | 1 req/sec           | None               |
| **Heavy Use**  | ❌ Discouraged      | ✅ Encouraged      |
| **Commercial** | ⚠️ Restricted       | ✅ Allowed         |
| **SLA**        | None                | None (best effort) |

---

## Usage Calculation for School Bus App

### Your App Requirements

```dart
// 1. Real-time location tracking
Stream<Position> positionStream = Geolocator.getPositionStream();

// 2. Route display
final route = await openRouteService.directions();

// 3. Multi-pickup optimization
final optimizedRoute = await openRouteService.optimization();

// 4. Live tracking with flutter_map
FlutterMap(
  options: MapOptions(center: busLocation),
  children: [
    TileLayer(urlTemplate: '...'),
    MarkerLayer(markers: busMarkers),
    PolylineLayer(polylines: routes),
  ],
)
```

---

### Request Consumption Analysis

#### Single Parent Session (Morning)

```
Action                          | Tiles | Requests
--------------------------------|-------|----------
1. Open app, map loads (zoom 12) | 12    | 12
2. Find bus, zoom in (zoom 15)   | 15    | 15
3. Watch bus move (5 mins)       | 40    | 40
   - Updates every 10 sec
   - Map auto-pans 5 times
   - 8 tiles per pan
4. Zoom out to see route (zoom 10)| 10    | 10
----------------------------------|-------|----------
TOTAL PER PARENT SESSION                 | 77
```

#### Single Driver Session (30-min route)

```
Action                          | Tiles | Requests
--------------------------------|-------|----------
1. Open app at route start      | 12    | 12
2. Navigation mode (continuous) | 180   | 180
   - 6 tiles per minute × 30
3. Zoom in/out at stops         | 20    | 20
--------------------------------|-------|----------
TOTAL PER DRIVER SESSION                | 212
```

---

### Monthly Calculation (100 Students School)

#### Assumptions:

- 100 students = 100 parents
- 5 bus drivers
- 22 school days per month
- Morning + afternoon routes

#### Daily Usage:

```
Morning Route:
├─ 100 parents × 77 requests = 7,700
├─ 5 drivers × 212 requests = 1,060
└─ Subtotal: 8,760 requests

Afternoon Route:
├─ 100 parents × 77 requests = 7,700
├─ 5 drivers × 212 requests = 1,060
└─ Subtotal: 8,760 requests

Daily Total: 17,520 requests/day
```

#### Monthly Usage:

```
17,520 requests/day × 22 days = 385,440 requests/month
```

---

### How You Stack Up Against Limits

| Service       | Free Limit | Your Usage | Result                          |
| ------------- | ---------- | ---------- | ------------------------------- |
| MapTiler Free | 100K/month | 385K/month | ❌ Exceeds (stops after 6 days) |
| MapTiler Flex | 500K/month | 385K/month | ✅ Within limit                 |
| Google Maps   | 10K/month  | 385K/month | ❌ Far exceeds ($2,600/month)   |
| HERE Free     | 250K/month | 385K/month | ❌ Slightly exceeds             |
| OpenFreeMap   | Unlimited  | 385K/month | ✅ No problem                   |

---

### Cost Breakdown

#### MapTiler Free:

```
Included: 100,000 requests
Your usage: 385,440 requests
Duration working: ~6 days
Then: Service stops until next month
Cost: $0 (but unreliable)
```

#### MapTiler Flex:

```
Included: 500,000 requests
Your usage: 385,440 requests
Overage: 0
Cost: $25/month
```

#### Google Maps:

```
Free: 10,000 requests
Your usage: 385,440 requests
Overage: 375,440 requests
Cost per 1K: $7
Total: 375,440 × $0.007 = $2,628/month
```

#### OpenFreeMap:

```
Limit: Unlimited
Your usage: 385,440 requests
Cost: $0/month
Reliability: Donation-supported, best effort
```

---

## Implementation Guide

### Option 1: OpenFreeMap (Recommended)

```dart
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class BusTrackingMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(12.9716, 77.5946), // Bangalore
        zoom: 13.0,
        maxZoom: 19,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tiles.openfreemap.org/styles/liberty/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.yourschool.busapp',
          maxZoom: 19,
          // No API key needed!
        ),
        MarkerLayer(
          markers: [
            // Your bus markers
          ],
        ),
        PolylineLayer(
          polylines: [
            // Your route polylines
          ],
        ),
      ],
    );
  }
}
```

**Advantages**:

- ✅ Zero cost
- ✅ No API key management
- ✅ No registration needed
- ✅ Unlimited requests
- ✅ No rate limiting

**Considerations**:

- ⚠️ Run by individual developer (donation-supported)
- ⚠️ No SLA guarantee
- ⚠️ Best effort support

---

### Option 2: MapTiler (Professional)

```dart
TileLayer(
  urlTemplate: 'https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key={key}',
  additionalOptions: {
    'key': 'YOUR_MAPTILER_API_KEY',
  },
  maxZoom: 22,
)
```

**Setup**:

1. Sign up at maptiler.com
2. Create API key
3. Choose plan (Free/Flex/Unlimited)
4. Monitor usage in dashboard

**Advantages**:

- ✅ Professional service
- ✅ 99.9% SLA (Unlimited plan)
- ✅ Better map quality
- ✅ Support available
- ✅ Team accounts

**Cost**: $25/month (Flex plan)

---

### Option 3: Self-Hosted Tiles

For advanced users who want complete control:

#### Step 1: Download OSM Data

```bash
# For specific region (e.g., Karnataka, India)
wget https://download.geofabrik.de/asia/india/karnataka-latest.osm.pbf
```

#### Step 2: Set Up Tile Server

```bash
# Using tileserver-gl
docker run -it -v $(pwd):/data -p 8080:80 \
  maptiler/tileserver-gl \
  --file /data/karnataka-latest.mbtiles
```

#### Step 3: Use in App

```dart
TileLayer(
  urlTemplate: 'http://your-server.com/styles/basic/{z}/{x}/{y}.png',
)
```

**Costs**:

- VPS: $5-20/month (DigitalOcean, Hetzner)
- Storage: Varies by region size
- Bandwidth: Usually included

**Advantages**:

- ✅ Complete control
- ✅ No external dependencies
- ✅ Unlimited usage
- ✅ Can customize map styles

**Disadvantages**:

- ❌ Complex setup
- ❌ Maintenance overhead
- ❌ Need to handle updates

---

### Comparison for Your Use Case

| Aspect           | OpenFreeMap        | MapTiler Flex | Self-Hosted      |
| ---------------- | ------------------ | ------------- | ---------------- |
| **Setup Time**   | 5 minutes          | 15 minutes    | 2-3 days         |
| **Monthly Cost** | $0                 | $25           | $10-20           |
| **Maintenance**  | None               | None          | Regular          |
| **Reliability**  | Good               | Excellent     | Depends          |
| **Support**      | Community          | Professional  | Self             |
| **Scalability**  | Unlimited          | 500K requests | Server-dependent |
| **Best For**     | MVP, small schools | Growing apps  | 10+ schools      |

---

## Recommendations

### For Your School Bus App (100 Students)

#### Phase 1: MVP & Testing (Month 1-3)

**Use: OpenFreeMap**

```dart
TileLayer(
  urlTemplate: 'https://tiles.openfreemap.org/styles/liberty/{z}/{x}/{y}.png',
)
```

- **Cost**: $0
- **Why**: Test your app, validate market, zero risk
- **Action**: Consider donating to OpenFreeMap if successful

---

#### Phase 2: Growth (3-5 Schools)

**Use: OpenFreeMap or MapTiler Flex**

**If usage < 500K requests/month**:

- Stick with OpenFreeMap
- Consider $25/month MapTiler for SLA

**If you need**:

- Professional support
- 99.9% uptime guarantee
- Better map styling

**Upgrade to**: MapTiler Flex ($25/month)

---

#### Phase 3: Scale (10+ Schools)

**Options**:

1. **MapTiler Unlimited** ($295/month)
   - 5M requests included
   - Team accounts
   - Priority support

2. **Self-Hosted**
   - One-time setup
   - $20-50/month VPS
   - Complete control

3. **HERE Maps** (Custom pricing)
   - Negotiate volume discount
   - Enterprise support

---

### Decision Matrix

```
Usage Level          | Recommendation        | Cost/Month
---------------------|----------------------|------------
< 100K requests      | OpenFreeMap          | $0
100K - 500K requests | OpenFreeMap or       | $0 or $25
                     | MapTiler Flex        |
500K - 5M requests   | MapTiler Unlimited   | $295
5M+ requests         | Self-hosted or       | $50-500
                     | Enterprise plans     |
```

---

### Quick Decision Guide

**Choose OpenFreeMap if:**

- ✅ Budget is $0
- ✅ Testing MVP
- ✅ Small to medium scale (< 10 schools)
- ✅ Can tolerate best-effort support
- ✅ Don't need SLA guarantees

**Choose MapTiler Flex if:**

- ✅ Budget is $25/month
- ✅ Need professional support
- ✅ Want 99.9% uptime SLA
- ✅ Growing quickly
- ✅ Better map styling needed

**Choose Self-Hosted if:**

- ✅ Have technical expertise
- ✅ 10+ schools (high volume)
- ✅ Want complete control
- ✅ Can maintain infrastructure
- ✅ Long-term cost optimization

**Avoid Google Maps unless:**

- ❌ You have huge budget ($2K+/month)
- ✅ Need specific Google features
- ✅ Enterprise with Google ecosystem

---

## Code Examples

### Complete Implementation with OpenFreeMap

```dart
// pubspec.yaml
dependencies:
  flutter_map: ^6.0.0
  latlong2: ^0.9.0
  geolocator: ^10.1.0

// map_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class BusTrackingScreen extends StatefulWidget {
  @override
  _BusTrackingScreenState createState() => _BusTrackingScreenState();
}

class _BusTrackingScreenState extends State<BusTrackingScreen> {
  final MapController _mapController = MapController();
  LatLng? _busLocation;
  List<LatLng> _routePoints = [];

  @override
  void initState() {
    super.initState();
    _startBusTracking();
  }

  void _startBusTracking() {
    Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
      ),
    ).listen((Position position) {
      setState(() {
        _busLocation = LatLng(position.latitude, position.longitude);
      });

      // Auto-center map on bus
      _mapController.move(_busLocation!, 15.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('School Bus Tracking')),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: _busLocation ?? LatLng(12.9716, 77.5946),
          zoom: 13.0,
          maxZoom: 19.0,
          minZoom: 3.0,
        ),
        children: [
          // OpenFreeMap Tile Layer
          TileLayer(
            urlTemplate: 'https://tiles.openfreemap.org/styles/liberty/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.yourschool.busapp',
            maxZoom: 19,
            tileProvider: NetworkTileProvider(),
          ),

          // Route Polyline
          if (_routePoints.isNotEmpty)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: _routePoints,
                  color: Colors.blue,
                  strokeWidth: 4.0,
                ),
              ],
            ),

          // Bus Marker
          if (_busLocation != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: _busLocation!,
                  width: 40,
                  height: 40,
                  builder: (context) => Icon(
                    Icons.directions_bus,
                    color: Colors.orange,
                    size: 40,
                  ),
                ),
              ],
            ),

          // Attribution (required)
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap: () => launch('https://openstreetmap.org/copyright'),
              ),
            ],
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_busLocation != null) {
            _mapController.move(_busLocation!, 15.0);
          }
        },
        child: Icon(Icons.my_location),
      ),
    );
  }
}
```

---

### Alternative Map Styles

#### Dark Mode

```dart
TileLayer(
  urlTemplate: 'https://tiles.openfreemap.org/styles/dark-matter/{z}/{x}/{y}.png',
)
```

#### Minimal/Light

```dart
TileLayer(
  urlTemplate: 'https://tiles.openfreemap.org/styles/positron/{z}/{x}/{y}.png',
)
```

#### Bright/Colorful

```dart
TileLayer(
  urlTemplate: 'https://tiles.openfreemap.org/styles/bright/{z}/{x}/{y}.png',
)
```

---

### Caching Tiles (Offline Support)

```dart
// pubspec.yaml
dependencies:
  flutter_map: ^6.0.0
  flutter_map_tile_caching: ^9.0.0

// Implementation
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';

// Initialize caching
await FlutterMapTileCaching.initialise();
await FMTC.instance('mapStore').manage.create();

// Use cached tile layer
TileLayer(
  urlTemplate: 'https://tiles.openfreemap.org/styles/liberty/{z}/{x}/{y}.png',
  tileProvider: FMTC.instance('mapStore').getTileProvider(),
)

// Download area for offline use
await FMTC.instance('mapStore').download.startBackground(
  region: RectangleRegion(
    LatLngBounds(
      LatLng(12.8, 77.4), // Southwest
      LatLng(13.1, 77.7), // Northeast
    ),
  ),
  minZoom: 10,
  maxZoom: 16,
);
```

---

## Additional Resources

### Official Documentation

- **OpenStreetMap**: https://www.openstreetmap.org/
- **OpenFreeMap**: https://openfreemap.org/
- **MapTiler**: https://www.maptiler.com/
- **Google Maps Platform**: https://developers.google.com/maps
- **HERE Maps**: https://developer.here.com/
- **TomTom**: https://developer.tomtom.com/

### Flutter Packages

- **flutter_map**: https://pub.dev/packages/flutter_map
- **geolocator**: https://pub.dev/packages/geolocator
- **latlong2**: https://pub.dev/packages/latlong2
- **flutter_map_tile_caching**: https://pub.dev/packages/flutter_map_tile_caching

### Routing Services (for your app)

- **OpenRouteService**: https://openrouteservice.org/ (2,000 requests/day free)
- **OSRM**: http://project-osrm.org/ (open source, self-hostable)
- **GraphHopper**: https://www.graphhopper.com/ (routing API)

---

## Summary & Action Items

### For Immediate Implementation

1. **Start with OpenFreeMap** (5 minutes setup)

   ```dart
   TileLayer(
     urlTemplate: 'https://tiles.openfreemap.org/styles/liberty/{z}/{x}/{y}.png',
   )
   ```

2. **Use OpenRouteService for routing** (free tier: 2,000 requests/day)
   - Multi-pickup optimization
   - Single pickup to multi-drop
   - Distance/duration calculations

3. **Implement real-time tracking** with Geolocator + flutter_map

4. **Monitor your usage** for first month to validate calculations

---

### Scaling Strategy

```
Month 1-3: MVP Testing
├─ OpenFreeMap (free)
├─ OpenRouteService (free)
└─ Monitor usage

Month 4-6: Initial Growth (3-5 schools)
├─ Continue OpenFreeMap or
├─ Upgrade to MapTiler Flex ($25/month)
└─ Total cost: $0-25/month

Month 7-12: Expansion (10+ schools)
├─ Consider self-hosting or
├─ MapTiler Unlimited ($295/month) or
├─ Negotiate enterprise plans
└─ Total cost: $50-500/month
```

---

### Cost Projections

| Schools | Students | Requests/Month | Recommended        | Cost/Month |
| ------- | -------- | -------------- | ------------------ | ---------- |
| 1       | 100      | 385K           | OpenFreeMap        | $0         |
| 3       | 300      | 1.15M          | MapTiler Unlimited | $295       |
| 5       | 500      | 1.92M          | MapTiler Unlimited | $295       |
| 10      | 1000     | 3.85M          | MapTiler Unlimited | $295       |
| 20+     | 2000+    | 7.7M+          | Self-hosted        | $100       |

---

## Final Recommendation

**For your 100-student school bus tracking app:**

### Start Here (Today):

```dart
// Use OpenFreeMap - Free & Unlimited
TileLayer(
  urlTemplate: 'https://tiles.openfreemap.org/styles/liberty/{z}/{x}/{y}.png',
  userAgentPackageName: 'com.yourschool.busapp',
)

// Keep using OpenRouteService for routing
// Both services = $0/month total
```

### Why This Works:

1. ✅ **Zero cost** - Perfect for MVP
2. ✅ **Unlimited requests** - No surprise shutdowns
3. ✅ **Production-ready** - Used by many apps
4. ✅ **Easy to switch** - Can change later if needed
5. ✅ **No vendor lock-in** - Standard tile URLs

### Future-Proof:

- Monitor usage for 1-2 months
- If you grow to 10+ schools, consider MapTiler Unlimited
- Always have self-hosting as backup option
- OpenFreeMap works even at scale (supports donations)

---

**Total Cost for Your Current Needs: $0/month** 🎉

---

_Document created: January 2026_  
_Based on: School bus tracking app with real-time location, multi-pickup/drop routing, parent tracking features_  
_Tech stack: Flutter, flutter_map, geolocator, OpenRouteService_
