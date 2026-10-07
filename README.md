tôi là Đức, tôi thèm ăn cứt, tôi yêu cứt


file 1 mở trong Factory IO;
file 2 mở trong TIA Portal V20;
file 3 mở trong S7 - PCLSIM V20;
* Bước 1: mở 3 app trên
* Bước 2: mở file Nhom2_FactoryIO_Template_S7-1200_V20_Version1.ap20 trong TIA Portal V20
* Bước 3: mở thư mục Nhom2_PLCSIMV20_Version1
* Bước 4: mở file Nhom2_IOFactory_Version1.factoryio trong Factory IO phiên bản 2.5.10
* Bước 5: kết nối
- Trong TIA Portal V20:
  + vào PLC_1 [CPU 1211C DC/DC/DC] -> Program blocks -> Main [OB1] ấn Save → Compile → Download to device -> Go online và bật Monitoring
  + màn hình hiện ra nhấn connect
- Trong PLCSIM ấn run
- Trong Factory IO ấn F4, chọn PCLSIM 1200 -> connect
Bước 6: ấn chạy thử, mở start, stop trên bảng điều khiển
- stop -> start -> realse stop
* Fact: xem số lượng hàng thì vào watch and force tables -> Forcetabelle -> Monitor all
