//本サイトライブラリ
#include "LibEA4.mqh"

input int FastMAPeriod = 20; //短期移動平均の期間
input int SlowMAPeriod = 50; //長期移動平均の期間
input double TSpips = 25; //トレイリングストップ幅(pips)
input double Lots = 0.1; //売買ロット数

//ティック時実行関数
void OnTick()
{
   //トレイリングストップのセット
   double profit = MyOrderProfitPips() - TSpips;
   double sl = MyOrderStopLoss();
   if(sl == 0 || profit > MyOrderShiftPips(sl))
      MyOrderModify(0, MyOrderShiftPrice(profit), 0);

   int sig_entry = EntrySignal(); //仕掛けシグナル
   //成行売買
   MyOrderSendMarket(sig_entry, sig_entry, Lots);
}

//仕掛けシグナル関数
int EntrySignal()
{
   //１本前と２本前の移動平均
   double FastMA1 = iMA(_Symbol, 0, FastMAPeriod, 0, MODE_SMA, PRICE_CLOSE, 1);
   double FastMA2 = iMA(_Symbol, 0, FastMAPeriod, 0, MODE_SMA, PRICE_CLOSE, 2);
   double SlowMA1 = iMA(_Symbol, 0, SlowMAPeriod, 0, MODE_SMA, PRICE_CLOSE, 1);
   double SlowMA2 = iMA(_Symbol, 0, SlowMAPeriod, 0, MODE_SMA, PRICE_CLOSE, 2);

   int ret = 0; //シグナルの初期化

   //買いシグナル
   if(FastMA2 <= SlowMA2 && FastMA1 > SlowMA1) ret = 1;
   //売りシグナル
   if(FastMA2 >= SlowMA2 && FastMA1 < SlowMA1) ret = -1;

   return ret; //シグナルの出力
}
