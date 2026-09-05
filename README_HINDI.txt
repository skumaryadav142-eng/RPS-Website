RPS WEBSITE + SUPABASE SETUP

1. supabase-config.js खोलें और SUPABASE_PUBLISHABLE_KEY में अपनी sb_publishable_... key डालें.
2. supabase_setup.sql को Supabase > SQL Editor में पूरा चलाएँ.
3. Supabase Authentication > Users में बनाए गए Admin user का UUID कॉपी करें.
4. SQL Editor में यह चलाएँ:
   insert into public.admin_users(user_id) values ('ADMIN-USER-UUID');
5. इस folder की files एक ही website folder में रखें.
6. index.html = public RPS website.
7. admin.html = Admin Panel.
8. admin.html को public navigation में link न करें; direct URL से खोलें.
9. GitHub Pages पर static files deploy की जा सकती हैं.

SECURITY:
- sb_secret_... या service-role key कभी frontend में न डालें.
- Admin password किसी के साथ साझा न करें.
- RLS policies को बंद न करें.
