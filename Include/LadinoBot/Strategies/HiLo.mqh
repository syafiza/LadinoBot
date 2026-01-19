//+------------------------------------------------------------------+
//|                                                         HiLo.mqh |
//|                                                   Rodrigo Landim |
//|                                        http://www.emagine.com.br |
//+------------------------------------------------------------------+
#property copyright "Rodrigo Landim"
#property link      "http://www.emagine.com.br"
#property version   "1.10"

#resource "\\Indicators\\gann_hi_lo_activator_ssl.ex5"

#include <LadinoBot/Utils.mqh>

class HiLo {
private:
   ENUM_TREND_SIGNAL _currentTrend;
   int _hiloHandle;
   int _period;

public:
   HiLo();
   bool Initialize(int period = 4, ENUM_TIMEFRAMES timeframe = PERIOD_CURRENT, long chartId = 0);
   double GetCurrentPosition();
   ENUM_TREND_SIGNAL GetCurrentTrend();
   bool VerifyTrendChange();
   virtual void OnTrendChange(ENUM_TREND_SIGNAL newTrend);
};

HiLo::HiLo() {
   _hiloHandle = 0;
   _currentTrend = SIGNAL_UNDEFINED;
   _period = 4;
}

bool HiLo::Initialize(int period = 4, ENUM_TIMEFRAMES timeframe = PERIOD_CURRENT, long chartId = 0) {
   _period = period;
   _hiloHandle = iCustom(_Symbol, timeframe, "::Indicators\\gann_hi_lo_activator_ssl", _period);
   
   if (_hiloHandle == INVALID_HANDLE) {
      Print("Error creating HiLo indicator");
      return false;
   }
   
   ChartIndicatorAdd(chartId, 0, _hiloHandle);
   return true;
}

double HiLo::GetCurrentPosition() {
   double hiloBuffer[1];
   if (CopyBuffer(_hiloHandle, 0, 0, 1, hiloBuffer) != 1) {
      Print("CopyBuffer from HiLo failed, no data");
      return -1;
   }
   return hiloBuffer[0];
}

ENUM_TREND_SIGNAL HiLo::GetCurrentTrend() {
   double hiloTrend[1];
   if (CopyBuffer(_hiloHandle, 4, 0, 1, hiloTrend) != 1) {
      Print("CopyBuffer from HiLo failed, no data");
      return SIGNAL_UNDEFINED;
   }
   
   if (hiloTrend[0] > 0)
      return SIGNAL_UP;
   else if (hiloTrend[0] < 0)
      return SIGNAL_DOWN;
   else
      return SIGNAL_UNDEFINED;
}

bool HiLo::VerifyTrendChange() {
   ENUM_TREND_SIGNAL trend = GetCurrentTrend();
   if (_currentTrend != trend) {
      _currentTrend = trend;
      OnTrendChange(_currentTrend);
   }
   return true;
}

void HiLo::OnTrendChange(ENUM_TREND_SIGNAL newTrend) {
   // Virtual method, can be overridden
}
