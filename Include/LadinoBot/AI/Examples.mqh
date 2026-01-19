//+------------------------------------------------------------------+
//|                                    Example: AI-Enhanced Trading  |
//|                        How to integrate AI into your strategy    |
//+------------------------------------------------------------------+

/*
   This file demonstrates how to use the AI sentiment analyzer
   in your LadinoBot trading logic.
*/

#include <LadinoBot/AI/SentimentAnalyzer.mqh>
#include <LadinoBot/LadinoBase.mqh>

//+------------------------------------------------------------------+
//| EXAMPLE 1: Simple AI Filter                                      |
//| Block trades when sentiment conflicts with technical signals     |
//+------------------------------------------------------------------+

class AIEnhancedBot : public LadinoBase {
private:
   SentimentAnalyzer* _aiSentiment;
   
public:
   AIEnhancedBot() {
      _aiSentiment = new SentimentAnalyzer();
   }
   
   ~AIEnhancedBot() {
      delete _aiSentiment;
   }
   
   virtual bool CheckEntry() {
      // Step 1: Get traditional technical signals
      bool technicalBuySignal = /* your HiLo/SR logic */ false;
      bool technicalSellSignal = /* your HiLo/SR logic */ false;
      
      // Step 2: Determine signal direction
      ENUM_POSITION_SIGNAL signal = SIGNAL_POSITION_NONE;
      if (technicalBuySignal) signal = SIGNAL_POSITION_BUY;
      if (technicalSellSignal) signal = SIGNAL_POSITION_SELL;
      
      if (signal == SIGNAL_POSITION_NONE) return false;
      
      // Step 3: AI confirmation
      if (!_aiSentiment.ConfirmsSignal(signal, AI_CONFIDENCE_THRESHOLD)) {
         if (AI_BLOCK_ON_CONFLICT) {
            Print("AI blocked trade due to sentiment conflict");
            return false;  // Block trade
         }
      }
      
      // Step 4: Execute trade
      return true;  // Proceed with entry
   }
};

//+------------------------------------------------------------------+
//| EXAMPLE 2: Weighted Signal Combination                           |
//| Combine technical and AI scores                                  |
//+------------------------------------------------------------------+

double GetCombinedSignalStrength(double technicalScore, double aiSentiment) {
   // technicalScore: 0-1 (strength of HiLo/SR signal)
   // aiSentiment: -1 to +1
   
   double combined = (technicalScore * (1 - AI_SENTIMENT_WEIGHT)) + 
                     (MathAbs(aiSentiment) * AI_SENTIMENT_WEIGHT);
   
   return combined;  // Result: 0-1 combined strength
}

//+------------------------------------------------------------------+
//| EXAMPLE 3: Manual Testing                                        |
//| Call this from OnInit() to test AI connectivity                  |
//+------------------------------------------------------------------+

void TestAISentiment() {
   SentimentAnalyzer testAI;
   
   Print("=== Testing AI Sentiment Analyzer ===");
   
   SentimentResult result = testAI.GetSentiment(_Symbol);
   
   if (result.valid) {
      Print("✓ AI API connected successfully");
      Print("  Symbol: ", _Symbol);
      Print("  Sentiment: ", testAI.GetSentimentDescription(result.score));
      Print("  Confidence: ", DoubleToString(result.confidence * 100, 1), "%");
      Print("  Source: ", result.source);
   } else {
      Print("✗ AI API connection failed");
      Print("  Check your API_KEY and internet connection");
   }
}

/*
=============================================================================
USAGE INSTRUCTIONS:
=============================================================================

1. GET API KEY:
   - Go to https://www.alphavantage.co/support/#api-key
   - Sign up for free API key
   - Copy your key

2. CONFIGURE IN MT5:
   - Open LadinoBot properties
   - Set AI_API_KEY = "your_key_here"
   - Set USE_AI_SENTIMENT = true
   - Set AI_CONFIDENCE_THRESHOLD = 0.3 (adjust as needed)

3. TEST:
   - Add TestAISentiment() to your OnInit()
   - Check Expert log for successful connection

4. DEPLOY:
   - Backtest with AI enabled vs disabled
   - Compare win rates and drawdowns
   - Adjust AI_SENTIMENT_WEIGHT based on results

=============================================================================
TROUBLESHOOTING:
=============================================================================

- "AI API connection failed": Check internet, API key, firewall
- "AI API Error: HTTP 429": Rate limited, increase AI_CACHE_SECONDS
- Sentiment always 0.0: Check symbol format (e.g., "EURUSD" vs "EUR/USD")

=============================================================================
*/
