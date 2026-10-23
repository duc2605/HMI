# BÁO CÁO TIẾN ĐỘ DỰ ÁN HMI BĂNG TẢI PHÂN LOẠI

<!-- AUTO-PROGRESS:START -->
## Cập nhật tự động từ GitHub

> Mục này phản ánh lịch sử Git. Đánh giá hoàn thành và kết quả chạy thử ở các phần bên dưới thuộc mốc đánh giá thủ công, cần được nhóm xác nhận lại khi có thay đổi.

- **Thời điểm commit nguồn mới nhất:** 23/10/2026 09:25 (UTC+7).
- **Phiên bản nguồn:** [`e080989`](https://github.com/duc2605/HMI/commit/e080989d6f29a68a43387660ecb7ead5eafeb62e).
- **Nội dung cập nhật:** Cap nhat toan bo du an HMI va bao cao tu dong.

### 15 thay đổi gần nhất của người phát triển

Nội dung dưới đây lấy từ thông điệp commit do người thực hiện ghi, chưa phải kết quả nghiệm thu tự động.

| Ngày (UTC+7) | Commit | Nội dung | Ghi chú/kết quả do người thực hiện ghi |
|---|---|---|---|
| 23/10/2026 | [`e080989`](https://github.com/duc2605/HMI/commit/e080989d6f29a68a43387660ecb7ead5eafeb62e) | Cap nhat toan bo du an HMI va bao cao tu dong | Cap nhat du lieu du an TIA, Runtime va script camera hien tai. |
| 23/10/2026 | [`e51e7e2`](https://github.com/duc2605/HMI/commit/e51e7e220c2b8d4cc9e946160132175802b6aa3c) | Them tu dong cap nhat bao cao tien do | Chưa ghi thêm |
| 21/10/2026 | [`7f00733`](https://github.com/duc2605/HMI/commit/7f0073394dc999ed2862ca05af9a3c852ab2d10c) | Update HMI project, portable runtime, AutoSync and README | Chưa ghi thêm |
| 07/10/2026 | [`1c8c3f7`](https://github.com/duc2605/HMI/commit/1c8c3f70d177834d332e3389013822d5ffe482e3) | Clean up README content | Removed inappropriate text and cleaned up the README. |
| 07/10/2026 | [`ed9cb5d`](https://github.com/duc2605/HMI/commit/ed9cb5deed55f8835219773946f842be6e6cceb9) | Update README.md | Chưa ghi thêm |
| 29/09/2026 | [`304e817`](https://github.com/duc2605/HMI/commit/304e81744a6f8f9e0454962cbddc9d4b80932d59) | Update README.md | Chưa ghi thêm |
| 29/09/2026 | [`eb07dc5`](https://github.com/duc2605/HMI/commit/eb07dc5dbff0d3bafab8da869473ff8f0c2857ac) | Format steps in README.md as bullet points | Chưa ghi thêm |
| 29/09/2026 | [`ad4a7a1`](https://github.com/duc2605/HMI/commit/ad4a7a1c23df1b2764091ec9a075276090d3b223) | Update README.md | Chưa ghi thêm |
| 29/09/2026 | [`16bfc4d`](https://github.com/duc2605/HMI/commit/16bfc4d48e66ad6cc76254866f9f9bd3e547b950) | Update README with monitoring instructions | Add instructions for monitoring in Factory IO. |
| 29/09/2026 | [`a18a79f`](https://github.com/duc2605/HMI/commit/a18a79f80369fb2fab2851e06dd6f47805cc4591) | Add semicolons to file references in README | Chưa ghi thêm |
| 29/09/2026 | [`3dabe29`](https://github.com/duc2605/HMI/commit/3dabe29522ffafbb568cc346c446da5c66b848d0) | Add usage instructions for Factory IO and TIA Portal | Added step-by-step instructions for using Factory IO and TIA Portal. |
| 29/09/2026 | [`1cb971c`](https://github.com/duc2605/HMI/commit/1cb971c88c2c4c76541748848f95eabcc61192f2) | Upload dự án HMI | Chưa ghi thêm |
| 25/09/2026 | [`307a108`](https://github.com/duc2605/HMI/commit/307a1089ab2997196b91dd25dcb82be052117dbf) | Upload dự án TIA | Chưa ghi thêm |

Muốn bổ sung kết quả thử nghiệm vào mục này, ghi chúng trong phần mô tả commit. Cập nhật trực tiếp các phần đánh giá bên dưới khi đã xác nhận chức năng.
<!-- AUTO-PROGRESS:END -->

**Mốc đánh giá thủ công:** 22/10/2026  
**Nhóm thực hiện:** Nhóm 2  
**Đề tài:** Xây dựng giao diện giám sát, vận hành hệ thống băng tải phân loại hàng theo chiều cao trên môi trường mô phỏng.  
**Kho mã nguồn:** [github.com/duc2605/HMI](https://github.com/duc2605/HMI)

> Báo cáo tổng hợp tiến độ đã trao đổi, ảnh chạy thử và kết quả xử lý lỗi đến thời điểm cập nhật. Các phần mới được hướng dẫn cấu hình nhưng chưa có xác nhận chạy thử được ghi là **đang triển khai/cần kiểm thử**, không coi là đã nghiệm thu.

## 1. Tóm tắt kết quả hiện tại

Dự án đã vận hành được chuỗi mô phỏng PLC–Factory I/O–HMI trên máy phát triển. Màn hình tổng quan hiển thị trạng thái dây chuyền, bộ đếm hai nhánh và video trực tiếp của cửa sổ Factory I/O. Đã tạo bộ khởi động `ChayDuAn.exe` để mở HMI và chạy các tiến trình video ở nền, giảm thao tác mở terminal thủ công.

Đã xây dựng giao diện đăng nhập tùy chỉnh tiếng Việt, định hướng giao diện theo bốn cấp L1–L4 và đưa một mốc dự án native lên GitHub. Công việc hiện tại tập trung hoàn thiện màn hình L2: đèn lệnh thiết bị, đèn cảm biến và trạng thái chạy/dừng. Các thao tác điều khiển, cảnh báo và toàn bộ chuỗi vận hành vẫn cần được kiểm thử theo ma trận nghiệm thu.

Hai vấn đề cần tiếp tục theo dõi là lỗi nạp cấu hình WinCC xuất hiện không ổn định và khả năng chạy đầy đủ trên máy khác. Chưa có kết quả nghiệm thu với PLC/HMI vật lý.

## 2. Mục tiêu và cấu trúc hệ thống

### 2.1. Mục tiêu

- Giám sát và vận hành mô hình phân loại hàng bằng PLC S7-1200 trong môi trường mô phỏng.
- Tổ chức thông tin HMI theo cấp: tổng quan, vận hành, thiết bị và chẩn đoán.
- Hiển thị trạng thái từ PLC thay cho các nội dung minh họa tĩnh.
- Tích hợp video mô phỏng trực tiếp để thuận tiện theo dõi và trình diễn.
- Chuẩn hóa cách khởi động, cập nhật dữ liệu HMI và chia sẻ dự án qua GitHub.

### 2.2. Các thành phần

| Thành phần | Vai trò trong dự án |
|---|---|
| TIA Portal V20 | Cấu hình, lập trình và biên dịch PLC/HMI |
| PLC S7-1200, CPU 1211C theo dự án gốc | Thực hiện logic điều khiển mô hình |
| S7-PLCSIM V20 | Chạy PLC mô phỏng |
| Factory I/O 2.5.10 Ultimate trên máy phát triển | Mô phỏng băng tải, hàng hóa, cảm biến và cơ cấu phân loại |
| HMI TP900 Comfort, WinCC Runtime Advanced | Giao diện vận hành và giám sát trên PC |
| FFmpeg | Chụp cửa sổ Factory I/O và mã hóa video |
| MediaMTX | Cung cấp luồng RTSP cho Camera view |
| Launcher C# và script PowerShell | Khởi động HMI/video, quản lý tiến trình và đồng bộ dữ liệu |
| GitHub | Lưu trữ, quản lý các mốc thay đổi và chia sẻ dự án |

**Luồng điều khiển và giám sát:** PLC mô phỏng trao đổi I/O với Factory I/O qua driver Siemens S7-PLCSIM; HMI đọc trạng thái và trao đổi các yêu cầu vận hành qua kết nối HMI–PLC.

**Luồng video:** Cửa sổ Factory I/O → FFmpeg → MediaMTX → Camera view trên HMI. Luồng này phục vụ quan sát; kết nối video và kết nối PLC là hai phần riêng.

## 3. Các giai đoạn công việc đã thực hiện

| Giai đoạn | Công việc | Kết quả và mức xác nhận |
|---|---|---|
| 1. Tiếp nhận nền tảng | Sử dụng dự án TIA, scene Factory I/O và dữ liệu PLCSIM có sẵn; đối chiếu tên và địa chỉ I/O | Đã có nền tảng mô phỏng và bảng tham chiếu tag để triển khai HMI |
| 2. Tổ chức giao diện | Xác định chức năng L1–L4; xây dựng bố cục, ảnh nền và thanh điều hướng | Đã có các màn hình trong dự án TIA; mức hoàn thiện chức năng từng màn hình còn khác nhau |
| 3. Đăng nhập và phân quyền | Xây dựng popup tiếng Việt; xử lý việc chuyển L2/L3 gọi hộp đăng nhập hệ thống; Việt hóa thông báo sai thông tin đăng nhập | Đã được phản hồi xử lý được trong quá trình cấu hình; thao tác Enter tại ô tên/mật khẩu cần rà soát lại để xác nhận đầy đủ |
| 4. Màn hình L1 | Hiển thị trạng thái chạy, bộ đếm trái/phải và khu vực camera | Có ảnh Runtime cho thấy PLC kết nối, trạng thái chạy và giá trị bộ đếm; chế độ vận hành còn hiện “CHƯA XÁC ĐỊNH” trong ảnh kiểm tra |
| 5. Video trực tiếp | Thử FFmpeg, kiểm tra RTSP và nhúng video Factory I/O vào HMI | Đã hiển thị được video trực tiếp và được người thực hiện xác nhận hoạt động |
| 6. Đóng gói khởi động | Tạo `HMI_Portable`, mã launcher và script video chạy nền | Đã biên dịch được `ChayDuAn.exe` trên Windows và dùng để mở Runtime |
| 7. Đồng bộ dữ liệu | Xây dựng công cụ theo dõi đầu ra compile, sao chép đầy đủ dữ liệu HMI và giữ bản sao lưu | Công cụ AutoSync đã có trong repo; cần kiểm thử lặp lại và lưu minh chứng đồng bộ thành công |
| 8. Quản lý phiên bản | Cập nhật dự án native, Runtime và README lên GitHub; xử lý sai remote và xung đột README | Đã xác nhận mốc commit `7f00733` trên nhánh `main` |
| 9. Hoàn thiện L2 | Cấu hình tag và hướng dẫn thêm đèn lệnh, đèn cảm biến, ô chạy/dừng | Đang triển khai; chưa có xác nhận chạy thử đầy đủ cho toàn bộ đối tượng mới |
| 10. Sửa lỗi vòng đời video | Phân tích log và sửa supervisor để nhận lại Runtime sau khi PID thay đổi | Bản vá camera v1.1 đã được người thực hiện xác nhận chạy được trên máy phát triển |

Các giai đoạn thể hiện thứ tự phát triển, không phải bảng chấm công hoặc lịch hoàn thành cố định.

## 4. Tiến độ theo từng màn hình

| Màn hình | Nội dung đã có | Phần còn cần hoàn thiện |
|---|---|---|
| **L1 — Tổng quan** | Bố cục tổng quan; hiển thị trạng thái chạy, bộ đếm hai nhánh; Camera view đã phát video trực tiếp; khu vực người dùng và điều hướng | Hoàn thiện chế độ vận hành từ PLC; trạng thái mất kết nối; cảnh báo ưu tiên; xác nhận chức năng của từng đối tượng trong các tình huống lỗi |
| **L2 — Vận hành** | Ảnh nền sơ đồ chức năng; khung điều khiển; đã xác nhận cấu hình tag đầu vào `HMI_Q_Entry`; đã cung cấp thông số cho các đối tượng động bổ sung | Kiểm thử toàn bộ đèn, cảm biến, ô chạy/dừng; hoàn thiện Auto/Manual và các nút điều khiển theo logic PLC thực tế |
| **L3 — Thiết bị** | Đã có màn hình và luồng điều hướng; đã xử lý vấn đề hiển thị popup đăng nhập khi truy cập | Hoàn thiện thông tin từng cơ cấu, điều kiện cho phép, chạy tay và liên động; kiểm thử phân quyền |
| **L4 — Chẩn đoán** | Đã có màn hình và bố cục chẩn đoán | Hoàn thiện danh sách cảnh báo, xác nhận cảnh báo, trạng thái I/O, hướng dẫn xử lý lỗi và kiểm thử tình huống lỗi |

**Lưu ý về ảnh nền:** các khối “Đầu vào”, “Nạp/chuyển”, “Nhánh trái/phải” trong sơ đồ L2 là thành phần của ảnh nền. Đèn, nhãn và trường hiển thị được thêm bằng đối tượng WinCC riêng, đặt lên trên nền để có thể liên kết tag và gán animation.

### 4.1. Các tín hiệu đang dùng để hoàn thiện L2

| Nhóm | PLC tag | Địa chỉ | Chức năng hiển thị |
|---|---|---|---|
| Lệnh thiết bị | `Q_ConveyorEntry` | `%Q0.0` | Lệnh băng tải đầu vào |
| Lệnh thiết bị | `Q_Load` | `%Q0.1` | Lệnh nạp |
| Lệnh thiết bị | `Q_Unload` | `%Q0.2` | Lệnh xả |
| Lệnh thiết bị | `Q_TransferLeft` | `%Q0.3` | Lệnh chuyển trái |
| Lệnh thiết bị | `Q_TransferRight` | `%Q0.4` | Lệnh chuyển phải |
| Lệnh thiết bị | `Q_ConveyorLeft` | `%Q0.5` | Lệnh băng tải nhánh trái |
| Lệnh thiết bị | `Q_ConveyorRight` | `%Q0.6` | Lệnh băng tải nhánh phải |
| Cảm biến | `S_High` | `%I0.0` | Tín hiệu cảm biến cao |
| Cảm biến | `S_Low` | `%I0.1` | Tín hiệu cảm biến thấp |
| Cảm biến | `S_Pallet` | `%I0.2` | Tín hiệu pallet |
| Cảm biến | `S_Loaded` | `%I0.3` | Tín hiệu đã nạp |
| Trạng thái | `M_Run` | `%M10.0` | Hiển thị chạy/dừng |

Địa chỉ trên đã được đối chiếu với danh sách tag trong dữ liệu PLCSIM của repo. Cấu hình HMI sử dụng kết nối `HMI_Connection_1` và lựa chọn PLC tag qua symbolic access. Bảng này là danh sách tín hiệu dùng cho phần đang triển khai, không phải xác nhận tất cả đã được kiểm thử trên Runtime.

Đèn lệnh thiết bị được quy ước xám khi bằng 0, xanh lá khi bằng 1; đèn cảm biến xám khi bằng 0, xanh dương khi bằng 1. Đèn đọc `%Q` thể hiện **lệnh đầu ra PLC**, không tự chứng minh cơ cấu đã chuyển động nếu chưa có tín hiệu phản hồi riêng.

## 5. Kết quả tích hợp video và bộ khởi động

### 5.1. Video trực tiếp

Đã sử dụng FFmpeg với `gfxcapture` để lấy hình từ cửa sổ Factory I/O theo HWND. Cấu hình mã hóa là H.264, `yuv420p`, kích thước 640 × 360 và tốc độ đặt 10 khung hình/giây. Đây là thông số cấu hình, chưa phải kết quả đánh giá hiệu năng dài hạn.

Luồng được đưa vào Camera view qua địa chỉ cục bộ:

```text
rtsp://127.0.0.1:8554/factory
```

Giải pháp đã chạy được mà không dùng OBS. Cửa sổ Factory I/O cần được giữ mở, không thu nhỏ trong quá trình kiểm tra hiện tại.

### 5.2. Bộ khởi động và AutoSync

| Thành phần | Công việc thực hiện | Giới hạn hiện tại |
|---|---|---|
| `TaoBoChay.cmd` | Chuẩn bị dữ liệu và biên dịch launcher trên Windows | Không xác nhận HMI nạp thành công chỉ bằng kết quả biên dịch EXE |
| `ChayDuAn.exe` | Mở WinCC Runtime và gọi script video nền bằng đường dẫn tương đối | Không tự nạp chương trình PLC hoặc cấu hình driver Factory I/O |
| `Start-HmiVideo.ps1` | Khởi động và quản lý MediaMTX/FFmpeg | Bản v1.1 cần được cập nhật lại vào repo từ bản vá đã thử trên máy |
| `BatTuDongBo.cmd` | Cấu hình nguồn và bật theo dõi đầu ra compile | Cần kiểm thử đồng bộ qua nhiều lần compile |
| `TatTuDongBo.cmd` | Dừng AutoSync và gỡ tự khởi động | Không thay thế thao tác quản lý phiên bản Git |

AutoSync được thiết kế để đợi đầu ra ổn định khoảng 10 giây, chép qua thư mục tạm, đối chiếu SHA-256 và giữ một bản Runtime trước đó. Khi Runtime đang mở, công cụ chờ đóng trước khi cập nhật. Công cụ theo dõi file, không nhận trực tiếp sự kiện compile thành công từ TIA; vì vậy vẫn phải kiểm tra **0 errors** và trạng thái **SYNC OK** trước khi chia sẻ.

## 6. Các vấn đề đã gặp và cách xử lý

| Vấn đề | Phân tích và cách xử lý | Tình trạng |
|---|---|---|
| L2/L3 gọi hộp đăng nhập tiếng Đức | Điều chỉnh luồng đăng nhập/phân quyền để sử dụng popup tùy chỉnh; Việt hóa thông báo lỗi đăng nhập | Đã xử lý theo phản hồi trong quá trình cấu hình; cần kiểm thử lại các vai trò người dùng |
| Phải mở nhiều terminal để chạy video | Đưa thao tác khởi động MediaMTX/FFmpeg vào launcher và script chạy nền | Đã có bộ khởi động, được sử dụng trên máy phát triển |
| Camera không có hình khi dùng launcher | Log cho thấy FFmpeg đã phát video nhưng supervisor dừng theo PID Runtime cũ; HMI thực tế chạy bằng PID mới | Đã áp dụng bản vá nhận lại tiến trình Runtime và được xác nhận chạy được |
| Runtime khởi động lỗi rồi thử lại mới chạy | WinCC báo không nạp được `pdata.fwc`, xảy ra cả khi chạy từ TIA | Chưa xác định nguyên nhân gốc; rebuild chưa giải quyết dứt điểm. Cần tiếp tục kiểm tra phiên bản, môi trường và log |
| Đường dẫn gắn với máy tác giả | Chuyển bộ chạy sang thư mục tương đối `HMI_Portable`; chọn đường dẫn WinCC theo máy | Đã triển khai cơ chế; chưa xác nhận trên máy thứ hai |
| Compile xong phải chép dữ liệu HMI thủ công | Bổ sung AutoSync cho toàn bộ đầu ra `Generates` | Đã xây dựng công cụ; còn cần nghiệm thu vòng đồng bộ |
| Git trỏ sang repo khác | Điều chỉnh remote tới `duc2605/HMI` | Đã xử lý |
| Xung đột README khi rebase | Giữ bản README cập nhật, tiếp tục rebase và push | Đã xác nhận commit cập nhật trên GitHub |

Ở lỗi camera, log ghi PID được theo dõi là `13196`, trong khi phiên HMI đang hoạt động mang PID `17228`. Bản vá v1.1 tìm lại tiến trình `HmiRTm` và chờ tối đa 90 giây khi mất Runtime trước khi dừng video. Cách xử lý này khắc phục vòng đời video, **không khẳng định đã sửa lỗi nạp `pdata.fwc` của WinCC**.

## 7. Kiểm thử và mức độ xác nhận

| Hạng mục | Minh chứng/kết quả hiện có | Việc còn cần làm |
|---|---|---|
| PLC–Factory I/O | Có phiên mô phỏng chạy, trạng thái driver kết nối và hàng di chuyển trong ảnh thử nghiệm | Lưu biên bản kiểm thử logic phân loại, Start/Stop/Reset và dừng khẩn |
| HMI–PLC | Có ảnh L1 hiển thị kết nối, trạng thái chạy và giá trị bộ đếm | Kiểm tra tính đúng của từng tag, mất kết nối và phục hồi |
| Video trực tiếp | Đã hiển thị trong HMI; log FFmpeg có khung hình được phát | Chạy liên tục đủ lâu, đo độ trễ và tải CPU/GPU nếu cần đánh giá |
| Launcher | Có kết quả tạo EXE thành công và các phiên mở Runtime | Kiểm thử nhiều vòng đóng/mở, xử lý Runtime lỗi và chuyển PID |
| Bản vá camera v1.1 | Người thực hiện phản hồi đã hoạt động | Kiểm tra lặp lại và đưa bản vá vào GitHub |
| AutoSync | Có mã nguồn và cơ chế sao chép/kiểm tra dữ liệu | Ghi nhận nhiều lần compile → SYNC OK → mở lại đúng giao diện mới |
| L2 mới bổ sung | Có hướng dẫn cấu hình tag, vị trí, màu RGB và animation | Xác nhận toàn bộ đèn/ô chạy dừng trên Runtime |
| Phân quyền, Enter tại popup | Đã xử lý giao diện và trao đổi cấu hình | Kiểm thử tài khoản đúng/sai, đăng xuất, truy cập L2/L3 và bàn phím |
| Chạy trên máy khác | Có hướng dẫn cài đặt và tổ chức bộ chạy | Thử một máy Windows thứ hai với các phần mềm tương thích |

Chưa dùng các giá trị minh họa trên ảnh thiết kế làm số liệu thực nghiệm. Chưa có bộ số liệu đánh giá năng suất, độ chính xác phân loại hoặc độ tin cậy dài hạn.

## 8. Tình trạng lưu trữ và bàn giao

Mốc GitHub đã kiểm tra tại ngày lập báo cáo:

- **Nhánh:** `main`.
- **Commit:** [`7f00733`](https://github.com/duc2605/HMI/commit/7f0073394dc999ed2862ca05af9a3c852ab2d10c) — `Update HMI project, portable runtime, AutoSync and README`, ngày 21/10/2026.
- Có dự án TIA native, scene, dữ liệu PLCSIM và thư mục `HMI_Portable` với Runtime, mã launcher và AutoSync.
- Tại thời điểm đối chiếu, `Start-HmiVideo.ps1` trên `main` vẫn là bản theo dõi PID cố định. **Bản vá v1.1 đã thử trên máy chưa được phản ánh trong commit này.** Các chỉnh sửa L2 sau mốc push cũng cần được cập nhật lại từ máy phát triển.

Không cần giữ `HMI_Video` riêng khi đã chuyển đủ công cụ vào `HMI_Portable/Tools` và kiểm tra bộ chạy. Tuy nhiên, cần giữ dự án TIA gốc để chỉnh sửa; dữ liệu Runtime không thay thế mã nguồn dự án.

“Portable” không có nghĩa là chạy độc lập trên máy chưa cài phần mềm: máy nhận vẫn cần WinCC Runtime tương thích, Factory I/O và môi trường PLC/PLCSIM phù hợp. Công cụ EXE bên thứ ba được tải riêng hoặc đóng gói phát hành theo điều kiện giấy phép tương ứng.

## 9. Kế hoạch giai đoạn tiếp theo

| Ưu tiên | Công việc | Tiêu chí hoàn thành |
|---|---|---|
| 1 | Kiểm thử các đối tượng L2 đã cấu hình | Mỗi đèn đổi đúng theo tag; chạy/dừng hiển thị đúng; có ảnh/video và bảng kết quả |
| 2 | Hoàn thiện Auto/Manual, Start/Stop và reset trên HMI | Lệnh đi qua logic PLC đã đối chiếu; xác nhận ưu tiên dừng, điều kiện cho phép và chức năng từng nút |
| 3 | Hoàn thiện thông tin chế độ và cảnh báo trên L1 | Không còn trạng thái chế độ chưa xác định khi PLC có dữ liệu hợp lệ; cảnh báo phản ánh đúng điều kiện thực |
| 4 | Hoàn thiện L3 | Hiển thị trạng thái từng cơ cấu, điều kiện vận hành và chạy tay theo phân quyền/liên động |
| 5 | Hoàn thiện L4 | Danh sách cảnh báo, xác nhận, I/O và hướng dẫn xử lý; thử các tình huống lỗi đã định nghĩa |
| 6 | Ổn định bộ chạy và đồng bộ | Đưa bản vá camera lên GitHub; kiểm thử AutoSync và xử lý lỗi khởi động WinCC |
| 7 | Chuẩn hóa bàn giao | Clone/tải sang thư mục mới và chạy thử trên máy thứ hai; cập nhật README, lưu video trình diễn và biên bản kiểm thử |

Không đặt mốc thời gian hoặc tỷ lệ hoàn thành định lượng khi chưa thống nhất lịch và tiêu chí nghiệm thu với giảng viên.

## 10. Trình tự trình diễn tiến độ cho giảng viên

1. Giới thiệu mục tiêu và các thành phần PLC, Factory I/O, HMI.
2. Mở mô phỏng PLC, kiểm tra CPU RUN và Factory I/O kết nối.
3. Dùng `ChayDuAn.exe` mở HMI; trình diễn L1 với video trực tiếp, trạng thái chạy và bộ đếm.
4. Mở L2, trình diễn những đèn/trường hiển thị đã kiểm thử. Những phần mới cấu hình hoặc chưa kiểm thử được nêu rõ là công việc đang làm.
5. Trình bày lỗi camera theo PID đã xử lý, vấn đề nạp WinCC còn tồn tại và kế hoạch hoàn thiện L3/L4.
6. Mở GitHub để chỉ ra mốc bàn giao và các thay đổi còn cần cập nhật từ máy phát triển.

### Nội dung báo cáo ngắn

> Nhóm đã xây dựng được nền tảng mô phỏng tích hợp PLC S7-1200, Factory I/O và HMI WinCC Runtime Advanced. Màn hình tổng quan đã hiển thị trạng thái, bộ đếm và video trực tiếp của mô hình; bộ launcher giúp khởi động HMI và video nền thuận tiện hơn. Nhóm đã xử lý được lỗi video bị dừng khi tiến trình Runtime thay đổi PID và đang hoàn thiện các đối tượng động trên màn hình vận hành L2. Các phần phân quyền, điều khiển, cảnh báo và đồng bộ sau compile cần được kiểm thử đầy đủ; lỗi nạp cấu hình WinCC không ổn định vẫn đang được theo dõi. Giai đoạn tiếp theo tập trung hoàn thiện L2–L4, lập biên bản kiểm thử và xác nhận khả năng chạy trên máy khác.
