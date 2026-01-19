//+------------------------------------------------------------------+
//|                                                        Utils.mqh |
//|                                                   Rodrigo Landim |
//|                                        http://www.emagine.com.br |
//+------------------------------------------------------------------+
#property copyright "Rodrigo Landim"
#property link      "http://www.emagine.com.br"
#property version   "1.10"

#include <LadinoBot/Languages/en.mqh>

const int CANDLES_TO_VERIFY = 100;

enum ENUM_CANDLE_FORMAT {
   FORMAT_NONE,
   FORMAT_SHORT,
   FORMAT_LONG,
   FORMAT_DOJI,
   FORMAT_HAMMER,
   FORMAT_INVERTED_HAMMER,
   FORMAT_MARUBOZU,
   FORMAT_LONG_MARUBOZU,
   FORMAT_SPINNING_TOP
};

enum ENUM_CANDLE_PATTERN {
   PATTERN_UNDEFINED,
   PATTERN_INSIDE_CANDLE_UP,
   PATTERN_INSIDE_CANDLE_DOWN,
   PATTERN_ENGULFING,
   PATTERN_SHOOTING_STAR,
   PATTERN_HAMMER,
   PATTERN_INVERTED_HAMMER,
   PATTERN_BULL_BELT_HOLD,
   PATTERN_BEAR_BELT_HOLD
};

enum ENUM_CANDLE_TYPE {
   TYPE_NONE,
   TYPE_BUYER,
   TYPE_SELLER
};

enum ENUM_OPERATION {
   TRADE_BUY_SELL,  // Buy and Sell
   TRADE_ONLY_BUY,  // Only Buy
   TRADE_ONLY_SELL  // Only Sell
};

enum ENUM_OPERATION_TYPE {
   TYPE_LIQUID,
   TYPE_BREAKOUT,
   TYPE_HILO,
   TYPE_INSIDE_CANDLE,
   TYPE_PRICE_ACTION,
   TYPE_SCALPER,
   TYPE_SCALPER_CONTRA,
   TYPE_MM_CROSS
};

enum ENUM_BOT_STATUS {
   STATUS_INITIALIZED,
   STATUS_ACTIVE,
   STATUS_INACTIVE,
   STATUS_CLOSING
};

enum ENUM_TREND_SIGNAL {
   SIGNAL_UNDEFINED,
   SIGNAL_UP,
   SIGNAL_DOWN
};

enum ENUM_POSITION_SIGNAL {
   SIGNAL_POSITION_NONE,
   SIGNAL_POSITION_BUY,
   SIGNAL_POSITION_SELL
};

// Refactored Time Enum: Simple hourly/half-hourly blocks
enum ENUM_TRADING_TIME {
   TIME_0800 = 480,  // Minutes from midnight
   TIME_0830 = 510,
   TIME_0900 = 540,
   TIME_0930 = 570,
   TIME_1000 = 600,
   TIME_1030 = 630,
   TIME_1100 = 660,
   TIME_1130 = 690,
   TIME_1200 = 720,
   TIME_1230 = 750,
   TIME_1300 = 780,
   TIME_1330 = 810,
   TIME_1400 = 840,
   TIME_1430 = 870,
   TIME_1500 = 900,
   TIME_1530 = 930,
   TIME_1600 = 960,
   TIME_1630 = 990,
   TIME_1700 = 1020,
   TIME_1730 = 1050,
   TIME_1800 = 1080
};

enum ENUM_TIME_CONDITION {
   CONDITION_GREATER_OR_EQUAL,
   CONDITION_LESS_OR_EQUAL,
   CONDITION_GREATER,
   CONDITION_LESS
};

enum ENUM_GRAPH_TIME {
   TIME_T1,
   TIME_T2,
   TIME_T3
};

