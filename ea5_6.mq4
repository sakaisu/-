//本サイトライブラリ
#include "LibEA4.mqh"

input int RSIPeriod = 14; //RSIの期間
input int StartHour = 12; //開始時刻（時）
input int StartMin = 30; //開始時刻（分）
input int TradeMin = 120; //フィルタ期間（分）
input double Lots = 0.1; //売買ロット数

//ティック時実行関数
void OnTick()
{
   int sig_entry = EntrySignal(); //仕掛けシグナル
   int sig_filter = FilterSignal(sig_entry); //タイムフィルタ
   //成行売買
   MyOrderSendMarket(sig_filter, sig_entry, Lots);
}

//仕掛けシグナル関数
int EntrySignal()
{
   //１本前のRSI
   double RSI1 = iRSI(_Symbol, 0, RSIPeriod, PRICE_CLOSE, 1);

   int ret = 0; //シグナルの初期化

   //買いシグナル
   if(RSI1 < 30) ret = 1;
   //売りシグナル
   if(RSI1 > 70) ret = -1;

   return ret; //シグナルの出力
}

//フィルタ関数
int FilterSignal(int signal)
{
   //開始時刻の作成
   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);
   dt.hour = StartHour;
   dt.min = StartMin;
   dt.sec = 0;
   datetime StartTime = StructToTime(dt);

   int ret = 0; //シグナルの初期化

   //売買シグナルのフィルタ
   if(TimeCurrent() >= StartTime && TimeCurrent() < StartTime+TradeMin*60) ret = signal;

   return ret; //シグナルの出力
}
