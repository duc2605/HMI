# HMI — Phân loại hàng với TIA Portal và Factory I/O

Dự án học tập mô phỏng băng tải phân loại thùng theo chiều cao bằng **Siemens S7-1200**, **TIA Portal V20**, **S7-PLCSIM V20** và **Factory I/O**. Phần bổ sung `HMI_Portable` khởi động **WinCC Runtime Advanced**, phát video trực tiếp của cửa sổ Factory I/O vào HMI và đồng bộ dữ liệu HMI sau khi compile.

**Bắt đầu:** tải toàn bộ repo → chạy [PLC và Factory I/O](#2-chạy-plc-và-factory-io) → nếu cần HMI có camera, làm tiếp [phần chuẩn bị HMI](#3-chuẩn-bị-hmi-và-camera-một-lần).

> **Trạng thái bản chia sẻ:** Có dự án TIA, scene và bộ HMI_Portable. Người tải cần cài phần mềm tương thích, tải công cụ video và tạo launcher theo hướng dẫn bên dưới.

## 1. Yêu cầu và tải dự án

| Thành phần | Mục đích |
|---|---|
| Windows x64 tương thích bộ Siemens và Windows Graphics Capture | Chạy mô phỏng, chụp cửa sổ Factory I/O |
| TIA Portal V20, có WinCC Comfort/Advanced phù hợp | Mở `.ap20`, sửa và compile PLC/HMI |
| S7-PLCSIM V20 | Chạy PLC mô phỏng |
| Factory I/O Siemens Edition hoặc Ultimate Edition | Chạy scene và driver S7-PLCSIM; scene gốc được lưu bằng **2.5.10** |
| WinCC Runtime Advanced / thành phần mô phỏng tương thích | Chạy HMI TP900 Comfort trên PC; không phải WinCC Unified |
| FFmpeg Windows có `gfxcapture` và `libx264` | Chụp cửa sổ và mã hóa video H.264 |
| MediaMTX **1.21.2** | Phát RTSP cục bộ cho Camera view |
| Windows PowerShell 5.1, .NET Framework 4.x có `csc.exe` | Chạy script, tạo launcher; không cần Python/Node.js/OBS |

Cài Siemens, Factory I/O và giấy phép phù hợp trên từng máy. “Portable” là dữ liệu dùng đường dẫn tương đối; các ứng dụng vẫn phải cài riêng.

Chọn **Code → Download ZIP**, giải nén toàn bộ; hoặc:

```powershell
git clone https://github.com/duc2605/HMI.git
```

Có thể đặt ở `C:\Projects\HMI` hoặc thư mục của bạn. Không cần tài khoản Windows cùng tên tác giả. Không chạy trực tiếp trong ZIP; nên dùng đường dẫn ngắn, không dấu, ngoài thư mục đồng bộ đám mây.

| Đường dẫn | Nội dung |
|---|---|
| `Nhom2_FactoryIO_Template_S7-1200_V20_Version1/` | **Cả thư mục** dự án TIA, mở file `.ap20` bên trong |
| `Nhom2_FactoryIO_My Scenes_Version1/` | `Nhom2_IOFactory_Version1.factoryio` |
| `Nhom2_PLCSIMV20_Version1/` | Dữ liệu PLCSIM đã lưu; cũng có thể tạo phiên mới từ TIA |
| `HMI_Portable/` | Mã launcher, script chuẩn bị, video và AutoSync |
| `docs/PUBLISH.md` | Hướng dẫn chủ dự án cập nhật bản native và phát hành |

## 2. Chạy PLC và Factory I/O

### 2.1. Nạp PLC mô phỏng

1. Mở TIA Portal V20, chọn file:

   ```text
   Nhom2_FactoryIO_Template_S7-1200_V20_Version1/
     Nhom2_FactoryIO_Template_S7-1200_V20_Version1.ap20
   ```

2. Chọn `PLC_1` (CPU 1211C DC/DC/DC theo cấu hình gốc), lưu và compile PLC. Xử lý lỗi trước khi nạp.
3. Chọn **Start simulation**. Khi nạp, chọn loại giao diện **PN/IE**, giao diện **PLCSIM S7-1200/S7-1500** phù hợp trên máy, tìm CPU rồi **Load**.
4. Trong S7-PLCSIM, chuyển CPU sang **RUN**. Có thể Go online/Monitoring trong TIA để kiểm tra chương trình.

Giữ phần kết nối Factory I/O có sẵn trong template; không thay bằng OB1 trống. Với template S7-1200 của hãng, Network 1 có vai trò trong kết nối. Xem [hướng dẫn Factory I/O cho S7-PLCSIM V20–21](https://docs.factoryio.com/tutorials/siemens/setting-up-s7-plcsim-v20/).

### 2.2. Mở scene và kết nối

1. Trong Factory I/O, mở `Nhom2_FactoryIO_My Scenes_Version1/Nhom2_IOFactory_Version1.factoryio`.
2. Nhấn **F4** hoặc **File → Driver Configuration**, chọn **Siemens S7-PLCSIM**.
3. Vào **Configuration**, chọn CPU S7-1200 tương ứng phiên bản PLCSIM. Bản Factory I/O mới có thể ghi `S7-1200 (V20+)`; tên mục có thể khác trong 2.5.10. Giữ driver mô phỏng phù hợp, không đổi sang driver Ethernet cho PLC thật.
4. Trở về cửa sổ driver, bấm **CONNECT**, kiểm tra chỉ báo kết nối. Giữ ánh xạ cảm biến/cơ cấu trong scene đã lưu.
5. Chuyển scene sang chế độ chạy; nhả dừng khẩn, đặt chế độ vận hành thích hợp, dùng Start/Stop/Reset theo logic PLC.

Nếu chưa kết nối: kiểm tra CPU RUN, model driver, phiên bản Factory I/O hỗ trợ PLCSIM đang cài và template PLC. HMI/camera không thay thế kết nối này. Để theo dõi bộ đếm, mở Watch and force tables trong TIA, chọn bảng đã cấu hình và Monitor all.

## 3. Chuẩn bị HMI và camera một lần

Cần bản native đã có HMI và Camera view. Nếu bản tải về chưa có màn hình đó, xem thông báo ở đầu README và [hướng dẫn xuất bản](docs/PUBLISH.md).

### 3.1. Công cụ video

Repo chứa mã nguồn/cấu hình, **không chứa `ffmpeg.exe`, `mediamtx.exe` hoặc bộ cài Siemens/Factory I/O**.

1. Tải FFmpeg Windows theo liên kết tại [FFmpeg](https://ffmpeg.org/download.html) → [gyan.dev Windows builds](https://www.gyan.dev/ffmpeg/builds/). Chọn gói static có `gfxcapture` và `libx264`, giải nén và chép `bin/ffmpeg.exe` vào `HMI_Portable/Tools/`. Gói `.7z` cần công cụ giải nén hỗ trợ định dạng đó.
2. Tải [MediaMTX 1.21.2 chính thức](https://github.com/bluenviron/mediamtx/releases/tag/v1.21.2), gói **Windows amd64**, chép `mediamtx.exe` vào cùng `Tools/`.
3. Giữ `mediamtx.yml` của repo: RTSP chỉ ở `127.0.0.1:8554`, path `factory`. Không cần thay bằng cấu hình mặc định của gói tải. Giữ giấy phép/thông tin nguồn khi phân phối lại công cụ.

Nếu đã có công cụ chạy được trong `HMI_Video`, script có thể lấy file còn thiếu từ đó. Người tải mới đặt công cụ trực tiếp vào `Tools`, không bắt buộc có `HMI_Video`.

### 3.2. Compile và tạo launcher

1. Chọn thiết bị HMI trong TIA → **Compile → Software (rebuild all)**; đợi **0 errors**. Nếu còn `StartProgram` gọi video cũ bằng đường dẫn tuyệt đối trong **L1 → Events → Loaded**, bỏ riêng lệnh đó để tránh chạy hai bộ video.
2. Camera view dùng URL:

   ```text
   rtsp://127.0.0.1:8554/factory
   ```

3. Đóng WinCC Runtime, nhấp đúp **`HMI_Portable/TaoBoChay.cmd`**. Cửa sổ lệnh chỉ dùng cho lần chuẩn bị.
4. Script kiểm tra FFmpeg, chép **toàn bộ** `Generates` vào `HMI_Portable/Runtime`, chép scene gốc nếu chưa có scene portable, rồi biên dịch `Source/Launcher.cs` thành **`ChayDuAn.exe`**. Nếu hỏi nguồn, chọn `pdata.fwc` trong `IM/HMI/C/0/Generates` của dự án TIA. Không chỉ chép một file `pdata.fwc`.

| Vị trí | Kết quả cần có |
|---|---|
| `HMI_Portable/` | `ChayDuAn.exe` |
| `HMI_Portable/Runtime/` | `pdata.fwc` và mọi file/thư mục đi kèm từ `Generates` |
| `HMI_Portable/Tools/` | `ffmpeg.exe`, `mediamtx.exe`, `mediamtx.yml`, `Start-HmiVideo.ps1` |
| `HMI_Portable/FactoryIO/` | Đúng một scene `.factoryio` cần mở |

Nếu đã có `Runtime/pdata.fwc`, `TaoBoChay.cmd` giữ nguyên snapshot. Sau lần compile tiếp theo, bật AutoSync hoặc chép lại đầy đủ `Generates` khi Runtime đã đóng.

## 4. Chạy hằng ngày

1. Chạy PLC/PLCSIM và kết nối Factory I/O theo phần 2. Nếu dùng scene portable đã cập nhật, mở bản trong `HMI_Portable/FactoryIO` để tránh nhầm scene cũ.
2. Nhấp đúp **`HMI_Portable/ChayDuAn.exe`**; không mở thêm HMI simulation từ TIA cùng lúc.
3. Chờ video khởi động rồi kiểm tra L1. Không thu nhỏ Factory I/O. Nếu chưa có hình sau khi scene mở xong, chuyển sang L2 rồi về L1 để thử nạp lại Camera view.

Launcher dùng đường dẫn tương đối. Nếu không tìm được WinCC mặc định, nó hỏi chọn `HmiRTm.exe` và lưu riêng trên máy. Nếu Factory I/O chưa có cửa sổ, nó thử mở scene bằng liên kết file Windows; nếu chưa có liên kết, mở scene thủ công.

MediaMTX và FFmpeg chạy nền; không cần ba terminal mỗi lần. Đóng Runtime sẽ dừng các tiến trình video do supervisor tạo. **Launcher không tự nạp PLC, chọn RUN hoặc cấu hình driver.** Nếu HMI có đăng nhập, dùng tài khoản được cấu hình trong dự án; repo không công bố tài khoản/mật khẩu mặc định.

## 5. AutoSync sau khi compile — tùy chọn

Chỉ bật trên máy **chỉnh sửa/compile**. Máy chỉ chạy bản chia sẻ không cần AutoSync.

1. Chạy **`HMI_Portable/BatTuDongBo.cmd`**.
2. Chọn **bản nguồn** `pdata.fwc` trong `Generates` của dự án TIA, không chọn `HMI_Portable/Runtime/pdata.fwc`.
3. Đóng Runtime, đợi khoảng 15 giây, mở **`HMI_Portable/Tools/AutoSync-Status.txt`**. Khi có **`SYNC OK`**, mở lại `ChayDuAn.exe`.

AutoSync kiểm tra đầu ra mỗi 3 giây, đợi danh sách/kích thước/thời gian sửa file ổn định ít nhất 10 giây, sao chép qua thư mục tạm và đối chiếu SHA-256. Khi Runtime đang mở, công cụ chờ đóng rồi mới cập nhật. Giao diện đang chạy không tự thay đổi trong phiên đó.

Công cụ giữ một bản cũ ở `Runtime_AutoSync_Backup`, tự chạy khi tài khoản hiện tại đăng nhập Windows và lưu nguồn trong LocalAppData. Chạy **`TatTuDongBo.cmd`** để dừng và gỡ tự khởi động. Trước khi đổi chỗ/đổi tên `HMI_Portable`, tắt AutoSync ở chỗ cũ rồi bật lại ở chỗ mới.

**AutoSync theo dõi file, không nhận sự kiện “compile thành công” từ TIA.** Luôn kiểm tra **0 errors** và `SYNC OK` trước khi chia sẻ. Nếu compile lỗi, dừng AutoSync và kiểm tra snapshot: dữ liệu trung gian có thể ổn định dù compile chưa thành công. Công cụ chỉ cập nhật HMI; không tự đồng bộ scene, chương trình PLC, tài nguyên ngoài `Generates`, không tự commit/push GitHub.

## 6. Xử lý lỗi

| Hiện tượng | Kiểm tra |
|---|---|
| Factory I/O không kết nối PLC | CPU RUN, driver/model, template và mapping; xem phần 2 |
| Thiếu `ffmpeg.exe`/`mediamtx.exe` | Tải theo phần 3.1, đặt trực tiếp vào `HMI_Portable/Tools` |
| FFmpeg thiếu `gfxcapture`/`libx264` | Dùng Windows build có đủ thành phần; script chuẩn bị sẽ báo thiếu |
| Thiếu `pdata.fwc` | Compile HMI native trước và chọn nguồn `Generates`; repo có thể chưa có snapshot mới |
| `configuration file could not be loaded` | Lỗi nạp HMI xảy ra trước video: kiểm tra đủ dữ liệu, Runtime tương thích, đóng tiến trình cũ và rebuild. Nếu cũng lỗi từ TIA, cần chẩn đoán môi trường mô phỏng; bấm lại nhiều lần chưa phải đã sửa lỗi |
| Camera không có hình | Factory I/O có cửa sổ, không thu nhỏ, đúng URL; đọc `Tools/video-logs/supervisor.log` và `ffmpeg-error.log` |
| MediaMTX không chạy | Đọc `Tools/video-logs/mediamtx-error.log`, kiểm tra cổng 8554 và cấu hình cho 1.21.2 |
| AutoSync `WAITING` | Đóng Runtime, chờ `SYNC OK` trước khi mở lại |
| AutoSync `RETRY`/`ERROR` | Xem `Tools/AutoSync-Status.txt`; chọn lại nguồn bằng `BatTuDongBo.cmd` |
| Không có `csc.exe` | Kiểm tra .NET Framework 4.x và công cụ biên dịch; giữ `Source/Launcher.cs` để tạo lại EXE |

## 7. Cập nhật và chia sẻ

Đọc [docs/PUBLISH.md](docs/PUBLISH.md). Giữ **cả thư mục TIA**; chỉ đưa `.ap20` lên sẽ thiếu cơ sở dữ liệu dự án. AutoSync không đưa thay đổi trên ổ đĩa lên GitHub.

Repo nguồn bỏ qua EXE tải từ bên thứ ba, launcher EXE, log, cache mới và backup. Gói ZIP phát hành đầy đủ có thể kèm launcher, Runtime và scene đã thử; nếu kèm FFmpeg/MediaMTX, giữ giấy phép và thông tin nguồn tương ứng. Nếu chưa có ZIP đầy đủ, người tải cần làm phần chuẩn bị ở mục 3.

**Mức kiểm tra:** video đã được vận hành trên máy tác giả trong quá trình dựng dự án. Mã launcher/AutoSync có bài kiểm tra Windows đi kèm; kết quả chỉ được xác nhận khi bài kiểm tra thực sự chạy. Môi trường biên soạn không có TIA/WinCC để thử lại toàn bộ, và chưa xác nhận gói trên máy thứ hai. Tạo EXE thành công không xác nhận dữ liệu HMI nạp thành công.

## Tài liệu tham khảo

- [Factory I/O — thiết lập S7-PLCSIM V20–21](https://docs.factoryio.com/tutorials/siemens/setting-up-s7-plcsim-v20/)
- [Factory I/O — driver S7-PLCSIM](https://docs.factoryio.com/manual/drivers/s7-plcsim/)
- [FFmpeg — tải công cụ](https://ffmpeg.org/download.html)
- [Gyan — Windows builds](https://www.gyan.dev/ffmpeg/builds/)
- [MediaMTX — cài đặt](https://mediamtx.org/docs/kickoff/install)
- [MediaMTX — cấu hình](https://mediamtx.org/docs/references/configuration-file)
- [Siemens V20 — biên dịch và nạp WinCC](https://docs.tia.siemens.cloud/r/en-us/v20/readme-wincc-basic-advanced-professional/important-information/compiling-and-loading)
