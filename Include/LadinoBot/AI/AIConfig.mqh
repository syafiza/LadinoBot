//+------------------------------------------------------------------+
//|                                                    AIConfig.mqh  |
//|                                        AI Configuration Settings |
//+------------------------------------------------------------------+
#property copyright "LadinoBot AI"
#property version   "1.00"

//+------------------------------------------------------------------+
//| AI Service Configuration                                         |
//+------------------------------------------------------------------+

// API Keys (configure these in input parameters or externally)
input string AI_API_KEY = "";                    // Your AI API key
input string AI_ENDPOINT = "https://api.example.com/v1";  // API endpoint
input int AI_CACHE_SECONDS = 300;                 // Cache duration (5 min default)
input double AI_CONFIDENCE_THRESHOLD = 0.3;       // Minimum confidence for AI signals

// Sentiment Analysis Settings
input bool USE_AI_SENTIMENT = false;              // Enable AI sentiment analysis
input bool AI_BLOCK_ON_CONFLICT = true;           // Block trade if AI conflicts with technical
input double AI_SENTIMENT_WEIGHT = 0.5;           // Weight of AI vs technical (0-1)

// Price Prediction Settings
input bool USE_AI_PREDICTION = false;             // Enable AI price predictions
input int AI_PREDICTION_BARS = 10;                // Predict N bars ahead

// API Provider Selection
enum ENUM_AI_PROVIDER {
   PROVIDER_ALPHA_VANTAGE,      // Alpha Vantage (free tier available)
   PROVIDER_NEWSAPI,            // NewsAPI.ai
   PROVIDER_OPENAI,             // OpenAI GPT
   PROVIDER_CUSTOM              // Custom endpoint
};

input ENUM_AI_PROVIDER AI_PROVIDER = PROVIDER_ALPHA_VANTAGE;

//+------------------------------------------------------------------+
//| Helper: Build API URL based on provider                         |
//+------------------------------------------------------------------+
string BuildSentimentURL(string symbol, ENUM_AI_PROVIDER provider) {
   switch(provider) {
      case PROVIDER_ALPHA_VANTAGE:
         return "https://www.alphavantage.co/query?function=NEWS_SENTIMENT&tickers=" + 
                symbol + "&apikey=" + AI_API_KEY;
      
      case PROVIDER_NEWSAPI:
         return "https://newsapi.ai/api/v1/article/getArticles?query=" + 
                symbol + "&apiKey=" + AI_API_KEY;
      
      case PROVIDER_OPENAI:
         return "https://api.openai.com/v1/chat/completions";
      
      case PROVIDER_CUSTOM:
         return AI_ENDPOINT + "/sentiment?symbol=" + symbol;
      
      default:
         return "";
   }
}
