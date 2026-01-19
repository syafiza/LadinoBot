//+------------------------------------------------------------------+
//|                                            SentimentAnalyzer.mqh |
//|                                   AI-powered sentiment analysis  |
//+------------------------------------------------------------------+
#property copyright "LadinoBot AI"
#property version   "1.00"

#include <LadinoBot/Utils.mqh>
#include <LadinoBot/AI/AIConfig.mqh>

//+------------------------------------------------------------------+
//| Sentiment Analysis Results                                       |
//+------------------------------------------------------------------+
struct SentimentResult {
   double score;           // -1.0 (bearish) to +1.0 (bullish)
   double confidence;      // 0.0 to 1.0
   datetime timestamp;
   string source;          // API provider name
   bool valid;
};

//+------------------------------------------------------------------+
//| AI Sentiment Analyzer Class                                      |
//+------------------------------------------------------------------+
class SentimentAnalyzer {
private:
   SentimentResult _cachedResult;
   string _lastSymbol;
   
   bool CallAPI(string url, string& response);
   double ParseAlphaVantage(string json);
   double ParseNewsAPI(string json);
   double ParseOpenAI(string json);
   
public:
   SentimentAnalyzer();
   
   // Get sentiment for symbol
   SentimentResult GetSentiment(string symbol);
   
   // Check if sentiment confirms technical signal
   bool ConfirmsSignal(ENUM_POSITION_SIGNAL technicalSignal, double threshold = 0.3);
   
   // Get human-readable sentiment description
   string GetSentimentDescription(double score);
};

//+------------------------------------------------------------------+
//| Constructor                                                       |
//+------------------------------------------------------------------+
SentimentAnalyzer::SentimentAnalyzer() {
   _cachedResult.valid = false;
   _cachedResult.score = 0.0;
   _cachedResult.confidence = 0.0;
   _cachedResult.timestamp = 0;
   _lastSymbol = "";
}

//+------------------------------------------------------------------+
//| Get Sentiment Score                                              |
//+------------------------------------------------------------------+
SentimentResult SentimentAnalyzer::GetSentiment(string symbol) {
   // Check cache validity
   if (_lastSymbol == symbol && 
       _cachedResult.valid && 
       (TimeCurrent() - _cachedResult.timestamp) < AI_CACHE_SECONDS) {
      return _cachedResult;
   }
   
   // Build API URL
   string url = BuildSentimentURL(symbol, AI_PROVIDER);
   if (url == "") {
      Print("AI: Invalid API configuration");
      _cachedResult.valid = false;
      return _cachedResult;
   }
   
   // Call API
   string response;
   if (!CallAPI(url, response)) {
      Print("AI: API call failed");
      _cachedResult.valid = false;
      return _cachedResult;
   }
   
   // Parse response based on provider
   double score = 0.0;
   switch(AI_PROVIDER) {
      case PROVIDER_ALPHA_VANTAGE:
         score = ParseAlphaVantage(response);
         break;
      case PROVIDER_NEWSAPI:
         score = ParseNewsAPI(response);
         break;
      case PROVIDER_OPENAI:
         score = ParseOpenAI(response);
         break;
      default:
         // For custom, assume simple JSON: {"sentiment": 0.75}
         int start = StringFind(response, "\"sentiment\":");
         if (start >= 0) {
            string sub = StringSubstr(response, start + 12);
            score = StringToDouble(sub);
         }
   }
   
   // Update cache
   _cachedResult.score = NormalizeDouble(score, 2);
   _cachedResult.confidence = 0.8;  // Could parse from API
   _cachedResult.timestamp = TimeCurrent();
   _cachedResult.source = EnumToString(AI_PROVIDER);
   _cachedResult.valid = true;
   _lastSymbol = symbol;
   
   return _cachedResult;
}

