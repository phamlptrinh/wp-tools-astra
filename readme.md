# Chức năng
- Tải và giải nén WordPress
- Tạo wp-config.php và database
- Cài đặt WordPress
- Cài đặt các plugin cần thiết
- Cài theme Astra và Astra Child
- Cài đặt các plugins của Astra Pro, Kadence Block và Kadence Block Pro
- Cài đặt woocommerce và woocommerce vietnam checkout (nếu cần)
- Thiết lập các options thường dùng như múi giờ, định dạng ngày tháng, cấu trúc permalink.
- Thiết lập các options cho các plugins
    - Disable Gutenberg
    - Unbloater
- Tạo page Home và Blog
- Thiết lập trang chủ và trang list bài viết dùng các trang Home và Blog ở trên.

# Yêu cầu
- Laragon
- 7zip
    - Cài đặt 7zip https://www.7-zip.org/
    - Copy 2 files `7z.exe` và `7z.dll` trong `C:\Program Files\7-Zip` vào thư mục `\usr\bin` của Laragon
# Cấu hình
- Edit file `wp-install.bat`
- Đổi đường dẫn `root` và `plugins_path` tuỳ theo từng máy.
    - root: Đường dẫn đến thư mục `www` của laragon
    - plugins_path: Đường dẫn đến thư mục chứa các file theme `kadence-child` và plugin của Kadence pro. Các file này sẽ được copy vào thư mục `wp-content/themes` và `wp-content/plugins` trong quá trình cài đặt.
- Điền các thông tin cần thiết để kết nối db và cài đặt WordPress
    - db_user
    - db_password
    - site_user
    - site_password
    - site_email
# Chạy cài đặt WordPress
## cmd
- Mở `cmd` ở thư mục chứa file `wp-install.bat`
- Chạy lệnh `wp-install`
## bash
- Mở `bash` ở thư mục chứa file `wp-install.bat`
- Chạy lệnh `./wp-install.bat`
## Chạy bash ở bất cứ đâu
- Thêm alias vào `.bashrc` (thay đường dẫn thư mục tuỳ máy)
    - `alias wp-install='{duong_dan_thu_muc}\\wp-install.bat'`
- Mở bash và chạy lệnh `wp-install` ở bất cứ đâu

