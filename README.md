# snake_game_box
ゲーミング貯金箱

## ピンアサインファイルの読み込み
1. Aggisnments -> Import Assignments -> ...(ファイル参照)
2. [`snake_game_box/FPGA_project/pin_assignments/DE10-Lite_pin.qsf`](https://github.com/2019-team4/snake_game_box/blob/master/FPGA_Project/pin_assignments/DE10-Lite_pin.qsf)を指定 -> OK
3. Message画面に下のような表示が出ていれば成功
```
Info (140120): Import completed.  370 assignments were written (out of 370 read).  0 non-global assignments were skipped because of entity name mismatch.
```

## 定義済み変数

| Variable     | Description   |
|--------------|---------------|
| LEDR[9:0]    | LED(Red)×10   |
| SW[9:0]      | Switch×10     |
| CLK1_50      | Clock(50Mhz)  |
| CLK2_50      | Clock(50Mhz)  |
| HEX0～5[7:0] | 7 segment LED |
| GPIO[35:0]   | GPIO pins     |