enum ENUM_ENTRY_CONDITION {
   HILO_MM_CROSS_T1_TICK,
   HILO_MM_CROSS_T2_TICK,
   HILO_MM_CROSS_T3_TICK,
   HILO_MM_CROSS_T1_CLOSE,
   HILO_MM_CROSS_T2_CLOSE,
   HILO_MM_CROSS_T3_CLOSE,
   ONLY_TREND_T1 = 12,
   ONLY_TREND_T2 = 13,
   ONLY_TREND_T3 = 14
};

enum ENUM_RISK {
   RISK_NORMAL = 0,
   RISK_PROGRESSIVE = 1
};

enum ENUM_GOAL {
   GOAL_NONE = 0,
   GOAL_FIXED_POSITION = 1,
   GOAL_TRENDLINE_BREAK = 2,
   GOAL_DUNNIGAN_PRICE_ACTION = 3,
   GOAL_T1_FIBO_382 = 4,
   GOAL_T2_FIBO_382 = 5,
   GOAL_T3_FIBO_382 = 6,
   GOAL_T1_FIBO_618 = 7,
   GOAL_T2_FIBO_618 = 8,
   GOAL_T3_FIBO_618 = 9,
   GOAL_T1_FIBO_1000 = 10,
   GOAL_T2_FIBO_1000 = 11,
   GOAL_T3_FIBO_1000 = 12,
   GOAL_T1_FIBO_1382 = 13,
   GOAL_T2_FIBO_1382 = 14,
   GOAL_T3_FIBO_1382 = 15,
   GOAL_T1_FIBO_1618 = 16,
   GOAL_T2_FIBO_1618 = 17,
   GOAL_T3_FIBO_1618 = 18,
   GOAL_T1_FIBO_2000 = 19,
   GOAL_T2_FIBO_2000 = 20,
   GOAL_T3_FIBO_2000 = 21,
   GOAL_T1_FIBO_2618 = 22,
   GOAL_T2_FIBO_2618 = 23,
   GOAL_T3_FIBO_2618 = 24
};

enum ENUM_STOP {
   STOP_FIXED = 0,
   STOP_T1_HILO = 1,
   STOP_T2_HILO = 2,
   STOP_T3_HILO = 3,
   STOP_T1_TOP_BOTTOM = 4,
   STOP_T2_TOP_BOTTOM = 5,
   STOP_T3_TOP_BOTTOM = 6,
   STOP_T1_PRIOR_CANDLE = 7,
   STOP_T2_PRIOR_CANDLE = 8,
   STOP_T3_PRIOR_CANDLE = 9,
   STOP_T1_CURRENT_CANDLE = 10,
   STOP_T2_CURRENT_CANDLE = 11,
   STOP_T3_CURRENT_CANDLE = 12
};

enum ENUM_OPERATION_STATUS {
   STATUS_OP_OPEN,
   STATUS_OP_BREAK_EVEN,
   STATUS_OP_GOAL1,
   STATUS_OP_GOAL2,
   STATUS_OP_GOAL3,
   STATUS_OP_CLOSED
};

enum ENUM_SUPPORT_RESISTANCE {
   TYPE_SUPPORT,
   TYPE_RESISTANCE
};

enum ENUM_ASSET {
   ASSET_INDEX,
   ASSET_STOCK
};

struct TRADE_POSITION {
   double entryPrice;
   double brokerage;
   double initialVolume;
   double currentVolume;
};

struct TRADE_CLOSED {
   datetime time;
   int success;
   int failure;
   double brokerage;
   double financial;
};

struct SUPPORT_RESISTANCE_DATA {
   int index;
   datetime time;
   double position;
   ENUM_SUPPORT_RESISTANCE type;
};

struct CANDLE_DATA {
   datetime time;
   double open;
   double high;
   double low;
   double close;
   double body;
   double wick;
   double upperShadow;
   double lowerShadow;
   double size;
   ENUM_TREND_SIGNAL trend;
   ENUM_CANDLE_TYPE type;
   ENUM_CANDLE_FORMAT format;
};

//+------------------------------------------------------------------+
//| MQL4 Compatibility Helpers                                       |
//+------------------------------------------------------------------+