//+------------------------------------------------------------------+
//| Call External API                                                |
//+------------------------------------------------------------------+
bool SentimentAnalyzer::CallAPI(string url, string& response) {
   char data[], result[];
   string headers = "";
   
   // Add authorization header for OpenAI
   if (AI_PROVIDER == PROVIDER_OPENAI) {
      headers = "Content-Type: application/json\r\n";
      headers += "Authorization: Bearer " + AI_API_KEY + "\r\n";
   }
   
   int timeout = 5000;  // 5 second timeout
   int res = WebRequest("GET", url, headers, timeout, data, result, headers);
   
   if (res == 200) {
      response = CharArrayToString(result);
      return true;
   }
   
   Print("AI API Error: HTTP ", res);
   return false;
}

//+------------------------------------------------------------------+
//| Parse Alpha Vantage Response                                     |
//+------------------------------------------------------------------+
double SentimentAnalyzer::ParseAlphaVantage(string json) {
   // Alpha Vantage returns sentiment scores in feed array
   // Simplified parsing - extract average sentiment
   double totalSentiment = 0.0;
   int count = 0;
   
   int pos = 0;
   while (true) {
      pos = StringFind(json, "\"overall_sentiment_score\":", pos);
      if (pos < 0) break;
      
      string sub = StringSubstr(json, pos + 27, 10);
      double sentiment = StringToDouble(sub);
      totalSentiment += sentiment;
      count++;
      pos += 30;
      
      if (count >= 10) break;  // Limit to first 10 articles
   }
   
   return (count > 0) ? (totalSentiment / count) : 0.0;
}

//+------------------------------------------------------------------+
//| Parse NewsAPI Response                                           |
//+------------------------------------------------------------------+
double SentimentAnalyzer::ParseNewsAPI(string json) {
   // Simplified - would need proper JSON parser
   // For now, return neutral
   return 0.0;
}

//+------------------------------------------------------------------+
//| Parse OpenAI Response                                            |
//+------------------------------------------------------------------+
double SentimentAnalyzer::ParseOpenAI(string json) {
   // Extract sentiment from GPT response
   // Would need to parse JSON and extract content
   return 0.0;
}

//+------------------------------------------------------------------+
//| Check if AI confirms technical signal                            |
//+------------------------------------------------------------------+
bool SentimentAnalyzer::ConfirmsSignal(ENUM_POSITION_SIGNAL signal, double threshold = 0.3) {
   if (!USE_AI_SENTIMENT) return true;  // AI disabled, always confirm
   
   SentimentResult sentiment = GetSentiment(_Symbol);
   
   if (!sentiment.valid) {
      Print("AI: Invalid sentiment data, defaulting to confirm");
      return true;  // Failsafe: allow trade if AI unavailable
   }
   
   // Check alignment
   if (signal == SIGNAL_POSITION_BUY && sentiment.score < threshold) {
      Print("AI: Sentiment (", DoubleToString(sentiment.score, 2), 
            ") does not confirm BUY signal (threshold: ", DoubleToString(threshold, 2), ")");
      return false;
   }
   
   if (signal == SIGNAL_POSITION_SELL && sentiment.score > -threshold) {
      Print("AI: Sentiment (", DoubleToString(sentiment.score, 2), 
            ") does not confirm SELL signal (threshold: ", DoubleToString(threshold, 2), ")");
      return false;
   }
   
   Print("AI: Sentiment ", GetSentimentDescription(sentiment.score), " confirms ", 
         EnumToString(signal));
   return true;
}

//+------------------------------------------------------------------+
//| Get Human-Readable Sentiment                                     |
//+------------------------------------------------------------------+
string SentimentAnalyzer::GetSentimentDescription(double score) {
   if (score > 0.6) return "VERY BULLISH (" + DoubleToString(score, 2) + ")";
   if (score > 0.3) return "Bullish (" + DoubleToString(score, 2) + ")";
   if (score > -0.3) return "Neutral (" + DoubleToString(score, 2) + ")";
   if (score > -0.6) return "Bearish (" + DoubleToString(score, 2) + ")";
   return "VERY BEARISH (" + DoubleToString(score, 2) + ")";
}
