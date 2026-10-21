# The Scholar's Ledger — Multi-user edition (GitHub Pages + Supabase)

This package keeps the existing Field Study and BSEd English Mock Board Preparation planner and adds a Supabase email/password sign-in gate plus per-user cloud save/load. Each account's `scholar_state` row is protected by PostgreSQL Row Level Security (RLS).

## Important limitations in this starter
- Account invitations are sent from Supabase Dashboard > Authentication > Users. Public sign-up is not provided in the app.
- New Auth accounts are created as **pending**. An administrator must approve them in `public.profiles` before they can access the planner.
- This starter saves the full planner state as a per-user JSON payload. The optional leaderboard is **not enabled in this first implementation**; the schema has a `leaderboard_opt_in` field for a later safe leaderboard phase. Do not show user payloads on a leaderboard.
- XP/achievements are UI-derived from task state, not a tamper-proof competitive economy. If you later want competitive rankings, award XP through server-side functions and store an authoritative event ledger.
- Do not put Supabase secret/service-role keys in `supabase-config.js`. Only the project's publishable key (or legacy anon key) belongs in browser code, with RLS enabled.

## A. Create and configure Supabase (Android-friendly)
1. Open https://supabase.com/ and create a project. Save the database password somewhere safe.
2. Open **SQL Editor** > **New query**. Copy all of `supabase-schema.sql` into the editor and run it.
3. Open **Project Settings** > **API** (wording can vary). Copy the **Project URL** and the **publishable key** (or legacy anon key).
4. Edit `supabase-config.js` and replace both `PASTE_...` values. Do not paste a `secret` or `service_role` key.
5. In Supabase **Authentication** settings, set the Site URL to your final GitHub Pages URL, for example `https://YOUR-USERNAME.github.io/YOUR-REPOSITORY/`. Add that exact URL to the allowed redirect URLs. Turn off public sign-ups if the dashboard has an explicit setting for it; the app itself has no sign-up form.
6. Configure email delivery/SMTP before inviting other people if Supabase's default email sending limits are not enough for your use.

## B. Create the administrator account
1. In Supabase open **Authentication > Users > Add user > Send invitation** and invite your own email. (Use an email you control.)
2. Accept the invitation and finish setting the password.
3. In SQL Editor, run this query after replacing the placeholder email:

```sql
update public.profiles p
set is_admin = true, approved = true
from auth.users u
where p.id = u.id and lower(u.email) = lower('YOUR_ADMIN_EMAIL');
```

4. Sign in to the published app. If your profile was created before the SQL trigger was installed, the query above updates it directly.

## C. Invite and approve students
1. In **Authentication > Users**, use **Add user > Send invitation** for each student. Do not enable public registration.
2. After the user appears in Auth, approve them using SQL (replace the email):

```sql
update public.profiles p
set approved = true
from auth.users u
where p.id = u.id and lower(u.email) = lower('STUDENT_EMAIL');
```

3. Students accept the invite, set their password, and sign in. Until approved, the app displays a pending-approval message.
4. To revoke access, set `approved = false` for the profile. For full account removal, disable/delete the Auth user from the dashboard after considering data-retention needs.

## D. Deploy on GitHub Pages using Android
1. Download and extract the package ZIP.
2. Open the GitHub repository in Chrome. Use **Add file > Upload files** (or the repository's upload option).
3. Upload all files from the extracted folder into the repository root. Keep `index.html`, `data.json`, `manifest.json`, `sw.js`, `icon.svg`, `icon-192.png`, `icon-512.png`, `ibukacchan-profile.jpg`, `supabase-config.js`, `supabase-schema.sql`, and this README at the root. Do not upload the ZIP itself as a substitute for the files.
4. Commit the changes to `main`. Keep GitHub Pages enabled with the existing branch/root setting.
5. Wait for deployment, then open the GitHub Pages URL in Chrome. Sign in and test a change, refresh, and sign in from another device/browser to confirm it syncs.
6. If the old PWA is cached, close the installed app, open the website in Chrome, refresh, or clear that site's stored data and reopen it.

## E. Test isolation before sharing
- Create two test student accounts.
- Add different notes/tasks to each, then sign out and sign in as the other account.
- Verify no data crosses accounts. RLS protects `scholar_state` rows even if a user tries to alter a request.
- Test the pending state before approving a test account.
- Never share the Supabase dashboard login or database password with students.

## Data and privacy
The browser uses the Supabase publishable/anon key; that key is not a secret. Security comes from RLS and the authenticated user's token. The secret/service-role key bypasses RLS and must never be placed in the website. A production leaderboard and admin interface should be implemented with additional RLS-reviewed views/functions before enabling public rankings.