datetime iTimeMQL4(string symbol, int tf_minutes, int index) {
   if (index < 0) return -1;
   ENUM_TIMEFRAMES period = TFMigrate(tf_minutes);
   datetime timeArr[];
   if (CopyTime(symbol, period, index, 1, timeArr) > 0)
      return timeArr[0];
   else
      return -1;
}

ENUM_TIMEFRAMES TFMigrate(int tf_minutes) {
   switch(tf_minutes) {
      case 0: return(PERIOD_CURRENT);
      case 1: return(PERIOD_M1);
      case 2: return(PERIOD_M2);
      case 3: return(PERIOD_M3);
      case 4: return(PERIOD_M4);
      case 5: return(PERIOD_M5);
      case 6: return(PERIOD_M6);
      case 10: return(PERIOD_M10);
      case 12: return(PERIOD_M12);
      case 15: return(PERIOD_M15);
      case 20: return(PERIOD_M20);
      case 30: return(PERIOD_M30);
      case 60: return(PERIOD_H1);
      case 120: return(PERIOD_H2);
      case 180: return(PERIOD_H3);
      case 240: return(PERIOD_H4);
      case 360: return(PERIOD_H6);
      case 480: return(PERIOD_H8);
      case 720: return(PERIOD_H12);
      case 1440: return(PERIOD_D1);
      case 10080: return(PERIOD_W1);
      case 43200: return(PERIOD_MN1);
      default: return(PERIOD_CURRENT);
   }
}

//+------------------------------------------------------------------+
//| Fibonacci Calculation                                            |
//+------------------------------------------------------------------+

bool CalculateFibo(double origin, double destination, double &projections[]) {
   double values[];
   ArrayResize(values, ArraySize(projections));
   double range = (origin > destination) ? (origin - destination) : (destination - origin);
   
   for (int i = 0; i < ArraySize(values); i++) {
      if (i == 0) values[i] = range * 0.382;
      else if (i == 1) values[i] = range * 0.618;
      else if (i == 2) values[i] = range;
      else if (i == 3) values[i] = range + (range * 0.618);
      else if (i > 3)  values[i] = values[i-1] + values[i-2];
   }
   
   if (origin < destination) {
      for (int i = 0; i < ArraySize(projections); i++)
         projections[i] = destination - values[i];
   } else {
      for (int i = 0; i < ArraySize(projections); i++)
         projections[i] = destination + values[i];
   }
   return true;
}

//+------------------------------------------------------------------+
//| GUI Helpers                                                      |
//+------------------------------------------------------------------+

long CreateSubChart(string name, ENUM_TIMEFRAMES period = PERIOD_CURRENT, int width = 320, int height = 240, int x = 10, int y = 250) {
   long subChartId = 0;
   if (ObjectCreate(0, name, OBJ_CHART, 0, 0, 0)) {
      ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_LOWER);
      ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
      ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
      ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
      ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
      ObjectSetInteger(0, name, OBJPROP_CHART_SCALE, 1);
      ObjectSetInteger(0, name, OBJPROP_DATE_SCALE, false);
      ObjectSetInteger(0, name, OBJPROP_PRICE_SCALE, false);
      ObjectSetString(0, name, OBJPROP_SYMBOL, _Symbol);
      ObjectSetInteger(0, name, OBJPROP_PERIOD, period);
      ObjectSetInteger(0, name, OBJPROP_BACK, false);
      ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, name, OBJPROP_COLOR, clrWhite);
      
      subChartId = ObjectGetInteger(0, name, OBJPROP_CHART_ID);
      ChartSetInteger(subChartId, CHART_SHOW_GRID, false);
      ChartSetInteger(subChartId, CHART_MODE, CHART_CANDLES);
      ChartSetInteger(subChartId, CHART_AUTOSCROLL, true);
      ChartSetInteger(subChartId, CHART_SHOW_OHLC, false);
      ChartSetInteger(subChartId, CHART_SHOW_TRADE_LEVELS, true);
      ChartSetInteger(subChartId, CHART_SHOW_BID_LINE, false);
      ChartSetInteger(subChartId, CHART_SHOW_ASK_LINE, false);
      ChartSetInteger(subChartId, CHART_COLOR_LAST, clrLimeGreen);
      ChartSetInteger(subChartId, CHART_COLOR_STOP_LEVEL, clrRed);
      
      ChartRedraw(subChartId);
      ChartRedraw();
   }
   return subChartId;
}

