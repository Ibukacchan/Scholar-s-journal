# The Scholar's Journal — Study Command Center

A GitHub Pages-ready Progressive Web App with a dark academia look.

## Menu
- **Dashboard**: Field Study checklist progress, today's open tasks, weekly open tasks, mock-board review log count, and the personal motto.
- **Field Study**: Existing episode checklist and deadlines, daily task entry, personal tasks, and a Monday–Sunday weekly view.
- **Mock Board Preparation**: Log review topics, review type, date, study minutes, score percentage, and notes. The app calculates an average for recorded scores.

## Motto
> YOU DO IT RIGHT. AND, YOU DO IT EVERYDAY.
>
> ONE TAKE. NO RETAKE.

## Deploy to GitHub Pages
1. Extract the ZIP.
2. Upload **all files inside this folder** to the root of your GitHub repository (not the ZIP itself).
3. Commit the changes.
4. In repository Settings → Pages, use GitHub Actions or Deploy from branch with `main` and `/(root)`, matching your current setup.
5. Open your GitHub Pages URL in Chrome on Android and choose **Install app** or **Add to Home screen**.

## Files
- `index.html`: the app interface and client-side functionality
- `data.json`: the original Field Study episode checklist
- `manifest.json`: PWA install metadata
- `sw.js`: offline caching
- `icon.svg`, `icon-192.png`, `icon-512.png`: app icons

## Data and privacy
Checklist checks, daily tasks, and mock-board review logs are stored in the browser's local storage on the device. They are not automatically synced to GitHub or between devices. Clearing browser/site data may erase this locally stored information. Offline access works after the app has been loaded and cached at least once while online.
