HMI PORTABLE - WINCC RUNTIME ADVANCED + FACTORY I/O VIDEO

CHUAN BI TREN MAY DUC
1. Giai nen, doi ten thu muc thanh HMI_Portable, dat tai:
   C:\Users\duc\projects\Hust\HMI\HMI_Portable
   TaoBoChay.cmd phai nam ngay trong HMI_Portable, khong long them mot cap.
2. Trong TIA, bo StartProgram cu goi video o L1 > Events > Loaded.
   Giu nguyen cac ham khac. Compile HMI roi dong Runtime.
   Camera view van dung rtsp://127.0.0.1:8554/factory
3. Chay TaoBoChay.cmd mot lan. Script tu copy 3 file tu HMI_Video
   va toan bo Generates tu du an goc sang Runtime, roi bien dich launcher.
   Neu khong tim thay du an, script hien hop thoai chon pdata.fwc.
4. Luu mot ban scene Factory I/O (.factoryio) vao FactoryIO.
5. Dong cac terminal video cu, roi bam ChayDuAn.exe de kiem thu.

MOI LAN CHAY
- Bam ChayDuAn.exe; khong can mo PowerShell/CMD thu cong.
- Launcher mo scene qua lien ket file Windows neu Factory I/O chua mo.
  Neu chua co lien ket file, mo scene thu cong; launcher se thong bao.
- Khong thu nho cua so Factory I/O. Video can vai giay de khoi dong.
- PLC/PLCSIM, driver Factory I/O va ket noi PLC van phai duoc thiet lap.
  Bo nay khong khoi dong/cau hinh PLC tu dong.
- Dong Runtime: supervisor dung encoder va MediaMTX do no tao ra.
  Khong tat MediaMTX co san do chuong trinh khac khoi dong.

CHIA SE
- Chia se ca HMI_Portable sau khi da chay TaoBoChay.cmd thanh cong.
  Giu ChayDuAn.exe, Runtime/, Tools/, FactoryIO/ cung cap.
- May nhan can Windows ho tro gfxcapture, WinCC Runtime Advanced tuong thich
  voi du an V20, Factory I/O va moi truong PLC phu hop.
- Khong copy thu muc cai dat Siemens/Factory I/O vao goi chia se.
- Neu GitHub bao file vuot gioi han, dua goi ZIP day du vao GitHub Releases.
  Giu cac thong bao ban quyen/giay phep kem theo ban FFmpeg va MediaMTX ban phan phoi.
- File nguon va script di kem khong can Python, Node.js hay OBS.
- File exe chua duoc bien dich san; TaoBoChay.cmd tao no tren Windows
  bang trinh bien dich .NET Framework co san neu may da cai Framework 4.x.

CAP NHAT MAN HINH HMI
Runtime/ la ban sao tai thoi diem dong goi. Sau khi sua trong TIA va compile,
dong Runtime va copy lai TOAN BO noi dung Generates vao Runtime/.
TaoBoChay.cmd khong ghi de Runtime/pdata.fwc da dong goi.
Anh/du lieu ngoai dung duong dan tuyet doi trong HMI can duoc kiem tra rieng.

LOI VIDEO
Xem Tools/video-logs/supervisor.log va ffmpeg-error.log.
Neu chua hien, cho Factory I/O mo xong va thu chuyen L2 roi ve L1.
Neu ffmpeg bao khong co gfxcapture, ban ffmpeg duoc copy khac ban da kiem thu.

GIOI HAN KIEM THU
Ma nguon goi nay duoc soat tinh. Chua chay thu launcher tren Windows/WinCC.
Can kiem thu tren may Duc roi tren may thu hai truoc khi coi la ban phat hanh.