void CreateLabel(long chartId, string name, string text, int x, int y, string font = "Tahoma", int size = 8, int color = clrWhiteSmoke, int corner = CORNER_RIGHT_UPPER, int anchor = ANCHOR_RIGHT) {
   if (ObjectCreate(chartId, name, OBJ_LABEL, 0, 0, 0)) {
      ObjectSetInteger(chartId, name, OBJPROP_XDISTANCE, y);
      ObjectSetInteger(chartId, name, OBJPROP_YDISTANCE, x);
      ObjectSetInteger(chartId, name, OBJPROP_CORNER, corner);
      ObjectSetInteger(chartId, name, OBJPROP_ANCHOR, anchor);
      ObjectSetInteger(chartId, name, OBJPROP_COLOR, color);
      ObjectSetString(chartId, name, OBJPROP_TEXT, text);
      ObjectSetString(chartId, name, OBJPROP_FONT, font);
      ObjectSetInteger(chartId, name, OBJPROP_FONTSIZE, size);
      ObjectSetInteger(chartId, name, OBJPROP_SELECTABLE, false);
      ObjectSetInteger(chartId, name, OBJPROP_HIDDEN, true);
   }
}

//+------------------------------------------------------------------+
//| Time Comparison Helpers                                          |
//+------------------------------------------------------------------+

bool CheckTimeCondition(ENUM_TRADING_TIME targetTime, ENUM_TIME_CONDITION condition) {
   MqlDateTime dt;
   TimeCurrent(dt);
   int currentMinutes = (dt.hour * 60) + dt.min;
   int targetMinutes = (int)targetTime;
   
   switch(condition) {
      case CONDITION_GREATER_OR_EQUAL: return currentMinutes >= targetMinutes;
      case CONDITION_LESS_OR_EQUAL:    return currentMinutes <= targetMinutes;
      case CONDITION_GREATER:          return currentMinutes > targetMinutes;
      case CONDITION_LESS:             return currentMinutes < targetMinutes;
      default: return false;
   }
}

string MoneyToString(double money) {
   return StringFormat("%.2f", NormalizeDouble(money, 2));
}

//+------------------------------------------------------------------+
//| Backward Compatibility: Portuguese -> English Type Aliases      |
//| These allow gradual migration from old Portuguese names         |
//+------------------------------------------------------------------+

// VELA -> CANDLE_DATA
#define VELA CANDLE_DATA

// ENUM_SINAL_TENDENCIA -> ENUM_TREND_SIGNAL
#define ENUM_SINAL_TENDENCIA ENUM_TREND_SIGNAL
#define INDEFINIDA SIGNAL_UNDEFINED
#define ALTA SIGNAL_UP
#define BAIXA SIGNAL_DOWN

// ENUM_SINAL_POSICAO -> ENUM_POSITION_SIGNAL
#define ENUM_SINAL_POSICAO ENUM_POSITION_SIGNAL

// ENUM_VELA_PADRAO -> ENUM_CANDLE_PATTERN
#define ENUM_VELA_PADRAO ENUM_CANDLE_PATTERN
#define INDEFINIDO PATTERN_UNDEFINED
#define INSIDE_CANDLE_ALTA PATTERN_INSIDE_CANDLE_UP
#define INSIDE_CANDLE_BAIXA PATTERN_INSIDE_CANDLE_DOWN
#define ENFORCADO PATTERN_ENGULFING
#define ESTRELA_CADENTE PATTERN_SHOOTING_STAR
#define MARTELO PATTERN_HAMMER
#define MARTELO_INVERTIDO PATTERN_INVERTED_HAMMER
#define BELT_HOLD_BULL PATTERN_BULL_BELT_HOLD
#define BELT_HOLD_BEAR PATTERN_BEAR_BELT_HOLD

