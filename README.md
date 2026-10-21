# The Scholar's Ledger — Multi-user RPG PWA

The original Field Study + Mock Board Preparation planner is preserved, with an invitation-only Supabase sign-in gate and per-user cloud save/load.

**Setup is required before login will work.** Follow `README-MULTIUSER.md`, run `supabase-schema.sql` in Supabase SQL Editor, then add your Supabase Project URL and publishable/anon key to `supabase-config.js`. Do not put a secret/service-role key in browser code.

Files:
- `index.html` — PWA and login gate
- `data.json` — Field Study checklist content
- `manifest.json`, `sw.js`, icons — installable PWA support
- `ibukacchan-profile.jpg` — profile image
- `supabase-config.js` — replaceable public project configuration
- `supabase-schema.sql` — database tables, trigger, and RLS policies
- `README-MULTIUSER.md` — Android deployment and account administration steps

Current version supports invitation-only login, administrator approval, and per-user cloud persistence. The optional leaderboard is reserved for a later phase so public ranking data can be designed separately from private study records.
