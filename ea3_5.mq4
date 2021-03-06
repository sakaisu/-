//本サイトライブラリ
#include "LibEA4.mqh"

input int FastEMAPeriod = 12; //短期EMAの期間
input int SlowEMAPeriod = 26; //長期EMAの期間
input int SignalPeriod = 9; //MACDにかけるSMAの期間
input double Lots = 0.1; //売買ロット数

//ティック時実行関数
void OnTick()
{
   int sig_entry = EntrySignal(); //仕掛けシグナル
   //成行売買
   MyOrderSendMarket(sig_entry, sig_entry, Lots);
}

//仕掛けシグナル関数
int EntrySignal()
{
   //１本前のMACD
   double MACD1 = iMACD(_Symbol, 0, FastEMAPeriod, SlowEMAPeriod, SignalPeriod, PRICE_CLOSE, MODE_MAIN, 1);
   double Signal1 = iMACD(_Symbol, 0, FastEMAPeriod, SlowEMAPeriod, SignalPeriod, PRICE_CLOSE, MODE_SIGNAL, 1);
   //２本前のMACD
   double MACD2 = iMACD(_Symbol, 0, FastEMAPeriod, SlowEMAPeriod, SignalPeriod, PRICE_CLOSE, MODE_MAIN, 2);
   double Signal2 = iMACD(_Symbol, 0, FastEMAPeriod, SlowEMAPeriod, SignalPeriod, PRICE_CLOSE, MODE_SIGNAL, 2);

   int ret = 0; //シグナルの初期化

   //買いシグナル
   if(MACD2 <= Signal2 && MACD1 > Signal1 && MACD1 < 0) ret = 1;
   //売りシグナル
   if(MACD2 >= Signal2 && MACD1 < Signal1 && MACD1 > 0) ret = -1;

   return ret; //シグナルの出力
}