// ENUM_VELA_FORMATO -> ENUM_CANDLE_FORMAT
#define ENUM_VELA_FORMATO ENUM_CANDLE_FORMAT
#define FORMATO_NENHUM FORMAT_NONE
#define FORMATO_CURTA FORMAT_SHORT
#define FORMATO_LONGA FORMAT_LONG
#define FORMATO_DOJI FORMAT_DOJI
#define FORMATO_MARTELO FORMAT_HAMMER
#define FORMATO_MARTELO_INVERTIDO FORMAT_INVERTED_HAMMER
#define FORMATO_MARIBOZU FORMAT_MARUBOZU
#define FORMATO_MARIBOZU_LONGO FORMAT_LONG_MARUBOZU
#define FORMATO_SPIN_TOP FORMAT_SPINNING_TOP

// ENUM_VELA_TIPO -> ENUM_CANDLE_TYPE
#define ENUM_VELA_TIPO ENUM_CANDLE_TYPE
#define NENHUM TYPE_NONE
#define COMPRADORA TYPE_BUYER
#define VENDEDORA TYPE_SELLER

// ENUM_OBJETIVO -> ENUM_GOAL
#define ENUM_OBJETIVO ENUM_GOAL
#define OBJETIVO_NENHUM GOAL_NONE
#define OBJETIVO_FIXO GOAL_FIXED_POSITION
#define OBJETIVO_LT GOAL_TRENDLINE_BREAK
#define OBJETIVO_DUNNIGAN GOAL_DUNNIGAN_PRICE_ACTION

// DADOS_SR -> SUPPORT_RESISTANCE_DATA
#define DADOS_SR SUPPORT_RESISTANCE_DATA
#define TIPO_SUPORTE TYPE_SUPPORT
#define TIPO_RESISTENCIA TYPE_RESISTANCE

// ENUM_SITUACAO_ROBO -> ENUM_BOT_STATUS
#define ENUM_SITUACAO_ROBO ENUM_BOT_STATUS
#define INICIALIZADO STATUS_INITIALIZED
#define ATIVO STATUS_ACTIVE
#define INATIVO STATUS_INACTIVE
#define FECHANDO STATUS_CLOSING

// ENUM_OPERACAO_SITUACAO -> ENUM_OPERATION_STATUS
#define ENUM_OPERACAO_SITUACAO ENUM_OPERATION_STATUS
#define SITUACAO_ABERTA STATUS_OP_OPEN
#define SITUACAO_BREAK_EVEN STATUS_OP_BREAK_EVEN
#define SITUACAO_OBJETIVO1 STATUS_OP_GOAL1
#define SITUACAO_OBJETIVO2 STATUS_OP_GOAL2
#define SITUACAO_OBJETIVO3 STATUS_OP_GOAL3
#define SITUACAO_FECHADA STATUS_OP_CLOSED

// ENUM_ATIVO -> ENUM_ASSET
#define ENUM_ATIVO ENUM_ASSET
#define ATIVO_INDICE ASSET_INDEX
#define ATIVO_ACAO ASSET_STOCK

// ENUM_RISCO compatibility (already in English but may have Portuguese references)
#define RISCO_NORMAL RISK_NORMAL
#define RISCO_PROGRESSIVO RISK_PROGRESSIVE

// ENUM_OPERACAO compatibility
#define COMPRAR_VENDER TRADE_BUY_SELL
#define APENAS_COMPRA TRADE_ONLY_BUY
#define APENAS_VENDA TRADE_ONLY_SELL

// Candle struct member aliases
#define tempo time
#define abertura open
#define maxima high
#define minima low
#define fechamento close
#define corpo body
#define pavil wick
#define sombra_superior upperShadow
#define sombra_inferior lowerShadow
#define tamanho size
#define tendencia trend
#define tipo type
#define formato format

// Constant aliases
#define VELA_VERIFICA_QUANTIDADE CANDLES_TO_VERIFY