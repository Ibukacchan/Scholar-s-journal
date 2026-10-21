# The Scholar's Ledger

A mobile-friendly, dark-academia Progressive Web App combining the Field Study I checklist and a BSEd English Mock Board Preparation workspace.

## Included
- Dashboard, Field Study, and Mock Board Prep menu
- Original Field Study I episode/task data in `data.json`
- Dated field-study and personal tasks with Today, Weekly, and All views
- Mock board course coverage for all 47 supplied courses, with editable status, confidence, priority, notes, and review dates
- Provisional 30-day study calendar (October 21–November 19, 2026), with 30-minute sessions and editable status
- Daily 30-minute routine, weekly reflection pages, active-recall/error log, and spaced-review dates
- PWA manifest, icons, and service worker for offline caching
- Local data stored in this browser using `localStorage`

## Publish on GitHub Pages
1. Extract this ZIP.
2. Upload every file inside this folder into the **root** of your GitHub Pages repository (not the ZIP itself).
3. Commit the changes. In repository Settings → Pages, ensure the publishing source points to the branch and `/(root)` if using branch publishing, or keep your existing Actions setup if already configured.
4. Wait for deployment, then open your GitHub Pages URL in Chrome on Android.
5. In Chrome's menu, choose **Install app** or **Add to Home screen**.

## Important
- Keep `index.html`, `data.json`, `manifest.json`, `sw.js`, and the icons together in the published root.
- Progress is saved locally in the browser on the current device; it does not automatically sync across devices or browsers.
- The mock board calendar is provisional and does not claim to represent official coverage or weighting. Unscheduled courses appear in the Coverage Gaps view.
- Courses are not marked mastered automatically. Update course status yourself.
- Use HTTPS (GitHub Pages provides it) for PWA installation and service worker support.


## RPG profile update
The dashboard now uses the Ibukacchan RPG profile image and character progression: XP, levels/ranks, a study-day streak, accomplishments, and a unified quest board showing Field Study checklist items, dated Field Study tasks, and scheduled Mock Board Prep sessions. XP is calculated from the current completed work, so completing a task/session adds XP and unchecking or reopening it removes that XP. Progress is saved locally in the browser on this device. Keep `ibukacchan-profile.jpg` in the repository root with the other app files.
