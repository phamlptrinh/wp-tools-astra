chcp 65001 >NUL
@echo off

set root=D:\laragon\www
set plugins_path=D:\laragon\#wordpress2\wp-tools\plugins

:: (use PUSHD to get into the dir instead of "cd" so we can use POPD to get back into the original dir).
PUSHD %root%

set db_user=root
set db_password=
set site_user=quantri
set site_password=password#123
set site_email=test@example.com

:: Nhập thông tin cài đặt
set /p wp_site=Thư mục cài đặt (vd: wp-test):
set /p wp_name=Tên website:
set /p wp_db=Database (vd: wp-test):
set has_woo=n
set /p has_woo=Cài woocommerce? (y/n) [Default: n]:
set use_virtual_host=y

echo(

:: Tạo thư mục website.
echo Tạo thư mục %root%/%wp_site%/ ...
mkdir %wp_site%
cd %wp_site%

:: Tao file wp-cli.yml để khi set permalink thì tạo file .htaccess
echo apache_modules: > wp-cli.yml
echo    - mod_rewrite >> wp-cli.yml

echo(

:: Download WordPress (uses WP-CLI)
call wp core download --locale=vi

echo(

:: Use WP-CLI to create the wp-config.php file
echo Tạo file wp-config.php ...
call wp config create --dbname="%wp_db%" --dbuser=%db_user% --dbpass=%db_password% --dbhost=localhost

echo(

:: Create database
echo Tạo database ...
call wp db create

echo(

:: Install WordPress using WP-CLI
echo Cài đặt WordPress ...
set "site_url=localhost/%wp_site%"
if %use_virtual_host%==y set "site_url=%wp_site%.test"
call wp core install --url="%site_url%" --title="%wp_name%" --admin_user="%site_user%" --admin_password=%site_password% --admin_email=%site_email% --skip-email --locale=vi

echo(

:: Dat ngon ngu, mui gio
echo Update options ...
call wp option update timezone_string "Asia/Ho_Chi_Minh"
call wp option update date_format "d/m/Y"
call wp option update time_format "H:i"

:: Dat permalink + tao htaccess
call wp rewrite structure /%%%%postname%%%%/
call wp rewrite flush --hard

echo(

:: Install theme
echo Cài theme Astra...
call wp theme install astra

echo Cài theme astra-child ...
copy %plugins_path%\astra-child.zip %root%\%wp_site%\wp-content\themes
call 7z x -y %root%\%wp_site%\wp-content\themes\astra-child.zip -o%root%\%wp_site%\wp-content\themes -x!__MACOSX
call wp theme activate astra-child

echo(

:: Install plugins
echo Cài đặt plugins...
call wp plugin install advanced-database-cleaner disable-gutenberg fakerpress go-live-update-urls kadence-blocks wpsite-show-ids smtp-mailer autodescription unbloater classic-menu-block astra-import-export
call wp plugin activate disable-gutenberg fakerpress kadence-blocks wpsite-show-ids unbloater

:: Install woocommerce?
if %has_woo%==y call wp plugin install woocommerce woo-vietnam-checkout --activate

echo(

echo Cài đặt plugin Astra Addon và Kadence Blocks Pro...
copy %plugins_path%\astra-addon.zip %root%\%wp_site%\wp-content\plugins
call 7z x -y %root%\%wp_site%\wp-content\plugins\astra-addon.zip -o%root%\%wp_site%\wp-content\plugins -x!__MACOSX

copy %plugins_path%\kadence-blocks-pro.zip %root%\%wp_site%\wp-content\plugins
call 7z x -y %root%\%wp_site%\wp-content\plugins\kadence-blocks-pro.zip -o%root%\%wp_site%\wp-content\plugins -x!__MACOSX

call wp plugin activate astra-addon kadence-blocks-pro

echo(

echo Update Kadence pro options...
:: Kadence Pro
if %has_woo%==y (
    call wp option update _astra_ext_enabled_extensions "{\"advanced-hooks\":\"advanced-hooks\",\"blog-pro\":\"blog-pro\",\"colors-and-background\":\"colors-and-background\",\"advanced-footer\":\"\",\"mobile-header\":\"\",\"header-sections\":\"\",\"lifterlms\":\"\",\"learndash\":\"\",\"advanced-headers\":\"advanced-headers\",\"site-layouts\":\"site-layouts\",\"spacing\":\"spacing\",\"sticky-header\":\"sticky-header\",\"transparent-header\":\"\",\"typography\":\"typography\",\"woocommerce\":\"woocommerce\",\"edd\":\"\",\"nav-menu\":\"nav-menu\",\"all\":\"all\"}" --format=json
) else (
    call wp option update _astra_ext_enabled_extensions "{\"advanced-hooks\":\"advanced-hooks\",\"blog-pro\":\"blog-pro\",\"colors-and-background\":\"colors-and-background\",\"advanced-footer\":\"\",\"mobile-header\":\"\",\"header-sections\":\"\",\"lifterlms\":\"\",\"learndash\":\"\",\"advanced-headers\":\"advanced-headers\",\"site-layouts\":\"site-layouts\",\"spacing\":\"spacing\",\"sticky-header\":\"sticky-header\",\"transparent-header\":\"\",\"typography\":\"typography\",\"woocommerce\":\"\",\"edd\":\"\",\"nav-menu\":\"nav-menu\",\"all\":\"all\"}" --format=json
)

echo(

:: Disable Gutenberg
echo Update Disable Gutenber options...
call wp option update disable_gutenberg_options "{\"user-role_administrator\":\"0\",\"user-role_editor\":\"0\",\"user-role_author\":\"1\",\"user-role_contributor\":\"1\",\"user-role_subscriber\":\"1\",\"post-type_post\":\"1\",\"templates\":\"\",\"post-ids\":\"\",\"whitelist-id\":\"\",\"whitelist-slug\":\"\",\"whitelist-title\":\"\",\"classic-widgets\":1,\"disable-nag\":1,\"styles-enable\":1,\"disable-all\":0,\"whitelist\":0,\"hide-menu\":0,\"hide-gut\":0,\"links-enable\":0,\"acf-enable\":0}" --format=json

echo(

:: Unbloater
echo Update Unbloater options...
call wp option update unbloater_settings "{\"remove_update_available_notice\":\"1\",\"disable_auto_updates_core\":\"1\",\"disable_auto_updates_plugins\":\"1\",\"disable_auto_updates_themes\":\"1\",\"disable_core_upgrade_bundled_items\":\"1\",\"disallow_file_edit\":\"0\",\"limit_post_revisions\":\"1\",\"limit_empty_trash_period\":\"0\",\"limit_application_password_creation\":\"0\",\"disable_application_passwords\":\"0\",\"disable_admin_email_confirmation\":\"1\",\"disable_xmlrpc\":\"1\",\"remove_admin_bar_wordpress_item\":\"1\",\"remove_admin_footer\":\"1\",\"remove_generator_tag\":\"1\",\"remove_script_style_version_parameter\":\"0\",\"remove_wlw_manifest_link\":\"1\",\"remove_rsd_link\":\"1\",\"remove_shortlink\":\"1\",\"remove_feed_generator_tag\":\"1\",\"remove_feed_links\":\"1\",\"disable_feeds\":\"1\",\"remove_wporg_dns_prefetch\":\"1\",\"remove_jquery_migrate\":\"1\",\"disable_emojis\":\"1\",\"optimize_comment_js_loading\":\"1\",\"remove_recent_comments_style\":\"1\",\"disable_comment_hyperlinks\":\"1\",\"reduce_heartbeat_interval\":\"1\",\"normalize_favicon\":\"0\",\"normalize_login_logo_url\":\"1\",\"normalize_login_logo_title\":\"1\",\"disable_login_language_dropdown\":\"0\",\"block_editor_deactivate_block_directory\":\"0\",\"block_editor_deactivate_core_block_patterns\":\"0\",\"block_editor_deactivate_template_editor\":\"0\",\"block_editor_autoclose_welcome_guide\":\"1\",\"block_editor_autoexit_fullscreen_mode\":\"0\"}" --format=json

echo(

:: set homepage as static page
echo Đặt home page và blog page là trang tĩnh ...
call wp option update show_on_front "page"

echo(

:: set homepage
echo Tạo home page ...
call wp post create --post_type=page --post_title=Home --post_status=publish --post_author=1
for /f %%i in ('wp post list --post_type^="page" --posts_per_page^=1 --post_status^="publish" --post_name^="home" --field^=ID --format^=ids') do set HOMEPAGE=%%i
call wp option update page_on_front %HOMEPAGE%

echo(

:: set blog page
echo Tạo blog page ...
call wp post create --post_type=page --post_title=Blog --post_status=publish --post_author=1
for /f %%y in ('wp post list --post_type^="page" --posts_per_page^=1 --post_status^="publish" --post_name^="blog" --field^=ID --format^=ids') do set BLOGPAGE=%%y
call wp option update page_for_posts %BLOGPAGE%

echo(

:: We're done, print out access details.
echo =================================================================
echo Cài đặt hoàn tất.
echo Vui lòng khởi động lại Apache hoặc Nginx để xem kết quả.
echo Đăng nhập: %site_url%/wp-admin
echo username: %site_user%
echo password: %site_password%
echo Nhớ vào Cài đặt - Đường dẫn tĩnh, nhấn Lưu thay đổi để tạo file .htaccess.
echo =================================================================

:: Go back to original folder (when using PUSHD to get into the dir, POPD takes us back).
POPD

@pause