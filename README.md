# Reno Tree Inventory — field and desktop app

A phone, tablet and desktop app for City of Reno Urban Forestry, built around the same records as TreePlotter:

- **Trees:** the inventory, including planting sites and stumps.
- **Work records:** individual tasks on a tree, such as A300 Prune: SRO, Remove Stump or Watering.
- **Work orders:** batches of work records issued to a crew, each with a crew-sheet PDF and a suggested route.
- **Service requests:** Reno Direct, park maintainer and code enforcement requests.
- **Inspections:** with photos.

It works without signal. Everything is stored **on the device**. There are no accounts and no server, and none of the city's data is in this repository.

---

## 1. Put it on GitHub Pages (about 10 minutes)

1. Sign in to GitHub with your own account (or create one at github.com).
2. Click **+** → **New repository**. Name it, for example, `reno-tree-inventory`. Leave it **Public**, which free GitHub Pages requires, and click **Create repository**.
3. Click **uploading an existing file**. Drag in `index.html`, `sw.js`, `manifest.webmanifest`, `README.md` and the `icons` folder, then click **Commit changes**.
4. Go to **Settings** → **Pages**. Set Source to **Deploy from a branch**, Branch to **main**, folder **/ (root)**, and click **Save**.
5. After a minute or two your link appears, which looks like `https://YOUR-USERNAME.github.io/reno-tree-inventory/`.

## 2. Install it

- **iPhone (Safari):** Share → **Add to Home Screen**.
- **Android (Chrome):** ⋮ → **Install app** or **Add to Home screen**.
- **Desktop:** open the link in Chrome or Edge. The install icon in the address bar is optional.

Open it once with signal so the map and PDF tools are saved for offline use.

## 3. Load the data from TreePlotter

Export these layers from TreePlotter as CSV: **trees**, **work records**, **work orders**, **tree inspections** and **service requests**.

In the app, go to **More** → **Import from TreePlotter** → **Choose CSV files**, and select all of them at once. The app recognizes each file. Importing the full inventory (33,000+ trees and 21,000+ work records) takes about a minute.

To refresh later, import newer exports the same way. Records are matched by their TreePlotter IDs. Anything added or edited in this app is kept, not overwritten.

---

## In the field (phone)

**Nearby tab**
- **Use my location** lists the closest trees with distance and direction and updates as you walk. You can switch the list to open service requests.
- The **map shows every tree**, colored by condition, open work or how long since the last inspection. Tap a tree to open it.
- **Flag a tree:** stand at the tree and tap it. Pick it from the closest trees, or add it if it isn't listed. Then choose what's wrong, set the priority, add a note and photos, and save. That creates a work record and can add it to a work order at the same time.
- **Plant a tree:** records a new tree at your GPS location, or converts a nearby planting site or stump. It fills in the scientific name from the inventory, logs a completed Plant Tree record and can add a watering record.

**A tree's page:** Inspect, New work record, Directions, Record planting (for planting sites), work history, inspections and photos.

**Inspections:** condition, defects, recommended action, priority, notes and photos. Open any past inspection to see its photos or add more. If the recommended action needs work, a work record is created automatically.

## At the desk (computer)

**Work tab**
- **Work records:** filter by status, category, task, priority, work order or trim cycle area. Tick records to **Add to work order** or **Suggest route**.
- **Board:** columns for To schedule, Scheduled, In progress and Completed. Drag cards between columns, or change the status on the card.
- **Work orders:** each one shows its records and progress, plus:
  - **Crew sheet PDF:** every stop with tree, address, species, DBH, task, equipment, a done box and hours, with signatures at the end.
  - **Suggest route:** puts the stops in a sensible order, starting from your location if you're out, draws it on a map, and gives Google Maps driving links in legs of up to 10 stops. **Use this order for the crew sheet** saves it.
  - **Mark selected complete:** closes out several records at once.

Completing a record updates the tree. Pruning sets the last-pruned date, a removal makes it a stump, a stump removal makes it a planting site, and a planting makes it active.

**Requests tab:** each request shows what was reported, contact details (tap to call or email), the trees nearest the request, and one tap to **Inspect** a tree or create a **Work record** from it.

**More tab:** overview (open and overdue work, open work by task, work completed in the last 12 months, condition, species mix against Reno's 10% guideline), import, export, backup and sync.

---

## Keeping a phone and a desktop in step

Each device keeps its own copy. There is no live sync without a server. To move changes between devices:

1. On the device with new work (usually the phone): **More** → **Send my changes**. Share the file by email, AirDrop, Drive or OneDrive.
2. On the other device: **More** → **Merge changes or a backup**, then pick the file.

Only records changed since the last send are included, along with their photos. If the same record was edited on both devices, the newer edit wins. Desktop changes, such as new work orders or assignments, go back to the phone the same way.

**Backups:** **More** → **Save backup file** saves everything, including photos. Do this weekly and keep the file off the device. If a phone is lost or the browser clears its storage, the backup is the only copy.

**Exports:** CSVs of trees, work records (all, or only those changed here), inspections and service requests. Use them for the office, or to enter field updates into TreePlotter.

---

## Updating the app

When you change `index.html`, also change the version line at the top of `sw.js` (for example `reno-trees-v2` → `reno-trees-v3`). Then upload both. Phones pick up the new version the next time the app opens with signal. Data on the device is not affected.

## Notes

- Route order is worked out from straight-line distances between stops, taking the nearest stop next and then removing crossings. Google Maps provides the actual driving directions.
- Map tiles come from OpenStreetMap. The map and PDF libraries load from cdnjs and are saved for offline use after the first visit.
- Photos from TreePlotter aren't included in its CSV exports, so the app lists their file names. Photos taken in this app are stored on the device and included in backups and changes files.
- Don't use private or incognito browsing. Those modes don't keep data.
